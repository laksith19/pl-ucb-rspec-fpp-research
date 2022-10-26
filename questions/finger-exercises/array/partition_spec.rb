require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#partition" do
  it "returns two arrays" do
    expect([].partition {}).to eq([[], []])
  end

  it "returns in the left array values for which the block evaluates to true" do
    ary = [0, 1, 2, 3, 4, 5]

    expect(ary.partition { |i| true }).to eq([ary, []])
    expect(ary.partition { |i| 5 }).to eq([ary, []])
    expect(ary.partition { |i| false }).to eq([[], ary])
    expect(ary.partition { |i| nil }).to eq([[], ary])
    expect(ary.partition { |i| i % 2 == 0 }).to eq([[0, 2, 4], [1, 3, 5]])
    expect(ary.partition { |i| i / 3 == 0 }).to eq([[0, 1, 2], [3, 4, 5]])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.partition { true }).to eq([[empty], []])
    expect(empty.partition { false }).to eq([[], [empty]])

    array = ArraySpecs.recursive_array
    expect(array.partition { true }).to eq([
      [1, 'two', 3.0, array, array, array, array, array],
      []
    ])
    condition = true
    expect(array.partition { condition = !condition }).to eq([
      ['two', array, array, array],
      [1, 3.0, array, array]
    ])
  end

  it "does not return subclass instances on Array subclasses" do
    result = ArraySpecs::MyArray[1, 2, 3].partition { |x| x % 2 == 0 }
    expect(result).to be_an_instance_of(Array)
    expect(result[0]).to be_an_instance_of(Array)
    expect(result[1]).to be_an_instance_of(Array)
  end
end
