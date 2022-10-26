require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative '../shared/enumeratorize'
require_relative '../shared/keep_if'
require_relative '../../enumerable/shared/enumeratorized'

describe :array_select, shared: true do
  it_should_behave_like :enumeratorize

  before :each do
    @object = [1,2,3]
  end
  it_should_behave_like :enumeratorized_with_origin_size

  it "returns a new array of elements for which block is true" do
    expect([1, 3, 4, 5, 6, 9].send(@method) { |i| i % ((i + 1) / 2) == 0}).to eq([1, 4, 6])
  end

  it "does not return subclass instance on Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method) { true }).to be_an_instance_of(Array)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method) { true }).to eq(empty)
    expect(empty.send(@method) { false }).to eq([])

    array = ArraySpecs.recursive_array
    expect(array.send(@method) { true }).to eq([1, 'two', 3.0, array, array, array, array, array])
    expect(array.send(@method) { false }).to eq([])
  end
end
