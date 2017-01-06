require 'csv'

class NumberList
  attr_reader :numbers,
              :number_strings

  # l = NumberList.build("input_examples/2016-01-food-outside-pinch.csv")
  def self.build(input_filepath)
    rows = CSV.read(input_filepath)
    new(rows.first)
  end

  def initialize(number_strings)
    @number_strings = number_strings
    @numbers = @number_strings.map(&:to_f)
  end

  def sum
    @numbers.reduce(&:+)
  end
end
