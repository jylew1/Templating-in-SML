structure Preprocess =
struct
    fun lookupStr key (JSON.OBJECT fields) =
          (case List.find (fn (k, _) => k = key) fields of
               SOME (_, JSON.STRING s) => s
             | _                       => "")
      | lookupStr _ _ = ""

    (* Wrap array items with isFirst/isLast.
       Object items get flags merged in; scalars get wrapped in a value key. *)
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

    (* Enrich social links: null gets empty string + has_X = false *)
    fun enrichSocial (JSON.OBJECT fields) =
          JSON.OBJECT (List.concat (List.map
              (fn (k, JSON.NULL) => [(k, JSON.STRING ""),
                                    ("has_" ^ k, JSON.BOOL false)]
                | (k, v)         => [(k, v),
                                    ("has_" ^ k, JSON.BOOL true)])
              fields))
      | enrichSocial v = v

    (* Enrich profile: bio fallback uses parent user's name/role/location,
       website null becomes "N/A", social links get has_X flags *)
    fun enrichProfile fullName role (JSON.OBJECT fields) =
          let
              val location = lookupStr "location" (JSON.OBJECT fields)
              fun enrichField ("bio",     JSON.NULL) =
                      ("bio", JSON.STRING (fullName ^ " is a " ^ role ^
                                           " based in " ^ location ^ "."))
                | enrichField ("website", JSON.NULL) =
                      ("website", JSON.STRING "N/A")
                | enrichField ("social",  v) =
                      ("social", enrichSocial v)
                | enrichField f = f
          in
              JSON.OBJECT (List.map enrichField fields)
          end
      | enrichProfile _ _ v = v

    (* Enrich a user object using field-aware logic *)
    fun enrichUser (JSON.OBJECT fields) =
          let
              val fullName = lookupStr "full_name" (JSON.OBJECT fields)
              val role     = lookupStr "role"      (JSON.OBJECT fields)
              fun enrichField ("profile", v) =
                      ("profile", enrichProfile fullName role v)
                | enrichField f = f
          in
              JSON.OBJECT (List.map enrichField fields)
          end
      | enrichUser v = v

    (* Walk all JSON, applying isFirst/isLast to arrays *)
    fun processValue (JSON.ARRAY items) =
            JSON.ARRAY (flagList (List.map processValue items))
      | processValue (JSON.OBJECT fields) =
            JSON.OBJECT (List.map (fn (k, v) => (k, processValue v)) fields)
      | processValue v = v

    (* Apply user enrichment first, then general isFirst/isLast processing *)
    fun enrichTopLevel (JSON.OBJECT fields) =
          JSON.OBJECT (List.map
              (fn ("users", JSON.ARRAY users) =>
                      ("users", JSON.ARRAY (List.map
                          (fn u => processValue (enrichUser u)) users))
                | (k, v) => (k, processValue v))
              fields)
      | enrichTopLevel v = processValue v

    fun returnArray v = enrichTopLevel v

end
