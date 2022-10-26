require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#reverse" do
  it "returns a new array with the elements in reverse order" do
    expect([].reverse).to eq([])
    expect([1, 3, 5, 2].reverse).to eq([2, 5, 3, 1])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.reverse).to eq(empty)

    array = ArraySpecs.recursive_array
    expect(array.reverse).to eq([array, array, array, array, array, 3.0, 'two', 1])
  end

  it "does not return subclass instance on Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].reverse).to be_an_instance_of(Array)
  end
end

describe "Array#reverse!" do
  it "reverses the elements in place" do
    a = [6, 3, 4, 2, 1]
    expect(a.reverse!).to equal(a)
    expect(a).to eq([1, 2, 4, 3, 6])
    expect([].reverse!).to eq([])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.reverse!).to eq([empty])

    array = ArraySpecs.recursive_array
    expect(array.reverse!).to eq([array, array, array, array, array, 3.0, 'two', 1])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.reverse! }.to raise_error(FrozenError)
  end
end
