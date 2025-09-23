#!/usr/bin/env -S make -f

src ::= $(wildcard src/*.asm src/prg/*.asm src/data/*.asm)
obj ::= $(patsubst src/%.asm,build/%.o,${src})
out ::= build/final_fantasy_1_regulation.nes
data ::= $(wildcard src/data/*.asm)

CA65 ?= ca65
LD65 ?= ld65
NODE ?= node
CA65FLAGS ::= -I. -g --feature force_range
LD65FLAGS ::= --dbgfile build/final_fantasy_1_regulation.dbg -m build/final_fantasy_1_regulation.map
NODE_SCRIPTS ::= script/data_generator.mjs

.PHONY: all clean run_node test $(NODE_SCRIPTS)

all: ${out}

test:
	${NODE} script/massive_test.mjs

clean:
	@${RM} ${obj} ${out} ${data}

${out}: nes.cfg ${obj} | run_node
	@${LD65} ${LD65FLAGS} -o $@ -C $^

run_node: $(NODE_SCRIPTS)

$(NODE_SCRIPTS):
	${NODE} $@

build/%.o: src/%.asm src/ram.asm src/ram-definitions.inc src/constants.inc src/macros.inc | run_node
	@mkdir -p $(@D)
	@${CA65} ${CA65FLAGS} $< -o $@ --listing $@.lst --list-bytes 0
