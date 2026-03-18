structure Eval =
struct
  open Calculator
(* print out AST *)
  fun printTree (NUM n)       = Int.toString n
    | printTree (ADD (x, y))  = "ADD(" ^ printTree x ^ ", " ^ printTree y ^ ")"
    | printTree (MULT (x, y)) = "MULT(" ^ printTree x ^ ", " ^ printTree y ^ ")"
(* display final value *)
(* this is from. AST val it = ADD (NUM 2,MULT (NUM 3,NUM 4)) : Calculator.nonterm *)
  fun eval (NUM n)       = n
    | eval (ADD (x, y))  = eval x + eval y
    | eval (MULT (x, y)) = eval x * eval y

  fun main () =
    let
      val tree = Calculator.calc (Stream.fromList (explode "1+2*3"))
    in
      print ("AST: " ^ printTree tree ^ "\n");
      print ("Result: " ^ Int.toString (eval tree) ^ "\n")
    end
end