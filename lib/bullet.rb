class Bullet
  attr_reader :x, :y, :type 

  def initialize(window, player)
    @window = window
    @player = player

    @circ = Gosu::Image.new(window, "media/CircleSmall.png", true)
    @squr = Gosu::Image.new(window, "media/SquareSmall.png", true)
    @tria = Gosu::Image.new(window, "media/TriangleSmall.png", true)

    @color = Gosu::Color.new(0xff000000)
    @color.red = 254
    @color.green = 254
    @color.blue = rand(256 - 40) + 40

    @x = @y = 0
    @speed = 0.0
    @active = false
  end

  def fire(player)
     @type = player.type
    case @type
      when Shapes::Circle
        @img = @circ
      when Shapes::Square
        @img = @squr
      when Shapes::Triangle
        @img = @tria
    end

    @x = player.x + (player.image.width / 2) - (@img.width) 
    @y = player.y
    @speed = -6
    @active = true
  end

  def collide(others)
    others.each do |o|
      if Gosu::distance(@x, @y, o.x + 40, o.y + 40) <= 40
        o.collided
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

    @img.draw(@x, @y, ZOrder::Stars,2,2, @color, :add)
  end

  def update
    return unless @active

    @y += @speed
    if (@y + @img.height) <= 0
      @speed = 0.0
      @active = false
      @player.hit_nothing
    end
  end
end
