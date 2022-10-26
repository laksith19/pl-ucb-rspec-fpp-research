require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#to_h" do
  it "converts empty array to empty hash" do
    expect([].to_h).to eq({})
  end

  it "converts [key, value] pairs to a hash" do
    hash = [[:a, 1], [:b, 2]].to_h
    expect(hash).to eq({ a: 1, b: 2 })
  end

  it "uses the last value of a duplicated key" do
    hash = [[:a, 1], [:b, 2], [:a, 3]].to_h
    expect(hash).to eq({ a: 3, b: 2 })
  end

  it "calls #to_ary on contents" do
    pair = double('to_ary')
    expect(pair).to receive(:to_ary).and_return([:b, 2])
    hash = [[:a, 1], pair].to_h
    expect(hash).to eq({ a: 1, b: 2 })
  end

  it "raises TypeError if an element is not an array" do
    expect { [:x].to_h }.to raise_error(TypeError)
  end

  it "raises ArgumentError if an element is not a [key, value] pair" do
    expect { [[:x]].to_h }.to raise_error(ArgumentError)
  end

  it "does not accept arguments" do
    expect { [].to_h(:a, :b) }.to raise_error(ArgumentError)
  end

  it "produces a hash that returns nil for a missing element" do
    expect([[:a, 1], [:b, 2]].to_h[:c]).to be_nil
  end

  context "with block" do
    it "converts [key, value] pairs returned by the block to a Hash" do
      expect([:a, :b].to_h { |k| [k, k.to_s] }).to eq({ a: 'a', b: 'b' })
    end

    it "raises ArgumentError if block returns longer or shorter array" do
      expect do
        [:a, :b].to_h { |k| [k, k.to_s, 1] }
      end.to raise_error(ArgumentError, /wrong array length at 0/)

      expect do
        [:a, :b].to_h { |k| [k] }
      end.to raise_error(ArgumentError, /wrong array length at 0/)
    end

    it "raises TypeError if block returns something other than Array" do
      expect do
        [:a, :b].to_h { |k| "not-array" }
      end.to raise_error(TypeError, /wrong element type String at 0/)
    end

    it "coerces returned pair to Array with #to_ary" do
      x = double('x')
      allow(x).to receive(:to_ary).and_return([:b, 'b'])

      expect([:a].to_h { |k| x }).to eq({ :b => 'b' })
    end

    it "does not coerce returned pair to Array with #to_a" do
      x = double('x')
      allow(x).to receive(:to_a).and_return([:b, 'b'])

      expect do
        [:a].to_h { |k| x }
      end.to raise_error(TypeError, /wrong element type MockObject at 0/)
    end
  end
end
