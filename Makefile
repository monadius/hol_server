all: server.cmo server2.cmo test_client.cmo

server.cmo: server.ml
	ocamlc -c -I +compiler-libs unix.cma server.ml

server2.cmo: server2.ml
	ocamlc -c -I +compiler-libs -I +threads unix.cma threads.cma server2.ml

test_client.cmo: test_client.ml
	ocamlc -c unix.cma test_client.ml

clean:
	rm -f *.cmi *.cmo *.cma