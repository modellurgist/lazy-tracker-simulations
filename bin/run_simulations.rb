require_relative '../lib/number_list'
require_relative '../lib/ui/full_keypad.rb'

number_list = NumberList.new("input_examples/2016-01-food-outside-pinch.csv")

simulations = FullKeypad.run_simulations(number_list)

simulations.each do |sim|
  deviation = (sim.actual_sum - sim.estimated_sum).abs

  puts
  puts sim.class.to_s
  #puts sim.variant_description
  puts sim.options.inspect
  puts "total_clicks: #{sim.total_clicks}"
  puts "actual sum: #{sim.actual_sum}"
  puts "absolute deviation: #{deviation}"
  puts "fraction deviation: #{deviation / sim.actual_sum}"
end
