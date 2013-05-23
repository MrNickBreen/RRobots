require 'robot'

class DavidDuck
   turn_speed = 0  
   include Robot
   
   def initialize
	 @my_accel = 1
	 @gun_turn_speed =10
	 @turn_speed =3
	 @found_enemy = 0
   end
   
   
  def tick events
    turn_radar 1 if time == 0
	@my_accel = 1 if time == 0
	turn_gun 20 if time < 3
	
	
	@last_hit = time unless events['got_hit'].empty? 
	if @last_hit && time - @last_hit < 5
		@turn_speed = [8,(@turn_speed+1)].max
		say('hit')
	elsif @last_hit && (time - @last_hit < 20)
		@turn_speed = rand(2...4);
		say('not hit')
	end
	if (time-@found_enemy>30 )
		say(['no enemy ',time].join)
		@gun_turn_speed = 4
		@turn_speed = rand(1..5)		
	end
		
	if(time%5==0)
		@turn_speed =0
	end
	if x<=65
		turn_speed = 5 
		say('left edge')
	elsif x>=(battlefield_width-65)
		turn_speed = 5 
		say('right edge')
	elsif y>= (battlefield_height-65)
		turn_speed = 5
		say('bottom edge')
	elsif y<=  65 
		turn_speed = 3
		say('top edge')
	end
	
	if (! events['robot_scanned'].empty?)
		fire 3 
		say('found enemy!')
		@gun_turn_speed = -@turn_speed	
		@turn_speed = 3
		#turn_radar -1
		@found_enemy=time
	end	
		accelerate(@my_accel)
		turn @turn_speed
		turn_gun @gun_turn_speed
  end
end