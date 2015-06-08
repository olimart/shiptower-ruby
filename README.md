# Shiptower

[![Build Status](https://semaphoreci.com/api/v1/projects/6d21d520-222b-4cf3-9f8c-18042f869cf1/446455/badge.svg)](https://semaphoreci.com/yafoy/shiptower-ruby)

Simple ruby gem for communicating with external API. Heavily inspired by stripe gem.

## Installation

Add this line to your application's Gemfile:

    gem 'shiptower'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shiptower

## Usage

1) Set Shiptower token in your app.

```ruby
Shiptower.token = ENV['SHIPTOWER_TOKEN']
```

2) Send order

```ruby
Shiptower::Order.create(
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
```

**For Sinatra app** you may need to add `require 'bundler/setup'`

## Tests

```ruby
rake test
```
