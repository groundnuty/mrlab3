require 'airport'

class City
  attr_accessor :x, :y, :airport
  
  def initialize(x, y)
    self.x = x
    self.y = y
  end
end
