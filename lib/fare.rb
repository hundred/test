class Fare
  MAX_AMOUNT_TUBE_FARE = 3.20
  BUS_AMOUNT = 1.80

  attr_reader :transport

  def initialize(options, card)
    @transport = options[:transport]
    @journey = options[:options]
    @card = card
  end

  def calculate
    public_send(transport)
  end

  def bus
    BUS_AMOUNT
  end

  def tube
    if @card.in_transit == true && @journey.fetch(:end, nil)
      @card.in_transit = false
      @card.refund(MAX_AMOUNT_TUBE_FARE)
      return 3
    else
      @card.in_transit = true if @journey.fetch(:start, nil)
      MAX_AMOUNT_TUBE_FARE
    end
  end
end
