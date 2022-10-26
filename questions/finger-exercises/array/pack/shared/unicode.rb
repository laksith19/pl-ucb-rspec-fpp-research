# -*- encoding: utf-8 -*-

describe :array_pack_unicode, shared: true do
  it "encodes ASCII values as a Unicode codepoint" do
    expect([ [[0],   "\x00"],
      [[1],   "\x01"],
      [[8],   "\x08"],
      [[15],  "\x0f"],
      [[24],  "\x18"],
      [[31],  "\x1f"],
      [[127], "\x7f"],
      [[128], "\xc2\x80"],
      [[129], "\xc2\x81"],
      [[255], "\xc3\xbf"]
    ]).to be_computed_by(:pack, "U")
  end

  it "encodes UTF-8 BMP codepoints" do
    expect([ [[0x80],    "\xc2\x80"],
      [[0x7ff],   "\xdf\xbf"],
      [[0x800],   "\xe0\xa0\x80"],
      [[0xffff],  "\xef\xbf\xbf"]
    ]).to be_computed_by(:pack, "U")
  end

  it "constructs strings with valid encodings" do
    str = [0x85].pack("U*")
    expect(str).to eq("\xc2\x85")
    expect(str.valid_encoding?).to be_true
  end

  it "encodes values larger than UTF-8 max codepoints" do
    expect([
      [[0x00110000], [244, 144, 128, 128].pack('C*').force_encoding('utf-8')],
      [[0x04000000], [252, 132, 128, 128, 128, 128].pack('C*').force_encoding('utf-8')],
      [[0x7FFFFFFF], [253, 191, 191, 191, 191, 191].pack('C*').force_encoding('utf-8')]
    ]).to be_computed_by(:pack, "U")
  end

  it "encodes UTF-8 max codepoints" do
    expect([ [[0x10000],   "\xf0\x90\x80\x80"],
      [[0xfffff],   "\xf3\xbf\xbf\xbf"],
      [[0x100000],  "\xf4\x80\x80\x80"],
      [[0x10ffff],  "\xf4\x8f\xbf\xbf"]
    ]).to be_computed_by(:pack, "U")
  end

  it "encodes the number of array elements specified by the count modifier" do
    expect([ [[0x41, 0x42, 0x43, 0x44], "U2",  "\x41\x42"],
      [[0x41, 0x42, 0x43, 0x44], "U2U", "\x41\x42\x43"]
    ]).to be_computed_by(:pack)
  end

  it "encodes all remaining elements when passed the '*' modifier" do
    expect([0x41, 0x42, 0x43, 0x44].pack("U*")).to eq("\x41\x42\x43\x44")
  end

  it "calls #to_int to convert the pack argument to an Integer" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(5)
    expect([obj].pack("U")).to eq("\x05")
  end

  it "raises a TypeError if #to_int does not return an Integer" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return("5")
    expect { [obj].pack("U") }.to raise_error(TypeError)
  end

  it "ignores NULL bytes between directives" do
    expect([1, 2, 3].pack("U\x00U")).to eq("\x01\x02")
  end

  it "ignores spaces between directives" do
    expect([1, 2, 3].pack("U U")).to eq("\x01\x02")
  end

  it "raises a RangeError if passed a negative number" do
    expect { [-1].pack("U") }.to raise_error(RangeError)
  end

  it "raises a RangeError if passed a number larger than an unsigned 32-bit integer" do
    expect { [2**32].pack("U") }.to raise_error(RangeError)
  end

  it "sets the output string to UTF-8 encoding" do
    expect([ [[0x00].pack("U"),     Encoding::UTF_8],
      [[0x41].pack("U"),     Encoding::UTF_8],
      [[0x7F].pack("U"),     Encoding::UTF_8],
      [[0x80].pack("U"),     Encoding::UTF_8],
      [[0x10FFFF].pack("U"), Encoding::UTF_8]
    ]).to be_computed_by(:encoding)
  end
end
