require_relative '../../spec_helper'

describe "Array#sum" do
  it "returns the sum of elements" do
    expect([1, 2, 3].sum).to eq(6)
  end

  it "applies a block to each element before adding if it's given" do
    expect([1, 2, 3].sum { |i| i * 10 }).to eq(60)
  end

  # https://bugs.ruby-lang.org/issues/12217
  # https://github.com/ruby/ruby/blob/master/doc/ChangeLog-2.4.0#L6208-L6214
  it "uses Kahan's compensated summation algorithm for precise sum of float numbers" do
    floats = [2.7800000000000002, 5.0, 2.5, 4.44, 3.89, 3.89, 4.44, 7.78, 5.0, 2.7800000000000002, 5.0, 2.5]
    naive_sum = floats.reduce { |sum, e| sum + e }
    expect(naive_sum).to eq(50.00000000000001)
    expect(floats.sum).to eq(50.0)
  end

  it "handles infinite values and NaN" do
    expect([1.0, Float::INFINITY].sum).to eq(Float::INFINITY)
    expect([1.0, -Float::INFINITY].sum).to eq(-Float::INFINITY)
    expect([1.0, Float::NAN].sum).to.nan?

    expect([Float::INFINITY, 1.0].sum).to eq(Float::INFINITY)
    expect([-Float::INFINITY, 1.0].sum).to eq(-Float::INFINITY)
    expect([Float::NAN, 1.0].sum).to.nan?

    expect([Float::NAN, Float::INFINITY].sum).to.nan?
    expect([Float::INFINITY, Float::NAN].sum).to.nan?

    expect([Float::INFINITY, -Float::INFINITY].sum).to.nan?
    expect([-Float::INFINITY, Float::INFINITY].sum).to.nan?

    expect([Float::INFINITY, Float::INFINITY].sum).to eq(Float::INFINITY)
    expect([-Float::INFINITY, -Float::INFINITY].sum).to eq(-Float::INFINITY)
    expect([Float::NAN, Float::NAN].sum).to.nan?
  end

  it "returns init value if array is empty" do
    expect([].sum(-1)).to eq(-1)
  end

  it "returns 0 if array is empty and init is omitted" do
    expect([].sum).to eq(0)
  end

  it "adds init value to the sum of elements" do
    expect([1, 2, 3].sum(10)).to eq(16)
  end

  it "can be used for non-numeric objects by providing init value" do
    expect(["a", "b", "c"].sum("")).to eq("abc")
  end

  it 'raises TypeError if any element are not numeric' do
    expect { ["a"].sum }.to raise_error(TypeError)
  end

  it 'raises TypeError if any element cannot be added to init value' do
    expect { [1].sum([]) }.to raise_error(TypeError)
  end

  it "calls + to sum the elements" do
    a = double("a")
    b = double("b")
    expect(a).to receive(:+).with(b).and_return(42)
    expect([b].sum(a)).to eq(42)
  end
end
