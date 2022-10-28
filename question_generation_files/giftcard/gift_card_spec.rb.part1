## STATIC
describe GiftCard do
  ## FPP (panel should be properly "indented" relative to static text)
  it 'fails when crated with negative balance' do
    expect { GiftCard.new(-1) }.to raise_error(ArgumentError)
  end
  it 'succeeds when created with positive balance' do
    gift_card = GiftCard.new(20)
    expect(gift_card.balance).to eq(20)
  end
  ## STATIC
end
