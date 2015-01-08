require 'gosu'
require 'ashton'

require_relative 'lib/player'
require_relative 'lib/bullet'
require_relative 'lib/bullet_cache'
require_relative 'lib/enemy'
require_relative 'lib/enemy_cache'
require_relative 'lib/star'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Hello World!'
    @font = Gosu::Font.new self, Gosu::default_font_name, 40
    @player = Player.new(self)
    @player.warp(320, 400)
    @stars = []
    @bullet_cache = BulletCache.new(self)
    @enemy_cache = EnemyCache.new(self)
 
    while @stars.size < 30
      @stars << Star.new(self)
    end

    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.0085
    @bloom.power = 0.3 
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def update
    if button_down? Gosu::KbUp or button_down? Gosu::GpUp then
      @player.move_up
    end
    if button_down? Gosu::KbDown or button_down? Gosu::GpDown then
      @player.move_down
    end
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.move_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.move_right
    end
    if button_down? Gosu::KbZ or button_down? Gosu::GpButton1 then
      @bullet_cache.fire @player
    end

    @player.move
    @bullet_cache.update
    @enemy_cache.update @bullet_cache
    #@stars.each { |star| star.update }
  end

  def draw
    post_process(@bloom) do
      @bullet_cache.draw
      @enemy_cache.draw
      #@stars.each { |star| star.draw }
    end
    
    @player.draw
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

GameWindow.new.show
