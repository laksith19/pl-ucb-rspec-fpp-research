require_relative '../../spec_helper'
require_relative 'fixtures/classes'


describe "Array#permutation" do

  before :each do
    @numbers = (1..3).to_a
    @yielded = []
  end

  it "returns an Enumerator of all permutations when called without a block or arguments" do
    enum = @numbers.permutation
    expect(enum).to be_an_instance_of(Enumerator)
    expect(enum.to_a.sort).to eq([
      [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
    ].sort)
  end

  it "returns an Enumerator of permutations of given length when called with an argument but no block" do
    enum = @numbers.permutation(1)
    expect(enum).to be_an_instance_of(Enumerator)
    expect(enum.to_a.sort).to eq([[1],[2],[3]])
  end

  it "yields all permutations to the block then returns self when called with block but no arguments" do
    array = @numbers.permutation {|n| @yielded << n}
    expect(array).to be_an_instance_of(Array)
    expect(array.sort).to eq(@numbers.sort)
    expect(@yielded.sort).to eq([
      [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
    ].sort)
  end

  it "yields all permutations of given length to the block then returns self when called with block and argument" do
    array = @numbers.permutation(2) {|n| @yielded << n}
    expect(array).to be_an_instance_of(Array)
    expect(array.sort).to eq(@numbers.sort)
    expect(@yielded.sort).to eq([[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]].sort)
  end

  it "returns the empty permutation ([[]]) when the given length is 0" do
    expect(@numbers.permutation(0).to_a).to eq([[]])
    @numbers.permutation(0) { |n| @yielded << n }
    expect(@yielded).to eq([[]])
  end

  it "returns the empty permutation([]) when called on an empty Array" do
    expect([].permutation.to_a).to eq([[]])
    [].permutation { |n| @yielded << n }
    expect(@yielded).to eq([[]])
  end

  it "returns no permutations when the given length has no permutations" do
    expect(@numbers.permutation(9).entries.size).to eq(0)
    @numbers.permutation(9) { |n| @yielded << n }
    expect(@yielded).to eq([])
  end

  it "handles duplicate elements correctly" do
    @numbers << 1
    expect(@numbers.permutation(2).sort).to eq([
      [1,1],[1,1],[1,2],[1,2],[1,3],[1,3],
      [2,1],[2,1],[2,3],
      [3,1],[3,1],[3,2]
    ].sort)
  end

  it "handles nested Arrays correctly" do
    # The ugliness is due to the order of permutations returned by
    # permutation being undefined combined with #sort croaking on Arrays of
    # Arrays.
    @numbers << [4,5]
    got = @numbers.permutation(2).to_a
    expected = [
       [1, 2],      [1, 3],      [1, [4, 5]],
       [2, 1],      [2, 3],      [2, [4, 5]],
       [3, 1],      [3, 2],      [3, [4, 5]],
      [[4, 5], 1], [[4, 5], 2], [[4, 5], 3]
    ]
    expected.each {|e| expect(got.include?(e)).to be_true}
    expect(got.size).to eq(expected.size)
  end

  it "truncates Float arguments" do
    expect(@numbers.permutation(3.7).to_a.sort).to eq(
      @numbers.permutation(3).to_a.sort
    )
  end

  it "returns an Enumerator which works as expected even when the array was modified" do
    @numbers = [1, 2]
    enum = @numbers.permutation
    @numbers << 3
    expect(enum.to_a.sort).to eq([
      [1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]
    ].sort)
  end

  it "generates from a defensive copy, ignoring mutations" do
    accum = []
    ary = [1,2,3]
    ary.permutation(3) do |x|
      accum << x
      ary[0] = 5
    end

    expect(accum).to eq([[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]])
  end

  describe "when no block is given" do
    describe "returned Enumerator" do
      describe "size" do
        describe "with an array size greater than 0" do
          it "returns the descending factorial of array size and given length" do
            expect(@numbers.permutation(4).size).to eq(0)
            expect(@numbers.permutation(3).size).to eq(6)
            expect(@numbers.permutation(2).size).to eq(6)
            expect(@numbers.permutation(1).size).to eq(3)
            expect(@numbers.permutation(0).size).to eq(1)
          end
          it "returns the descending factorial of array size with array size when there's no param" do
            expect(@numbers.permutation.size).to eq(6)
            expect([1,2,3,4].permutation.size).to eq(24)
            expect([1].permutation.size).to eq(1)
          end
        end
        describe "with an empty array" do
          it "returns 1 when the given length is 0" do
            expect([].permutation(0).size).to eq(1)
          end
          it "returns 1 when there's param" do
            expect([].permutation.size).to eq(1)
          end
        end
      end
    end
  end
end
