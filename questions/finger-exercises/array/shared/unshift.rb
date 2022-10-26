describe :array_unshift, shared: true do
  it "prepends object to the original array" do
    a = [1, 2, 3]
    expect(a.send(@method, "a")).to equal(a)
    expect(a).to eq(['a', 1, 2, 3])
    expect(a.send(@method)).to equal(a)
    expect(a).to eq(['a', 1, 2, 3])
    a.send(@method, 5, 4, 3)
    expect(a).to eq([5, 4, 3, 'a', 1, 2, 3])

    # shift all but one element
    a = [1, 2]
    a.shift
    a.send(@method, 3, 4)
    expect(a).to eq([3, 4, 2])

    # now shift all elements
    a.shift
    a.shift
    a.shift
    a.send(@method, 3, 4)
    expect(a).to eq([3, 4])
  end

  it "quietly ignores unshifting nothing" do
    expect([].send(@method)).to eq([])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method, :new)).to eq([:new, empty])

    array = ArraySpecs.recursive_array
    array.send(@method, :new)
    expect(array[0..5]).to eq([:new, 1, 'two', 3.0, array, array])
  end

  it "raises a FrozenError on a frozen array when the array is modified" do
    expect { ArraySpecs.frozen_array.send(@method, 1) }.to raise_error(FrozenError)
  end

  # see [ruby-core:23666]
  it "raises a FrozenError on a frozen array when the array would not be modified" do
    expect { ArraySpecs.frozen_array.send(@method) }.to raise_error(FrozenError)
  end
end
