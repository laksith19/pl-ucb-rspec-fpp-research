describe :array_binary_difference, shared: true do
  it "creates an array minus any items from other array" do
    expect([].send(@method, [ 1, 2, 4 ])).to eq([])
    expect([1, 2, 4].send(@method, [])).to eq([1, 2, 4])
    expect([ 1, 2, 3, 4, 5 ].send(@method, [ 1, 2, 4 ])).to eq([3, 5])
  end

  it "removes multiple items on the lhs equal to one on the rhs" do
    expect([1, 1, 2, 2, 3, 3, 4, 5].send(@method, [1, 2, 4])).to eq([3, 3, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method, empty)).to eq([])

    expect([].send(@method, ArraySpecs.recursive_array)).to eq([])

    array = ArraySpecs.recursive_array
    expect(array.send(@method, array)).to eq([])
  end

  it "tries to convert the passed arguments to Arrays using #to_ary" do
    obj = double('[2,3,3,4]')
    expect(obj).to receive(:to_ary).and_return([2, 3, 3, 4])
    expect([1, 1, 2, 2, 3, 4].send(@method, obj)).to eq([1, 1])
  end

  it "raises a TypeError if the argument cannot be coerced to an Array by calling #to_ary" do
    obj = double('not an array')
    expect { [1, 2, 3].send(@method, obj) }.to raise_error(TypeError)
  end

  it "does not return subclass instance for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, [])).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, ArraySpecs::MyArray[])).to be_an_instance_of(Array)
    expect([1, 2, 3].send(@method, ArraySpecs::MyArray[])).to be_an_instance_of(Array)
  end

  it "does not call to_ary on array subclasses" do
    expect([5, 6, 7].send(@method, ArraySpecs::ToAryArray[7])).to eq([5, 6])
  end

  it "removes an item identified as equivalent via #hash and #eql?" do
    obj1 = double('1')
    obj2 = double('2')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj1).to receive(:eql?).at_least(1).and_return(true)

    expect([obj1].send(@method, [obj2])).to eq([])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([])
  end

  it "doesn't remove an item with the same hash but not #eql?" do
    obj1 = double('1')
    obj2 = double('2')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj1).to receive(:eql?).at_least(1).and_return(false)

    expect([obj1].send(@method, [obj2])).to eq([obj1])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([obj1, obj1])
  end

  it "removes an identical item even when its #eql? isn't reflexive" do
    x = double('x')
    allow(x).to receive(:hash).and_return(42)
    allow(x).to receive(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    expect([x].send(@method, [x])).to eq([])
  end

  it "is not destructive" do
    a = [1, 2, 3]
    a.send(@method, [1])
    expect(a).to eq([1, 2, 3])
  end
end
