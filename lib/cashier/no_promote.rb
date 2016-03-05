class NoPromote
  def call(item, count)
    cost = (item.price * count).round(2)

    header = sprintf("名称：%s，数量：%d%s，单价：%.2f(元)，小计：%.2f(元)", item.name, count, item.unit, item.price, cost)

    {
      cost: cost,
      save: 0,
      header: header,
      append: nil
    }
  end
end
