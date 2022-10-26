require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/union'

describe "Array#|" do
  it_behaves_like :array_binary_union, :|
end

describe "Array#union" do
  it_behaves_like :array_binary_union, :union

  it "returns unique elements when given no argument" do
    x = [1, 2, 3, 2]
    expect(x.union).to eq([1, 2, 3])
  end

  it "does not return subclass instances for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].union).to be_an_instance_of(Array)
  end

  it "accepts multiple arguments" do
    x = [1, 2, 3]
    expect(x.union(x, x, x, x, [3, 4], x)).to eq([1, 2, 3, 4])
  end
end
