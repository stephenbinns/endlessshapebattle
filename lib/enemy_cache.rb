class EnemyCache
  def initialize(window)
    @window = window
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
    enemy = @enemies.select { |b| b.active? == false }.first
    enemy.spawn if enemy
  end

  def draw
    @enemies.each { |b| b.draw }
  end

  def update
    chance = rand(150)

    spawn if chance < @window.player.level
    @enemies.each { |b| b.update }

    @window.bullets.check_collisions @enemies.select { |e| e.active? }
  end
end
