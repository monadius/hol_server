#load "unix.cma"
#mod_use "server.ml"

(* We cannot start a server inside the init script because
  this script is loaded by `use_silently` which sets the 
  `Toploop.use_print_results` (which is not accesible) to `false`.
  When this flag is `false`, `Toploop.use_input` always returns empty results.
*)
(* let _ = Server.start 2012 *)

let run () = Server.start 2012

let () = Printf.printf "Start the server with run();;\n"