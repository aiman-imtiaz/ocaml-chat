open Async
open Base
open Stdio

let t2 = ref 0.

let handler r w =
  let stdin = Lazy.force Reader.stdin in
  let rec task1 () = Reader.read_line stdin >>= function
    | `Eof -> return ()
    | `Ok x ->
      t2 := Unix.gettimeofday ();
      Writer.write_line w x;
      task1 () in
  let rec task2 () = Reader.read_line r >>= function
    | `Eof  -> return ()
    | `Ok "done" ->
      print_endline ("Message Received");
      print_endline(Printf.sprintf
                      "Roundtrip time: %fs\n" (Unix.gettimeofday () -. !t2));
      task2 ()
    | `Ok x ->
      print_endline ("Server: " ^ x);
      Writer.write_line w "done";
      task2 () in
  Deferred.any_unit [
    task1 ();
    task2 ();
  ]

let run ~ip ~port =
  Tcp.with_connection
    (Tcp.Where_to_connect.of_host_and_port { host = ip; port = port})
    (fun _ r w ->
       handler r w)

let () =
  Command.async ~summary:"Start a client"
    Command.Let_syntax.(
      let%map_open port =
        flag "-port"
          (optional_with_default 987 int)
          ~doc:" Port to listen on (987)"
      and ip =
        flag "-ip"
          (optional_with_default "127.0.0.1" string)
           ~doc:" ip address to conenct to (default 127.0.0.1)"
      in
      fun () -> run ~ip ~port)
  |> Command.run

