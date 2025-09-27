#!/usr/bin/env -S make -f

src ::= $(wildcard src/*.asm src/prg/*.asm src/data/*.asm)
obj ::= $(patsubst src/%.asm,build/%.o,${src})
out ::= build/final_fantasy_1_regulation.nes
data ::= $(wildcard src/data/*.asm)

CA65 ?= ca65
LD65 ?= ld65
DENO ?= deno
CA65FLAGS ::= -I. -g --feature force_range
LD65FLAGS ::= --dbgfile build/final_fantasy_1_regulation.dbg -m build/final_fantasy_1_regulation.map

.PHONY: all clean run_deno test compress compress-crab compress-crab-debug

all: ${out}

# Main test target (now uses Deno)
test:
	${DENO} task test

# Compression targets
compress:
	${DENO} task compress $(FILE) $(PROFILE)

compress-crab:
	${DENO} task compress data/chr/crab.massive.png

compress-crab-debug:
	${DENO} task compress data/chr/crab.massive.png

# Data generation (now uses Deno)
generate:
	${DENO} task generate

clean:
	@${RM} ${obj} ${out} ${data}

${out}: nes.cfg ${obj} | run_deno
	@${LD65} ${LD65FLAGS} -o $@ -C $^

# Data generation dependency (now uses Deno)
run_deno:
	${DENO} task generate

build/%.o: src/%.asm src/ram.asm src/ram-definitions.inc src/constants.inc src/macros.inc | run_deno
	@mkdir -p $(@D)
	@${CA65} ${CA65FLAGS} $< -o $@ --listing $@.lst --list-bytes 0