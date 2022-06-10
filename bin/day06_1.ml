open Core

module Input = struct
  type t = int list [@@deriving sexp]

  let parse_stdin () =
    In_channel.input_all In_channel.stdin
    |> String.strip ~drop:Char.is_whitespace
    |> String.split ~on:',' |> List.map ~f:Int.of_string

  let step t =
    let n_to_append = List.count ~f:(Int.equal 0) t in
    let updated =
      List.map ~f:(function 0 -> 6 | other -> Int.(other - 1)) t
    in
    List.append updated (List.init ~f:(Fn.const 8) n_to_append)
end

let () =
  let num_days = 80 in
  let input = Input.parse_stdin () in
  let output = Fn.apply_n_times ~n:num_days Input.step input in
  print_endline (Int.to_string (List.length output))
