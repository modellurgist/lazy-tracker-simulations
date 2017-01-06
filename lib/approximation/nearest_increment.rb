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

