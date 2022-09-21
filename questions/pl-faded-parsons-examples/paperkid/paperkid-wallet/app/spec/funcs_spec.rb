require_relative '../funcs.rb'

# use expect{...} when testing for errors and expect(...) for values
# (easy to forget)

describe 'Wallet Tests' do
    describe 'constructor' do
        it 'should reject <0 money' do
            bad_amount = -100
            expect { Wallet.new(bad_amount) }.to raise_error(ArgumentError)
        end
    end

    describe 'withdraw' do
        before(:each) do
            @amount = 20
            @amount_to_remove = 10
            @wallet = Wallet.new(@amount)
        end
        it 'should remove valid amount' do
            @wallet.withdraw(@amount_to_remove)
            expect( @wallet.cash ).to eq(@amount - @amount_to_remove)
            expect( @wallet.error ).to be_falsy
        end
        it 'should not withdraw too much' do
            @wallet.withdraw(@amount + 1)
            expect( @wallet.error ).to be_truthy
            expect( @wallet.cash ).to eq(@amount)
        end
        it 'should not withdraw negative money' do
            @wallet.withdraw(-1 * @amount)
            expect( @wallet.error ).to be_truthy
            expect( @wallet.cash ).to eq(@amount)
        end
    end
end
