# Cashier

A simulated cash machine, only support scan and print right now.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cashier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cashier

## Usage

Initialize and configure

```ruby
cashier = Cashier.new '没钱赚商店', File.open('inventory.yml')

cashier.configure do |config|
  config.add_promotion PromoteByCount.new('买二赠一'),  apply_to: ['ITEM000001', 'ITEM000003'], priority: 1
  config.add_promotion PromoteByDiscount.new('95折'),   apply_to: ['ITEM000005']
end
```

Scan items

```ruby
cashier.scan 'ITEM000001'
cashier.scan 'ITEM000001'
cashier.scan 'ITEM000001'
cashier.scan 'ITEM000001'
cashier.scan 'ITEM000001'
cashier.scan 'ITEM000003', count: 2
cashier.scan 'ITEM000005'
cashier.scan 'ITEM000005'
cashier.scan 'ITEM000005'
```

Print

```ruby
cashier.print
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cashier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

