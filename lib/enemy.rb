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
    @death_frames = 200
    @particles = Ashton::ParticleEmitter.new 0, 0, 3,
                                                 scale: 4,
                                                 speed: 20..50,
                                                 max_particles: 1000,
                                                 offset: 0..5,
                                                 interval: 0.0090,
                                                 color: @color,
                                                 fade: 100,
                                                 gravity: 30 # pixels/s*s
    @particles.x, @particles.y = x + 40, y + 40
  end

  def draw  
    @particles.draw if @particles
    return unless @active

    @img.draw(@x, @y, ZOrder::Stars,1,1, @color, :add)
  end

  def update
    if (@death_frames && @death_frames > 0)
      @last_update_at ||= Gosu::milliseconds
      delta = [Gosu::milliseconds - @last_update_at, 100].min * 0.001 # Limit delta to 100ms (10fps), in case of freezing.
      @last_update_at = Gosu::milliseconds
      @particles.update delta
      @death_frames = @death_frames - 1
    else
      @particles = nil
    end

    return unless @active

    @y += @speed
    if (@y + @img.height) >= 480 + 80
      @active = false
      @window.player.take_hit
    end
  end
end
