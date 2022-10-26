require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#to_a" do
  it "returns self" do
    a = [1, 2, 3]
    expect(a.to_a).to eq([1, 2, 3])
    expect(a).to equal(a.to_a)
  end

  it "does not return subclass instance on Array subclasses" do
    e = ArraySpecs::MyArray.new(1, 2)
    expect(e.to_a).to be_an_instance_of(Array)
    expect(e.to_a).to eq([1, 2])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.to_a).to eq(empty)

    array = ArraySpecs.recursive_array
    expect(array.to_a).to eq(array)
  end
end
