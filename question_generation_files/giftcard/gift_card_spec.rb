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
  describe 'withdrawing' do
    before(:each) do
      @gift_card = GiftCard.new(20)
    end
    describe 'with sufficient balance' do
      before(:each) do
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
    end
    describe 'with insufficient balance' do
      before(:each) do
        @result = @gift_card.withdraw(30)
      end
      it 'returns falsy value' do
        expect(@result).to be_falsy
      end
      it 'does not change balance' do
        expect(@gift_card.balance).to eq(20)
      end
      it 'provides error message' do
        expect(@gift_card.error).to match(/cannot have negative balance/)
      end
    end
end
