#directory "+compiler-libs";;

#load "unix.cma";;
(* #load "ocamlcommon.cma";;  *)
#load "server.cmo";;

let port = ref 2011

let test () =
  incr port;
  Server.start !port

let () = test ();;