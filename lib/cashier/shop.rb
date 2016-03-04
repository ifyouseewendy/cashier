require 'yaml'

class Shop
  attr_reader :name, :inventory

  def initialize(name, io)
    @name = name
    set_inventory(io)
  end

  def find_item(bar_code)
    inventory.detect { |item| item.bar_code == bar_code }
  end

  private

    def set_inventory(io)
      @inventory = ::YAML.load(io.read).reduce([]) do |ar, attr|
        ar << Item.new(attr)
      end
    end
end
