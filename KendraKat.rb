require 'robot'

class KendraKat
   include Robot
   

  def tick events
	turn_radar 1 if time == 0
	@my_acceleration = 1 if time == 0
	if events['robot_scanned'].empty?
		turn 2
		turn_gun 5
		accelerate @my_acceleration
	else
		turn_gun -9
		#if events["robot_scanned"][0][0].to_i < 7000
			fire 3
		#else
			#fire 2.5
		#end
	end
	
	
   @last_hit = time unless events['got_hit'].empty? 
	#if @last_hit && time - @last_hit < 10
	 if not events['got_hit'].empty?
      if speed > 0
		@my_acceleration = -1
	else @my_acceleration = 1
	end
	  say "ouch!"
	end

	buffer_size = 100
	if x < buffer_size or x > battlefield_width - buffer_size or y < buffer_size or y > battlefield_height - buffer_size
		turn 8
	end	

	
  end
end