require_relative '../../../spec_helper'

describe "Array#pack with empty format" do
  it "returns an empty String" do
    expect([1, 2, 3].pack("")).to eq("")
  end

  it "returns a String with US-ASCII encoding" do
    expect([1, 2, 3].pack("").encoding).to eq(Encoding::US_ASCII)
  end
end
