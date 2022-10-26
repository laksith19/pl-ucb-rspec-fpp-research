describe :array_pack_hex, shared: true do
  it "encodes no bytes when passed zero as the count modifier" do
    expect(["abc"].pack(pack_format(0))).to eq("")
  end

  it "raises a TypeError if the object does not respond to #to_str" do
    obj = double("pack hex non-string")
    expect { [obj].pack(pack_format) }.to raise_error(TypeError)
  end

  it "raises a TypeError if #to_str does not return a String" do
    obj = double("pack hex non-string")
    expect(obj).to receive(:to_str).and_return(1)
    expect { [obj].pack(pack_format) }.to raise_error(TypeError)
  end
end
