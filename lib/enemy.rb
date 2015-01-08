class Enemy
  attr_reader :x, :y 

  def initialize(window, image)
    @img =  Gosu::Image.new(window, "media/#{image}.png", false)
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40

    @x = @y = 0
    @speed = 0.0
    @active = false
  end

  def spawn
    @x = rand(6) * 80
    @y = 0
    @speed = 2.9
    @active = true
  end
 
  def active?
    @active
  end
 
  def collided(other)
    @active = false
  end

  def draw  
    return unless @active

    @img.draw(@x, @y, ZOrder::Stars,1,1, @color, :add)
  end

  def update
    return unless @active

    @y += @speed
    if (@y + @img.height) >= 480
      @active = false
    end
  end
end
