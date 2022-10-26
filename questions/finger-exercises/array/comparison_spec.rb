require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#<=>" do
  it "calls <=> left to right and return first non-0 result" do
    [-1, +1, nil, "foobar"].each do |result|
      lhs = Array.new(3) { double("#{result}") }
      rhs = Array.new(3) { double("#{result}") }

      expect(lhs[0]).to receive(:<=>).with(rhs[0]).and_return(0)
      expect(lhs[1]).to receive(:<=>).with(rhs[1]).and_return(result)
      expect(lhs[2]).not_to receive(:<=>)

      expect(lhs <=> rhs).to eq(result)
    end
  end

  it "returns 0 if the arrays are equal" do
    expect([] <=> []).to eq(0)
    expect([1, 2, 3, 4, 5, 6] <=> [1, 2, 3, 4, 5.0, 6.0]).to eq(0)
  end

  it "returns -1 if the array is shorter than the other array" do
    expect([] <=> [1]).to eq(-1)
    expect([1, 1] <=> [1, 1, 1]).to eq(-1)
  end

  it "returns +1 if the array is longer than the other array" do
    expect([1] <=> []).to eq(+1)
    expect([1, 1, 1] <=> [1, 1]).to eq(+1)
  end

  it "returns -1 if the arrays have same length and a pair of corresponding elements returns -1 for <=>" do
    eq_l = double('an object equal to the other')
    eq_r = double('an object equal to the other')
    allow(eq_l).to receive(:<=>).with(eq_r).and_return(0)

    less = double('less than the other')
    greater = double('greater then the other')
    allow(less).to receive(:<=>).with(greater).and_return(-1)

    rest = double('an rest element of the arrays')
    allow(rest).to receive(:<=>).with(rest).and_return(0)
    lhs = [eq_l, eq_l, less, rest]
    rhs = [eq_r, eq_r, greater, rest]

    expect(lhs <=> rhs).to eq(-1)
  end

  it "returns +1 if the arrays have same length and a pair of corresponding elements returns +1 for <=>" do
    eq_l = double('an object equal to the other')
    eq_r = double('an object equal to the other')
    allow(eq_l).to receive(:<=>).with(eq_r).and_return(0)

    greater = double('greater then the other')
    less = double('less than the other')
    allow(greater).to receive(:<=>).with(less).and_return(+1)

    rest = double('an rest element of the arrays')
    allow(rest).to receive(:<=>).with(rest).and_return(0)
    lhs = [eq_l, eq_l, greater, rest]
    rhs = [eq_r, eq_r, less, rest]

    expect(lhs <=> rhs).to eq(+1)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty <=> empty).to eq(0)
    expect(empty <=> []).to eq(1)
    expect([] <=> empty).to eq(-1)

    expect(ArraySpecs.recursive_array <=> []).to eq(1)
    expect([] <=> ArraySpecs.recursive_array).to eq(-1)

    expect(ArraySpecs.recursive_array <=> ArraySpecs.empty_recursive_array).to eq(nil)

    array = ArraySpecs.recursive_array
    expect(array <=> array).to eq(0)
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('to_ary')
    allow(obj).to receive(:to_ary).and_return([1, 2, 3])
    expect([4, 5] <=> obj).to eq([4, 5] <=> obj.to_ary)
  end

  it "does not call #to_ary on Array subclasses" do
    obj = ArraySpecs::ToAryArray[5, 6, 7]
    expect(obj).not_to receive(:to_ary)
    expect([5, 6, 7] <=> obj).to eq(0)
  end

  it "returns nil when the argument is not array-like" do
    expect([] <=> false).to be_nil
  end
end
