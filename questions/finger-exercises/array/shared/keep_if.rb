require_relative '../../enumerable/shared/enumeratorized'

describe :keep_if, shared: true do
  it "deletes elements for which the block returns a false value" do
    array = [1, 2, 3, 4, 5]
    expect(array.send(@method) {|item| item > 3 }).to equal(array)
    expect(array).to eq([4, 5])
  end

  it "returns an enumerator if no block is given" do
    expect([1, 2, 3].send(@method)).to be_an_instance_of(Enumerator)
  end

  it "updates the receiver after all blocks" do
    a = [1, 2, 3]
    a.send(@method) do |e|
      expect(a.length).to eq(3)
      false
    end
    expect(a.length).to eq(0)
  end

  before :all do
    @object = [1,2,3]
  end
  it_should_behave_like :enumeratorized_with_origin_size

  describe "on frozen objects" do
    before :each do
      @origin = [true, false]
      @frozen = @origin.dup.freeze
    end

    it "returns an Enumerator if no block is given" do
      expect(@frozen.send(@method)).to be_an_instance_of(Enumerator)
    end

    describe "with truthy block" do
      it "keeps elements after any exception" do
        expect { @frozen.send(@method) { true } }.to raise_error(Exception)
        expect(@frozen).to eq(@origin)
      end

      it "raises a FrozenError" do
        expect { @frozen.send(@method) { true } }.to raise_error(FrozenError)
      end
    end

    describe "with falsy block" do
      it "keeps elements after any exception" do
        expect { @frozen.send(@method) { false } }.to raise_error(Exception)
        expect(@frozen).to eq(@origin)
      end

      it "raises a FrozenError" do
        expect { @frozen.send(@method) { false } }.to raise_error(FrozenError)
      end
    end
  end
end
