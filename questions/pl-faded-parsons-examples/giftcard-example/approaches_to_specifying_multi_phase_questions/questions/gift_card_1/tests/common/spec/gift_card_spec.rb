# begin: pre-text0
describe GiftCard do
# end: pre-text0
# begin: code-lines0
  it 'fails with negative balance' do
    expect { GiftCard.new(-1) }.to raise_error(ArgumentError)
  end
  it 'succeeds with positive balance' do
    gift_card = GiftCard.new(20)
    expect(gift_card.balance).to eq(20)
  end
# end: code-lines0
# begin: post-text0
end
# end: post-text0

# begin: pre-text1
describe GiftCard do
    describe 'creating' do
      it 'fails with negative balance' do
        expect { GiftCard.new(-1) }.to raise_error(ArgumentError)
      end
      it 'succeeds with positive balance' do
        gift_card = GiftCard.new(20)
        expect(gift_card.balance).to eq(20)
      end
    end
    describe 'withdrawing with sufficient balance' do
# end: pre-text1
# begin: code-lines1
      it 'returns truthy value' do
        @gift_card = GiftCard.new(20)
      @result = @gift_card.withdraw(15)
      expect(@result).to be_truthy
    end
    it 'changes the balance' do
      @gift_card = GiftCard.new(20)
      @result = @gift_card.withdraw(15)
      expect(@gift_card.balance).to eq(5)
    end
    it 'does not result in error message' do
      @gift_card = GiftCard.new(20)
      @result = @gift_card.withdraw(15)
      expect(@gift_card.error).to be_empty
    end
# end: code-lines1
# begin: post-text1
  end
end
# end: post-text1

# begin: pre-text2
describe GiftCard do
  describe 'creating' do
    it 'fails with negative balance' do
      expect { GiftCard.new(-1) }.to raise_error(ArgumentError)
    end
    it 'succeeds with positive balance' do
      gift_card = GiftCard.new(20)
      expect(gift_card.balance).to eq(20)
    end
  end
  describe 'withdrawing with sufficient balance' do
# end: pre-text2
# begin: code-lines2
    before(:each) do            #given0
      @gift_card = GiftCard.new(20)
      @result = @gift_card.withdraw(15)
    end
    it 'returns truthy value' do
      expect(@result).to be_truthy
    end
    it 'changes the balance' do
      expect(@gift_card.balance).to eq(5)
    end
    it 'does not result in error message' do
      expect(@gift_card.error).to be_empty
    end
# end: code-lines2
# begin: post-text2
  end
end
# end: post-text2
