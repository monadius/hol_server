let run () =
  Sys.catch_break true;
  let old_signals = Thread.sigmask Unix.SIG_BLOCK [Sys.sigint] in
  let thread i =
    try
      Printf.printf "Thread %d started\n%!" i;
      if i = 3 || i = 4 then ignore (Thread.sigmask Unix.SIG_UNBLOCK [Sys.sigint]);
      Thread.delay 5.0
    with Sys.Break ->
      Printf.printf "Thread %d interrupted\n%!" i
  in
  try
    let ts = List.init 5 (fun i -> Thread.create thread (i + 1)) in
    Thread.delay 10.0;
    List.iter Thread.join ts;
    ignore (Thread.sigmask Unix.SIG_SETMASK old_signals)
  with Sys.Break ->
    Printf.printf "Main thread interrupted"
