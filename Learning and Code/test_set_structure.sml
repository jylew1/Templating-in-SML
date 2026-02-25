use "Learning and Code/SetStructure.sml";

val s1 = IntSet.insert 1 IntSet.empty;
val s2 = IntSet.insert 2 s1;
val s3 = IntSet.insert 3 s2;
val s3_dup = IntSet.insert 3 s3; 

val _ = print("--- Member Tests ---\n");
val _ = print("member 1 s3: " ^ Bool.toString(IntSet.member 1 s3) ^ "\n"); (* true *)
val _ = print("member 5 s3: " ^ Bool.toString(IntSet.member 5 s3) ^ "\n"); (* false *)
val _ = print("member 3 s3_dup: " ^ Bool.toString(IntSet.member 3 s3_dup) ^ "\n"); (* true *)

(* Test union *)
val sa = IntSet.insert 1 (IntSet.insert 2 IntSet.empty);
val sb = IntSet.insert 2 (IntSet.insert 3 IntSet.empty);
val su = IntSet.union sa sb;

val _ = print("--- Union Tests ---\n");
val _ = print("member 1 union: " ^ Bool.toString(IntSet.member 1 su) ^ "\n"); (* true *)
val _ = print("member 2 union: " ^ Bool.toString(IntSet.member 2 su) ^ "\n"); (* true *)
val _ = print("member 3 union: " ^ Bool.toString(IntSet.member 3 su) ^ "\n"); (* true *)

(* Test intersect *)
val si = IntSet.intersect sa sb;

val _ = print("--- Intersect Tests ---\n");
val _ = print("member 1 intersect: " ^ Bool.toString(IntSet.member 1 si) ^ "\n"); (* false *)
val _ = print("member 2 intersect: " ^ Bool.toString(IntSet.member 2 si) ^ "\n"); (* true *)
val _ = print("member 3 intersect: " ^ Bool.toString(IntSet.member 3 si) ^ "\n"); (* false *)