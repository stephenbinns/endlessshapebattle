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
    @player.warp(80 * 3 + 3, 400)
    @stars = []
    @bullets = BulletCache.new(self)
    @enemy_cache = EnemyCache.new(self)
    @grid = Gosu::Image.new(self, "media/Grid.png", true)
    @color = Gosu::Color.new(0xff000000)

    while @stars.size < 30
      @stars << Star.new(self)
    end

    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.005
    @bloom.power = 0.25 
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def update
    $gosu_blocks.clear if defined? $gosu_blocks # workaround for Gosu 0.7.45 bug.
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

    @color.red = pulse(@color.red)
    @color.green = pulse(@color.green)
    @color.blue = pulse(@color.blue)
  end
 
  def pulse(value)
    if @increment
       val = [125, value+1].min
       @increment = val != 125
    else
       val = [20, value-1].max
       @increment = val == 20
    end

    val
  end

  def draw
    post_process(@bloom) do
      @bullets.draw
      @enemy_cache.draw
      @player.draw
      timex = 0
      timey = 0
      6.times do
         6.times do
           @grid.draw(timex, timey, ZOrder::Background, 1,1, @color, :add)
           timey += 80
         end
         timey = 0
         timex += 80
      end
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
