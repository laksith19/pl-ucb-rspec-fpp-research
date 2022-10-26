require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#fetch" do
  it "returns the element at the passed index" do
    expect([1, 2, 3].fetch(1)).to eq(2)
    expect([nil].fetch(0)).to eq(nil)
  end

  it "counts negative indices backwards from end" do
    expect([1, 2, 3, 4].fetch(-1)).to eq(4)
  end

  it "raises an IndexError if there is no element at index" do
    expect { [1, 2, 3].fetch(3) }.to raise_error(IndexError)
    expect { [1, 2, 3].fetch(-4) }.to raise_error(IndexError)
    expect { [].fetch(0) }.to raise_error(IndexError)
  end

  it "returns default if there is no element at index if passed a default value" do
    expect([1, 2, 3].fetch(5, :not_found)).to eq(:not_found)
    expect([1, 2, 3].fetch(5, nil)).to eq(nil)
    expect([1, 2, 3].fetch(-4, :not_found)).to eq(:not_found)
    expect([nil].fetch(0, :not_found)).to eq(nil)
  end

  it "returns the value of block if there is no element at index if passed a block" do
    expect([1, 2, 3].fetch(9) { |i| i * i }).to eq(81)
    expect([1, 2, 3].fetch(-9) { |i| i * i }).to eq(81)
  end

  it "passes the original index argument object to the block, not the converted Integer" do
    o = double('5')
    def o.to_int(); 5; end

    expect([1, 2, 3].fetch(o) { |i| i }).to equal(o)
  end

  it "gives precedence to the default block over the default argument" do
    expect {
      @result = [1, 2, 3].fetch(9, :foo) { |i| i * i }
    }.to complain(/block supersedes default value argument/)
    expect(@result).to eq(81)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(2)
    expect(["a", "b", "c"].fetch(obj)).to eq("c")
  end

  it "raises a TypeError when the passed argument can't be coerced to Integer" do
    expect { [].fetch("cat") }.to raise_error(TypeError)
  end
end
