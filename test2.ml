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

let big () =
  let buf = Buffer.create (1024 * 100) in
  Buffer.add_string buf "aa";
  for i = 1 to 26 do
    let s = Buffer.contents buf in
    Printf.printf "%d: %s%!" i s;
    Thread.delay 0.2;
    Buffer.add_string buf s;
  done

let port = ref 2011

let run () =
  incr port;
  Server2.start !port

let () = run ();;

