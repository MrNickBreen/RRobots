require 'robot'
#notes for future updates:
# - get the corner and side detection working properly
# - instead of turning the duck to find enemy, turn the gun (which turns radar)
# - do evasive action when get hit (health changes between turns)
class NickDuck
   include Robot
   def initialize
    # TODO: add all variables here
   end
   def detectEnemy
    unless events['robot_scanned'].empty?
      @seen_enemy_recently = true
      @last_time_enemy_seen = time
    end
    if @seen_enemy_recently == true && (@last_time_enemy_seen <= @time-15)
      @seen_enemy_recently = false
    end
  end
  def setAccelerate
    accelerate 1
  end
  def turn_counter
    turn 10
  end
  def turn_clockwise
    turn -10
  end
  def setRobotTurnDirection(min, max)
      @midpoint = min+90
      @local_heading = @heading
      if (min == 270) && (max == 90) && (@heading >= 270 || @heading <= 90)
        if @heading <= 90
          @local_heading = @heading+360
        end
        max = max+360
        @midpoint = 360
       else
        #%361 to help with the edge case of escaping y max turning counter
        @midpoint = (@midpoint)%361
      end
      if (min <= @local_heading) && (@local_heading <= max)
        @edge_detection_activated = true
        if @local_heading >= @midpoint
          turn_counter
        else
          turn_clockwise
        end
      end
  end
  def setRobotTurn
    @edge_detection_activated = false
    @edge_detection_constant = 70
    if (@x-@size-@edge_detection_constant) <= 0
      setRobotTurnDirection(90, 270)
    end
    if (@x+@size+@edge_detection_constant) >= @battlefield_width
      setRobotTurnDirection(270, 90)
    end
    if (@y-@size-@edge_detection_constant) <= 0
      setRobotTurnDirection(0, 180)
    end
    if (@y+@size+@edge_detection_constant) >= @battlefield_height
      setRobotTurnDirection(180, 360)
    end
    if !@edge_detection_activated
      if !@seen_enemy_recently
        @turn_variable = rand(0..8)
        if @turn_variable == 0
         turn 1
        elsif @turn_variable > 1
        # turn -10
        end
      end
    end
  end
  def initialize
    @seen_enemy_recently = false
    @last_time_enemy_seen = 0
    turn_radar 1 if time == 0
  end
  def tick events
    detectEnemy
   # say @speed.to_s.concat(' ').concat(@time.to_s).concat(@seen_enemy_recently.to_s)
    setAccelerate
    setRobotTurn

    #turn_gun 30 if time < 3
    fire 3 unless events['robot_scanned'].empty?
  end
end
