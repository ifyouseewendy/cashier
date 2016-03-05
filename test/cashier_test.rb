require 'test_helper'

class CashierTest < Minitest::Test
  attr_reader :cashier

  def setup
    shop = Shop.new('没钱赚商店', File.open('test/fixtures/inventory.yml'))
    @cashier = Cashier.new(shop)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Cashier::VERSION
  end

  def test_no_promotion
    expected = <<-BILL
***<没钱赚商店>购物清单***
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
----------------------
总计：25.00(元)
**********************
    BILL
    assert_equal expected.chop, cashier.print(json)
  end

  def test_promote_by_count
    cashier.add_promotion PromoteByCount.new('买二赠一'), apply_to: ['ITEM000001', 'ITEM000005'], priority: 1

    expected = <<-BILL
***<没钱赚商店>购物清单***
名称：羽毛球，数量：5个，单价：1.00(元)，小计：4.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：11.00(元)
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元)
----------------------
买二赠一商品：
名称：羽毛球，数量：1个
名称：可口可乐，数量：1瓶
----------------------
总计：21.00(元)
节省：4.00(元)
**********************
    BILL

    assert_equal expected.chop, cashier.print(json)
  end

  def test_promote_by_discount
    cashier.add_promotion PromoteByDiscount.new('95折'), apply_to: ['ITEM000003']

    expected = <<-BILL
***<没钱赚商店>购物清单***
名称：羽毛球，数量：5个，单价：1.00(元)，小计：5.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：9.00(元)
----------------------
总计：24.45(元)
节省：0.55(元)
**********************
    BILL

    assert_equal expected.chop, cashier.print(json)
  end

  def test_promote_by_both
    cashier.add_promotion PromoteByCount.new('买二赠一'),  apply_to: ['ITEM000001', 'ITEM000005'], priority: 1
    cashier.add_promotion PromoteByDiscount.new('95折'),   apply_to: ['ITEM000003', 'ITEM000005']

    expected = <<-BILL
***<没钱赚商店>购物清单***
名称：羽毛球，数量：5个，单价：1.00(元)，小计：4.00(元)
名称：苹果，数量：2斤，单价：5.50(元)，小计：10.45(元)，节省0.55(元)
名称：可口可乐，数量：3瓶，单价：3.00(元)，小计：6.00(元)
----------------------
买二赠一商品：
名称：羽毛球，数量：1个
名称：可口可乐，数量：1瓶
----------------------
总计：20.45(元)
节省：4.55(元)
**********************
    BILL

    assert_equal expected.chop, cashier.print(json)
  end

  private

    def json
      @_json ||= JSON.dump \
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
    end
end

