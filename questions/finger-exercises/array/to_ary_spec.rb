require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#to_ary" do
  it "returns self" do
    a = [1, 2, 3]
    expect(a).to equal(a.to_ary)
    a = ArraySpecs::MyArray[1, 2, 3]
    expect(a).to equal(a.to_ary)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.to_ary).to eq(empty)

    array = ArraySpecs.recursive_array
    expect(array.to_ary).to eq(array)
  end

end
