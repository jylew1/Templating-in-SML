structure Main = struct
  fun main (_, _) =
    (print "Hello world!\n"; OS.Process.success)
end
