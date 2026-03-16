
structure Calculator
  :>
  sig
    datatype nonterm = NUM of int 
                     | ADD of nonterm * nonterm 
                     | MULT of nonterm * nonterm
    val calc : char Stream.stream -> nonterm
  end
  =
  struct
     open Stream

    datatype nonterm = NUM of int 
                     | ADD of nonterm * nonterm 
                     | MULT of nonterm * nonterm

     datatype terminal =
        NUMBER of int
      | PLUS
      | TIMES
      | LPAREN
      | RPAREN

     structure Lexer =
        CalcLexFun
        (structure Streamable = StreamStreamable
         structure Arg =
            struct
               type symbol = char
               val ord = Char.ord

               type t = terminal front
    
               type self = { lex : char stream -> t }
               type info = { match : char list,
                             follow : char stream,
                             self : self,
                             len : int,
                             start : char stream }
    
               fun number ({ match, follow, self, ... }:info) =
                 Cons (NUMBER (Option.valOf (Int.fromString (String.implode match))),
                       lazy (fn () => #lex self follow))
    
               fun simple terminal ({ follow, self, ... }:info) =
                 Cons (terminal, lazy (fn () => #lex self follow))
    
               val plus = simple PLUS
               val times = simple TIMES
               val lparen = simple LPAREN
               val rparen = simple RPAREN
    
               fun whitespace ({ follow, self, ...}:info) =
                 #lex self follow
    
               fun eof _ = Nil
             end)
     
      structure Parser =
         CalcParseFun
         (structure Streamable = StreamStreamable
          structure Arg =
             struct
               type t = int
               type nonterm = nonterm
               fun id x = x
    
               val number_atom = NUM
               val paren_atom = id
               val atom_factor = id
               fun times_factor (x, y) = MULT (x, y)
               val factor_term = id
               fun plus_term (x, y) = ADD (x,y)
    
               datatype terminal = datatype terminal
    
               fun error _ = Fail "syntax error"
             end)
   
      fun calc strm = #1 (Parser.parse (lazy (fn () => Lexer.lex strm)))
  end
