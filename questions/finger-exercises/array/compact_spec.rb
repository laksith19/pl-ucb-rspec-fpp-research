require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#compact" do
  it "returns a copy of array with all nil elements removed" do
    a = [1, 2, 4]
    expect(a.compact).to eq([1, 2, 4])
    a = [1, nil, 2, 4]
    expect(a.compact).to eq([1, 2, 4])
    a = [1, 2, 4, nil]
    expect(a.compact).to eq([1, 2, 4])
    a = [nil, 1, 2, 4]
    expect(a.compact).to eq([1, 2, 4])
  end

  it "does not return self" do
    a = [1, 2, 3]
    expect(a.compact).not_to equal(a)
  end

  it "does not return subclass instance for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3, nil].compact).to be_an_instance_of(Array)
  end
end

describe "Array#compact!" do
  it "removes all nil elements" do
    a = ['a', nil, 'b', false, 'c']
    expect(a.compact!).to equal(a)
    expect(a).to eq(["a", "b", false, "c"])
    a = [nil, 'a', 'b', false, 'c']
    expect(a.compact!).to equal(a)
    expect(a).to eq(["a", "b", false, "c"])
    a = ['a', 'b', false, 'c', nil]
    expect(a.compact!).to equal(a)
    expect(a).to eq(["a", "b", false, "c"])
  end

  it "returns self if some nil elements are removed" do
    a = ['a', nil, 'b', false, 'c']
    expect(a.compact!).to equal a
  end

  it "returns nil if there are no nil elements to remove" do
    expect([1, 2, false, 3].compact!).to eq(nil)
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.compact! }.to raise_error(FrozenError)
  end
end
