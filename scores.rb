require 'gosu'
require 'yaml'

class HighScores
  def initialize(window, score)
    @window = window
    @font = Gosu::Font.new window, Gosu::default_font_name, 20
    @wallpaper = Gosu::Image.new(window, "media/fullscreen.png", false)
    @scores = load_scores
    if score > top_scores.last.value
      puts 'new high score'
      @scores << ScoreItem.new(score)
      
      File.open('scores.yml', 'w') {|f| f.write top_scores.to_yaml }
    end 

    @cooloff = 0
  end

  def load_scores
    begin
       YAML::load_file('scores.yml')
    rescue
      scores = []
      scores << ScoreItem.new(0)
    end
  end

  def top_scores
    @scores.sort.take(10)
  end

  def draw
    @wallpaper.draw 0,0,0
    @font.draw("High scores", 260, 30, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    index = 0
    top_scores.each do |m| 
       index += 1
       m.draw(@font, index)
    end 
  end

  def main_menu
    @window.change_state MainMenu.new @window
  end

  def update
    if @window.button_down? Gosu::KbX or @window.button_down? Gosu::GpButton1 then
      main_menu
    end
  end
end

class ScoreItem
  attr_accessor :value
  def initialize(value)
    @value = value
  end

  def draw(font, index)
    color = 0xffffffff
    font.draw(@value.to_s, 280, 30 * index + 50, ZOrder::UI, 1.0, 1.0, color)
  end
  
  def <=>(other)
    other.value <=> self.value
  end
end
