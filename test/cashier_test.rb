require 'test_helper'

class CashierTest < Minitest::Test
  attr_reader :cashier

  def setup
    @cashier = Cashier.new '没钱赚商店', File.open('test/fixtures/inventory.yml')
  end

  def test_that_it_has_a_version_number
    refute_nil ::Cashier::VERSION
  end

  def test_no_promotion
    scan

    assert_equal cashier.print, <<-BILL
      ***<没钱赚商店>购物清单***
      名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
      名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
      名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
      ----------------------
      总计：25.00(元)
      **********************
    BILL
  end

  def test_promote_by_count
    cashier.configure do |config|
      config.add_promotion PromoteByCount.new('买二赠一'), apply_to: ['ITEM000001', 'ITEM000003'], priority: 1
    end

    scan

    assert_equal cashier.print, <<-BILL
      ***<没钱赚商店>购物清单***
      名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元)
      名称：羽毛球，数量：5个，单价：1.00(元)，小计：4.00(元)
      名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
      ----------------------
      买二赠一商品：
      名称：可口可乐，数量：1瓶
      名称：羽毛球，数量：1个
      ----------------------
      总计：21.00(元)
      节省：4.00(元)
      **********************
    BILL
  end

  def test_promote_by_discount
    cashier.configure do |config|
      config.add_promotion PromoteByDiscount.new('95折'), apply_to: ['ITEM000005']
    end

    scan

    assert_equal cashier.print, <<-BILL
      ***<没钱赚商店>购物清单***
      名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
      名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
      名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
      ----------------------
      总计：24.45(元)
      节省：0.55(元)
      **********************
    BILL
  end

  def test_promote_by_both
    cashier.configure do |config|
      config.add_promotion PromoteByCount.new('买二赠一'),  apply_to: ['ITEM000001', 'ITEM000003'], priority: 1
      config.add_promotion PromoteByDiscount.new('95折'),      apply_to: ['ITEM000005']
    end

    scan

    assert_equal cashier.print, <<-BILL
      ***<没钱赚商店>购物清单***
      名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元)
      名称：羽毛球，数量：6个，单价：1.00(元)，小计：4.00(元)
      名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
      ----------------------
      买二赠一商品：
      名称：可口可乐，数量：1瓶
      名称：羽毛球，数量：2个
      ----------------------
      总计：20.45(元)
      节省：5.55(元)
      **********************
    BILL
  end

  private

    def scan
      cashier.scan \
        [
          'ITEM000001',
          'ITEM000001',
          'ITEM000001',
          'ITEM000001',
          'ITEM000001',
          'ITEM000003-2',
          'ITEM000005',
          'ITEM000005',
          'ITEM000005'
        ]
    end
end
