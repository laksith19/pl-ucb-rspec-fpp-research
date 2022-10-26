require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#rotate" do
  describe "when passed no argument" do
    it "returns a copy of the array with the first element moved at the end" do
      expect([1, 2, 3, 4, 5].rotate).to eq([2, 3, 4, 5, 1])
    end
  end

  describe "with an argument n" do
    it "returns a copy of the array with the first (n % size) elements moved at the end" do
      a = [1, 2, 3, 4, 5]
      expect(a.rotate(  2)).to eq([3, 4, 5, 1, 2])
      expect(a.rotate( -1)).to eq([5, 1, 2, 3, 4])
      expect(a.rotate(-21)).to eq([5, 1, 2, 3, 4])
      expect(a.rotate( 13)).to eq([4, 5, 1, 2, 3])
      expect(a.rotate(  0)).to eq(a)
    end

    it "coerces the argument using to_int" do
      expect([1, 2, 3].rotate(2.6)).to eq([3, 1, 2])

      obj = double('integer_like')
      expect(obj).to receive(:to_int).and_return(2)
      expect([1, 2, 3].rotate(obj)).to eq([3, 1, 2])
    end

    it "raises a TypeError if not passed an integer-like argument" do
      expect {
        [1, 2].rotate(nil)
      }.to raise_error(TypeError)
      expect {
        [1, 2].rotate("4")
      }.to raise_error(TypeError)
    end
  end

  it "returns a copy of the array when its length is one or zero" do
    expect([1].rotate).to eq([1])
    expect([1].rotate(2)).to eq([1])
    expect([1].rotate(-42)).to eq([1])
    expect([ ].rotate).to eq([])
    expect([ ].rotate(2)).to eq([])
    expect([ ].rotate(-42)).to eq([])
  end

  it "does not mutate the receiver" do
    expect {
      [].freeze.rotate
      [2].freeze.rotate(2)
      [1,2,3].freeze.rotate(-3)
    }.not_to raise_error
  end

  it "does not return self" do
    a = [1, 2, 3]
    expect(a.rotate).not_to equal(a)
    a = []
    expect(a.rotate(0)).not_to equal(a)
  end

  it "does not return subclass instance for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].rotate).to be_an_instance_of(Array)
  end
end

describe "Array#rotate!" do
  describe "when passed no argument" do
    it "moves the first element to the end and returns self" do
      a = [1, 2, 3, 4, 5]
      expect(a.rotate!).to equal(a)
      expect(a).to eq([2, 3, 4, 5, 1])
    end
  end

  describe "with an argument n" do
    it "moves the first (n % size) elements at the end and returns self" do
      a = [1, 2, 3, 4, 5]
      expect(a.rotate!(2)).to equal(a)
      expect(a).to eq([3, 4, 5, 1, 2])
      expect(a.rotate!(-12)).to equal(a)
      expect(a).to eq([1, 2, 3, 4, 5])
      expect(a.rotate!(13)).to equal(a)
      expect(a).to eq([4, 5, 1, 2, 3])
    end

    it "coerces the argument using to_int" do
      expect([1, 2, 3].rotate!(2.6)).to eq([3, 1, 2])

      obj = double('integer_like')
      expect(obj).to receive(:to_int).and_return(2)
      expect([1, 2, 3].rotate!(obj)).to eq([3, 1, 2])
    end

    it "raises a TypeError if not passed an integer-like argument" do
      expect {
        [1, 2].rotate!(nil)
      }.to raise_error(TypeError)
      expect {
        [1, 2].rotate!("4")
      }.to raise_error(TypeError)
    end
  end

  it "does nothing and returns self when the length is zero or one" do
    a = [1]
    expect(a.rotate!).to equal(a)
    expect(a).to eq([1])
    expect(a.rotate!(2)).to equal(a)
    expect(a).to eq([1])
    expect(a.rotate!(-21)).to equal(a)
    expect(a).to eq([1])

    a = []
    expect(a.rotate!).to equal(a)
    expect(a).to eq([])
    expect(a.rotate!(2)).to equal(a)
    expect(a).to eq([])
    expect(a.rotate!(-21)).to equal(a)
    expect(a).to eq([])
  end

  it "raises a FrozenError on a frozen array" do
    expect { [1, 2, 3].freeze.rotate!(0) }.to raise_error(FrozenError)
    expect { [1].freeze.rotate!(42) }.to raise_error(FrozenError)
    expect { [].freeze.rotate! }.to raise_error(FrozenError)
  end
end
