require 'gosu'
require 'ashton'

require_relative 'menu'
require_relative 'scores'
require_relative 'game'
require_relative 'options'
require_relative 'intro'
require_relative 'lib/player'
require_relative 'lib/bullet'
require_relative 'lib/bullet_cache'
require_relative 'lib/shockwave'
require_relative 'lib/combo'
require_relative 'lib/alert'
require_relative 'lib/enemy'
require_relative 'lib/enemy_cache'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'HYPER Endless Shape Battle - 1.0'
    @state = Intro.new self
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def change_state(state)
    @state = state
  end

  def update
    @state.update
  end

  def draw
    @state.draw
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

module Shapes
  Circle, Square, Triangle = *0..2
end

GameWindow.new.show
