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

  let zero = { x = 0; y = 0 }

  let product { x; y } = x * y
end

module State = struct
  type t = { coord : Coord.t; aim : int } [@@deriving show, fields]

  let update ({ coord = { Coord.x; y }; aim } as t)
      { Command.direction; distance } =
    match direction with
    | `Up -> { t with aim = aim - distance }
    | `Down -> { t with aim = aim + distance }
    | `Forward ->
        { coord = { x = x + distance; y = y + (distance * aim) }; aim }

  let init = { coord = Coord.zero; aim = 0 }
end

let () =
  let commands = Advent.read_stdin () |> List.map ~f:Command.of_string_exn in
  let destination = List.fold commands ~init:State.init ~f:State.update in
  print_endline (Int.to_string (Coord.product (State.coord destination)))
