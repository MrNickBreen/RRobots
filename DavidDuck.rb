require 'robot'

class DavidDuck
   turn_speed = 0  
   include Robot
   
   def initialize
	 @my_accel = 1
	 @gun_turn_speed =10
	 @turn_speed =3
   end
   
  def tick events
    turn_radar 1 if time == 0
	@my_accel = 1 if time == 0
	turn_gun 20 if time < 3
	
	
	@last_hit = time unless events['got_hit'].empty? 
	if @last_hit && time - @last_hit < 20
      @turn_speed = (-@turn_speed*4+2)
	end	

    accelerate(@my_accel)
	turn @turn_speed
	turn_gun @gun_turn_speed
	
    fire 3 unless events['robot_scanned'].empty? 
	
  end
end