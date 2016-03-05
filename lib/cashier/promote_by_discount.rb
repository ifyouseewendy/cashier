class PromoteByDiscount
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def call(item, count)
    prime_cost   = (item.price * count).round(2)
    promote_cost = (item.price * count * 0.95).round(2)
    save         = (prime_cost - promote_cost).round(2)

    header = sprintf(
      "名称：%s，数量：%d%s，单价：%.2f(元)，小计：%.2f(元)，节省%.2f(元)",
      item.name,
      count,
      item.unit,
      item.price,
      promote_cost,
      save
    )

    {
      cost: promote_cost,
      save: save,
      header: header,
      append: nil
    }
  end
end
