class Intro
	def initialize(window)
    @window = window
    @font = Gosu::Font.new window, 'media/digiffiti.ttf', 48
    @notify = Alert.new 320, 240, "Handmadebymogwai", true, 3, 2
	end

  def button_down?(button)
    @window.button_down? button
  end

	def update
    if @notify && @notify.should_pause
      if button_down?(Gosu::KbSpace)
        @window.change_state MainMenu.new @window
      end
      @notify.update
      @window.change_state MainMenu.new @window if @notify.dead?
      return
    end
	end

  def draw
    if @notify
      @notify.draw(@font)
    end
  end
end