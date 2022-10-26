# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'
require_relative 'shared/numeric_basic'

describe "Array#pack with format 'w'" do
  it_behaves_like :array_pack_basic, 'w'
  it_behaves_like :array_pack_basic_non_float, 'w'
  it_behaves_like :array_pack_arguments, 'w'
  it_behaves_like :array_pack_numeric_basic, 'w'

  it "encodes a BER-compressed integer" do
    expect([ [[0],     "\x00"],
      [[1],     "\x01"],
      [[9999],  "\xce\x0f"],
      [[2**65], "\x84\x80\x80\x80\x80\x80\x80\x80\x80\x00"]
    ]).to be_computed_by(:pack, "w")
  end

  it "calls #to_int to convert the pack argument to an Integer" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(5)
    expect([obj].pack("w")).to eq("\x05")
  end

  it "ignores NULL bytes between directives" do
    expect([1, 2, 3].pack("w\x00w")).to eq("\x01\x02")
  end

  it "ignores spaces between directives" do
    expect([1, 2, 3].pack("w w")).to eq("\x01\x02")
  end

  it "raises an ArgumentError when passed a negative value" do
    expect { [-1].pack("w") }.to raise_error(ArgumentError)
  end

  it "returns a binary string" do
    expect([1].pack('w').encoding).to eq(Encoding::BINARY)
  end
end
