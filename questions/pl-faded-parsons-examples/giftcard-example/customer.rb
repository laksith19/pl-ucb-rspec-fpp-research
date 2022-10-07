class Customer
  attr_accessor :name
  def initialize(name, gift_card=nil)
    @gift_card = gift_card
    @name = name
  end
  def pay(amount)
    if @gift_card.withdraw(amount)
      return true
    else
      self.send_email(@gift_card.error)
    end
  end
end
