### A server for executing toplevel HOL Light commands

## Protocol

All result strings are escaped with `String.escaped`.

All input strings should be escaped (they are processed with `Scanf.unescaped`).

- `ready`: the server waits for a command.

- `info:{escaped text}`: information about the server such as the pid of the server process.

- `stdout:{escaped text}`: stdout output.

- `stderr:{escaped text}`: stderr output.

- `result:{escaped text}`: the command result. It could be either int the form `- : type = value` (`val it : type = value` for HOL Light), `Exception: exception`, or `Error: error` (this result is returned when the command cannot be parsed).

### Special commands

- `#quit` (or `#quit;;`): disconnects a client from the server.


