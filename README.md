# Slimpay

Ruby implementation of the Slimpay Hypermedia API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slimpay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slimpay

## Usage

**API Docs: https://api-sandbox.slimpay.net/docs/**

**SANDBOX CREDENTIALS :**

* client_id =  'democreditor01'
* client_secret = 'demosecret01'
* creditor_reference : democreditor

### Available resources :
**Order**, **Mandate**, **App**

Each resource defines its own methods according to the Slimpay API.

**Example:**

```zsh
Slimpay::Order.new.api_methods
=> ["get_order", "patch_order", "create_orders", "get_orders"]
```

Some methods as been added in this gem as shortcuts to these.

**Example:**

The official API method:

```ruby
orders = Slimpay::Order.new(client_id = '1234', client_secret = '987654321', creditor_reference = 'azerty')
orders.get_orders({creditorReference: @creditor_reference, reference: 1234})
```

The shortcut:

```ruby
orders = Slimpay::Order.new(client_id = '1234', client_secret = '987654321', creditor_reference = 'azerty')
orders.get_one(1234)
```

### Root endpoint resources:

```ruby
slimpay = Slimpay::Base.new(client_id = '1234', client_secret = '987654321', creditor_reference = 'azerty')
slimpay.api_methods
```
:warning: If you call ```Slimpay::Base.new``` without arguments, the _Sandbox_ credentials will be used.

### Get a specific Order
If your Order as a reference key = 1234

```ruby
orders = Slimpay::Order.new
orders.get_one(1234)
```

result will be a Hash:

```json
{"_links"=>
  {"self"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1"},
   "https://api.slimpay.net/alps#get-creditor"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor"},
   "https://api.slimpay.net/alps#get-subscriber"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1/subscribers/subscriber01"},
   "https://api.slimpay.net/alps#user-approval"=>{"href"=>"https://slimpay.net/slimpaytpe16/userApproval?accessCode=spK534N0cuZztBGwj2FjC6eKzcsKFRzXbfy8buloUHiZV6p9PhIfcPgV7c507R"},
   "https://api.slimpay.net/alps#get-order-items"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/orders/1/items"},
   "https://api.slimpay.net/alps#get-mandate"=>{"href"=>"https://api-sandbox.slimpay.net/creditors/democreditor/mandates/1"}},
 "reference"=>"1",
 "state"=>"closed.completed",
 "started"=>true,
 "dateCreated"=>"2014-12-12T09:35:39.000+0000",
 "mandateReused"=>false}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gdurelle/slimpay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

