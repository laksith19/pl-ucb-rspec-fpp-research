require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#zip" do
  it "returns an array of arrays containing corresponding elements of each array" do
    expect([1, 2, 3, 4].zip(["a", "b", "c", "d", "e"])).to eq(
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
    )
  end

  it "fills in missing values with nil" do
    expect([1, 2, 3, 4, 5].zip(["a", "b", "c", "d"])).to eq(
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"], [5, nil]]
    )
  end

  it "properly handles recursive arrays" do
    a = []; a << a
    b = [1]; b << b

    expect(a.zip(a)).to eq([ [a[0], a[0]] ])
    expect(a.zip(b)).to eq([ [a[0], b[0]] ])
    expect(b.zip(a)).to eq([ [b[0], a[0]], [b[1], a[1]] ])
    expect(b.zip(b)).to eq([ [b[0], b[0]], [b[1], b[1]] ])
  end

  it "calls #to_ary to convert the argument to an Array" do
    obj = double('[3,4]')
    expect(obj).to receive(:to_ary).and_return([3, 4])
    expect([1, 2].zip(obj)).to eq([[1, 3], [2, 4]])
  end

  it "uses #each to extract arguments' elements when #to_ary fails" do
    obj = Class.new do
      def each(&b)
        [3,4].each(&b)
      end
    end.new

    expect([1, 2].zip(obj)).to eq([[1, 3], [2, 4]])
  end

  it "stops at own size when given an infinite enumerator" do
    expect([1, 2].zip(10.upto(Float::INFINITY))).to eq([[1, 10], [2, 11]])
  end

  it "fills nil when the given enumerator is shorter than self" do
    obj = Object.new
    def obj.each
      yield 10
    end
    expect([1, 2].zip(obj)).to eq([[1, 10], [2, nil]])
  end

  it "calls block if supplied" do
    values = []
    expect([1, 2, 3, 4].zip(["a", "b", "c", "d", "e"]) { |value|
      values << value
    }).to eq(nil)

    expect(values).to eq([[1, "a"], [2, "b"], [3, "c"], [4, "d"]])
  end

  it "does not return subclass instance on Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].zip(["a", "b"])).to be_an_instance_of(Array)
  end
end
