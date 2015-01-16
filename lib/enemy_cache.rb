class EnemyCache
  def initialize(window, player, bullets, game_view)
    @window = window
    @player = player
    @bullets = bullets
    @cooloff = 0
    @enemies = []
    while @enemies.size < 30
      type = @enemies.size % 3
      case type
        when Shapes::Circle
          @enemies << Enemy.new(window, "Circle", type, player, game_view)
        when Shapes::Square
          @enemies << Enemy.new(window, "Square", type, player, game_view)
        when Shapes::Triangle
          @enemies << Enemy.new(window, "Triangle", type, player, game_view)
      end
    end
  end

  def spawn
    enemy = @enemies.select { |b| b.active? == false }.shuffle.first
    enemy.spawn if enemy
  end

  def draw
    @enemies.each { |b| b.draw }
  end

  def update
    @cooloff -= 1
    if @cooloff <= 0
      spawn
      @cooloff = [150 - (@player.level * rand(30)), 30].max
    end
    @enemies.each { |b| b.update }

    @bullets.check_collisions @enemies.select { |e| e.active? }
  end
end
