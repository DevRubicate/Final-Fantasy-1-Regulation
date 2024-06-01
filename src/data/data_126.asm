.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_HOLDRESET, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_RETURNLIFE, LUT_TILE_CHR, TILECHR_BORDER_EDGE, TILECHR_BORDER_CORNER, TILECHR_BORDER_CONJUNCTION, TILECHR_BORDER_SPLIT, TILECHR_CURSOR_0, TILECHR_CURSOR_1, TILECHR_FONT_PART_0, TILECHR_FONT_PART_1, TILECHR_FONT_PART_2, TILECHR_FONT_PART_3, TILECHR_FONT_PART_4, TILECHR_FONT_PART_5, TILECHR_FONT_PART_6, TILECHR_FONT_PART_7, TILECHR_FONT_PART_8, TILECHR_FONT_PART_9, TILECHR_FONT_PART_10, TILECHR_FONT_PART_11, TILECHR_FONT_PART_12, TILECHR_FONT_PART_13, TILECHR_FONT_PART_14, TILECHR_FONT_PART_15, LUT_TILE_CHR_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $42, $52, $58, $7f, $4b, $44, $59, $48, $7f, $51, $52, $57, $4b, $4c, $51, $4a, $7f, $57, $52, $5e, $56, $48, $4f, $4f, $7f, $7f, $2a, $51, $5c, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $31, $52, $4f, $47, $7f, $3b, $2e, $3c, $2e, $3d, $7f, $5a, $4b, $4c, $4f, $48, $7f, $5c, $52, $58, $7f, $57, $58, $55, $51, $7f, $39, $38, $40, $2e, $3b, $7f, $52, $49, $49, $64, $64, $00

; address 81 - 110 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $42, $52, $58, $5e, $47, $52, $7f, $51, $52, $57, $7f, $51, $48, $48, $47, $5e, $50, $5c, $7f, $4b, $48, $4f, $53, $7f, $51, $52, $5a, $60, $00

; address 110 - 135 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $40, $2a, $3b, $3b, $32, $38, $3b, $7f, $7f, $3b, $48, $57, $58, $55, $51, $7f, $57, $52, $7f, $4f, $4c, $49, $48, $64, $00

; address 135 - 157 (bytes 0 - 22)
LUT_TILE_CHR:
.byte <TILECHR_BORDER_EDGE, <TILECHR_BORDER_CORNER, <TILECHR_BORDER_CONJUNCTION, <TILECHR_BORDER_SPLIT, <TILECHR_CURSOR_0, <TILECHR_CURSOR_1, <TILECHR_FONT_PART_0, <TILECHR_FONT_PART_1, <TILECHR_FONT_PART_2, <TILECHR_FONT_PART_3, <TILECHR_FONT_PART_4, <TILECHR_FONT_PART_5, <TILECHR_FONT_PART_6, <TILECHR_FONT_PART_7, <TILECHR_FONT_PART_8, <TILECHR_FONT_PART_9, <TILECHR_FONT_PART_10, <TILECHR_FONT_PART_11, <TILECHR_FONT_PART_12, <TILECHR_FONT_PART_13, <TILECHR_FONT_PART_14, <TILECHR_FONT_PART_15

; address 157 - 177 (bytes 0 - 20)
TILECHR_BORDER_EDGE:
.byte $5c, $04, $ff, $03, $00, $ff, $80, $07, $80, $fd, $90, $ff, $00, $60, $00, $ff, $80, $e0, $80, $bf

; address 177 - 216 (bytes 0 - 39)
TILECHR_BORDER_CORNER:
.byte $0c, $87, $07, $ff, $fe, $fc, $87, $fa, $06, $fc, $00, $f0, $fc, $fe, $ff, $07, $70, $fc, $06, $fa, $f0, $3f, $7f, $ff, $e0, $70, $3f, $60, $5f, $87, $e0, $ff, $7f, $3f, $87, $5f, $60, $3f, $00

; address 216 - 245 (bytes 0 - 29)
TILECHR_BORDER_CONJUNCTION:
.byte $7d, $a4, $38, $f8, $38, $98, $ef, $0f, $ef, $84, $38, $ff, $83, $ef, $00, $ff, $a4, $38, $3f, $38, $98, $ef, $e0, $ef, $10, $38, $60, $00, $ef

; address 245 - 257 (bytes 0 - 12)
TILECHR_BORDER_SPLIT:
.byte $52, $f0, $80, $38, $80, $ef, $24, $ff, $00, $18, $00, $ff

; address 257 - 292 (bytes 0 - 35)
TILECHR_CURSOR_0:
.byte $02, $fc, $9c, $7f, $6f, $23, $00, $8e, $7f, $6f, $07, $00, $fe, $ba, $f6, $ec, $f8, $f0, $7f, $00, $bb, $ff, $fe, $fd, $ff, $f8, $00, $0e, $f8, $fc, $00, $1a, $f8, $fc, $00

; address 292 - 312 (bytes 0 - 20)
TILECHR_CURSOR_1:
.byte $02, $f4, $03, $2c, $6e, $07, $07, $6e, $7f, $07, $20, $68, $da, $0e, $60, $6a, $fb, $06, $c0, $40

; address 312 - 361 (bytes 0 - 49)
TILECHR_FONT_PART_0:
.byte $4c, $61, $3c, $66, $3c, $c1, $c1, $80, $c1, $63, $3c, $18, $38, $18, $a5, $c1, $e3, $c3, $e3, $7f, $7e, $30, $18, $0c, $06, $66, $3c, $bf, $80, $c0, $e1, $f0, $88, $80, $c1, $7f, $3c, $66, $06, $1c, $06, $66, $3c, $d5, $c1, $80, $e0, $80, $c1

; address 361 - 408 (bytes 0 - 47)
TILECHR_FONT_PART_1:
.byte $bd, $7c, $8f, $83, $81, $80, $00, $5d, $bf, $a7, $a3, $7f, $20, $61, $80, $00, $80, $77, $af, $6f, $45, $7d, $39, $80, $61, $81, $00, $89, $77, $bf, $7f, $49, $7b, $32, $89, $5b, $fc, $04, $00, $e0, $f8, $57, $fd, $7d, $0f, $e3, $f8

; address 408 - 455 (bytes 0 - 47)
TILECHR_FONT_PART_2:
.byte $5d, $77, $36, $7f, $49, $7f, $36, $00, $61, $81, $00, $81, $77, $26, $6f, $49, $7f, $3e, $00, $61, $91, $00, $81, $77, $7e, $7f, $09, $7f, $7e, $00, $6d, $01, $00, $e4, $00, $01, $57, $7f, $49, $7f, $36, $00, $4d, $00, $24, $00, $81

; address 455 - 498 (bytes 0 - 43)
TILECHR_FONT_PART_3:
.byte $5d, $77, $3e, $7f, $41, $63, $22, $00, $6d, $81, $00, $3c, $18, $99, $5f, $7f, $41, $63, $3e, $1c, $00, $4f, $00, $18, $00, $81, $c3, $51, $7f, $49, $00, $48, $00, $24, $55, $7f, $09, $01, $00, $4a, $00, $e4, $fc

; address 498 - 539 (bytes 0 - 41)
TILECHR_FONT_PART_4:
.byte $4c, $6f, $3c, $66, $6e, $60, $66, $3c, $f7, $c1, $80, $88, $80, $88, $80, $c1, $4c, $66, $7e, $66, $94, $88, $80, $88, $61, $7e, $18, $7e, $a2, $80, $e3, $80, $68, $3c, $66, $06, $e8, $c1, $80, $88, $f8

; address 539 - 581 (bytes 0 - 42)
TILECHR_FONT_PART_5:
.byte $4c, $7f, $66, $6c, $78, $70, $78, $6c, $66, $f7, $88, $80, $81, $83, $81, $80, $88, $60, $7e, $60, $a0, $80, $8f, $4b, $c6, $d6, $fe, $ec, $91, $18, $00, $01, $5b, $66, $6e, $7e, $76, $66, $a1, $88, $80, $88

; address 581 - 630 (bytes 0 - 49)
TILECHR_FONT_PART_6:
.byte $4c, $61, $3c, $66, $3c, $e3, $c1, $80, $88, $80, $c1, $4d, $60, $7c, $66, $7c, $9f, $8f, $81, $80, $88, $80, $81, $71, $3e, $6c, $66, $3c, $d3, $c0, $80, $88, $80, $c1, $7d, $66, $6c, $78, $7c, $66, $7c, $ef, $88, $80, $81, $80, $88, $80, $81

; address 630 - 670 (bytes 0 - 40)
TILECHR_FONT_PART_7:
.byte $4c, $7f, $3c, $66, $06, $3c, $60, $66, $3c, $ff, $c1, $80, $88, $c0, $81, $88, $80, $c1, $41, $18, $7e, $82, $e3, $80, $60, $3c, $66, $e0, $c1, $80, $88, $68, $18, $3c, $66, $d8, $e3, $c1, $80, $88

; address 670 - 717 (bytes 0 - 47)
TILECHR_FONT_PART_8:
.byte $4c, $7a, $c6, $ee, $fe, $d6, $c6, $c2, $99, $00, $18, $5e, $66, $3c, $18, $3c, $66, $b6, $88, $80, $c1, $80, $88, $4c, $18, $3c, $66, $9c, $e3, $c1, $80, $88, $7f, $7e, $60, $30, $18, $0c, $06, $7e, $be, $80, $87, $c3, $e1, $f0, $80

; address 717 - 763 (bytes 0 - 46)
TILECHR_FONT_PART_9:
.byte $4c, $7e, $3b, $66, $3e, $06, $3c, $00, $d6, $c0, $80, $c0, $c1, $ff, $66, $78, $6c, $78, $60, $c6, $83, $81, $83, $8f, $7e, $38, $6c, $60, $6c, $38, $00, $c6, $c3, $81, $c3, $ff, $66, $3c, $6c, $3c, $0c, $c6, $c1, $81, $c1, $f1

; address 763 - 811 (bytes 0 - 48)
TILECHR_FONT_PART_10:
.byte $4c, $7e, $3c, $60, $7c, $64, $38, $00, $c6, $c1, $81, $c3, $ff, $5f, $60, $78, $60, $6c, $38, $00, $ab, $8f, $83, $81, $c3, $ff, $7e, $78, $0c, $3c, $6c, $3c, $00, $f6, $83, $81, $c1, $81, $c1, $ff, $46, $6c, $78, $60, $86, $81, $83, $8f

; address 811 - 850 (bytes 0 - 39)
TILECHR_FONT_PART_11:
.byte $4c, $47, $18, $00, $18, $00, $81, $e3, $ff, $77, $38, $6c, $0c, $00, $0c, $00, $d1, $c3, $81, $f1, $ff, $7e, $6c, $78, $70, $78, $6c, $60, $aa, $81, $83, $81, $8f, $41, $18, $38, $82, $e3, $c3

; address 850 - 892 (bytes 0 - 42)
TILECHR_FONT_PART_12:
.byte $4c, $6e, $8c, $ac, $fc, $58, $00, $c6, $31, $01, $83, $ff, $46, $6c, $78, $00, $86, $81, $83, $ff, $66, $38, $6c, $38, $00, $c6, $c3, $81, $c3, $ff, $5e, $60, $78, $6c, $78, $00, $b6, $8f, $83, $81, $83, $ff

; address 892 - 942 (bytes 0 - 50)
TILECHR_FONT_PART_13:
.byte $5d, $7a, $08, $1c, $14, $7c, $00, $69, $e7, $c3, $03, $ff, $7f, $44, $7c, $78, $44, $0c, $08, $00, $67, $33, $03, $23, $e3, $e7, $7e, $48, $5c, $54, $74, $24, $00, $63, $27, $03, $93, $ff, $3e, $04, $3e, $7e, $44, $00, $3b, $f3, $81, $01, $33, $ff

; address 942 - 985 (bytes 0 - 43)
TILECHR_FONT_PART_14:
.byte $4c, $62, $34, $6c, $00, $c2, $c1, $81, $ff, $72, $18, $3c, $66, $00, $f2, $e3, $c1, $81, $88, $ff, $7a, $6c, $7c, $d6, $c6, $00, $aa, $81, $00, $18, $ff, $7e, $6c, $38, $10, $38, $6c, $00, $aa, $81, $c3, $81, $ff

; address 985 - 1012 (bytes 0 - 27)
TILECHR_FONT_PART_15:
.byte $52, $f0, $7a, $70, $18, $3c, $6c, $00, $f2, $87, $83, $c1, $81, $ff, $7e, $7c, $60, $30, $18, $7c, $00, $ba, $81, $87, $c3, $81, $ff

; address 1012 - 1034 (bytes 0 - 22)
LUT_TILE_CHR_SIBLING2:
.byte >TILECHR_BORDER_EDGE, >TILECHR_BORDER_CORNER, >TILECHR_BORDER_CONJUNCTION, >TILECHR_BORDER_SPLIT, >TILECHR_CURSOR_0, >TILECHR_CURSOR_1, >TILECHR_FONT_PART_0, >TILECHR_FONT_PART_1, >TILECHR_FONT_PART_2, >TILECHR_FONT_PART_3, >TILECHR_FONT_PART_4, >TILECHR_FONT_PART_5, >TILECHR_FONT_PART_6, >TILECHR_FONT_PART_7, >TILECHR_FONT_PART_8, >TILECHR_FONT_PART_9, >TILECHR_FONT_PART_10, >TILECHR_FONT_PART_11, >TILECHR_FONT_PART_12, >TILECHR_FONT_PART_13, >TILECHR_FONT_PART_14, >TILECHR_FONT_PART_15

; 1034 - 8192
.res 7158

