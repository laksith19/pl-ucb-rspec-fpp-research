require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#flatten" do
  it "returns a one-dimensional flattening recursively" do
    expect([[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []].flatten).to eq([1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4])
  end

  it "takes an optional argument that determines the level of recursion" do
    expect([ 1, 2, [3, [4, 5] ] ].flatten(1)).to eq([1, 2, 3, [4, 5]])
  end

  it "returns dup when the level of recursion is 0" do
    a = [ 1, 2, [3, [4, 5] ] ]
    expect(a.flatten(0)).to eq(a)
    expect(a.flatten(0)).not_to equal(a)
  end

  it "ignores negative levels" do
    expect([ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-1)).to eq([1, 2, 3, 4, 5, 6])
    expect([ 1, 2, [ 3, 4, [5, 6] ] ].flatten(-10)).to eq([1, 2, 3, 4, 5, 6])
  end

  it "tries to convert passed Objects to Integers using #to_int" do
    obj = double("Converted to Integer")
    expect(obj).to receive(:to_int).and_return(1)

    expect([ 1, 2, [3, [4, 5] ] ].flatten(obj)).to eq([1, 2, 3, [4, 5]])
  end

  it "raises a TypeError when the passed Object can't be converted to an Integer" do
    obj = double("Not converted")
    expect { [ 1, 2, [3, [4, 5] ] ].flatten(obj) }.to raise_error(TypeError)
  end

  it "does not call flatten on elements" do
    obj = double('[1,2]')
    expect(obj).not_to receive(:flatten)
    expect([obj, obj].flatten).to eq([obj, obj])

    obj = [5, 4]
    expect(obj).not_to receive(:flatten)
    expect([obj, obj].flatten).to eq([5, 4, 5, 4])
  end

  it "raises an ArgumentError on recursive arrays" do
    x = []
    x << x
    expect { x.flatten }.to raise_error(ArgumentError)

    x = []
    y = []
    x << y
    y << x
    expect { x.flatten }.to raise_error(ArgumentError)
  end

  it "flattens any element which responds to #to_ary, using the return value of said method" do
    x = double("[3,4]")
    expect(x).to receive(:to_ary).at_least(:once).and_return([3, 4])
    expect([1, 2, x, 5].flatten).to eq([1, 2, 3, 4, 5])

    y = double("MyArray[]")
    expect(y).to receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
    expect([y].flatten).to eq([])

    z = double("[2,x,y,5]")
    expect(z).to receive(:to_ary).and_return([2, x, y, 5])
    expect([1, z, 6].flatten).to eq([1, 2, 3, 4, 5, 6])
  end

  it "does not call #to_ary on elements beyond the given level" do
    obj = double("1")
    expect(obj).not_to receive(:to_ary)
    [[obj]].flatten(1)
  end

  ruby_version_is ''...'3.0' do
    it "returns subclass instance for Array subclasses" do
      expect(ArraySpecs::MyArray[].flatten).to be_an_instance_of(ArraySpecs::MyArray)
      expect(ArraySpecs::MyArray[1, 2, 3].flatten).to be_an_instance_of(ArraySpecs::MyArray)
      expect(ArraySpecs::MyArray[1, [2], 3].flatten).to be_an_instance_of(ArraySpecs::MyArray)
      expect(ArraySpecs::MyArray[1, [2, 3], 4].flatten).to eq(ArraySpecs::MyArray[1, 2, 3, 4])
      expect([ArraySpecs::MyArray[1, 2, 3]].flatten).to be_an_instance_of(Array)
    end
  end

  ruby_version_is '3.0' do
    it "returns Array instance for Array subclasses" do
      expect(ArraySpecs::MyArray[].flatten).to be_an_instance_of(Array)
      expect(ArraySpecs::MyArray[1, 2, 3].flatten).to be_an_instance_of(Array)
      expect(ArraySpecs::MyArray[1, [2], 3].flatten).to be_an_instance_of(Array)
      expect(ArraySpecs::MyArray[1, [2, 3], 4].flatten).to eq([1, 2, 3, 4])
      expect([ArraySpecs::MyArray[1, 2, 3]].flatten).to be_an_instance_of(Array)
    end
  end

  it "is not destructive" do
    ary = [1, [2, 3]]
    ary.flatten
    expect(ary).to eq([1, [2, 3]])
  end

  describe "with a non-Array object in the Array" do
    before :each do
      @obj = double("Array#flatten")
      ScratchPad.record []
    end

    it "does not call #to_ary if the method is not defined" do
      expect([@obj].flatten).to eq([@obj])
    end

    it "does not raise an exception if #to_ary returns nil" do
      expect(@obj).to receive(:to_ary).and_return(nil)
      expect([@obj].flatten).to eq([@obj])
    end

    it "raises a TypeError if #to_ary does not return an Array" do
      expect(@obj).to receive(:to_ary).and_return(1)
      expect { [@obj].flatten }.to raise_error(TypeError)
    end

    it "calls respond_to_missing?(:to_ary, true) to try coercing" do
      def @obj.respond_to_missing?(*args) ScratchPad << args; false end
      expect([@obj].flatten).to eq([@obj])
      expect(ScratchPad.recorded).to eq([[:to_ary, true]])
    end

    it "does not call #to_ary if not defined when #respond_to_missing? returns false" do
      def @obj.respond_to_missing?(name, priv) ScratchPad << name; false end

      expect([@obj].flatten).to eq([@obj])
      expect(ScratchPad.recorded).to eq([:to_ary])
    end

    it "calls #to_ary if not defined when #respond_to_missing? returns true" do
      def @obj.respond_to_missing?(name, priv) ScratchPad << name; true end

      expect { [@obj].flatten }.to raise_error(NoMethodError)
      expect(ScratchPad.recorded).to eq([:to_ary])
    end

    it "calls #method_missing if defined" do
      expect(@obj).to receive(:method_missing).with(:to_ary).and_return([1, 2, 3])
      expect([@obj].flatten).to eq([1, 2, 3])
    end
  end

  it "performs respond_to? and method_missing-aware checks when coercing elements to array" do
    bo = BasicObject.new
    expect([bo].flatten).to eq([bo])

    def bo.method_missing(name, *)
      [1,2]
    end

    expect([bo].flatten).to eq([1,2])

    def bo.respond_to?(name, *)
      false
    end

    expect([bo].flatten).to eq([bo])

    def bo.respond_to?(name, *)
      true
    end

    expect([bo].flatten).to eq([1,2])
  end
end

describe "Array#flatten!" do
  it "modifies array to produce a one-dimensional flattening recursively" do
    a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
    a.flatten!
    expect(a).to eq([1, 2, 3, 2, 3, 4, 4, 5, 5, 1, 2, 3, 4])
  end

  it "returns self if made some modifications" do
    a = [[[1, [2, 3]],[2, 3, [4, [4, [5, 5]], [1, 2, 3]]], [4]], []]
    expect(a.flatten!).to equal(a)
  end

  it "returns nil if no modifications took place" do
    a = [1, 2, 3]
    expect(a.flatten!).to eq(nil)
    a = [1, [2, 3]]
    expect(a.flatten!).not_to eq(nil)
  end

  it "should not check modification by size" do
    a = [1, 2, [3]]
    expect(a.flatten!).not_to eq(nil)
    expect(a).to eq([1, 2, 3])
  end

  it "takes an optional argument that determines the level of recursion" do
    expect([ 1, 2, [3, [4, 5] ] ].flatten!(1)).to eq([1, 2, 3, [4, 5]])
  end

  # redmine #1440
  it "returns nil when the level of recursion is 0" do
    a = [ 1, 2, [3, [4, 5] ] ]
    expect(a.flatten!(0)).to eq(nil)
  end

  it "treats negative levels as no arguments" do
    expect([ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-1)).to eq([1, 2, 3, 4, 5, 6])
    expect([ 1, 2, [ 3, 4, [5, 6] ] ].flatten!(-10)).to eq([1, 2, 3, 4, 5, 6])
  end

  it "tries to convert passed Objects to Integers using #to_int" do
    obj = double("Converted to Integer")
    expect(obj).to receive(:to_int).and_return(1)

    expect([ 1, 2, [3, [4, 5] ] ].flatten!(obj)).to eq([1, 2, 3, [4, 5]])
  end

  it "raises a TypeError when the passed Object can't be converted to an Integer" do
    obj = double("Not converted")
    expect { [ 1, 2, [3, [4, 5] ] ].flatten!(obj) }.to raise_error(TypeError)
  end

  it "does not call flatten! on elements" do
    obj = double('[1,2]')
    expect(obj).not_to receive(:flatten!)
    expect([obj, obj].flatten!).to eq(nil)

    obj = [5, 4]
    expect(obj).not_to receive(:flatten!)
    expect([obj, obj].flatten!).to eq([5, 4, 5, 4])
  end

  it "raises an ArgumentError on recursive arrays" do
    x = []
    x << x
    expect { x.flatten! }.to raise_error(ArgumentError)

    x = []
    y = []
    x << y
    y << x
    expect { x.flatten! }.to raise_error(ArgumentError)
  end

  it "flattens any elements which responds to #to_ary, using the return value of said method" do
    x = double("[3,4]")
    expect(x).to receive(:to_ary).at_least(:once).and_return([3, 4])
    expect([1, 2, x, 5].flatten!).to eq([1, 2, 3, 4, 5])

    y = double("MyArray[]")
    expect(y).to receive(:to_ary).at_least(:once).and_return(ArraySpecs::MyArray[])
    expect([y].flatten!).to eq([])

    z = double("[2,x,y,5]")
    expect(z).to receive(:to_ary).and_return([2, x, y, 5])
    expect([1, z, 6].flatten!).to eq([1, 2, 3, 4, 5, 6])

    ary = [ArraySpecs::MyArray[1, 2, 3]]
    ary.flatten!
    expect(ary).to be_an_instance_of(Array)
    expect(ary).to eq([1, 2, 3])
  end

  it "raises a FrozenError on frozen arrays when the array is modified" do
    nested_ary = [1, 2, []]
    nested_ary.freeze
    expect { nested_ary.flatten! }.to raise_error(FrozenError)
  end

  # see [ruby-core:23663]
  it "raises a FrozenError on frozen arrays when the array would not be modified" do
    expect { ArraySpecs.frozen_array.flatten! }.to raise_error(FrozenError)
    expect { ArraySpecs.empty_frozen_array.flatten! }.to raise_error(FrozenError)
  end
end
