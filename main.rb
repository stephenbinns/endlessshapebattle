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
    self.caption = 'Endless Shape Battle - 0.1'
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
    @bloom.power = 0.3 
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
      @player.change_type Shapes::Circle
      @bullets.fire @player
    end
    if button_down? Gosu::KbX or button_down? Gosu::GpButton2 then
      @player.change_type Shapes::Square
      @bullets.fire @player
    end
    if button_down? Gosu::KbC or button_down? Gosu::GpButton3 then
      @player.change_type Shapes::Triangle
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

    @font.draw("Score: #{@player.score}", 480, 40, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Chain: #{@player.chain}", 480, 60, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Level: #{@player.level}", 480, 80, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Lives: #{@player.lives}", 480, 100, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("Z: () ", 480, 140, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("X: []", 480, 160, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw("C: /\\", 480, 180, ZOrder::UI, 1.0, 1.0, 0xffffffff)
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

module Shapes
  Circle, Square, Triangle = *0..2
end

GameWindow.new.show
