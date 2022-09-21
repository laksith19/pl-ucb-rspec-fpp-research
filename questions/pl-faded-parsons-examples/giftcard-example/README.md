# Intro to RSpec and TDD: Learning Goals

This assignment introduces unit test writing with RSpec.  Rather than
writing code from scratch, you will solve Faded Parsons Problems, in
which you rearrange scrambled lines of code, possibly filling  in
blanks in some of the lines, to create a valid solution to each
programming problem.

1) You will first learn the basic pattern that all unit tests follow: Arrange,
Act, Assert (AAA).  You will create a few simple _examples_ (unit tests) for a pure leaf
function that has no side effects and relies on no external objects or
functions to do its work.
These exercises will help you get familiar with the "AAA" pattern and how to code it in
RSpec.

2) You will then create a series of more complex examples
 in which additional actions are required as part of the
Arrange part of the AAA pattern.
In particular, you will create some tests that use _test doubles_ such as
mock objects or method stubs 
to isolate the code being tested from its dependencies.

3) You will learn how to group related tests together using 
`describe` blocks, which collect together a set of examples that
share common Arrange steps (and sometimes common Act steps) but have
different Assert steps.

## Learning Goals

When you finish this assignment, you should be able to:

* Explain how the Arrange-Act-Assert programming pattern 
forms the underlying structure of all unit tests.

* Explain the basic mechanisms involved in realizing the
Arrange-Act-Assert steps in unit tests: expectations,
mock objects (object doubles), method stubs (method doubles).

* Recognize which of these mechanisms are necessary in a particular
unit testing scenario.

* Write unit tests for Ruby and Rails code using the RSpec testing
framework's facilities that provide these mechanisms.

* Use `describe` blocks to group together related examples that share
Arrange and/or Act steps.

## Pre-work

(prior to this point, students should have done a bunch of finger
exercises on simple leaf function tests)

TBD: For the micropilot, they would review some existing material and take
a pre-test.  (Question - should the pretest be sequenced before or
after the finger exercises? Would be interesting to try both.)

# Background

Your app manages online gift cards for a soon-to-be-major e-tailer.
Customers can use the app to place orders using their card
balance. 

We have classes that model the GiftCard and the Customer.  First you
will write tests for the GiftCard class, to verify that:

* a GiftCard when first created has a non-negative cash balance
* a withdrawal when there is enough cash returns success, and changes
the card balance
* a withdrawal when there is not enough cash returns failure, provides
an error message explaining the failure, and does not change the card balance.

Once those tests are done, we will "seal off" the GiftCard class and move on to
Customer, which has a dependency on GiftCard.  In testing Customer, we
will rely only on the _specification_ of the (now well-tested)
GiftCard class-- the description
of its methods and their behaviors-- and not its _implementation_.
(This setup mimics a common scenario where you are testing your own
code that calls some code in a library you don't control,
so you need to be able to
test your code in isolation from the implementation of the library.)

The main thing we want to test for Customer is what happens when they
try to buy an item.

* If they have enough money on their gift card, the item is bought, and their card
balance goes down
* If not, the item is not bought, a helpful error message saves the
reason why, and the card balance doesn't change.

# Reference SUT and solution - will not be part of the student-visible scaffolding:

* [system under test](questions/giftcard-example/giftcard.rb)
* [reference test suite](questions/giftcard-example/giftcard_spec.rb)


# Part 1: testing the GiftCard class

# Part 2: testing the Customer class
