# Making the Calculator example work

In order to make the calculator example work, you should

* install SML/NJ
* install CM-Tools
* copy Makefile and calc.cm in this directory to your cmtool/examples-sml directory
* run make in that directory
* start sml and invoke `CM.make "calc.cm";`
* run the parser with `(Calculator.calc o Stream.fromString) "1 + 2*3";`
