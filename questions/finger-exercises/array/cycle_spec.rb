require_relative '../../spec_helper'
require_relative '../enumerable/shared/enumeratorized'

describe "Array#cycle" do
  before :each do
    ScratchPad.record []

    @array = [1, 2, 3]
    @prc = -> x { ScratchPad << x }
  end

  it "does not yield and returns nil when the array is empty and passed value is an integer" do
    expect([].cycle(6, &@prc)).to be_nil
    expect(ScratchPad.recorded).to eq([])
  end

  it "does not yield and returns nil when the array is empty and passed value is nil" do
    expect([].cycle(nil, &@prc)).to be_nil
    expect(ScratchPad.recorded).to eq([])
  end

  it "does not yield and returns nil when passed 0" do
    expect(@array.cycle(0, &@prc)).to be_nil
    expect(ScratchPad.recorded).to eq([])
  end

  it "iterates the array 'count' times yielding each item to the block" do
    @array.cycle(2, &@prc)
    expect(ScratchPad.recorded).to eq([1, 2, 3, 1, 2, 3])
  end

  it "iterates indefinitely when not passed a count" do
    @array.cycle do |x|
      ScratchPad << x
      break if ScratchPad.recorded.size > 7
    end
    expect(ScratchPad.recorded).to eq([1, 2, 3, 1, 2, 3, 1, 2])
  end

  it "iterates indefinitely when passed nil" do
    @array.cycle(nil) do |x|
      ScratchPad << x
      break if ScratchPad.recorded.size > 7
    end
    expect(ScratchPad.recorded).to eq([1, 2, 3, 1, 2, 3, 1, 2])
  end

  it "does not rescue StopIteration when not passed a count" do
    expect do
      @array.cycle { raise StopIteration }
    end.to raise_error(StopIteration)
  end

  it "does not rescue StopIteration when passed a count" do
    expect do
      @array.cycle(3) { raise StopIteration }
    end.to raise_error(StopIteration)
  end

  it "iterates the array Integer(count) times when passed a Float count" do
    @array.cycle(2.7, &@prc)
    expect(ScratchPad.recorded).to eq([1, 2, 3, 1, 2, 3])
  end

  it "calls #to_int to convert count to an Integer" do
    count = double("cycle count 2")
    expect(count).to receive(:to_int).and_return(2)

    @array.cycle(count, &@prc)
    expect(ScratchPad.recorded).to eq([1, 2, 3, 1, 2, 3])
  end

  it "raises a TypeError if #to_int does not return an Integer" do
    count = double("cycle count 2")
    expect(count).to receive(:to_int).and_return("2")

    expect { @array.cycle(count, &@prc) }.to raise_error(TypeError)
  end

  it "raises a TypeError if passed a String" do
    expect { @array.cycle("4") { } }.to raise_error(TypeError)
  end

  it "raises a TypeError if passed an Object" do
    expect { @array.cycle(double("cycle count")) { } }.to raise_error(TypeError)
  end

  it "raises a TypeError if passed true" do
    expect { @array.cycle(true) { } }.to raise_error(TypeError)
  end

  it "raises a TypeError if passed false" do
    expect { @array.cycle(false) { } }.to raise_error(TypeError)
  end

  before :all do
    @object = [1, 2, 3, 4]
    @empty_object = []
  end
  it_should_behave_like :enumeratorized_with_cycle_size
end
