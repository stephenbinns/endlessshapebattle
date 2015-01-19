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
    @speed = [@player.level + rand(2), 5].min
    @active = true
  end
 
  def active?
    @active
  end
 
  def collided
    @active = false
    @speed = 0
    @player.hit_shape
    origin_x = @x
    origin_y = @y
    @game.make_waves Shockwave.new(origin_x, origin_y)
    @game.combo Combo.new(origin_x, origin_y, @player.chain)
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
