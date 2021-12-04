open Core

let read_stdin () = In_channel.input_lines In_channel.stdin

let sum_ints = List.fold ~init:0 ~f:( + )
