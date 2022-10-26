require_relative '../../spec_helper'

describe "Array#count" do
  it "returns the number of elements" do
    expect([:a, :b, :c].count).to eq(3)
  end

  it "returns the number of elements that equal the argument" do
    expect([:a, :b, :b, :c].count(:b)).to eq(2)
  end

  it "returns the number of element for which the block evaluates to true" do
    expect([:a, :b, :c].count { |s| s != :b }).to eq(2)
  end
end
