require "json"
require "cashier/version"
require "cashier/shop"
require "cashier/item"
require "cashier/promotable"
require "cashier/promotion"
require "cashier/no_promote"
require "cashier/promote_by_count"
require "cashier/promote_by_discount"

class Cashier
  include Promotable

  attr_reader :shop
  attr_accessor :buffer

  def initialize(shop)
    @shop = shop
    @buffer = Buffer.new([], [], Hash.new{|h,k| h[k] = [] })
  end

  def print(json)
    counter = aggregate_from(json)

    buffer.headers << "***<#{shop.name}>购物清单***"

    total_cost, total_save = [0]*2

    counter.each do |bar_code, count|
      item = shop.find_item(bar_code)
      info = calculate(item, count)

      total_cost += info[:cost]
      total_save += info[:save]

      buffer.headers << info[:header]

      append = info[:append]
      buffer.additions[append[:name]] << append[:detail] unless append.nil?
    end

    buffer.footers << ("总计：%.2f(元)" % total_cost)
    buffer.footers << ("节省：%.2f(元)" % total_save) unless total_save.zero?
    buffer.footers << "**********************"

    buffer.print
  end

  private

    Buffer = Struct.new(:headers, :footers, :additions) do
      def print
        header = headers.join("\n")

        addition = additions.reduce([]) { |ar, (k,v)|
          ar << (["#{k}商品："] + v).join("\n")
        }.join("\n")

        footer = footers.join("\n")

        [header, addition, footer]
          .reject(&:empty?)
          .join("\n----------------------\n")
      end
    end

    def aggregate_from(json)
      JSON.parse(json).reduce(Hash.new(0)) do |ret, code|
        parts    = code.split('-')
        bar_code = parts[0]
        count    = parts[1].nil? ? 1 : parts[1].to_i

        ret[bar_code] += count
        ret
      end
    end
end
