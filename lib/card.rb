class Card

  attr_reader :balance

  def initialize
    @balance = 0
    @journey = nil
  end

  def top_up(amount)
    add_money(amount)
  end

  def touch_in(options)
    @journey = Journey.new(transport: options[:transport], start_point: options[:stop])
    charge(@journey.basic_fare)
  end

  def touch_out(options)
    if @journey
      @journey.complete!(end_point: options[:stop])
      refund(@journey.fare_difference)
    else
      @journey = Journey.new(transport: options[:transport], end_point: options[:stop])
      charge(@journey.basic_fare)
    end
  end

  private

  def charge(amount)
    raise "Please top up" if @balance < @journey.basic_fare
    @balance -= amount
  end

  def add_money(amount)
    raise 'Top up amount must be higher than 0' unless is_valid?(amount)
    @balance += amount
  end
  alias :refund :add_money

  def is_valid?(amount)
    (amount.is_a?(Integer) || amount.is_a?(Float)) && amount > 0
  end

end
