val floor = Real.floor
val real = Real.fromInt

val zc =
fn (d, m, y, c) =>
(* this feels hard coded with the -1 at the end *)
(floor (2.61 * real m - 0.2) + d + y + y div 4 + c div 4 - 2 * c - 1) mod 7

val rec zeller = fn (d, 1, y) => zeller (d, 11, y-1)
| (d, 2, y) => zeller (d, 12, y-1)
| (d, m, y) => zc (d, m-2, y mod 100, y div 100)

(* GB's version *)

val zc2 =
fn (d, m, y, c) =>
(* GB: I removed the subtraction of 1 at the end *)
(Real.floor (2.61 * Real.fromInt m - 0.2) + d + y + y div 4 + c div 4 - 2 * c) mod 7


fun zeller2 (d, 1, y) = zeller2 (d, 11, y-1)
  | zeller2 (d, 2, y) = zeller2 (d, 12, y-1)
  | zeller2 (d, m, y) = zc2 (d, m-2, y mod 100, y div 100)

fun dayToString 0 = "Sunday"
  | dayToString 1 = "Monday"
  | dayToString 2 = "Tuesday"
  | dayToString 3 = "Wednesday"
  | dayToString 4 = "Thursday"
  | dayToString 5 = "Friday"
  | dayToString 6 = "Saturday"

fun dateToDay day month year = dayToString (zeller2 (day, month, year))
