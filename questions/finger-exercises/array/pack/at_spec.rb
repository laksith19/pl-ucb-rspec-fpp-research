# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'
require_relative 'shared/basic'

describe "Array#pack with format '@'" do
  it_behaves_like :array_pack_basic, '@'
  it_behaves_like :array_pack_basic_non_float, '@'
  it_behaves_like :array_pack_no_platform, '@'

  it "moves the insertion point to the index specified by the count modifier" do
    expect([1, 2, 3, 4, 5].pack("C4@2C")).to eq("\x01\x02\x05")
  end

  it "does not consume any elements" do
    expect([1, 2, 3].pack("C@3C")).to eq("\x01\x00\x00\x02")
  end

  it "extends the string with NULL bytes if the string size is less than the count" do
    expect([1, 2, 3].pack("@3C*")).to eq("\x00\x00\x00\x01\x02\x03")
  end

  it "truncates the string if the string size is greater than the count" do
    expect([1, 2, 3].pack("Cx5@2C")).to eq("\x01\x00\x02")
  end

  it "implicitly has a count of one when no count modifier is passed" do
    expect([1, 2, 3].pack("C*@")).to eq("\x01")
  end
end
