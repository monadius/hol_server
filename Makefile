all: server.cmo

server.cmo: server.ml
	ocamlc -c -I +compiler-libs unix.cma server.ml

clean:
	rm *.cmi *.cmo