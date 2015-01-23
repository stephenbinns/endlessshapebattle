require 'gosu'

class Options 
  def initialize(window)
    @window = window
    @wallpaper = Gosu::Image.new(window, "media/fullscreen.png", false)
    @font = Gosu::Font.new window, "media/digiffiti.ttf", 48
    @menu = []

    load_options

    @menu << MenuItem.new("Turorial - #{on_text @options[:tutorial]}", lambda { toggle_tutorial }, true) 
    @menu << MenuItem.new("Sounds - #{on_text @options[:sounds]}", lambda { toggle_sounds }, false) 
    @menu << MenuItem.new("Music - #{on_text @options[:music]}", lambda { toggle_music }, false) 
    @menu << MenuItem.new("Back", lambda { menu }, false) 
    @cooloff = 0
  end

  def load_options
    begin
      @options = YAML::load_file('options.yml')
    rescue
      @options = {
        :tutorial => true,
        :sounds => true,
        :music => true
      }
    end
  end

  def on_text(option)
    if option 
      "on"
    else
      "off"
    end
  end

  def draw
    @wallpaper.draw 0,0,0
    @menu.each_with_index { |m, i| m.draw(@font, i) } 
    @font.draw("Options", 180, 80, ZOrder::UI)
  end

  def toggle_tutorial
    return if @cooloff > 0
    @options[:tutorial] = !@options[:tutorial]
    selected_menu.text = "Turorial - #{on_text @options[:tutorial]}"
  end
  
  def toggle_sounds
    return if @cooloff > 0
    @options[:sounds] = !@options[:sounds]
    selected_menu.text = "Sounds - #{on_text @options[:sounds]}"
  end

  def toggle_music
    return if @cooloff > 0
    @options[:music] = !@options[:music]
    selected_menu.text = "Music - #{on_text @options[:music]}"
  end

  def menu
    File.open('options.yml', 'w') {|f| f.write @options.to_yaml }
    @window.change_state MainMenu.new @window
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
      selected_menu.select
    end
    @cooloff -= 1
  end
end
