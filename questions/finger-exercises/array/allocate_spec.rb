require_relative '../../spec_helper'

describe "Array.allocate" do
  it "returns an instance of Array" do
    ary = Array.allocate
    expect(ary).to be_an_instance_of(Array)
  end

  it "returns a fully-formed instance of Array" do
    ary = Array.allocate
    expect(ary.size).to eq(0)
    ary << 1
    expect(ary).to eq([1])
  end

  it "does not accept any arguments" do
    expect { Array.allocate(1) }.to raise_error(ArgumentError)
  end
end
