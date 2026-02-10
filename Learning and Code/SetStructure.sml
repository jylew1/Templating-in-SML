signature SET =
sig
    type elem
    type set
    val empty : set
    val singleton : elem -> set
    val union : set -> set -> set
    val intersect : set -> set -> set
end


(* As a second exercise, have the element the following signature: *)

signature SETELEM =
sig
   type elem
   val equal: elem -> elem -> bool
end

(* and implement a functor that creates a set implementation that conforms *)

signature SET =
sig
    type elem
    type set
    val empty : set
    val member : elem -> set -> bool
    val insert : elem -> set -> set (* pay attention that this is
different from the above *)
    val union : set -> set -> set
    val intersect : set -> set -> set
end

functor SetFunctor (E : SETELEM) : SET = 
struct
    type elem = E.elem
    type set = elem list 

    val empty = []
(* for bool *)
    fun member x [] = false
        | member x (h::t) = E.equal x h orelse member x t
(* for elem--> set *)
    fun insert x s = 
        if member x s then s else x :: s
(* for set *)
    fun union [] s2 = s2 
        | union (h::t) s2 = union t (insert h s2)
    fun intersect [] s2 = []
        | intersect (h::t) s2 =
            if member h s2
            then h :: intersect t s2
            else intersect t s2 
end 


structure IntElem : SETELEM =
struct
  type elem = int
  fun equal a b = (a=b)
end

(*
*
* member 2 [1,2,3] = member 2 1::[2,3] = E.equal 2 1 orelse member 2 [2,3] =
* False orelse member 2 [2,3] = member 2 2::[3] = E.equal 2 2 orelse member 2
* [3] = True orelse ... = True
*
* member 2 [3] = member 2 3::[] = E.equal 2 3 orelse member 2 [] 
*
*   Instantiation:
*)

   structure IntSet = SetFunctor(IntElem);

