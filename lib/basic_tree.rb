class BasicTree
  class Children
    include Enumerable
  
    def each(&block)
      trees.each(&block)
    end
    
    def empty?
      trees.empty?
    end
  
    private
  
    def trees
      @trees ||= []
    end
  
    def <<(tree)
      trees << tree
    end
  end
  
  include Enumerable
  
  def initialize(object, &block)
    self.object = object
    yield self if block_given?
  end
  
  attr_accessor :object
  attr_reader :parent
  
  def add(object, &block)
    self.class.new(object) do |child|
      children.send(:<<, child)
      child.send(:parent=, self)
      yield child if block_given?
    end
  end
  
  def each(&block)
    children.each(&block)
  end
  
  def path
    ancestors << self
  end
  
  def ancestors
    root? ? [] : (parent.ancestors << parent)
  end
  
  def descendants(depth = -1)
    trees = []
    if depth != 0
      children.each do |child|
        trees << child
        trees += child.descendants(depth - 1)
      end
    end
    trees
  end
  
  def subtree(depth = -1)
    [self] + descendants(depth)
  end
  
  def siblings
    parent.children.select { |child| child != self }
  end
  
  def root
    ancestors.first
  end
  
  def level
    path.size
  end
  
  def root?
    !parent
  end
  
  def leaf?
    children.empty?
  end
  
  def leaves
    trees = []
    children.each do |child|
      child.leaf? ? (trees << child) : (trees += child.leaves)
    end
    trees
  end
  
  private
  
  attr_writer :parent
  
  def children
    @children ||= Children.new
  end
  
end