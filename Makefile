all: server.cmo test_client.cmo

server.cmo: server.ml
	ocamlc -c -I +compiler-libs unix.cma server.ml

test_client.cmo: test_client.ml
	ocamlc -c unix.cma test_client.ml

clean:
	rm *.cmi *.cmo