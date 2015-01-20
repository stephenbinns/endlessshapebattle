class Player
  attr_reader :x, :y, :image, :type, :score, :chain, :level, :lives, :bombs

  def initialize(window, game)
    @window = window
    @game = game
    @image_c = Gosu::Image.new(window, "media/Circle.png", false)
    @image_s = Gosu::Image.new(window, "media/Square.png", false)
    @image_t = Gosu::Image.new(window, "media/Triangle.png", false)
    
    reset
  end

  def reset
    @image = @image_t
    @type = Shapes::Circle
    @vel_x = 0.0
    @bombs = 0
    @move_wait = @cooloff = @bomb_cooloff = @score = 0
    @chain = 0
    @level = 1
    @lives = 3
    @x, @y = (80 * 3 + 3), 400
    @bomb_target = 200
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
      when Shapes::Circle
        @image = @image_c
      when Shapes::Square
        @image = @image_s
      when Shapes::Triangle
        @image = @image_t
    end
  end

  def hit_shape
    @chain += 1
    @chain = [@chain, 9].min
    @score += @chain
    @level = (@score / 100) + 1
    if @score > @bomb_target
      @bombs += 1 
      @bomb_target *= 2
    end
    @cooloff = 0
  end
 
  def hit_nothing
    @chain = [@chain-1, 0].max
    @game.combo Combo.new @x, @y, "-1" 
  end
  
  def take_hit
    @lives -= 1
    if @lives == 0
      @window.change_state HighScores.new @window, @score
    end
  end

  def fire
     @cooloff = 10
     # todo play sound
  end

  def bomb
    return if @bombs < 1 || @bomb_cooloff > 0

    @bombs -= 1
    @bomb_cooloff = 10
    @game.enemy_cache.bomb
  end

  def move
    @x += @vel_x
    @x %= 480
    @cooloff -= 1
    @move_wait -= 1
    @bomb_cooloff -= 1
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
