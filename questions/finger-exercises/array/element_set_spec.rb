require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#[]=" do
  it "sets the value of the element at index" do
    a = [1, 2, 3, 4]
    a[2] = 5
    a[-1] = 6
    a[5] = 3
    expect(a).to eq([1, 2, 5, 6, nil, 3])

    a = []
    a[4] = "e"
    expect(a).to eq([nil, nil, nil, nil, "e"])
    a[3] = "d"
    expect(a).to eq([nil, nil, nil, "d", "e"])
    a[0] = "a"
    expect(a).to eq(["a", nil, nil, "d", "e"])
    a[-3] = "C"
    expect(a).to eq(["a", nil, "C", "d", "e"])
    a[-1] = "E"
    expect(a).to eq(["a", nil, "C", "d", "E"])
    a[-5] = "A"
    expect(a).to eq(["A", nil, "C", "d", "E"])
    a[5] = "f"
    expect(a).to eq(["A", nil, "C", "d", "E", "f"])
    a[1] = []
    expect(a).to eq(["A", [], "C", "d", "E", "f"])
    a[-1] = nil
    expect(a).to eq(["A", [], "C", "d", "E", nil])
  end

  it "sets the section defined by [start,length] to other" do
    a = [1, 2, 3, 4, 5, 6]
    a[0, 1] = 2
    a[3, 2] = ['a', 'b', 'c', 'd']
    expect(a).to eq([2, 2, 3, "a", "b", "c", "d", 6])
  end

  it "replaces the section defined by [start,length] with the given values" do
    a = [1, 2, 3, 4, 5, 6]
    a[3, 2] = 'a', 'b', 'c', 'd'
    expect(a).to eq([1, 2, 3, "a", "b", "c", "d", 6])
  end

  it "just sets the section defined by [start,length] to other even if other is nil" do
    a = ['a', 'b', 'c', 'd', 'e']
    a[1, 3] = nil
    expect(a).to eq(["a", nil, "e"])
  end

  it "returns nil if the rhs is nil" do
    a = [1, 2, 3]
    expect(a[1, 3] = nil).to eq(nil)
    expect(a[1..3] = nil).to eq(nil)
  end

  it "sets the section defined by range to other" do
    a = [6, 5, 4, 3, 2, 1]
    a[1...2] = 9
    a[3..6] = [6, 6, 6]
    expect(a).to eq([6, 9, 4, 6, 6, 6])
  end

  it "replaces the section defined by range with the given values" do
    a = [6, 5, 4, 3, 2, 1]
    a[3..6] = :a, :b, :c
    expect(a).to eq([6, 5, 4, :a, :b, :c])
  end

  it "just sets the section defined by range to other even if other is nil" do
    a = [1, 2, 3, 4, 5]
    a[0..1] = nil
    expect(a).to eq([nil, 3, 4, 5])
  end

  it 'expands and nil-pads the array if section assigned by range is outside array boundaries' do
    a = ['a']
    a[3..4] = ['b', 'c']
    expect(a).to eq(['a', nil, nil, 'b', 'c'])
  end

  it "calls to_int on its start and length arguments" do
    obj = double('to_int')
    allow(obj).to receive(:to_int).and_return(2)

    a = [1, 2, 3, 4]
    a[obj, 0] = [9]
    expect(a).to eq([1, 2, 9, 3, 4])
    a[obj, obj] = []
    expect(a).to eq([1, 2, 4])
    a[obj] = -1
    expect(a).to eq([1, 2, -1])
  end

  it "checks frozen before attempting to coerce arguments" do
    a = [1,2,3,4].freeze
    expect {a[:foo] = 1}.to raise_error(FrozenError)
    expect {a[:foo, :bar] = 1}.to raise_error(FrozenError)
  end

  it "sets elements in the range arguments when passed ranges" do
    ary = [1, 2, 3]
    rhs = [nil, [], ["x"], ["x", "y"]]
    (0 .. ary.size + 2).each do |a|
      (a .. ary.size + 3).each do |b|
        rhs.each do |c|
          ary1 = ary.dup
          ary1[a .. b] = c
          ary2 = ary.dup
          ary2[a, 1 + b-a] = c
          expect(ary1).to eq(ary2)

          ary1 = ary.dup
          ary1[a ... b] = c
          ary2 = ary.dup
          ary2[a, b-a] = c
          expect(ary1).to eq(ary2)
        end
      end
    end
  end

  it "inserts the given elements with [range] which the range is zero-width" do
    ary = [1, 2, 3]
    ary[1...1] = 0
    expect(ary).to eq([1, 0, 2, 3])
    ary[1...1] = [5]
    expect(ary).to eq([1, 5, 0, 2, 3])
    ary[1...1] = :a, :b, :c
    expect(ary).to eq([1, :a, :b, :c, 5, 0, 2, 3])
  end

  it "inserts the given elements with [start, length] which length is zero" do
    ary = [1, 2, 3]
    ary[1, 0] = 0
    expect(ary).to eq([1, 0, 2, 3])
    ary[1, 0] = [5]
    expect(ary).to eq([1, 5, 0, 2, 3])
    ary[1, 0] = :a, :b, :c
    expect(ary).to eq([1, :a, :b, :c, 5, 0, 2, 3])
  end

  # Now we only have to test cases where the start, length interface would
  # have raise an exception because of negative size
  it "inserts the given elements with [range] which the range has negative width" do
    ary = [1, 2, 3]
    ary[1..0] = 0
    expect(ary).to eq([1, 0, 2, 3])
    ary[1..0] = [4, 3]
    expect(ary).to eq([1, 4, 3, 0, 2, 3])
    ary[1..0] = :a, :b, :c
    expect(ary).to eq([1, :a, :b, :c, 4, 3, 0, 2, 3])
  end

  it "just inserts nil if the section defined by range is zero-width and the rhs is nil" do
    ary = [1, 2, 3]
    ary[1...1] = nil
    expect(ary).to eq([1, nil, 2, 3])
  end

  it "just inserts nil if the section defined by range has negative width and the rhs is nil" do
    ary = [1, 2, 3]
    ary[1..0] = nil
    expect(ary).to eq([1, nil, 2, 3])
  end

  it "does nothing if the section defined by range is zero-width and the rhs is an empty array" do
    ary = [1, 2, 3]
    ary[1...1] = []
    expect(ary).to eq([1, 2, 3])
  end

  it "does nothing if the section defined by range has negative width and the rhs is an empty array" do
    ary = [1, 2, 3, 4, 5]
    ary[1...0] = []
    expect(ary).to eq([1, 2, 3, 4, 5])
    ary[-2..2] = []
    expect(ary).to eq([1, 2, 3, 4, 5])
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

    a[from .. to] = ["a", "b", "c"]
    expect(a).to eq([1, "a", "b", "c", 4])

    a[to .. from] = ["x"]
    expect(a).to eq([1, "a", "b", "x", "c", 4])
    expect { a["a" .. "b"] = []  }.to raise_error(TypeError)
    expect { a[from .. "b"] = [] }.to raise_error(TypeError)
  end

  it "raises an IndexError when passed indexes out of bounds" do
    a = [1, 2, 3, 4]
    expect { a[-5] = ""      }.to raise_error(IndexError)
    expect { a[-5, -1] = ""  }.to raise_error(IndexError)
    expect { a[-5, 0] = ""   }.to raise_error(IndexError)
    expect { a[-5, 1] = ""   }.to raise_error(IndexError)
    expect { a[-5, 2] = ""   }.to raise_error(IndexError)
    expect { a[-5, 10] = ""  }.to raise_error(IndexError)

    expect { a[-5..-5] = ""  }.to raise_error(RangeError)
    expect { a[-5...-5] = "" }.to raise_error(RangeError)
    expect { a[-5..-4] = ""  }.to raise_error(RangeError)
    expect { a[-5...-4] = "" }.to raise_error(RangeError)
    expect { a[-5..10] = ""  }.to raise_error(RangeError)
    expect { a[-5...10] = "" }.to raise_error(RangeError)

    # ok
    a[0..-9] = [1]
    expect(a).to eq([1, 1, 2, 3, 4])
  end

  it "calls to_ary on its rhs argument for multi-element sets" do
    obj = double('to_ary')
    def obj.to_ary() [1, 2, 3] end
    ary = [1, 2]
    ary[0, 0] = obj
    expect(ary).to eq([1, 2, 3, 1, 2])
    ary[1, 10] = obj
    expect(ary).to eq([1, 1, 2, 3])
  end

  it "does not call to_ary on rhs array subclasses for multi-element sets" do
    ary = []
    ary[0, 0] = ArraySpecs::ToAryArray[5, 6, 7]
    expect(ary).to eq([5, 6, 7])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array[0, 0] = [] }.to raise_error(FrozenError)
  end
end

describe "Array#[]= with [index]" do
  it "returns value assigned if idx is inside array" do
    a = [1, 2, 3, 4, 5]
    expect(a[3] = 6).to eq(6)
  end

  it "returns value assigned if idx is right beyond right array boundary" do
    a = [1, 2, 3, 4, 5]
    expect(a[5] = 6).to eq(6)
  end

  it "returns value assigned if idx far beyond right array boundary" do
    a = [1, 2, 3, 4, 5]
    expect(a[10] = 6).to eq(6)
  end

  it "sets the value of the element at index" do
    a = [1, 2, 3, 4]
    a[2] = 5
    a[-1] = 6
    a[5] = 3
    expect(a).to eq([1, 2, 5, 6, nil, 3])
  end

  it "sets the value of the element if it is right beyond the array boundary" do
    a = [1, 2, 3, 4]
    a[4] = 8
    expect(a).to eq([1, 2, 3, 4, 8])
  end

end

describe "Array#[]= with [index, count]" do
  it "returns non-array value if non-array value assigned" do
    a = [1, 2, 3, 4, 5]
    expect(a[2, 3] = 10).to eq(10)
  end

  it "returns array if array assigned" do
    a = [1, 2, 3, 4, 5]
    expect(a[2, 3] = [4, 5]).to eq([4, 5])
  end

  it "accepts a frozen String literal as RHS" do
    a = ['a', 'b', 'c']
    a[0, 2] = 'd'.freeze
    expect(a).to eq(['d', 'c'])
  end

  it "just sets the section defined by [start,length] to nil even if the rhs is nil" do
    a = ['a', 'b', 'c', 'd', 'e']
    a[1, 3] = nil
    expect(a).to eq(["a", nil, "e"])
  end

  it "just sets the section defined by [start,length] to nil if negative index within bounds, cnt > 0 and the rhs is nil" do
    a = ['a', 'b', 'c', 'd', 'e']
    a[-3, 2] = nil
    expect(a).to eq(["a", "b", nil, "e"])
  end

  it "replaces the section defined by [start,length] to other" do
    a = [1, 2, 3, 4, 5, 6]
    a[0, 1] = 2
    a[3, 2] = ['a', 'b', 'c', 'd']
    expect(a).to eq([2, 2, 3, "a", "b", "c", "d", 6])
  end

  it "replaces the section to other if idx < 0 and cnt > 0" do
    a = [1, 2, 3, 4, 5, 6]
    a[-3, 2] = ["x", "y", "z"]
    expect(a).to eq([1, 2, 3, "x", "y", "z", 6])
  end

  it "replaces the section to other even if cnt spanning beyond the array boundary" do
    a = [1, 2, 3, 4, 5]
    a[-1, 3] = [7, 8]
    expect(a).to eq([1, 2, 3, 4, 7, 8])
  end

  it "pads the Array with nils if the span is past the end" do
    a = [1, 2, 3, 4, 5]
    a[10, 1] = [1]
    expect(a).to eq([1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1])

    b = [1, 2, 3, 4, 5]
    b[10, 0] = [1]
    expect(a).to eq([1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1])

    c = [1, 2, 3, 4, 5]
    c[10, 0] = []
    expect(c).to eq([1, 2, 3, 4, 5, nil, nil, nil, nil, nil])
  end

  it "inserts other section in place defined by idx" do
    a = [1, 2, 3, 4, 5]
    a[3, 0] = [7, 8]
    expect(a).to eq([1, 2, 3, 7, 8, 4, 5])

    b = [1, 2, 3, 4, 5]
    b[1, 0] = b
    expect(b).to eq([1, 1, 2, 3, 4, 5, 2, 3, 4, 5])
  end

  it "raises an IndexError when passed start and negative length" do
    a = [1, 2, 3, 4]
    expect { a[-2, -1] = "" }.to raise_error(IndexError)
    expect { a[0, -1] = ""  }.to raise_error(IndexError)
    expect { a[2, -1] = ""  }.to raise_error(IndexError)
    expect { a[4, -1] = ""  }.to raise_error(IndexError)
    expect { a[10, -1] = "" }.to raise_error(IndexError)
    expect { [1, 2, 3, 4,  5][2, -1] = [7, 8] }.to raise_error(IndexError)
  end
end

describe "Array#[]= with [m..n]" do
  it "returns non-array value if non-array value assigned" do
    a = [1, 2, 3, 4, 5]
    expect(a[2..4] = 10).to eq(10)
    expect(a.[]=(2..4, 10)).to eq(10)
  end

  it "returns array if array assigned" do
    a = [1, 2, 3, 4, 5]
    expect(a[2..4] = [7, 8]).to eq([7, 8])
    expect(a.[]=(2..4, [7, 8])).to eq([7, 8])
  end

  it "just sets the section defined by range to nil even if the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[0..1] = nil
    expect(a).to eq([nil, 3, 4, 5])
  end

  it "just sets the section defined by range to nil if m and n < 0 and the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[-3..-2] = nil
    expect(a).to eq([1, 2, nil, 5])
  end

  it "replaces the section defined by range" do
    a = [6, 5, 4, 3, 2, 1]
    a[1...2] = 9
    a[3..6] = [6, 6, 6]
    expect(a).to eq([6, 9, 4, 6, 6, 6])
  end

  it "replaces the section if m and n < 0" do
    a = [1, 2, 3, 4, 5]
    a[-3..-2] = [7, 8, 9]
    expect(a).to eq([1, 2, 7, 8, 9, 5])
  end

  it "replaces the section if m < 0 and n > 0" do
    a = [1, 2, 3, 4, 5]
    a[-4..3] = [8]
    expect(a).to eq([1, 8, 5])
  end

  it "inserts the other section at m if m > n" do
    a = [1, 2, 3, 4, 5]
    a[3..1] = [8]
    expect(a).to eq([1, 2, 3, 8, 4, 5])
  end

  it "inserts at the end if m > the array size" do
    a = [1, 2, 3]
    a[3..3] = [4]
    expect(a).to eq([1, 2, 3, 4])
    a[5..7] = [6]
    expect(a).to eq([1, 2, 3, 4, nil, 6])
  end

  describe "Range subclasses" do
    before :each do
      @range_incl = ArraySpecs::MyRange.new(1, 2)
      @range_excl = ArraySpecs::MyRange.new(-3, -1, true)
    end

    it "accepts Range subclasses" do
      a = [1, 2, 3, 4]

      a[@range_incl] = ["a", "b"]
      expect(a).to eq([1, "a", "b", 4])
      a[@range_excl] = ["A", "B"]
      expect(a).to eq([1, "A", "B", 4])
    end

    it "returns non-array value if non-array value assigned" do
      a = [1, 2, 3, 4, 5]
      expect(a[@range_incl] = 10).to eq(10)
      expect(a.[]=(@range_incl, 10)).to eq(10)
    end

    it "returns array if array assigned" do
      a = [1, 2, 3, 4, 5]
      expect(a[@range_incl] = [7, 8]).to eq([7, 8])
      expect(a.[]=(@range_incl, [7, 8])).to eq([7, 8])
    end
  end
end

describe "Array#[]= with [m..]" do
  it "just sets the section defined by range to nil even if the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[eval("(2..)")] = nil
    expect(a).to eq([1, 2, nil])
  end

  it "just sets the section defined by range to nil if m and n < 0 and the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[eval("(-3..)")] = nil
    expect(a).to eq([1, 2, nil])
  end

  it "replaces the section defined by range" do
    a = [6, 5, 4, 3, 2, 1]
    a[eval("(3...)")] = 9
    expect(a).to eq([6, 5, 4, 9])
    a[eval("(2..)")] = [7, 7, 7]
    expect(a).to eq([6, 5, 7, 7, 7])
  end

  it "replaces the section if m and n < 0" do
    a = [1, 2, 3, 4, 5]
    a[eval("(-3..)")] = [7, 8, 9]
    expect(a).to eq([1, 2, 7, 8, 9])
  end

  it "inserts at the end if m > the array size" do
    a = [1, 2, 3]
    a[eval("(3..)")] = [4]
    expect(a).to eq([1, 2, 3, 4])
    a[eval("(5..)")] = [6]
    expect(a).to eq([1, 2, 3, 4, nil, 6])
  end
end

describe "Array#[]= with [..n] and [...n]" do
  it "just sets the section defined by range to nil even if the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[(..2)] = nil
    expect(a).to eq([nil, 4, 5])
    a[(...2)] = nil
    expect(a).to eq([nil, 5])
  end

  it "just sets the section defined by range to nil if n < 0 and the rhs is nil" do
    a = [1, 2, 3, 4, 5]
    a[(..-3)] = nil
    expect(a).to eq([nil, 4, 5])
    a[(...-1)] = [nil, 5]
  end

  it "replaces the section defined by range" do
    a = [6, 5, 4, 3, 2, 1]
    a[(...3)] = 9
    expect(a).to eq([9, 3, 2, 1])
    a[(..2)] = [7, 7, 7, 7, 7]
    expect(a).to eq([7, 7, 7, 7, 7, 1])
  end

  it "replaces the section if n < 0" do
    a = [1, 2, 3, 4, 5]
    a[(..-2)] = [7, 8, 9]
    expect(a).to eq([7, 8, 9, 5])
  end

  it "replaces everything if n > the array size" do
    a = [1, 2, 3]
    a[(...7)] = [4]
    expect(a).to eq([4])
  end

  it "inserts at the beginning if n < negative the array size" do
    a = [1, 2, 3]
    a[(..-7)] = [4]
    expect(a).to eq([4, 1, 2, 3])
    a[(...-10)] = [6]
    expect(a).to eq([6, 4, 1, 2, 3])
  end
end

describe "Array#[] after a shift" do
  it "works for insertion" do
    a = [1,2]
    a.shift
    a.shift
    a[0,0] = [3,4]
    expect(a).to eq([3,4])
  end
end
