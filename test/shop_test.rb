require 'test_helper'

class ShopTest < Minitest::Test
  attr_reader :shop

  def setup
    @shop = Shop.new '没钱赚商店', File.new('test/fixtures/inventory.yml')
  end

  def test_initialize
    assert_equal        '没钱赚商店', shop.name
    assert_equal        3,            shop.inventory.count
    assert_instance_of  Item,         shop.inventory.first
  end

  def test_find_item
    assert_nil shop.find_item('ITEM000000')
    assert_equal '羽毛球', shop.find_item('ITEM000001').name
  end
end
