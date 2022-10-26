require_relative '../../spec_helper'

describe "Array#min" do
  it "is defined on Array" do
    expect([1].method(:max).owner).to equal Array
  end

  it "returns nil with no values" do
    expect([].min).to eq(nil)
  end

  it "returns only element in one element array" do
    expect([1].min).to eq(1)
  end

  it "returns smallest value with multiple elements" do
    expect([1,2].min).to eq(1)
    expect([2,1].min).to eq(1)
  end

  describe "given a block with one argument" do
    it "yields in turn the last length-1 values from the array" do
      ary = []
      result = [1,2,3,4,5].min {|x| ary << x; x}

      expect(ary).to eq([2,3,4,5])
      expect(result).to eq(1)
    end
  end
end

# From Enumerable#min, copied for better readability
describe "Array#min" do
  before :each do
    @a = [2, 4, 6, 8, 10]

    @e_strs = ["333", "22", "666666", "1", "55555", "1010101010"]
    @e_ints = [ 333,   22,   666666,        55555,   1010101010]
  end

  it "min should return the minimum element" do
    expect([18, 42].min).to eq(18)
    expect([2, 5, 3, 6, 1, 4].min).to eq(1)
  end

  it "returns the minimum (basic cases)" do
    expect([55].min).to eq(55)

    expect([11,99].min).to eq(11)
    expect([99,11].min).to eq(11)
    expect([2, 33, 4, 11].min).to eq(2)

    expect([1,2,3,4,5].min).to eq(1)
    expect([5,4,3,2,1].min).to eq(1)
    expect([4,1,3,5,2].min).to eq(1)
    expect([5,5,5,5,5].min).to eq(5)

    expect(["aa","tt"].min).to eq("aa")
    expect(["tt","aa"].min).to eq("aa")
    expect(["2","33","4","11"].min).to eq("11")

    expect(@e_strs.min).to eq("1")
    expect(@e_ints.min).to eq(22)
  end

  it "returns nil for an empty Enumerable" do
    expect([].min).to be_nil
  end

  it "raises a NoMethodError for elements without #<=>" do
    expect do
      [BasicObject.new, BasicObject.new].min
    end.to raise_error(NoMethodError)
  end

  it "raises an ArgumentError for incomparable elements" do
    expect do
      [11,"22"].min
    end.to raise_error(ArgumentError)
    expect do
      [11,12,22,33].min{|a, b| nil}
    end.to raise_error(ArgumentError)
  end

  it "returns the minimum when using a block rule" do
    expect(["2","33","4","11"].min {|a,b| a <=> b }).to eq("11")
    expect([ 2 , 33 , 4 , 11 ].min {|a,b| a <=> b }).to eq(2)

    expect(["2","33","4","11"].min {|a,b| b <=> a }).to eq("4")
    expect([ 2 , 33 , 4 , 11 ].min {|a,b| b <=> a }).to eq(33)

    expect([ 1, 2, 3, 4 ].min {|a,b| 15 }).to eq(1)

    expect([11,12,22,33].min{|a, b| 2 }).to eq(11)
    @i = -2
    expect([11,12,22,33].min{|a, b| @i += 1 }).to eq(12)

    expect(@e_strs.min {|a,b| a.length <=> b.length }).to eq("1")

    expect(@e_strs.min {|a,b| a <=> b }).to eq("1")
    expect(@e_strs.min {|a,b| a.to_i <=> b.to_i }).to eq("1")

    expect(@e_ints.min {|a,b| a <=> b }).to eq(22)
    expect(@e_ints.min {|a,b| a.to_s <=> b.to_s }).to eq(1010101010)
  end

  it "returns the minimum for enumerables that contain nils" do
    arr = [nil, nil, true]
    expect(arr.min { |a, b|
      x = a.nil? ? -1 : a ? 0 : 1
      y = b.nil? ? -1 : b ? 0 : 1
      x <=> y
    }).to eq(nil)
  end

  it "gathers whole arrays as elements when each yields multiple" do
    multi = [[1,2], [3,4,5], [6,7,8,9]]
    expect(multi.min).to eq([1, 2])
  end

end
