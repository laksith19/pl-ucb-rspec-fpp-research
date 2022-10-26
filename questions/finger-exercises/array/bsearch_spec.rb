require_relative '../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe "Array#bsearch" do
  it "returns an Enumerator when not passed a block" do
    expect([1].bsearch).to be_an_instance_of(Enumerator)
  end

  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, [1,2,3]

  it "raises a TypeError if the block returns an Object" do
    expect { [1].bsearch { Object.new } }.to raise_error(TypeError)
  end

  it "raises a TypeError if the block returns a String" do
    expect { [1].bsearch { "1" } }.to raise_error(TypeError)
  end

  context "with a block returning true or false" do
    it "returns nil if the block returns false for every element" do
      expect([0, 1, 2, 3].bsearch { |x| x > 3 }).to be_nil
    end

    it "returns nil if the block returns nil for every element" do
      expect([0, 1, 2, 3].bsearch { |x| nil }).to be_nil
    end

    it "returns element at zero if the block returns true for every element" do
      expect([0, 1, 2, 3].bsearch { |x| x < 4 }).to eq(0)

    end

    it "returns the element at the smallest index for which block returns true" do
      expect([0, 1, 3, 4].bsearch { |x| x >= 2 }).to eq(3)
      expect([0, 1, 3, 4].bsearch { |x| x >= 1 }).to eq(1)
    end
  end

  context "with a block returning negative, zero, positive numbers" do
    it "returns nil if the block returns less than zero for every element" do
      expect([0, 1, 2, 3].bsearch { |x| x <=> 5 }).to be_nil
    end

    it "returns nil if the block returns greater than zero for every element" do
      expect([0, 1, 2, 3].bsearch { |x| x <=> -1 }).to be_nil

    end

    it "returns nil if the block never returns zero" do
      expect([0, 1, 3, 4].bsearch { |x| x <=> 2 }).to be_nil
    end

    it "accepts (+/-)Float::INFINITY from the block" do
      expect([0, 1, 3, 4].bsearch { |x| Float::INFINITY }).to be_nil
      expect([0, 1, 3, 4].bsearch { |x| -Float::INFINITY }).to be_nil
    end

    it "returns an element at an index for which block returns 0.0" do
      result = [0, 1, 2, 3, 4].bsearch { |x| x < 2 ? 1.0 : x > 2 ? -1.0 : 0.0 }
      expect(result).to eq(2)
    end

    it "returns an element at an index for which block returns 0" do
      result = [0, 1, 2, 3, 4].bsearch { |x| x < 1 ? 1 : x > 3 ? -1 : 0 }
      expect([1, 2]).to include(result)
    end
  end

  context "with a block that calls break" do
    it "returns nil if break is called without a value" do
      expect(['a', 'b', 'c'].bsearch { |v| break }).to be_nil
    end

    it "returns nil if break is called with a nil value" do
      expect(['a', 'b', 'c'].bsearch { |v| break nil }).to be_nil
    end

    it "returns object if break is called with an object" do
      expect(['a', 'b', 'c'].bsearch { |v| break 1234 }).to eq(1234)
      expect(['a', 'b', 'c'].bsearch { |v| break 'hi' }).to eq('hi')
      expect(['a', 'b', 'c'].bsearch { |v| break [42] }).to eq([42])
    end
  end
end
