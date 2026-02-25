(* Define the constructors, Nil and Cons, such that the following code type checks. *)

datatype 'a Nil = Nil
datatype ('a, 'b) Cons = Cons of 'a * 'b
fun 'a 'b length (Nil) = 0
    | length (Cons (_, x)) = 1 + length (x)
val heterogeneous = Cons (1, Cons (true, Cons (fn x => x, Nil)))
