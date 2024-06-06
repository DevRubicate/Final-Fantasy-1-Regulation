#!/usr/bin/env -S make -f

src ::= $(wildcard src/*.asm src/prg/*.asm src/data/*.asm)
obj ::= $(patsubst src/%.asm,build/%.o,${src})
out ::= build/final_fantasy_1_regulation.nes

CA65 ?= ca65
LD65 ?= ld65
NODE ?= node
CA65FLAGS ::= -I. -g --feature force_range
LD65FLAGS ::= --dbgfile build/final_fantasy_1_regulation.dbg -m build/final_fantasy_1_regulation.map
NODE_SCRIPTS ::= $(wildcard script/*.mjs)

.PHONY: all clean run_node

all: ${out}

clean:
	${RM} ${obj} ${out}

${out}: nes.cfg ${obj}
	@${LD65} ${LD65FLAGS} -o $@ -C $^

run_node: $(NODE_SCRIPTS)

$(NODE_SCRIPTS):
	${NODE} $@

build/%.o: src/%.asm | run_node
	@${CA65} ${CA65FLAGS} $< -o $@ --listing $@.lst --list-bytes 0
