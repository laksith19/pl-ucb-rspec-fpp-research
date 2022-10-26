describe :array_binary_union, shared: true do
  it "returns an array of elements that appear in either array (union)" do
    expect([].send(@method, [])).to eq([])
    expect([1, 2].send(@method, [])).to eq([1, 2])
    expect([].send(@method, [1, 2])).to eq([1, 2])
    expect([ 1, 2, 3, 4 ].send(@method, [ 3, 4, 5 ])).to eq([1, 2, 3, 4, 5])
  end

  it "creates an array with no duplicates" do
    expect([ 1, 2, 3, 1, 4, 5 ].send(@method, [ 1, 3, 4, 5, 3, 6 ])).to eq([1, 2, 3, 4, 5, 6])
  end

  it "creates an array with elements in order they are first encountered" do
    expect([ 1, 2, 3, 1 ].send(@method, [ 1, 3, 4, 5 ])).to eq([1, 2, 3, 4, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method, empty)).to eq(empty)

    array = ArraySpecs.recursive_array
    expect(array.send(@method, [])).to eq([1, 'two', 3.0, array])
    expect([].send(@method, array)).to eq([1, 'two', 3.0, array])
    expect(array.send(@method, array)).to eq([1, 'two', 3.0, array])
    expect(array.send(@method, empty)).to eq([1, 'two', 3.0, array, empty])
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('[1,2,3]')
    expect(obj).to receive(:to_ary).and_return([1, 2, 3])
    expect([0].send(@method, obj)).to eq([0] | [1, 2, 3])
  end

  # MRI follows hashing semantics here, so doesn't actually call eql?/hash for Integer/Symbol
  it "acts as if using an intermediate hash to collect values" do
    not_supported_on :opal do
      expect([5.0, 4.0].send(@method, [5, 4])).to eq([5.0, 4.0, 5, 4])
    end

    str = "x"
    expect([str].send(@method, [str.dup])).to eq([str])

    obj1 = double('1')
    obj2 = double('2')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj2).to receive(:eql?).at_least(1).and_return(true)

    expect([obj1].send(@method, [obj2])).to eq([obj1])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([obj1])

    obj1 = double('3')
    obj2 = double('4')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj2).to receive(:eql?).at_least(1).and_return(false)

    expect([obj1].send(@method, [obj2])).to eq([obj1, obj2])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([obj1, obj2])
  end

  it "does not return subclass instances for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, [])).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_an_instance_of(Array)
    expect([].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_an_instance_of(Array)
  end

  it "does not call to_ary on array subclasses" do
    expect([1, 2].send(@method, ArraySpecs::ToAryArray[5, 6])).to eq([1, 2, 5, 6])
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = double('x')
    allow(x).to receive(:hash).and_return(42)
    allow(x).to receive(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    expect([x].send(@method, [x])).to eq([x])
  end
end
