(* load_spec.sml — run from repo root:
       echo 'use "spec_tests/load_spec.sml";' | sml
   or use run.sh                                          *)

val smlnjLib =
    case OS.Process.getEnv "SMLNJ_LIB" of
      SOME p => p
    | NONE   => "/usr/local/smlnj/smlnj-lib";

val _ = use (smlnjLib ^ "/Util/json.sml");
val _ = use (smlnjLib ^ "/JSON/json-source.sml");
val _ = use (smlnjLib ^ "/JSON/json-parser.sml");

val cmtool =
    case OS.Process.getEnv "CMTOOL_HOME" of
      SOME p => p
    | NONE   => case OS.Process.getEnv "HOME" of
                  SOME p => p ^ "/cmtool"
                | NONE   => raise Fail "Set CMTOOL_HOME or HOME";

val _ = use (cmtool ^ "/cmlib/streamable.sig");
val _ = use (cmtool ^ "/cmlib/lex-engine.sig");
val _ = use (cmtool ^ "/cmlib/lex-engine.sml");
val _ = use (cmtool ^ "/cmlib/parse-engine.sig");
val _ = use (cmtool ^ "/cmlib/parse-engine.sml");

val _ = use "mustache_parser/ast.sml";
val _ = use "mustache_parser/mustache.cmlex.sml";
val _ = use "mustache_parser/mustache.cmyacc.sml";
val _ = use "mustache_parser/mustache.sml";
val _ = use "renderer/renderer.sml";

val _ = use "spec_tests/spec_runner.sml";
val _ = SpecRunner.runAll "spec_tests/generated";
