require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array.[]" do
  it "returns a new array populated with the given elements" do
    obj = Object.new
    expect(Array.[](5, true, nil, 'a', "Ruby", obj)).to eq([5, true, nil, "a", "Ruby", obj])

    a = ArraySpecs::MyArray.[](5, true, nil, 'a', "Ruby", obj)
    expect(a).to be_an_instance_of(ArraySpecs::MyArray)
    expect(a.inspect).to eq([5, true, nil, "a", "Ruby", obj].inspect)
  end
end

describe "Array[]" do
  it "is a synonym for .[]" do
    obj = Object.new
    expect(Array[5, true, nil, 'a', "Ruby", obj]).to eq(Array.[](5, true, nil, "a", "Ruby", obj))

    a = ArraySpecs::MyArray[5, true, nil, 'a', "Ruby", obj]
    expect(a).to be_an_instance_of(ArraySpecs::MyArray)
    expect(a.inspect).to eq([5, true, nil, "a", "Ruby", obj].inspect)
  end
end
