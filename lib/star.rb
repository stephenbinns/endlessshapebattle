class Star
  attr_reader :x, :y 

  def initialize(window)
    @img =  Gosu::Image.new(window, "media/Star.png", false)
    @color = Gosu::Color.new(0xff000000)
    @color.red = @color.green = @color.blue = rand(256 - 40) + 40

    @x = rand * 640
    @y = rand * 480
    @speed = (rand * 4) + 1 
  end

  def draw  
    @img.draw(@x, @y, ZOrder::Stars)#,1,1, @color, :add)
  end

  def update
    @y += @speed
    if @y + @img.height > 640
      @y = 0
      @x = rand * 640
    end
  end
end
