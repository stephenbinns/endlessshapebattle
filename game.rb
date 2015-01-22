class GameEngine
  attr_reader :bullets, :player, :enemy_cache

  def initialize(window)
    @window = window
    @font = Gosu::Font.new window, 'media/digiffiti.ttf', 32
    @font_large = Gosu::Font.new window, 'media/digiffiti.ttf', 48
    @player = Player.new(window, self)
    @player.warp(80 * 3 + 3, 400)
    @bullets = BulletCache.new(window, player)
    @enemy_cache = EnemyCache.new(window, player, @bullets, self)
    @grid = Gosu::Image.new(window, 'media/Grid.png', true)
    @wallpaper = Gosu::Image.new(window, 'media/wallpaper.png', false)
    @color = Gosu::Color.new(0xff000000)
    @bloom = Ashton::Shader.new fragment: :bloom
    @bloom.glare_size = 0.005
    @bloom.power = 0.25
    @waves = []
    @combos = []

    @circ = Gosu::Image.new(window, 'media/CircleSmall.png', true)
    @squr = Gosu::Image.new(window, 'media/SquareSmall.png', true)
    @tria = Gosu::Image.new(window, 'media/TriangleSmall.png', true)
    notify "Get ready", true
    @song = Gosu::Song.new window, 'media/JumpShot.ogg'
  end

  def combo(combo)
    @combos << combo
  end

  def pulse(value)
    if !@increment.nil? && @increment
      val = [125, value + 1].min
      @increment = val != 125
    else
      val = [20, value - 1].max
      @increment = val == 20
    end

    val
  end

  def make_waves(wave)
    @waves << wave
  end

  def notify(text, should_pause)
    @notify = Alert.new 220, 200, text, should_pause
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def button_down?(button)
    @window.button_down? button
  end

  def update
    if @song.playing? == false
      @song.play(true)
    end

    if @notify && @notify.should_pause
      if button_down?(Gosu::KbSpace)
        @notify.unpause
      end
      @notify.update
      @notify = nil if @notify.dead?
      return
    end

    if @notify
      @notify.update
      @notify = nil if @notify.dead?
    end
      
    if button_down?(Gosu::KbLeft) || button_down?(Gosu::GpLeft)
      @player.move_left
    end
    if button_down?(Gosu::KbRight) || button_down?(Gosu::GpRight)
      @player.move_right
    end
    if button_down?(Gosu::KbZ) || button_down?(Gosu::GpButton1)
      @player.change_type Shapes::Circle
      @bullets.fire @player
    end
    if button_down?(Gosu::KbX) || button_down?(Gosu::GpButton2)
      @player.change_type Shapes::Square
      @bullets.fire @player
    end
    if button_down?(Gosu::KbC) || button_down?(Gosu::GpButton3)
      @player.change_type Shapes::Triangle
      @bullets.fire @player
    end
    if button_down?(Gosu::KbSpace) || button_down?(Gosu::GpButton4)
      @player.bomb
    end

    @player.move
    @bullets.update
    @enemy_cache.update

    @color.red = pulse(@color.red)
    @color.green = pulse(@color.green)
    @color.blue = pulse(@color.blue)

    @waves.delete_if(&:dead?)
    @waves.each(&:update)

    @combos.delete_if(&:dead?)
    @combos.each(&:update)
  end

  def draw
    shaders = @waves.map(&:shader)
    shaders << @bloom
    @window.post_process(*shaders) do
      @bullets.draw
      @enemy_cache.draw
      @player.draw
      @combos.each { |c| c.draw(@font_large) }
      timex = 0
      timey = 0
      6.times do
        6.times do
          @grid.draw(timex, timey, ZOrder::Background, 1, 1, @color, :add)
          timey += 80
        end
        timey = 0
        timex += 80
      end
    end

    @wallpaper.draw(480, 0, ZOrder::UI)
    @font.draw('Score:', 500, 40, ZOrder::UI)
    @font.draw("#{@player.score}", 500, 60, ZOrder::UI)
    @font.draw("Level: #{@player.level}", 500, 80, ZOrder::UI)
    @font.draw("Lives: #{@player.lives}", 500, 100, ZOrder::UI)

    @font.draw('Z:', 500, 140, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw('X:', 500, 160, ZOrder::UI, 1.0, 1.0, 0xffffffff)
    @font.draw('C:', 500, 180, ZOrder::UI, 1.0, 1.0, 0xffffffff)

    @circ.draw(540, 150, ZOrder::UI, 1.0, 1.0)
    @squr.draw(540, 170, ZOrder::UI, 1.0, 1.0)
    @tria.draw(540, 190, ZOrder::UI, 1.0, 1.0)

    bomb_string = '*' * @player.bombs
    @font.draw('Bombs:', 500, 220, ZOrder::UI)
    @font.draw("#{bomb_string}", 500, 240, ZOrder::UI)

    @font.draw "FPS: #{Gosu.fps} Waves: #{@waves.size}", 0, 0, 0
    if @notify
      @notify.draw(@font_large)
    end
  end
end
