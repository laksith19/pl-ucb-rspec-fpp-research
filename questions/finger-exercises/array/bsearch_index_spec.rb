require_relative '../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe "Array#bsearch_index" do
  context "when not passed a block" do
    before :each do
      @enum = [1, 2, 42, 100, 666].bsearch_index
    end

    it "returns an Enumerator" do
      expect(@enum).to be_an_instance_of(Enumerator)
    end

    it "returns an Enumerator with unknown size" do
      expect(@enum.size).to be_nil
    end

    it "returns index of element when block condition is satisfied" do
      expect(@enum.each { |x| x >= 33 }).to eq(2)
    end
  end

  it "raises a TypeError when block returns a String" do
    expect { [1, 2, 3].bsearch_index { "not ok" } }.to raise_error(TypeError)
  end

  it "returns nil when block is empty" do
    expect([1, 2, 3].bsearch_index {}).to be_nil
  end

  context "minimum mode" do
    before :each do
      @array = [0, 4, 7, 10, 12]
    end

    it "returns index of first element which satisfies the block" do
      expect(@array.bsearch_index { |x| x >= 4 }).to eq(1)
      expect(@array.bsearch_index { |x| x >= 6 }).to eq(2)
      expect(@array.bsearch_index { |x| x >= -1 }).to eq(0)
    end

    it "returns nil when block condition is never satisfied" do
      expect(@array.bsearch_index { false }).to be_nil
      expect(@array.bsearch_index { |x| x >= 100 }).to be_nil
    end
  end

  context "find any mode" do
    before :each do
      @array = [0, 4, 7, 10, 12]
    end

    it "returns the index of any matched elements where element is between 4 <= x < 8" do
      expect([1, 2]).to include(@array.bsearch_index { |x| 1 - x / 4 })
    end

    it "returns the index of any matched elements where element is between 8 <= x < 10" do
      expect(@array.bsearch_index { |x| 4 - x / 2 }).to be_nil
    end

    it "returns nil when block never returns 0" do
      expect(@array.bsearch_index { |x| 1 }).to be_nil
      expect(@array.bsearch_index { |x| -1 }).to be_nil
    end

    it "returns the middle element when block always returns zero" do
      expect(@array.bsearch_index { |x| 0 }).to eq(2)
    end

    context "magnitude does not effect the result" do
      it "returns the index of any matched elements where element is between 4n <= xn < 8n" do
        expect([1, 2]).to include(@array.bsearch_index { |x| (1 - x / 4) * (2**100) })
      end

      it "returns nil when block never returns 0" do
        expect(@array.bsearch_index { |x| 1 * (2**100) }).to be_nil
        expect(@array.bsearch_index { |x| (-1) * (2**100) }).to be_nil
      end

      it "handles values from Integer#coerce" do
        expect([1, 2]).to include(@array.bsearch_index { |x| (2**100).coerce((1 - x / 4) * (2**100)).first })
      end
    end
  end
end
