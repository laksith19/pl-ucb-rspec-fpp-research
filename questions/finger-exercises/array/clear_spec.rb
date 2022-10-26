require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#clear" do
  it "removes all elements" do
    a = [1, 2, 3, 4]
    expect(a.clear).to equal(a)
    expect(a).to eq([])
  end

  it "returns self" do
    a = [1]
    expect(a).to equal a.clear
  end

  it "leaves the Array empty" do
    a = [1]
    a.clear
    expect(a).to.empty?
    expect(a.size).to eq(0)
  end

  it "does not accept any arguments" do
    expect { [1].clear(true) }.to raise_error(ArgumentError)
  end

  it "raises a FrozenError on a frozen array" do
    a = [1]
    a.freeze
    expect { a.clear }.to raise_error(FrozenError)
  end
end
