# What does the preprocess.sml intend to do?
Preprocess.sml takes the .JSON array and wraps each item with isFirst and isLast flags so that the template can format list items differenly based on their position 
--> acts as a libary of functions 
1. wrapItem
It takes a single .JSON item and wraps it in a new .JSON object with three fields: value (the original item), isFirst and isLast
2. flagList
This alls wrapItem on every item in the list and passes the correct bool for each position so it processes the whole list and not just one item respective to their positions. 
3. returnArray
if it is an array, it runs flagList
if it is not an array, then it returns it as a how it is 
    | returnArray v = v

# How to use preprocess.sml
1. go to the /preprocessing directory
2. go into SML/NJ
3. use "/usr/local/smlnj/smlnj-lib/Util/json.sml";
4. use "preprocess.sml";
5. Call in REPL: Preprocess.returnArray (JSON.ARRAY [JSON.STRING "a", JSON.STRING "b"]);

# Running the tests

The test file is `tests_preprocess.sml`. Run all tests with one command:

    bash preprocessing/run_tests.sh

Or manually from inside the `preprocessing/` directory:

    $ sml
    - use "/usr/local/smlnj/smlnj-lib/Util/json.sml";
    - use "preprocess.sml";
    - use "tests_preprocess.sml";

Each test prints PASS or FAIL. A summary is printed at the end, e.g. `13 passed, 0 failed`.

The tests cover three groups:

- **wrapItem** (4 tests) — wrapping strings and integers with isFirst/isLast combinations
- **flagList** (4 tests) — empty list, singleton, two items, three items
- **returnArray** (7 tests) — arrays of one/three/zero items; strings, ints, bools, and null passed through unchanged
