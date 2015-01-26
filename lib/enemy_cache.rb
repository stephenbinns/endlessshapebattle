class EnemyCache
  def initialize(window, player, bullets, game_view)
    @window = window
    @player = player
    @bullets = bullets
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
    @spawner = RandomSpawner.new @enemies, @player
    @bonus = false
  end

  def draw
    @enemies.each(&:draw)
  end

  def bomb
    @enemies.select(&:active?).each(&:collided)
  end

  def bonus
    @bonus = true
    @bonus_spawn = BonusSpawner.new @enemies, @player
    puts "bonus time"
  end

  def update
    if @bonus
      @bonus_spawn.update
      @bonus = !@bonus_spawn.dead?
    else
      @spawner.update
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
        @game.notify "Shoot Triangles with C", false unless @triangle_spawned
        @triangle_spawned = true
      end
    end
  end
end

class RandomSpawner
  def initialize(enemies, player)
    @enemies = enemies
    @player = player
    @exclude_type = []
    @exclude_type << Shapes::Triangle
    @cooloff = 0
  end

  def spawn
    if @player.level > 3
      @exclude_type = []
    end

    enemy = @enemies.select { |b| b.active? == false }
                    .select { |b| @exclude_type.member?(b.type) == false }
                    .shuffle.first

    enemy.spawn if enemy
  end

  def update
    @cooloff -= 1
    if @cooloff <= 0
      spawn
      @cooloff = [150 - (@player.level * rand(30)), 30].max
    end
  end
end

class BonusSpawner
  def initialize(enemies, player)
    @enemies = enemies
    @player = player
    @bonus_type = [Shapes::Triangle, Shapes::Square, Shapes::Circle].shuffle.first
    @cooloff = 0
    @index = 0
    @increment = false
    @number_to_spawn = player.level * 5
  end

  def spawn
    enemy = @enemies.select { |b| b.active? == false }
                    .select { |b| b.type == @bonus_type }
                    .shuffle.first

    if @increment
      @index += 1
      @increment = @index < 5
      @index = [@index, 5].min
    else
      @index -= 1
      @increment = @index <= 0
      @index = [@index, 0].max
    end

    enemy.spawn_at @index if enemy
    @number_to_spawn -= 1
  end

  def update
    @cooloff -= 1
    if @cooloff <= 0
      spawn
      @cooloff = 50
    end
  end

  def dead?
    @number_to_spawn == 0
  end
end
