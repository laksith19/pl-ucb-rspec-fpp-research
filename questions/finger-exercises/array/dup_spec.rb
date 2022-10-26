require_relative '../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/clone'

describe "Array#dup" do
  it_behaves_like :array_clone, :dup # FIX: no, clone and dup are not alike

  it "does not copy frozen status from the original" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    a.freeze
    aa = a.dup
    bb = b.dup

    expect(aa.frozen?).to be_false
    expect(bb.frozen?).to be_false
  end

  it "does not copy singleton methods" do
    a = [1, 2, 3, 4]
    b = [1, 2, 3, 4]
    def a.a_singleton_method; end
    aa = a.dup
    bb = b.dup

    expect(a.respond_to?(:a_singleton_method)).to be_true
    expect(b.respond_to?(:a_singleton_method)).to be_false
    expect(aa.respond_to?(:a_singleton_method)).to be_false
    expect(bb.respond_to?(:a_singleton_method)).to be_false
  end
end
