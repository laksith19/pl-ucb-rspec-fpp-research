describe GiftCard do # pre-text 0,1,2
  describe 'creating' do # pre-text 1,2
  it 'fails with negative balance' do # code-line 0 # pre-text 1+1,2+1
    expect { GiftCard.new(-1) }.to raise_error(ArgumentError) # code-line 0 # pre-text 1+1,2+1
  end # code-line 0 # pre-text 1+1,2+1
  it 'succeeds with positive balance' do # code-line 0 # pre-text 1+1,2+1
    gift_card = GiftCard.new(20) # code-line 0 # pre-text 1+1,2+1
    expect(gift_card.balance).to eq(20) # code-line 0 # pre-text 1+1,2+1
  end # code-line 0 # pre-text 1+1,2+1
  end # pre-text 1,2
  describe 'withdrawing with sufficient balance' do # pre-text 1,2
    before(:each) do #given0 # code-line 2
      @gift_card = GiftCard.new(20) # code-line 2
      @result = @gift_card.withdraw(15) # code-line 2
    end # code-line 2
    it 'returns truthy value' do # code-line 1,2
      @gift_card = GiftCard.new(20) # code-line 1
      @result = @gift_card.withdraw(15) # code-line 1
      expect(@result).to be_truthy # code-line 1,2
    end # code-line 1,2
    it 'changes the balance' do # code-line 1,2
      @gift_card = GiftCard.new(20) # code-line 1
      @result = @gift_card.withdraw(15) # code-line 1
      expect(@gift_card.balance).to eq(5) # code-line 1,2
    end # code-line 1,2
    it 'does not result in error message' do # code-line 1,2
      @gift_card = GiftCard.new(20) # code-line 1
      @result = @gift_card.withdraw(15) # code-line 1
      expect(@gift_card.error).to be_empty # code-line 1,2
    end # code-line 1,2
  end # post-text 1,2
end # post-text 0,1,2

