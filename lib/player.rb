class Player
  attr_reader :x, :y, :image, :type, :score

  def initialize(window)
    @image_c = Gosu::Image.new(window, "media/Circle.png", false)
    @image_s = Gosu::Image.new(window, "media/Square.png", false)
    @image_t = Gosu::Image.new(window, "media/Triangle.png", false)
    @image = @image_t
    @type = 0
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
  
  def change_type(type)
    @type = type
    case type
      when 0
        @image = @image_c
      when 1
        @image = @image_s
      when 2
        @image = @image_t
    end
  end

  def hit_shape
    @score += 1
  end

  def fire
     @cooloff = 10
     # todo play sound
  end

  def move
    @x += @vel_x
    @x %= 480
    @cooloff = @cooloff - 1
    @move_wait = @move_wait - 1
    @vel_x = @vel_y = 0.0
  end

  def can_fire?
    @cooloff <= 0;
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  private

  def do_move(amount)
    if @move_wait <= 0
      @vel_x = amount
      @move_wait = 10
    end
  end
end
