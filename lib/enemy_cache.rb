class EnemyCache
  def initialize(window, player, bullets, game_view)
    @window = window
    @player = player
    @bullets = bullets
    @cooloff = 0
    @enemies = []
    @game = game_view
    while @enemies.size < 30
      type = @enemies.size % 3
      case type
        when Shapes::Circle
          @enemies << Enemy.new(window, 'Circle', type, player, game_view)
        when Shapes::Square
          @enemies << Enemy.new(window, 'Square', type, player, game_view)
        when Shapes::Triangle
          @enemies << Enemy.new(window, 'Triangle', type, player, game_view)
      end
    end
    @circle_spawned = @square_spawned = @triangle_spawned = false
  end

  def spawn
    enemy = @enemies.select { |b| b.active? == false }.shuffle.first
    enemy.spawn if enemy
  end

  def draw
    @enemies.each(&:draw)
  end

  def bomb
    @enemies.select(&:active?).each(&:collided)
  end

  def update
    @cooloff -= 1
    if @cooloff <= 0
      spawn
      @cooloff = [150 - (@player.level * rand(30)), 30].max
    end
    @enemies.each(&:update)

    @bullets.check_collisions @enemies.select(&:active?)
    tutorial if @game.options[:tutorial]
  end

  private
  def tutorial
    return if @circle_spawned && @square_spawned && @triangle_spawned

    @enemies.select(&:active?).each do |enemy|
      return if enemy.y < 30

      case enemy.type
      when Shapes::Circle
        @game.notify "Shoot Circles with Z", true unless @circle_spawned
        @circle_spawned = true
      when Shapes::Square
        @game.notify "Shoot Squares with X", true unless @square_spawned
        @square_spawned = true
      when Shapes::Triangle
        @game.notify "Shoot Triangles with C", true unless @triangle_spawned
        @triangle_spawned = true
      end
    end
  end
end
