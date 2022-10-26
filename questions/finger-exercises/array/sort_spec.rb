require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#sort" do
  it "returns a new array sorted based on comparing elements with <=>" do
    a = [1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    expect(a.sort).to eq([-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000])
  end

  it "does not affect the original Array" do
    a = [3, 1, 2]
    expect(a.sort).to eq([1, 2, 3])
    expect(a).to eq([3, 1, 2])

    a = [0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    b = a.sort
    expect(a).to eq([0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13])
    expect(b).to eq((0..15).to_a)
  end

  it "sorts already-sorted Arrays" do
    expect((0..15).to_a.sort).to eq((0..15).to_a)
  end

  it "sorts reverse-sorted Arrays" do
    expect((0..15).to_a.reverse.sort).to eq((0..15).to_a)
  end

  it "sorts Arrays that consist entirely of equal elements" do
    a = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    expect(a.sort).to eq(a)
    b = Array.new(15).map { ArraySpecs::SortSame.new }
    expect(b.sort).to eq(b)
  end

  it "sorts Arrays that consist mostly of equal elements" do
    a = [1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    expect(a.sort).to eq([0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
  end

  it "does not return self even if the array would be already sorted" do
    a = [1, 2, 3]
    sorted = a.sort
    expect(sorted).to eq(a)
    expect(sorted).not_to equal(a)
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.sort).to eq(empty)

    array = [[]]; array << array
    expect(array.sort).to eq([[], array])
  end

  it "uses #<=> of elements in order to sort" do
    a = ArraySpecs::MockForCompared.new
    b = ArraySpecs::MockForCompared.new
    c = ArraySpecs::MockForCompared.new

    expect(ArraySpecs::MockForCompared).not_to.compared?
    expect([a, b, c].sort).to eq([c, b, a])
    expect(ArraySpecs::MockForCompared).to.compared?
  end

  it "does not deal with exceptions raised by unimplemented or incorrect #<=>" do
    o = Object.new

    expect {
      [o, 1].sort
    }.to raise_error(ArgumentError)
  end

  it "may take a block which is used to determine the order of objects a and b described as -1, 0 or +1" do
    a = [5, 1, 4, 3, 2]
    expect(a.sort).to eq([1, 2, 3, 4, 5])
    expect(a.sort {|x, y| y <=> x}).to eq([5, 4, 3, 2, 1])
  end

  it "raises an error when a given block returns nil" do
    expect { [1, 2].sort {} }.to raise_error(ArgumentError)
  end

  it "does not call #<=> on contained objects when invoked with a block" do
    a = Array.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    expect(a.sort { -1 }).to be_an_instance_of(Array)
  end

  it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Array.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    expect(a.sort { -1 }).to be_an_instance_of(Array)
  end

  it "completes when supplied a block that always returns the same result" do
    a = [2, 3, 5, 1, 4]
    expect(a.sort {  1 }).to be_an_instance_of(Array)
    expect(a.sort {  0 }).to be_an_instance_of(Array)
    expect(a.sort { -1 }).to be_an_instance_of(Array)
  end

  it "does not freezes self during being sorted" do
    a = [1, 2, 3]
    a.sort { |x,y| expect(a).not_to.frozen?; x <=> y }
  end

  it "returns the specified value when it would break in the given block" do
    expect([1, 2, 3].sort{ break :a }).to eq(:a)
  end

  it "uses the sign of Integer block results as the sort result" do
    a = [1, 2, 5, 10, 7, -4, 12]
    begin
      class Integer
        alias old_spaceship <=>
        def <=>(other)
          raise
        end
      end
      expect(a.sort {|n, m| (n - m) * (2 ** 200)}).to eq([-4, 1, 2, 5, 7, 10, 12])
    ensure
      class Integer
        alias <=> old_spaceship
      end
    end
  end

  it "compares values returned by block with 0" do
    a = [1, 2, 5, 10, 7, -4, 12]
    expect(a.sort { |n, m| n - m }).to eq([-4, 1, 2, 5, 7, 10, 12])
    expect(a.sort { |n, m|
      ArraySpecs::ComparableWithInteger.new(n-m)
    }).to eq([-4, 1, 2, 5, 7, 10, 12])
    expect {
      a.sort { |n, m| (n - m).to_s }
    }.to raise_error(ArgumentError)
  end

  it "sorts an array that has a value shifted off without a block" do
    a = Array.new(20, 1)
    a.shift
    a[0] = 2
    expect(a.sort.last).to eq(2)
  end

  it "sorts an array that has a value shifted off with a block" do
    a = Array.new(20, 1)
    a.shift
    a[0] = 2
    expect(a.sort {|x, y| x <=> y }.last).to eq(2)
  end

  it "raises an error if objects can't be compared" do
    a=[ArraySpecs::Uncomparable.new, ArraySpecs::Uncomparable.new]
    expect {a.sort}.to raise_error(ArgumentError)
  end

  # From a strange Rubinius bug
  it "handles a large array that has been pruned" do
    pruned = ArraySpecs::LargeArray.dup.delete_if { |n| n !~ /^test./ }
    expect(pruned.sort).to eq(ArraySpecs::LargeTestArraySorted)
  end

  it "does not return subclass instance on Array subclasses" do
    ary = ArraySpecs::MyArray[1, 2, 3]
    expect(ary.sort).to be_an_instance_of(Array)
  end
end

describe "Array#sort!" do
  it "sorts array in place using <=>" do
    a = [1, -2, 3, 9, 1, 5, -5, 1000, -5, 2, -10, 14, 6, 23, 0]
    a.sort!
    expect(a).to eq([-10, -5, -5, -2, 0, 1, 1, 2, 3, 5, 6, 9, 14, 23, 1000])
  end

  it "sorts array in place using block value if a block given" do
    a = [0, 15, 2, 3, 4, 6, 14, 5, 7, 12, 8, 9, 1, 10, 11, 13]
    expect(a.sort! { |x, y| y <=> x }).to eq((0..15).to_a.reverse)
  end

  it "returns self if the order of elements changed" do
    a = [6, 7, 2, 3, 7]
    expect(a.sort!).to equal(a)
    expect(a).to eq([2, 3, 6, 7, 7])
  end

  it "returns self even if makes no modification" do
    a = [1, 2, 3, 4, 5]
    expect(a.sort!).to equal(a)
    expect(a).to eq([1, 2, 3, 4, 5])
  end

  it "properly handles recursive arrays" do
    empty = ArraySpecs.empty_recursive_array
    expect(empty.sort!).to eq(empty)

    array = [[]]; array << array
    expect(array.sort!).to eq(array)
  end

  it "uses #<=> of elements in order to sort" do
    a = ArraySpecs::MockForCompared.new
    b = ArraySpecs::MockForCompared.new
    c = ArraySpecs::MockForCompared.new

    expect(ArraySpecs::MockForCompared).not_to.compared?
    expect([a, b, c].sort!).to eq([c, b, a])
    expect(ArraySpecs::MockForCompared).to.compared?
  end

  it "does not call #<=> on contained objects when invoked with a block" do
    a = Array.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    expect(a.sort! { -1 }).to be_an_instance_of(Array)
  end

  it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Array.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    expect(a.sort! { -1 }).to be_an_instance_of(Array)
  end

  it "completes when supplied a block that always returns the same result" do
    a = [2, 3, 5, 1, 4]
    expect(a.sort!{  1 }).to be_an_instance_of(Array)
    expect(a.sort!{  0 }).to be_an_instance_of(Array)
    expect(a.sort!{ -1 }).to be_an_instance_of(Array)
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.sort! }.to raise_error(FrozenError)
  end

  it "returns the specified value when it would break in the given block" do
    expect([1, 2, 3].sort{ break :a }).to eq(:a)
  end

  it "makes some modification even if finished sorting when it would break in the given block" do
    partially_sorted = (1..5).map{|i|
      ary = [5, 4, 3, 2, 1]
      ary.sort!{|x,y| break if x==i; x<=>y}
      ary
    }
    expect(partially_sorted.any?{|ary| ary != [1, 2, 3, 4, 5]}).to be_true
  end
end
