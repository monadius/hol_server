## A server for executing toplevel HOL Light commands

This server is used by the [HOL Light VS Code extension](https://github.com/monadius/vscode-hol-light) to execute HOL Light
commands and get command results.

Clone this repository and run `make` to compile the server code. To start the server inside an active HOL Light REPL, run the following commands:
```
#load "unix.cma";;
#load "{path to the server}/server.cmo";;
Server.start 2012;;
```

(Replace `{path to the server}` with the path where this repository is cloned.)

`2012` is the server port number. You may use any available port number.

## Protocol

All result strings are escaped with `String.escaped`.

All input strings should be escaped (they are processed with `Scanf.unescaped`).

- `ready`: the server waits for a command.

- `info:{escaped text}`: information about the server such as the pid of the server process.

- `stdout:{escaped text}`: stdout output.

- `stderr:{escaped text}`: stderr output.

- `result:{escaped text}`: the command result. It could be either int the form `- : type = value` or `val it : type = value` for HOL Light.

- `rerror:{escaped text}`: the error result. It could be either a parsing error or an exception.

### Special commands

- `#quit` (or `#quit;;`): disconnects a client from the server.


