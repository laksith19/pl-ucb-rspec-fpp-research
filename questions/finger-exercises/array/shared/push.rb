describe :array_push, shared: true do
  it "appends the arguments to the array" do
    a = [ "a", "b", "c" ]
    expect(a.send(@method, "d", "e", "f")).to equal(a)
    expect(a.send(@method)).to eq(["a", "b", "c", "d", "e", "f"])
    a.send(@method, 5)
    expect(a).to eq(["a", "b", "c", "d", "e", "f", 5])

    a = [0, 1]
    a.send(@method, 2)
    expect(a).to eq([0, 1, 2])
  end

  it "isn't confused by previous shift" do
    a = [ "a", "b", "c" ]
    a.shift
    a.send(@method, "foo")
    expect(a).to eq(["b", "c", "foo"])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method, :last)).to eq([empty, :last])

    array = ArraySpecs.recursive_array
    expect(array.send(@method, :last)).to eq([1, 'two', 3.0, array, array, array, array, array, :last])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.send(@method, 1) }.to raise_error(FrozenError)
    expect { ArraySpecs.frozen_array.send(@method) }.to raise_error(FrozenError)
  end
end
