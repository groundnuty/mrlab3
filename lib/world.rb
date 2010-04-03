require 'country'

class World
  attr_accessor :width, :height, :countries
  
  def initialize(width, height)
    raise "width and height must be at least 3" if width<3 || height<3
    self.width = width
    self.height = height
    self.countries = create_countries
  end

  def create_countries
    countries = []
    y = 0
    rows = rand(self.height-1)+1
    country_height = self.height/rows.to_f
    while country_height<3 do
      rows = rand(self.height-1)+1
      country_height = self.height/rows.to_f
    end
    
    rows.times do
      x = 0
      cols = rand(self.width-1)+1
      country_width = self.width/cols.to_f
      while country_width<3 do
        cols = rand(self.width-1)+1
        country_width = self.width/cols.to_f
      end
      cols.times do
        countries << Country.new(x, y, country_width, country_height)
        x += country_width
      end
      y += country_height
    end
    countries
  end
end
