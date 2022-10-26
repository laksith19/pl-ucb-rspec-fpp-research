# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'

describe "Array#pack with format 'x'" do
  it_behaves_like :array_pack_basic, 'x'
  it_behaves_like :array_pack_basic_non_float, 'x'
  it_behaves_like :array_pack_no_platform, 'x'

  it "adds a NULL byte with an empty array" do
    expect([].pack("x")).to eq("\x00")
  end

  it "adds a NULL byte without consuming an element" do
    expect([1, 2].pack("CxC")).to eq("\x01\x00\x02")
  end

  it "is not affected by a previous count modifier" do
    expect([].pack("x3x")).to eq("\x00\x00\x00\x00")
  end

  it "adds multiple NULL bytes when passed a count modifier" do
    expect([].pack("x3")).to eq("\x00\x00\x00")
  end

  it "does not add a NULL byte if the count modifier is zero" do
    expect([].pack("x0")).to eq("")
  end

  it "does not add a NULL byte when passed the '*' modifier" do
    expect([].pack("x*")).to eq("")
    expect([1, 2].pack("Cx*C")).to eq("\x01\x02")
  end
end

describe "Array#pack with format 'X'" do
  it_behaves_like :array_pack_basic, 'X'
  it_behaves_like :array_pack_basic_non_float, 'X'
  it_behaves_like :array_pack_no_platform, 'X'

  it "reduces the output string by one byte at the point it is encountered" do
    expect([1, 2, 3].pack("C2XC")).to eq("\x01\x03")
  end

  it "does not consume any elements" do
    expect([1, 2, 3].pack("CXC")).to eq("\x02")
  end

  it "reduces the output string by multiple bytes when passed a count modifier" do
    expect([1, 2, 3, 4, 5].pack("C2X2C")).to eq("\x03")
  end

  it "has no affect when passed the '*' modifier" do
    expect([1, 2, 3].pack("C2X*C")).to eq("\x01\x02\x03")
  end

  it "raises an ArgumentError if the output string is empty" do
    expect { [1, 2, 3].pack("XC") }.to raise_error(ArgumentError)
  end

  it "raises an ArgumentError if the count modifier is greater than the bytes in the string" do
    expect { [1, 2, 3].pack("C2X3") }.to raise_error(ArgumentError)
  end
end
