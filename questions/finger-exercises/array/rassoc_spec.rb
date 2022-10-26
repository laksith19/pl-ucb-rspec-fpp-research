require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#rassoc" do
  it "returns the first contained array whose second element is == object" do
    ary = [[1, "a", 0.5], [2, "b"], [3, "b"], [4, "c"], [], [5], [6, "d"]]
    expect(ary.rassoc("a")).to eq([1, "a", 0.5])
    expect(ary.rassoc("b")).to eq([2, "b"])
    expect(ary.rassoc("d")).to eq([6, "d"])
    expect(ary.rassoc("z")).to eq(nil)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.rassoc([])).to be_nil
    expect([[empty, empty]].rassoc(empty)).to eq([empty, empty])

    array = ArraySpecs.recursive_array
    expect(array.rassoc(array)).to be_nil
    expect([[empty, array]].rassoc(array)).to eq([empty, array])
  end

  it "calls elem == obj on the second element of each contained array" do
    key = 'foobar'
    o = double('foobar')
    def o.==(other); other == 'foobar'; end

    expect([[1, :foobar], [2, o], [3, double('foo')]].rassoc(key)).to eq([2, o])
  end

  it "does not check the last element in each contained but specifically the second" do
    key = 'foobar'
    o = double('foobar')
    def o.==(other); other == 'foobar'; end

    expect([[1, :foobar, o], [2, o, 1], [3, double('foo')]].rassoc(key)).to eq([2, o, 1])
  end
end
