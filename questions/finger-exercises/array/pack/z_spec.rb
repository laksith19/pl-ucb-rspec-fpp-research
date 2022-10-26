# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'
require_relative 'shared/string'
require_relative 'shared/taint'

describe "Array#pack with format 'Z'" do
  it_behaves_like :array_pack_basic, 'Z'
  it_behaves_like :array_pack_basic_non_float, 'Z'
  it_behaves_like :array_pack_no_platform, 'Z'
  it_behaves_like :array_pack_string, 'Z'
  it_behaves_like :array_pack_taint, 'Z'

  it "calls #to_str to convert an Object to a String" do
    obj = double("pack Z string")
    expect(obj).to receive(:to_str).and_return("``abcdef")
    expect([obj].pack("Z*")).to eq("``abcdef\x00")
  end

  it "will not implicitly convert a number to a string" do
    expect { [0].pack('Z') }.to raise_error(TypeError)
  end

  it "adds all the bytes and appends a NULL byte when passed the '*' modifier" do
    expect(["abc"].pack("Z*")).to eq("abc\x00")
  end

  it "padds the output with NULL bytes when the count exceeds the size of the String" do
    expect(["abc"].pack("Z6")).to eq("abc\x00\x00\x00")
  end

  it "adds a NULL byte when the value is nil" do
    expect([nil].pack("Z")).to eq("\x00")
  end

  it "pads the output with NULL bytes when the value is nil" do
    expect([nil].pack("Z3")).to eq("\x00\x00\x00")
  end

  it "does not append a NULL byte when passed the '*' modifier and the value is nil" do
    expect([nil].pack("Z*")).to eq("\x00")
  end
end
