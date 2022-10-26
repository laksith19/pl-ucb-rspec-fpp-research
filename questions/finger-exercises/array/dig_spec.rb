require_relative '../../spec_helper'

describe "Array#dig" do

  it "returns #at with one arg" do
    expect(['a'].dig(0)).to eq('a')
    expect(['a'].dig(1)).to be_nil
  end

  it "recurses array elements" do
    a = [ [ 1, [2, '3'] ] ]
    expect(a.dig(0, 0)).to eq(1)
    expect(a.dig(0, 1, 1)).to eq('3')
    expect(a.dig(0, -1, 0)).to eq(2)
  end

  it "returns the nested value specified if the sequence includes a key" do
    a = [42, { foo: :bar }]
    expect(a.dig(1, :foo)).to eq(:bar)
  end

  it "raises a TypeError for a non-numeric index" do
    expect {
      ['a'].dig(:first)
    }.to raise_error(TypeError)
  end

  it "raises a TypeError if any intermediate step does not respond to #dig" do
    a = [1, 2]
    expect {
      a.dig(0, 1)
    }.to raise_error(TypeError)
  end

  it "raises an ArgumentError if no arguments provided" do
    expect {
      [10].dig()
    }.to raise_error(ArgumentError)
  end

  it "returns nil if any intermediate step is nil" do
    a = [[1, [2, 3]]]
    expect(a.dig(1, 2, 3)).to eq(nil)
  end

  it "calls #dig on the result of #at with the remaining arguments" do
    h = [[nil, [nil, nil, 42]]]
    expect(h[0]).to receive(:dig).with(1, 2).and_return(42)
    expect(h.dig(0, 1, 2)).to eq(42)
  end

end
