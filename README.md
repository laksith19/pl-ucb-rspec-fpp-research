This is a copy of https://github.com/ace-lab/pl-ucb-csxxx used to develop FPP questions for software testing with rspec. 

# Starting PL with autograder support

```
export HOST_JOBS_DIR=/tmp/directory/for/autograder/jobqueue
sudo docker run -it --rm \
    -p 3000:3000 \
    -v "$HOST_JOBS_DIR":"/jobs" \
    -v `pwd`:/course \
    -v /var/run/docker.sock:/var/run/docker.sock \
    prairielearn/prairielearn:latest
```
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

