structure Preprocess =
struct
   fun wrapItem item isFirst isLast =
    JSON.OBJECT [
        ("value", item),
        ("isFirst", JSON.BOOL isFirst),
        ("isLast", JSON.BOOL isLast)
    ]
    
    fun flagList items =
        let 
            fun go [] _ = []
                | go [x] isFirst =
                    [ wrapItem x isFirst true]
                | go (x::xs) isFirst =
                    wrapItem x isFirst false :: go xs false
        in 
            go items true 
        end
    
    fun returnArray (JSON.ARRAY items) = JSON.ARRAY (flagList items)
        | returnArray v = v

end 
