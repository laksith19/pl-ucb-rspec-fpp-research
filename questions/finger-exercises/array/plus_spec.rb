require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#+" do
  it "concatenates two arrays" do
    expect([ 1, 2, 3 ] + [ 3, 4, 5 ]).to eq([1, 2, 3, 3, 4, 5])
    expect([ 1, 2, 3 ] + []).to eq([1, 2, 3])
    expect([] + [ 1, 2, 3 ]).to eq([1, 2, 3])
    expect([] + []).to eq([])
  end

  it "can concatenate an array with itself" do
    ary = [1, 2, 3]
    expect(ary + ary).to eq([1, 2, 3, 1, 2, 3])
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('["x", "y"]')
    expect(obj).to receive(:to_ary).and_return(["x", "y"])
    expect([1, 2, 3] + obj).to eq([1, 2, 3, "x", "y"])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty + empty).to eq([empty, empty])

    array = ArraySpecs.recursive_array
    expect(empty + array).to eq([empty, 1, 'two', 3.0, array, array, array, array, array])
    expect(array + array).to eq([
      1, 'two', 3.0, array, array, array, array, array,
      1, 'two', 3.0, array, array, array, array, array])
  end

  it "does return subclass instances with Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3] + []).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3] + ArraySpecs::MyArray[]).to be_an_instance_of(Array)
    expect([1, 2, 3] + ArraySpecs::MyArray[]).to be_an_instance_of(Array)
  end

  it "does not call to_ary on array subclasses" do
    expect([5, 6] + ArraySpecs::ToAryArray[1, 2]).to eq([5, 6, 1, 2])
  end
end
