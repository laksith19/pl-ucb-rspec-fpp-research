require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#fill" do
  before :all do
    @never_passed = -> i do
      raise ExpectationNotMetError, "the control path should not pass here"
    end
  end

  it "returns self" do
    ary = [1, 2, 3]
    expect(ary.fill(:a)).to equal(ary)
  end

  it "is destructive" do
    ary = [1, 2, 3]
    ary.fill(:a)
    expect(ary).to eq([:a, :a, :a])
  end

  it "does not replicate the filler" do
    ary = [1, 2, 3, 4]
    str = "x"
    expect(ary.fill(str)).to eq([str, str, str, str])
    str << "y"
    expect(ary).to eq([str, str, str, str])
    expect(ary[0]).to equal(str)
    expect(ary[1]).to equal(str)
    expect(ary[2]).to equal(str)
    expect(ary[3]).to equal(str)
  end

  it "replaces all elements in the array with the filler if not given a index nor a length" do
    ary = ['a', 'b', 'c', 'duh']
    expect(ary.fill(8)).to eq([8, 8, 8, 8])

    str = "x"
    expect(ary.fill(str)).to eq([str, str, str, str])
  end

  it "replaces all elements with the value of block (index given to block)" do
    expect([nil, nil, nil, nil].fill { |i| i * 2 }).to eq([0, 2, 4, 6])
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.fill('x') }.to raise_error(FrozenError)
  end

  it "raises a FrozenError on an empty frozen array" do
    expect { ArraySpecs.empty_frozen_array.fill('x') }.to raise_error(FrozenError)
  end

  it "raises an ArgumentError if 4 or more arguments are passed when no block given" do
    expect { [].fill('a') }.not_to raise_error

    expect { [].fill('a', 1) }.not_to raise_error

    expect { [].fill('a', 1, 2) }.not_to raise_error
    expect { [].fill('a', 1, 2, true) }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError if no argument passed and no block given" do
    expect { [].fill }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError if 3 or more arguments are passed when a block given" do
    expect { [].fill() {|i|} }.not_to raise_error

    expect { [].fill(1) {|i|} }.not_to raise_error

    expect { [].fill(1, 2) {|i|} }.not_to raise_error
    expect { [].fill(1, 2, true) {|i|} }.to raise_error(ArgumentError)
  end
end

describe "Array#fill with (filler, index, length)" do
  it "replaces length elements beginning with the index with the filler if given an index and a length" do
    ary = [1, 2, 3, 4, 5, 6]
    expect(ary.fill('x', 2, 3)).to eq([1, 2, 'x', 'x', 'x', 6])
  end

  it "replaces length elements beginning with the index with the value of block" do
    expect([true, false, true, false, true, false, true].fill(1, 4) { |i| i + 3 }).to eq([true, 4, 5, 6, 7, false, true])
  end

  it "replaces all elements after the index if given an index and no length" do
    ary = [1, 2, 3]
    expect(ary.fill('x', 1)).to eq([1, 'x', 'x'])
    expect(ary.fill(1){|i| i*2}).to eq([1, 2, 4])
  end

  it "replaces all elements after the index if given an index and nil as a length" do
    a = [1, 2, 3]
    expect(a.fill('x', 1, nil)).to eq([1, 'x', 'x'])
    expect(a.fill(1, nil){|i| i*2}).to eq([1, 2, 4])
    expect(a.fill('y', nil)).to eq(['y', 'y', 'y'])
  end

  it "replaces the last (-n) elements if given an index n which is negative and no length" do
    a = [1, 2, 3, 4, 5]
    expect(a.fill('x', -2)).to eq([1, 2, 3, 'x', 'x'])
    expect(a.fill(-2){|i| i.to_s}).to eq([1, 2, 3, '3', '4'])
  end

  it "replaces the last (-n) elements if given an index n which is negative and nil as a length" do
    a = [1, 2, 3, 4, 5]
    expect(a.fill('x', -2, nil)).to eq([1, 2, 3, 'x', 'x'])
    expect(a.fill(-2, nil){|i| i.to_s}).to eq([1, 2, 3, '3', '4'])
  end

  it "makes no modifications if given an index greater than end and no length" do
    expect([1, 2, 3, 4, 5].fill('a', 5)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill(5, &@never_passed)).to eq([1, 2, 3, 4, 5])
  end

  it "makes no modifications if given an index greater than end and nil as a length" do
    expect([1, 2, 3, 4, 5].fill('a', 5, nil)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill(5, nil, &@never_passed)).to eq([1, 2, 3, 4, 5])
  end

  it "replaces length elements beginning with start index if given an index >= 0 and a length >= 0" do
    expect([1, 2, 3, 4, 5].fill('a', 2, 0)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill('a', 2, 2)).to eq([1, 2, "a", "a", 5])

    expect([1, 2, 3, 4, 5].fill(2, 0, &@never_passed)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill(2, 2){|i| i*2}).to eq([1, 2, 4, 6, 5])
  end

  it "increases the Array size when necessary" do
    a = [1, 2, 3]
    expect(a.size).to eq(3)
    a.fill 'a', 0, 10
    expect(a.size).to eq(10)
  end

  it "pads between the last element and the index with nil if given an index which is greater than size of the array" do
    expect([1, 2, 3, 4, 5].fill('a', 8, 5)).to eq([1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a'])
    expect([1, 2, 3, 4, 5].fill(8, 5){|i| 'a'}).to eq([1, 2, 3, 4, 5, nil, nil, nil, 'a', 'a', 'a', 'a', 'a'])
  end

  it "replaces length elements beginning with the (-n)th if given an index n < 0 and a length > 0" do
    expect([1, 2, 3, 4, 5].fill('a', -2, 2)).to eq([1, 2, 3, "a", "a"])
    expect([1, 2, 3, 4, 5].fill('a', -2, 4)).to eq([1, 2, 3, "a", "a", "a", "a"])

    expect([1, 2, 3, 4, 5].fill(-2, 2){|i| 'a'}).to eq([1, 2, 3, "a", "a"])
    expect([1, 2, 3, 4, 5].fill(-2, 4){|i| 'a'}).to eq([1, 2, 3, "a", "a", "a", "a"])
  end

  it "starts at 0 if the negative index is before the start of the array" do
    expect([1, 2, 3, 4, 5].fill('a', -25, 3)).to eq(['a', 'a', 'a', 4, 5])
    expect([1, 2, 3, 4, 5].fill('a', -10, 10)).to eq(%w|a a a a a a a a a a|)

    expect([1, 2, 3, 4, 5].fill(-25, 3){|i| 'a'}).to eq(['a', 'a', 'a', 4, 5])
    expect([1, 2, 3, 4, 5].fill(-10, 10){|i| 'a'}).to eq(%w|a a a a a a a a a a|)
  end

  it "makes no modifications if the given length <= 0" do
    expect([1, 2, 3, 4, 5].fill('a', 2, 0)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill('a', -2, 0)).to eq([1, 2, 3, 4, 5])

    expect([1, 2, 3, 4, 5].fill('a', 2, -2)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill('a', -2, -2)).to eq([1, 2, 3, 4, 5])

    expect([1, 2, 3, 4, 5].fill(2, 0, &@never_passed)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill(-2, 0, &@never_passed)).to eq([1, 2, 3, 4, 5])

    expect([1, 2, 3, 4, 5].fill(2, -2, &@never_passed)).to eq([1, 2, 3, 4, 5])
    expect([1, 2, 3, 4, 5].fill(-2, -2, &@never_passed)).to eq([1, 2, 3, 4, 5])
  end

  # See: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/17481
  it "does not raise an exception if the given length is negative and its absolute value does not exceed the index" do
    expect { [1, 2, 3, 4].fill('a', 3, -1)}.not_to raise_error
    expect { [1, 2, 3, 4].fill('a', 3, -2)}.not_to raise_error
    expect { [1, 2, 3, 4].fill('a', 3, -3)}.not_to raise_error

    expect { [1, 2, 3, 4].fill(3, -1, &@never_passed)}.not_to raise_error
    expect { [1, 2, 3, 4].fill(3, -2, &@never_passed)}.not_to raise_error
    expect { [1, 2, 3, 4].fill(3, -3, &@never_passed)}.not_to raise_error
  end

  it "does not raise an exception even if the given length is negative and its absolute value exceeds the index" do
    expect { [1, 2, 3, 4].fill('a', 3, -4)}.not_to raise_error
    expect { [1, 2, 3, 4].fill('a', 3, -5)}.not_to raise_error
    expect { [1, 2, 3, 4].fill('a', 3, -10000)}.not_to raise_error

    expect { [1, 2, 3, 4].fill(3, -4, &@never_passed)}.not_to raise_error
    expect { [1, 2, 3, 4].fill(3, -5, &@never_passed)}.not_to raise_error
    expect { [1, 2, 3, 4].fill(3, -10000, &@never_passed)}.not_to raise_error
  end

  it "tries to convert the second and third arguments to Integers using #to_int" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(2, 2)
    filler = double('filler')
    expect(filler).not_to receive(:to_int)
    expect([1, 2, 3, 4, 5].fill(filler, obj, obj)).to eq([1, 2, filler, filler, 5])
  end

  it "raises a TypeError if the index is not numeric" do
    expect { [].fill 'a', true }.to raise_error(TypeError)

    obj = double('nonnumeric')
    expect { [].fill('a', obj) }.to raise_error(TypeError)
  end

  it "raises a TypeError when the length is not numeric" do
    expect { [1, 2, 3].fill("x", 1, "foo") }.to raise_error(TypeError, /no implicit conversion of String into Integer/)
    expect { [1, 2, 3].fill("x", 1, :"foo") }.to raise_error(TypeError, /no implicit conversion of Symbol into Integer/)
    expect { [1, 2, 3].fill("x", 1, Object.new) }.to raise_error(TypeError, /no implicit conversion of Object into Integer/)
  end

  not_supported_on :opal do
    it "raises an ArgumentError or RangeError for too-large sizes" do
      error_types = [RangeError, ArgumentError]
      arr = [1, 2, 3]
      expect { arr.fill(10, 1, fixnum_max) }.to raise_error { |err| expect(error_types).to include(err.class) }
      expect { arr.fill(10, 1, bignum_value) }.to raise_error(RangeError)
    end
  end
end

describe "Array#fill with (filler, range)" do
  it "replaces elements in range with object" do
    expect([1, 2, 3, 4, 5, 6].fill(8, 0..3)).to eq([8, 8, 8, 8, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(8, 0...3)).to eq([8, 8, 8, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 4..6)).to eq([1, 2, 3, 4, 'x', 'x', 'x'])
    expect([1, 2, 3, 4, 5, 6].fill('x', 4...6)).to eq([1, 2, 3, 4, 'x', 'x'])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2..-1)).to eq([1, 2, 3, 4, 'x', 'x'])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2...-1)).to eq([1, 2, 3, 4, 'x', 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2...-2)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2..-2)).to eq([1, 2, 3, 4, 'x', 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2..0)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 0...0)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 1..1)).to eq([1, 'x', 3, 4, 5, 6])
  end

  it "replaces all elements in range with the value of block" do
    expect([1, 1, 1, 1, 1, 1].fill(1..6) { |i| i + 1 }).to eq([1, 2, 3, 4, 5, 6, 7])
  end

  it "increases the Array size when necessary" do
    expect([1, 2, 3].fill('x', 1..6)).to eq([1, 'x', 'x', 'x', 'x', 'x', 'x'])
    expect([1, 2, 3].fill(1..6){|i| i+1}).to eq([1, 2, 3, 4, 5, 6, 7])
  end

  it "raises a TypeError with range and length argument" do
    expect { [].fill('x', 0 .. 2, 5) }.to raise_error(TypeError)
  end

  it "replaces elements between the (-m)th to the last and the (n+1)th from the first if given an range m..n where m < 0 and n >= 0" do
    expect([1, 2, 3, 4, 5, 6].fill('x', -4..4)).to eq([1, 2, 'x', 'x', 'x', 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -4...4)).to eq([1, 2, 'x', 'x', 5, 6])

    expect([1, 2, 3, 4, 5, 6].fill(-4..4){|i| (i+1).to_s}).to eq([1, 2, '3', '4', '5', 6])
    expect([1, 2, 3, 4, 5, 6].fill(-4...4){|i| (i+1).to_s}).to eq([1, 2, '3', '4', 5, 6])
  end

  it "replaces elements between the (-m)th and (-n)th to the last if given an range m..n where m < 0 and n < 0" do
    expect([1, 2, 3, 4, 5, 6].fill('x', -4..-2)).to eq([1, 2, 'x', 'x', 'x', 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -4...-2)).to eq([1, 2, 'x', 'x', 5, 6])

    expect([1, 2, 3, 4, 5, 6].fill(-4..-2){|i| (i+1).to_s}).to eq([1, 2, '3', '4', '5', 6])
    expect([1, 2, 3, 4, 5, 6].fill(-4...-2){|i| (i+1).to_s}).to eq([1, 2, '3', '4', 5, 6])
  end

  it "replaces elements between the (m+1)th from the first and (-n)th to the last if given an range m..n where m >= 0 and n < 0" do
    expect([1, 2, 3, 4, 5, 6].fill('x', 2..-2)).to eq([1, 2, 'x', 'x', 'x', 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 2...-2)).to eq([1, 2, 'x', 'x', 5, 6])

    expect([1, 2, 3, 4, 5, 6].fill(2..-2){|i| (i+1).to_s}).to eq([1, 2, '3', '4', '5', 6])
    expect([1, 2, 3, 4, 5, 6].fill(2...-2){|i| (i+1).to_s}).to eq([1, 2, '3', '4', 5, 6])
  end

  it "makes no modifications if given an range which implies a section of zero width" do
    expect([1, 2, 3, 4, 5, 6].fill('x', 2...2)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -4...2)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -4...-4)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 2...-4)).to eq([1, 2, 3, 4, 5, 6])

    expect([1, 2, 3, 4, 5, 6].fill(2...2, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(-4...2, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(-4...-4, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(2...-4, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
  end

  it "makes no modifications if given an range which implies a section of negative width" do
    expect([1, 2, 3, 4, 5, 6].fill('x', 2..1)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -4..1)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', -2..-4)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill('x', 2..-5)).to eq([1, 2, 3, 4, 5, 6])

    expect([1, 2, 3, 4, 5, 6].fill(2..1, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(-4..1, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(-2..-4, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
    expect([1, 2, 3, 4, 5, 6].fill(2..-5, &@never_passed)).to eq([1, 2, 3, 4, 5, 6])
  end

  it "raises an exception if some of the given range lies before the first of the array" do
    expect { [1, 2, 3].fill('x', -5..-3) }.to raise_error(RangeError)
    expect { [1, 2, 3].fill('x', -5...-3) }.to raise_error(RangeError)
    expect { [1, 2, 3].fill('x', -5..-4) }.to raise_error(RangeError)

    expect { [1, 2, 3].fill(-5..-3, &@never_passed) }.to raise_error(RangeError)
    expect { [1, 2, 3].fill(-5...-3, &@never_passed) }.to raise_error(RangeError)
    expect { [1, 2, 3].fill(-5..-4, &@never_passed) }.to raise_error(RangeError)
  end

  it "tries to convert the start and end of the passed range to Integers using #to_int" do
    obj = double('to_int')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    expect(obj).to receive(:to_int).twice.and_return(2)
    filler = double('filler')
    expect(filler).not_to receive(:to_int)
    expect([1, 2, 3, 4, 5].fill(filler, obj..obj)).to eq([1, 2, filler, 4, 5])
  end

  it "raises a TypeError if the start or end of the passed range is not numeric" do
    obj = double('nonnumeric')
    def obj.<=>(rhs); rhs == self ? 0 : nil end
    expect { [].fill('a', obj..obj) }.to raise_error(TypeError)
  end

  it "works with endless ranges" do
    expect([1, 2, 3, 4].fill('x', eval("(1..)"))).to eq([1, 'x', 'x', 'x'])
    expect([1, 2, 3, 4].fill('x', eval("(3...)"))).to eq([1, 2, 3, 'x'])
    expect([1, 2, 3, 4].fill(eval("(1..)")) { |x| x + 2 }).to eq([1, 3, 4, 5])
    expect([1, 2, 3, 4].fill(eval("(3...)")) { |x| x + 2 }).to eq([1, 2, 3, 5])
  end

  it "works with beginless ranges" do
    expect([1, 2, 3, 4].fill('x', (..2))).to eq(["x", "x", "x", 4])
    expect([1, 2, 3, 4].fill((...2)) { |x| x + 2 }).to eq([2, 3, 3, 4])
  end
end
