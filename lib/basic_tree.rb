require 'active_support/core_ext/object'

class BasicTree

  include Enumerable

  VERSION = "1.0.0"

  class Kids < Array
    def swap!(p1, p2)
      self[p1], self[p2] = self[p2], self[p1]
    end
  end

  ##################################################

  # TODO: test
  def initialize(object, parent = nil, &block)
    self.object = object
    parent.try(:insert!, self)
    instance_eval(&block) if block_given?
  end

  # TODO: test
  def add(object, &block)
    if object.is_a?(self.class)
      insert!(object)
    else
      self.class.new(object, self, &block)
    end
  end

  # TODO: test
  def insert!(basic_tree)
    raise ArgumentError, "Must be a #{self.class}" unless basic_tree.is_a?(self.class)
    basic_tree.send(:parent=, self)
    kids << basic_tree
  end

  # TODO: self
  def remove!(basic_tree)
    raise ArgumentError, "Must be a #{self.class}" unless basic_tree.is_a?(self.class)
    raise StandardError, "Can't remove root" if root?
    parent.send(:kids).delete(self)
    basic_tree.send(:parent=, nil)
  end

  # TODO: test
  def move_up!
    raise "Already first" if first?
    parent.send(:kids).swap!(position, position - 1)
  end

  # TODO: test
  def move_down!
    raise "Already last" if last?
    parent.send(:kids).swap!(position, position + 1)
  end

  ##################################################

  def children
    kids.dup
  end

  def path
    ancestors << self
  end

  def ancestors
    root? ? [] : (parent.ancestors << parent)
  end

  def descendants
    d = []
    kids.each { |k| d += k.descendants.unshift(k) }
    d
  end

  def subtree
    descendants.unshift(self)
  end

  def siblings_and_self
    root? ? [self] : parent.children
  end

  def siblings
    root? ? [] : siblings_and_self.delete_if { |s| s == self }
  end

  ##################################################

  attr_reader :parent
  attr_accessor :object

  def root
    path.first
  end

  def level
    path.size
  end

  def position
    siblings_and_self.index(self)
  end

  ##################################################

  def root?
    !parent
  end

  def leaf?
    kids.empty?
  end

  def first?
    root? || siblings_and_self[0] == self
  end

  def last?
    root? || siblings_and_self.last == self
  end

  ##################################################
  private

  attr_writer :parent

  def kids
    @kids ||= Kids.new
  end

end