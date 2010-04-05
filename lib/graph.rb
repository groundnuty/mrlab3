require 'rubygems'
require 'node'
require 'edge'
require 'rgl/adjacency'
require 'rgl/dot'

class Graph
  attr_accessor :nodes, :edges, :dg

  # Creates graph from given array of nodes and edges represented as three-element array - start node, end node and weight.
  def initialize(nodes, edges)
    super()
    self.nodes = nodes
    self.edges = edges.map { |e| Edge.new(e[0], e[1], e[2]) }

    self.build
  end

  def build
    self.dg = RGL::DirectedAdjacencyGraph.new
    self.nodes.each do |n|
      self.dg.add_vertex(n.to_s)
    end
    self.edges.each do |e|
      self.dg.add_edge(e.v_start.to_s, e.v_end.to_s)
    end
  end

  def to_png(file_name='graph')
    self.dg.write_to_graphic_file('png', file_name)
  end
end
