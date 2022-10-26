require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array.new" do
  it "returns an instance of Array" do
    expect(Array.new).to be_an_instance_of(Array)
  end

  it "returns an instance of a subclass" do
    expect(ArraySpecs::MyArray.new(1, 2)).to be_an_instance_of(ArraySpecs::MyArray)
  end

  it "raises an ArgumentError if passed 3 or more arguments" do
    expect do
      [1, 2].send :initialize, 1, 'x', true
    end.to raise_error(ArgumentError)
    expect do
      [1, 2].send(:initialize, 1, 'x', true) {}
    end.to raise_error(ArgumentError)
  end
end

describe "Array.new with no arguments" do
  it "returns an empty array" do
    expect(Array.new).to be_empty
  end

  it "does not use the given block" do
    expect{ Array.new { raise } }.not_to raise_error
  end
end

describe "Array.new with (array)" do
  it "returns an array initialized to the other array" do
    b = [4, 5, 6]
    expect(Array.new(b)).to eq(b)
  end

  it "does not use the given block" do
    expect{ Array.new([1, 2]) { raise } }.not_to raise_error
  end

  it "calls #to_ary to convert the value to an array" do
    a = double("array")
    expect(a).to receive(:to_ary).and_return([1, 2])
    expect(a).not_to receive(:to_int)
    expect(Array.new(a)).to eq([1, 2])
  end

  it "does not call #to_ary on instances of Array or subclasses of Array" do
    a = [1, 2]
    expect(a).not_to receive(:to_ary)
    Array.new(a)
  end

  it "raises a TypeError if an Array type argument and a default object" do
    expect { Array.new([1, 2], 1) }.to raise_error(TypeError)
  end
end

describe "Array.new with (size, object=nil)" do
  it "returns an array of size filled with object" do
    obj = [3]
    a = Array.new(2, obj)
    expect(a).to eq([obj, obj])
    expect(a[0]).to equal(obj)
    expect(a[1]).to equal(obj)

    expect(Array.new(3, 14)).to eq([14, 14, 14])
  end

  it "returns an array of size filled with nil when object is omitted" do
    expect(Array.new(3)).to eq([nil, nil, nil])
  end

  it "raises an ArgumentError if size is negative" do
    expect { Array.new(-1, :a) }.to raise_error(ArgumentError)
    expect { Array.new(-1) }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError if size is too large" do
    expect { Array.new(fixnum_max+1) }.to raise_error(ArgumentError)
  end

  it "calls #to_int to convert the size argument to an Integer when object is given" do
    obj = double('1')
    expect(obj).to receive(:to_int).and_return(1)
    expect(Array.new(obj, :a)).to eq([:a])
  end

  it "calls #to_int to convert the size argument to an Integer when object is not given" do
    obj = double('1')
    expect(obj).to receive(:to_int).and_return(1)
    expect(Array.new(obj)).to eq([nil])
  end

  it "raises a TypeError if the size argument is not an Integer type" do
    obj = double('nonnumeric')
    allow(obj).to receive(:to_ary).and_return([1, 2])
    expect{ Array.new(obj, :a) }.to raise_error(TypeError)
  end

  it "yields the index of the element and sets the element to the value of the block" do
    expect(Array.new(3) { |i| i.to_s }).to eq(['0', '1', '2'])
  end

  it "uses the block value instead of using the default value" do
    expect {
      @result = Array.new(3, :obj) { |i| i.to_s }
    }.to complain(/block supersedes default value argument/)
    expect(@result).to eq(['0', '1', '2'])
  end

  it "returns the value passed to break" do
    a = Array.new(3) do |i|
      break if i == 2
      i.to_s
    end

    expect(a).to eq(nil)
  end
end
