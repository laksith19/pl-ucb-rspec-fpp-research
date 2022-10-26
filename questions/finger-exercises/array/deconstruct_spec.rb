require_relative '../../spec_helper'

describe "Array#deconstruct" do
  it "returns self" do
    array = [1]

    expect(array.deconstruct).to equal array
  end
end
