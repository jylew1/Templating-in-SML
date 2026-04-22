val cmtool = case OS.Process.getEnv "HOME" of
                 SOME p => p ^ "/cmtool"
               | NONE   => raise Fail "HOME environment variable not set";

use (cmtool ^ "/cmlib/streamable.sig");
use (cmtool ^ "/cmlib/lex-engine.sig");
use (cmtool ^ "/cmlib/lex-engine.sml");
use (cmtool ^ "/cmlib/parse-engine.sig");
use (cmtool ^ "/cmlib/parse-engine.sml");
use "ast.sml";
use "mustache.cmlex.sml";
use "mustache.cmyacc.sml";
use "mustache.sml";
use "tests.sml";
