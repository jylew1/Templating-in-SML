structure SpecRunner =
struct
    fun getStr key (JSON.OBJECT fields) =
          (case List.find (fn (k, _) => k = key) fields of
             SOME (_, JSON.STRING s) => s
           | _ => "")
      | getStr _ _ = ""

    fun getVal key (JSON.OBJECT fields) =
          (case List.find (fn (k, _) => k = key) fields of
             SOME (_, v) => v
           | NONE => JSON.OBJECT [])
      | getVal _ _ = JSON.OBJECT []

    fun getArr key json =
          case getVal key json of
            JSON.ARRAY xs => xs
          | _ => []

    fun showStr s =
        let fun esc #"\n" = "\\n"
              | esc #"\r" = "\\r"
              | esc #"\t" = "\\t"
              | esc c     = String.str c
        in String.concat (List.map esc (String.explode s))
        end

    (* Run one test case; returns (passed_delta, failed_delta) *)
    fun runTest specName (p, f) testJson =
        let
            val name     = getStr "name"     testJson
            val template = getStr "template" testJson
            val data     = getVal "data"     testJson
            val expected = getStr "expected" testJson
            val actual   = (Render.render template data)
                           handle e => "[EXCEPTION: " ^ exnMessage e ^ "]"
        in
            if actual = expected then
                (print ("  PASS  " ^ name ^ "\n"); (p + 1, f))
            else
                ( print ("  FAIL  " ^ name ^ "\n")
                ; print ("    exp: " ^ showStr expected ^ "\n")
                ; print ("    got: " ^ showStr actual   ^ "\n")
                ; (p, f + 1) )
        end

    (* Run all tests in one spec JSON file *)
    fun runFile jsonPath =
        let
            val json     = JSONParser.parseFile jsonPath
            val specName = getStr "spec"  json
            val tests    = getArr "tests" json
            val ()       = print ("\n=== " ^ specName ^ " ===\n")
            val (p, f)   = List.foldl (fn (t, acc) => runTest specName acc t) (0, 0) tests
        in
            print ("  " ^ Int.toString p ^ "/" ^ Int.toString (p + f) ^ " passed\n");
            (p, f)
        end

    (* Run all JSON files in a directory *)
    fun runAll genDir =
        let
            val dh    = OS.FileSys.openDir genDir
            fun collect () =
                case OS.FileSys.readDir dh of
                  NONE   => []
                | SOME f => f :: collect ()
            val files = collect ()
            val ()    = OS.FileSys.closeDir dh
            val jsons = List.filter (fn f => String.isSuffix ".json" f) files
            val results = List.map (fn f => runFile (genDir ^ "/" ^ f)) jsons
            val (tp, tf) = List.foldl (fn ((p,f),(ap,af)) => (ap+p, af+f)) (0,0) results
        in
            print ("\n========================================\n");
            print ("TOTAL: " ^ Int.toString tp ^ " passed, " ^
                               Int.toString tf ^ " failed\n");
            print "========================================\n"
        end
end
