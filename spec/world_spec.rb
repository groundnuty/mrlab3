require 'world'

describe World do
  before(:each) do
    @world = World.new(20, 20)
  end

  it "should create countries properly" do
    country = @world.countries.select { |c| c.x == 0 && c.y == 0 }.first
    h = 0
    while h<@world.height do
      w = 0
      while w<@world.width do
        @world.countries.select { |c| c.x == w+country.width && c.y == h}.should_not be_nil
        w += country.width
      end
      h += country.height
    end
  end
end

