let get_sockaddr host_name port =
  let host = Unix.gethostbyname host_name in
  let address = host.h_addr_list.(0) in
  Unix.ADDR_INET (address, port)

let client ?(host_name = "localhost") port =
  Sys.catch_break true;
  let addr = get_sockaddr host_name port in
  let in_chan, out_chan = Unix.open_connection addr in
  try
    while true do
      let line = input_line in_chan in
      Printf.printf "%s\n%!" line;
      if line = "ready" then begin
          let cmd = input_line stdin in
          output_string out_chan cmd;
          output_string out_chan "\n";
          flush out_chan
      end
    done
  with exn ->
    Unix.shutdown_connection in_chan;
    close_out out_chan;
    Printf.printf "Connection closed\n%!";
    raise exn
