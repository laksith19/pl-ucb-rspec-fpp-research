describe :array_intersection, shared: true do
  it "creates an array with elements common to both arrays (intersection)" do
    expect([].send(@method, [])).to eq([])
    expect([1, 2].send(@method, [])).to eq([])
    expect([].send(@method, [1, 2])).to eq([])
    expect([ 1, 3, 5 ].send(@method, [ 1, 2, 3 ])).to eq([1, 3])
  end

  it "creates an array with no duplicates" do
    expect([ 1, 1, 3, 5 ].send(@method, [ 1, 2, 3 ]).uniq!).to eq(nil)
  end

  it "creates an array with elements in order they are first encountered" do
    expect([ 1, 2, 3, 2, 5 ].send(@method, [ 5, 2, 3, 4 ])).to eq([2, 3, 5])
  end

  it "does not modify the original Array" do
    a = [1, 1, 3, 5]
    expect(a.send(@method, [1, 2, 3])).to eq([1, 3])
    expect(a).to eq([1, 1, 3, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.send(@method, empty)).to eq(empty)

    expect(ArraySpecs.recursive_array.send(@method, [])).to eq([])
    expect([].send(@method, ArraySpecs.recursive_array)).to eq([])

    expect(ArraySpecs.recursive_array.send(@method, ArraySpecs.recursive_array)).to eq([1, 'two', 3.0, ArraySpecs.recursive_array])
  end

  it "tries to convert the passed argument to an Array using #to_ary" do
    obj = double('[1,2,3]')
    expect(obj).to receive(:to_ary).and_return([1, 2, 3])
    expect([1, 2].send(@method, obj)).to eq([1, 2])
  end

  it "determines equivalence between elements in the sense of eql?" do
    not_supported_on :opal do
      expect([5.0, 4.0].send(@method, [5, 4])).to eq([])
    end

    str = "x"
    expect([str].send(@method, [str.dup])).to eq([str])

    obj1 = double('1')
    obj2 = double('2')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj1).to receive(:eql?).at_least(1).and_return(true)
    allow(obj2).to receive(:eql?).and_return(true)

    expect([obj1].send(@method, [obj2])).to eq([obj1])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([obj1])

    obj1 = double('3')
    obj2 = double('4')
    allow(obj1).to receive(:hash).and_return(0)
    allow(obj2).to receive(:hash).and_return(0)
    expect(obj1).to receive(:eql?).at_least(1).and_return(false)

    expect([obj1].send(@method, [obj2])).to eq([])
    expect([obj1, obj1, obj2, obj2].send(@method, [obj2])).to eq([obj2])
  end

  it "does return subclass instances for Array subclasses" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, [])).to be_an_instance_of(Array)
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_an_instance_of(Array)
    expect([].send(@method, ArraySpecs::MyArray[1, 2, 3])).to be_an_instance_of(Array)
  end

  it "does not call to_ary on array subclasses" do
    expect([5, 6].send(@method, ArraySpecs::ToAryArray[1, 2, 5, 6])).to eq([5, 6])
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = double('x')
    allow(x).to receive(:hash).and_return(42)
    allow(x).to receive(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    expect([x].send(@method, [x])).to eq([x])
  end
end
