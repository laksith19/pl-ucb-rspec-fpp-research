class Wallet
    attr_reader :cash
    attr_reader :error
    def initialize(amount)
      raise ArgumentError if amount < 0
      @cash = amount
    end
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
  