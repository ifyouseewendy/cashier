class PromoteByCount
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def call(item, count)
    prime_cost   = (item.price * count).round(2)
    save_count   = count / 3
    promote_cost = (item.price * (count-save_count)).round(2)
    save         = (prime_cost - promote_cost).round(2)

    header = sprintf(
      "名称：%s，数量：%d%s，单价：%.2f(元)，小计：%.2f(元)",
      item.name,
      count,
      item.unit,
      item.price,
      promote_cost
    )

    if save_count > 0
      append = {
        name: name,
        detail: "名称：#{item.name}，数量：#{save_count}#{item.unit}"
      }
    else
      append = nil
    end

    {
      cost: promote_cost,
      save: save,
      print: {
        header: header,
        append: append
      }
    }
  end
end
