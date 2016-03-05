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
shop = Shop.new('没钱赚商店', File.new('inventory.yml'))
cashier = Cashier.new(shop)

cashier.add_promotion PromoteByCount.new('买二赠一'),  apply_to: ['ITEM000001', 'ITEM000005'], priority: 1
cashier.add_promotion PromoteByDiscount.new('95折'),   apply_to: ['ITEM000003']
```

Print

```ruby
data = JSON.dump \
  [
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000001",
    "ITEM000003-2",
    "ITEM000005",
    "ITEM000005",
    "ITEM000005"
  ]
cashier.print(data)
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

