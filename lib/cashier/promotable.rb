# Public: Several methods for base klass to enable promoting.
module Promotable
  def self.included(klass)
    klass.class_eval do
      attr_accessor :promotions
    end
  end

  def add_promotion(strategy, option)
    @promotions ||= []
    @promotions << Promotion.new(strategy, **option)
  end

  # Public: Find the best promotion for item. Default by no promotion.
  def promotion_for(item)
    @promotions ||= []
    @promotions.sort_by(&:priority).reverse.detect{|pr| pr.can_apply_to?(item)}\
      || Promotion.new( NoPromote.new )
  end

  def calculate(item, count)
    promotion_for(item).calculate(item, count)
  end
end
