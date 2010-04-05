require 'city'

class Country
  attr_accessor :x, :y, :width, :height, :cities, :name
  MinHeight = 7
  MinWidth = 7
  MaxHeight = 10
  MaxWidth = 20
  
  def initialize(x, y, width, height, name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.name = name
    self.create_cities
  end

  def create_cities
    self.cities = []
    i = 1
    y = self.y+2
    while y<self.height+self.y-1 do
      x = self.x+2
      while x<self.width+self.x-1 do
        if rand < 0.35
          self.cities << City.new(x,y, "City#{i}", self.name)
          i += 1
        end
        x += 2
      end
      y += 2
    end

    if self.cities.empty?
      self.cities << City.new(self.x+1,self.y+1, "City#{i}", self.name)
    end
  end
end
