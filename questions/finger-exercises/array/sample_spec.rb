require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#sample" do
  it "samples evenly" do
    ArraySpecs.measure_sample_fairness(4, 1, 400)
    ArraySpecs.measure_sample_fairness(4, 2, 400)
    ArraySpecs.measure_sample_fairness(4, 3, 400)
    ArraySpecs.measure_sample_fairness(40, 3, 400)
    ArraySpecs.measure_sample_fairness(40, 4, 400)
    ArraySpecs.measure_sample_fairness(40, 8, 400)
    ArraySpecs.measure_sample_fairness(40, 16, 400)
    ArraySpecs.measure_sample_fairness_large_sample_size(100, 80, 4000)
  end

  it "returns nil for an empty Array" do
    expect([].sample).to be_nil
  end

  it "returns nil for an empty array when called without n and a Random is given" do
    expect([].sample(random: Random.new(42))).to be_nil
  end

  it "returns a single value when not passed a count" do
    expect([4].sample).to equal(4)
  end

  it "returns a single value when not passed a count and a Random is given" do
    expect([4].sample(random: Random.new(42))).to equal(4)
  end

  it "returns an empty Array when passed zero" do
    expect([4].sample(0)).to eq([])
  end

  it "returns an Array of elements when passed a count" do
    expect([1, 2, 3, 4].sample(3)).to be_an_instance_of(Array)
  end

  it "returns elements from the Array" do
    array = [1, 2, 3, 4]
    array.sample(3).all? { |x| expect(array).to include(x) }
  end

  it "returns at most the number of elements in the Array" do
    array = [1, 2, 3, 4]
    result = array.sample(20)
    expect(result.size).to eq(4)
  end

  it "does not return the same value if the Array has unique values" do
    array = [1, 2, 3, 4]
    result = array.sample(20)
    expect(result.sort).to eq(array)
  end

  it "may return the same value if the array is not unique" do
    expect([4, 4].sample(2)).to eq([4,4])
  end

  it "calls #to_int to convert the count when passed an Object" do
    expect([1, 2, 3, 4].sample(mock_int(2)).size).to eq(2)
  end

  it "raises ArgumentError when passed a negative count" do
    expect { [1, 2].sample(-1) }.to raise_error(ArgumentError)
  end

  it "does not return subclass instances with Array subclass" do
    expect(ArraySpecs::MyArray[1, 2, 3].sample(2)).to be_an_instance_of(Array)
  end

  describe "with options" do
    it "calls #rand on the Object passed by the :random key in the arguments Hash" do
      obj = double("array_sample_random")
      expect(obj).to receive(:rand).and_return(0.5)

      expect([1, 2].sample(random: obj)).to be_an_instance_of(Integer)
    end

    it "raises a NoMethodError if an object passed for the RNG does not define #rand" do
      obj = BasicObject.new

      expect { [1, 2].sample(random: obj) }.to raise_error(NoMethodError)
    end

    describe "when the object returned by #rand is an Integer" do
      it "uses the integer as index" do
        random = double("array_sample_random_ret")
        expect(random).to receive(:rand).and_return(0)

        expect([1, 2].sample(random: random)).to eq(1)

        random = double("array_sample_random_ret")
        expect(random).to receive(:rand).and_return(1)

        expect([1, 2].sample(random: random)).to eq(2)
      end

      it "raises a RangeError if the value is less than zero" do
        random = double("array_sample_random")
        expect(random).to receive(:rand).and_return(-1)

        expect { [1, 2].sample(random: random) }.to raise_error(RangeError)
      end

      it "raises a RangeError if the value is equal to the Array size" do
        random = double("array_sample_random")
        expect(random).to receive(:rand).and_return(2)

        expect { [1, 2].sample(random: random) }.to raise_error(RangeError)
      end
    end
  end

  describe "when the object returned by #rand is not an Integer but responds to #to_int" do
    it "calls #to_int on the Object" do
      value = double("array_sample_random_value")
      expect(value).to receive(:to_int).and_return(1)
      random = double("array_sample_random")
      expect(random).to receive(:rand).and_return(value)

      expect([1, 2].sample(random: random)).to eq(2)
    end

    it "raises a RangeError if the value is less than zero" do
      value = double("array_sample_random_value")
      expect(value).to receive(:to_int).and_return(-1)
      random = double("array_sample_random")
      expect(random).to receive(:rand).and_return(value)

      expect { [1, 2].sample(random: random) }.to raise_error(RangeError)
    end

    it "raises a RangeError if the value is equal to the Array size" do
      value = double("array_sample_random_value")
      expect(value).to receive(:to_int).and_return(2)
      random = double("array_sample_random")
      expect(random).to receive(:rand).and_return(value)

      expect { [1, 2].sample(random: random) }.to raise_error(RangeError)
    end
  end
end
