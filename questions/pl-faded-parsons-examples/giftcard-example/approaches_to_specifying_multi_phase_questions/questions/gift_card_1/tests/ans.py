{"pre": "describe GiftCard do\n", "lines": "it 'fails with negative balance' do\n  expect { GiftCard.new(-1) }.to raise_error(?ArgumentError?)\nend\nit 'succeeds with positive balance' do\n  gift_card = GiftCard.new(20)\n  ?expect?(gift_card.balance).to ?eq?(20)\nend\n", "post": "end\n"}

