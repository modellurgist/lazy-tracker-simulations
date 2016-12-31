class FullKeypad
  def self.run_simulations(number_list)
    variants = [
      self.new("user must enter decimal point", number_list, require_decimal_point: false),
      self.new("user skips decimal point", number_list)
    ]
    variants.each(&:simulate)
    variants
  end

  attr_reader :variant_description,
              :total_clicks,
              :estimated_sum,
              :actual_sum

  def initialize(variant_description, number_list, options = {})
    @numbers = number_list.numbers
    @actual_sum = number_list.tally
    @variant_description = variant_description
    @options = options
  end

  def simulate
    @estimated_sum = @actual_sum
    @total_clicks = @numbers.map {|number| digits(number, @options) }.reduce(&:+)
  end

  private

  def digits(number, require_decimal_point: true)
    string =
      if require_decimal_point
        number.to_s
      else
        number.to_s.delete(".")
      end
    string.size
  end
end
