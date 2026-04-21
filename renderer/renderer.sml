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

    fun htmlEscape s =
        let fun escapeChar #"&" = "&amp;"
              | escapeChar #"<" = "&lt;"
              | escapeChar #">" = "&gt;"
              | escapeChar #"\"" = "&quot;"
              | escapeChar #"'" = "&#39;"
              | escapeChar c   = String.str c
        in String.concat (List.map escapeChar (String.explode s))
        end

    fun renderNote ctx node =
        case node of 
            Text s => s 
        | Comment _ => ""
        | Variable name => htmlEscape (jsonToString (resolve name ctx))
        | UnescapedVariable name => jsonToString (resolve name ctx)
        | Section (name, nodes) =>
            let val value = resolve name ctx
            in case value of
                JSON.ARRAY items =>
                    String.concat (List.map (fn item =>
                        String.concat (List.map (renderNote item) nodes)) items)
              | JSON.OBJECT _ =>
                    String.concat (List.map (renderNote value) nodes)
              | _ => if isTruth value
                     then String.concat (List.map (renderNote ctx) nodes)
                     else ""
            end
        | InvertedSection (name, nodes) => 
            let val value = resolve name ctx
            in if not (isTruth value)
                then String.concat (List.map (renderNote ctx) nodes)
                else ""
            end
        | Template nodes => String.concat (List.map (renderNote ctx) nodes)
        | Partial name => ""
        | DelimiterChange _ => ""

    fun render templateStr jsonData =
        let val ast = Mustache.parse templateStr
        in renderNote jsonData ast
        end
end 
