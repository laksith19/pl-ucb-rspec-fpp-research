require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/join'

describe "Array#join" do
  it_behaves_like :array_join_with_string_separator,  :join
  it_behaves_like :array_join_with_default_separator, :join

  it "does not separate elements when the passed separator is nil" do
    expect([1, 2, 3].join(nil)).to eq('123')
  end

  it "calls #to_str to convert the separator to a String" do
    sep = double("separator")
    expect(sep).to receive(:to_str).and_return(", ")
    expect([1, 2].join(sep)).to eq("1, 2")
  end

  it "does not call #to_str on the separator if the array is empty" do
    sep = double("separator")
    expect(sep).not_to receive(:to_str)
    expect([].join(sep)).to eq("")
  end

  it "raises a TypeError if the separator cannot be coerced to a String by calling #to_str" do
    obj = double("not a string")
    expect { [1, 2].join(obj) }.to raise_error(TypeError)
  end

  it "raises a TypeError if passed false as the separator" do
    expect { [1, 2].join(false) }.to raise_error(TypeError)
  end
end

describe "Array#join with $," do
  before :each do
    @before_separator = $,
  end

  after :each do
    suppress_warning {$, = @before_separator}
  end

  it "separates elements with default separator when the passed separator is nil" do
    suppress_warning {
      $, = "_"
      expect([1, 2, 3].join(nil)).to eq('1_2_3')
    }
  end
end
