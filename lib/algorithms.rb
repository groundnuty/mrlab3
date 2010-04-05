require 'graph'

class Algorithms
  Infinity = 1.0/0

  # Returns hash with distance of the shortest paths to every node from given source.
  #   nodes = [Node.new(1),Node.new(2),Node.new(3),Node.new(4),Node.new(5)]
  #   g = Graph.new(nodes, [[nodes[0],nodes[1],1],[nodes[0],nodes[2],2],[nodes[2],nodes[3],3],[nodes[3],nodes[4],4]])
  #   Algorithms.dijkstra(g, 1) #=> { 1=>0, 2=>1, 3=>2, 4=>5, 5=>9 }
  def self.dijkstra(graph, src)
    dist = {}
    graph.nodes.map { |n| n.id }.each do |n_id|
      dist[n_id] = Infinity
    end
    dist[src.id] = 0
    # all nodes in the graph are unoptimized - thus are in queue
    queue = graph.nodes.map { |n| n.id }
    while !queue.empty?
      # vertex in queue with the smallest distance
      u_id = dist.select { |k,v| queue.include?(k) }.min { |a,b| a[1] <=> b[1] }.first
      if dist[u_id] == Infinity
        # all remaining vertices are inaccessible from source
        break
      end
      queue.delete(u_id)
      queue
      # for all v neighbours of u which has not yet been removed from queue
      graph.edges.select { |e| e.v_start.id == u_id && queue.include?(e.v_end.id) }.map { |e| e.v_end.id }.each do |v_id|
        alt = dist[u_id] + graph.edges.select { |e| e.v_start.id == u_id && e.v_end.id == v_id }.first.weight
        # relax
        dist[v_id] = alt if alt<dist[v_id]
      end
    end
    dist
  end

  # Computes betweenness centrality for every node according to equation
  #   betweenness_centrality(x) = q_s1_t1(x)/q_s1_t1 + ... + q_sn_tn(x)/q_sn_tn
  #
  #   where
  #   q_s_t(x) is the number of shortest paths from s to t that x lies on
  #   q_s_t is the number of shortes paths from s to t
  #   
  # Returns hash node => betweenness
  def self.betweenness_centrality(graph)
    betweenness = {}
    fi = {}
    graph.nodes.map { |n| n.id }.each do |n_id|
      betweenness[n_id] = 0.0
      fi[n_id] = 0.0
    end
    graph.nodes.map { |n| n.id }.each do |s_id|
      stack = []
      p = {}
      q = {}
      d = {}
      graph.nodes.map { |n| n.id }.each do |w_id|
        p[w_id] = []
        q[w_id] = 0.0
        d[w_id] = -1.0
      end
      q[s_id] = 1.0
      d[s_id] = 0.0
      queue = [s_id]
      while !queue.empty?
        v_id = queue.shift
        stack.push(v_id)
        graph.edges.select { |e| e.v_start.id == v_id }.map { |e| e.v_end.id }.each do |w_id|
          # w found for the first time?
          if d[w_id]<0
            queue << w_id
            d[w_id] = d[v_id]+1
          end
          # shortest path to w via v?
          if d[w_id] == d[v_id]+1
            q[w_id] += q[v_id]
            p[w_id] << v_id
          end
        end
      end
      while !stack.empty?
        w_id = stack.pop
        p[w_id].each do |v_id|
          fi[v_id] += (q[v].to_f/q[w_id].to_f)*(1+fi[w_id])
        end
        if w_id != s_id
          betweenness[w_id] += fi[w_id]
        end
      end
    end
    betweenness
  end

  def self.graph_efficiency(graph)
    nodes_count = graph.nodes.count
    shortest_paths_sum = 0
    graph.nodes.each do |src|
      shortest_paths_sum += dijkstra(graph, src).values.inject(0) { |sum, v| sum+(v == 0? 0 : 1.0/v) }
    end
    (1.0/(nodes_count*(nodes_count-1)))*shortest_paths_sum
  end
end
