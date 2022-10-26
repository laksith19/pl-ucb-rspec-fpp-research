require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#pop" do
  it "removes and returns the last element of the array" do
    a = ["a", 1, nil, true]

    expect(a.pop).to eq(true)
    expect(a).to eq(["a", 1, nil])

    expect(a.pop).to eq(nil)
    expect(a).to eq(["a", 1])

    expect(a.pop).to eq(1)
    expect(a).to eq(["a"])

    expect(a.pop).to eq("a")
    expect(a).to eq([])
  end

  it "returns nil if there are no more elements" do
    expect([].pop).to eq(nil)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.pop).to eq([])

    array = ArraySpecs.recursive_array
    expect(array.pop).to eq([1, 'two', 3.0, array, array, array, array])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.pop }.to raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    expect { ArraySpecs.empty_frozen_array.pop }.to raise_error(FrozenError)
  end

  describe "passed a number n as an argument" do
    it "removes and returns an array with the last n elements of the array" do
      a = [1, 2, 3, 4, 5, 6]

      expect(a.pop(0)).to eq([])
      expect(a).to eq([1, 2, 3, 4, 5, 6])

      expect(a.pop(1)).to eq([6])
      expect(a).to eq([1, 2, 3, 4, 5])

      expect(a.pop(2)).to eq([4, 5])
      expect(a).to eq([1, 2, 3])

      expect(a.pop(3)).to eq([1, 2, 3])
      expect(a).to eq([])
    end

    it "returns an array with the last n elements even if shift was invoked" do
      a = [1, 2, 3, 4]
      a.shift
      expect(a.pop(3)).to eq([2, 3, 4])
    end

    it "returns a new empty array if there are no more elements" do
      a = []
      popped1 = a.pop(1)
      expect(popped1).to eq([])
      expect(a).to eq([])

      popped2 = a.pop(2)
      expect(popped2).to eq([])
      expect(a).to eq([])

      expect(popped1).not_to equal(popped2)
    end

    it "returns whole elements if n exceeds size of the array" do
      a = [1, 2, 3, 4, 5]
      expect(a.pop(6)).to eq([1, 2, 3, 4, 5])
      expect(a).to eq([])
    end

    it "does not return self even when it returns whole elements" do
      a = [1, 2, 3, 4, 5]
      expect(a.pop(5)).not_to equal(a)

      a = [1, 2, 3, 4, 5]
      expect(a.pop(6)).not_to equal(a)
    end

    it "raises an ArgumentError if n is negative" do
      expect{ [1, 2, 3].pop(-1) }.to raise_error(ArgumentError)
    end

    it "tries to convert n to an Integer using #to_int" do
      a = [1, 2, 3, 4]
      expect(a.pop(2.3)).to eq([3, 4])

      obj = double('to_int')
      expect(obj).to receive(:to_int).and_return(2)
      expect(a).to eq([1, 2])
      expect(a.pop(obj)).to eq([1, 2])
      expect(a).to eq([])
    end

    it "raises a TypeError when the passed n cannot be coerced to Integer" do
      expect{ [1, 2].pop("cat") }.to raise_error(TypeError)
      expect{ [1, 2].pop(nil) }.to raise_error(TypeError)
    end

    it "raises an ArgumentError if more arguments are passed" do
      expect{ [1, 2].pop(1, 2) }.to raise_error(ArgumentError)
    end

    it "does not return subclass instances with Array subclass" do
      expect(ArraySpecs::MyArray[1, 2, 3].pop(2)).to be_an_instance_of(Array)
    end

    it "raises a FrozenError on a frozen array" do
      expect { ArraySpecs.frozen_array.pop(2) }.to raise_error(FrozenError)
      expect { ArraySpecs.frozen_array.pop(0) }.to raise_error(FrozenError)
    end
  end
end
