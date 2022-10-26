# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'
require_relative 'shared/string'
require_relative 'shared/taint'

describe "Array#pack with format 'A'" do
  it_behaves_like :array_pack_basic, 'A'
  it_behaves_like :array_pack_basic_non_float, 'A'
  it_behaves_like :array_pack_no_platform, 'A'
  it_behaves_like :array_pack_string, 'A'
  it_behaves_like :array_pack_taint, 'A'

  it "calls #to_str to convert an Object to a String" do
    obj = double("pack A string")
    expect(obj).to receive(:to_str).and_return("``abcdef")
    expect([obj].pack("A*")).to eq("``abcdef")
  end

  it "will not implicitly convert a number to a string" do
    expect { [0].pack('A') }.to raise_error(TypeError)
    expect { [0].pack('a') }.to raise_error(TypeError)
  end

  it "adds all the bytes to the output when passed the '*' modifier" do
    expect(["abc"].pack("A*")).to eq("abc")
  end

  it "padds the output with spaces when the count exceeds the size of the String" do
    expect(["abc"].pack("A6")).to eq("abc   ")
  end

  it "adds a space when the value is nil" do
    expect([nil].pack("A")).to eq(" ")
  end

  it "pads the output with spaces when the value is nil" do
    expect([nil].pack("A3")).to eq("   ")
  end

  it "does not pad with spaces when passed the '*' modifier and the value is nil" do
    expect([nil].pack("A*")).to eq("")
  end
end

describe "Array#pack with format 'a'" do
  it_behaves_like :array_pack_basic, 'a'
  it_behaves_like :array_pack_basic_non_float, 'a'
  it_behaves_like :array_pack_no_platform, 'a'
  it_behaves_like :array_pack_string, 'a'
  it_behaves_like :array_pack_taint, 'a'

  it "adds all the bytes to the output when passed the '*' modifier" do
    expect(["abc"].pack("a*")).to eq("abc")
  end

  it "padds the output with NULL bytes when the count exceeds the size of the String" do
    expect(["abc"].pack("a6")).to eq("abc\x00\x00\x00")
  end

  it "adds a NULL byte when the value is nil" do
    expect([nil].pack("a")).to eq("\x00")
  end

  it "pads the output with NULL bytes when the value is nil" do
    expect([nil].pack("a3")).to eq("\x00\x00\x00")
  end

  it "does not pad with NULL bytes when passed the '*' modifier and the value is nil" do
    expect([nil].pack("a*")).to eq("")
  end
end
