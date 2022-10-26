require_relative '../../spec_helper'

describe "Array#repeated_combination" do
  before :each do
    @array = [10, 11, 12]
  end

  it "returns an enumerator when no block is provided" do
    expect(@array.repeated_combination(2)).to be_an_instance_of(Enumerator)
  end

  it "returns self when a block is given" do
    expect(@array.repeated_combination(2){}).to equal(@array)
  end

  it "yields nothing for negative length and return self" do
    expect(@array.repeated_combination(-1){ fail }).to equal(@array)
    expect(@array.repeated_combination(-10){ fail }).to equal(@array)
  end

  it "yields the expected repeated_combinations" do
    expect(@array.repeated_combination(2).to_a.sort).to eq([[10, 10], [10, 11], [10, 12], [11, 11], [11, 12], [12, 12]])
    expect(@array.repeated_combination(3).to_a.sort).to eq([[10, 10, 10], [10, 10, 11], [10, 10, 12], [10, 11, 11], [10, 11, 12],
                                                        [10, 12, 12], [11, 11, 11], [11, 11, 12], [11, 12, 12], [12, 12, 12]])
  end

  it "yields [] when length is 0" do
    expect(@array.repeated_combination(0).to_a).to eq([[]]) # one repeated_combination of length 0
    expect([].repeated_combination(0).to_a).to eq([[]]) # one repeated_combination of length 0
  end

  it "yields nothing when the array is empty and num is non zero" do
    expect([].repeated_combination(5).to_a).to eq([]) # one repeated_combination of length 0
  end

  it "yields a partition consisting of only singletons" do
    expect(@array.repeated_combination(1).sort.to_a).to eq([[10],[11],[12]])
  end

  it "accepts sizes larger than the original array" do
    expect(@array.repeated_combination(4).to_a.sort).to eq(
      [[10, 10, 10, 10], [10, 10, 10, 11], [10, 10, 10, 12],
       [10, 10, 11, 11], [10, 10, 11, 12], [10, 10, 12, 12],
       [10, 11, 11, 11], [10, 11, 11, 12], [10, 11, 12, 12],
       [10, 12, 12, 12], [11, 11, 11, 11], [11, 11, 11, 12],
       [11, 11, 12, 12], [11, 12, 12, 12], [12, 12, 12, 12]]
    )
  end

  it "generates from a defensive copy, ignoring mutations" do
    accum = []
    @array.repeated_combination(2) do |x|
      accum << x
      @array[0] = 1
    end
    expect(accum.sort).to eq([[10, 10], [10, 11], [10, 12], [11, 11], [11, 12], [12, 12]])
  end

  describe "when no block is given" do
    describe "returned Enumerator" do
      describe "size" do
        it "returns 0 when the combination_size is < 0" do
          expect(@array.repeated_combination(-1).size).to eq(0)
          expect([].repeated_combination(-2).size).to eq(0)
        end

        it "returns 1 when the combination_size is 0" do
          expect(@array.repeated_combination(0).size).to eq(1)
          expect([].repeated_combination(0).size).to eq(1)
        end

        it "returns the binomial coefficient between combination_size and array size + combination_size -1" do
          expect(@array.repeated_combination(5).size).to eq(21)
          expect(@array.repeated_combination(4).size).to eq(15)
          expect(@array.repeated_combination(3).size).to eq(10)
          expect(@array.repeated_combination(2).size).to eq(6)
          expect(@array.repeated_combination(1).size).to eq(3)
          expect(@array.repeated_combination(0).size).to eq(1)
          expect([].repeated_combination(0).size).to eq(1)
          expect([].repeated_combination(1).size).to eq(0)
        end
      end
    end
  end
end
