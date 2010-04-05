class Node
  attr_accessor :id
  @@actual_id = 1

  def initialize(id=nil)
    if id
      self.id = id
    else
      self.id = @@actual_id
      @@actual_id += 1
    end
  end

  def to_s
    self.id.to_s
  end
end
