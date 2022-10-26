describe :array_pack_arguments, shared: true do
  it "raises an ArgumentError if there are fewer elements than the format requires" do
    expect { [].pack(pack_format(1)) }.to raise_error(ArgumentError)
  end
end

describe :array_pack_basic, shared: true do
  before :each do
    @obj = ArraySpecs.universal_pack_object
  end

  it "raises a TypeError when passed nil" do
    expect { [@obj].pack(nil) }.to raise_error(TypeError)
  end

  it "raises a TypeError when passed an Integer" do
    expect { [@obj].pack(1) }.to raise_error(TypeError)
  end
end

describe :array_pack_basic_non_float, shared: true do
  before :each do
    @obj = ArraySpecs.universal_pack_object
  end

  it "ignores whitespace in the format string" do
    expect([@obj, @obj].pack("a \t\n\v\f\r"+pack_format)).to be_an_instance_of(String)
  end

  it "calls #to_str to coerce the directives string" do
    d = double("pack directive")
    expect(d).to receive(:to_str).and_return("x"+pack_format)
    expect([@obj, @obj].pack(d)).to be_an_instance_of(String)
  end
end

describe :array_pack_basic_float, shared: true do
  it "ignores whitespace in the format string" do
    expect([9.3, 4.7].pack(" \t\n\v\f\r"+pack_format)).to be_an_instance_of(String)
  end

  it "calls #to_str to coerce the directives string" do
    d = double("pack directive")
    expect(d).to receive(:to_str).and_return("x"+pack_format)
    expect([1.2, 4.7].pack(d)).to be_an_instance_of(String)
  end
end

describe :array_pack_no_platform, shared: true do
  it "raises ArgumentError when the format modifier is '_'" do
    expect{ [1].pack(pack_format("_")) }.to raise_error(ArgumentError)
  end

  it "raises ArgumentError when the format modifier is '!'" do
    expect{ [1].pack(pack_format("!")) }.to raise_error(ArgumentError)
  end
end
