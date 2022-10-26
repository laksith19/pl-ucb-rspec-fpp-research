describe :array_pack_numeric_basic, shared: true do
  it "returns an empty String if count is zero" do
    expect([1].pack(pack_format(0))).to eq("")
  end

  it "raises a TypeError when passed nil" do
    expect { [nil].pack(pack_format) }.to raise_error(TypeError)
  end

  it "raises a TypeError when passed true" do
    expect { [true].pack(pack_format) }.to raise_error(TypeError)
  end

  it "raises a TypeError when passed false" do
    expect { [false].pack(pack_format) }.to raise_error(TypeError)
  end

  it "returns a binary string" do
    expect([0xFF].pack(pack_format).encoding).to eq(Encoding::BINARY)
    expect([0xE3, 0x81, 0x82].pack(pack_format(3)).encoding).to eq(Encoding::BINARY)
  end
end

describe :array_pack_integer, shared: true do
  it "raises a TypeError when the object does not respond to #to_int" do
    obj = double('not an integer')
    expect { [obj].pack(pack_format) }.to raise_error(TypeError)
  end

  it "raises a TypeError when passed a String" do
    expect { ["5"].pack(pack_format) }.to raise_error(TypeError)
  end
end

describe :array_pack_float, shared: true do
  it "raises a TypeError if a String does not represent a floating point number" do
    expect { ["a"].pack(pack_format) }.to raise_error(TypeError)
  end

  it "raises a TypeError when the object does not respond to #to_f" do
    obj = double('not an float')
    expect { [obj].pack(pack_format) }.to raise_error(TypeError)
  end
end
