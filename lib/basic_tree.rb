class BasicTree

  include Enumerable

  VERSION = "0.1.1"

  def initialize(object, &block)
    self.object = object
    yield self if block_given?
  end

  attr_accessor :object, :parent

  def add(object, &block)
    self.class.new(object) do |child|
      children << child
      child.parent = self
      yield child if block_given?
    end
  end

  def path
    ancestors << self
  end

  def ancestors
    root? ? [] : (parent.ancestors << parent)
  end

  def descendants
    children.map { |c| [c] + c.descendants }.flatten
  end

  def subtree
    [self] + descendants
  end

  def siblings
    root? ? [] : parent.children.select { |child| child != self }
  end

  def root
    path.first
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

  def children
    @children ||= []
  end

end