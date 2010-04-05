require 'rubygems'
require 'country'
require 'node_pair'
require 'graph'

class World
  attr_accessor :max_width, :max_height, :countries

  def initialize(max_width, max_height)
    self.max_width = max_width
    self.max_height = max_height
    self.create_countries
  end

  def create_countries
    self.countries = []
    i = 1
    y = 0
    begin
      country_height = rand(Country::MaxHeight-Country::MinHeight)+Country::MinHeight
      x = 0
      begin
        country_width = rand(Country::MaxWidth-Country::MinWidth)+Country::MinWidth
        self.countries << Country.new(x, y, country_width, country_height, "Country#{i}")
        i += 1
        x += country_width
      end while x<self.max_width
      y += country_height
    end while y<self.max_height
  end

  def create_airport_network
    # first airports
    self.countries.each do |country|
      city = country.cities.first
      city.airport = Airport.new(city)
    end
    
    all_cities = self.all_cities
    # only a few (not more than 10%) airports are connected to airports in other countries
    self.countries.each do |country|
      begin
        pairs_for_link = []
        pairs_for_add = []
        country.cities.each do |city|
          if city.airport
            all_cities.select { |c| c.country_name != city.country_name && c.airport }.each do |c|
              pairs_for_link << NodePair.new(city.airport, c.airport)
            end

            all_cities.select { |c| c.country_name != city.country_name && c.airport == nil }.each do |c|
              pairs_for_add << NodePair.new(city.airport, c)
            end
          else
            all_cities.select { |c| c.country_name != city.country_name && c.airport }.each do |c|
              pairs_for_add << NodePair.new(c.airport, city)
            end
          end
        end
        add_airport_or_link(pairs_for_add, pairs_for_link)
        country_airports = country.cities.map { |c| c.airport }
      end while country_airports.count < 0.1*country.cities.count && !pairs_for_add.empty? && !pairs_for_link.empty?
    end
    # the rest are connected only in country
    # but not every city has an airport
    # by our choice 70% cities of each country has an airport
    self.countries.each do |country|
      begin
        pairs_for_link = []
        pairs_for_add = []
        country.cities.select { |c| c.airport }.each do |c1|
          country.cities.select { |c| c.name != c1.name }.each do |c2|
            if c2.airport
              pairs_for_link << NodePair.new(c1.airport, c2.airport)
            else
              pairs_for_add << NodePair.new(c1.airport, c2)
            end
          end
        end
        add_airport_or_link(pairs_for_add, pairs_for_link)
        country_airports = country.cities.map { |c| c.airport }
      end while country_airports.count < 0.7*country.cities.count && !pairs_for_add.empty? && !pairs_for_link.empty?
    end

    visualize
  end

  def add_airport_or_link(pairs_for_add, pairs_for_link)
    return if pairs_for_add.empty? || pairs_for_link.empty?
    if rand<0.65
      # establish new link between two existing nodes
      pairs = pairs_for_link
      pairs.each do |pair|
        a1 = pair.a1
        a2 = pair.a2
        distance = Math.sqrt((a1.city.x-a2.city.x)**2+(a1.city.y-a2.city.y)**2)
        # params of choice
        # r = 1
        # F(d) = d^r
        r = 1
        pair.probability = (a1.links.count*a2.links.count).to_f/((distance**r).to_f > 0 ? (distance**r).to_f : 1)
        probability = probability
      end
      pairs.sort! { |p1, p2| p1.probability <=> p2.probability }
      j = 0
      while j<pairs.size && rand>pairs[j].probability
        j += 1
      end
      pair = pairs[j-1]
      pair.a1.links << pair.a2
      pair.a2.links << pair.a1
    else
      # add new node and connect it to existing node
      pairs = pairs_for_add
      pairs.each do |pair|
        a = pair.a1
        c = pair.a2
        distance = Math.sqrt((a.city.x-c.x)**2+(a.city.y-c.y)**2)
        # params of choice
        # r = 1
        # F(d) = d^r
        r = 1
        pair.probability = a.links.count.to_f/((distance**r).to_f > 0 ? (distance**r).to_f : 1)
      end
      pairs.sort! { |p1, p2| p1.probability <=> p2.probability }
      j = 0
      while j<pairs.size && rand>pairs[j].probability
        j += 1
      end

      pair = pairs[j-1]
      new_airport = Airport.new(pair.a2)
      pair.a2.airport = new_airport
      new_airport.links << pair.a1
      pair.a1.links << new_airport
    end
  end
  
  def all_cities
    self.countries.map { |c| c.cities }.inject([]) { |cities, c| cities+c }
  end

  def to_graph
    nodes = self.all_cities
    edges = []
    nodes.select { |n| n.airport }.each do |c|
      c.airport.links.each do |link|
        distance = Math.sqrt((link.city.x-c.x)**2+(link.city.y-c.y)**2)
        edges << [c, link.city, distance]
      end
    end
    Graph.new(nodes, edges)
  end

  def visualize
    dest = File.join('..','images','graph')
    self.to_graph.to_png(dest)
  end

  def print
    # clrscr
    printf "\033[2J"
    self.countries.each do |c|
      # draw cities
      c.cities.each do |city|
        printf "\033[#{city.y.to_i};#{city.x.to_i}H"
        printf "c"
      end

      # draw country boundaries
      y = c.y
      while y < c.height+c.y do
        printf "\033[#{y.to_i};#{c.x.to_i}H"
        printf "x"

        printf "\033[#{y.to_i};#{c.x.to_i+c.width.to_i}H"
        printf "x"
        y += 1
      end
      x = c.x
      while x<c.width+c.x do
        printf "\033[#{c.y.to_i};#{x.to_i}H"
        printf "x"

        printf "\033[#{c.y.to_i+c.height.to_i};#{x.to_i}H"
        printf "x"
        x += 1
      end
    end
    puts
  end
end
