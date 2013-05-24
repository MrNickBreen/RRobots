
require 'robot'

class GrantButt
turn_speed = 0
#move_speed = 1
#posneg = 0

include Robot

def tick events
turn_radar 1 if time == 0
turn_gun 10
if (time % 100 < 50)
turn_speed = 2
say('woo')
elsif (time % 100 >= 50 && time % 100 < 70)
turn_speed = -3
say('!!!')
else
turn_speed = 5
say('hoo')
end

if events['robot_scanned'].empty? 
turn turn_speed
turn_gun 5
else
#turn  -turn_speed
end
accelerate 3

fire 3 unless events['robot_scanned'].empty?

end
end

