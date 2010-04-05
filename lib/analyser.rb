require 'rubygems'
require 'attacker'
require 'gruff'
require 'world'
require 'fileutils'

class Analyser
  def self.analize_attacks
    world = World.new(80,40)
    world.print
    world.create_airport_network

    # random attack
    analize_attack(world, Proc.new { |graph| Attacker.random_attack(graph) }, "random", "random_attack")

    # most connected attack
    analize_attack(world, Proc.new { |graph| Attacker.most_connected_attack(graph) }, "most connected", "most_connected_attack")

    # most central attack
    analize_attack(world, Proc.new { |graph| Attacker.most_central_attack(graph) }, "most central", "most_central_attack")
  end

  def self.analize_attack(world, attack, attack_name, dir_name)
    graph = world.dup.to_graph
    efficiency = [Algorithms.graph_efficiency(graph)]
    file_name = File.join('..', 'images', "#{dir_name}", 'before_attack')
    graph.to_png(file_name)
    5.times do |i|
      attack.call(graph)
      file_name = File.join('..', 'images', "#{dir_name}", "after_attack_#{i+1}")
      graph.to_png(file_name)
      efficiency << Algorithms.graph_efficiency(graph)
    end
    file_name = File.join('..', 'images', "#{dir_name}", 'efficiency_chart.png')
    draw_efficiency_chart("#{attack_name} attack".upcase, "#{attack_name} attacks", efficiency, file_name)

    file_path = File.join('..', 'images', "#{dir_name}", "*.dot")
    `rm -f #{file_path}`
  end

  def self.draw_efficiency_chart(title, x_label, efficiency, file_name)
    bar = Gruff::Bar.new

    bar.title = title
    bar.x_axis_label = x_label
    bar.y_axis_label = "efficiency"

    efficiency.each_with_index do |e, i|
      bar.data(i, e)
    end

    dest = File.join('..', 'images', file_name)
    bar.write(dest)
  end
end

Analyser.analize_attacks
