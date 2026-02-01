signature ORDERED =
sig
  type t
  val compare : t * t -> order 
end

signature SORTING = 
sig
    type t
    val sort : t list -> t list 
end 


functor QuickSortFun(O : ORDERED) : SORTING =
struct
    type t = O.t

(* partition: int -> int list -> (int list * int list)*)
    fun partition p [] = ([], [])
    | partition p (x::xs) =
        let
        val (less, greater) = partition p xs
        in
        case O.compare(x, p) of
            LESS    => (x::less, greater)
        | EQUAL   => (x::less, greater)
        | GREATER => (less, x::greater)

    end

(* quicksort: int list -> int list *)
    fun quicksort [] = []  (* base case *)
  | quicksort (p::xs) =
    let
      val (lessorequal, greater) = partition p xs
    in
      quicksort lessorequal @ [p] @ quicksort greater
    end 
    val sort = quicksort
end