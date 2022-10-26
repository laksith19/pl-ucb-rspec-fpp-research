require_relative '../../spec_helper'

describe "Array#max" do
  it "is defined on Array" do
    expect([1].method(:max).owner).to equal Array
  end

  it "returns nil with no values" do
    expect([].max).to eq(nil)
  end

  it "returns only element in one element array" do
    expect([1].max).to eq(1)
  end

  it "returns largest value with multiple elements" do
    expect([1,2].max).to eq(2)
    expect([2,1].max).to eq(2)
  end

  describe "given a block with one argument" do
    it "yields in turn the last length-1 values from the array" do
      ary = []
      result = [1,2,3,4,5].max {|x| ary << x; x}

      expect(ary).to eq([2,3,4,5])
      expect(result).to eq(5)
    end
  end
end

# From Enumerable#max, copied for better readability
describe "Array#max" do
  before :each do
    @a = [2, 4, 6, 8, 10]

    @e_strs = ["333", "22", "666666", "1", "55555", "1010101010"]
    @e_ints = [333,   22,   666666,   55555, 1010101010]
  end

  it "max should return the maximum element" do
    expect([18, 42].max).to eq(42)
    expect([2, 5, 3, 6, 1, 4].max).to eq(6)
  end

  it "returns the maximum element (basics cases)" do
    expect([55].max).to eq(55)

    expect([11,99].max).to eq(99)
    expect([99,11].max).to eq(99)
    expect([2, 33, 4, 11].max).to eq(33)

    expect([1,2,3,4,5].max).to eq(5)
    expect([5,4,3,2,1].max).to eq(5)
    expect([1,4,3,5,2].max).to eq(5)
    expect([5,5,5,5,5].max).to eq(5)

    expect(["aa","tt"].max).to eq("tt")
    expect(["tt","aa"].max).to eq("tt")
    expect(["2","33","4","11"].max).to eq("4")

    expect(@e_strs.max).to eq("666666")
    expect(@e_ints.max).to eq(1010101010)
  end

  it "returns nil for an empty Enumerable" do
    expect([].max).to eq(nil)
  end

  it "raises a NoMethodError for elements without #<=>" do
    expect do
      [BasicObject.new, BasicObject.new].max
    end.to raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    expect do
      [11,"22"].max
    end.to raise_error(ArgumentError)
    expect do
      [11,12,22,33].max{|a, b| nil}
    end.to raise_error(ArgumentError)
  end

  it "returns the maximum element (with block)" do
    # with a block
    expect(["2","33","4","11"].max {|a,b| a <=> b }).to eq("4")
    expect([ 2 , 33 , 4 , 11 ].max {|a,b| a <=> b }).to eq(33)

    expect(["2","33","4","11"].max {|a,b| b <=> a }).to eq("11")
    expect([ 2 , 33 , 4 , 11 ].max {|a,b| b <=> a }).to eq(2)

    expect(@e_strs.max {|a,b| a.length <=> b.length }).to eq("1010101010")

    expect(@e_strs.max {|a,b| a <=> b }).to eq("666666")
    expect(@e_strs.max {|a,b| a.to_i <=> b.to_i }).to eq("1010101010")

    expect(@e_ints.max {|a,b| a <=> b }).to eq(1010101010)
    expect(@e_ints.max {|a,b| a.to_s <=> b.to_s }).to eq(666666)
  end

  it "returns the minimum for enumerables that contain nils" do
    arr = [nil, nil, true]
    expect(arr.max { |a, b|
      x = a.nil? ? 1 : a ? 0 : -1
      y = b.nil? ? 1 : b ? 0 : -1
      x <=> y
    }).to eq(nil)
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = [[1,2], [3,4,5], [6,7,8,9]]
    expect(multi.max).to eq([6, 7, 8, 9])
  end

end
