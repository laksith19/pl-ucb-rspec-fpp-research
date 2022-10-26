describe :enumeratorize, shared: true do
  it "returns an Enumerator if no block given" do
    expect([1,2].send(@method)).to be_an_instance_of(Enumerator)
  end
end
