#!/usr/bin/env -S make -f

src ::= $(wildcard src/*.asm)
obj ::= $(patsubst src/%.asm,build/%.o,${src})
out ::= build/final_fantasy_1_regulation.nes

CA65 ?= ca65
LD65 ?= ld65
CA65FLAGS ::= -I.
LD65FLAGS ::= --dbgfile build/final_fantasy_1_regulation.dbg

.PHONY: all clean

all: ${out}

clean:
	${RM} ${obj} ${out}

build/%.o: src/%.asm
	${CA65} ${CA65FLAGS} $< -o $@ --listing $@.lst

${out}: nes.cfg ${obj}
	${LD65} ${LD65FLAGS} -o $@ -C $^ 
