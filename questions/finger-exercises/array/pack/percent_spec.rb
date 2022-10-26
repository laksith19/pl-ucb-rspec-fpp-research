require_relative '../../../spec_helper'

describe "Array#pack with format '%'" do
  it "raises an Argument Error" do
    expect { [1].pack("%") }.to raise_error(ArgumentError)
  end
end
