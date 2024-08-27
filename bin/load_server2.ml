#directory "+compiler-libs";;
#directory "+threads";;

#load "unix.cma"
#load "threads.cma"
#mod_use "server2.ml"

(* We cannot start a server inside the init script because
  this script is loaded by `use_silently` which sets the 
  `Toploop.use_print_results` (which is not accesible) to `false`.
  When this flag is `false`, `Toploop.use_input` always returns empty results.
*)
(* let _ = Server2.start 2012 *)

let run () = Server2.start 2012

let () = Printf.printf "Start the server with run();;\n"