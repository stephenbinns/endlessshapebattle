class Shockwave
  attr_reader :shader

  def age
    (Gosu.milliseconds - @start_time) / 1000.0
  end

  def dead?
    age > 3.0
  end

  def initialize(x, y)
    @shader = Ashton::Shader.new fragment: :shockwave, uniforms: {
      shock_params: [10.0, 0.8, 0.1], # Not entirely sure what these represent!
      center: [x, y]
    }
    @start_time = Gosu.milliseconds
  end

  def update
    @shader.time = age
  end
end
