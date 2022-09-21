# Instructor info:

This nominally 2-part assigmnet starts by developing a handful of unit
tests for pure leaf functions (constructor & public method of a very
simple GiftCard class), then proceeds to introduce test doubles to
develop unit tests for a Customer class that depends on the GiftCard
class to make a purchase.

Each of the 2 main parts is to be presented to the student in _phases_
(or stages; we need a good word for this).  In stage N, they develop a
very specific unit test (or maybe 2, if they're simple) in a
vertically-laid-out FPP screen layout.  In stage
N+1, the work they have completed in stage N becomes part of the
static code displayed on the screen, and they develop new code in a
vertically-laid-out FPP panel that is correctly inlined/interleaved
with that static code.

## Reference SUT and solution - will not be part of the student-visible scaffolding:

* [system under test](questions/giftcard-example/gift_card.rb)
* [reference test suite](questions/giftcard-example/gift_card_spec.rb)

I'm using names like `gift_card_spec.1.rb`, `gift_card_spec.2.rb`, etc
to show what i hope the UX looks like in each phase.  In those files,
I separate into "regions" the parts that should be static text
displayed to the student vs the part that should be the FPP panel.
The end-of-line comment `## SC` means scaffolding (starter code, ie
this line is given in its correct place in the FPP panel).

# STUDENT-FACING INSTRUCTIONS START HERE

## Intro to RSpec and TDD: Learning Goals

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

TBD: For the micropilot, they would review some existing material and take
a pre-test.  (Question - should the pretest be sequenced before or
after the finger exercises? Would be interesting to try both.)

## Background

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


# Part 1: testing the GiftCard class

# Part 2: testing the Customer class
