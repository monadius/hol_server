#directory "+compiler-libs";;
#directory "+threads";;

#load "unix.cma";;
#load "threads.cma";;

#mod_use "server2.ml";;

let test1 () =
  for i = 1 to 10 do
    Printf.printf "i = %d\n%!" i;
    Thread.delay 0.5;
  done

let test2 () =
  for i = 1 to 10 do
    Printf.printf "i = %d\n%!" i;
    Printf.eprintf "error: i = %d%!" i;
    Thread.delay 0.5;
  done

let port = ref 2011

let run () =
  incr port;
  Server2.start !port

let () = run ();;

