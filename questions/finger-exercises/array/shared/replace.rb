describe :array_replace, shared: true do
  it "replaces the elements with elements from other array" do
    a = [1, 2, 3, 4, 5]
    b = ['a', 'b', 'c']
    expect(a.send(@method, b)).to equal(a)
    expect(a).to eq(b)
    expect(a).not_to equal(b)

    a.send(@method, [4] * 10)
    expect(a).to eq([4] * 10)

    a.send(@method, [])
    expect(a).to eq([])
  end

  it "properly handles recursive arrays" do
    orig = [1, 2, 3]
    empty = ArraySpecs.empty_recursive_array
    orig.send(@method, empty)
    expect(orig).to eq(empty)

    array = ArraySpecs.recursive_array
    orig.send(@method, array)
    expect(orig).to eq(array)
  end

  it "returns self" do
    ary = [1, 2, 3]
    other = [:a, :b, :c]
    expect(ary.send(@method, other)).to equal(ary)
  end

  it "does not make self dependent to the original array" do
    ary = [1, 2, 3]
    other = [:a, :b, :c]
    ary.send(@method, other)
    expect(ary).to eq([:a, :b, :c])
    ary << :d
    expect(ary).to eq([:a, :b, :c, :d])
    expect(other).to eq([:a, :b, :c])
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('to_ary')
    allow(obj).to receive(:to_ary).and_return([1, 2, 3])
    expect([].send(@method, obj)).to eq([1, 2, 3])
  end

  it "does not call #to_ary on Array subclasses" do
    obj = ArraySpecs::ToAryArray[5, 6, 7]
    expect(obj).not_to receive(:to_ary)
    expect([].send(@method, ArraySpecs::ToAryArray[5, 6, 7])).to eq([5, 6, 7])
  end

  it "raises a FrozenError on a frozen array" do
    expect {
      ArraySpecs.frozen_array.send(@method, ArraySpecs.frozen_array)
    }.to raise_error(FrozenError)
  end
end
