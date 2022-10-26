require_relative '../fixtures/classes'
require_relative '../fixtures/encoded_strings'

describe :array_join_with_default_separator, shared: true do
  before :each do
    @separator = $,
  end

  after :each do
    $, = @separator
  end

  it "returns an empty string if the Array is empty" do
    expect([].send(@method)).to eq('')
  end

  it "returns a US-ASCII string for an empty Array" do
    expect([].send(@method).encoding).to eq(Encoding::US_ASCII)
  end

  it "returns a string formed by concatenating each String element separated by $," do
    suppress_warning {
      $, = " | "
      expect(["1", "2", "3"].send(@method)).to eq("1 | 2 | 3")
    }
  end

  it "attempts coercion via #to_str first" do
    obj = double('foo')
    allow(obj).to receive(:to_str).and_return("foo")
    expect([obj].send(@method)).to eq("foo")
  end

  it "attempts coercion via #to_ary second" do
    obj = double('foo')
    allow(obj).to receive(:to_str).and_return(nil)
    allow(obj).to receive(:to_ary).and_return(["foo"])
    expect([obj].send(@method)).to eq("foo")
  end

  it "attempts coercion via #to_s third" do
    obj = double('foo')
    allow(obj).to receive(:to_str).and_return(nil)
    allow(obj).to receive(:to_ary).and_return(nil)
    allow(obj).to receive(:to_s).and_return("foo")
    expect([obj].send(@method)).to eq("foo")
  end

  it "raises a NoMethodError if an element does not respond to #to_str, #to_ary, or #to_s" do
    obj = double('o')
    class << obj; undef :to_s; end
    expect { [1, obj].send(@method) }.to raise_error(NoMethodError)
  end

  it "raises an ArgumentError when the Array is recursive" do
    expect { ArraySpecs.recursive_array.send(@method) }.to raise_error(ArgumentError)
    expect { ArraySpecs.head_recursive_array.send(@method) }.to raise_error(ArgumentError)
    expect { ArraySpecs.empty_recursive_array.send(@method) }.to raise_error(ArgumentError)
  end

  it "uses the first encoding when other strings are compatible" do
    ary1 = ArraySpecs.array_with_7bit_utf8_and_usascii_strings
    ary2 = ArraySpecs.array_with_usascii_and_7bit_utf8_strings
    ary3 = ArraySpecs.array_with_utf8_and_7bit_binary_strings
    ary4 = ArraySpecs.array_with_usascii_and_7bit_binary_strings

    expect(ary1.send(@method).encoding).to eq(Encoding::UTF_8)
    expect(ary2.send(@method).encoding).to eq(Encoding::US_ASCII)
    expect(ary3.send(@method).encoding).to eq(Encoding::UTF_8)
    expect(ary4.send(@method).encoding).to eq(Encoding::US_ASCII)
  end

  it "uses the widest common encoding when other strings are incompatible" do
    ary1 = ArraySpecs.array_with_utf8_and_usascii_strings
    ary2 = ArraySpecs.array_with_usascii_and_utf8_strings

    expect(ary1.send(@method).encoding).to eq(Encoding::UTF_8)
    expect(ary2.send(@method).encoding).to eq(Encoding::UTF_8)
  end

  it "fails for arrays with incompatibly-encoded strings" do
    ary_utf8_bad_binary = ArraySpecs.array_with_utf8_and_binary_strings

    expect { ary_utf8_bad_binary.send(@method) }.to raise_error(EncodingError)
  end

  context "when $, is not nil" do
    before do
      suppress_warning do
        $, = '*'
      end
    end

    it "warns" do
      expect { [].join }.to complain(/warning: \$, is set to non-nil value/)
      expect { [].join(nil) }.to complain(/warning: \$, is set to non-nil value/)
    end
  end
end

describe :array_join_with_string_separator, shared: true do
  it "returns a string formed by concatenating each element.to_str separated by separator" do
    obj = double('foo')
    expect(obj).to receive(:to_str).and_return("foo")
    expect([1, 2, 3, 4, obj].send(@method, ' | ')).to eq('1 | 2 | 3 | 4 | foo')
  end

  it "uses the same separator with nested arrays" do
    expect([1, [2, [3, 4], 5], 6].send(@method, ":")).to eq("1:2:3:4:5:6")
    expect([1, [2, ArraySpecs::MyArray[3, 4], 5], 6].send(@method, ":")).to eq("1:2:3:4:5:6")
  end
end
