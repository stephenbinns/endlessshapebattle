class EnemyCache
  def initialize(window)
    @window = window
    @cooloff = 0
    @enemies = []
    while @enemies.size < 30
      type = @enemies.size % 3
      case type
        when Shapes::Circle
          @enemies << Enemy.new(window, "Circle", type)
        when Shapes::Square
          @enemies << Enemy.new(window, "Square", type)
        when Shapes::Triangle
          @enemies << Enemy.new(window, "Triangle", type)
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
      @cooloff = 150 - (@window.player.level * rand(30)) 
    end
    @enemies.each { |b| b.update }

    @window.bullets.check_collisions @enemies.select { |e| e.active? }
  end
end
