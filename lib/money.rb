class Money
  attr_accessor :integer_string,
                :decimal_string,
                :integer,
                :decimal

  def self.build(number)
    values = number.to_s.split(".")
    Money.new(values.first, values.last[0..1])
  end

  def self.sum(monies)
    integer_sum = monies.reduce(0) {|sum, money| sum + money.integer}
    decimal_sum = monies.reduce(0) {|sum, money| sum + money.decimal}
    integer_sum + decimal_sum
  end

  def initialize(integer_string, decimal_string)
    @integer_string = integer_string
    @decimal_string = decimal_string
    @integer = @integer_string.to_i
    @decimal = "0.#{@decimal_string}".to_f
  end

  def to_s
    decimal = ".#{@decimal_string}" if @decimal > 0
    "#{@integer_string}#{decimal}"
  end

  def to_f
    to_s.to_f
  end
end
