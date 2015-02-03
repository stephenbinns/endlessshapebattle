require 'gosu'

class MainMenu
  def initialize(window)
    @window = window
    @wallpaper = Gosu::Image.new(window, "media/fullscreen.png", false)
    @font = Gosu::Font.new window, "media/digiffiti.ttf", 48
    @font_l = Gosu::Font.new window, "media/digiffiti.ttf", 150
    @hyper_font = Gosu::Font.new(window, "media/digiffiti.ttf", 60)
    @menu = []
    @menu << MenuItem.new("Start", lambda { start_game }, true)
    @menu << MenuItem.new("Scores", lambda { high_scores }, false)
    @menu << MenuItem.new("Options", lambda { options }, false)
    @menu << MenuItem.new("Exit", lambda { window.close }, false)
    @cooloff = 10
    @color = Gosu::Color.new(0xff000000)
  end

  def draw
    @wallpaper.draw 0,0,0
    @menu.each_with_index { |m, i| m.draw(@font, i) }

    if Gem.win_platform?
      offset = 60
    else
      offset = 120
    end

    @font_l.draw("E-S-B", offset, 50, ZOrder::UI, 1.0, 1.0, @color)
    @hyper_font.draw("hyper", offset, 40, ZOrder::UI, 1.0, 1.0, @color)

    centered_text "Press Z to select", 400
  end

  def pulse(value)
    if !@increment.nil? && @increment
      val = [200, value + rand(3)].min
      @increment = val != 200
    else
      val = [125, value - rand(4)].max
      @increment = val <= 125
    end

    val
  end

  def centered_text(text, y)
    offset_x = text.length * 10
    @font.draw(text, 320 - offset_x, y, ZOrder::UI)
  end

  def high_scores
    @window.change_state HighScores.new @window, 0
  end

  def start_game
    @window.change_state GameEngine.new @window
  end

  def options
    @window.change_state Options.new @window
  end

  def move_down
    return if @cooloff > 0
    current = selected_menu
    current.selected = false
    index = current.index
    index = [current.index + 1, @menu.length].min

    @menu[index - 1].selected = true
    @cooloff = 10
  end

  def move_up
    return if @cooloff > 0
    current = selected_menu
    current.selected = false
    index = current.index
    index = [current.index - 1, 1].max

    @menu[index - 1].selected = true
    @cooloff = 10
  end

  def selected_menu
    @menu.select { |s| s.selected }.first
  end

  def update
    if @window.button_down? Gosu::KbDown or @window.button_down? Gosu::GpDown then
      move_down
    end
    if @window.button_down? Gosu::KbUp or @window.button_down? Gosu::GpUp then
      move_up
    end
    if @window.button_down? Gosu::KbZ or @window.button_down? Gosu::GpButton1 then
      selected_menu.select if @cooloff < 0
    end
    @cooloff -= 1

    @color.red = pulse(@color.red)
    @color.green = pulse(@color.green)
    @color.blue = pulse(@color.blue)
  end
end

class MenuItem
  attr_accessor :selected, :index, :text

  def initialize(text, callback, selected)
    @text = text
    @callback = callback
    @selected = selected
  end

  def draw(font, i)
    color = 0xffffffff
    if @selected
      color = 0xff22ffff
    end
    @index = i + 1
    offset_x = @text.length * 10
    font.draw(@text, 320 - offset_x, 35 * i + 200, ZOrder::UI, 1.0, 1.0, color)
  end

  def select
    @callback.call
  end
end
