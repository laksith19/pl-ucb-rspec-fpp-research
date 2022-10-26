require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumeratorize'
require_relative 'shared/delete_if'
require_relative '../enumerable/shared/enumeratorized'

describe "Array#reject" do
  it "returns a new array without elements for which block is true" do
    ary = [1, 2, 3, 4, 5]
    expect(ary.reject { true }).to eq([])
    expect(ary.reject { false }).to eq(ary)
    expect(ary.reject { false }).not_to equal ary
    expect(ary.reject { nil }).to eq(ary)
    expect(ary.reject { nil }).not_to equal ary
    expect(ary.reject { 5 }).to eq([])
    expect(ary.reject { |i| i < 3 }).to eq([3, 4, 5])
    expect(ary.reject { |i| i % 2 == 0 }).to eq([1, 3, 5])
  end

  it "returns self when called on an Array emptied with #shift" do
    array = [1]
    array.shift
    expect(array.reject { |x| true }).to eq([])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.reject { false }).to eq([empty])
    expect(empty.reject { true }).to eq([])

    array = ArraySpecs.recursive_array
    expect(array.reject { false }).to eq([1, 'two', 3.0, array, array, array, array, array])
    expect(array.reject { true }).to eq([])
  end

  it "does not return subclass instance on Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].reject { |x| x % 2 == 0 }).to be_an_instance_of(Array)
  end

  it "does not retain instance variables" do
    array = []
    array.instance_variable_set("@variable", "value")
    expect(array.reject { false }.instance_variable_get("@variable")).to eq(nil)
  end

  it_behaves_like :enumeratorize, :reject
  it_behaves_like :enumeratorized_with_origin_size, :reject, [1,2,3]
end

describe "Array#reject!" do
  it "removes elements for which block is true" do
    a = [3, 4, 5, 6, 7, 8, 9, 10, 11]
    expect(a.reject! { |i| i % 2 == 0 }).to equal(a)
    expect(a).to eq([3, 5, 7, 9, 11])
    a.reject! { |i| i > 8 }
    expect(a).to eq([3, 5, 7])
    a.reject! { |i| i < 4 }
    expect(a).to eq([5, 7])
    a.reject! { |i| i == 5 }
    expect(a).to eq([7])
    a.reject! { true }
    expect(a).to eq([])
    a.reject! { true }
    expect(a).to eq([])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    empty_dup = empty.dup
    expect(empty.reject! { false }).to eq(nil)
    expect(empty).to eq(empty_dup)

    empty = ArraySpecs.empty_recursive_array
    expect(empty.reject! { true }).to eq([])
    expect(empty).to eq([])

    array = ArraySpecs.recursive_array
    array_dup = array.dup
    expect(array.reject! { false }).to eq(nil)
    expect(array).to eq(array_dup)

    array = ArraySpecs.recursive_array
    expect(array.reject! { true }).to eq([])
    expect(array).to eq([])
  end

  it "returns nil when called on an Array emptied with #shift" do
    array = [1]
    array.shift
    expect(array.reject! { |x| true }).to eq(nil)
  end

  it "returns nil if no changes are made" do
    a = [1, 2, 3]

    expect(a.reject! { |i| i < 0 }).to eq(nil)

    a.reject! { true }
    expect(a.reject! { true }).to eq(nil)
  end

  it "returns an Enumerator if no block given, and the array is frozen" do
    expect(ArraySpecs.frozen_array.reject!).to be_an_instance_of(Enumerator)
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.reject! {} }.to raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    expect { ArraySpecs.empty_frozen_array.reject! {} }.to raise_error(FrozenError)
  end

  it "does not truncate the array is the block raises an exception" do
    a = [1, 2, 3]
    begin
      a.reject! { raise StandardError, 'Oops' }
    rescue
    end

    expect(a).to eq([1, 2, 3])
  end

  it "only removes elements for which the block returns true, keeping the element which raised an error." do
    a = [1, 2, 3, 4]
    begin
      a.reject! do |x|
        case x
        when 2 then true
        when 3 then raise StandardError, 'Oops'
        else false
        end
      end
    rescue StandardError
    end

    expect(a).to eq([1, 3, 4])
  end

  it_behaves_like :enumeratorize, :reject!
  it_behaves_like :enumeratorized_with_origin_size, :reject!, [1,2,3]
  it_behaves_like :delete_if, :reject!
end
