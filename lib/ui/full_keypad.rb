require_relative '../../lib/money'

class FullKeypad
  def self.run_simulations(number_list)
    variants = [
      self.new(number_list, omit_decimal_point: true),
      self.new(number_list),
      self.new(number_list, omit_cents: true)
    ]
    variants.each(&:simulate)
    variants
  end

  attr_reader :actual_sum,
              :estimated_sum,
              :options,
              :total_clicks

  def initialize(number_list, options = {})
    @numbers = number_list.numbers
    @actual_sum = number_list.sum
    @options = options
  end

  def simulate
    parsed_monies = @numbers.map {|number| parsed_money(number, @options) }
    monies = parsed_monies.map {|parsed_money| parsed_money[:money]}

    @estimated_sum = Money.sum(monies)
    @total_clicks = parsed_monies.map {|parsed_money| parsed_money[:input_string].size }.reduce(&:+)
  end

  private

  def parsed_money(number, omit_decimal_point: false, omit_cents: false)
    money = Money.build(number)

    if omit_decimal_point
      {
        input_string: "#{money.integer_string}#{money.decimal_string}",
        money: money
      }
    elsif omit_cents
      {
        input_string: money.integer_string,
        money: Money.build(money.integer_string)
      }
    else
      {
        input_string: number.to_s,
        money: money
      }
    end
  end
end
