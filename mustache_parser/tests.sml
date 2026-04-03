structure Tests =
struct
    open Ast

    (* Simple test runner *)
    val passed = ref 0
    val failed = ref 0

    fun assert name expected actual =
        if expected = actual then
            ( print ("PASS: " ^ name ^ "\n")
            ; passed := !passed + 1 )
        else
            ( print ("FAIL: " ^ name ^ "\n")
            ; failed := !failed + 1 )

    fun runAll () =
        let
            (* ---- Text only ---- *)
            val () = assert "plain text"
                (Template [Text "Hello World"])
                (Mustache.parse "Hello World")

            val () = assert "implict iterator"
                (Template [Variable "."])
                (Mustache.parse "{{.}}")

            val () = assert "empty string"
                (Template [])
                (Mustache.parse "")

            (* ---- Variables ---- *)
            val () = assert "simple variable"
                (Template [Variable "name"])
                (Mustache.parse "{{name}}")

            val () = assert "dotted name"
                (Template [Variable "person.name"])
                (Mustache.parse "{{person.name}}")

            val () = assert "standalone tags"
                (Template [Section ("name", [Text "  World\n"])])
                (Mustache.parse "{{#name}}\n  World\n{{/name}}")
           
            val () = assert "variable with surrounding text"
                (Template [Text "Hello ", Variable "name", Text "!"])
                (Mustache.parse "Hello {{name}}!")

            val () = assert "multiple variables"
                (Template [Variable "first", Text " ", Variable "last"])
                (Mustache.parse "{{first}} {{last}}")

            (* ---- Unescaped variables ---- *)
            val () = assert "triple brace unescaped"
                (Template [UnescapedVariable "html"])
                (Mustache.parse "{{{html}}}")

            val () = assert "ampersand unescaped"
                (Template [UnescapedVariable "html"])
                (Mustache.parse "{{&html}}")

            (* ---- Sections ---- *)
            val () = assert "empty section"
                (Template [Section ("items", [])])
                (Mustache.parse "{{#items}}{{/items}}")

            val () = assert "section with text"
                (Template [Section ("items", [Text "hello"])])
                (Mustache.parse "{{#items}}hello{{/items}}")

            val () = assert "section with variable"
                (Template [Section ("items", [Variable "name"])])
                (Mustache.parse "{{#items}}{{name}}{{/items}}")

            val () = assert "nested sections"
                (Template [Section ("a", [Section ("b", [Variable "x"])])])
                (Mustache.parse "{{#a}}{{#b}}{{x}}{{/b}}{{/a}}")

            (* ---- Inverted sections ---- *)
            val () = assert "inverted section"
                (Template [InvertedSection ("items", [Text "none"])])
                (Mustache.parse "{{^items}}none{{/items}}")

            (* ---- Comments ---- *)
            val () = assert "comment ignored in output"
                (Template [Comment "this is a comment"])
                (Mustache.parse "{{!this is a comment}}")

            val () = assert "comment between text"
                (Template [Text "Hello ", Comment "ignore me", Text " World"])
                (Mustache.parse "Hello {{!ignore me}} World")

            (* ---- Partials ---- *)
            val () = assert "partial"
                (Template [Partial "header"])
                (Mustache.parse "{{>header}}")

            (* ---- Mixed ---- *)
            val () = assert "mixed content"
                (Template [Text "Dear ", Variable "name", Text ", you have ", Variable "count", Text " messages."])
                (Mustache.parse "Dear {{name}}, you have {{count}} messages.")

            (* ---- Real world templates ---- *)
            val () =
                let
                    val template = TextIO.inputAll (TextIO.openIn "../Learning and Code/Code/example.mustache")
                    val result = Mustache.parse template
                in
                    case result of
                        Template _ => ( print "PASS: example.mustache parses successfully\n"
                                      ; passed := !passed + 1 )
                      | _          => ( print "FAIL: example.mustache did not return a Template\n"
                                      ; failed := !failed + 1 )
                end

            val () =
                let
                    val template = TextIO.inputAll (TextIO.openIn "templates/model.mustache")
                    val result = Mustache.parse template
                in
                    case result of
                        Template _ => ( print "PASS: model.mustache parses successfully\n"
                                      ; passed := !passed + 1 )
                      | _          => ( print "FAIL: model.mustache did not return a Template\n"
                                      ; failed := !failed + 1 )
                end

            val () =
                let
                    val template = TextIO.inputAll (TextIO.openIn "templates/README.mustache")
                    val result = Mustache.parse template
                in
                    case result of
                        Template _ => ( print "PASS: README.mustache parses successfully\n"
                                      ; passed := !passed + 1 )
                      | _          => ( print "FAIL: README.mustache did not return a Template\n"
                                      ; failed := !failed + 1 )
                end

        in
            print ("\n" ^ Int.toString (!passed) ^ " passed, " ^
                          Int.toString (!failed) ^ " failed.\n")
        end
    
end
