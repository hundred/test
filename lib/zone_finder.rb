class ZoneFinder

  ZONES = {
    "holborn" => [1],
    "earls court" => [1, 2],
    "hammersmith" => [2],
    "wimbeldon" => [3],
  }

  ZONES_TO_WORDS = { 1 => "one",
                     2 => "two",
                     3 => "three"
                   }

  attr_reader :origin, :destination

  def initialize(origin, destination)
    @origin = ZONES[origin]
    @destination = ZONES[destination]
  end

  def perform
    zones = collect_travelled_zones
    if zones.include?(1)
      { count_humanize: ZONES_TO_WORDS[zones.max], inc_zone_one: true }
    else
      { count_humanize: ZONES_TO_WORDS[zones.length], inc_zone_one: false }
    end
  end

  private

  def collect_travelled_zones
    one_zone_only = origin & destination
    one_zone_only.any? ? one_zone_only : multiple_zones
  end

  def multiple_zones
    if origin.last < destination.first
      (origin.last..destination.first).collect {|i| i}
    elsif origin.last > destination.last
      (destination.last..origin.last).collect {|i| i}
    end
  end
end
