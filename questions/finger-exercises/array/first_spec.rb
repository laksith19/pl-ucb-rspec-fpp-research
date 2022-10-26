require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#first" do
  it "returns the first element" do
    expect(%w{a b c}.first).to eq('a')
    expect([nil].first).to eq(nil)
  end

  it "returns nil if self is empty" do
    expect([].first).to eq(nil)
  end

  it "returns the first count elements if given a count" do
    expect([true, false, true, nil, false].first(2)).to eq([true, false])
  end

  it "returns an empty array when passed count on an empty array" do
    expect([].first(0)).to eq([])
    expect([].first(1)).to eq([])
    expect([].first(2)).to eq([])
  end

  it "returns an empty array when passed count == 0" do
    expect([1, 2, 3, 4, 5].first(0)).to eq([])
  end

  it "returns an array containing the first element when passed count == 1" do
    expect([1, 2, 3, 4, 5].first(1)).to eq([1])
  end

  it "raises an ArgumentError when count is negative" do
    expect { [1, 2].first(-1) }.to raise_error(ArgumentError)
  end

  it "raises a RangeError when count is a Bignum" do
    expect { [].first(bignum_value) }.to raise_error(RangeError)
  end

  it "returns the entire array when count > length" do
    expect([1, 2, 3, 4, 5, 9].first(10)).to eq([1, 2, 3, 4, 5, 9])
  end

  it "returns an array which is independent to the original when passed count" do
    ary = [1, 2, 3, 4, 5]
    ary.first(0).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
    ary.first(1).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
    ary.first(6).replace([1,2])
    expect(ary).to eq([1, 2, 3, 4, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.first).to equal(empty)

    ary = ArraySpecs.head_recursive_array
    expect(ary.first).to equal(ary)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(2)
    expect([1, 2, 3, 4, 5].first(obj)).to eq([1, 2])
  end

  it "raises a TypeError if the passed argument is not numeric" do
    expect { [1,2].first(nil) }.to raise_error(TypeError)
    expect { [1,2].first("a") }.to raise_error(TypeError)

    obj = double("nonnumeric")
    expect { [1,2].first(obj) }.to raise_error(TypeError)
  end

  it "does not return subclass instance when passed count on Array subclasses" do
    expect(ArraySpecs::MyArray[].first(0)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[].first(2)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].first(0)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].first(1)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].first(2)).to be_an_instance_of(Array)
  end

  it "is not destructive" do
    a = [1, 2, 3]
    a.first
    expect(a).to eq([1, 2, 3])
    a.first(2)
    expect(a).to eq([1, 2, 3])
    a.first(3)
    expect(a).to eq([1, 2, 3])
  end
end
