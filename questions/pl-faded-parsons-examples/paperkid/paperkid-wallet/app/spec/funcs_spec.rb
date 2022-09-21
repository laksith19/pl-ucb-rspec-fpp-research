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

    # these tests still need to be checked.
    describe 'withdraw' do
        before(:each) do
            amount = 20
            amount_to_remove = 10
            wallet = Wallet.new(amount)
        end
        it 'should remove valid amount' do
            wallet.withdraw(amount_to_remove)
            expect( wallet.cash ).to eq(amount - amount_to_remove)
            expect( wallet.error ).to be_falsy
        end
        it 'should not withdraw too much' do
            wallet.withdraw(amount + 1)
            expect( wallet.error ).to be_truthy
            expect( wallet.cash ).to eq(amount)
            # not_to change? check valid rspec matchers...
        end
        it 'should not withdraw negative money' do
            wallet.withdraw(-1 * amount)
            expect( wallet.error ).to be_truthy
            expect( wallet.cash ).to eq(amount)
        end
    end
    # extra tests...
    describe 'getter setter' do
        it 'should have cash set by constructor' do
            amount = 20
            wallet = Wallet.new(amount)
            expect(wallet.cash).to eq(amount)
        end
        it 'should not have a cash setter method' do
            wallet = Wallet.new(10)
            expect{ wallet.cash = 100 }.to raise_error(NoMethodError)
        end
    end
end
