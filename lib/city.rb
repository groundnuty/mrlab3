require 'airport'

class City
  attr_accessor :x, :y, :airport, :name, :country_name
  
  def initialize(x, y, name, country_name)
    self.x = x.to_f
    self.y = y.to_f
    self.name = name
    self.country_name = country_name
  end
end
