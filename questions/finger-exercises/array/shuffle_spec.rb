require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "Array#shuffle" do
  it "returns the same values, in a usually different order" do
    a = [1, 2, 3, 4]
    different = false
    10.times do
      s = a.shuffle
      expect(s.sort).to eq(a)
      different ||= (a != s)
    end
    expect(different).to be_true # Will fail once in a blue moon (4!^10)
  end

  it "is not destructive" do
    a = [1, 2, 3]
    10.times do
      a.shuffle
      expect(a).to eq([1, 2, 3])
    end
  end

  it "does not return subclass instances with Array subclass" do
    expect(ArraySpecs::MyArray[1, 2, 3].shuffle).to be_an_instance_of(Array)
  end

  it "calls #rand on the Object passed by the :random key in the arguments Hash" do
    obj = double("array_shuffle_random")
    expect(obj).to receive(:rand).at_least(1).times.and_return(0.5)

    result = [1, 2].shuffle(random: obj)
    expect(result.size).to eq(2)
    expect(result).to include(1, 2)
  end

  it "raises a NoMethodError if an object passed for the RNG does not define #rand" do
    obj = BasicObject.new

    expect { [1, 2].shuffle(random: obj) }.to raise_error(NoMethodError)
  end

  it "accepts a Float for the value returned by #rand" do
    random = double("array_shuffle_random")
    expect(random).to receive(:rand).at_least(1).times.and_return(0.3)

    expect([1, 2].shuffle(random: random)).to be_an_instance_of(Array)
  end

  it "calls #to_int on the Object returned by #rand" do
    value = double("array_shuffle_random_value")
    expect(value).to receive(:to_int).at_least(1).times.and_return(0)
    random = double("array_shuffle_random")
    expect(random).to receive(:rand).at_least(1).times.and_return(value)

    expect([1, 2].shuffle(random: random)).to be_an_instance_of(Array)
  end

  it "raises a RangeError if the value is less than zero" do
    value = double("array_shuffle_random_value")
    expect(value).to receive(:to_int).and_return(-1)
    random = double("array_shuffle_random")
    expect(random).to receive(:rand).and_return(value)

    expect { [1, 2].shuffle(random: random) }.to raise_error(RangeError)
  end

  it "raises a RangeError if the value is equal to one" do
    value = double("array_shuffle_random_value")
    expect(value).to receive(:to_int).at_least(1).times.and_return(1)
    random = double("array_shuffle_random")
    expect(random).to receive(:rand).at_least(1).times.and_return(value)

    expect { [1, 2].shuffle(random: random) }.to raise_error(RangeError)
  end
end

describe "Array#shuffle!" do
  it "returns the same values, in a usually different order" do
    a = [1, 2, 3, 4]
    original = a
    different = false
    10.times do
      a = a.shuffle!
      expect(a.sort).to eq([1, 2, 3, 4])
      different ||= (a != [1, 2, 3, 4])
    end
    expect(different).to be_true # Will fail once in a blue moon (4!^10)
    expect(a).to equal(original)
  end

  it "raises a FrozenError on a frozen array" do
    expect { ArraySpecs.frozen_array.shuffle! }.to raise_error(FrozenError)
    expect { ArraySpecs.empty_frozen_array.shuffle! }.to raise_error(FrozenError)
  end
end
