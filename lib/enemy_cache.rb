class EnemyCache
  def initialize(window)
    @enemies = []
    while @enemies.size < 30
      type = @enemies.size % 3
      case type
        when 0
          @enemies << Enemy.new(window, "Circle")
        when 1
          @enemies << Enemy.new(window, "Square")
        when 2
          @enemies << Enemy.new(window, "Triangle")
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

  def update(bullets)
    chance = rand(30)

    spawn if chance < 5
    @enemies.each { |b| b.update }

    bullets.check_collisions @enemies
  end
end
