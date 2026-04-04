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
end 