
datatype int_Exp = plus of int_term * int_Exp 
              | minus of int_term * int_Exp 
  and int_term = times of int_factor * int_term 
              | divide of int_factor * int_term 
              | modulo of int_factor * int_term 
  and int_factor = int_const of int
              | paren of int_Exp

fun eval_int_factor (int_const n) = n
  | eval_int_factor (paren e)     = eval_int_exp e

and eval_int_term (times (f, t))  = eval_int_factor f * eval_int_term t
  | eval_int_term (divide (f, t)) = eval_int_factor f div eval_int_term t
  | eval_int_term (modulo (f, t)) = eval_int_factor f mod eval_int_term t
 
and eval_int_exp (plus (t, e))    = eval_int_term t + eval_int_exp e
  | eval_int_exp (minus (t, e))   = eval_int_term t - eval_int_exp e




(* Poly/ML 5.9.2 Release
val eval_int_exp = fn: int_Exp -> int
val eval_int_factor = fn: int_factor -> int
val eval_int_term = fn: int_term -> int
datatype int_Exp = minus of int_term * int_Exp | plus of int_term * int_Exp
datatype int_factor = int_const of int | paren of int_Exp
datatype int_term =
    divide of int_factor * int_term
  | modulo of int_factor * int_term
  | times of int_factor * int_term
(END) *)