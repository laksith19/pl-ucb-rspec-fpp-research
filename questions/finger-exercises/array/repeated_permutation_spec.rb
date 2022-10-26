require_relative '../../spec_helper'


describe "Array#repeated_permutation" do

  before :each do
    @numbers = [10, 11, 12]
    @permutations = [[10, 10], [10, 11], [10, 12], [11, 10], [11, 11], [11, 12], [12, 10], [12, 11], [12, 12]]
  end

  it "returns an Enumerator of all repeated permutations of given length when called without a block" do
    enum = @numbers.repeated_permutation(2)
    expect(enum).to be_an_instance_of(Enumerator)
    expect(enum.to_a.sort).to eq(@permutations)
  end

  it "yields all repeated_permutations to the block then returns self when called with block but no arguments" do
    yielded = []
    expect(@numbers.repeated_permutation(2) {|n| yielded << n}).to equal(@numbers)
    expect(yielded.sort).to eq(@permutations)
  end

  it "yields the empty repeated_permutation ([[]]) when the given length is 0" do
    expect(@numbers.repeated_permutation(0).to_a).to eq([[]])
    expect([].repeated_permutation(0).to_a).to eq([[]])
  end

  it "does not yield when called on an empty Array with a nonzero argument" do
    expect([].repeated_permutation(10).to_a).to eq([])
  end

  it "handles duplicate elements correctly" do
    @numbers[-1] = 10
    expect(@numbers.repeated_permutation(2).sort).to eq(
      [[10, 10], [10, 10], [10, 10], [10, 10], [10, 11], [10, 11], [11, 10], [11, 10], [11, 11]]
    )
  end

  it "truncates Float arguments" do
    expect(@numbers.repeated_permutation(3.7).to_a.sort).to eq(
      @numbers.repeated_permutation(3).to_a.sort
    )
  end

  it "returns an Enumerator which works as expected even when the array was modified" do
    @numbers.shift
    enum = @numbers.repeated_permutation(2)
    @numbers.unshift 10
    expect(enum.to_a.sort).to eq(@permutations)
  end

  it "allows permutations larger than the number of elements" do
    expect([1,2].repeated_permutation(3).sort).to eq(
      [[1, 1, 1], [1, 1, 2], [1, 2, 1],
       [1, 2, 2], [2, 1, 1], [2, 1, 2],
       [2, 2, 1], [2, 2, 2]]
    )
  end

  it "generates from a defensive copy, ignoring mutations" do
    accum = []
    ary = [1,2]
    ary.repeated_permutation(3) do |x|
      accum << x
      ary[0] = 5
    end

    expect(accum.sort).to eq(
      [[1, 1, 1], [1, 1, 2], [1, 2, 1],
       [1, 2, 2], [2, 1, 1], [2, 1, 2],
       [2, 2, 1], [2, 2, 2]]
    )
  end

  describe "when no block is given" do
    describe "returned Enumerator" do
      describe "size" do
        it "returns 0 when combination_size is < 0" do
          expect(@numbers.repeated_permutation(-1).size).to eq(0)
          expect([].repeated_permutation(-1).size).to eq(0)
        end

        it "returns array size ** combination_size" do
          expect(@numbers.repeated_permutation(4).size).to eq(81)
          expect(@numbers.repeated_permutation(3).size).to eq(27)
          expect(@numbers.repeated_permutation(2).size).to eq(9)
          expect(@numbers.repeated_permutation(1).size).to eq(3)
          expect(@numbers.repeated_permutation(0).size).to eq(1)
          expect([].repeated_permutation(4).size).to eq(0)
          expect([].repeated_permutation(3).size).to eq(0)
          expect([].repeated_permutation(2).size).to eq(0)
          expect([].repeated_permutation(1).size).to eq(0)
          expect([].repeated_permutation(0).size).to eq(1)
        end
      end
    end
  end
end
