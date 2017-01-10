require 'byebug'

class Fare
  BASIC_TUBE_FARE = 3.20
  BUS_FARE = 1.80

  THREE_ZONES_FAIR = 3.20
  TWO_ZONES_INC_ZONE_ONE_FARE = 3.00
  TWO_ZONES_EXC_ZONE_ONE_FARE = 2.25
  ZONE_ONE_FARE = 2.50
  ANY_ZONE_OUTSIDE_ZONE_ONE_FARE = 2.00

  ZONES = {
    "holborn" => [1],
    "earls court" => [1, 2],
    "hammersmith" => [2],
    "wimbeldon" => [3],
  }

  def bus
    BUS_FARE
  end

  def tube
    BASIC_TUBE_FARE
  end

  def calculate_final_fare(start_point, end_point)
    # TODO could be better refactored later
    start_zone = ZONES[start_point]
    end_zone = ZONES[end_point]
    overlapping_zone = start_zone & end_zone
    if overlapping_zone.any?
      one_zone_charge(overlapping_zone.first)
    elsif start_zone.last < end_zone.first
       multiple_zones(sz: start_zone.last, ez: end_zone.first)
     elsif start_zone.last > end_zone.last
       multiple_zones(sz: end_zone.last, ez: start_zone.last)
    end
  end

  private

  def one_zone_charge(zone)
    zone == 1 ? ZONE_ONE_FARE : ANY_ZONE_OUTSIDE_ZONE_ONE_FARE
  end

  def multiple_zones(sz:, ez:)
    zones = (sz..ez).collect {|i| i}
    if zones.length > 2
      THREE_ZONES_FAIR
    elsif zones.length == 2 && zones.include?(1)
      TWO_ZONES_INC_ZONE_ONE_FARE
    else
      TWO_ZONES_EXC_ZONE_ONE_FARE
    end
  end
end
