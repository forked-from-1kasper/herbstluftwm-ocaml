all:
	ocamlbuild herbstluftd.native battery.native

clean:
	ocamlbuild -clean
