require 'csv'

class NumberList
  # l = NumberList.new("input_examples/2016-01-food-outside-pinch.csv")
  def initialize(input_filepath)
    rows = CSV.read(input_filepath)
    @numbers = rows.first.map(&:to_f)
  end

  def numbers
    @numbers
  end

  def tally
    @numbers.reduce(&:+)
  end
end
