require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#assoc" do
  it "returns the first array whose 1st item is == obj or nil" do
    s1 = ["colors", "red", "blue", "green"]
    s2 = [:letters, "a", "b", "c"]
    s3 = [4]
    s4 = ["colors", "cyan", "yellow", "magenda"]
    s5 = [:letters, "a", "i", "u"]
    s_nil = [nil, nil]
    a = [s1, s2, s3, s4, s5, s_nil]
    expect(a.assoc(s1.first)).to equal(s1)
    expect(a.assoc(s2.first)).to equal(s2)
    expect(a.assoc(s3.first)).to equal(s3)
    expect(a.assoc(s4.first)).to equal(s1)
    expect(a.assoc(s5.first)).to equal(s2)
    expect(a.assoc(s_nil.first)).to equal(s_nil)
    expect(a.assoc(4)).to equal(s3)
    expect(a.assoc("key not in array")).to be_nil
  end

  it "calls == on first element of each array" do
    key1 = 'it'
    key2 = double('key2')
    items = [['not it', 1], [ArraySpecs::AssocKey.new, 2], ['na', 3]]

    expect(items.assoc(key1)).to equal(items[1])
    expect(items.assoc(key2)).to be_nil
  end

  it "ignores any non-Array elements" do
    expect([1, 2, 3].assoc(2)).to be_nil
    s1 = [4]
    s2 = [5, 4, 3]
    a = ["foo", [], s1, s2, nil, []]
    expect(a.assoc(s1.first)).to equal(s1)
    expect(a.assoc(s2.first)).to equal(s2)
  end
end
