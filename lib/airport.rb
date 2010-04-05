class Airport
  attr_accessor :links, :city

  def initialize(city)
    self.links = []
    self.city = city
  end

  def to_s
    "#{self.city.country_name}/#{self.city.name}"
  end
end
