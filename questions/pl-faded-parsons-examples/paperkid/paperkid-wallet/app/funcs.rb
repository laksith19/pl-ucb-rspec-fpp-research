# Wallet
#
# Maintains an amount of cash and an error
# string.
class Wallet

  # The amount of money in the wallet
  attr_reader :cash

  # An error string, nil if no errors
  attr_reader :error

  # Constructor
  #
  # @raise [ArgumentError] if amount < 0
  #
  # @param [amount] amount to set in the wallet
  def initialize(amount) #:notnew:
    raise ArgumentError if amount < 0
    @cash = amount
  end
  
  # Withdraw
  #
  # Sets Wallet#error string after invalid request.
  # It sets Wallet#error string to +nil+ after valid requests
  #
  # @param [amount] amount to withdraw
  #
  # @return [truthy] for valid withdraws
  def withdraw(amount)
    if amount > @cash or amount < 0 
      @error = 'invalid request'
      return nil
    end
    @cash -= amount
    @error = nil
    return amount
  end
end


  # idea - do we want to make multiple class files?
  # should we include Customer (new version) in this
  # file? 

class Customer
  attr_reader :error
  def initialize(wallet, rate)
    @wallet = wallet
    @rate = rate
    @error = ''
  end
  def attempt_delivery
    if @wallet.withdraw(@rate)
      deliver_paper()
    else
      @error = "Not enough money"
    end
  end
  def deliver_paper
    @error = ''
  end
end