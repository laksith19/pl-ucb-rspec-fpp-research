require_relative '../../spec_helper'

describe "Array" do
  it "includes Enumerable" do
    expect(Array.include?(Enumerable)).to eq(true)
  end
end
