require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/push'

describe "Array#<<" do
  it "pushes the object onto the end of the array" do
    expect([ 1, 2 ] << "c" << "d" << [ 3, 4 ]).to eq([1, 2, "c", "d", [3, 4]])
  end

  it "returns self to allow chaining" do
    a = []
    b = a
    expect(a << 1).to equal(b)
    expect(a << 2 << 3).to equal(b)
  end

  it "correctly resizes the Array" do
    a = []
    expect(a.size).to eq(0)
    a << :foo
    expect(a.size).to eq(1)
    a << :bar << :baz
    expect(a.size).to eq(3)

    a = [1, 2, 3]
    a.shift
    a.shift
    a.shift
    a << :foo
    expect(a).to eq([:foo])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array << 5 }.to raise_error(FrozenError)
  end
end

describe "Array#append" do
  it_behaves_like :array_push, :append
end
