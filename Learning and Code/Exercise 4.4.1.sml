(* Define the constructors, Nil and Cons, such that the following code type checks. *)

datatype tree = Nil = empty | Cons = node of 1 + tree
fun length (Nil) = 0
| length (Cons (_, x)) = 1 + length (x)
val heterogeneous = Cons (1, Cons (true, Cons (fn x => x, Nil)))