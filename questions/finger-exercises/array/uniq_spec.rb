require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#uniq" do
  it "returns an array with no duplicates" do
    expect(["a", "a", "b", "b", "c"].uniq).to eq(["a", "b", "c"])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.uniq).to eq([empty])

    array = ArraySpecs.recursive_array
    expect(array.uniq).to eq([1, 'two', 3.0, array])
  end

  it "uses eql? semantics" do
    expect([1.0, 1].uniq).to eq([1.0, 1])
  end

  it "compares elements first with hash" do
    x = double('0')
    expect(x).to receive(:hash).at_least(1).and_return(0)
    y = double('0')
    expect(y).to receive(:hash).at_least(1).and_return(0)

    expect([x, y].uniq).to eq([x, y])
  end

  it "does not compare elements with different hash codes via eql?" do
    x = double('0')
    expect(x).not_to receive(:eql?)
    y = double('1')
    expect(y).not_to receive(:eql?)

    expect(x).to receive(:hash).at_least(1).and_return(0)
    expect(y).to receive(:hash).at_least(1).and_return(1)

    expect([x, y].uniq).to eq([x, y])
  end

  it "compares elements with matching hash codes with #eql?" do
    a = Array.new(2) do
      obj = double('0')
      expect(obj).to receive(:hash).at_least(1).and_return(0)

      def obj.eql?(o)
        false
      end

      obj
    end

    expect(a.uniq).to eq(a)

    a = Array.new(2) do
      obj = double('0')
      expect(obj).to receive(:hash).at_least(1).and_return(0)

      def obj.eql?(o)
        true
      end

      obj
    end

    expect(a.uniq.size).to eq(1)
  end

  it "compares elements based on the value returned from the block" do
    a = [1, 2, 3, 4]
    expect(a.uniq { |x| x >= 2 ? 1 : 0 }).to eq([1, 2])
  end

  it "yields items in order" do
    a = [1, 2, 3]
    yielded = []
    a.uniq { |v| yielded << v }
    expect(yielded).to eq(a)
  end

  it "handles nil and false like any other values" do
    expect([nil, false, 42].uniq { :foo }).to eq([nil])
    expect([false, nil, 42].uniq { :bar }).to eq([false])
  end

  ruby_version_is ''...'3.0' do
    it "returns subclass instance on Array subclasses" do
      expect(ArraySpecs::MyArray[1, 2, 3].uniq).to be_an_instance_of(ArraySpecs::MyArray)
    end
  end

  ruby_version_is '3.0' do
    it "returns Array instance on Array subclasses" do
      expect(ArraySpecs::MyArray[1, 2, 3].uniq).to be_an_instance_of(Array)
    end
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = double('x')
    expect(x).to receive(:hash).at_least(1).and_return(42)
    allow(x).to receive(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    expect([x, x].uniq).to eq([x])
  end

  describe "given an array of BasicObject subclasses that define ==, eql?, and hash" do
    # jruby/jruby#3227
    it "filters equivalent elements using those definitions" do

      basic = Class.new(BasicObject) do
        attr_reader :x

        def initialize(x)
          @x = x
        end

        def ==(rhs)
          @x == rhs.x
        end
        alias_method :eql?, :==

        def hash
          @x.hash
        end
      end

      a = [basic.new(3), basic.new(2), basic.new(1), basic.new(4), basic.new(1), basic.new(2), basic.new(3)]
      expect(a.uniq).to eq([basic.new(3), basic.new(2), basic.new(1), basic.new(4)])
    end
  end
end

describe "Array#uniq!" do
  it "modifies the array in place" do
    a = [ "a", "a", "b", "b", "c" ]
    a.uniq!
    expect(a).to eq(["a", "b", "c"])
  end

  it "returns self" do
    a = [ "a", "a", "b", "b", "c" ]
    expect(a).to equal(a.uniq!)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty_dup = empty.dup
    empty.uniq!
    expect(empty).to eq(empty_dup)

    array = ArraySpecs.recursive_array
    expected = array[0..3]
    array.uniq!
    expect(array).to eq(expected)
  end

  it "compares elements first with hash" do
    x = double('0')
    expect(x).to receive(:hash).at_least(1).and_return(0)
    y = double('0')
    expect(y).to receive(:hash).at_least(1).and_return(0)

    a = [x, y]
    a.uniq!
    expect(a).to eq([x, y])
  end

  it "does not compare elements with different hash codes via eql?" do
    x = double('0')
    expect(x).not_to receive(:eql?)
    y = double('1')
    expect(y).not_to receive(:eql?)

    expect(x).to receive(:hash).at_least(1).and_return(0)
    expect(y).to receive(:hash).at_least(1).and_return(1)

    a = [x, y]
    a.uniq!
    expect(a).to eq([x, y])
  end

  it "returns nil if no changes are made to the array" do
    expect([ "a", "b", "c" ].uniq!).to eq(nil)
  end

  it "raises a FrozenError on a frozen array when the array is modified" do
    dup_ary = [1, 1, 2]
    dup_ary.freeze
    expect { dup_ary.uniq! }.to raise_error(FrozenError)
  end

  # see [ruby-core:23666]
  it "raises a FrozenError on a frozen array when the array would not be modified" do
    expect { ArraySpecs.frozen_array.uniq!}.to raise_error(FrozenError)
    expect { ArraySpecs.empty_frozen_array.uniq!}.to raise_error(FrozenError)
  end

  it "doesn't yield to the block on a frozen array" do
    expect { ArraySpecs.frozen_array.uniq!{ raise RangeError, "shouldn't yield"}}.to raise_error(FrozenError)
  end

  it "compares elements based on the value returned from the block" do
    a = [1, 2, 3, 4]
    expect(a.uniq! { |x| x >= 2 ? 1 : 0 }).to eq([1, 2])
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = double('x')
    expect(x).to receive(:hash).at_least(1).and_return(42)
    allow(x).to receive(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    a = [x, x]
    a.uniq!
    expect(a).to eq([x])
  end
end
