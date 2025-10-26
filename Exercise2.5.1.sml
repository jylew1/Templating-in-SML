val floor = Real.floor
val real = Real.fromInt

val zc =
fn (d, m, y, c) =>
(* this feels hard coded with the -1 at the end *)
(floor (2.61 * real m - 0.2) + d + y + y div 4 + c div 4 - 2 * c - 1) mod 7

val rec zeller = fn (d, 1, y) => zeller (d, 11, y-1)
| (d, 2, y) => zeller (d, 12, y-1)
| (d, m, y) => zc (d, m-2, y mod 100, y div 100)