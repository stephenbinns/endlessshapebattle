# Required only so we know the gem is being copied properly.
require 'rubygems'
require 'bundler/setup' unless defined? OSX_EXECUTABLE_FOLDER # Can't require bundler because the current OSX wrapper is broken.
require 'cri'

require 'gosu'
require 'ashton'

require_relative 'menu'
require_relative 'scores'
require_relative 'game'
require_relative 'lib/player'
require_relative 'lib/bullet'
require_relative 'lib/bullet_cache'
require_relative 'lib/shockwave'
require_relative 'lib/combo'
require_relative 'lib/enemy'
require_relative 'lib/enemy_cache'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = 'Endless Shape Battle - 0.1'
    @state = MainMenu.new self
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
