class Bullet
  attr_reader :x, :y 

  def initialize(window)
    @img =  Gosu::Image.new(window, "media/Star.png", false)
    @color = Gosu::Color.new(0xff000000)
    @color.red = @color.green = @color.blue = rand(256 - 40) + 40

    @x = @y = 0
    @speed = 0.0
    @active = false
  end

  def fire(player)
    @x = player.x + (player.image.width / 2) 
    @y = player.y
    @speed = -2.9
    @active = true
  end
 
  def active?
    @active
  end 

  def draw  
    return unless @active

    @img.draw(@x, @y, ZOrder::Stars,1,1, @color, :add)
  end

  def update
    return unless @active

    @y += @speed
    if (@y + @img.height) <= 0
      @speed = 0.0
      @active = false
    end
  end
end