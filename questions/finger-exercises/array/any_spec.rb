require_relative '../../spec_helper'

describe "Array#any?" do
  describe 'with no block given (a default block of { |x| x } is implicit)' do
    it "is false if the array is empty" do
      empty_array = []
      expect(empty_array).not_to.any?
    end

    it "is false if the array is not empty, but all the members of the array are falsy" do
      falsy_array = [false, nil, false]
      expect(falsy_array).not_to.any?
    end

    it "is true if the array has any truthy members" do
      not_empty_array = ['anything', nil]
      expect(not_empty_array).to.any?
    end
  end

  describe 'with a block given' do
    it 'is false if the array is empty' do
      empty_array = []
      expect(empty_array.any? {|v| 1 == 1 }).to eq(false)
    end

    it 'is true if the block returns true for any member of the array' do
      array_with_members = [false, false, true, false]
      expect(array_with_members.any? {|v| v == true }).to eq(true)
    end

    it 'is false if the block returns false for all members of the array' do
      array_with_members = [false, false, true, false]
      expect(array_with_members.any? {|v| v == 42 }).to eq(false)
    end
  end
end
