require 'graph'
require 'algorithms'

describe Algorithms do
  before(:each) do
    @nodes = [Node.new(1),Node.new(2),Node.new(3),Node.new(4),Node.new(5)]
  end
  
  it "should returns hash with proper distances" do
    g = Graph.new(@nodes, [[@nodes[0],@nodes[1],1],[@nodes[0],@nodes[2],2],[@nodes[2],@nodes[3],3],[@nodes[3],@nodes[4],4]])
    Algorithms.dijkstra(g, @nodes[0]).should == { 1=>0, 2=>1, 3=>2, 4=>5, 5=>9 }
  end

  it "should count graph efficiency properly" do
    g = Graph.new(
      @nodes,
      [
        [@nodes[0],@nodes[1],1],[@nodes[0],@nodes[2],1],[@nodes[2],@nodes[3],1],[@nodes[3],@nodes[4],1],
        [@nodes[1],@nodes[0],1],[@nodes[2],@nodes[0],1],[@nodes[3],@nodes[2],1],[@nodes[4],@nodes[3],1]
      ]
    )
    ((Algorithms.graph_efficiency(g).to_f*100).to_f.truncate/100.0).should == ((12 + 5.0/6)*(1.0/(5*4))*100).to_f.truncate/100.0
  end
end

