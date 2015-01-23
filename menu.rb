require 'gosu'

class MainMenu
  def initialize(window)
    @window = window
    @wallpaper = Gosu::Image.new(window, "media/fullscreen.png", false)
    @font = Gosu::Font.new window, "media/digiffiti.ttf", 48
    @font_l = Gosu::Font.new window, "media/digiffiti.ttf", 128
    @menu = []
    @menu << MenuItem.new("Start", lambda { start_game }, true) 
    @menu << MenuItem.new("Scores", lambda { high_scores }, false) 
    @menu << MenuItem.new("Options", lambda { options }, false) 
    @menu << MenuItem.new("Exit", lambda { window.close }, false) 
    @cooloff = 10
  end

  def draw
    @wallpaper.draw 0,0,0
    @menu.each_with_index { |m, i| m.draw(@font, i) } 
    @font_l.draw("E.S.B", 180, 80, ZOrder::UI)

    centered_text "Press Z to select", 400
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
