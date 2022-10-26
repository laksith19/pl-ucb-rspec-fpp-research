# -*- encoding: binary -*-
require_relative '../../../spec_helper'
require_relative '../fixtures/classes'

describe "Array#pack" do
  it "ignores directives text from '#' to the first newline" do
    expect([1, 2, 3].pack("c#this is a comment\nc")).to eq("\x01\x02")
  end

  it "ignores directives text from '#' to the end if no newline is present" do
    expect([1, 2, 3].pack("c#this is a comment c")).to eq("\x01")
  end

  it "ignores comments at the start of the directives string" do
    expect([1, 2, 3].pack("#this is a comment\nc")).to eq("\x01")
  end

  it "ignores the entire directive string if it is a comment" do
    expect([1, 2, 3].pack("#this is a comment")).to eq("")
  end

  it "ignores multiple comments" do
    expect([1, 2, 3].pack("c#comment\nc#comment\nc#c")).to eq("\x01\x02\x03")
  end
end
