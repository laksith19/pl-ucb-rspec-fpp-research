require_relative '../fixtures/encoded_strings'

describe :array_inspect, shared: true do
  it "returns a string" do
    expect([1, 2, 3].send(@method)).to be_an_instance_of(String)
  end

  it "returns '[]' for an empty Array" do
    expect([].send(@method)).to eq("[]")
  end

  it "calls inspect on its elements and joins the results with commas" do
    items = Array.new(3) do |i|
      obj = double(i.to_s)
      expect(obj).to receive(:inspect).and_return(i.to_s)
      obj
    end
    expect(items.send(@method)).to eq("[0, 1, 2]")
  end

  it "does not call #to_s on a String returned from #inspect" do
    str = "abc"
    expect(str).not_to receive(:to_s)

    expect([str].send(@method)).to eq('["abc"]')
  end

  it "calls #to_s on the object returned from #inspect if the Object isn't a String" do
    obj = double("Array#inspect/to_s calls #to_s")
    expect(obj).to receive(:inspect).and_return(obj)
    expect(obj).to receive(:to_s).and_return("abc")

    expect([obj].send(@method)).to eq("[abc]")
  end

  it "does not call #to_str on the object returned from #inspect when it is not a String" do
    obj = double("Array#inspect/to_s does not call #to_str")
    expect(obj).to receive(:inspect).and_return(obj)
    expect(obj).not_to receive(:to_str)

    expect([obj].send(@method)).to match(/^\[#<MockObject:0x[0-9a-f]+>\]$/)
  end

  it "does not call #to_str on the object returned from #to_s when it is not a String" do
    obj = double("Array#inspect/to_s does not call #to_str on #to_s result")
    expect(obj).to receive(:inspect).and_return(obj)
    expect(obj).to receive(:to_s).and_return(obj)
    expect(obj).not_to receive(:to_str)

    expect([obj].send(@method)).to match(/^\[#<MockObject:0x[0-9a-f]+>\]$/)
  end

  it "does not swallow exceptions raised by #to_s" do
    obj = double("Array#inspect/to_s does not swallow #to_s exceptions")
    expect(obj).to receive(:inspect).and_return(obj)
    expect(obj).to receive(:to_s).and_raise(Exception)

    expect { [obj].send(@method) }.to raise_error(Exception)
  end

  it "represents a recursive element with '[...]'" do
    expect(ArraySpecs.recursive_array.send(@method)).to eq("[1, \"two\", 3.0, [...], [...], [...], [...], [...]]")
    expect(ArraySpecs.head_recursive_array.send(@method)).to eq("[[...], [...], [...], [...], [...], 1, \"two\", 3.0]")
    expect(ArraySpecs.empty_recursive_array.send(@method)).to eq("[[...]]")
  end

  describe "with encoding" do
    before :each do
      @default_external_encoding = Encoding.default_external
    end

    after :each do
      Encoding.default_external = @default_external_encoding
    end

    it "returns a US-ASCII string for an empty Array" do
      expect([].send(@method).encoding).to eq(Encoding::US_ASCII)
    end

    it "use the default external encoding if it is ascii compatible" do
      Encoding.default_external = Encoding.find('UTF-8')

      utf8 = "utf8".encode("UTF-8")
      jp   = "jp".encode("EUC-JP")
      array = [jp, utf8]

      expect(array.send(@method).encoding.name).to eq("UTF-8")
    end

    it "use US-ASCII encoding if the default external encoding is not ascii compatible" do
      Encoding.default_external = Encoding.find('UTF-32')

      utf8 = "utf8".encode("UTF-8")
      jp   = "jp".encode("EUC-JP")
      array = [jp, utf8]

      expect(array.send(@method).encoding.name).to eq("US-ASCII")
    end

    it "does not raise if inspected result is not default external encoding" do
      utf_16be = double("utf_16be")
      expect(utf_16be).to receive(:inspect).and_return(%<"utf_16be \u3042">.encode!(Encoding::UTF_16BE))

      expect([utf_16be].send(@method)).to eq('["utf_16be \u3042"]')
    end
  end
end
