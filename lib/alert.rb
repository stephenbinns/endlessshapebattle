class Alert
  attr_reader :should_pause

  def age
    (Gosu.milliseconds - @start_time) / 1000.0
  end

  def dead?
    age > @death_time
  end

  def unpause
    @should_pause = false
  end

  def initialize(x, y, text, should_pause, death_time = 1.5, alpha_fade = 4)
    @x = x
    @y = y
    @text = text
    @should_pause = should_pause
    @color = Gosu::Color.new(0xffffffff)
    @start_time = Gosu.milliseconds
    if @should_pause
      @death_time = death_time
    else
      @death_time = death_time * 2
    end
    @alpha_fade = alpha_fade
  end

  def update
    @color.alpha -= @alpha_fade
  end

  def draw(font)
    if Gem.win_platform?
      offset = 14
    else
      offset = 10
    end

    offset_x = @text.length * offset
    font.draw(@text, @x - offset_x, @y, ZOrder::UI, 1.0, 1.0, @color)
  end
end
