require 'shiptower'
require 'test/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'shoulda'

class Setup
  def setup
    Shiptower.token = "111"
    Shiptower.api_base = "http://localhost:5000/api"
  end

  def teardown
    Shiptower.token = nil
    Shiptower.api_base = nil
  end
end
