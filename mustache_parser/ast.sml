structure Ast = 
struct
    datatype node
        = Text of string
        | Variable of string
        | UnescapedVariable of string
        | Section of string * node list
        | InvertedSection of string * node list
        | Comment of string
        | Partial of string
        | DelimiterChange of string * string       
        | Template of node list
end 