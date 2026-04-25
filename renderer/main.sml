structure Main =
struct
  fun readFile filename =
    let
      val instream = TextIO.openIn filename
      val contents = TextIO.inputAll instream
      val _ = TextIO.closeIn instream
    in
      contents
    end

  fun main (_, args) =
    case args of
      [templateFile, jsonFile] =>
        (let
          val templateStr = readFile templateFile
          val jsonData    = Preprocess.returnArray (JSONParser.parseFile jsonFile)
        in
          print (Render.render templateStr jsonData)
        ; OS.Process.success
        end
        handle e =>
          ( TextIO.output (TextIO.stdErr, "Error: " ^ exnMessage e ^ "\n")
          ; OS.Process.exit OS.Process.failure
          ))
    | _ =>
        ( TextIO.output (TextIO.stdErr,
            "Usage: render <template.mustache> <data.json>\n")
        ; OS.Process.exit OS.Process.failure
        )
end
