require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/slice'

describe "Array#slice!" do
  it "removes and return the element at index" do
    a = [1, 2, 3, 4]
    expect(a.slice!(10)).to eq(nil)
    expect(a).to eq([1, 2, 3, 4])
    expect(a.slice!(-10)).to eq(nil)
    expect(a).to eq([1, 2, 3, 4])
    expect(a.slice!(2)).to eq(3)
    expect(a).to eq([1, 2, 4])
    expect(a.slice!(-1)).to eq(4)
    expect(a).to eq([1, 2])
    expect(a.slice!(1)).to eq(2)
    expect(a).to eq([1])
    expect(a.slice!(-1)).to eq(1)
    expect(a).to eq([])
    expect(a.slice!(-1)).to eq(nil)
    expect(a).to eq([])
    expect(a.slice!(0)).to eq(nil)
    expect(a).to eq([])
  end

  it "removes and returns length elements beginning at start" do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.slice!(2, 3)).to eq([3, 4, 5])
    expect(a).to eq([1, 2, 6])
    expect(a.slice!(1, 1)).to eq([2])
    expect(a).to eq([1, 6])
    expect(a.slice!(1, 0)).to eq([])
    expect(a).to eq([1, 6])
    expect(a.slice!(2, 0)).to eq([])
    expect(a).to eq([1, 6])
    expect(a.slice!(0, 4)).to eq([1, 6])
    expect(a).to eq([])
    expect(a.slice!(0, 4)).to eq([])
    expect(a).to eq([])

    a = [1]
    expect(a.slice!(0, 1)).to eq([1])
    expect(a).to eq([])
    expect(a[-1]).to eq(nil)

    a = [1, 2, 3]
    expect(a.slice!(0,1)).to eq([1])
    expect(a).to eq([2, 3])
  end

  it "returns nil if length is negative" do
    a = [1, 2, 3]
    expect(a.slice!(2, -1)).to eq(nil)
    expect(a).to eq([1, 2, 3])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.slice(0)).to eq(empty)

    array = ArraySpecs.recursive_array
    expect(array.slice(4)).to eq(array)
    expect(array.slice(0..3)).to eq([1, 'two', 3.0, array])
  end

  it "calls to_int on start and length arguments" do
    obj = double('2')
    def obj.to_int() 2 end

    a = [1, 2, 3, 4, 5]
    expect(a.slice!(obj)).to eq(3)
    expect(a).to eq([1, 2, 4, 5])
    expect(a.slice!(obj, obj)).to eq([4, 5])
    expect(a).to eq([1, 2])
    expect(a.slice!(0, obj)).to eq([1, 2])
    expect(a).to eq([])
  end

  it "removes and return elements in range" do
    a = [1, 2, 3, 4, 5, 6, 7, 8]
    expect(a.slice!(1..4)).to eq([2, 3, 4, 5])
    expect(a).to eq([1, 6, 7, 8])
    expect(a.slice!(1...3)).to eq([6, 7])
    expect(a).to eq([1, 8])
    expect(a.slice!(-1..-1)).to eq([8])
    expect(a).to eq([1])
    expect(a.slice!(0...0)).to eq([])
    expect(a).to eq([1])
    expect(a.slice!(0..0)).to eq([1])
    expect(a).to eq([])

    a = [1,2,3]
    expect(a.slice!(0..3)).to eq([1,2,3])
    expect(a).to eq([])
  end

  it "removes and returns elements in end-exclusive ranges" do
    a = [1, 2, 3, 4, 5, 6, 7, 8]
    expect(a.slice!(4...a.length)).to eq([5, 6, 7, 8])
    expect(a).to eq([1, 2, 3, 4])
  end

  it "calls to_int on range arguments" do
    from = double('from')
    to = double('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    a = [1, 2, 3, 4, 5]

    expect(a.slice!(from .. to)).to eq([2, 3, 4])
    expect(a).to eq([1, 5])

    expect { a.slice!("a" .. "b")  }.to raise_error(TypeError)
    expect { a.slice!(from .. "b") }.to raise_error(TypeError)
  end

  it "returns last element for consecutive calls at zero index" do
    a = [ 1, 2, 3 ]
    expect(a.slice!(0)).to eq(1)
    expect(a.slice!(0)).to eq(2)
    expect(a.slice!(0)).to eq(3)
    expect(a).to eq([])
  end

  it "does not expand array with indices out of bounds" do
    a = [1, 2]
    expect(a.slice!(4)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.slice!(4, 0)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.slice!(6, 1)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.slice!(8...8)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.slice!(10..10)).to eq(nil)
    expect(a).to eq([1, 2])
  end

  it "does not expand array with negative indices out of bounds" do
    a = [1, 2]
    expect(a.slice!(-3, 1)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.slice!(-3..2)).to eq(nil)
    expect(a).to eq([1, 2])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.slice!(0, 0) }.to raise_error(FrozenError)
  end

  it "works with endless ranges" do
    a = [1, 2, 3]
    expect(a.slice!(eval("(1..)"))).to eq([2, 3])
    expect(a).to eq([1])

    a = [1, 2, 3]
    expect(a.slice!(eval("(2...)"))).to eq([3])
    expect(a).to eq([1, 2])

    a = [1, 2, 3]
    expect(a.slice!(eval("(-2..)"))).to eq([2, 3])
    expect(a).to eq([1])

    a = [1, 2, 3]
    expect(a.slice!(eval("(-1...)"))).to eq([3])
    expect(a).to eq([1, 2])
  end

  it "works with beginless ranges" do
    a = [0,1,2,3,4]
    expect(a.slice!((..3))).to eq([0, 1, 2, 3])
    expect(a).to eq([4])

    a = [0,1,2,3,4]
    expect(a.slice!((...-2))).to eq([0, 1, 2])
    expect(a).to eq([3, 4])
  end

  describe "with a subclass of Array" do
    before :each do
      @array = ArraySpecs::MyArray[1, 2, 3, 4, 5]
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance with [n, m]" do
        expect(@array.slice!(0, 2)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n, m]" do
        expect(@array.slice!(-3, 2)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [n..m]" do
        expect(@array.slice!(1..3)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [n...m]" do
        expect(@array.slice!(1...3)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n..-m]" do
        expect(@array.slice!(-3..-1)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n...-m]" do
        expect(@array.slice!(-3...-1)).to be_an_instance_of(ArraySpecs::MyArray)
      end
    end

    ruby_version_is '3.0' do
      it "returns a Array instance with [n, m]" do
        expect(@array.slice!(0, 2)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n, m]" do
        expect(@array.slice!(-3, 2)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [n..m]" do
        expect(@array.slice!(1..3)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [n...m]" do
        expect(@array.slice!(1...3)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n..-m]" do
        expect(@array.slice!(-3..-1)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n...-m]" do
        expect(@array.slice!(-3...-1)).to be_an_instance_of(Array)
      end
    end
  end
end

describe "Array#slice" do
  it_behaves_like :array_slice, :slice
end
