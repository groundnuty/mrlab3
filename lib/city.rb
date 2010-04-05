require 'airport'
require 'node'

class City < Node
  attr_accessor :x, :y, :airport, :name, :country_name
  
  def initialize(x, y, name, country_name)
    super()
    self.x = x.to_f
    self.y = y.to_f
    self.name = name
    self.country_name = country_name
  end

  def to_s
    "#{self.country_name}/#{self.name}"
  end
end
