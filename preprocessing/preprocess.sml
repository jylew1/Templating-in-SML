structure Preprocess =
struct
    (* Wrap array items with isFirst/isLast. *)
    fun wrapItem (JSON.OBJECT fields) isFirst isLast =
            JSON.OBJECT (fields @ [("isFirst", JSON.BOOL isFirst),
                                   ("isLast",  JSON.BOOL isLast)])
      | wrapItem item isFirst isLast =
            JSON.OBJECT [("value",   item),
                         ("isFirst", JSON.BOOL isFirst),
                         ("isLast",  JSON.BOOL isLast)]

    fun flagList items =
        let
            fun go [] _        = []
              | go [x] isFirst = [wrapItem x isFirst true]
              | go (x::xs) isFirst =
                    wrapItem x isFirst false :: go xs false
        in
            go items true
        end

    (* Walk all JSON values applying type-based rules:
       - null fields get empty string + has_X = false
       - string fields get has_X = true
       - arrays get isFirst/isLast on every item *)
    fun processFields [] = []
      | processFields ((k, JSON.NULL) :: rest) =
            (k,          JSON.STRING "") ::
            ("has_" ^ k, JSON.BOOL false) ::
            processFields rest
      | processFields ((k, JSON.STRING s) :: rest) =
            (k,          JSON.STRING s) ::
            ("has_" ^ k, JSON.BOOL true) ::
            processFields rest
      | processFields ((k, v) :: rest) =
            (k, processValue v) ::
            ("has_" ^ k, JSON.BOOL true) ::
            processFields rest

    and processValue (JSON.ARRAY items) =
            JSON.ARRAY (flagList (List.map processValue items))
      | processValue (JSON.OBJECT fields) =
            JSON.OBJECT (processFields fields)
      | processValue v = v

    fun returnArray v = processValue v

end
