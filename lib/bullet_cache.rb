class BulletCache
  def initialize(window, player)
    @bullets = []
    while @bullets.size < 30
      @bullets.push(Bullet.new(window, player))
    end
  end

  def fire(player)
    return unless player.can_fire?

    player.fire
    bullet = @bullets.select { |b| b.active? == false }.first
    bullet.fire(player) if bullet
  end

  def check_collisions(others)
    active = @bullets.select(&:active?)
    active.each { |b| b.collide(others.select { |o| o.type == b.type }) }
  end

  def draw
    @bullets.each(&:draw)
  end

  def update
    @bullets.each(&:update)
  end
end
