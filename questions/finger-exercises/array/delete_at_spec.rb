require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#delete_at" do
  it "removes the element at the specified index" do
    a = [1, 2, 3, 4]
    a.delete_at(2)
    expect(a).to eq([1, 2, 4])
    a.delete_at(-1)
    expect(a).to eq([1, 2])
  end

  it "returns the removed element at the specified index" do
    a = [1, 2, 3, 4]
    expect(a.delete_at(2)).to eq(3)
    expect(a.delete_at(-1)).to eq(4)
  end

  it "returns nil and makes no modification if the index is out of range" do
    a = [1, 2]
    expect(a.delete_at(3)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.delete_at(-3)).to eq(nil)
    expect(a).to eq([1, 2])
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(-1)
    expect([1, 2].delete_at(obj)).to eq(2)
  end

  it "accepts negative indices" do
    a = [1, 2]
    expect(a.delete_at(-2)).to eq(1)
  end

  it "raises a FrozenError on a frozen array" do
    expect { [1,2,3].freeze.delete_at(0) }.to raise_error(FrozenError)
  end
end
