require 'graph'
require 'algorithms'

class Attacker
  def self.random_attack(graph)
    node = graph.nodes[rand(graph.nodes.count-1)]
    crush_node(graph, node)
  end

  def self.most_connected_attack(graph)
    node = graph.nodes.max { |n1, n2|
      graph.edges.select { |e| e.v_start.id == n1.id || e.v_end.id == n1.id }.count <=>
        graph.edges.select { |e| e.v_start.id == n2.id || e.v_end.id == n2.id }.count }
    crush_node(graph, node)
  end

  def self.most_central_attack(graph)
    node = graph.nodes.select { |n| n.id == Algorithms.betweenness_centrality(graph).max.first }.first
    crush_node(graph, node)
  end

  def self.crush_node(graph, node)
    edges_to_delete = graph.edges.select { |e| e.v_start.id == node.id || e.v_end.id == node.id }
    edges_to_delete.each do |e|
      graph.edges.delete(e)
      graph.dg.remove_edge(e.v_start.to_s, e.v_end.to_s)
    end
  end
end
