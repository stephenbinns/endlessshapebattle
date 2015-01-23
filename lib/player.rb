class Player
  attr_reader :x, :y, :image, :type, :score, :chain, :level, :lives, :bombs

  def initialize(window, game)
    @window = window
    @game = game
    @image_c = Gosu::Image.new(window, 'media/Circle.png', false)
    @image_s = Gosu::Image.new(window, 'media/Square.png', false)
    @image_t = Gosu::Image.new(window, 'media/Triangle.png', false)

    @shoot = Gosu::Sample.new(window, "media/Shoot.wav")
    @death = Gosu::Sample.new(window, "media/Death.wav")
    @hit = Gosu::Sample.new(window, "media/Hit.wav")
    @miss = Gosu::Sample.new(window, "media/Miss.wav")
    @level_up = Gosu::Sample.new(window, "media/LevelUp.wav")
    @bomb_sound = Gosu::Sample.new(window, "media/Explosion.wav")

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

    old_level = @level
    @level = (@score / 100) + 1

    if old_level != @level
      @game.notify 'Level up!', false
      @level_up.play if @game.options[:sounds]
      old_level = @level
    end

    if @score > @bomb_target
      @bombs += 1
      if @bomb_target == 200
        @game.notify 'Bomb with space', false
      end
      @level_up.play if @game.options[:sounds]
      @bomb_target *= 2
    end
    @cooloff = 0
    @hit.play if @game.options[:sounds]
  end

  def hit_nothing
    @chain = 0
    @game.combo Combo.new @x, @y, '0'
    @miss.play if @game.options[:sounds]
  end

  def take_hit
    @lives -= 1
    if @lives == 0
      @window.change_state HighScores.new @window, @score
      @death.play if @game.options[:sounds]
    else
      @miss.play if @game.options[:sounds]
    end
  end

  def fire
    @cooloff = 10
    @shoot.play
  end

  def bomb
    return if @bombs < 1 || @bomb_cooloff > 0

    @bombs -= 1
    @bomb_cooloff = 10
    @game.enemy_cache.bomb
    @bomb_sound.play if @game.options[:sounds]
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
    @cooloff <= 0
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
