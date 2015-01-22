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

  def initialize(x, y, text, should_pause)
    @x = x
    @y = y
    @text = text
    @should_pause = should_pause
    @color = Gosu::Color.new(0xffffffff)
    @start_time = Gosu.milliseconds
    if @should_pause
      @death_time = 1.5
    else
      @death_time = 3.0
    end
  end

  def update
    @color.alpha -= 4
  end

  def draw(font)
    offset_x = @text.length * 10
    font.draw(@text, @x - offset_x, @y, ZOrder::UI, 1.0, 1.0, @color)
  end
end
