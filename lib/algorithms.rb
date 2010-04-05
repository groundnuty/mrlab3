require 'graph'

class Algorithms
  Infinity = 1.0/0

  # Returns hash with distance of the shortest paths to every node from given source.
  #   g = Graph.new([1,2,3,4,5], [[1,2,1],[1,3,2],[3,4,3],[4,5,4]])
  #   Algorithms.dijkstra(g, 1) #=> { 1=>0, 2=>1, 3=>2, 4=>5, 5=>9 }
  def self.dijkstra(graph, src)
    dist = {}
    graph.nodes.each do |n|
      dist[n] = Infinity
    end
    dist[src] = 0
    # all nodes in the graph are unoptimized - thus are in queue
    queue = graph.nodes.dup
    while !queue.empty?
      # vertex in queue with the smallest distance
      u = dist.select { |k,v| queue.include?(k) }.min { |a,b| a[1] <=> b[1] }.first
      if dist[u] == Infinity
        # all remaining vertices are inaccessible from source
        break
      end
      queue.delete(u)
      queue
      # for all v neighbours of u which has not yet been removed from queue
      graph.edges.select { |e| e.v_start == u && queue.include?(e.v_end) }.map { |e| e.v_end }.each do |v|
        alt = dist[u] + graph.edges.select { |e| e.v_start == u && e.v_end == v }.first.weight
        # relax
        dist[v] = alt if alt<dist[v]
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
    graph.nodes.each do |n|
      betweenness[n] = 0.0
      fi[n] = 0.0
    end
    graph.nodes.each do |s|
      stack = []
      p = {}
      q = {}
      d = {}
      graph.nodes.each do |w|
        p[w] = []
        q[w] = 0.0
        d[w] = -1.0
      end
      q[s] = 1.0
      d[s] = 0.0
      queue = [s]
      while !queue.empty?
        v = queue.shift
        stack.push(v)
        graph.edges.select { |e| e.v_start == v }.map { |e| e.v_end }.each do |w|
          # w found for the first time?
          if d[w]<0
            queue << w
            d[w] = d[v]+1
          end
          # shortest path to w via v?
          if d[w] == d[v]+1
            q[w] += q[v]
            p[w] << v
          end
        end
      end
      while !stack.empty?
        w = stack.pop
        p[w].each do |v|
          fi[v] += (q[v].to_f/q[w].to_f)*(1+fi[w])
        end
        if w != s
          betweenness[w] += fi[w]
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
