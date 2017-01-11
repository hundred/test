class Fare
  BASIC_TUBE_FARE = 3.20
  BUS_FARE = 1.80

  THREE_ZONES_FAIR = 3.20
  TWO_ZONES_INC_ZONE_ONE_FARE = 3.00
  TWO_ZONES_EXC_ZONE_ONE_FARE = 2.25
  ZONE_ONE_FARE = 2.50
  ANY_ZONE_OUTSIDE_ZONE_ONE_FARE = 2.00

  def bus
    BUS_FARE
  end

  def tube
    BASIC_TUBE_FARE
  end

  def calculate_final_fare(origin_station, destination_station)
    zones = ZoneFinder.new(origin_station, destination_station).perform
    if zones[:inc_zone_one]
      send("#{zones[:count_humanize]}_zone_higher_fare".to_sym)
    else
      send("#{zones[:count_humanize]}_zone_standard_fare".to_sym)
    end
  end

  private

  def one_zone_higher_fare
    ZONE_ONE_FARE
  end

  def two_zone_higher_fare
    TWO_ZONES_INC_ZONE_ONE_FARE
  end

  def three_zone_higher_fare
    THREE_ZONES_FAIR
  end

  def one_zone_standard_fare
    ANY_ZONE_OUTSIDE_ZONE_ONE_FARE
  end

  def two_zone_standard_fare
    TWO_ZONES_EXC_ZONE_ONE_FARE
  end

  def three_zone_standard_fare
    THREE_ZONES_FAIR
  end
end
