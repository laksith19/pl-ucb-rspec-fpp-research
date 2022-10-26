require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/clone'

describe "Array#clone" do
  it_behaves_like :array_clone, :clone

  it "copies frozen status from the original" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    a.freeze
    aa = a.clone
    bb = b.clone

    expect(aa).to.frozen?
    expect(bb).not_to.frozen?
  end

  it "copies singleton methods" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    def a.a_singleton_method; end
    aa = a.clone
    bb = b.clone

    expect(a.respond_to?(:a_singleton_method)).to be_true
    expect(b.respond_to?(:a_singleton_method)).to be_false
    expect(aa.respond_to?(:a_singleton_method)).to be_true
    expect(bb.respond_to?(:a_singleton_method)).to be_false
  end
end
