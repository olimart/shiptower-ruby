require File.expand_path("../../test_helper", __FILE__)

module Shiptower
  class OrderTest < Minitest::Test
    should 'create should return status 200' do
      Shiptower.token = '111'
      Shiptower.api_base = "http://localhost:5000/api"
      response = Shiptower::Order.create(
                  status: 'confirmed',
                  notes: 'order 1234',
                  client: {
                    name: 'ACME widget',
                    contact_name: 'John',
                    phone: '3368 505 9884',
                    email: 'j@email.com'
                  },
                  billing_address: {
                    full_name: 'ACME widget',
                    street: '18 rue de la rue',
                    street2: 'Suite ABC',
                    postal_code: '1A1A1A',
                    city: 'MyTown',
                    country: 'CA'
                  },
                  shipping_address: {
                    full_name: 'ACME widget',
                    street: '18 rue de la rue',
                    street2: 'Suite ABC',
                    postal_code: '1A1A1A',
                    city: 'MyTown',
                    country: 'CA'
                  },
                  items: [
                    {
                      quantity: 1,
                      product_sku: "823-78-7978",
                      price: "21.5"
                    },
                    {
                      quantity: 2,
                      product_sku: "048-98-2408"
                    }
                  ]
                )
      assert_equal '200', response.code
    end

    should 'raise Shiptower::AuthenticationError if no token provided' do
      Shiptower.token = nil
      assert_raises(Shiptower::AuthenticationError) { Shiptower::Order.create }
    end

    should 'raise Shiptower::InvalidRequestError if not enough parameters' do
      begin
      rescue JSON::ParserError
        assert_raises(Shiptower::InvalidRequestError) { Shiptower::Order.create }
      end
    end
  end
end
