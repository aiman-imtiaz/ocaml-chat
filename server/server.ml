open Async
open Base
open Stdio

let t1 = ref 0.

let handler r w =
  let stdin = Lazy.force Reader.stdin in
  let rec task1 () = Reader.read_line stdin >>= function
    | `Eof -> return ()
    | `Ok x ->
      t1 := Unix.gettimeofday ();
      Writer.write_line w x;
      task1 () in
  let rec task2 () = Reader.read_line r >>= function
    | `Eof  -> return ()
    | `Ok "exit" -> return ()
    | `Ok "done" ->
      print_endline ("Message Received");
      print_endline(Printf.sprintf
                      "Roundtrip time: %fs\n" (Unix.gettimeofday () -. !t1));
      task2 ()
    | `Ok x ->
      print_endline ("Client: " ^ x);
      Writer.write_line w "done";
      task2 () in
  Deferred.any_unit [
    task1 ();
    task2 ();
  ]

let run ~port =
  let host_and_port =
    Tcp.Server.create ~on_handler_error:`Raise
      (Tcp.Where_to_listen.of_port port) (fun _addr r w ->
        handler r w)
  in
  ignore (host_and_port : (Socket.Address.Inet.t, int) Tcp.Server.t Deferred.t);
  Deferred.never ()

let () =
  Command.async ~summary:"Start a server"
    Command.Let_syntax.(
      let%map_open port =
        flag "-port"
          (optional_with_default 987 int)
          ~doc:" Port to listen on (default 987)"
      in
      fun () -> run ~port)
  |> Command.run

