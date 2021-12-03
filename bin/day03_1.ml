open Core

let parse_binary_string s =
  String.to_list s |> List.rev
  |> List.foldi ~init:0 ~f:(fun i acc c ->
         if Char.equal c '0' then acc else acc + Int.shift_left 1 i)

let count_1 xs pos =
  let mask = Int.shift_left 1 pos in
  List.map xs ~f:(Int.bit_and mask) |> List.count ~f:(Fun.negate (Int.equal 0))

let gamma width xs =
  let len = List.length xs in
  List.range (width - 1) 0 ~stop:`inclusive ~stride:(-1)
  |> List.map ~f:(fun pos ->
         if count_1 xs pos > len / 2 then Int.shift_left 1 pos else 0)
  |> List.fold ~init:0 ~f:( + )

let epsilon width xs =
  let mask = Int.shift_left 1 width - 1 in
  gamma width xs |> Int.bit_not |> Int.bit_and mask

let () =
  let input = Advent.read_stdin () in
  let numbers = input |> List.map ~f:parse_binary_string in
  let width = String.length (List.hd_exn input) in
  print_endline (Int.to_string (gamma width numbers * epsilon width numbers))
