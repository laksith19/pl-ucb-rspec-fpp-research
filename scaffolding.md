# Pre-work

prior to this point, students should have done a bunch of finger
exercises.

For the micropilot, they would review some existing material and take
a pre-test.  (Question - should the pretest be sequenced before or
after the finger exercises? Would be interesting to try both.)

# Background

This is about customers with gift cards to the Tea or Nil coffee
shop.  They can use an online app to place orders using their card
balance. 

If the gift card has enough balance, the customer can buy a latte.

We have classes that model the GiftCard and the Customer.  First you
will write tests for the GiftCard class, to check that:

* a GiftCard when created has a non-negative cash balance
* a withdrawal when there is enough cash returns success, and changes
the wallet balance
* a withdrawal when there is not enough cash returns failure, provides
the reason for the failure, and does not change the card balance.

Once that's done, we will "seal off" the GiftCard class and move on to
Customer, which has a dependency on GiftCard.  In testing Customer, we
will rely only on the _specification_ of the GiftCard class (description
of its methods and their behaviors) and not its _implementation_.
(This models the scenario where you are testing code of your own that
relies on code in a library.  You often don't have easy access to the
source code of the library you rely on, but you need to be able to
test code that calls into that library.)

The main thing we want to test for Customer is what happens when they
try to buy an item.

* If they have enough money, the item is bought, and their card
balance goes down
* If not, the item is not bought, a helpful error message saves the
reason why, and the card balance doesn't change.

# Part 1: testing the GiftCard class


# Part 2: testing the Customer class
