# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'
require_relative 'shared/encodings'
require_relative 'shared/taint'

describe "Array#pack with format 'B'" do
  it_behaves_like :array_pack_basic, 'B'
  it_behaves_like :array_pack_basic_non_float, 'B'
  it_behaves_like :array_pack_arguments, 'B'
  it_behaves_like :array_pack_hex, 'B'
  it_behaves_like :array_pack_taint, 'B'

  it "calls #to_str to convert an Object to a String" do
    obj = double("pack B string")
    expect(obj).to receive(:to_str).and_return("``abcdef")
    expect([obj].pack("B*")).to eq("\x2a")
  end

  it "will not implicitly convert a number to a string" do
    expect { [0].pack('B') }.to raise_error(TypeError)
    expect { [0].pack('b') }.to raise_error(TypeError)
  end

  it "encodes one bit for each character starting with the most significant bit" do
    expect([ [["0"], "\x00"],
      [["1"], "\x80"]
    ]).to be_computed_by(:pack, "B")
  end

  it "implicitly has a count of one when not passed a count modifier" do
    expect(["1"].pack("B")).to eq("\x80")
  end

  it "implicitly has count equal to the string length when passed the '*' modifier" do
    expect([ [["00101010"], "\x2a"],
      [["00000000"], "\x00"],
      [["11111111"], "\xff"],
      [["10000000"], "\x80"],
      [["00000001"], "\x01"]
    ]).to be_computed_by(:pack, "B*")
  end

  it "encodes the least significant bit of a character other than 0 or 1" do
    expect([ [["bbababab"], "\x2a"],
      [["^&#&#^#^"], "\x2a"],
      [["(()()()("], "\x2a"],
      [["@@%@%@%@"], "\x2a"],
      [["ppqrstuv"], "\x2a"],
      [["rqtvtrqp"], "\x42"]
    ]).to be_computed_by(:pack, "B*")
  end

  it "returns a binary string" do
    expect(["1"].pack("B").encoding).to eq(Encoding::BINARY)
  end

  it "encodes the string as a sequence of bytes" do
    expect(["ああああああああ"].pack("B*")).to eq("\xdbm\xb6")
  end
end

describe "Array#pack with format 'b'" do
  it_behaves_like :array_pack_basic, 'b'
  it_behaves_like :array_pack_basic_non_float, 'b'
  it_behaves_like :array_pack_arguments, 'b'
  it_behaves_like :array_pack_hex, 'b'
  it_behaves_like :array_pack_taint, 'b'

  it "calls #to_str to convert an Object to a String" do
    obj = double("pack H string")
    expect(obj).to receive(:to_str).and_return("`abcdef`")
    expect([obj].pack("b*")).to eq("\x2a")
  end

  it "encodes one bit for each character starting with the least significant bit" do
    expect([ [["0"], "\x00"],
      [["1"], "\x01"]
    ]).to be_computed_by(:pack, "b")
  end

  it "implicitly has a count of one when not passed a count modifier" do
    expect(["1"].pack("b")).to eq("\x01")
  end

  it "implicitly has count equal to the string length when passed the '*' modifier" do
    expect([ [["0101010"],  "\x2a"],
      [["00000000"], "\x00"],
      [["11111111"], "\xff"],
      [["10000000"], "\x01"],
      [["00000001"], "\x80"]
    ]).to be_computed_by(:pack, "b*")
  end

  it "encodes the least significant bit of a character other than 0 or 1" do
    expect([ [["bababab"], "\x2a"],
      [["&#&#^#^"], "\x2a"],
      [["()()()("], "\x2a"],
      [["@%@%@%@"], "\x2a"],
      [["pqrstuv"], "\x2a"],
      [["qrtrtvs"], "\x41"]
    ]).to be_computed_by(:pack, "b*")
  end

  it "returns a binary string" do
    expect(["1"].pack("b").encoding).to eq(Encoding::BINARY)
  end

  it "encodes the string as a sequence of bytes" do
    expect(["ああああああああ"].pack("b*")).to eq("\xdb\xb6m")
  end
end
