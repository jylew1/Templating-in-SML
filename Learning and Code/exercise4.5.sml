(* Exercise 4.5.1 *)
fun same a = a

(* Exercise 4.5.2 *)
fun nonexplicit x y = [x, y];
val nonexplicit2 = fn x => fn y => if x = y then x else y;

(* 25/02/2026 output code: 
val nonexplicit = fn: 'a -> 'a -> 'a list
val same = fn: 'a -> 'a
val nonexplicit2 = fn: ''a -> ''a -> ''a *)

