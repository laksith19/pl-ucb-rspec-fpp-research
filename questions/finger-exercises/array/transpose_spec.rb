require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#transpose" do
  it "assumes an array of arrays and returns the result of transposing rows and columns" do
    expect([[1, 'a'], [2, 'b'], [3, 'c']].transpose).to eq([[1, 2, 3], ["a", "b", "c"]])
    expect([[1, 2, 3], ["a", "b", "c"]].transpose).to eq([[1, 'a'], [2, 'b'], [3, 'c']])
    expect([].transpose).to eq([])
    expect([[]].transpose).to eq([])
    expect([[], []].transpose).to eq([])
    expect([[0]].transpose).to eq([[0]])
    expect([[0], [1]].transpose).to eq([[0, 1]])
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('[1,2]')
    expect(obj).to receive(:to_ary).and_return([1, 2])
    expect([obj, [:a, :b]].transpose).to eq([[1, :a], [2, :b]])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.transpose).to eq(empty)

    a = []; a << a
    b = []; b << b
    expect([a, b].transpose).to eq([[a, b]])

    a = [1]; a << a
    b = [2]; b << b
    expect([a, b].transpose).to eq([ [1, 2], [a, b] ])
  end

  it "raises a TypeError if the passed Argument does not respond to #to_ary" do
    expect { [Object.new, [:a, :b]].transpose }.to raise_error(TypeError)
  end

  it "does not call to_ary on array subclass elements" do
    ary = [ArraySpecs::ToAryArray[1, 2], ArraySpecs::ToAryArray[4, 6]]
    expect(ary.transpose).to eq([[1, 4], [2, 6]])
  end

  it "raises an IndexError if the arrays are not of the same length" do
    expect { [[1, 2], [:a]].transpose }.to raise_error(IndexError)
  end

  it "does not return subclass instance on Array subclasses" do
    result = ArraySpecs::MyArray[ArraySpecs::MyArray[1, 2, 3], ArraySpecs::MyArray[4, 5, 6]].transpose
    expect(result).to be_an_instance_of(Array)
    expect(result[0]).to be_an_instance_of(Array)
    expect(result[1]).to be_an_instance_of(Array)
  end
end
