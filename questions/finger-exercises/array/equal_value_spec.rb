require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/eql'

describe "Array#==" do
  it_behaves_like :array_eql, :==

  it "compares with an equivalent Array-like object using #to_ary" do
    obj = double('array-like')
    expect(obj).to receive(:respond_to?).at_least(1).with(:to_ary).and_return(true)
    expect(obj).to receive(:==).with([1]).at_least(1).and_return(true)

    expect([1] == obj).to be_true
    expect([[1]] == [obj]).to be_true
    expect([[[1], 3], 2] == [[obj, 3], 2]).to be_true

    # recursive arrays
    arr1 = [[1]]
    arr1 << arr1
    arr2 = [obj]
    arr2 << arr2
    expect(arr1 == arr2).to be_true
    expect(arr2 == arr1).to be_true
  end

  it "returns false if any corresponding elements are not #==" do
    a = ["a", "b", "c"]
    b = ["a", "b", "not equal value"]
    expect(a).not_to eq(b)

    c = double("c")
    expect(c).to receive(:==).and_return(false)
    expect(["a", "b", c]).not_to eq(a)
  end

  it "returns true if corresponding elements are #==" do
    expect([]).to eq([])
    expect(["a", "c", 7]).to eq(["a", "c", 7])

    expect([1, 2, 3]).to eq([1.0, 2.0, 3.0])

    obj = double('5')
    expect(obj).to receive(:==).and_return(true)
    expect([obj]).to eq([5])
  end

  # See https://bugs.ruby-lang.org/issues/1720
  it "returns true for [NaN] == [NaN] because Array#== first checks with #equal? and NaN.equal?(NaN) is true" do
    expect([Float::NAN]).to eq([Float::NAN])
  end
end
