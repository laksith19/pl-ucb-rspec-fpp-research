require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#delete" do
  it "removes elements that are #== to object" do
    x = double('delete')
    def x.==(other) 3 == other end

    a = [1, 2, 3, x, 4, 3, 5, x]
    a.delete double('not contained')
    expect(a).to eq([1, 2, 3, x, 4, 3, 5, x])

    a.delete 3
    expect(a).to eq([1, 2, 4, 5])
  end

  it "calculates equality correctly for reference values" do
    a = ["foo", "bar", "foo", "quux", "foo"]
    a.delete "foo"
    expect(a).to eq(["bar","quux"])
  end

  it "returns object or nil if no elements match object" do
    expect([1, 2, 4, 5].delete(1)).to eq(1)
    expect([1, 2, 4, 5].delete(3)).to eq(nil)
  end

  it "may be given a block that is executed if no element matches object" do
    expect([1].delete(1) {:not_found}).to eq(1)
    expect([].delete('a') {:not_found}).to eq(:not_found)
  end

  it "returns nil if the array is empty due to a shift" do
    a = [1]
    a.shift
    expect(a.delete(nil)).to eq(nil)
  end

  it "returns nil on a frozen array if a modification does not take place" do
    expect([1, 2, 3].freeze.delete(0)).to eq(nil)
  end

  it "raises a FrozenError on a frozen array" do
    expect { [1, 2, 3].freeze.delete(1) }.to raise_error(FrozenError)
  end
end
