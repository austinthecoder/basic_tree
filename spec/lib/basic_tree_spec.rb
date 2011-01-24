require 'spec_helper'

describe BasicTree do

  before do
    @a = BasicTree.new "a" do
      add "a1" do
        add "a11"
        add "a12"
      end
      add "a2"
    end
    @a1 = @a.children[0]
    @a2 = @a.children[1]
    @a11 = @a1.children[0]
    @a12 = @a1.children[1]
  end

  describe "instance methods" do
    before do
      @object = "soccer"
      @bt = BasicTree.new(@object)
    end

    describe "#leaf?" do
      context("with no children") { it { @bt.should be_leaf } }

      context("with children") do
        before { @bt.add("ball") }

        it { @bt.should_not be_leaf }
      end
    end

    describe "#root?" do
      context("with no parent") { it { @bt.should be_root } }

      context("as a child") do
        before { BasicTree.new("sport").add(@bt) }

        it { @bt.should_not be_root }
      end
    end

    describe "#level" do
      it "returns the size of the path" do
        @bt.stub!(:path => 13.times.map(&:to_i))
        @bt.level.should eq(13)
      end
    end

    describe "#root" do
      it "returns the first item in the path" do
        @bt.stub!(:path => [3, 2])
        @bt.root.should eq(3)
      end
    end

    describe "#path" do
      it "returns the ancestors and itself" do
        @bt.stub!(:ancestors => [3, 4])
        @bt.path.should eq([3, 4, @bt])
      end
    end

    describe "#ancestors" do
      context("when root") do
        it("returns empty array") { @bt.ancestors.should eq([]) }
      end

      context "when not root" do
        before { BasicTree.new("Fun Stuff").add("Sports").add(@bt) }

        it "returns parent's path" do
          @bt.ancestors.should eq(@bt.parent.path)
        end
      end
    end

    describe "#children" do
      context "with none" do
        it "returns empty array" do
          @bt.children.should eq([])
        end
      end

      context "with some" do
        before do
          @c1 = @bt.add("c1")
          @c2 = @bt.add("c2")
        end

        it "returns them" do
          @bt.children.should eq([@c1, @c2])
        end
      end
    end

    describe "#descendants" do
      context "with no children" do
        it { @bt.descendants.should eq([]) }
      end

      context "when children exist, and some of them have children" do
        before do
          @ball = @bt.add("ball")
          @size = @ball.add("size")
          @four = @size.add("4")
          @goal = @bt.add("goal")
        end

        it "returns array" do
          @bt.descendants.should eq([@ball, @size, @four, @goal])
        end
      end
    end

    describe "#subtree" do
      before do
        @result = [1, 2, 3]
        @bt.stub!(:descendants => @result)
      end

      it "should add itself to the front of descendants" do
        @bt.descendants.should_receive(:unshift).with(@bt)
        @bt.subtree
      end

      it { @bt.subtree.should eq(@result) }
    end

    describe "#siblings" do
      context "when root" do
        it { @bt.siblings.should eq([]) }
      end

      context "when not root" do
        before do
          @k1 = mock(BasicTree)
          @k2 = mock(BasicTree)

          @bt.stub!(:parent => mock(BasicTree, :kids => [@k1, @bt, @k2]))
        end

        it "returns parent's children (without itself)" do
          @bt.siblings.should eq([@k1, @k2])
        end
      end
    end
  end

end
