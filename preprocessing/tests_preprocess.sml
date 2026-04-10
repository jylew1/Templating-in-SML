structure Tests_Preprocess =
struct
    open JSON

    val passed = ref 0
    val failed = ref 0

    fun jsonEqual (NULL,        NULL)        = true
      | jsonEqual (BOOL b1,     BOOL b2)     = b1 = b2
      | jsonEqual (INT i1,      INT i2)      = i1 = i2
      | jsonEqual (FLOAT f1,    FLOAT f2)    = Real.== (f1, f2)
      | jsonEqual (STRING s1,   STRING s2)   = s1 = s2
      | jsonEqual (ARRAY a1,    ARRAY a2)    = ListPair.allEq jsonEqual (a1, a2)
      | jsonEqual (OBJECT o1,   OBJECT o2)   =
          ListPair.allEq (fn ((k1,v1),(k2,v2)) => k1 = k2 andalso jsonEqual (v1,v2)) (o1, o2)
      | jsonEqual _                          = false

    fun assertJ name expected actual =
        if jsonEqual (expected, actual) then
            ( print ("PASS: " ^ name ^ "\n")
            ; passed := !passed + 1)
        else
            ( print ("FAIL: " ^ name ^ "\n")
            ; failed := !failed + 1)

    fun assertJL name expected actual =
        if ListPair.allEq jsonEqual (expected, actual) then
            ( print ("PASS: " ^ name ^ "\n")
            ; passed := !passed + 1)
        else
            ( print ("FAIL: " ^ name ^ "\n")
            ; failed := !failed + 1)

    (* --- wrapItem tests --- *)

    val () = assertJ "wrapItem wraps string with isFirst=true isLast=false"
        (OBJECT [("value", STRING "a"), ("isFirst", BOOL true), ("isLast", BOOL false)])
        (Preprocess.wrapItem (STRING "a") true false)

    val () = assertJ "wrapItem wraps string with isFirst=false isLast=true"
        (OBJECT [("value", STRING "z"), ("isFirst", BOOL false), ("isLast", BOOL true)])
        (Preprocess.wrapItem (STRING "z") false true)

    val () = assertJ "wrapItem wraps string with isFirst=false isLast=false"
        (OBJECT [("value", STRING "mid"), ("isFirst", BOOL false), ("isLast", BOOL false)])
        (Preprocess.wrapItem (STRING "mid") false false)

    val () = assertJ "wrapItem wraps int value"
        (OBJECT [("value", INT 42), ("isFirst", BOOL true), ("isLast", BOOL true)])
        (Preprocess.wrapItem (INT 42) true true)

    (* --- flagList tests --- *)

    val () = assertJL "flagList empty list"
        []
        (Preprocess.flagList [])

    val () = assertJL "flagList singleton: isFirst=true isLast=true"
        [ OBJECT [("value", STRING "only"), ("isFirst", BOOL true), ("isLast", BOOL true)] ]
        (Preprocess.flagList [STRING "only"])

    val () = assertJL "flagList two items: first and last flagged"
        [ OBJECT [("value", STRING "a"), ("isFirst", BOOL true),  ("isLast", BOOL false)]
        , OBJECT [("value", STRING "b"), ("isFirst", BOOL false), ("isLast", BOOL true)] ]
        (Preprocess.flagList [STRING "a", STRING "b"])

    val () = assertJL "flagList three items: middle has both flags false"
        [ OBJECT [("value", STRING "charlie"), ("isFirst", BOOL true),  ("isLast", BOOL false)]
        , OBJECT [("value", STRING "emma"),    ("isFirst", BOOL false), ("isLast", BOOL false)]
        , OBJECT [("value", STRING "henry"),   ("isFirst", BOOL false), ("isLast", BOOL true)] ]
        (Preprocess.flagList [STRING "charlie", STRING "emma", STRING "henry"])

    (* --- returnArray tests --- *)

    val () = assertJ "returnArray on array of one"
        (ARRAY [ OBJECT [("value", STRING "solo"), ("isFirst", BOOL true), ("isLast", BOOL true)] ])
        (Preprocess.returnArray (ARRAY [STRING "solo"]))

    val () = assertJ "returnArray on array of three"
        (ARRAY
            [ OBJECT [("value", STRING "charlie"), ("isFirst", BOOL true),  ("isLast", BOOL false)]
            , OBJECT [("value", STRING "emma"),    ("isFirst", BOOL false), ("isLast", BOOL false)]
            , OBJECT [("value", STRING "henry"),   ("isFirst", BOOL false), ("isLast", BOOL true)] ])
        (Preprocess.returnArray (ARRAY [STRING "charlie", STRING "emma", STRING "henry"]))

    val () = assertJ "returnArray on empty array"
        (ARRAY [])
        (Preprocess.returnArray (ARRAY []))

    val () = assertJ "returnArray on non-array string passes through"
        (STRING "hello")
        (Preprocess.returnArray (STRING "hello"))

    val () = assertJ "returnArray on non-array int passes through"
        (INT 99)
        (Preprocess.returnArray (INT 99))

    val () = assertJ "returnArray on bool passes through"
        (BOOL true)
        (Preprocess.returnArray (BOOL true))

    val () = assertJ "returnArray on null passes through"
        NULL
        (Preprocess.returnArray NULL)

    (* --- summary --- *)

    val () = print ("\nResults: " ^ Int.toString (!passed) ^ " passed, " ^ Int.toString (!failed) ^ " failed\n")

end
