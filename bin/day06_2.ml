open Core

module Input = struct
  (* track the number of fish of each counter value *)
  type t = int Int.Map.t [@@deriving sexp]

  let parse_stdin () =
    let init_counters =
      In_channel.input_all In_channel.stdin
      |> String.strip ~drop:Char.is_whitespace
      |> String.split ~on:',' |> List.map ~f:Int.of_string
    in
    List.fold init_counters ~init:Int.Map.empty ~f:(fun acc count ->
        Map.update acc count ~f:(function Some x -> x + 1 | None -> 1))

  let step t =
    let n_to_append = Map.find t 0 |> Option.value ~default:0 in
    Map.fold t
      ~init:(Int.Map.of_alist_exn [ (8, n_to_append) ])
      ~f:(fun ~key ~data acc ->
        let next_key = match key with 0 -> 6 | other -> other - 1 in
        Map.update acc next_key ~f:(function
          | None -> data
          | Some current -> current + data))

  let count t = Advent.sum_ints (Map.data t)
end

let () =
  let num_days = 256 in
  let input = Input.parse_stdin () in
  let output = Fn.apply_n_times ~n:num_days Input.step input in
  print_endline (Int.to_string (Input.count output))
