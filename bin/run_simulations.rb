require_relative '../lib/money'
require_relative '../lib/number_list'
require_relative '../lib/ui/full_keypad'
require_relative '../lib/approximation/nearest_increment'


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

def report_simulations_run(simulations)
  simulations.each do |sim|
    puts
    puts sim.class.to_s
    #puts sim.variant_description
    puts sim.options.inspect
    puts "total_clicks: #{sim.total_clicks}"
    puts "actual sum: #{sim.actual_sum}"
    puts "estimated sum: #{sim.estimated_sum}"
    puts "absolute deviation: #{sim.absolute_deviation}"
    puts "fraction deviation: #{sim.fraction_deviation}"
  end
end

puts
puts

# summary analysis of each variant (Full Keypad, with decimal point)

def build_approximate_numbers(number_list, smallest_increment)
  approximation = Approximation::NearestIncrement.new(smallest_increment)
  include_decimal = smallest_increment < 1.0

  number_list.numbers.map do |number|
    approximation.round(number, include_decimal: include_decimal)
  end
end

def report_approximation(simulations)
  puts
  puts
  puts "#{smallest_increment}:  "
  print approximate_numbers.inspect
  puts
  report_simulations_run(simulations)
end

def summarize_results(simulation)
  [
    simulation.smallest_approximation_increment,
    simulation.total_clicks,
    simulation.fraction_deviation,
    simulation.absolute_deviation,
    simulation.actual_sum,
    simulation.estimated_sum
    # number values
    # average value
    # value range width
  ]
end

def export_results(report_folder, simulations)
  timestamp = Time.now.to_i
  report_path = "#{report_folder}/#{timestamp}-lazy-tracker-simulations.csv"

  labels = ["Smallest Increment", "Total Clicks", "Fraction Deviation", "Absolute Deviation", "Actual Total", "Estimated Total", "Number of Values", "Average Value", "Value Range Width"]

  CSV.open(report_path, "wb") do |csv|
    csv << labels

    simulations.each do |simulation|
      csv << summarize_results(simulation)
    end
  end
end

number_lists = NumberList.build("input_examples/2016-01-food-outside-pinch.csv")

simulations = number_lists.map do |number_list|
  [0.01, 0.1, 0.5, 1, 2, 5, 10, 20, 100].map do |smallest_increment|
    approximate_numbers = build_approximate_numbers(number_list, smallest_increment)
    approximate_number_list = NumberList.new(approximate_numbers.map(&:to_s))

    simulations = FullKeypad.run_simulations(number_list, approximate_number_list)
    simulations.first
  end
end.flatten

export_results("reports/", simulations)

#report_approximation(smallest_increment, number_list, simulations)

# summary across variants
