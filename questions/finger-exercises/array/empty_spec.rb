require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#empty?" do
  it "returns true if the array has no elements" do
    expect([]).to.empty?
    expect([1]).not_to.empty?
    expect([1, 2]).not_to.empty?
  end
end
