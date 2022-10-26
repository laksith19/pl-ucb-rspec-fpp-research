require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/join'

describe "Array#*" do
  it "tries to convert the passed argument to a String using #to_str" do
    obj = double('separator')
    expect(obj).to receive(:to_str).and_return('::')
    expect([1, 2, 3, 4] * obj).to eq('1::2::3::4')
  end

  it "tires to convert the passed argument to an Integer using #to_int" do
    obj = double('count')
    expect(obj).to receive(:to_int).and_return(2)
    expect([1, 2, 3, 4] * obj).to eq([1, 2, 3, 4, 1, 2, 3, 4])
  end

  it "raises a TypeError if the argument can neither be converted to a string nor an integer" do
    obj = double('not a string or integer')
    expect{ [1,2] * obj }.to raise_error(TypeError)
  end

  it "converts the passed argument to a String rather than an Integer" do
    obj = double('2')
    def obj.to_int() 2 end
    def obj.to_str() "2" end
    expect([:a, :b, :c] * obj).to eq("a2b2c")
  end

  it "raises a TypeError is the passed argument is nil" do
    expect{ [1,2] * nil }.to raise_error(TypeError)
  end

  it "raises an ArgumentError when passed 2 or more arguments" do
    expect{ [1,2].send(:*, 1, 2) }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError when passed no arguments" do
    expect{ [1,2].send(:*) }.to raise_error(ArgumentError)
  end
end

describe "Array#* with an integer" do
  it "concatenates n copies of the array when passed an integer" do
    expect([ 1, 2, 3 ] * 0).to eq([])
    expect([ 1, 2, 3 ] * 1).to eq([1, 2, 3])
    expect([ 1, 2, 3 ] * 3).to eq([1, 2, 3, 1, 2, 3, 1, 2, 3])
    expect([] * 10).to eq([])
  end

  it "does not return self even if the passed integer is 1" do
    ary = [1, 2, 3]
    expect(ary * 1).not_to equal(ary)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty * 0).to eq([])
    expect(empty * 1).to eq(empty)
    expect(empty * 3).to eq([empty, empty, empty])

    array = ArraySpecs.recursive_array
    expect(array * 0).to eq([])
    expect(array * 1).to eq(array)
  end

  it "raises an ArgumentError when passed a negative integer" do
    expect { [ 1, 2, 3 ] * -1 }.to raise_error(ArgumentError)
    expect { [] * -1 }.to raise_error(ArgumentError)
  end

  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear

      @array = ArraySpecs::MyArray[1, 2, 3, 4, 5]
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance" do
        expect(@array * 0).to be_an_instance_of(ArraySpecs::MyArray)
        expect(@array * 1).to be_an_instance_of(ArraySpecs::MyArray)
        expect(@array * 2).to be_an_instance_of(ArraySpecs::MyArray)
      end
    end

    ruby_version_is '3.0' do
      it "returns an Array instance" do
        expect(@array * 0).to be_an_instance_of(Array)
        expect(@array * 1).to be_an_instance_of(Array)
        expect(@array * 2).to be_an_instance_of(Array)
      end
    end

    it "does not call #initialize on the subclass instance" do
      expect(@array * 2).to eq([1, 2, 3, 4, 5, 1, 2, 3, 4, 5])
      expect(ScratchPad.recorded).to be_nil
    end
  end
end

describe "Array#* with a string" do
  it_behaves_like :array_join_with_string_separator, :*
end
