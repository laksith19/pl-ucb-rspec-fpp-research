require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'
require_relative 'shared/taint'

describe "Array#pack with format 'P'" do
  it_behaves_like :array_pack_basic_non_float, 'P'
  it_behaves_like :array_pack_taint, 'P'

  it "produces as many bytes as there are in a pointer" do
    expect(["hello"].pack("P").size).to eq([0].pack("J").size)
  end

  it "round-trips a string through pack and unpack" do
    expect(["hello"].pack("P").unpack("P5")).to eq(["hello"])
  end

  it "with nil gives a null pointer" do
    expect([nil].pack("P").unpack("J")).to eq([0])
  end
end

describe "Array#pack with format 'p'" do
  it_behaves_like :array_pack_basic_non_float, 'p'
  it_behaves_like :array_pack_taint, 'p'

  it "produces as many bytes as there are in a pointer" do
    expect(["hello"].pack("p").size).to eq([0].pack("J").size)
  end

  it "round-trips a string through pack and unpack" do
    expect(["hello"].pack("p").unpack("p")).to eq(["hello"])
  end

  it "with nil gives a null pointer" do
    expect([nil].pack("p").unpack("J")).to eq([0])
  end
end
