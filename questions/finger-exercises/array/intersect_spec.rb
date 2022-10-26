require_relative '../../spec_helper'

describe 'Array#intersect?' do
  ruby_version_is '3.1' do # https://bugs.ruby-lang.org/issues/15198
    describe 'when at least one element in two Arrays is the same' do
      it 'returns true' do
        expect([1, 2].intersect?([2, 3])).to eq(true)
      end
    end

    describe 'when there are no elements in common between two Arrays' do
      it 'returns false' do
        expect([1, 2].intersect?([3, 4])).to eq(false)
      end
    end
  end
end
