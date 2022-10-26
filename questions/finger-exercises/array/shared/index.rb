describe :array_index, shared: true do
  it "returns the index of the first element == to object" do
    x = double('3')
    def x.==(obj) 3 == obj; end

    expect([2, x, 3, 1, 3, 1].send(@method, 3)).to eq(1)
    expect([2, 3.0, 3, x, 1, 3, 1].send(@method, x)).to eq(1)
  end

  it "returns 0 if first element == to object" do
    expect([2, 1, 3, 2, 5].send(@method, 2)).to eq(0)
  end

  it "returns size-1 if only last element == to object" do
    expect([2, 1, 3, 1, 5].send(@method, 5)).to eq(4)
  end

  it "returns nil if no element == to object" do
    expect([2, 1, 1, 1, 1].send(@method, 3)).to eq(nil)
  end

  it "accepts a block instead of an argument" do
    expect([4, 2, 1, 5, 1, 3].send(@method) {|x| x < 2}).to eq(2)
  end

  it "ignores the block if there is an argument" do
    expect {
      expect([4, 2, 1, 5, 1, 3].send(@method, 5) {|x| x < 2}).to eq(3)
    }.to complain(/given block not used/)
  end

  describe "given no argument and no block" do
    it "produces an Enumerator" do
      expect([].send(@method)).to be_an_instance_of(Enumerator)
    end
  end
end
