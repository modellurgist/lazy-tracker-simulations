class FullKeypad
  def initialize(number_list)
    @numbers = number_list.numbers
    @actual_sum = number_list.tally
  end

  def simulate(require_decimal_point: true)
    @estimated_sum = @actual_sum
    @total_clicks = @numbers.map {|number| digits(number, require_decimal_point) }.reduce(&:+)
  end

  def total_clicks
    @total_clicks
  end

  def estimated_sum
    @estimated_sum
  end

  private

  def digits(number, require_decimal_point)
    string =
      if require_decimal_point
        number.to_s
      else
        number.to_s.delete(".")
      end
    string.size
  end
end
