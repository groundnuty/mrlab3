require 'graph'
require 'algorithms'

describe Algorithms do
  it "should returns hash with proper distances" do
    g = Graph.new([1,2,3,4,5], [[1,2,1],[1,3,2],[3,4,3],[4,5,4]])
    Algorithms.dijkstra(g, 1).should == { 1=>0, 2=>1, 3=>2, 4=>5, 5=>9 }
  end

  it "should count graph efficiency properly" do
    g = Graph.new([1,2,3,4,5], [[1,2,1],[1,3,1],[3,4,1],[4,5,1],[2,1,1],[3,1,1],[4,3,1],[5,4,1]])
    ((Algorithms.graph_efficiency(g).to_f*100).to_f.truncate/100.0).should == ((12 + 5.0/6)*(1.0/(5*4))*100).to_f.truncate/100.0
  end
end

