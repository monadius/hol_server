let read_thread (in_chan, fdcontrol) =
  let buf = Bytes.create 1024 in
  let fdin = Unix.descr_of_in_channel in_chan in
  try
    while true do
      let rs, _, _ = Unix.select [fdin; fdcontrol] [] [] (-1.) in
      if List.mem fdin rs then begin
        let line = input_line in_chan in
        Printf.printf "line = %s\n%!" line
      end;
      if List.mem fdcontrol rs then begin
        let n = Unix.read fdcontrol buf 0 1024 in
        Printf.printf "received %d control bytes\n%!" n;
        raise End_of_file
      end;
    done
  with End_of_file ->
    print_endline "End_of_file: thread stopped"

let read_thread2 (fdin, fdcontrol) =
  ignore (Thread.sigmask Unix.SIG_BLOCK [Sys.sigint]);
  let buf = Bytes.create 1024 in
  try
    while true do
      let rs, _, _ = Unix.select [fdin; fdcontrol] [] [] (-1.) in
      if List.mem fdin rs then begin
        let n = Unix.read fdin buf 0 3 in
        let line = Bytes.sub_string buf 0 n in
        Printf.printf "n = %d, input: '%s'\n%!" n line
      end;
      if List.mem fdcontrol rs then begin
        let n = Unix.read fdcontrol buf 0 1024 in
        Printf.printf "received %d control bytes\n%!" n;
        raise End_of_file
      end;
    done
  with End_of_file ->
    print_endline "End_of_file: thread stopped"

let try_finally ~(finally : unit -> unit) f arg =
  let result = try f arg with exn -> finally (); raise exn in
  finally ();
  result

let drain =
  let size = 1024 * 10 in
  let bytes = Bytes.create size in
  fun fdin ->
    let buf = Buffer.create size in
    Unix.set_nonblock fdin;
    try_finally ~finally:(fun () -> Unix.clear_nonblock fdin)
    (fun () ->
      try
        let n = ref 1 in
        while !n > 0 do
          n := Unix.read fdin bytes 0 size;
          Buffer.add_subbytes buf bytes 0 !n;
        done;
        buf
      with Unix.Unix_error (Unix.EAGAIN, _, _) | Unix.Unix_error (Unix.EWOULDBLOCK, _, _) -> buf
    ) ()

let run () =
  let buf = Bytes.create 1024 in
  let fdin, fdout = Unix.pipe () in
  Unix.set_nonblock fdin;
  let fdin_ctrl, fdout_ctrl = Unix.pipe () in
  let out_chan = Unix.out_channel_of_descr fdout in
  let in_chan = Unix.in_channel_of_descr fdin in
  print_endline "Starting a reading thread";
  (* let t = Thread.create read_thread (in_chan, fdin_ctrl) in *)
  let t = Thread.create read_thread2 (fdin, fdin_ctrl) in
  print_endline "Writing";
  try
    for i = 1 to 5 do
      output_string out_chan "Hello!\n";
      flush out_chan;
      Thread.delay 0.5;
    done;
    output_string out_chan "Last hello";
    print_endline "Flushing";
    flush out_chan;
    print_endline "Joining";
    ignore (Unix.single_write fdout_ctrl buf 0 1);
    Thread.join t;
    ignore (drain fdin_ctrl);
    print_endline "Reading remaining data";
    let res = Buffer.contents (drain fdin) in
    Printf.printf "res = '%s'\n" res;
    close_in in_chan;
    close_out out_chan;
    Unix.close fdin_ctrl;
    Unix.close fdout_ctrl
  with Sys.Break ->
    ignore (Unix.single_write fdout_ctrl buf 0 1);
    Thread.join t;
    ignore (drain fdin_ctrl);
    close_in in_chan;
    close_out out_chan;
    Unix.close fdin_ctrl;
    Unix.close fdout_ctrl
