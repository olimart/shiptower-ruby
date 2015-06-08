# shiptower Ruby bindings
require "cgi"
require "set"
require "openssl"
require "json"
require "net/http"
require "uri"

# Version
require "shiptower/version"

# API operations
require "shiptower/api_operations/create"

# Resources
require "shiptower/shiptower_object"
require "shiptower/api_resource"
require "shiptower/order"

# Errors
require "shiptower/errors/shiptower_error"
require "shiptower/errors/api_error"
require "shiptower/errors/api_connection_error"
require "shiptower/errors/invalid_request_error"
require "shiptower/errors/authentication_error"

module Shiptower
  @api_base = "https://shiptower.herokuapp.com/api"

  class << self
    attr_accessor :token, :api_base, :verify_ssl_certs, :api_version
  end

  def self.api_url(url="")
    @api_base + url
  end

  def self.request(method, url, token, params={}, headers={})
    unless token ||= @token
      raise AuthenticationError.new("No token provided")
    end

    url = api_url(url)

    begin

      uri = URI(url)
      request = Net::HTTP::Post.new(uri) if method == :post

      request["User-Agent"]    = "shiptower-ruby gem"
      request["Authorization"] = "Token token=\"#{token}\""
      request["Content-Type"]  = "application/json"
      request.body = params.to_json

      http = Net::HTTP.new(uri.hostname, uri.port)

      # see http://www.rubyinside.com/how-to-cure-nethttps-risky-default-https-behavior-4010.html
      # for info about ssl verification

      http.use_ssl = true if uri.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri.scheme == "https"

      response = http.start {|h|
        h.request(request)
      }

      # since http.request doesn't throw such exceptions, check them by status codes
      handle_api_error(response.code, response.body)

    rescue SocketError => e
      handle_connection_error(e)
    rescue NoMethodError => e
      handle_connection_error(e)
    rescue OpenSSL::SSL::SSLError => e
      handle_connection_error(e)
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH => e
      handle_connection_error(e)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      handle_connection_error(e)
    end

    [response, token]
  end

  def self.handle_connection_error(e)
    case e
      when SocketError
        message = "Unexpected error when trying to connect to Shiptower"
      when NoMethodError
        message = "Unexpected HTTP response code"
      else
        message = "Unexpected error communicating with Shiptower"
    end

    raise APIConnectionError.new(message + "\n\n(Network error: #{e.message})")
  end

  def self.handle_api_error(rcode, rbody)
    begin
      error_obj = JSON.parse(rbody)
    rescue JSON::ParserError
      raise general_api_error(rcode, rbody)
    end

    case rcode
      when 400, 404, 422
        raise invalid_request_error error, rcode, rbody, error_obj
      when 401
        raise authentication_error error, rcode, rbody, error_obj
      when 500
        raise api_error error, rcode, rbody, error_obj
      else
        # raise api_error error, rcode, rbody, error_obj
    end

  end

  def self.invalid_request_error(error, rcode, rbody, error_obj)
    InvalidRequestError.new(error[:message], error[:param], rcode,
                            rbody, error_obj)
  end

  def self.authentication_error(error, rcode, rbody, error_obj)
    AuthenticationError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.api_error(error, rcode, rbody, error_obj)
    APIError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.general_api_error(rcode, rbody)
    APIError.new("Invalid response object from API: #{rbody.inspect} " +
                 "(HTTP response code was #{rcode})", rcode, rbody)
  end
end
