require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#shift" do
  it "removes and returns the first element" do
    a = [5, 1, 1, 5, 4]
    expect(a.shift).to eq(5)
    expect(a).to eq([1, 1, 5, 4])
    expect(a.shift).to eq(1)
    expect(a).to eq([1, 5, 4])
    expect(a.shift).to eq(1)
    expect(a).to eq([5, 4])
    expect(a.shift).to eq(5)
    expect(a).to eq([4])
    expect(a.shift).to eq(4)
    expect(a).to eq([])
  end

  it "returns nil when the array is empty" do
    expect([].shift).to eq(nil)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.shift).to eq([])
    expect(empty).to eq([])

    array = ArraySpecs.recursive_array
    expect(array.shift).to eq(1)
    expect(array[0..2]).to eq(['two', 3.0, array])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.shift }.to raise_error(FrozenError)
  end
  it "raises a FrozenError on an empty frozen array" do
    expect { ArraySpecs.empty_frozen_array.shift }.to raise_error(FrozenError)
  end

  describe "passed a number n as an argument" do
    it "removes and returns an array with the first n element of the array" do
      a = [1, 2, 3, 4, 5, 6]

      expect(a.shift(0)).to eq([])
      expect(a).to eq([1, 2, 3, 4, 5, 6])

      expect(a.shift(1)).to eq([1])
      expect(a).to eq([2, 3, 4, 5, 6])

      expect(a.shift(2)).to eq([2, 3])
      expect(a).to eq([4, 5, 6])

      expect(a.shift(3)).to eq([4, 5, 6])
      expect(a).to eq([])
    end

    it "does not corrupt the array when shift without arguments is followed by shift with an argument" do
      a = [1, 2, 3, 4, 5]

      expect(a.shift).to eq(1)
      expect(a.shift(3)).to eq([2, 3, 4])
      expect(a).to eq([5])
    end

    it "returns a new empty array if there are no more elements" do
      a = []
      popped1 = a.shift(1)
      expect(popped1).to eq([])
      expect(a).to eq([])

      popped2 = a.shift(2)
      expect(popped2).to eq([])
      expect(a).to eq([])

      expect(popped1).not_to equal(popped2)
    end

    it "returns whole elements if n exceeds size of the array" do
      a = [1, 2, 3, 4, 5]
      expect(a.shift(6)).to eq([1, 2, 3, 4, 5])
      expect(a).to eq([])
    end

    it "does not return self even when it returns whole elements" do
      a = [1, 2, 3, 4, 5]
      expect(a.shift(5)).not_to equal(a)

      a = [1, 2, 3, 4, 5]
      expect(a.shift(6)).not_to equal(a)
    end

    it "raises an ArgumentError if n is negative" do
      expect{ [1, 2, 3].shift(-1) }.to raise_error(ArgumentError)
    end

    it "tries to convert n to an Integer using #to_int" do
      a = [1, 2, 3, 4]
      expect(a.shift(2.3)).to eq([1, 2])

      obj = double('to_int')
      expect(obj).to receive(:to_int).and_return(2)
      expect(a).to eq([3, 4])
      expect(a.shift(obj)).to eq([3, 4])
      expect(a).to eq([])
    end

    it "raises a TypeError when the passed n cannot be coerced to Integer" do
      expect{ [1, 2].shift("cat") }.to raise_error(TypeError)
      expect{ [1, 2].shift(nil) }.to raise_error(TypeError)
    end

    it "raises an ArgumentError if more arguments are passed" do
      expect{ [1, 2].shift(1, 2) }.to raise_error(ArgumentError)
    end

    it "does not return subclass instances with Array subclass" do
      expect(ArraySpecs::MyArray[1, 2, 3].shift(2)).to be_an_instance_of(Array)
    end
  end
end
