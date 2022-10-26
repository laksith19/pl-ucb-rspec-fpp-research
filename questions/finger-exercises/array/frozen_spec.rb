require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#frozen?" do
  it "returns true if array is frozen" do
    a = [1, 2, 3]
    expect(a).not_to.frozen?
    a.freeze
    expect(a).to.frozen?
  end

  it "returns false for an array being sorted by #sort" do
    a = [1, 2, 3]
    a.sort { |x,y| expect(a).not_to.frozen?; x <=> y }
  end
end
