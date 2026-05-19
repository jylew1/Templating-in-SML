# What does the mustache.sml intend to do?
mustache.sml takes mustache template string as input, lexes it into tokens then parses those tokens into an AST

"fun parse (input : string) : Ast.node =
    let
        val charStream = Stream.fromList (String.explode input)
        val tokStream  = Stream.lazy (fn () => Lexer.lex charStream)
    in
        #1 (Parser.parse tokStream)
    end"

So, this is valuable because the AST tells you want the mustache output contain. 

# Before using the parser, you have to compile the parser
(Outside SML)
1. mustache.cmlex : the lexer spec, compiled with...
    cmlex mustache.cmlex
to generate "mustache.cmlex.sml"

2. mustache.cmyacc : the parser spec, compiled with...
    cmyacc mustache.cmyacc
to generate mustache.cmyacc.sml

# How to use your parser
(INSIDE SML)
- inside SML/NJ, use "load.sml"; within the mustache_parser/ directory
- the main entry point is Mustache.parse, which takes a string and returns an Ast.node

    Mustache.parse "Hello {{name}}!";
    (* val it = Template [Text "Hello ", Variable "name", Text "!"] : Ast.node *)

- the result is one of the following AST nodes:

    Text s               — literal text
    Variable s           — {{name}}
    UnescapedVariable s  — {{{name}}} or {{&name}}
    Section (s, nodes)   — {{#name}}...{{/name}}
    InvertedSection      — {{^name}}...{{/name}}
    Comment s            — {{! comment }}
    Partial s            — {{>name}}
    Template nodes       — the top-level result wrapping all nodes

# Running the tests

- call Tests.runAll (); after loading via load.sml
- each test prints PASS or FAIL followed by the test name
- a summary is printed at the end, e.g. 21 passed, 0 failed.
- note: two tests read .mustache files from disk using relative paths,
  so sml must be launched from inside mustache_parser/ or they will fail

# Automated spec tests

An automated test suite lives in `spec_tests/`. It reads test cases from a
JSON file and runs each one through the full parse-and-render pipeline,
comparing the output to the expected string.

Test cases are defined in `spec_tests/parser_tests.json`:

    {
      "name": "simple variable",
      "template": "Hello {{name}}!",
      "data": { "name": "World" },
      "expected": "Hello World!"
    }

To run all spec tests from the repo root:

    bash spec_tests/run.sh

Each test prints PASS or FAIL. Failures show the expected and actual output
side by side. A summary is printed at the end.

To add a new test, open `spec_tests/parser_tests.json` and append an entry
with `name`, `template`, `data`, and `expected` fields.
