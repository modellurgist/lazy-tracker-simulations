require_relative '../../lib/money'
require_relative '../../lib/approximation/nearest_increment'

# TODO: begin with the end in mind: what graphs to analyze, questions to answer
#  - how precise today, to be precise enough at end of month (non-adaptive, then later adaptive) -- each valid input set should have a fixed bounded error %
#  - trade-off between clicks and precision
#  - larger question:  how much error can/should someone tolerate in their end-of-month numbers?
#    - what is goal?  get expenses under control or know them exactly?
#
# NOTE: precision of input is independent of input interface type!  (that's great, so can decide precision first, and optimize for additional click savings second)

# - anything other than full keypad is to optimize clicks
# - otherwise, the variants here are sufficient to choose input strings for estimates and calculate precision of the sum of them
# - just need to generate reasonable, representative ranges to try simulations on
class FullKeypad
  def self.run_simulations(number_list, approximated_number_list)
    variants = [
      # variant: don't enter trailing zeros (decimal and/or integer)
      #self.new(number_list, omit_decimal_point: true)#,
      self.new(number_list, approximated_number_list)
    ]
    variants.each(&:simulate)
    variants
  end

  attr_reader :actual_sum,
              :estimated_sum,
              :total_clicks

  def initialize(number_list, approximated_number_list, omit_decimal_point: false)
    @number_list = number_list
    @actual_numbers = number_list.numbers
    @actual_sum = number_list.sum

    @approximated_number_list = approximated_number_list
    @approximated_numbers = approximated_number_list.numbers

    @omit_decimal_point = omit_decimal_point
  end

  def options
    {
      omit_decimal_point: @omit_decimal_point
    }
  end

  def simulate
    parsed_monies = @approximated_numbers.map {|number| parsed_money(number) }
    monies = parsed_monies.map {|parsed_money| parsed_money[:money]}
    @estimated_sum = Money.sum(monies)

    @total_clicks = parsed_monies.map {|parsed_money| parsed_money[:input_string].size }.reduce(&:+)
  end

  private

  def parsed_money(number)
    money = Money.build(number)

    if @omit_decimal_point
      {
        input_string: "#{money.integer_string}#{money.decimal_string}",
        money: money
      }
    else
      {
        input_string: number.to_s,
        money: money
      }
    end
  end
end
