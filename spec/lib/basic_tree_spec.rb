require 'spec_helper'

describe BasicTree do

  before do
    @a = BasicTree.new "a" do |a|
      @a1 = a.add "a1" do |a1|
        @a11 = a1.add "a11"
        @a12 = a1.add "a12"
      end
      @a2 = a.add "a2"
    end
  end

  it "path" do
    @a.path.should == [@a]
    @a1.path.should == [@a, @a1]
    @a11.path.should == [@a, @a1, @a11]
    @a12.path.should == [@a, @a1, @a12]
    @a2.path.should == [@a, @a2]
  end

  it "ancestors" do
    @a.ancestors.should == []
    @a1.ancestors.should == [@a]
    @a11.ancestors.should == [@a, @a1]
    @a12.ancestors.should == [@a, @a1]
    @a2.ancestors.should == [@a]
  end

  it "descendants" do
    @a.descendants.should == [@a1, @a11, @a12, @a2]
    @a1.descendants.should == [@a11, @a12]
    @a11.descendants.should == []
    @a12.descendants.should == []
    @a2.descendants.should == []
  end

  it "subtree" do
    @a.subtree.should == [@a, @a1, @a11, @a12, @a2]
    @a1.subtree.should == [@a1, @a11, @a12]
    @a11.subtree.should == [@a11]
    @a12.subtree.should == [@a12]
    @a2.subtree.should == [@a2]
  end

  it "siblings" do
    @a.siblings.should == []
    @a1.siblings.should == [@a2]
    @a11.siblings.should == [@a12]
    @a12.siblings.should == [@a11]
    @a2.siblings.should == [@a1]
  end

  it "root" do
    [@a, @a1, @a11, @a12, @a2].each do |m|
      m.root.should == @a
    end
  end

  it "level" do
    @a.level.should == 1
    @a1.level.should == 2
    @a11.level.should == 3
    @a12.level.should == 3
    @a2.level.should == 2
  end

  it "root?" do
    @a.root?.should be_true
    @a1.root?.should be_false
    @a11.root?.should be_false
    @a12.root?.should be_false
    @a2.root?.should be_false
  end

  it "leaf?" do
    @a.leaf?.should be_false
    @a1.leaf?.should be_false
    @a11.leaf?.should be_true
    @a12.leaf?.should be_true
    @a2.leaf?.should be_true
  end

end
