class Airport
  attr_accessor :x, :y, :links, :country_name, :city_name

  def initialize(x, y, country_name, city_name)
    self.x = x.to_f
    self.y = y.to_f
    self.links = []
    self.country_name = country_name
    self.city_name = city_name
  end

  def to_s
    "#{self.country_name}/#{self.city_name}"
  end
end
