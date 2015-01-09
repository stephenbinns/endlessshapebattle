class EnemyCache
  def initialize(window)
    @window = window
    @enemies = []
    while @enemies.size < 30
      type = @enemies.size % 3
      case type
        when 0
          @enemies << Enemy.new(window, "Circle", type)
        when 1
          @enemies << Enemy.new(window, "Square", type)
        when 2
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
    chance = rand(30)

    spawn if chance < 1
    @enemies.each { |b| b.update }

    @window.bullets.check_collisions @enemies.select { |e| e.active? }
  end
end
