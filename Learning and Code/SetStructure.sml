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
    val insert : elem -> set -> set (* pay attention that this is
different from the above *)
    val union : set -> set -> set
    val intersect : set -> set -> set
end

functor SetFunctor (E : SETELEM) : SET = 
struct
    type elem = int
    type set = int list 

    val empty = []
(* for bool *)
    fun member x [] = false
        | member x (h::t) = E.equal x h orelse member x 
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
    fun equal x y = (x = y)
end

structure IntSet = SetFunctor(IntElem)

val s1 = IntSet.empty
val s2 = IntSet.insert 1 s1
val s3 = IntSet.insert 2 s2
val s4 = IntSet.insert 1 s3

val s5 = IntSet.insert 3 (IntSet.insert 2 IntSet.empty)

val s6 = IntSet.union s4 s5
val s7 = IntSet.intersect s4 s5