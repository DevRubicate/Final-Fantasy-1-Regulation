.segment "DATA_123"

.include "src/global-import.inc"

.export TEXT_EXAMPLE_EQUIP_LIST, TEXT_MENU_SELECTION, LUT_TILE_CHR, TILECHR_BORDER_EDGE, TILECHR_BORDER_CORNER, TILECHR_BORDER_CONJUNCTION, TILECHR_BORDER_SPLIT, TILECHR_CURSOR_0, TILECHR_CURSOR_1, TILECHR_FONT_PART_0, TILECHR_FONT_PART_1, TILECHR_FONT_PART_2, TILECHR_FONT_PART_3, TILECHR_FONT_PART_4, TILECHR_FONT_PART_5, TILECHR_FONT_PART_6, TILECHR_FONT_PART_7, TILECHR_FONT_PART_8, TILECHR_FONT_PART_9, TILECHR_FONT_PART_10, TILECHR_FONT_PART_11, TILECHR_FONT_PART_12, TILECHR_FONT_PART_13, TILECHR_FONT_PART_14, TILECHR_FONT_PART_15, TILECHR_FONT_PART_16, TILECHR_FONT_PART_17, TILECHR_ICON_PART_0, TILECHR_ICON_PART_1, TILECHR_ICON_PART_2, TILECHR_ICON_PART_3, LUT_TILE_CHR_SIBLING2

; address 0 - 51 (bytes 0 - 51)
TEXT_EXAMPLE_EQUIP_LIST:
.byte $0f, $7e, $13, $36, $33, $32, $7e, $1d, $3b, $33, $36, $28, $7f, $0f, $7e, $13, $36, $33, $32, $7e, $12, $29, $30, $31, $29, $38, $7f, $0f, $7e, $0c, $36, $25, $27, $29, $30, $29, $38, $7f, $7e, $7e, $21, $33, $33, $28, $29, $32, $7e, $0b, $3c, $29, $00

; address 51 - 87 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $13, $1e, $0f, $17, $1d, $7f, $7f, $17, $0b, $11, $13, $0d, $7f, $7f, $21, $0f, $0b, $1a, $19, $18, $7f, $7f, $0b, $1c, $17, $19, $1c, $7f, $7f, $1d, $1e, $0b, $1e, $1f, $1d, $00

; address 87 - 115 (bytes 0 - 28)
LUT_TILE_CHR:
.byte <TILECHR_BORDER_EDGE, <TILECHR_BORDER_CORNER, <TILECHR_BORDER_CONJUNCTION, <TILECHR_BORDER_SPLIT, <TILECHR_CURSOR_0, <TILECHR_CURSOR_1, <TILECHR_FONT_PART_0, <TILECHR_FONT_PART_1, <TILECHR_FONT_PART_2, <TILECHR_FONT_PART_3, <TILECHR_FONT_PART_4, <TILECHR_FONT_PART_5, <TILECHR_FONT_PART_6, <TILECHR_FONT_PART_7, <TILECHR_FONT_PART_8, <TILECHR_FONT_PART_9, <TILECHR_FONT_PART_10, <TILECHR_FONT_PART_11, <TILECHR_FONT_PART_12, <TILECHR_FONT_PART_13, <TILECHR_FONT_PART_14, <TILECHR_FONT_PART_15, <TILECHR_FONT_PART_16, <TILECHR_FONT_PART_17, <TILECHR_ICON_PART_0, <TILECHR_ICON_PART_1, <TILECHR_ICON_PART_2, <TILECHR_ICON_PART_3

; address 115 - 135 (bytes 0 - 20)
TILECHR_BORDER_EDGE:
.byte $5c, $04, $ff, $03, $00, $ff, $80, $07, $80, $fd, $90, $ff, $00, $60, $00, $ff, $80, $e0, $80, $bf

; address 135 - 174 (bytes 0 - 39)
TILECHR_BORDER_CORNER:
.byte $0c, $87, $07, $ff, $fe, $fc, $87, $fa, $06, $fc, $00, $f0, $fc, $fe, $ff, $07, $70, $fc, $06, $fa, $f0, $3f, $7f, $ff, $e0, $70, $3f, $60, $5f, $87, $e0, $ff, $7f, $3f, $87, $5f, $60, $3f, $00

; address 174 - 203 (bytes 0 - 29)
TILECHR_BORDER_CONJUNCTION:
.byte $7d, $a4, $38, $f8, $38, $98, $ef, $0f, $ef, $84, $38, $ff, $83, $ef, $00, $ff, $a4, $38, $3f, $38, $98, $ef, $e0, $ef, $10, $38, $60, $00, $ef

; address 203 - 215 (bytes 0 - 12)
TILECHR_BORDER_SPLIT:
.byte $52, $f0, $80, $38, $80, $ef, $24, $ff, $00, $18, $00, $ff

; address 215 - 263 (bytes 0 - 48)
TILECHR_CURSOR_0:
.byte $0c, $9f, $ff, $ef, $b3, $78, $07, $00, $8e, $7f, $6f, $07, $00, $0f, $07, $78, $bd, $ee, $07, $07, $6e, $7f, $ff, $ba, $f6, $ed, $fa, $f0, $7f, $07, $f8, $bb, $ff, $fe, $fd, $ff, $f8, $00, $1f, $70, $9e, $b5, $6c, $de, $0e, $60, $6a, $fb

; address 263 - 284 (bytes 0 - 21)
TILECHR_CURSOR_1:
.byte $82, $f0, $ff, $c0, $80, $f8, $fc, $06, $02, $fc, $00, $1a, $f8, $fc, $00, $0c, $c0, $e0, $06, $c0, $40

; address 284 - 333 (bytes 0 - 49)
TILECHR_FONT_PART_0:
.byte $5c, $c1, $3e, $7f, $3e, $61, $c3, $99, $c3, $a5, $3e, $1c, $3c, $1c, $63, $c3, $e7, $c7, $e7, $bf, $7f, $3f, $1e, $0f, $77, $7f, $3e, $7f, $81, $cf, $e7, $f3, $f9, $99, $c3, $d5, $3e, $7f, $1f, $7f, $3e, $7f, $c3, $99, $f9, $e3, $f9, $99, $c3

; address 333 - 380 (bytes 0 - 47)
TILECHR_FONT_PART_1:
.byte $1d, $7c, $70, $7c, $7e, $7f, $ff, $5d, $bf, $a7, $a3, $7f, $20, $61, $7f, $ff, $7f, $77, $af, $6f, $45, $7d, $39, $80, $61, $7e, $ff, $76, $77, $bf, $7f, $49, $7b, $32, $89, $5b, $03, $fb, $ff, $1f, $07, $57, $fd, $7d, $0f, $e3, $f8

; address 380 - 427 (bytes 0 - 47)
TILECHR_FONT_PART_2:
.byte $5d, $61, $7e, $ff, $7e, $77, $c9, $80, $b6, $80, $c9, $ff, $61, $6e, $ff, $7e, $77, $d9, $90, $b6, $80, $c1, $ff, $6d, $fe, $ff, $1b, $ff, $fe, $77, $81, $80, $f6, $80, $81, $ff, $4d, $ff, $db, $ff, $7e, $57, $80, $b6, $80, $c9, $ff

; address 427 - 470 (bytes 0 - 43)
TILECHR_FONT_PART_3:
.byte $5d, $6d, $7e, $ff, $c3, $e7, $66, $77, $c1, $80, $be, $9c, $dd, $ff, $4f, $ff, $e7, $ff, $7e, $3c, $5f, $80, $be, $9c, $c1, $e3, $ff, $48, $ff, $db, $51, $80, $b6, $ff, $4a, $ff, $1b, $03, $55, $80, $f6, $fe, $ff

; address 470 - 511 (bytes 0 - 41)
TILECHR_FONT_PART_4:
.byte $5c, $f7, $3e, $7f, $77, $7f, $77, $7f, $3e, $6f, $c3, $99, $91, $9f, $99, $c3, $94, $77, $7f, $77, $4c, $99, $81, $99, $a2, $7f, $1c, $7f, $61, $81, $e7, $81, $e8, $3e, $7f, $77, $07, $68, $c3, $99, $f9

; address 511 - 553 (bytes 0 - 42)
TILECHR_FONT_PART_5:
.byte $5c, $f7, $77, $7f, $7e, $7c, $7e, $7f, $77, $7f, $99, $93, $87, $8f, $87, $93, $99, $a0, $7f, $70, $60, $81, $9f, $91, $e7, $ff, $fe, $4b, $39, $29, $01, $13, $a1, $77, $7f, $77, $5b, $99, $91, $81, $89, $99

; address 553 - 602 (bytes 0 - 49)
TILECHR_FONT_PART_6:
.byte $5c, $e3, $3e, $7f, $77, $7f, $3e, $61, $c3, $99, $c3, $9f, $70, $7e, $7f, $77, $7f, $7e, $4d, $9f, $83, $99, $83, $d3, $3f, $7f, $77, $7f, $3e, $71, $c1, $93, $99, $c3, $ef, $77, $7f, $7e, $7f, $77, $7f, $7e, $7d, $99, $93, $87, $83, $99, $83

; address 602 - 642 (bytes 0 - 40)
TILECHR_FONT_PART_7:
.byte $5c, $ff, $3e, $7f, $77, $3f, $7e, $77, $7f, $3e, $7f, $c3, $99, $f9, $c3, $9f, $99, $c3, $82, $1c, $7f, $41, $e7, $81, $e0, $3e, $7f, $77, $60, $c3, $99, $d8, $1c, $3e, $7f, $77, $68, $e7, $c3, $99

; address 642 - 689 (bytes 0 - 47)
TILECHR_FONT_PART_8:
.byte $5c, $c2, $66, $ff, $e7, $7a, $39, $11, $01, $29, $39, $b6, $77, $7f, $3e, $7f, $77, $5e, $99, $c3, $e7, $c3, $99, $9c, $1c, $3e, $7f, $77, $4c, $e7, $c3, $99, $be, $7f, $78, $3c, $1e, $0f, $7f, $7f, $81, $9f, $cf, $e7, $f3, $f9, $81

; address 689 - 735 (bytes 0 - 46)
TILECHR_FONT_PART_9:
.byte $5c, $d6, $3f, $7f, $3f, $3e, $00, $7e, $c4, $99, $c1, $f9, $c3, $ff, $c6, $7c, $7e, $7c, $70, $66, $87, $93, $87, $9f, $c6, $3c, $7e, $3c, $00, $7e, $c7, $93, $9f, $93, $c7, $ff, $c6, $3e, $7e, $3e, $0e, $66, $c3, $93, $c3, $f3

; address 735 - 783 (bytes 0 - 48)
TILECHR_FONT_PART_10:
.byte $5c, $c6, $3e, $7e, $3c, $00, $7e, $c3, $9f, $83, $9b, $c7, $ff, $ab, $70, $7c, $7e, $3c, $00, $5f, $9f, $87, $9f, $93, $c7, $ff, $f6, $7c, $7e, $3e, $7e, $3e, $00, $7e, $87, $f3, $c3, $93, $c3, $ff, $86, $7e, $7c, $70, $46, $93, $87, $9f

; address 783 - 822 (bytes 0 - 39)
TILECHR_FONT_PART_11:
.byte $5c, $81, $1c, $00, $47, $e7, $ff, $e7, $ff, $d1, $3c, $7e, $0e, $00, $77, $c7, $93, $f3, $ff, $f3, $ff, $aa, $7e, $7c, $7e, $70, $7e, $93, $87, $8f, $87, $93, $9f, $82, $1c, $3c, $41, $e7, $c7

; address 822 - 864 (bytes 0 - 42)
TILECHR_FONT_PART_12:
.byte $5c, $c6, $ce, $fe, $7c, $00, $6e, $73, $53, $03, $a7, $ff, $86, $7e, $7c, $00, $46, $93, $87, $ff, $c6, $3c, $7e, $3c, $00, $66, $c7, $93, $c7, $ff, $b6, $70, $7c, $7e, $7c, $00, $5e, $9f, $87, $93, $87, $ff

; address 864 - 914 (bytes 0 - 50)
TILECHR_FONT_PART_13:
.byte $5d, $69, $18, $3c, $fc, $00, $7a, $f7, $e3, $eb, $83, $ff, $67, $cc, $fc, $dc, $1c, $18, $7f, $bb, $83, $87, $bb, $f3, $f7, $ff, $63, $d8, $fc, $6c, $00, $7e, $b7, $a3, $ab, $8b, $db, $ff, $3b, $0c, $7e, $fe, $cc, $00, $3e, $fb, $c1, $81, $bb, $ff

; address 914 - 957 (bytes 0 - 43)
TILECHR_FONT_PART_14:
.byte $5c, $c2, $3e, $7e, $00, $62, $cb, $93, $ff, $f2, $1c, $3e, $7e, $77, $00, $72, $e7, $c3, $99, $ff, $aa, $7e, $ff, $e7, $00, $7a, $93, $83, $29, $39, $ff, $aa, $7e, $3c, $7e, $00, $7e, $93, $c7, $ef, $c7, $93, $ff

; address 957 - 997 (bytes 0 - 40)
TILECHR_FONT_PART_15:
.byte $5c, $f2, $78, $7c, $3e, $7e, $00, $7a, $8f, $e7, $c3, $93, $ff, $ba, $7e, $78, $3c, $7e, $00, $7e, $83, $9f, $cf, $e7, $83, $ff, $d0, $3c, $1c, $00, $d0, $cf, $e7, $ff, $90, $1c, $00, $50, $e7, $ff

; address 997 - 1042 (bytes 0 - 45)
TILECHR_FONT_PART_16:
.byte $5c, $28, $3e, $00, $18, $c3, $ff, $9f, $1c, $1e, $0f, $77, $7f, $3e, $7f, $e7, $ff, $e7, $f3, $f9, $99, $c3, $80, $1c, $70, $e7, $ff, $e7, $ff, $67, $77, $3f, $1c, $7e, $77, $73, $00, $7f, $b9, $d9, $ef, $f7, $9b, $9d, $ff

; address 1042 - 1086 (bytes 0 - 44)
TILECHR_FONT_PART_17:
.byte $5d, $5b, $3e, $1e, $3e, $1e, $00, $7e, $e9, $f1, $ff, $e9, $f1, $ff, $16, $3e, $1e, $00, $1c, $e9, $f1, $ff, $12, $ee, $00, $14, $99, $ff, $7f, $e0, $f0, $78, $3c, $1e, $0f, $07, $7f, $9f, $cf, $e7, $f3, $f9, $fc, $ff

; address 1086 - 1142 (bytes 0 - 56)
TILECHR_ICON_PART_0:
.byte $5d, $ff, $07, $0f, $1f, $be, $fc, $f8, $f0, $f8, $ff, $fc, $f8, $f1, $63, $87, $cf, $af, $77, $94, $1e, $ff, $1e, $99, $f1, $12, $f1, $ff, $7f, $d8, $f8, $78, $fc, $fe, $1f, $0f, $7f, $b7, $cf, $c7, $a3, $f1, $f8, $ff, $55, $3f, $1e, $ff, $0e, $6f, $e0, $f1, $ff, $00, $ff, $f9

; address 1142 - 1198 (bytes 0 - 56)
TILECHR_ICON_PART_1:
.byte $4c, $ff, $03, $07, $0e, $6c, $fc, $d8, $f8, $70, $fd, $fe, $fd, $fb, $f7, $b7, $6f, $9f, $87, $63, $3f, $3c, $00, $cf, $fd, $bd, $bf, $fd, $d7, $ff, $bb, $7f, $7e, $7f, $ff, $e3, $00, $f7, $a5, $99, $c3, $81, $42, $3c, $ff, $c0, $3f, $7f, $ef, $e3, $dd, $b6, $a2, $b6, $be, $80

; address 1198 - 1245 (bytes 0 - 47)
TILECHR_ICON_PART_2:
.byte $5d, $70, $18, $df, $ff, $6d, $f7, $b2, $82, $02, $45, $37, $3c, $7c, $fc, $f8, $e0, $37, $e3, $c3, $87, $5f, $bf, $7b, $7c, $fe, $e7, $c3, $e7, $fe, $73, $c3, $9d, $3e, $9d, $c3, $cc, $0e, $fe, $fc, $fe, $d5, $f9, $81, $83, $81, $f9

; address 1245 - 1259 (bytes 0 - 14)
TILECHR_ICON_PART_3:
.byte $52, $c0, $ce, $1e, $3f, $1e, $0c, $1e, $ad, $e3, $c1, $e3, $f7, $e3

; address 1259 - 1287 (bytes 0 - 28)
LUT_TILE_CHR_SIBLING2:
.byte >TILECHR_BORDER_EDGE, >TILECHR_BORDER_CORNER, >TILECHR_BORDER_CONJUNCTION, >TILECHR_BORDER_SPLIT, >TILECHR_CURSOR_0, >TILECHR_CURSOR_1, >TILECHR_FONT_PART_0, >TILECHR_FONT_PART_1, >TILECHR_FONT_PART_2, >TILECHR_FONT_PART_3, >TILECHR_FONT_PART_4, >TILECHR_FONT_PART_5, >TILECHR_FONT_PART_6, >TILECHR_FONT_PART_7, >TILECHR_FONT_PART_8, >TILECHR_FONT_PART_9, >TILECHR_FONT_PART_10, >TILECHR_FONT_PART_11, >TILECHR_FONT_PART_12, >TILECHR_FONT_PART_13, >TILECHR_FONT_PART_14, >TILECHR_FONT_PART_15, >TILECHR_FONT_PART_16, >TILECHR_FONT_PART_17, >TILECHR_ICON_PART_0, >TILECHR_ICON_PART_1, >TILECHR_ICON_PART_2, >TILECHR_ICON_PART_3

; 1287 - 8192
.res 6905

