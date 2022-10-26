require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#hash" do
  it "returns the same fixnum for arrays with the same content" do
    expect([].respond_to?(:hash)).to eq(true)

    [[], [1, 2, 3]].each do |ary|
      expect(ary.hash).to eq(ary.dup.hash)
      expect(ary.hash).to be_an_instance_of(Integer)
    end
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect { empty.hash }.not_to raise_error

    array = ArraySpecs.recursive_array
    expect { array.hash }.not_to raise_error
  end

  it "returns the same hash for equal recursive arrays" do
    rec = []; rec << rec
    expect(rec.hash).to eq([rec].hash)
    expect(rec.hash).to eq([[rec]].hash)
    # This is because rec.eql?([[rec]])
    # Remember that if two objects are eql?
    # then the need to have the same hash
    # Check the Array#eql? specs!
  end

  it "returns the same hash for equal recursive arrays through hashes" do
    h = {} ; rec = [h] ; h[:x] = rec
    expect(rec.hash).to eq([h].hash)
    expect(rec.hash).to eq([{x: rec}].hash)
    # Like above, this is because rec.eql?([{x: rec}])
  end

  it "calls to_int on result of calling hash on each element" do
    ary = Array.new(5) do
      obj = double('0')
      expect(obj).to receive(:hash).and_return(obj)
      expect(obj).to receive(:to_int).and_return(0)
      obj
    end

    ary.hash


    hash = double('1')
    expect(hash).to receive(:to_int).and_return(1.hash)

    obj = double('@hash')
    obj.instance_variable_set(:@hash, hash)
    def obj.hash() @hash end

    expect([obj].hash).to eq([1].hash)
  end

  it "ignores array class differences" do
    expect(ArraySpecs::MyArray[].hash).to eq([].hash)
    expect(ArraySpecs::MyArray[1, 2].hash).to eq([1, 2].hash)
  end

  it "returns same hash code for arrays with the same content" do
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    expect(a.hash).to eq(b.hash)
  end

  it "returns the same value if arrays are #eql?" do
    a = [1, 2, 3, 4]
    a.fill 'a', 0..3
    b = %w|a a a a|
    expect(a.hash).to eq(b.hash)
    expect(a).to eql(b)
  end

  it "produces different hashes for nested arrays with different values and empty terminator" do
    expect([1, [1, []]].hash).not_to eq([2, [2, []]].hash)
  end
end
