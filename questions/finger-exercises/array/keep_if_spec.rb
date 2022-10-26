require_relative 'shared/keep_if'

describe "Array#keep_if" do
  it "returns the same array if no changes were made" do
    array = [1, 2, 3]
    expect(array.keep_if { true }).to equal(array)
  end

  it_behaves_like :keep_if, :keep_if
end
