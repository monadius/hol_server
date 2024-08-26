#directory "+compiler-libs";;

#load "unix.cma";;
(* #load "ocamlcommon.cma";;  *)

#mod_use "server.ml";;

let port = ref 2011

let test () =
  incr port;
  Server.start !port

let () = test ();;