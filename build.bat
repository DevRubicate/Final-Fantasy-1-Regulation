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
ca65 src/bank_10.asm -o build/bank_10.o
ca65 src/bank_11.asm -o build/bank_11.o
ca65 src/bank_12.asm -o build/bank_12.o
ca65 src/bank_13.asm -o build/bank_13.o
ca65 src/bank_14.asm -o build/bank_14.o
ca65 src/bank_15.asm -o build/bank_15.o
ca65 src/bank_16.asm -o build/bank_16.o
ca65 src/bank_17.asm -o build/bank_17.o
ca65 src/bank_18.asm -o build/bank_18.o
ca65 src/bank_19.asm -o build/bank_19.o
ca65 src/bank_1A.asm -o build/bank_1A.o
ca65 src/bank_1B.asm -o build/bank_1B.o
ca65 src/bank_1C.asm -o build/bank_1C.o
ca65 src/bank_1D.asm -o build/bank_1D.o
ca65 src/bank_1E.asm -o build/bank_1E.o
ca65 src/bank_fixed.asm -o build/bank_fixed.o

ld65 -C nes.cfg build/header.o build/bank_00.o build/bank_01.o build/bank_02.o build/bank_03.o build/bank_04.o build/bank_05.o build/bank_06.o build/bank_07.o build/bank_08.o build/bank_09.o build/bank_0A.o build/bank_0B.o build/bank_0C.o build/bank_0D.o build/bank_0E.o build/bank_0F.o build/bank_10.o build/bank_11.o build/bank_12.o build/bank_13.o build/bank_14.o build/bank_15.o build/bank_16.o build/bank_17.o build/bank_18.o build/bank_19.o build/bank_1A.o build/bank_1B.o build/bank_1C.o build/bank_1D.o build/bank_1E.o build/bank_fixed.o -o build/final_fantasy_1_regulation.nes

pause
