require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumeratorize'
require_relative 'shared/delete_if'
require_relative '../enumerable/shared/enumeratorized'

describe "Array#delete_if" do
  before do
    @a = [ "a", "b", "c" ]
  end

  it "removes each element for which block returns true" do
    @a = [ "a", "b", "c" ]
    @a.delete_if { |x| x >= "b" }
    expect(@a).to eq(["a"])
  end

  it "returns self" do
    expect(@a.delete_if{ true }.equal?(@a)).to be_true
  end

  it_behaves_like :enumeratorize, :delete_if

  it "returns self when called on an Array emptied with #shift" do
    array = [1]
    array.shift
    expect(array.delete_if { |x| true }).to equal(array)
  end

  it "returns an Enumerator if no block given, and the enumerator can modify the original array" do
    enum = @a.delete_if
    expect(enum).to be_an_instance_of(Enumerator)
    expect(@a).not_to be_empty
    enum.each { true }
    expect(@a).to be_empty
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    expect(@a.freeze.delete_if).to be_an_instance_of(Enumerator)
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.delete_if {} }.to raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    expect { ArraySpecs.empty_frozen_array.delete_if {} }.to raise_error(FrozenError)
  end

  it_behaves_like :enumeratorized_with_origin_size, :delete_if, [1,2,3]
  it_behaves_like :delete_if, :delete_if
end
