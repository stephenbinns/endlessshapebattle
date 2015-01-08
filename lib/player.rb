class Player
  attr_reader :x, :y, :image

  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @x = @y = @vel_x = 0.0
    @move_wait = @cooloff = @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def move_left
    do_move(-80)
  end

  def move_right
    do_move(80)
  end

  def fire
     @cooloff = 10
     # todo play sound
  end

  def move
    @x += @vel_x
    @x %= 480
    @cooloff = @cooloff - 1
    @vel_x = @vel_y = 0.0
  end

  def can_fire?
    @cooloff <= 0;
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  private:
  def do_move(amount)
    if @move_wait <= 0
      @vel_x = amount
      @move_wait = 10
    end
  end
end
