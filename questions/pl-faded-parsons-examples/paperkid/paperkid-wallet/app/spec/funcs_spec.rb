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

describe 'Customer Tests' do
    describe 'constructor' do
        it 'should create a customer given a wallet and rate' do
            wallet_double = double("Wallet")
            rate = 5.25
            expect { Customer.new(wallet_double, rate) }.not_to raise_error
        end
    end
    describe 'paying up' do
        before(:each) do
            @wallet_double = double("Wallet")
            @rate = 5.25
            @customer = Customer.new(@wallet_double, @rate)
        end
        it 'should call attempt_delivery happy path' do
            # stub Wallet#withdraw successful for @rate
            expect(@wallet_double).to receive(:withdraw).with(@rate).and_return(true)
            #assert true path, which calls Customer#deliver_paper
            expect(@customer).to receive(:deliver_paper)
            #act
            @customer.attempt_delivery
        end
        it 'should call attempt_delivery sad path' do
            # stub Wallet#withdraw unsuccessful for @rate
            expect(@wallet_double).to receive(:withdraw).with(@rate).and_return(false)
            #act
            @customer.attempt_delivery
            #assert true path, which calls Customer#deliver_paper
            expect(@customer.error).to eq("Not enough money")
        end
    end
end
