class Combo
  attr_reader :shader

  def age
    (Gosu.milliseconds - @start_time) / 1000.0
  end

  def dead?
    age > 3.0
  end

  def initialize(x, y, text)
    @x = x
    @y = y
    @text = text
    @color = Gosu::Color.new(0xffffffff)
    @start_time = Gosu.milliseconds
  end

  def update
    @color.alpha -= 4
  end

  def draw(font)
    font.draw("#{@text}X", @x, @y, ZOrder::UI, 1.0, 1.0, @color)
  end
end
