(* initial trial to just add up numbers *)
(* val rec sum' = fn 0 => 0
                  | n => n + sum' (n - 1) *)
val sum'' =
  let
    val rec sum_aux = fn (0, acc) => acc 
      | (i, acc) => sum_aux (i - 1, acc + i) 
  in 
    fn n => sum_aux (n, 0)
  end