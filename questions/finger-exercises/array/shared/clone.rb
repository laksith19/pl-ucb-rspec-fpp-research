describe :array_clone, shared: true do
  it "returns an Array or a subclass instance" do
    expect([].send(@method)).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2].send(@method)).to be_an_instance_of(ArraySpecs::MyArray)
  end

  it "produces a shallow copy where the references are directly copied" do
    a = [double('1'), double('2')]
    b = a.send @method
    expect(b.first).to equal a.first
    expect(b.last).to equal a.last
  end

  it "creates a new array containing all elements or the original" do
    a = [1, 2, 3, 4]
    b = a.send @method
    expect(b).to eq(a)
    expect(b.__id__).not_to eq(a.__id__)
  end
end
