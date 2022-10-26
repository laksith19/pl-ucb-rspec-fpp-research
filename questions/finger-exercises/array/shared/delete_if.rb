describe :delete_if, shared: true do
  before :each do
    @object = [1,2,3]
  end

  it "updates the receiver after all blocks" do
    @object.send(@method) do |e|
      expect(@object.length).to eq(3)
      true
    end
    expect(@object.length).to eq(0)
  end
end
