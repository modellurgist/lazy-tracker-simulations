require_relative '../lib/money'
require_relative '../lib/number_list'
require_relative '../lib/ui/full_keypad.rb'

number_list = NumberList.build("input_examples/2016-01-food-outside-pinch.csv")

  # need generic way to run through variants
  # - round to dime
  # - round to 50 cents
  # - round to dollar
  # - round to 2 dollars
  # - round to 5 dollars
  # - round to 10 dollars
  # - round to 20 dollars
  # - round to 100 dollars
  # - fibonacci
  # - base-2: 1, 2, 4, 8, 16, 32, 128, etc.
  # - only if the above 2 show promise:
  # - geometric / arithmetic series
  # - other series (natural?)
  # - other series

# partial keypad simulations

# full keypad simulations
simulations = FullKeypad.run_simulations(number_list)

def report_simulations_run(simulations)
  simulations.each do |sim|
    deviation = (sim.actual_sum - sim.estimated_sum).abs

    puts
    puts sim.class.to_s
    #puts sim.variant_description
    puts sim.options.inspect
    puts "total_clicks: #{sim.total_clicks}"
    puts "actual sum: #{sim.actual_sum}"
    puts "estimated sum: #{sim.estimated_sum}"
    puts "absolute deviation: #{deviation}"
    puts "fraction deviation: #{deviation / sim.actual_sum}"
  end
end

report_simulations_run(simulations)

# summary analysis of each variant (Full Keypad, with decimal point)
labels = ["Granularity", "Total Clicks", "Fraction Deviation", "Absolute Deviation", "Actual Total", "Estimated Total", "Number of Values", "Average Value", "Value Range Width"]

module Approximation
  class NearestIncrement
    # Ex: 0.1, 1, 2, 20
    def initialize(increment)
      @increment = increment
    end

    def round(number, include_decimal: true)
      number_of_multiples = (number / @increment).round
      # look at number of multiples (relates to click count)
      approximation = number_of_multiples * @increment
      money = Money.build(approximation)
      include_decimal ? money.to_f : money.integer
    end
  end
end

puts "original data"
p number_list.numbers
puts

[0.1, 0.5, 1, 2, 5, 10, 20, 100].map do |smallest_increment|
  include_decimal = smallest_increment < 1.0
  approximation = Approximation::NearestIncrement.new(smallest_increment)
  approximate_numbers = number_list.numbers.map do |number|
    approximation.round(number, include_decimal: include_decimal)
  end

  approximate_number_list = NumberList.new(approximate_numbers.map(&:to_s))
  simulations = FullKeypad.run_simulations(approximate_number_list)
  report_simulations_run(simulations)
  #puts "#{smallest_increment}:  "
  #print approximate_numbers.inspect
  #puts
end

# summary across variants

  # CSV generator for graphing
