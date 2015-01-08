class BulletCache
  def initialize(window)
    @bullets = []
    while @bullets.size < 30
      @bullets.push(Bullet.new(window))
    end
  end

  def fire(player)
    if player.can_fire?
      player.fire
      bullet = @bullets.select { |b| b.active? == false }.first
      bullet.fire(player) if bullet
    end
  end

  def check_collisions(others)
    active = @bullets.select { |b| b.active? }
    active.each { |b| b.collide(others) }
  end

  def draw
    @bullets.each { |b| b.draw }
  end

  def update
    @bullets.each { |b| b.update }
  end
end
