artwork := $(wildcard artwork/*jpg artwork/*.png)

default: cards-nightmare-king.cdb pics


cards-nightmare-king.cdb: cards/cards.toml cards/sets.toml cards/macro.toml config.toml Makefile
	#mkdir expansions
	cmd.exe /C ygofab make
	cp expansions/* .
	#rmdir expansions

pics: $(artwork) config.toml cards/cards.toml cards/sets.toml cards/macro.toml Makefile
	cmd.exe /C ygofab compose -Pall -Eall
	rm -rf pics/field
	mv pics/EDOPro/* pics/
	rmdir pics/EDOPro