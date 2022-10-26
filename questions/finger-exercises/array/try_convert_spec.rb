require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array.try_convert" do
  it "returns the argument if it's an Array" do
    x = Array.new
    expect(Array.try_convert(x)).to equal(x)
  end

  it "returns the argument if it's a kind of Array" do
    x = ArraySpecs::MyArray[]
    expect(Array.try_convert(x)).to equal(x)
  end

  it "returns nil when the argument does not respond to #to_ary" do
    expect(Array.try_convert(Object.new)).to be_nil
  end

  it "sends #to_ary to the argument and returns the result if it's nil" do
    obj = double("to_ary")
    expect(obj).to receive(:to_ary).and_return(nil)
    expect(Array.try_convert(obj)).to be_nil
  end

  it "sends #to_ary to the argument and returns the result if it's an Array" do
    x = Array.new
    obj = double("to_ary")
    expect(obj).to receive(:to_ary).and_return(x)
    expect(Array.try_convert(obj)).to equal(x)
  end

  it "sends #to_ary to the argument and returns the result if it's a kind of Array" do
    x = ArraySpecs::MyArray[]
    obj = double("to_ary")
    expect(obj).to receive(:to_ary).and_return(x)
    expect(Array.try_convert(obj)).to equal(x)
  end

  it "sends #to_ary to the argument and raises TypeError if it's not a kind of Array" do
    obj = double("to_ary")
    expect(obj).to receive(:to_ary).and_return(Object.new)
    expect { Array.try_convert obj }.to raise_error(TypeError)
  end

  it "does not rescue exceptions raised by #to_ary" do
    obj = double("to_ary")
    expect(obj).to receive(:to_ary).and_raise(RuntimeError)
    expect { Array.try_convert obj }.to raise_error(RuntimeError)
  end
end
