require 'robot'

class DavidDuck  

   #TODO: remove magic numbers.
     
   include Robot
   
   def initialize
     @NORMAL_TURN = 1
     @FAST_TURN = 4
          
     @TURN_DELAY = 12 # mod this is 0 we delay
     
     @WALL_PADDING = 120
     
     @SLOW_GUN_TURN = 1
     @NORMAL_GUN_TURN = 5
     @FAST_GUN_TURN = 17 

     @RADAR_TURN_SPEED = 2
     
     @ENEMY_CLOSE = 100   # threshold distance for considering an enemy close.
     @SAW_ENEMY_LONG_AGO = 20 # how many ticks ago do we consider too long ago since we saw an enemy
     @SAW_ENEMY_MEDIUM = 15   # I tried 20, and then only won 60% of matches against grant. with 15 I win 80%
     @SAW_ENEMY_RECENTLY = 5
     
     
  	 @my_accel = 1
  	 @gun_turn_speed = 10
  	 @near_wall = false
  	 @turn_speed = 3
  	 @found_enemy = 0        # the time at which our scanner last saw an enemy
  	 @distance_to_enemy = 0  # distance to enemy we scanned
   end

   
  # main game loop
  def tick events
    setup_bot	
  		
  	default_turn   	

    wall_behaviour	
  	
    enemy_behaviour
    
    aim_gun
        
    implement_update            
  end
    
   # Helper methods       
   def setup_bot          
    turn_radar -3 if time == 0
   end
   
   def default_turn
     @turn_speed = @NORMAL_TURN unless time % @TURN_DELAY == 0  
   end

  def enemy_behaviour
    if (! events['robot_scanned'].empty?)
      say('Pew!')
      fire 3 
      @gun_turn_speed = -@turn_speed  
      @found_enemy = time
      @distance_to_enemy = events['robot_scanned'][0][0]
      update_radar      
    end    
   end
   
   def aim_gun
     time_since_enemy = time-@found_enemy
     
    if (time_since_enemy> 0 and time_since_enemy < @SAW_ENEMY_RECENTLY)
      @gun_turn_speed = - @turn_speed - @NORMAL_GUN_TURN - 5 
    elsif (time_since_enemy > @SAW_ENEMY_RECENTLY and time_since_enemy < @SAW_ENEMY_MEDIUM and @distance_to_enemy > @ENEMY_CLOSE)
      @gun_turn_speed = @SLOW_GUN_TURN
    elsif (time_since_enemy < @SAW_ENEMY_LONG_AGO)
      @gun_turn_speed = @NORMAL_GUN_TURN
    elsif (time_since_enemy > @SAW_ENEMY_LONG_AGO)
      say(['no enemy ',time].join)
      @gun_turn_speed = @FAST_GUN_TURN
    end 
   end
   
   def update_radar
     if(@distance_to_enemy > @ENEMY_CLOSE and (radar_heading > -6 + gun_heading))
       turn_radar(-@RADAR_TURN_SPEED) 
     elsif (radar_heading < -@RADAR_TURN_SPEED + gun_heading)
      turn_radar @RADAR_TURN_SPEED 
     end
   end
   
   # Not currently used. Makes me an easier target.
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
  
  def wall_behaviour
    @turn_speed =  @FAST_TURN if detect_walls
  end

   def detect_walls
    if x <= @WALL_PADDING or x >= (battlefield_width - @WALL_PADDING)   
      @near_wall = true;
    elsif y >= (battlefield_height - @WALL_PADDING) or (y <= @WALL_PADDING)       
      @near_wall = true;
    else
      @near_wall = false;
    end
    return @near_wall
   end
   
   def implement_update
      turn @turn_speed
      accelerate @my_accel 
      turn_gun @gun_turn_speed     
   end
   
end