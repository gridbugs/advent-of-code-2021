open Core

module Command = struct
  type t = { direction : [ `Forward | `Down | `Up ]; distance : int }
  [@@deriving show, fields]

  let of_string_exn s =
    let direction, distance =
      match String.split ~on:' ' s with
      | [ "forward"; x ] -> (`Forward, Int.of_string x)
      | [ "down"; x ] -> (`Down, Int.of_string x)
      | [ "up"; x ] -> (`Up, Int.of_string x)
      | _ -> failwith "failed to parse"
    in
    Fields.create ~direction ~distance
end

module Coord = struct
  type t = { x : int; y : int } [@@deriving show, fields]

  let update t command =
    let { x; y } = t in
    let { Command.direction; distance } = command in
    match direction with
    | `Forward -> { x = x + distance; y }
    | `Up -> { x; y = y - distance }
    | `Down -> { x; y = y + distance }

  let zero = { x = 0; y = 0 }

  let product { x; y } = x * y
end

let () =
  let commands = Advent.read_stdin () |> List.map ~f:Command.of_string_exn in
  let destination = List.fold commands ~init:Coord.zero ~f:Coord.update in
  print_endline (Int.to_string (Coord.product destination))
