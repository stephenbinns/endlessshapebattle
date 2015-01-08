class Player
  attr_reader :x, :y, :image

  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @x = @y = @vel_x = @vel_y = 0.0
    @cooloff = @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def move_up
    @vel_y = -2.9
  end

  def move_down
    @vel_y = 2.9
  end

  def move_left
    @vel_x = -80
  end

  def move_right
    @vel_x = 80
  end

  def fire
     @cooloff = 10
     # todo play sound
  end

  def move
    @x += @vel_x
    @y += @vel_y

    #todo consider if warping is desired
    @x %= 480
    @y %= 480

    @cooloff = @cooloff - 1

    @vel_x = @vel_y = 0.0
  end

  def can_fire?
    @cooloff <= 0;
  end

  def draw
    @image.draw(@x, @y, 1)
  end
end
