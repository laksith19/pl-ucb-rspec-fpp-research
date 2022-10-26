require_relative '../../enumerable/shared/enumeratorized'

describe :array_collect, shared: true do
  it "returns a copy of array with each element replaced by the value returned by block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) { |i| i + '!' }
    expect(b).to eq(["a!", "b!", "c!", "d!"])
    expect(b).not_to equal a
  end

  it "does not return subclass instance" do
    expect(ArraySpecs::MyArray[1, 2, 3].send(@method) { |x| x + 1 }).to be_an_instance_of(Array)
  end

  it "does not change self" do
    a = ['a', 'b', 'c', 'd']
    a.send(@method) { |i| i + '!' }
    expect(a).to eq(['a', 'b', 'c', 'd'])
  end

  it "returns the evaluated value of block if it broke in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    expect(b).to eq(0)
  end

  it "returns an Enumerator when no block given" do
    a = [1, 2, 3]
    expect(a.send(@method)).to be_an_instance_of(Enumerator)
  end

  it "raises an ArgumentError when no block and with arguments" do
    a = [1, 2, 3]
    expect {
      a.send(@method, :foo)
    }.to raise_error(ArgumentError)
  end

  before :all do
    @object = [1, 2, 3, 4]
  end
  it_should_behave_like :enumeratorized_with_origin_size
end

describe :array_collect_b, shared: true do
  it "replaces each element with the value returned by block" do
    a = [7, 9, 3, 5]
    expect(a.send(@method) { |i| i - 1 }).to equal(a)
    expect(a).to eq([6, 8, 2, 4])
  end

  it "returns self" do
    a = [1, 2, 3, 4, 5]
    b = a.send(@method) {|i| i+1 }
    expect(a).to equal b
  end

  it "returns the evaluated value of block but its contents is partially modified, if it broke in the block" do
    a = ['a', 'b', 'c', 'd']
    b = a.send(@method) {|i|
      if i == 'c'
        break 0
      else
        i + '!'
      end
    }
    expect(b).to eq(0)
    expect(a).to eq(['a!', 'b!', 'c', 'd'])
  end

  it "returns an Enumerator when no block given, and the enumerator can modify the original array" do
    a = [1, 2, 3]
    enum = a.send(@method)
    expect(enum).to be_an_instance_of(Enumerator)
    enum.each{|i| "#{i}!" }
    expect(a).to eq(["1!", "2!", "3!"])
  end

  describe "when frozen" do
    it "raises a FrozenError" do
      expect { ArraySpecs.frozen_array.send(@method) {} }.to raise_error(FrozenError)
    end

    it "raises a FrozenError when empty" do
      expect { ArraySpecs.empty_frozen_array.send(@method) {} }.to raise_error(FrozenError)
    end

    it "raises a FrozenError when calling #each on the returned Enumerator" do
      enumerator = ArraySpecs.frozen_array.send(@method)
      expect { enumerator.each {|x| x } }.to raise_error(FrozenError)
    end

    it "raises a FrozenError when calling #each on the returned Enumerator when empty" do
      enumerator = ArraySpecs.empty_frozen_array.send(@method)
      expect { enumerator.each {|x| x } }.to raise_error(FrozenError)
    end
  end

  before :all do
    @object = [1, 2, 3, 4]
  end
  it_should_behave_like :enumeratorized_with_origin_size
end
