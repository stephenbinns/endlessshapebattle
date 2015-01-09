require 'gosu'
require 'ashton'

require_relative 'lib/player'
require_relative 'lib/bullet'
require_relative 'lib/bullet_cache'
require_relative 'lib/enemy'
require_relative 'lib/enemy_cache'
require_relative 'lib/star'

class GameWindow < Gosu::Window
  attr_reader :bullets, :player

  def initialize
    super(640, 480, false)
    self.caption = 'Hello World!'
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    @player = Player.new(self)
    @player.warp(80 * 3, 400)
    @stars = []
    @bullets = BulletCache.new(self)
    @enemy_cache = EnemyCache.new(self)
 
    while @stars.size < 30
      @stars << Star.new(self)
    end

    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.0085
    @bloom.power = 0.2 
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.move_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.move_right
    end
    if button_down? Gosu::KbZ or button_down? Gosu::GpButton1 then
      @player.change_type 0
      @bullets.fire @player
    end
    if button_down? Gosu::KbX or button_down? Gosu::GpButton2 then
      @player.change_type 1
      @bullets.fire @player
    end
    if button_down? Gosu::KbC or button_down? Gosu::GpButton3 then
      @player.change_type 2
      @bullets.fire @player
    end   

    @player.move
    @bullets.update
    @enemy_cache.update
  end

  def draw
    post_process(@bloom) do
      @bullets.draw
      @enemy_cache.draw
      @player.draw
    end

    @font.draw("Score: #{@player.score}", 480, 10, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

GameWindow.new.show
