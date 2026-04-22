# Compiling a standalone program in SML/NJ

You cannot create a fully independent standalone program in SML/NJ. What you can do is to an SML/NJ-specific object file and load it into SML/NJ. You need to write a shell
script for this.

In this directory, there's a Hello World program that you need to adapt to your system. The script is
```
$ cat hello
#!/bin/bash

sml @SMLload=./hello.amd64-linux $@
```

You might need something different than amd64-linux.

In order to compile `hello.sml`, using `hello.cm`, use the following command:
```
$ ml-build hello.cm Main.main hello
```

Check `hello.sml` and `hello.cm` and ask questions if they are not clear. 
