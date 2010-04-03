require 'city'

class Country
  attr_accessor :x, :y, :width, :height, :cities
  
  def initialize(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.cities = create_cities
  end

  def create_cities
    cities = []
    y = 0
    while y<self.height do
      x = 0
      while x<self.width do
        if rand < 0.35
          cities << City.new(x,y)
        end
        x += 2
      end
      y += 2
    end
    cities
  end
end
