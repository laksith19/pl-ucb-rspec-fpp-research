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


  #todo: add rdocs
  