require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/eql'

describe "Array#eql?" do
  it_behaves_like :array_eql, :eql?

  it "returns false if any corresponding elements are not #eql?" do
    expect([1, 2, 3, 4]).not_to eql([1, 2, 3, 4.0])
  end

  it "returns false if other is not a kind of Array" do
    obj = double("array eql?")
    expect(obj).not_to receive(:to_ary)
    expect(obj).not_to receive(:eql?)

    expect([1, 2, 3]).not_to eql(obj)
  end
end
