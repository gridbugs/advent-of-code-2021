open Core

let list_pred_split xs ~f =
  List.fold xs ~init:([], []) ~f:(fun (lhs, rhs) x ->
      if f x then (x :: lhs, rhs) else (lhs, x :: rhs))

let parse_binary_string s =
  String.to_list s |> List.rev
  |> List.foldi ~init:0 ~f:(fun i acc c ->
         if Char.equal c '0' then acc else acc + Int.shift_left 1 i)

let has_1_at pos x = not (Int.equal (Int.bit_and (Int.shift_left 1 pos) x) 0)

let rec get_oxygen xs pos =
  match xs with
  | [] -> failwith "empty"
  | [ x ] -> x
  | xs ->
      let common_1, common_0 = list_pred_split xs ~f:(has_1_at pos) in
      if List.length common_1 >= List.length common_0 then
        get_oxygen common_1 (pos - 1)
      else get_oxygen common_0 (pos - 1)

let rec get_scrubber xs pos =
  match xs with
  | [] -> failwith "empty"
  | [ x ] -> x
  | xs ->
      let common_1, common_0 = list_pred_split xs ~f:(has_1_at pos) in
      if List.length common_0 <= List.length common_1 then
        get_scrubber common_0 (pos - 1)
      else get_scrubber common_1 (pos - 1)

let () =
  let input = Advent.read_stdin () in
  let numbers = input |> List.map ~f:parse_binary_string in
  let width = String.length (List.hd_exn input) in
  let oxygen = get_oxygen numbers (width - 1) in
  let scrubber = get_scrubber numbers (width - 1) in
  print_endline (Int.to_string (oxygen * scrubber))
