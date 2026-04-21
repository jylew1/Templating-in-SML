# What does renderer.sml intend to do?
renderer.sml takes a parsed Mustache AST and a JSON value (the context) and produces a rendered string output.

The main entry point is Render.render, which takes a template string and JSON data and returns the final rendered string.

# Functions

1. renderNote
Takes a JSON context and a single AST node and returns a string. Handles all node types:
- Text s — returns the literal text as-is
- Comment _ — returns empty string
- Variable name — looks up name in context, converts to string, HTML escapes it
- UnescapedVariable name — same as Variable but skips HTML escaping
- Section (name, nodes) — renders inner nodes if value is truthy; loops over each item if value is a JSON array
- InvertedSection (name, nodes) — renders inner nodes only if value is falsy
- Template nodes — renders all nodes and joins the results into one string
- Partial _ - not yet implemented, returns empty string
- DelimiterChange _ — not supported, returns empty string

2. resolve
Walks a dot-separated path (e.g. "person.name") through the JSON context to find a value. "." refers to the current context itself.

3. isTruth
Returns false for JSON.NULL, JSON.BOOL false, and empty JSON.ARRAY. Everything else is truthy.

4. jsonToString
Converts a JSON value to a string. Objects and arrays return empty string.

5. htmlEscape
Escapes &, <, >, ", ' to their HTML entities to prevent XSS.

# How to use renderer.sml

1. go to the /renderer directory
2. go into SML/NJ
3. use "loadrender.sml";

loadrender.sml does the following in order:
- loads the JSON library
- loads the cmlib lexer and parser engine
- loads the mustache parser (ast.sml, mustache.sml and the generated cmlex/cmyacc files)
- loads preprocess.sml
- loads renderer.sml
- loads and runs tests_renderer.sml — prints PASS/FAIL for each test
- reads example.mustache and data.json, renders them together and prints the final output

# Running the tests

- tests run automatically when you use "loadrender.sml";
- each test prints PASS or FAIL followed by the test name
- a summary is printed at the end, e.g. 14 passed, 0 failed.
- sml must be launched from inside renderer/ so relative paths work

# Output

after the tests, the rendered output is printed using example.mustache as the template and data.json as the data.
data.json contains two people — Alice (Computer Science) and Bob (Mathematics) — each with name, email, degree, isComputerScience flag and a skills list.
the output is a rendered class profile for each person, using sections and inverted sections to switch between the CS and non-CS templates.
