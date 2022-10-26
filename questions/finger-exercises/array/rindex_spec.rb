require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative '../enumerable/shared/enumeratorized'

# Modifying a collection while the contents are being iterated
# gives undefined behavior. See
# http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/23633

describe "Array#rindex" do
  it "returns the first index backwards from the end where element == to object" do
    key = 3
    uno = double('one')
    dos = double('two')
    tres = double('three')
    allow(tres).to receive(:==).and_return(false)
    allow(dos).to receive(:==).and_return(true)
    expect(uno).not_to receive(:==)
    ary = [uno, dos, tres]

    expect(ary.rindex(key)).to eq(1)
  end

  it "returns size-1 if last element == to object" do
    expect([2, 1, 3, 2, 5].rindex(5)).to eq(4)
  end

  it "returns 0 if only first element == to object" do
    expect([2, 1, 3, 1, 5].rindex(2)).to eq(0)
  end

  it "returns nil if no element == to object" do
    expect([1, 1, 3, 2, 1, 3].rindex(4)).to eq(nil)
  end

  it "returns correct index even after delete_at" do
    array = ["fish", "bird", "lion", "cat"]
    array.delete_at(0)
    expect(array.rindex("lion")).to eq(1)
  end

  it "properly handles empty recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.rindex(empty)).to eq(0)
    expect(empty.rindex(1)).to be_nil
  end

  it "properly handles recursive arrays" do
    array = ArraySpecs.recursive_array
    expect(array.rindex(1)).to eq(0)
    expect(array.rindex(array)).to eq(7)
  end

  it "accepts a block instead of an argument" do
    expect([4, 2, 1, 5, 1, 3].rindex { |x| x < 2 }).to eq(4)
  end

  it "ignores the block if there is an argument" do
    expect {
      expect([4, 2, 1, 5, 1, 3].rindex(5) { |x| x < 2 }).to eq(3)
    }.to complain(/given block not used/)
  end

  it "rechecks the array size during iteration" do
    ary = [4, 2, 1, 5, 1, 3]
    seen = []
    ary.rindex { |x| seen << x; ary.clear; false }

    expect(seen).to eq([3])
  end

  describe "given no argument and no block" do
    it "produces an Enumerator" do
      enum = [4, 2, 1, 5, 1, 3].rindex
      expect(enum).to be_an_instance_of(Enumerator)
      expect(enum.each { |x| x < 2 }).to eq(4)
    end
  end

  it_behaves_like :enumeratorized_with_unknown_size, :bsearch, [1,2,3]
end
