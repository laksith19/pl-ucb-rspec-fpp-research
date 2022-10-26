require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#insert" do
  it "returns self" do
    ary = []
    expect(ary.insert(0)).to equal(ary)
    expect(ary.insert(0, :a)).to equal(ary)
  end

  it "inserts objects before the element at index for non-negative index" do
    ary = []
    expect(ary.insert(0, 3)).to eq([3])
    expect(ary.insert(0, 1, 2)).to eq([1, 2, 3])
    expect(ary.insert(0)).to eq([1, 2, 3])

    # Let's just assume insert() always modifies the array from now on.
    expect(ary.insert(1, 'a')).to eq([1, 'a', 2, 3])
    expect(ary.insert(0, 'b')).to eq(['b', 1, 'a', 2, 3])
    expect(ary.insert(5, 'c')).to eq(['b', 1, 'a', 2, 3, 'c'])
    expect(ary.insert(7, 'd')).to eq(['b', 1, 'a', 2, 3, 'c', nil, 'd'])
    expect(ary.insert(10, 5, 4)).to eq(['b', 1, 'a', 2, 3, 'c', nil, 'd', nil, nil, 5, 4])
  end

  it "appends objects to the end of the array for index == -1" do
    expect([1, 3, 3].insert(-1, 2, 'x', 0.5)).to eq([1, 3, 3, 2, 'x', 0.5])
  end

  it "inserts objects after the element at index with negative index" do
    ary = []
    expect(ary.insert(-1, 3)).to eq([3])
    expect(ary.insert(-2, 2)).to eq([2, 3])
    expect(ary.insert(-3, 1)).to eq([1, 2, 3])
    expect(ary.insert(-2, -3)).to eq([1, 2, -3, 3])
    expect(ary.insert(-1, [])).to eq([1, 2, -3, 3, []])
    expect(ary.insert(-2, 'x', 'y')).to eq([1, 2, -3, 3, 'x', 'y', []])
    ary = [1, 2, 3]
  end

  it "pads with nils if the index to be inserted to is past the end" do
    expect([].insert(5, 5)).to eq([nil, nil, nil, nil, nil, 5])
  end

  it "can insert before the first element with a negative index" do
    expect([1, 2, 3].insert(-4, -3)).to eq([-3, 1, 2, 3])
  end

  it "raises an IndexError if the negative index is out of bounds" do
    expect { [].insert(-2, 1)  }.to raise_error(IndexError)
    expect { [1].insert(-3, 2) }.to raise_error(IndexError)
  end

  it "does nothing of no object is passed" do
    expect([].insert(0)).to eq([])
    expect([].insert(-1)).to eq([])
    expect([].insert(10)).to eq([])
    expect([].insert(-2)).to eq([])
  end

  it "tries to convert the passed position argument to an Integer using #to_int" do
    obj = double('2')
    expect(obj).to receive(:to_int).and_return(2)
    expect([].insert(obj, 'x')).to eq([nil, nil, 'x'])
  end

  it "raises an ArgumentError if no argument passed" do
    expect { [].insert() }.to raise_error(ArgumentError)
  end

  it "raises a FrozenError on frozen arrays when the array is modified" do
    expect { ArraySpecs.frozen_array.insert(0, 'x') }.to raise_error(FrozenError)
  end

  # see [ruby-core:23666]
  it "raises a FrozenError on frozen arrays when the array would not be modified" do
    expect { ArraySpecs.frozen_array.insert(0) }.to raise_error(FrozenError)
  end
end
