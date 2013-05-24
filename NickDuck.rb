require 'robot'

class NickDuck
   include Robot
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
      #@midpoint = min+90
      #if (min == 270) && (max == 90) && (@heading <= 90)
      #  @local_heading = @heading+360
      #else
      #  @local_heading = @heading
      #  @midpoint = (@midpoint)%361
      #end
      #say min.to_s.concat(' ').concat(@local_heading.to_s).concat(' ').concat(max.to_s)
      #if (min <= @local_heading) && (@local_heading <= max)
        #say (@local_heading.to_s).concat(' ').concat(((min+90)%360).to_s)
        #%361 to help with the edge case of escaping y max turning counter
      #  if @local_heading >= @midpoint
          turn_counter
      #  else
      #    turn_clockwise
      #  end
      #end
  end
  def setRobotTurn
    #say @x.to_s.concat(' ').concat(@y.to_s)
    #say @size
    @edge_detection_constant = 70
    if (@x-@size-@edge_detection_constant) <= 0
      setRobotTurnDirection(90, 270)
    elsif (@x+@size+@edge_detection_constant) >= @battlefield_width
      setRobotTurnDirection(270, 90)
    elsif (@y-@size-@edge_detection_constant) <= 0
      setRobotTurnDirection(0, 180)
    elsif (@y+@size+@edge_detection_constant) >= @battlefield_height
      setRobotTurnDirection(180, 360)
    elsif !@seen_enemy_recently
      @turn_variable = rand(0..5)
      if @turn_variable == 0
        turn 30
      elsif @turn_variable > 1
        turn 5
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