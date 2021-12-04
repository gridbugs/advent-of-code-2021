open Core

module Board = struct
  type t = { numbers : int list; strips : Int.Set.t list } [@@deriving sexp]

  let of_ints numbers =
    assert (Int.equal (List.length numbers) 25);
    let rows = List.chunks_of numbers ~length:5 in
    let cols = List.transpose_exn rows in
    { numbers; strips = rows @ cols |> List.map ~f:Int.Set.of_list }

  let is_won { strips; _ } ~seen_nums =
    List.exists strips ~f:(Int.Set.is_subset ~of_:seen_nums)

  let score { numbers; _ } ~seen_nums ~last_seen_num =
    let unmarked_sum =
      List.filter numbers ~f:(Fun.negate (Int.Set.mem seen_nums))
      |> Advent.sum_ints
    in
    unmarked_sum * last_seen_num

  module Parse = struct
    let space = Re2.create_exn " +"

    let parse_lines lines =
      List.bind lines ~f:(fun line ->
          let line = String.strip line in
          Re2.split space line)
      |> List.map ~f:Int.of_string |> of_ints
  end
end

module Input = struct
  type t = { numbers : int list; boards : Board.t list } [@@deriving sexp]

  module Parse = struct
    let parse_numbers s = String.split s ~on:',' |> List.map ~f:Int.of_string

    let parse_lines lines =
      match lines with
      | h :: rest ->
          let numbers = parse_numbers h in
          let boards =
            List.chunks_of rest ~length:6
            |> List.map ~f:List.tl_exn
            |> List.map ~f:Board.Parse.parse_lines
          in
          { numbers; boards }
      | _ -> failwith "failed to parse"
  end
end

let () =
  let { Input.numbers; boards } =
    Input.Parse.parse_lines (Advent.read_stdin ())
  in
  let seen_nums, winning_board, last_seen_num =
    List.fold_until numbers ~init:(Int.Set.empty, boards)
      ~finish:(fun _ -> failwith "no winner")
      ~f:(fun (seen_so_far, unwon_boards) num ->
        let with_num = Int.Set.add seen_so_far num in
        let next_unwon_boards =
          List.filter unwon_boards
            ~f:(Fun.negate (Board.is_won ~seen_nums:with_num))
        in
        if List.is_empty next_unwon_boards then (
          assert (Int.equal (List.length unwon_boards) 1);
          Continue_or_stop.Stop (with_num, List.hd_exn unwon_boards, num))
        else Continue_or_stop.Continue (with_num, next_unwon_boards))
  in
  print_endline
    (Int.to_string (Board.score winning_board ~seen_nums ~last_seen_num))
