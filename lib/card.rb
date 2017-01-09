require 'fare'

class Card

  attr_reader :balance
  attr_accessor :in_transit

  def initialize
    @balance = 0
    @in_transit = false
  end

  def top_up(amount)
    raise 'Top up amount must be an integer higher than 0' unless is_valid?(amount)
    @balance += amount
  end
  alias :refund :top_up

  def charge(options)
    fare = Fare.new(options, self).calculate
    @balance -= fare
  end

  private

  def is_valid?(amount)
    (amount.is_a?(Integer) || amount.is_a?(Float)) && amount > 0
  end

end
