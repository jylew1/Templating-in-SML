use "/usr/local/smlnj/smlnj-lib/Util/json.sml";
use "/usr/local/smlnj/smlnj-lib/JSON/json-source.sml";
use "/usr/local/smlnj/smlnj-lib/JSON/json-parser.sml";

val cmtool = case OS.Process.getEnv "HOME" of
                 SOME p => p ^ "/cmtool"
               | NONE   => raise Fail "HOME environment variable not set";

use (cmtool ^ "/cmlib/streamable.sig");
use (cmtool ^ "/cmlib/lex-engine.sig");
use (cmtool ^ "/cmlib/lex-engine.sml");
use (cmtool ^ "/cmlib/parse-engine.sig");
use (cmtool ^ "/cmlib/parse-engine.sml");
use "../mustache_parser/ast.sml";
use "../mustache_parser/mustache.cmlex.sml";
use "../mustache_parser/mustache.cmyacc.sml";
use "../mustache_parser/mustache.sml";

use "../preprocessing/preprocess.sml";

use "renderer.sml";
use "tests_renderer.sml";
val _ = RendererTests.runAll ();

val _ =
    let val template = TextIO.inputAll (TextIO.openIn "../Learning and Code/Code/example.mustache")
        val src = Preprocess.returnArray (JSONParser.parseFile "data.json")
    in print ("\nRendered output:\n" ^ Render.render template src ^ "\n")
    end;
