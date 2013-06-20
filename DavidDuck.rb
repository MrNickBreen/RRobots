require 'robot'

class DavidDuck  


   #TODO: remove magic numbers.
   #TODO: rename detect methods
   
  
   include Robot
   
   def initialize
     @NORMAL_TURN = 1
     @FAST_TURN = 4
     
     @WALL_PADDING = 120
     
     @SLOW_GUN_TURN = 1
     @NORMAL_GUN_TURN = 5
     @FAST_GUN_TURN = 17 
     
  	 @my_accel = 1
  	 @gun_turn_speed = 10
  	 @near_wall = false
  	 @turn_speed = 3
  	 @found_enemy = 0  #the time at which our scanner last saw an enemy
  	 @distance_to_enemy = 0 # distance to enemy we scanned
   end

   
  # main game loop
  def tick events
    setup_bot	
            
  	#detect_injury	
  		
  	@turn_speed = @NORMAL_TURN unless time % 12 == 0     	

  	detect_walls
  	
    detect_enemy
        
    implement_update        
    
  end
    
    
   # Helper methods       
   def setup_bot          
    turn_radar -3 if time == 0
   end
   

   def detect_enemy
    if (! events['robot_scanned'].empty?)
      say('Pew!')
      fire 3 
      @gun_turn_speed = -@turn_speed  
      @found_enemy=time
      @distance_to_enemy = events['robot_scanned'][0][0]
      update_radar      
    end    
    if (time-@found_enemy > 0 && time - @found_enemy < 3)
      @gun_turn_speed = - @turn_speed - @NORMAL_GUN_TURN - 5 
    elsif (time-@found_enemy > 3 && time - @found_enemy < 15 and @distance_to_enemy > 100)
      @gun_turn_speed = @SLOW_GUN_TURN
    elsif (time-@found_enemy < 20 )
      @gun_turn_speed = @NORMAL_GUN_TURN
    elsif (time-@found_enemy > 20 )
      say(['no enemy ',time].join)
      @gun_turn_speed = @FAST_GUN_TURN
    end 
   end
   
   def update_radar
     if(@distance_to_enemy>100 and (radar_heading > -6+gun_heading))
       turn_radar -2
     elsif (radar_heading < -2+gun_heading)
      turn_radar 2
     end
   end
   
   def detect_injury   
    @last_hit = time unless events['got_hit'].empty? 
    if @last_hit and time - @last_hit < 4
      say('hit')
      @turn_speed = @FAST_TURN      
    elsif @last_hit and (time - @last_hit < 10)
      say('not hit')
      @turn_speed = rand(1...@NORMAL_TURN)      
    end    
   end 

   def detect_walls
    if x<=@WALL_PADDING or x>=(battlefield_width-@WALL_PADDING)
      @turn_speed =  @FAST_TURN 
      say('side edge')
          @near_wall=true;
    elsif y>= (battlefield_height-@WALL_PADDING) or y<= @WALL_PADDING 
      @turn_speed =  @FAST_TURN
      say('top edge')
      @near_wall=true;
    else
      @near_wall=false;
    end
   end
   
   def implement_update
      turn @turn_speed
      accelerate( @my_accel ) 
      turn_gun @gun_turn_speed     
   end
   
end