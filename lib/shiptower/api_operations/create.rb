module Shiptower
  module APIOperations
    module Create
      module ClassMethods

        # Shiptower::Order.create
        def create(params={}, token=nil)
          # puts params
          # puts "**** #{params[:order][:billing_address]}"
          # puts "**** #{params[:order][:billing_address]}" if params[:order].has_key?(:billing_address)

          # reformat params hash
          # wrap under order hash to accomodate strong params
          params = { order: params }

          # reformat nested attributes as per rails strong params expectations
          params[:order][:client_attributes] = params[:order].delete(:client) if params[:order].has_key?(:client)
          params[:order][:billing_address_attributes] = params[:order].delete(:billing_address) if params[:order].has_key?(:billing_address)
          params[:order][:shipping_address_attributes] = params[:order].delete(:shipping_address) if params[:order].has_key?(:shipping_address)

          response, token = Shiptower.request(:post, self.url, token, params)
          response
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
