open Core

let rec slide2 = function
  | [] | [ _ ] -> []
  | a :: b :: tl -> (a, b) :: slide2 (b :: tl)

let rec slide3_sum = function
  | [] | [ _ ] | [ _; _ ] -> []
  | a :: b :: c :: tl -> (a + b + c) :: slide3_sum (b :: c :: tl)

let () =
  let depths = Advent.read_stdin () |> List.map ~f:Int.of_string in
  let sums = slide3_sum depths in
  let depth_pairs = slide2 sums in
  let num_increases = List.count depth_pairs ~f:(fun (a, b) -> a < b) in
  print_endline (Int.to_string num_increases)
