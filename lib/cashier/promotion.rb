# Public: Wrapper over promoting information. Strategy should be duck
# typing on `call` method.
class Promotion
  attr_reader :strategy, :apply_to, :priority

  def initialize(strategy, apply_to: [], priority: 0)
    @strategy    = strategy
    @apply_to    = apply_to
    @priority    = priority
  end

  def can_apply_to?(item)
    apply_to.include?(item.bar_code)
  end

  def calculate(item, number)
    strategy.call(item, number)
  end
end
