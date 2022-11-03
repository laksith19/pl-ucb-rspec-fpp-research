# A tip for putting code into pl-code elements

Try the following in either qustion.html or the yaml file:

```
<pl-code language="ruby">
<![CDATA[
  if something < other || thing > 0
    puts "<brackets are ok now>"
    #  this comment is ok despite having </pl-code>
    #  be careful to close the square braces correctly:
]]>
</pl-code>
```



# Starting PL with autograder support

The easiest way to setup a working environment across all platforms is using [Docker Compose](https://docs.docker.com/compose/). If you've used docker in the past you most likely need no further set-up. You can start PrairieLearn by running:
```
docker compose up
``` 

If you've not set up docker before or the above command is not found, follow the [install instructions](https://docs.docker.com/compose/install/) before starting the PrairieLearn instance. 

<details>
<summary>Advanced docker instructions</summary>
<p>
<p>
It's highly recommended to use Docker Compose to start PrairieLearn as it works on Windows(powershell, wsl & git-bash), MacOS and Linux.
If you prefer to not use Docker Compose, you can use these platform specific docker instructions. You'll still need to have [Docker](https://docs.docker.com/get-docker/) installed. 
 

### For MacOS and Linux:


```
docker run -it --rm \
    -p 3000:3000 \
    -v "/tmp/directory/for/autograder/jobqueue":"/jobs" \
    -e HOST_JOBS_DIR="/tmp/directory/for/autograder/jobqueue" \
    -v `pwd`:/course \
    -v /var/run/docker.sock:/var/run/docker.sock \
    prairielearn/prairielearn:latest
```


### For Windows in a WSL2 Enviornment:

```
docker run -it --rm \
    -p 3000:3000 \
    -v "/tmp/directory/for/autograder/jobqueue":"/jobs" \
    -e HOST_JOBS_DIR="/tmp/directory/for/autograder/jobqueue" \
    -v `pwd`:/course \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --add-host=host.docker.internal:172.17.0.1 \
    prairielearn/prairielearn:latest
```


Note: This only works in a WSL2 environment, as docker in powershell has it's quirks. You can find more information about it in the 	[PrairieLearn docs](https://prairielearn.readthedocs.io/en/latest/externalGrading/#windows-errors-and-quirks).
</details>


# Thoughts on gradient of test writing

## Testing a pure leaf function (single expectation per spec)

`expect(expr).to `_matcher_  (or `not_to` _matcher_):
* `eq`
* `be >`, `be <`, etc
* `be_truthy` (or falsy)

Strings: Exercise matchers for `match(/regex/)`, `start_with(string)` (or
`end_with`)

Collections: `expect(collection).to` :
*  `be_empty`
* `include(elt)`
* `match_array(['order','doesnt','matter'])`
* `have_key(key)` (for hashes)

## Testing a function that calls a helper

`allow(:object).to ` (or `expect(:object).to`):
* `receive(:method_call)`
* `receive(:method_call).and_return(expr)`

## Multiple specs that share a before-block

## Testing a side effect

`expect { operation }.to `:
* `change { expr }`
* `change { expr }.by(qty)`
* `change { expr }.from(val).to(val)`
* `raise_error(SomeError)`

## Doubles using instance_double (makes sure instance calls its private method the right way)


# Micropilot structure and thoughts

- Read/view lecture/notes
- pre-test (AF can come up with some of this)
- finger exercises (see below)
- exercise sequence (see below)
- post-test 

## Finger exercises

In Armando's ideal world, BEFORE doing the exercise sequence below,
there would be numerous "finger exercises" to practice writing very
short and focused specs for asserting return values, error raising,
etc.  Maybe some undergrads can be recruited to help with these.
Armando will reach out via CS169 GSIs to see if interest.

## Exercise sequence

Note: all development below is within the paperkid-wallet directory. It's getting too cumbersome to separate (and synchronize) the steps of the exercise sequence across the different paperkid directories. -mv 

(todo) Fix Wallet class so that it raises error only when constructor gets
negative value. Withdrawing too much should return falsy and capture the error somehow.

(done) Part 1:  develop [tests for Wallet (DONE - mv)](https://github.com/ace-lab/pl-ucb-rspec-fpp-research/blob/main/questions/pl-faded-parsons-examples/paperkid/paperkid-wallet/app/spec/funcs_spec.rb)

- test happy path of leaf function `withdraw`
- test sad path - error string gets set, and balance does not change 
   - 2 specs that can share a before-block
- test for raising error in constructor


```ruby
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
```

(done) Part 2: Wallet code is replaced with [rdoc-like description of Wallet](https://github.com/ace-lab/pl-ucb-rspec-fpp-research/blob/main/questions/pl-faded-parsons-examples/paperkid/paperkid-wallet/app/funcs.rb),
now we write [tests for Customer (done, scroll down)](https://github.com/ace-lab/pl-ucb-rspec-fpp-research/blob/main/questions/pl-faded-parsons-examples/paperkid/paperkid-wallet/app/spec/funcs_spec.rb)


attempt_delivery motivates the use of a method stub (to force a return value from
Wallet#withdraw, whose implementation is now invisible) and also checking whether
Customer#deliver_paper gets called or not.  ~~And you can have a separate spec to then
check that Wallet#cash has changed to the right value as a result.~~ (as we are stubbing
Wallet#withdraw, checking (and maintaining) the @cash on the test double essentially recreates Wallet.)
~~Or even something like
`expect { Customer.attempt_delivery(amt) }.to change { Customer.wallet.cash }.by(amount)`~~
New: `@error` string instance variable to test object state after delivery attempt.
New: instance method called for successful deliveries, which clears error string if set.
New: `amount` parameter for Customer#attempt_delivery replaced with `@rate` instance variable

```ruby
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
```

