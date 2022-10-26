require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#initialize" do
  before :each do
    ScratchPad.clear
  end

  it "is private" do
    expect(Array).to have_private_instance_method("initialize")
  end

  it "is called on subclasses" do
    b = ArraySpecs::SubArray.new :size_or_array, :obj

    expect(b).to eq([])
    expect(ScratchPad.recorded).to eq([:size_or_array, :obj])
  end

  it "preserves the object's identity even when changing its value" do
    a = [1, 2, 3]
    expect(a.send(:initialize)).to equal(a)
    expect(a).not_to eq([1, 2, 3])
  end

  it "raises an ArgumentError if passed 3 or more arguments" do
    expect do
      [1, 2].send :initialize, 1, 'x', true
    end.to raise_error(ArgumentError)
    expect do
      [1, 2].send(:initialize, 1, 'x', true) {}
    end.to raise_error(ArgumentError)
  end

  it "raises a FrozenError on frozen arrays" do
    expect do
      ArraySpecs.frozen_array.send :initialize
    end.to raise_error(FrozenError)
    expect do
      ArraySpecs.frozen_array.send :initialize, ArraySpecs.frozen_array
    end.to raise_error(FrozenError)
  end

  it "calls #to_ary to convert the value to an array, even if it's private" do
    a = ArraySpecs::PrivateToAry.new
    expect([].send(:initialize, a)).to eq([1, 2, 3])
  end
end

describe "Array#initialize with no arguments" do
  it "makes the array empty" do
    expect([1, 2, 3].send(:initialize)).to be_empty
  end

  it "does not use the given block" do
    expect{ [1, 2, 3].send(:initialize) { raise } }.not_to raise_error
  end
end

describe "Array#initialize with (array)" do
  it "replaces self with the other array" do
    b = [4, 5, 6]
    expect([1, 2, 3].send(:initialize, b)).to eq(b)
  end

  it "does not use the given block" do
    expect{ [1, 2, 3].send(:initialize) { raise } }.not_to raise_error
  end

  it "calls #to_ary to convert the value to an array" do
    a = double("array")
    expect(a).to receive(:to_ary).and_return([1, 2])
    expect(a).not_to receive(:to_int)
    expect([].send(:initialize, a)).to eq([1, 2])
  end

  it "does not call #to_ary on instances of Array or subclasses of Array" do
    a = [1, 2]
    expect(a).not_to receive(:to_ary)
    expect([].send(:initialize, a)).to eq(a)
  end

  it "raises a TypeError if an Array type argument and a default object" do
    expect { [].send(:initialize, [1, 2], 1) }.to raise_error(TypeError)
  end
end

describe "Array#initialize with (size, object=nil)" do
  it "sets the array to size and fills with the object" do
    a = []
    obj = [3]
    expect(a.send(:initialize, 2, obj)).to eq([obj, obj])
    expect(a[0]).to equal(obj)
    expect(a[1]).to equal(obj)

    b = []
    expect(b.send(:initialize, 3, 14)).to eq([14, 14, 14])
    expect(b).to eq([14, 14, 14])
  end

  it "sets the array to size and fills with nil when object is omitted" do
    expect([].send(:initialize, 3)).to eq([nil, nil, nil])
  end

  it "raises an ArgumentError if size is negative" do
    expect { [].send(:initialize, -1, :a) }.to raise_error(ArgumentError)
    expect { [].send(:initialize, -1) }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError if size is too large" do
    expect { [].send(:initialize, fixnum_max+1) }.to raise_error(ArgumentError)
  end

  it "calls #to_int to convert the size argument to an Integer when object is given" do
    obj = double('1')
    expect(obj).to receive(:to_int).and_return(1)
    expect([].send(:initialize, obj, :a)).to eq([:a])
  end

  it "calls #to_int to convert the size argument to an Integer when object is not given" do
    obj = double('1')
    expect(obj).to receive(:to_int).and_return(1)
    expect([].send(:initialize, obj)).to eq([nil])
  end

  it "raises a TypeError if the size argument is not an Integer type" do
    obj = double('nonnumeric')
    allow(obj).to receive(:to_ary).and_return([1, 2])
    expect{ [].send(:initialize, obj, :a) }.to raise_error(TypeError)
  end

  it "yields the index of the element and sets the element to the value of the block" do
    expect([].send(:initialize, 3) { |i| i.to_s }).to eq(['0', '1', '2'])
  end

  it "uses the block value instead of using the default value" do
    expect {
      @result = [].send(:initialize, 3, :obj) { |i| i.to_s }
    }.to complain(/block supersedes default value argument/)
    expect(@result).to eq(['0', '1', '2'])
  end

  it "returns the value passed to break" do
    expect([].send(:initialize, 3) { break :a }).to eq(:a)
  end

  it "sets the array to the values returned by the block before break is executed" do
    a = [1, 2, 3]
    a.send(:initialize, 3) do |i|
      break if i == 2
      i.to_s
    end

    expect(a).to eq(['0', '1'])
  end
end
