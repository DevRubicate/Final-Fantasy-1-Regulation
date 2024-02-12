ca65 src/header.asm  -o build/header.o
ca65 src/bank_00.asm -o build/bank_00.o
ca65 src/bank_01.asm -o build/bank_01.o
ca65 src/bank_02.asm -o build/bank_02.o
ca65 src/bank_03.asm -o build/bank_03.o
ca65 src/bank_04.asm -o build/bank_04.o
ca65 src/bank_05.asm -o build/bank_05.o
ca65 src/bank_06.asm -o build/bank_06.o
ca65 src/bank_07.asm -o build/bank_07.o
ca65 src/bank_08.asm -o build/bank_08.o
ca65 src/bank_09.asm -o build/bank_09.o
ca65 src/bank_0A.asm -o build/bank_0A.o
ca65 src/bank_0B.asm -o build/bank_0B.o
ca65 src/bank_0C.asm -o build/bank_0C.o
ca65 src/bank_0D.asm -o build/bank_0D.o
ca65 src/bank_0E.asm -o build/bank_0E.o
ca65 src/bank_0F.asm -o build/bank_0F.o

ld65 -C nes.cfg build/header.o build/bank_00.o build/bank_01.o build/bank_02.o build/bank_03.o build/bank_04.o build/bank_05.o build/bank_06.o build/bank_07.o build/bank_08.o build/bank_09.o build/bank_0A.o build/bank_0B.o build/bank_0C.o build/bank_0D.o build/bank_0E.o build/bank_0F.o -o build/final_fantasy_1_regulation.nes

pause
