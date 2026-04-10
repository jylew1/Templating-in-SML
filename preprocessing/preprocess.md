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

- have yet to write a formal test file but have performed manual tests
Preprocess.returnArray (JSON.ARRAY [JSON.STRING "charlie", JSON.STRING "emma", JSON.STRING "henry"]);
(* expected: each item wrapped with isFirst and isLast, e.g. charlie has isFirst=true, henry has isLast=true *)

Preprocess.returnArray (JSON.STRING "hello");
(* expected: JSON.STRING "hello" returned unchanged as it is not an array *)
