require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#at" do
  it "returns the (n+1)'th element for the passed index n" do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.at(0)).to eq(1)
    expect(a.at(1)).to eq(2)
    expect(a.at(5)).to eq(6)
  end

  it "returns nil if the given index is greater than or equal to the array's length" do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.at(6)).to eq(nil)
    expect(a.at(7)).to eq(nil)
  end

  it "returns the (-n)'th element from the last, for the given negative index n" do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.at(-1)).to eq(6)
    expect(a.at(-2)).to eq(5)
    expect(a.at(-6)).to eq(1)
  end

  it "returns nil if the given index is less than -len, where len is length of the array"  do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.at(-7)).to eq(nil)
    expect(a.at(-8)).to eq(nil)
  end

  it "does not extend the array unless the given index is out of range" do
    a = [1, 2, 3, 4, 5, 6]
    expect(a.length).to eq(6)
    a.at(100)
    expect(a.length).to eq(6)
    a.at(-100)
    expect(a.length).to eq(6)
  end

  it "tries to convert the passed argument to an Integer using #to_int" do
    a = ["a", "b", "c"]
    expect(a.at(0.5)).to eq("a")

    obj = double('to_int')
    expect(obj).to receive(:to_int).and_return(2)
    expect(a.at(obj)).to eq("c")
  end

  it "raises a TypeError when the passed argument can't be coerced to Integer" do
    expect { [].at("cat") }.to raise_error(TypeError)
  end

  it "raises an ArgumentError when 2 or more arguments are passed" do
    expect { [:a, :b].at(0,1) }.to raise_error(ArgumentError)
  end
end
