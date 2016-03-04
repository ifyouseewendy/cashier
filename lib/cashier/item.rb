class Item
  ATTRIBUTE = %i(name price unit category bar_code)

  attr_accessor *ATTRIBUTE

  def initialize(attr)
    validate! attr

    attr.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  private

    def validate!(attr)
      keys = attr.keys.map(&:to_sym)

      unless (invalid_keys = keys - ATTRIBUTE).empty?
        raise "Invalid attribute for Item: #{invalid_keys}"
      end
    end
end
