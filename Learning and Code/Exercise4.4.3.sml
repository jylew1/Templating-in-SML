datatype int_Exp = plus of int_term * int_term 
                | minus of int_term * int_term 
    and int-term = time of int_factor * factor 
                | divide of int_factor * int_factor 
                | modulo of int_factor * int_factor 
    and int_factor = int_const of int
                | paren of int_exp


fun eval_int_factor (int_const n) = n
  | eval_int_factor (paren e)     = eval_int_exp e
and eval_int_term (times (f, t))  = eval_int_factor f * eval_int_term t
  | eval_int_term (divide (f, t)) = eval_int_factor f div eval_int_term t
  | eval_int_term (modulo (f, t)) = eval_int_factor f mod eval_int_term t
  | eval_int_term (factor f)      = eval_int_factor f
and eval_int_exp (plus (t, e))    = eval_int_term t + eval_int_exp e
  | eval_int_exp (minus (t, e))   = eval_int_term t - eval_int_exp e
  | eval_int_exp (term t)         = eval_int_term t