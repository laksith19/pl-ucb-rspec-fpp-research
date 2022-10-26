require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#product" do
  it "returns converted arguments using :to_ary" do
    expect{ [1].product(2..3) }.to raise_error(TypeError)
    ar = ArraySpecs::ArrayConvertible.new(2,3)
    expect([1].product(ar)).to eq([[1,2],[1,3]])
    expect(ar.called).to eq(:to_ary)
  end

  it "returns the expected result" do
    expect([1,2].product([3,4,5],[6,8])).to eq([[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                                            [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]])
  end

  it "has no required argument" do
    expect([1,2].product).to eq([[1],[2]])
  end

  it "returns an empty array when the argument is an empty array" do
    expect([1, 2].product([])).to eq([])
  end

  it "does not attempt to produce an unreasonable number of products" do
    a = (0..100).to_a
    expect do
      a.product(a, a, a, a, a, a, a, a, a, a)
    end.to raise_error(RangeError)
  end

  describe "when given a block" do
    it "yields all combinations in turn" do
      acc = []
      [1,2].product([3,4,5],[6,8]){|array| acc << array}
      expect(acc).to eq([[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
                     [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]])

      acc = []
      [1,2].product([3,4,5],[],[6,8]){|array| acc << array}
      expect(acc).to be_empty
    end

    it "returns self" do
      a = [1, 2, 3].freeze

      expect(a.product([1, 2]) { |p| p.first }).to eq(a)
    end

    it "will ignore unreasonable numbers of products and yield anyway" do
      a = (0..100).to_a
      expect do
        a.product(a, a, a, a, a, a, a, a, a, a)
      end.to raise_error(RangeError)
    end
  end

  describe "when given an empty block" do
    it "returns self" do
      arr = [1,2]
      expect(arr.product([3,4,5],[6,8]){}).to equal(arr)
      arr = []
      expect(arr.product([3,4,5],[6,8]){}).to equal(arr)
      arr = [1,2]
      expect(arr.product([]){}).to equal(arr)
    end
  end
end
