require 'robot'

class DavidDuck  
  
   include Robot
   
   def initialize
     @NORMAL_TURN = 2
     @FAST_TURN = 7
     @SLOW_GUN_TURN = 1
     @NORMAL_GUN_TURN = 5
     @FAST_GUN_TURN = 10 
     
  	 @my_accel = 1
  	 @gun_turn_speed = 10
  	 @near_wall = false
  	 @turn_speed = 3
  	 @found_enemy = 0  #the time at which our scanner last saw an enemy
   end

   
  # main game loop
  def tick events
    setup_bot	
        
  	detect_injury		  	

  	detect_walls
  	
    detect_enemy
        
    implement_update        
    
  end
    
    
   # Helper methods       
   def setup_bot          
    turn_radar 1 if time == 0
    turn_gun 20 if time < 3
   end
   
   def detect_win
     
   end
   
   def detect_enemy
    if (! events['robot_scanned'].empty?)
      say('Pew!')
      fire 3 
      @gun_turn_speed = -@turn_speed  
      @found_enemy=time
      # @turn_speed = 3
      # turn_radar -1      
    end    
    if (time-@found_enemy>0 && time-@found_enemy<4)
      @gun_turn_speed = -@turn_speed-5  
    elsif (time-@found_enemy>3 && time-@found_enemy<20 )
      @gun_turn_speed = @SLOW_GUN_TURN
    elsif (time-@found_enemy>30 )
      say(['no enemy ',time].join)
      @gun_turn_speed = @FAST_GUN_TURN
      if(!@near_wall)
        @turn_speed = 0 
        @turn_speed = rand(1..4)  unless time%5 == 0  
      end
    end 
   end
   
   def detect_injury   
    @last_hit = time unless events['got_hit'].empty? 
    if @last_hit && time - @last_hit < 5
      say('hit')
      @turn_speed = @FAST_TURN-2      
    elsif @last_hit && (time - @last_hit < 20)
      say('not hit')
      @turn_speed = rand(1...@NORMAL_TURN)      
    end    
   end 

   def detect_walls
    if x<=85
      turn_speed =  @FAST_TURN
      say('left edge')
      @near_wall=true;
    elsif x>=(battlefield_width-85)
      turn_speed =  @FAST_TURN 
      say('right edge')
          @near_wall=true;
    elsif y>= (battlefield_height-85)
      turn_speed =  @FAST_TURN
      say('bottom edge')
          @near_wall=true;
    elsif y<= 150 
      turn_speed =  @FAST_TURN
      say('top edge')
      @near_wall=true;
    else
      @near_wall=false;
    end
   end
   
          
   def implement_update
     say(@turn_speed.to_s)
      accelerate(@my_accel)
      turn @turn_speed
      turn_gun @gun_turn_speed     
   end
   
end