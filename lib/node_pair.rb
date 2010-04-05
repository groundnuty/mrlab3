class NodePair
  attr_accessor :a1, :a2, :probability
  def initialize(a1, a2)
    self.a1 = a1
    self.a2 = a2
    self.probability = 0
  end
end
