require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#last" do
  it "returns the last element" do
    expect([1, 1, 1, 1, 2].last).to eq(2)
  end

  it "returns nil if self is empty" do
    expect([].last).to eq(nil)
  end

  it "returns the last count elements if given a count" do
    expect([1, 2, 3, 4, 5, 9].last(3)).to eq([4, 5, 9])
  end

  it "returns an empty array when passed a count on an empty array" do
    expect([].last(0)).to eq([])
    expect([].last(1)).to eq([])
  end

  it "returns an empty array when count == 0" do
    expect([1, 2, 3, 4, 5].last(0)).to eq([])
  end

  it "returns an array containing the last element when passed count == 1" do
    expect([1, 2, 3, 4, 5].last(1)).to eq([5])
  end

  it "raises an ArgumentError when count is negative" do
    expect { [1, 2].last(-1) }.to raise_error(ArgumentError)
  end

  it "returns the entire array when count > length" do
    expect([1, 2, 3, 4, 5, 9].last(10)).to eq([1, 2, 3, 4, 5, 9])
  end

  it "returns an array which is independent to the original when passed count" do
    ary = [1, 2, 3, 4, 5]
    ary.last(0).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
    ary.last(1).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
    ary.last(6).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.last).to equal(empty)

    array = ArraySpecs.recursive_array
    expect(array.last).to equal(array)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(2)
    expect([1, 2, 3, 4, 5].last(obj)).to eq([4, 5])
  end

  it "raises a TypeError if the passed argument is not numeric" do
    expect { [1,2].last(nil) }.to raise_error(TypeError)
    expect { [1,2].last("a") }.to raise_error(TypeError)

    obj = double("nonnumeric")
    expect { [1,2].last(obj) }.to raise_error(TypeError)
  end

  it "does not return subclass instance on Array subclasses" do
    expect(ArraySpecs::MyArray[].last(0)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[].last(2)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].last(0)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].last(1)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].last(2)).to be_an_instance_of(Array)
  end

  it "is not destructive" do
    a = [1, 2, 3]
    a.last
    expect(a).to eq([1, 2, 3])
    a.last(2)
    expect(a).to eq([1, 2, 3])
    a.last(3)
    expect(a).to eq([1, 2, 3])
  end
end
