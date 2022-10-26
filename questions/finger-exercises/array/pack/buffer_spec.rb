# encoding: binary

require_relative '../../../spec_helper'

describe "Array#pack with :buffer option" do
  it "returns specified buffer" do
    n = [ 65, 66, 67 ]
    buffer = " "*3
    result = n.pack("ccc", buffer: buffer)      #=> "ABC"
    expect(result).to equal(buffer)
  end

  it "adds result at the end of buffer content" do
    n = [ 65, 66, 67 ] # result without buffer is "ABC"

    buffer = ""
    expect(n.pack("ccc", buffer: buffer)).to eq("ABC")

    buffer = "123"
    expect(n.pack("ccc", buffer: buffer)).to eq("123ABC")

    buffer = "12345"
    expect(n.pack("ccc", buffer: buffer)).to eq("12345ABC")
  end

  it "raises TypeError exception if buffer is not String" do
    expect { [65].pack("ccc", buffer: []) }.to raise_error(
      TypeError, "buffer must be String, not Array")
  end

  context "offset (@) is specified" do
    it 'keeps buffer content if it is longer than offset' do
      n = [ 65, 66, 67 ]
      buffer = "123456"
      expect(n.pack("@3ccc", buffer: buffer)).to eq("123ABC")
    end

    it "fills the gap with \\0 if buffer content is shorter than offset" do
      n = [ 65, 66, 67 ]
      buffer = "123"
      expect(n.pack("@6ccc", buffer: buffer)).to eq("123\0\0\0ABC")
    end

    it 'does not keep buffer content if it is longer than offset + result' do
      n = [ 65, 66, 67 ]
      buffer = "1234567890"
      expect(n.pack("@3ccc", buffer: buffer)).to eq("123ABC")
    end
  end
end
