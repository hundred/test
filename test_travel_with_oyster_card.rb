require_relative 'lib/card'
require_relative 'lib/fare'
require_relative 'lib/journey'
require_relative 'lib/zone_finder'

# top up with £30
card = Card.new
card.top_up(30)
puts "Current balance ... #{card.balance}"

# Tube: from Holborn to Earl’s Court
card.touch_in({transport: :tube, stop: "Holborn"})
puts "-------> Travelling by TUBE"
puts "Touched in at Holborn (zone 1) \n Current balance ... #{card.balance}"
card.touch_out({transport: :tube, stop: "Earl’s Court"})
puts "Touched out at Earl’s Court (zone 1/2) \n Current balance ... #{card.balance} \n ---"

# BUS: 328 from Earl’s Court to Chelsea (doesnt matter where, you dont touch out)
card.touch_in({transport: :bus, stop: "Earl’s Court"})
puts "-------> Travelling by BUS"
puts "Touched in at Earl’s Court (zone 1/2) \n Current balance ... #{card.balance} \n ---"

# Tube: from Earl’s court to Hammersmith
card.touch_in({transport: :tube, stop: "Earl’s Court"})
puts "-------> Travelling by TUBE"
puts "Touched in at Earl’s Court (zone 1/2) \n Current balance ... #{card.balance}"
card.touch_out({transport: :tube, stop: "Hammersmith"})
puts "Touched out at Hammersmith (zone 2) \n Current balance ... #{card.balance} \n ---"

# final balance
puts "Final card balance ... #{card.balance}"
