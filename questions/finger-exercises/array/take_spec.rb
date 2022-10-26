require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#take" do
  it "returns the first specified number of elements" do
    expect([1, 2, 3].take(2)).to eq([1, 2])
  end

  it "returns all elements when the argument is greater than the Array size" do
    expect([1, 2].take(99)).to eq([1, 2])
  end

  it "returns all elements when the argument is less than the Array size" do
    expect([1, 2].take(4)).to eq([1, 2])
  end

  it "returns an empty Array when passed zero" do
    expect([1].take(0)).to eq([])
  end

  it "returns an empty Array when called on an empty Array" do
    expect([].take(3)).to eq([])
  end

  it "raises an ArgumentError when the argument is negative" do
    expect{ [1].take(-3) }.to raise_error(ArgumentError)
  end

  ruby_version_is ''...'3.0' do
    it 'returns a subclass instance for Array subclasses' do
      expect(ArraySpecs::MyArray[1, 2, 3, 4, 5].take(1)).to be_an_instance_of(ArraySpecs::MyArray)
    end
  end

  ruby_version_is '3.0' do
    it 'returns a Array instance for Array subclasses' do
      expect(ArraySpecs::MyArray[1, 2, 3, 4, 5].take(1)).to be_an_instance_of(Array)
    end
  end
end
