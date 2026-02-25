(* Exercise 4.5.1 *)
fun same a = a

(* Exercise 4.5.2 *)
fun nonexplict x = fn x => x 

(* 14:10 error code:

Poly/ML 5.9.2 Release
val nonexplict = fn: 'a -> 'b -> 'b
val same = fn: 'a -> 'a *)

