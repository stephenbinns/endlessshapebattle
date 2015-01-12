require 'ashton'
require 'gosu'

class Enemy
  attr_reader :x, :y, :type 

  def initialize(window, image, type)
    @window = window
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
    @speed = @window.player.level + rand(1) 
    @active = true
  end
 
  def active?
    @active
  end
 
  def collided(other)
    @active = false
    @window.player.hit_shape

    # todo display for x frames
    @last_update_at ||= Gosu::milliseconds
    delta = [Gosu::milliseconds - @last_update_at, 100].min * 0.001 # Limit delta to 100ms (10fps), in case of freezing.
    @last_update_at = Gosu::milliseconds

    @mouse_emitter = Ashton::ParticleEmitter.new 0, 0, 3,
                                                 scale: 4,
                                                 speed: 20..50,
                                                 max_particles: 5000,
                                                 offset: 0..5,
                                                 interval: 0.0010,
                                                 color: Gosu::Color.rgba(0, 255, 255, 100),
                                                 fade: 25,
                                                 gravity: 60 # pixels/s*s

    @mouse_emitter.x, @mouse_emitter.y = x, y
    @mouse_emitter.update delta

  end

  def draw  
    @mouse_emitter.draw if @mouse_emitter
    return unless @active

    @img.draw(@x, @y, ZOrder::Stars,1,1, @color, :add)
  end

  def update
    return unless @active

    @y += @speed
    if (@y + @img.height) >= 480 + 80
      @active = false
      @window.player.take_hit
    end
  end
end
