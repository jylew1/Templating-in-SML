structure Render = 
struct
    open Ast

    fun lookupKey key (JSON.OBJECT fields) =
            (case List.find (fn (k, _) => k = key) fields of
                SOME (_, v) => v
            | NONE          => JSON.NULL)
        | lookupKey _ _ = JSON.NULL
    fun resolve "." ctx = ctx 
        | resolve path ctx =
            let val parts = String.fields (fn c => c = #".") path 
            in List.foldl (fn (k, acc) => lookupKey k acc) ctx parts 
            end 
    fun isTruth JSON.NULL           = false
        | isTruth (JSON.BOOL false) = false 
        | isTruth (JSON.ARRAY [])   = false
        | isTruth _                 = true 
    fun jsonToString JSON.NULL              = ""
        | jsonToString (JSON.BOOL true)     = "true"
        | jsonToString (JSON.BOOL false)    = "false"
        | jsonToString (JSON.INT n)         = IntInf.toString n 
        | jsonToString (JSON.FLOAT r)       = Real.toString r 
        | jsonToString (JSON.STRING s)      = s
        | jsonToString _                    = ""
    fun renderNode ctx node = 
        case node of 
            Text s => s 
        | Variable name => jsonToString (resolve name ctx)
        | UnescapedVariable name => jsonToString (resolve name ctx) 
        | Comment _ => ""
        | DelimiterChange _ => ""
        | Template nodes => String.concat (List.map (renderNode ctx) nodes)
        | Section (name, body) => 
            let val value = resolve name ctx 
            in  case value of 
                    JSON.ARRAY items => 
                         String.concat (List.map (fn item => String.concat (List.map (renderNode item) body)) items)
                | _ => 
                    if isTruth value then 
                        String.concat (List.map (renderNode ctx) body)
                    else ""
            end
        | InvertedSection (name, body) => 
            if isTruth (resolve name ctx) then ""
            else String.concat (List.map (renderNode ctx) body)
        | Partial name =>
            let val src = TextIO.inputAll (TextIO.openIn (name ^ ".mustache"))
            in renderNode ctx (Mustache.parse src)
            end
    fun render templateStr data = 
        renderNode data (Mustache.parse templateStr)

end 