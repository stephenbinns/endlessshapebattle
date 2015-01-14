require 'gosu'

class MainMenu
  def initialize(window)
    @window = window
    @font = Gosu::Font.new window, Gosu::default_font_name, 20
    @wallpaper = Gosu::Image.new(window, "media/fullscreen.png", false)
    @menu = []
    @menu << MenuItem.new("Start", @font, 1, lambda { start_game }, true) 
    @menu << MenuItem.new("Scores", @font, 2, lambda { start_game }, false) 
    @menu << MenuItem.new("Exit", @font, 3, lambda { window.close }, false) 
    @cooloff = 0
  end

  def draw
    @wallpaper.draw 0,0,0
    @menu.each { |m| m.draw } 
  end

  def start_game
    @window.change_state GameEngine.new @window
  end

  def move_down
    return if @cooloff > 0
    current = selected_menu
    current.selected = false
    index = current.index
    index = [current.index + 1, 3].min

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
      selected_menu.select
    end
    @cooloff -= 1
  end
end

class MenuItem
  attr_accessor :selected, :index

  def initialize(text, font, index, callback, selected)
    @text = text
    @font = font
    @index = index
    @callback = callback
    @selected = selected
  end

  def draw
    color = 0xffffffff
    if @selected
      color = 0xffaaffff
    end
    @font.draw(@text, 280, 30 * @index + 200, ZOrder::UI, 1.0, 1.0, color)
  end
    
  def select
    @callback.call
  end 
end
