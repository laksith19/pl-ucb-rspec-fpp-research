require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#include?" do
  it "returns true if object is present, false otherwise" do
    expect([1, 2, "a", "b"].include?("c")).to eq(false)
    expect([1, 2, "a", "b"].include?("a")).to eq(true)
  end

  it "determines presence by using element == obj" do
    o = double('')

    expect([1, 2, "a", "b"].include?(o)).to eq(false)

    def o.==(other); other == 'a'; end

    expect([1, 2, o, "b"].include?('a')).to eq(true)

    expect([1, 2.0, 3].include?(2)).to eq(true)
  end

  it "calls == on elements from left to right until success" do
    key = "x"
    one = double('one')
    two = double('two')
    three = double('three')
    allow(one).to receive(:==).and_return(false)
    allow(two).to receive(:==).and_return(true)
    expect(three).not_to receive(:==)
    ary = [one, two, three]
    expect(ary.include?(key)).to eq(true)
  end
end
