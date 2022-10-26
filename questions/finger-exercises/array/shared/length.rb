describe :array_length, shared: true do
  it "returns the number of elements" do
    expect([].send(@method)).to eq(0)
    expect([1, 2, 3].send(@method)).to eq(3)
  end

  it "properly handles recursive arrays" do
    expect(ArraySpecs.empty_recursive_array.send(@method)).to eq(1)
    expect(ArraySpecs.recursive_array.send(@method)).to eq(8)
  end
end
