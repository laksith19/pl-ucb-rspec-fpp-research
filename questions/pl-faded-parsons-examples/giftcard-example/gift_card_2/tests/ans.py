it 'returns truthy value' do
  @gift_card = GiftCard.new(20)
  @result = @gift_card.?withdraw?(15)
  ?expect?(@result).to be_truthy
end
it 'changes the balance' do
  @gift_card = GiftCard.new(20)
  @result = @gift_card.withdraw(15)
  expect(@gift_card.balance).to ?eq?(5)
end
it 'does not result in error message' do
  @gift_card = GiftCard.new(20)
  @result = @gift_card.withdraw(15)
  expect(@gift_card.?error?).to be_empty
end
