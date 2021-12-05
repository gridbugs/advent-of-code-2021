open Core

module Coord = struct
  module T = struct
    type t = { x : int; y : int } [@@deriving fields, show, compare, sexp]
  end

  include T
  include Comparable.Make (T)
end

module Line = struct
  type t = Coord.t * Coord.t [@@deriving show]

  let coords ({ Coord.x = x0; y = y0 }, { Coord.x = x1; y = y1 }) =
    if Int.equal y0 y1 then
      let x_start, x_end = (Int.min x0 x1, Int.max x0 x1) in
      List.range ~stop:`inclusive x_start x_end
      |> List.map ~f:(fun x -> Coord.Fields.create ~x ~y:y0)
    else if Int.equal x0 x1 then
      let y_start, y_end = (Int.min y0 y1, Int.max y0 y1) in
      List.range ~stop:`inclusive y_start y_end
      |> List.map ~f:(fun y -> Coord.Fields.create ~x:x0 ~y)
    else
      let get_sign n = if n > 0 then 1 else -1 in
      let dx = x1 - x0 in
      let dy = y1 - y0 in
      let x_range = List.range ~stop:`inclusive ~stride:(get_sign dx) x0 x1 in
      let y_range = List.range ~stop:`inclusive ~stride:(get_sign dy) y0 y1 in
      List.zip_exn x_range y_range
      |> List.map ~f:(fun (x, y) -> Coord.Fields.create ~x ~y)

  module Parse = struct
    let pattern = Re2.create_exn "([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)"

    let parse s =
      let match_ = Re2.first_match_exn pattern s in
      let x0 = Re2.Match.get_exn ~sub:(`Index 1) match_ |> Int.of_string in
      let y0 = Re2.Match.get_exn ~sub:(`Index 2) match_ |> Int.of_string in
      let x1 = Re2.Match.get_exn ~sub:(`Index 3) match_ |> Int.of_string in
      let y1 = Re2.Match.get_exn ~sub:(`Index 4) match_ |> Int.of_string in
      (Coord.Fields.create ~x:x0 ~y:y0, Coord.Fields.create ~x:x1 ~y:y1)
  end
end

module Space = struct
  type t = int Coord.Map.t

  let empty = Coord.Map.empty

  let update t coord =
    Coord.Map.update t coord ~f:(function None -> 1 | Some n -> n + 1)

  let count_dangerous t = Coord.Map.count t ~f:(fun c -> c >= 2)
end

let () =
  let lines = Advent.read_stdin () |> List.map ~f:Line.Parse.parse in
  let space =
    List.fold
      (List.concat (List.map lines ~f:Line.coords))
      ~init:Space.empty ~f:Space.update
  in
  print_endline (Int.to_string (Space.count_dangerous space))
