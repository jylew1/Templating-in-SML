structure RendererTests =
struct
    val passed = ref 0
    val failed = ref 0

    fun assert name expected actual =
        if expected = actual then
            ( print ("PASS: " ^ name ^ "\n")
            ; passed := !passed + 1 )
        else
            ( print ("FAIL: " ^ name ^ "\n  expected: " ^ expected ^ "\n  actual:   " ^ actual ^ "\n")
            ; failed := !failed + 1 )

    fun runAll () =
        let
            val () = assert "plain text"
                "Hello World"
                (Render.render "Hello World" (JSON.OBJECT []))

            val () = assert "simple variable"
                "Hello Alice"
                (Render.render "Hello {{name}}" (JSON.OBJECT [("name", JSON.STRING "Alice")]))

            val () = assert "missing variable is empty"
                "Hello "
                (Render.render "Hello {{name}}" (JSON.OBJECT []))

            val () = assert "multiple variables"
                "Alice Smith"
                (Render.render "{{first}} {{last}}" (JSON.OBJECT [("first", JSON.STRING "Alice"), ("last", JSON.STRING "Smith")]))

            val () = assert "html escape"
                "&lt;b&gt;bold&lt;/b&gt;"
                (Render.render "{{html}}" (JSON.OBJECT [("html", JSON.STRING "<b>bold</b>")]))

            val () = assert "unescaped variable"
                "<b>bold</b>"
                (Render.render "{{{html}}}" (JSON.OBJECT [("html", JSON.STRING "<b>bold</b>")]))

            val () = assert "comment renders nothing"
                "Hello World"
                (Render.render "Hello{{! this is ignored}} World" (JSON.OBJECT []))

            val () = assert "section truthy renders"
                "yes"
                (Render.render "{{#show}}yes{{/show}}" (JSON.OBJECT [("show", JSON.BOOL true)]))

            val () = assert "section falsy hidden"
                ""
                (Render.render "{{#show}}yes{{/show}}" (JSON.OBJECT [("show", JSON.BOOL false)]))

            val () = assert "section null hidden"
                ""
                (Render.render "{{#show}}yes{{/show}}" (JSON.OBJECT [("show", JSON.NULL)]))

            val () = assert "inverted section falsy renders"
                "nothing here"
                (Render.render "{{^items}}nothing here{{/items}}" (JSON.OBJECT [("items", JSON.ARRAY [])]))

            val () = assert "inverted section truthy hidden"
                ""
                (Render.render "{{^items}}nothing here{{/items}}" (JSON.OBJECT [("items", JSON.BOOL true)]))

            val () = assert "section loops over array"
                "AliceBob"
                (Render.render "{{#names}}{{.}}{{/names}}"
                    (JSON.OBJECT [("names", JSON.ARRAY [JSON.STRING "Alice", JSON.STRING "Bob"])]))

            val () = assert "dotted name lookup"
                "Alice"
                (Render.render "{{person.name}}"
                    (JSON.OBJECT [("person", JSON.OBJECT [("name", JSON.STRING "Alice")])]))

        in
            print ("\n" ^ Int.toString (!passed) ^ " passed, " ^
                          Int.toString (!failed) ^ " failed.\n")
        end

end
