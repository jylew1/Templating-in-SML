structure Mustache =
struct
    open Ast

    (* Minimal lazy stream, since cmlib stream.sml couldn't be loaded *)
    structure Stream =
    struct
        datatype 'a front
            = Nil
            | Cons of 'a * 'a stream
        and 'a stream = Stream of unit -> 'a front

        fun front (Stream f) = f ()
        fun lazy f = Stream f
        fun fromList []      = lazy (fn () => Nil)
          | fromList (x::xs) = lazy (fn () => Cons (x, fromList xs))
    end

    (* Streamable wrapping our Stream *)
    structure StreamStreamable : STREAMABLE =
    struct
        type 'a t = 'a Stream.stream
        datatype front = datatype Stream.front
        val front = Stream.front
    end

    (* Terminal type defined once, shared by both Lexer and Parser Arg structs *)
    datatype terminal
        = SECTION       of string
        | CLOSE_SECTION of string
        | INVERTED      of string
        | PARTIAL       of string
        | COMMENT       of string
        | OPEN_TAG      of string
        | OPEN_UNESC    of string
        | UNESC_AMP     of string
        | TEXT          of string
        | LBRACE
        | EOF

    (* Drop characters from the front while predicate holds *)
    fun dropLeft p []      = []
      | dropLeft p (x::xs) = if p x then dropLeft p xs else x :: xs

    (* Drop characters from the back while predicate holds *)
    fun dropRight p xs = List.rev (dropLeft p (List.rev xs))

    (* Extract name from matched tag e.g. {{#items}} -> "items"*)
    fun extractName prefixLen suffixLen (match : char list) =
        let
            val chars = List.drop (match, prefixLen)
            val chars = List.rev (List.drop (List.rev chars, suffixLen))
            fun isSpace c = c = #" " orelse c = #"\t"
            val chars = dropLeft  isSpace chars
            val chars = dropRight isSpace chars
        in
            String.implode chars
        end

    structure Lexer =
        MustacheLexFun
        (structure Streamable = StreamStreamable
         structure Arg =
            struct
                type symbol = char
                val ord = Char.ord

                (* Replicate the shared terminal datatype *)
                datatype terminal = datatype terminal

                type t = terminal Stream.front

                type self = { lex : char Stream.stream -> t }
                type info = { match : char list,
                              follow : char Stream.stream,
                              self   : self,
                              len    : int,
                              start  : char Stream.stream }

                (* emit a token and continue lexing the rest of the input *)
                fun emit tok ({ follow, self, ... }:info) =
                    Stream.Cons (tok, Stream.lazy (fn () => #lex self follow))

                fun section       (i as {match,...}:info) = emit (SECTION       (extractName 3 2 match)) i
                fun close_section (i as {match,...}:info) = emit (CLOSE_SECTION (extractName 3 2 match)) i
                fun inverted      (i as {match,...}:info) = emit (INVERTED      (extractName 3 2 match)) i
                fun partial       (i as {match,...}:info) = emit (PARTIAL       (extractName 3 2 match)) i
                fun comment       (i as {match,...}:info) = emit (COMMENT       (extractName 3 2 match)) i
                fun unesc_amp     (i as {match,...}:info) = emit (UNESC_AMP     (extractName 3 2 match)) i
                fun open_unesc    (i as {match,...}:info) = emit (OPEN_UNESC    (extractName 3 3 match)) i
                fun open_tag      (i as {match,...}:info) = emit (OPEN_TAG      (extractName 2 2 match)) i
                fun text          (i as {match,...}:info) = emit (TEXT          (String.implode match)) i
                fun lbrace        (i:info)                = emit LBRACE i
                fun eof           _                       = Stream.Nil
            end)

    structure Parser =
        MustacheParseFun
        (structure Streamable = StreamStreamable
         structure Arg =
            struct
                type string = string
                type node   = Ast.node

                fun mk_empty ()                             = Template []
                fun mk_cons  (n, Template ns)               = Template (n :: ns)
                  | mk_cons  (n, _)                         = Template [n]
                fun mk_text          s                      = Text s
                fun mk_variable      s                      = Variable s
                fun mk_unescaped     s                      = UnescapedVariable s
                fun mk_comment       s                      = Comment s
                fun mk_partial       s                      = Partial s
                fun mk_lbrace        ()                     = Text "{"
                fun stripLeadingNewline (Text s :: rest) =
                        let val s' = if String.size s > 0 andalso String.sub (s, 0) = #"\n"
                                     then String.extract (s, 1, NONE)
                                     else s
                        in if s' = "" then rest else Text s' :: rest end
                  | stripLeadingNewline ns = ns

                fun mk_section  (name, Template ns, _)      = Section (name, stripLeadingNewline ns)
                  | mk_section  (name, n, _)                = Section (name, [n])
                fun mk_inverted (name, Template ns, _)      = InvertedSection (name, stripLeadingNewline ns)
                  | mk_inverted (name, n, _)                = InvertedSection (name, [n])

                (* Replicate the shared terminal datatype *)
                datatype terminal = datatype terminal

                fun error _ = Fail "parse error"
            end)

    fun parse (input : string) : Ast.node =
        let
            val charStream = Stream.fromList (String.explode input)
            val tokStream  = Stream.lazy (fn () => Lexer.lex charStream)
        in
            #1 (Parser.parse tokStream)
        end
end
