## A server for executing toplevel HOL Light commands

This server is used by the [HOL Light VS Code extension](https://github.com/monadius/vscode-hol-light) to execute HOL Light commands and get command results.

To start the server inside an active HOL Light REPL, run the following commands:
```ocaml
#directory "+threads";;
#load "unix.cma";;
#load "threads.cma";;
#mod_use "{path to the server}/server2.ml";;
#mod_use "{path to the server}/hol_light_json.ml";;
Server2.start 2012;;
```

(Replace `{path to the server}` with the path where this repository is cloned.)

`2012` is the server port number. You may use any available port number.

`server2.ml` is a multi-threaded server. It should be preferred over `server.ml` which cannot send real-time updates about executing commands to a client.

A server can be stopped by typing `CTRL + C` in the server terminal. Note that `CTRL + C` does not stop a server when there is a connected client. Instead, `CTRL + C` will interrupt a command executed by a server. In order to stop a server with a connected client, type `stop` in the server terminal to disconnect the client and then type `CTRL + C`.

## Protocol

All result strings are escaped with `String.escaped`. All server messages end with the newline character `\n`. All commands sent to a server should be terminated with a single `\n`. The command text should be escaped (they are processed with `Scanf.unescaped`).

### Server messages

- `ready:{escaped text}`: the server waits for a command. All commands (except `$interrupt`) must be sent to the server after receiving the `ready` message from the server. Currently the following message is sent by `server2`: `ready:subgoals:{# subgoals info}`

- `info:{escaped text}`: information about the server such as the pid of the server process. Currently the following message is sent by `server2`: `info:interrupt:true;pid:{server process PID}`. The message from `server` does not include the `interrupt:true` part.

- `stdout:{escaped text}`: stdout output. Multiple `stdout` messages can be sent by `server2` for the same command.

- `stderr:{escaped text}`: stderr output. Multiple `stderr` messages can be sent by `server2` for the same command.

- `result:{escaped text}`: the command result. It could be either int the form `- : type = value` or `val it : type = value` for HOL Light.

- `rerror:{escaped text}`: the error result. It could be either a parsing error or an exception.

### Special commands

- Any `server2` command can be prefixed with arguments enclosed in `$...$` and separated by `;`. For example, `$arg1;arg2=value$1+1;;` asks the server to execute the command `1+1;;` with arguments `arg1` (without any value) and `arg2` (with the value `value`). The following arguments are supported:
    
    - `silent` (without value). Suppress automatic `it` binding for top level expressions.

    - `string` (without value). Execute a command which returns a string and return its result.


- `$interrupt` (`server2` only): sends the SIGINT signal to the main thread. This command may be sent
any time (it is not necessary to wait for the `ready` message).

- `#quit` (or `#quit;;`): disconnects a client from the server.
