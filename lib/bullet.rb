class Bullet
  attr_reader :x, :y, :type 

  def initialize(window)
    @img =  Gosu::Image.new(window, "media/Star.png", false)
    @color = Gosu::Color.new(0xff000000)
    @color.red = 254
    @color.green = 254
    @color.blue = rand(256 - 40) + 40

    @x = @y = 0
    @speed = 0.0
    @active = false
  end

  def fire(player)
    @x = player.x + (player.image.width / 2) - (@img.width / 2) 
    @y = player.y
    @speed = -6
    @active = true
    @type = player.type
  end

  def collide(others)
    others.each do |o|
      if Gosu::distance(@x, @y, o.x, o.y) <= 40
        o.collided(self)
        collided
      end
    end
  end

  def collided
    @active = false
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
