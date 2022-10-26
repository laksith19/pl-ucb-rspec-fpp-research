describe :array_slice, shared: true do
  it "returns the element at index with [index]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 1)).to eq("b")

    a = [1, 2, 3, 4]

    expect(a.send(@method, 0)).to eq(1)
    expect(a.send(@method, 1)).to eq(2)
    expect(a.send(@method, 2)).to eq(3)
    expect(a.send(@method, 3)).to eq(4)
    expect(a.send(@method, 4)).to eq(nil)
    expect(a.send(@method, 10)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns the element at index from the end of the array with [-index]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, -2)).to eq("d")

    a = [1, 2, 3, 4]

    expect(a.send(@method, -1)).to eq(4)
    expect(a.send(@method, -2)).to eq(3)
    expect(a.send(@method, -3)).to eq(2)
    expect(a.send(@method, -4)).to eq(1)
    expect(a.send(@method, -5)).to eq(nil)
    expect(a.send(@method, -10)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns count elements starting from index with [index, count]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 2, 3)).to eq(["c", "d", "e"])

    a = [1, 2, 3, 4]

    expect(a.send(@method, 0, 0)).to eq([])
    expect(a.send(@method, 0, 1)).to eq([1])
    expect(a.send(@method, 0, 2)).to eq([1, 2])
    expect(a.send(@method, 0, 4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, 0, 6)).to eq([1, 2, 3, 4])
    expect(a.send(@method, 0, -1)).to eq(nil)
    expect(a.send(@method, 0, -2)).to eq(nil)
    expect(a.send(@method, 0, -4)).to eq(nil)

    expect(a.send(@method, 2, 0)).to eq([])
    expect(a.send(@method, 2, 1)).to eq([3])
    expect(a.send(@method, 2, 2)).to eq([3, 4])
    expect(a.send(@method, 2, 4)).to eq([3, 4])
    expect(a.send(@method, 2, -1)).to eq(nil)

    expect(a.send(@method, 4, 0)).to eq([])
    expect(a.send(@method, 4, 2)).to eq([])
    expect(a.send(@method, 4, -1)).to eq(nil)

    expect(a.send(@method, 5, 0)).to eq(nil)
    expect(a.send(@method, 5, 2)).to eq(nil)
    expect(a.send(@method, 5, -1)).to eq(nil)

    expect(a.send(@method, 6, 0)).to eq(nil)
    expect(a.send(@method, 6, 2)).to eq(nil)
    expect(a.send(@method, 6, -1)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns count elements starting at index from the end of array with [-index, count]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, -2, 2)).to eq(["d", "e"])

    a = [1, 2, 3, 4]

    expect(a.send(@method, -1, 0)).to eq([])
    expect(a.send(@method, -1, 1)).to eq([4])
    expect(a.send(@method, -1, 2)).to eq([4])
    expect(a.send(@method, -1, -1)).to eq(nil)

    expect(a.send(@method, -2, 0)).to eq([])
    expect(a.send(@method, -2, 1)).to eq([3])
    expect(a.send(@method, -2, 2)).to eq([3, 4])
    expect(a.send(@method, -2, 4)).to eq([3, 4])
    expect(a.send(@method, -2, -1)).to eq(nil)

    expect(a.send(@method, -4, 0)).to eq([])
    expect(a.send(@method, -4, 1)).to eq([1])
    expect(a.send(@method, -4, 2)).to eq([1, 2])
    expect(a.send(@method, -4, 4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4, 6)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4, -1)).to eq(nil)

    expect(a.send(@method, -5, 0)).to eq(nil)
    expect(a.send(@method, -5, 1)).to eq(nil)
    expect(a.send(@method, -5, 10)).to eq(nil)
    expect(a.send(@method, -5, -1)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns the first count elements with [0, count]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 0, 3)).to eq(["a", "b", "c"])
  end

  it "returns the subarray which is independent to self with [index,count]" do
    a = [1, 2, 3]
    sub = a.send(@method, 1,2)
    sub.replace([:a, :b])
    expect(a).to eq([1, 2, 3])
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    allow(obj).to receive(:to_int).and_return(2)

    a = [1, 2, 3, 4]
    expect(a.send(@method, obj)).to eq(3)
    expect(a.send(@method, obj, 1)).to eq([3])
    expect(a.send(@method, obj, obj)).to eq([3, 4])
    expect(a.send(@method, 0, obj)).to eq([1, 2])
  end

  it "raises TypeError if to_int returns non-integer" do
    from = double('from')
    to = double('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    a = [1, 2, 3, 4, 5]

    def from.to_int() 'cat' end
    def to.to_int() -2 end

    expect { a.send(@method, from..to) }.to raise_error(TypeError)

    def from.to_int() 1 end
    def to.to_int() 'cat' end

    expect { a.send(@method, from..to) }.to raise_error(TypeError)
  end

  it "returns the elements specified by Range indexes with [m..n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 1..3)).to eq(["b", "c", "d"])
    expect([ "a", "b", "c", "d", "e" ].send(@method, 4..-1)).to eq(['e'])
    expect([ "a", "b", "c", "d", "e" ].send(@method, 3..3)).to eq(['d'])
    expect([ "a", "b", "c", "d", "e" ].send(@method, 3..-2)).to eq(['d'])
    expect(['a'].send(@method, 0..-1)).to eq(['a'])

    a = [1, 2, 3, 4]

    expect(a.send(@method, 0..-10)).to eq([])
    expect(a.send(@method, 0..0)).to eq([1])
    expect(a.send(@method, 0..1)).to eq([1, 2])
    expect(a.send(@method, 0..2)).to eq([1, 2, 3])
    expect(a.send(@method, 0..3)).to eq([1, 2, 3, 4])
    expect(a.send(@method, 0..4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, 0..10)).to eq([1, 2, 3, 4])

    expect(a.send(@method, 2..-10)).to eq([])
    expect(a.send(@method, 2..0)).to eq([])
    expect(a.send(@method, 2..2)).to eq([3])
    expect(a.send(@method, 2..3)).to eq([3, 4])
    expect(a.send(@method, 2..4)).to eq([3, 4])

    expect(a.send(@method, 3..0)).to eq([])
    expect(a.send(@method, 3..3)).to eq([4])
    expect(a.send(@method, 3..4)).to eq([4])

    expect(a.send(@method, 4..0)).to eq([])
    expect(a.send(@method, 4..4)).to eq([])
    expect(a.send(@method, 4..5)).to eq([])

    expect(a.send(@method, 5..0)).to eq(nil)
    expect(a.send(@method, 5..5)).to eq(nil)
    expect(a.send(@method, 5..6)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns elements specified by Range indexes except the element at index n with [m...n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 1...3)).to eq(["b", "c"])

    a = [1, 2, 3, 4]

    expect(a.send(@method, 0...-10)).to eq([])
    expect(a.send(@method, 0...0)).to eq([])
    expect(a.send(@method, 0...1)).to eq([1])
    expect(a.send(@method, 0...2)).to eq([1, 2])
    expect(a.send(@method, 0...3)).to eq([1, 2, 3])
    expect(a.send(@method, 0...4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, 0...10)).to eq([1, 2, 3, 4])

    expect(a.send(@method, 2...-10)).to eq([])
    expect(a.send(@method, 2...0)).to eq([])
    expect(a.send(@method, 2...2)).to eq([])
    expect(a.send(@method, 2...3)).to eq([3])
    expect(a.send(@method, 2...4)).to eq([3, 4])

    expect(a.send(@method, 3...0)).to eq([])
    expect(a.send(@method, 3...3)).to eq([])
    expect(a.send(@method, 3...4)).to eq([4])

    expect(a.send(@method, 4...0)).to eq([])
    expect(a.send(@method, 4...4)).to eq([])
    expect(a.send(@method, 4...5)).to eq([])

    expect(a.send(@method, 5...0)).to eq(nil)
    expect(a.send(@method, 5...5)).to eq(nil)
    expect(a.send(@method, 5...6)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns elements that exist if range start is in the array but range end is not with [m..n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 4..7)).to eq(["e"])
  end

  it "accepts Range instances having a negative m and both signs for n with [m..n] and [m...n]" do
    a = [1, 2, 3, 4]

    expect(a.send(@method, -1..-1)).to eq([4])
    expect(a.send(@method, -1...-1)).to eq([])
    expect(a.send(@method, -1..3)).to eq([4])
    expect(a.send(@method, -1...3)).to eq([])
    expect(a.send(@method, -1..4)).to eq([4])
    expect(a.send(@method, -1...4)).to eq([4])
    expect(a.send(@method, -1..10)).to eq([4])
    expect(a.send(@method, -1...10)).to eq([4])
    expect(a.send(@method, -1..0)).to eq([])
    expect(a.send(@method, -1..-4)).to eq([])
    expect(a.send(@method, -1...-4)).to eq([])
    expect(a.send(@method, -1..-6)).to eq([])
    expect(a.send(@method, -1...-6)).to eq([])

    expect(a.send(@method, -2..-2)).to eq([3])
    expect(a.send(@method, -2...-2)).to eq([])
    expect(a.send(@method, -2..-1)).to eq([3, 4])
    expect(a.send(@method, -2...-1)).to eq([3])
    expect(a.send(@method, -2..10)).to eq([3, 4])
    expect(a.send(@method, -2...10)).to eq([3, 4])

    expect(a.send(@method, -4..-4)).to eq([1])
    expect(a.send(@method, -4..-2)).to eq([1, 2, 3])
    expect(a.send(@method, -4...-2)).to eq([1, 2])
    expect(a.send(@method, -4..-1)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4...-1)).to eq([1, 2, 3])
    expect(a.send(@method, -4..3)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4...3)).to eq([1, 2, 3])
    expect(a.send(@method, -4..4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4...4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4...4)).to eq([1, 2, 3, 4])
    expect(a.send(@method, -4..0)).to eq([1])
    expect(a.send(@method, -4...0)).to eq([])
    expect(a.send(@method, -4..1)).to eq([1, 2])
    expect(a.send(@method, -4...1)).to eq([1])

    expect(a.send(@method, -5..-5)).to eq(nil)
    expect(a.send(@method, -5...-5)).to eq(nil)
    expect(a.send(@method, -5..-4)).to eq(nil)
    expect(a.send(@method, -5..-1)).to eq(nil)
    expect(a.send(@method, -5..10)).to eq(nil)

    expect(a).to eq([1, 2, 3, 4])
  end

  it "returns the subarray which is independent to self with [m..n]" do
    a = [1, 2, 3]
    sub = a.send(@method, 1..2)
    sub.replace([:a, :b])
    expect(a).to eq([1, 2, 3])
  end

  it "tries to convert Range elements to Integers using #to_int with [m..n] and [m...n]" do
    from = double('from')
    to = double('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    a = [1, 2, 3, 4]

    expect(a.send(@method, from..to)).to eq([2, 3])
    expect(a.send(@method, from...to)).to eq([2])
    expect(a.send(@method, 1..0)).to eq([])
    expect(a.send(@method, 1...0)).to eq([])

    expect { a.send(@method, "a" .. "b") }.to raise_error(TypeError)
    expect { a.send(@method, "a" ... "b") }.to raise_error(TypeError)
    expect { a.send(@method, from .. "b") }.to raise_error(TypeError)
    expect { a.send(@method, from ... "b") }.to raise_error(TypeError)
  end

  it "returns the same elements as [m..n] and [m...n] with Range subclasses" do
    a = [1, 2, 3, 4]
    range_incl = ArraySpecs::MyRange.new(1, 2)
    range_excl = ArraySpecs::MyRange.new(-3, -1, true)

    expect(a.send(@method, range_incl)).to eq([2, 3])
    expect(a.send(@method, range_excl)).to eq([2, 3])
  end

  it "returns nil for a requested index not in the array with [index]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 5)).to eq(nil)
  end

  it "returns [] if the index is valid but length is zero with [index, length]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 0, 0)).to eq([])
    expect([ "a", "b", "c", "d", "e" ].send(@method, 2, 0)).to eq([])
  end

  it "returns nil if length is zero but index is invalid with [index, length]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 100, 0)).to eq(nil)
    expect([ "a", "b", "c", "d", "e" ].send(@method, -50, 0)).to eq(nil)
  end

  # This is by design. It is in the official documentation.
  it "returns [] if index == array.size with [index, length]" do
    expect(%w|a b c d e|.send(@method, 5, 2)).to eq([])
  end

  it "returns nil if index > array.size with [index, length]" do
    expect(%w|a b c d e|.send(@method, 6, 2)).to eq(nil)
  end

  it "returns nil if length is negative with [index, length]" do
    expect(%w|a b c d e|.send(@method, 3, -1)).to eq(nil)
    expect(%w|a b c d e|.send(@method, 2, -2)).to eq(nil)
    expect(%w|a b c d e|.send(@method, 1, -100)).to eq(nil)
  end

  it "returns nil if no requested index is in the array with [m..n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, 6..10)).to eq(nil)
  end

  it "returns nil if range start is not in the array with [m..n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, -10..2)).to eq(nil)
    expect([ "a", "b", "c", "d", "e" ].send(@method, 10..12)).to eq(nil)
  end

  it "returns an empty array when m == n with [m...n]" do
    expect([1, 2, 3, 4, 5].send(@method, 1...1)).to eq([])
  end

  it "returns an empty array with [0...0]" do
    expect([1, 2, 3, 4, 5].send(@method, 0...0)).to eq([])
  end

  it "returns a subarray where m, n negatives and m < n with [m..n]" do
    expect([ "a", "b", "c", "d", "e" ].send(@method, -3..-2)).to eq(["c", "d"])
  end

  it "returns an array containing the first element with [0..0]" do
    expect([1, 2, 3, 4, 5].send(@method, 0..0)).to eq([1])
  end

  it "returns the entire array with [0..-1]" do
    expect([1, 2, 3, 4, 5].send(@method, 0..-1)).to eq([1, 2, 3, 4, 5])
  end

  it "returns all but the last element with [0...-1]" do
    expect([1, 2, 3, 4, 5].send(@method, 0...-1)).to eq([1, 2, 3, 4])
  end

  it "returns [3] for [2..-1] out of [1, 2, 3]" do
    expect([1,2,3].send(@method, 2..-1)).to eq([3])
  end

  it "returns an empty array when m > n and m, n are positive with [m..n]" do
    expect([1, 2, 3, 4, 5].send(@method, 3..2)).to eq([])
  end

  it "returns an empty array when m > n and m, n are negative with [m..n]" do
    expect([1, 2, 3, 4, 5].send(@method, -2..-3)).to eq([])
  end

  it "does not expand array when the indices are outside of the array bounds" do
    a = [1, 2]
    expect(a.send(@method, 4)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.send(@method, 4, 0)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.send(@method, 6, 1)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.send(@method, 8...8)).to eq(nil)
    expect(a).to eq([1, 2])
    expect(a.send(@method, 10..10)).to eq(nil)
    expect(a).to eq([1, 2])
  end

  describe "with a subclass of Array" do
    before :each do
      ScratchPad.clear

      @array = ArraySpecs::MyArray[1, 2, 3, 4, 5]
    end

    ruby_version_is ''...'3.0' do
      it "returns a subclass instance with [n, m]" do
        expect(@array.send(@method, 0, 2)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n, m]" do
        expect(@array.send(@method, -3, 2)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [n..m]" do
        expect(@array.send(@method, 1..3)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [n...m]" do
        expect(@array.send(@method, 1...3)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n..-m]" do
        expect(@array.send(@method, -3..-1)).to be_an_instance_of(ArraySpecs::MyArray)
      end

      it "returns a subclass instance with [-n...-m]" do
        expect(@array.send(@method, -3...-1)).to be_an_instance_of(ArraySpecs::MyArray)
      end
    end

    ruby_version_is '3.0' do
      it "returns a Array instance with [n, m]" do
        expect(@array.send(@method, 0, 2)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n, m]" do
        expect(@array.send(@method, -3, 2)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [n..m]" do
        expect(@array.send(@method, 1..3)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [n...m]" do
        expect(@array.send(@method, 1...3)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n..-m]" do
        expect(@array.send(@method, -3..-1)).to be_an_instance_of(Array)
      end

      it "returns a Array instance with [-n...-m]" do
        expect(@array.send(@method, -3...-1)).to be_an_instance_of(Array)
      end
    end

    it "returns an empty array when m == n with [m...n]" do
      expect(@array.send(@method, 1...1)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "returns an empty array with [0...0]" do
      expect(@array.send(@method, 0...0)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "returns an empty array when m > n and m, n are positive with [m..n]" do
      expect(@array.send(@method, 3..2)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "returns an empty array when m > n and m, n are negative with [m..n]" do
      expect(@array.send(@method, -2..-3)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "returns [] if index == array.size with [index, length]" do
      expect(@array.send(@method, 5, 2)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "returns [] if the index is valid but length is zero with [index, length]" do
      expect(@array.send(@method, 0, 0)).to eq([])
      expect(@array.send(@method, 2, 0)).to eq([])
      expect(ScratchPad.recorded).to be_nil
    end

    it "does not call #initialize on the subclass instance" do
      expect(@array.send(@method, 0, 3)).to eq([1, 2, 3])
      expect(ScratchPad.recorded).to be_nil
    end
  end

  it "raises a RangeError when the start index is out of range of Fixnum" do
    array = [1, 2, 3, 4, 5, 6]
    obj = double('large value')
    expect(obj).to receive(:to_int).and_return(bignum_value)
    expect { array.send(@method, obj) }.to raise_error(RangeError)

    obj = 8e19
    expect { array.send(@method, obj) }.to raise_error(RangeError)

    # boundary value when longs are 64 bits
    expect { array.send(@method, 2.0**63) }.to raise_error(RangeError)

    # just under the boundary value when longs are 64 bits
    expect(array.send(@method, max_long.to_f.prev_float)).to eq(nil)
  end

  it "raises a RangeError when the length is out of range of Fixnum" do
    array = [1, 2, 3, 4, 5, 6]
    obj = double('large value')
    expect(obj).to receive(:to_int).and_return(bignum_value)
    expect { array.send(@method, 1, obj) }.to raise_error(RangeError)

    obj = 8e19
    expect { array.send(@method, 1, obj) }.to raise_error(RangeError)
  end

  it "raises a type error if a range is passed with a length" do
    expect{ [1, 2, 3].send(@method, 1..2, 1) }.to raise_error(TypeError)
  end

  it "raises a RangeError if passed a range with a bound that is too large" do
    array = [1, 2, 3, 4, 5, 6]
    expect { array.send(@method, bignum_value..(bignum_value + 1)) }.to raise_error(RangeError)
    expect { array.send(@method, 0..bignum_value) }.to raise_error(RangeError)
  end

  it "can accept endless ranges" do
    a = [0, 1, 2, 3, 4, 5]
    expect(a.send(@method, eval("(2..)"))).to eq([2, 3, 4, 5])
    expect(a.send(@method, eval("(2...)"))).to eq([2, 3, 4, 5])
    expect(a.send(@method, eval("(-2..)"))).to eq([4, 5])
    expect(a.send(@method, eval("(-2...)"))).to eq([4, 5])
    expect(a.send(@method, eval("(9..)"))).to eq(nil)
    expect(a.send(@method, eval("(9...)"))).to eq(nil)
    expect(a.send(@method, eval("(-9..)"))).to eq(nil)
    expect(a.send(@method, eval("(-9...)"))).to eq(nil)
  end

  ruby_version_is "3.0" do
    describe "can be sliced with Enumerator::ArithmeticSequence" do
      before :each do
        @array = [0, 1, 2, 3, 4, 5]
      end

      it "has endless range and positive steps" do
        expect(@array.send(@method, eval("(0..).step(1)"))).to eq([0, 1, 2, 3, 4, 5])
        expect(@array.send(@method, eval("(0..).step(2)"))).to eq([0, 2, 4])
        expect(@array.send(@method, eval("(0..).step(10)"))).to eq([0])

        expect(@array.send(@method, eval("(2..).step(1)"))).to eq([2, 3, 4, 5])
        expect(@array.send(@method, eval("(2..).step(2)"))).to eq([2, 4])
        expect(@array.send(@method, eval("(2..).step(10)"))).to eq([2])

        expect(@array.send(@method, eval("(-3..).step(1)"))).to eq([3, 4, 5])
        expect(@array.send(@method, eval("(-3..).step(2)"))).to eq([3, 5])
        expect(@array.send(@method, eval("(-3..).step(10)"))).to eq([3])
      end

      it "has beginless range and positive steps" do
        # end with zero index
        expect(@array.send(@method, (..0).step(1))).to eq([0])
        expect(@array.send(@method, (...0).step(1))).to eq([])

        expect(@array.send(@method, (..0).step(2))).to eq([0])
        expect(@array.send(@method, (...0).step(2))).to eq([])

        expect(@array.send(@method, (..0).step(10))).to eq([0])
        expect(@array.send(@method, (...0).step(10))).to eq([])

        # end with positive index
        expect(@array.send(@method, (..3).step(1))).to eq([0, 1, 2, 3])
        expect(@array.send(@method, (...3).step(1))).to eq([0, 1, 2])

        expect(@array.send(@method, (..3).step(2))).to eq([0, 2])
        expect(@array.send(@method, (...3).step(2))).to eq([0, 2])

        expect(@array.send(@method, (..3).step(10))).to eq([0])
        expect(@array.send(@method, (...3).step(10))).to eq([0])

        # end with negative index
        expect(@array.send(@method, (..-2).step(1))).to eq([0, 1, 2, 3, 4,])
        expect(@array.send(@method, (...-2).step(1))).to eq([0, 1, 2, 3])

        expect(@array.send(@method, (..-2).step(2))).to eq([0, 2, 4])
        expect(@array.send(@method, (...-2).step(2))).to eq([0, 2])

        expect(@array.send(@method, (..-2).step(10))).to eq([0])
        expect(@array.send(@method, (...-2).step(10))).to eq([0])
      end

      it "has endless range and negative steps" do
        expect(@array.send(@method, eval("(0..).step(-1)"))).to eq([0])
        expect(@array.send(@method, eval("(0..).step(-2)"))).to eq([0])
        expect(@array.send(@method, eval("(0..).step(-10)"))).to eq([0])

        expect(@array.send(@method, eval("(2..).step(-1)"))).to eq([2, 1, 0])
        expect(@array.send(@method, eval("(2..).step(-2)"))).to eq([2, 0])

        expect(@array.send(@method, eval("(-3..).step(-1)"))).to eq([3, 2, 1, 0])
        expect(@array.send(@method, eval("(-3..).step(-2)"))).to eq([3, 1])
      end

      it "has closed range and positive steps" do
        # start and end with 0
        expect(@array.send(@method, eval("(0..0).step(1)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(1)"))).to eq([])

        expect(@array.send(@method, eval("(0..0).step(2)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(2)"))).to eq([])

        expect(@array.send(@method, eval("(0..0).step(10)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(10)"))).to eq([])

        # start and end with positive index
        expect(@array.send(@method, eval("(1..3).step(1)"))).to eq([1, 2, 3])
        expect(@array.send(@method, eval("(1...3).step(1)"))).to eq([1, 2])

        expect(@array.send(@method, eval("(1..3).step(2)"))).to eq([1, 3])
        expect(@array.send(@method, eval("(1...3).step(2)"))).to eq([1])

        expect(@array.send(@method, eval("(1..3).step(10)"))).to eq([1])
        expect(@array.send(@method, eval("(1...3).step(10)"))).to eq([1])

        # start with positive index, end with negative index
        expect(@array.send(@method, eval("(1..-2).step(1)"))).to eq([1, 2, 3, 4])
        expect(@array.send(@method, eval("(1...-2).step(1)"))).to eq([1, 2, 3])

        expect(@array.send(@method, eval("(1..-2).step(2)"))).to eq([1, 3])
        expect(@array.send(@method, eval("(1...-2).step(2)"))).to eq([1, 3])

        expect(@array.send(@method, eval("(1..-2).step(10)"))).to eq([1])
        expect(@array.send(@method, eval("(1...-2).step(10)"))).to eq([1])

        # start with negative index, end with positive index
        expect(@array.send(@method, eval("(-4..4).step(1)"))).to eq([2, 3, 4])
        expect(@array.send(@method, eval("(-4...4).step(1)"))).to eq([2, 3])

        expect(@array.send(@method, eval("(-4..4).step(2)"))).to eq([2, 4])
        expect(@array.send(@method, eval("(-4...4).step(2)"))).to eq([2])

        expect(@array.send(@method, eval("(-4..4).step(10)"))).to eq([2])
        expect(@array.send(@method, eval("(-4...4).step(10)"))).to eq([2])

        # start with negative index, end with negative index
        expect(@array.send(@method, eval("(-4..-2).step(1)"))).to eq([2, 3, 4])
        expect(@array.send(@method, eval("(-4...-2).step(1)"))).to eq([2, 3])

        expect(@array.send(@method, eval("(-4..-2).step(2)"))).to eq([2, 4])
        expect(@array.send(@method, eval("(-4...-2).step(2)"))).to eq([2])

        expect(@array.send(@method, eval("(-4..-2).step(10)"))).to eq([2])
        expect(@array.send(@method, eval("(-4...-2).step(10)"))).to eq([2])
      end

      it "has closed range and negative steps" do
        # start and end with 0
        expect(@array.send(@method, eval("(0..0).step(-1)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(-1)"))).to eq([])

        expect(@array.send(@method, eval("(0..0).step(-2)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(-2)"))).to eq([])

        expect(@array.send(@method, eval("(0..0).step(-10)"))).to eq([0])
        expect(@array.send(@method, eval("(0...0).step(-10)"))).to eq([])

        # start and end with positive index
        expect(@array.send(@method, eval("(1..3).step(-1)"))).to eq([])
        expect(@array.send(@method, eval("(1...3).step(-1)"))).to eq([])

        expect(@array.send(@method, eval("(1..3).step(-2)"))).to eq([])
        expect(@array.send(@method, eval("(1...3).step(-2)"))).to eq([])

        expect(@array.send(@method, eval("(1..3).step(-10)"))).to eq([])
        expect(@array.send(@method, eval("(1...3).step(-10)"))).to eq([])

        # start with positive index, end with negative index
        expect(@array.send(@method, eval("(1..-2).step(-1)"))).to eq([])
        expect(@array.send(@method, eval("(1...-2).step(-1)"))).to eq([])

        expect(@array.send(@method, eval("(1..-2).step(-2)"))).to eq([])
        expect(@array.send(@method, eval("(1...-2).step(-2)"))).to eq([])

        expect(@array.send(@method, eval("(1..-2).step(-10)"))).to eq([])
        expect(@array.send(@method, eval("(1...-2).step(-10)"))).to eq([])

        # start with negative index, end with positive index
        expect(@array.send(@method, eval("(-4..4).step(-1)"))).to eq([])
        expect(@array.send(@method, eval("(-4...4).step(-1)"))).to eq([])

        expect(@array.send(@method, eval("(-4..4).step(-2)"))).to eq([])
        expect(@array.send(@method, eval("(-4...4).step(-2)"))).to eq([])

        expect(@array.send(@method, eval("(-4..4).step(-10)"))).to eq([])
        expect(@array.send(@method, eval("(-4...4).step(-10)"))).to eq([])

        # start with negative index, end with negative index
        expect(@array.send(@method, eval("(-4..-2).step(-1)"))).to eq([])
        expect(@array.send(@method, eval("(-4...-2).step(-1)"))).to eq([])

        expect(@array.send(@method, eval("(-4..-2).step(-2)"))).to eq([])
        expect(@array.send(@method, eval("(-4...-2).step(-2)"))).to eq([])

        expect(@array.send(@method, eval("(-4..-2).step(-10)"))).to eq([])
        expect(@array.send(@method, eval("(-4...-2).step(-10)"))).to eq([])
      end

      it "has inverted closed range and positive steps" do
        # start and end with positive index
        expect(@array.send(@method, eval("(3..1).step(1)"))).to eq([])
        expect(@array.send(@method, eval("(3...1).step(1)"))).to eq([])

        expect(@array.send(@method, eval("(3..1).step(2)"))).to eq([])
        expect(@array.send(@method, eval("(3...1).step(2)"))).to eq([])

        expect(@array.send(@method, eval("(3..1).step(10)"))).to eq([])
        expect(@array.send(@method, eval("(3...1).step(10)"))).to eq([])

        # start with negative index, end with positive index
        expect(@array.send(@method, eval("(-2..1).step(1)"))).to eq([])
        expect(@array.send(@method, eval("(-2...1).step(1)"))).to eq([])

        expect(@array.send(@method, eval("(-2..1).step(2)"))).to eq([])
        expect(@array.send(@method, eval("(-2...1).step(2)"))).to eq([])

        expect(@array.send(@method, eval("(-2..1).step(10)"))).to eq([])
        expect(@array.send(@method, eval("(-2...1).step(10)"))).to eq([])

        # start with positive index, end with negative index
        expect(@array.send(@method, eval("(4..-4).step(1)"))).to eq([])
        expect(@array.send(@method, eval("(4...-4).step(1)"))).to eq([])

        expect(@array.send(@method, eval("(4..-4).step(2)"))).to eq([])
        expect(@array.send(@method, eval("(4...-4).step(2)"))).to eq([])

        expect(@array.send(@method, eval("(4..-4).step(10)"))).to eq([])
        expect(@array.send(@method, eval("(4...-4).step(10)"))).to eq([])

        # start with negative index, end with negative index
        expect(@array.send(@method, eval("(-2..-4).step(1)"))).to eq([])
        expect(@array.send(@method, eval("(-2...-4).step(1)"))).to eq([])

        expect(@array.send(@method, eval("(-2..-4).step(2)"))).to eq([])
        expect(@array.send(@method, eval("(-2...-4).step(2)"))).to eq([])

        expect(@array.send(@method, eval("(-2..-4).step(10)"))).to eq([])
        expect(@array.send(@method, eval("(-2...-4).step(10)"))).to eq([])
      end

      it "has range with bounds outside of array" do
        # end is equal to array's length
        expect(@array.send(@method, (0..6).step(1))).to eq([0, 1, 2, 3, 4, 5])
        expect { @array.send(@method, (0..6).step(2)) }.to raise_error(RangeError)

        # end is greater than length with positive steps
        expect(@array.send(@method, (1..6).step(2))).to eq([1, 3, 5])
        expect(@array.send(@method, (2..7).step(2))).to eq([2, 4])
        expect { @array.send(@method, (2..8).step(2)) }.to raise_error(RangeError)

        # begin is greater than length with negative steps
        expect(@array.send(@method, (6..1).step(-2))).to eq([5, 3, 1])
        expect(@array.send(@method, (7..2).step(-2))).to eq([5, 3])
        expect { @array.send(@method, (8..2).step(-2)) }.to raise_error(RangeError)
      end

      it "has endless range with start outside of array's bounds" do
        expect(@array.send(@method, eval("(6..).step(1)"))).to eq([])
        expect(@array.send(@method, eval("(7..).step(1)"))).to eq(nil)

        expect(@array.send(@method, eval("(6..).step(2)"))).to eq([])
        expect { @array.send(@method, eval("(7..).step(2)")) }.to raise_error(RangeError)
      end
    end
  end

  it "can accept beginless ranges" do
    a = [0, 1, 2, 3, 4, 5]
    expect(a.send(@method, (..3))).to eq([0, 1, 2, 3])
    expect(a.send(@method, (...3))).to eq([0, 1, 2])
    expect(a.send(@method, (..-3))).to eq([0, 1, 2, 3])
    expect(a.send(@method, (...-3))).to eq([0, 1, 2])
    expect(a.send(@method, (..0))).to eq([0])
    expect(a.send(@method, (...0))).to eq([])
    expect(a.send(@method, (..9))).to eq([0, 1, 2, 3, 4, 5])
    expect(a.send(@method, (...9))).to eq([0, 1, 2, 3, 4, 5])
    expect(a.send(@method, (..-9))).to eq([])
    expect(a.send(@method, (...-9))).to eq([])
  end

  ruby_version_is "3.2" do
    describe "can be sliced with Enumerator::ArithmeticSequence" do
      it "with infinite/inverted ranges and negative steps" do
        @array = [0, 1, 2, 3, 4, 5]
        expect(@array.send(@method, (2..).step(-1))).to eq([2, 1, 0])
        expect(@array.send(@method, (2..).step(-2))).to eq([2, 0])
        expect(@array.send(@method, (2..).step(-3))).to eq([2])
        expect(@array.send(@method, (2..).step(-4))).to eq([2])

        expect(@array.send(@method, (-3..).step(-1))).to eq([3, 2, 1, 0])
        expect(@array.send(@method, (-3..).step(-2))).to eq([3, 1])
        expect(@array.send(@method, (-3..).step(-3))).to eq([3, 0])
        expect(@array.send(@method, (-3..).step(-4))).to eq([3])
        expect(@array.send(@method, (-3..).step(-5))).to eq([3])

        expect(@array.send(@method, (..0).step(-1))).to eq([5, 4, 3, 2, 1, 0])
        expect(@array.send(@method, (..0).step(-2))).to eq([5, 3, 1])
        expect(@array.send(@method, (..0).step(-3))).to eq([5, 2])
        expect(@array.send(@method, (..0).step(-4))).to eq([5, 1])
        expect(@array.send(@method, (..0).step(-5))).to eq([5, 0])
        expect(@array.send(@method, (..0).step(-6))).to eq([5])
        expect(@array.send(@method, (..0).step(-7))).to eq([5])

        expect(@array.send(@method, (...0).step(-1))).to eq([5, 4, 3, 2, 1])
        expect(@array.send(@method, (...0).step(-2))).to eq([5, 3, 1])
        expect(@array.send(@method, (...0).step(-3))).to eq([5, 2])
        expect(@array.send(@method, (...0).step(-4))).to eq([5, 1])
        expect(@array.send(@method, (...0).step(-5))).to eq([5])
        expect(@array.send(@method, (...0).step(-6))).to eq([5])

        expect(@array.send(@method, (...1).step(-1))).to eq([5, 4, 3, 2])
        expect(@array.send(@method, (...1).step(-2))).to eq([5, 3])
        expect(@array.send(@method, (...1).step(-3))).to eq([5, 2])
        expect(@array.send(@method, (...1).step(-4))).to eq([5])
        expect(@array.send(@method, (...1).step(-5))).to eq([5])

        expect(@array.send(@method, (..-5).step(-1))).to eq([5, 4, 3, 2, 1])
        expect(@array.send(@method, (..-5).step(-2))).to eq([5, 3, 1])
        expect(@array.send(@method, (..-5).step(-3))).to eq([5, 2])
        expect(@array.send(@method, (..-5).step(-4))).to eq([5, 1])
        expect(@array.send(@method, (..-5).step(-5))).to eq([5])
        expect(@array.send(@method, (..-5).step(-6))).to eq([5])

        expect(@array.send(@method, (...-5).step(-1))).to eq([5, 4, 3, 2])
        expect(@array.send(@method, (...-5).step(-2))).to eq([5, 3])
        expect(@array.send(@method, (...-5).step(-3))).to eq([5, 2])
        expect(@array.send(@method, (...-5).step(-4))).to eq([5])
        expect(@array.send(@method, (...-5).step(-5))).to eq([5])

        expect(@array.send(@method, (4..1).step(-1))).to eq([4, 3, 2, 1])
        expect(@array.send(@method, (4..1).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (4..1).step(-3))).to eq([4, 1])
        expect(@array.send(@method, (4..1).step(-4))).to eq([4])
        expect(@array.send(@method, (4..1).step(-5))).to eq([4])

        expect(@array.send(@method, (4...1).step(-1))).to eq([4, 3, 2])
        expect(@array.send(@method, (4...1).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (4...1).step(-3))).to eq([4])
        expect(@array.send(@method, (4...1).step(-4))).to eq([4])

        expect(@array.send(@method, (-2..1).step(-1))).to eq([4, 3, 2, 1])
        expect(@array.send(@method, (-2..1).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (-2..1).step(-3))).to eq([4, 1])
        expect(@array.send(@method, (-2..1).step(-4))).to eq([4])
        expect(@array.send(@method, (-2..1).step(-5))).to eq([4])

        expect(@array.send(@method, (-2...1).step(-1))).to eq([4, 3, 2])
        expect(@array.send(@method, (-2...1).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (-2...1).step(-3))).to eq([4])
        expect(@array.send(@method, (-2...1).step(-4))).to eq([4])

        expect(@array.send(@method, (4..-5).step(-1))).to eq([4, 3, 2, 1])
        expect(@array.send(@method, (4..-5).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (4..-5).step(-3))).to eq([4, 1])
        expect(@array.send(@method, (4..-5).step(-4))).to eq([4])
        expect(@array.send(@method, (4..-5).step(-5))).to eq([4])

        expect(@array.send(@method, (4...-5).step(-1))).to eq([4, 3, 2])
        expect(@array.send(@method, (4...-5).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (4...-5).step(-3))).to eq([4])
        expect(@array.send(@method, (4...-5).step(-4))).to eq([4])

        expect(@array.send(@method, (-2..-5).step(-1))).to eq([4, 3, 2, 1])
        expect(@array.send(@method, (-2..-5).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (-2..-5).step(-3))).to eq([4, 1])
        expect(@array.send(@method, (-2..-5).step(-4))).to eq([4])
        expect(@array.send(@method, (-2..-5).step(-5))).to eq([4])

        expect(@array.send(@method, (-2...-5).step(-1))).to eq([4, 3, 2])
        expect(@array.send(@method, (-2...-5).step(-2))).to eq([4, 2])
        expect(@array.send(@method, (-2...-5).step(-3))).to eq([4])
        expect(@array.send(@method, (-2...-5).step(-4))).to eq([4])
      end
    end
  end

  it "can accept nil...nil ranges" do
    a = [0, 1, 2, 3, 4, 5]
    expect(a.send(@method, eval("(nil...nil)"))).to eq(a)
    expect(a.send(@method, (...nil))).to eq(a)
    expect(a.send(@method, eval("(nil..)"))).to eq(a)
  end
end
