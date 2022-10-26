require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/slice'

describe "Array#[]" do
  it_behaves_like :array_slice, :[]
end

describe "Array.[]" do
  it "[] should return a new array populated with the given elements" do
    array = Array[1, 'a', nil]
    expect(array[0]).to eq(1)
    expect(array[1]).to eq('a')
    expect(array[2]).to eq(nil)
  end

  it "when applied to a literal nested array, unpacks its elements into the containing array" do
    expect(Array[1, 2, *[3, 4, 5]]).to eq([1, 2, 3, 4, 5])
  end

  it "when applied to a nested referenced array, unpacks its elements into the containing array" do
    splatted_array = Array[3, 4, 5]
    expect(Array[1, 2, *splatted_array]).to eq([1, 2, 3, 4, 5])
  end

  it "can unpack 2 or more nested referenced array" do
    splatted_array = Array[3, 4, 5]
    splatted_array2 = Array[6, 7, 8]
    expect(Array[1, 2, *splatted_array, *splatted_array2]).to eq([1, 2, 3, 4, 5, 6, 7, 8])
  end

  it "constructs a nested Hash for tailing key-value pairs" do
    expect(Array[1, 2, 3 => 4, 5 => 6]).to eq([1, 2, { 3 => 4, 5 => 6 }])
  end

  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear
    end

    it "returns an instance of the subclass" do
      expect(ArraySpecs::MyArray[1, 2, 3]).to be_an_instance_of(ArraySpecs::MyArray)
    end

    it "does not call #initialize on the subclass instance" do
      expect(ArraySpecs::MyArray[1, 2, 3]).to eq([1, 2, 3])
      expect(ScratchPad.recorded).to be_nil
    end
  end
end
