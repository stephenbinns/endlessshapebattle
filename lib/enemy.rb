class Enemy
  attr_reader :x, :y, :type 

  def initialize(window, image, type, player, game)
    @window = window
    @player = player
    @game = game
    @img = Gosu::Image.new(window, "media/#{image}.png", false)
    @color = Gosu::Color.new(0xff000000)
    @x = @y = 0
    @speed = 0.0
    @active = false
    @type = type
  end

  def spawn
    @x = rand(6) * 80 + 3
    @y = -90
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @speed = [@player.level + rand(2), 10].min
    @active = true
  end
 
  def active?
    @active
  end
 
  def collided(other)
    @active = false
    @speed = 0
    @player.hit_shape
    @game.make_waves Shockwave.new(@x, @y)
  end

  def draw  
    return unless @active

    @img.draw(@x, @y, ZOrder::Stars,1,1, @color, :add)
  end

  def update
    return unless @active

    @y += @speed
    if (@y + @img.height) >= 480 + 80
      @active = false
      @player.take_hit
    end
  end
end
