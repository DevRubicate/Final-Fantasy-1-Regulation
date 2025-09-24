.segment "DATA_115"

.include "src/global-import.inc"

.export LUT_TILE_CHR_LO, LUT_TILE_CHR_HI, TILECHR_TILE_BORDER_EDGE, TILECHR_TILE_BORDER_CORNER, TILECHR_TILE_BORDER_CONJUNCTION, TILECHR_TILE_BORDER_SPLIT, TILECHR_TILE_CURSOR_0, TILECHR_TILE_CURSOR_1, TILECHR_TILE_FONT_PART_0, TILECHR_TILE_FONT_PART_1, TILECHR_TILE_FONT_PART_2, TILECHR_TILE_FONT_PART_3, TILECHR_TILE_FONT_PART_4, TILECHR_TILE_FONT_PART_5, TILECHR_TILE_FONT_PART_6, TILECHR_TILE_FONT_PART_7, TILECHR_TILE_FONT_PART_8, TILECHR_TILE_FONT_PART_9, TILECHR_TILE_FONT_PART_10, TILECHR_TILE_FONT_PART_11, TILECHR_TILE_FONT_PART_12, TILECHR_TILE_FONT_PART_13, TILECHR_TILE_FONT_PART_14, TILECHR_TILE_FONT_PART_15, TILECHR_TILE_FONT_PART_16, TILECHR_TILE_FONT_PART_17, TILECHR_TILE_BLACK_BELT_0, TILECHR_TILE_BLACK_BELT_1, TILECHR_TILE_BLACK_BELT_2, TILECHR_TILE_BLACK_BELT_3, TILECHR_TILE_BLACK_BELT_4, TILECHR_TILE_BLACK_BELT_5, TILECHR_TILE_BLACK_BELT_6, TILECHR_TILE_BLACK_BELT_7, TILECHR_TILE_BLACK_BELT_8, TILECHR_TILE_BLACK_BELT_9, TILECHR_TILE_BLACK_BELT_10, TILECHR_TILE_BLACK_MAGE_0, TILECHR_TILE_BLACK_MAGE_1, TILECHR_TILE_BLACK_MAGE_2, TILECHR_TILE_BLACK_MAGE_3, TILECHR_TILE_BLACK_MAGE_4, TILECHR_TILE_BLACK_MAGE_5, TILECHR_TILE_BLACK_MAGE_6, TILECHR_TILE_BLACK_MAGE_7, TILECHR_TILE_BLACK_MAGE_8, TILECHR_TILE_BLACK_MAGE_9, TILECHR_TILE_BLACK_MAGE_10, TILECHR_TILE_FIGHTER_0, TILECHR_TILE_FIGHTER_1, TILECHR_TILE_FIGHTER_2, TILECHR_TILE_FIGHTER_3, TILECHR_TILE_FIGHTER_4, TILECHR_TILE_FIGHTER_5, TILECHR_TILE_FIGHTER_6, TILECHR_TILE_FIGHTER_7, TILECHR_TILE_FIGHTER_8, TILECHR_TILE_FIGHTER_9, TILECHR_TILE_FIGHTER_10, TILECHR_TILE_RED_MAGE_0, TILECHR_TILE_RED_MAGE_1, TILECHR_TILE_RED_MAGE_2, TILECHR_TILE_RED_MAGE_3, TILECHR_TILE_RED_MAGE_4, TILECHR_TILE_RED_MAGE_5, TILECHR_TILE_RED_MAGE_6, TILECHR_TILE_RED_MAGE_7, TILECHR_TILE_RED_MAGE_8, TILECHR_TILE_RED_MAGE_9, TILECHR_TILE_RED_MAGE_10, TILECHR_TILE_THIEF_0, TILECHR_TILE_THIEF_1, TILECHR_TILE_THIEF_2, TILECHR_TILE_THIEF_3, TILECHR_TILE_THIEF_4, TILECHR_TILE_THIEF_5, TILECHR_TILE_THIEF_6, TILECHR_TILE_THIEF_7, TILECHR_TILE_THIEF_8, TILECHR_TILE_THIEF_9, TILECHR_TILE_THIEF_10, TILECHR_TILE_WHITE_MAGE_0, TILECHR_TILE_WHITE_MAGE_1, TILECHR_TILE_WHITE_MAGE_2, TILECHR_TILE_WHITE_MAGE_3, TILECHR_TILE_WHITE_MAGE_4, TILECHR_TILE_WHITE_MAGE_5, TILECHR_TILE_WHITE_MAGE_6, TILECHR_TILE_WHITE_MAGE_7, TILECHR_TILE_WHITE_MAGE_8, TILECHR_TILE_WHITE_MAGE_9, TILECHR_TILE_WHITE_MAGE_10, TILECHR_TILE_ICON_PART_0, TILECHR_TILE_ICON_PART_1, TILECHR_TILE_ICON_PART_2, TILECHR_TILE_ICON_PART_3, TILECHR_MAP_TILE_GRASS_0, TILECHR_MAP_TILE_GRASS_1, TILECHR_MAP_TILE_GRASS_2, TILECHR_MAP_TILE_GRASS_3, TILECHR_MAP_TILE_4, TILECHR_MAP_TILE_5, TILECHR_MAP_TILE_6, TILECHR_MAP_TILE_7, TILECHR_MAP_TILE_8, TILECHR_MAP_TILE_9, TILECHR_MAP_TILE_10, TILECHR_MAP_TILE_11, TILECHR_MAP_TILE_12, TILECHR_MAP_TILE_13, TILECHR_MAP_TILE_14, TILECHR_MAP_TILE_15, TILECHR_MAP_TILE_16, TILECHR_MAP_TILE_17, TILECHR_MAP_TILE_18, TILECHR_MAP_TILE_19, TILECHR_MAP_TILE_20, TILECHR_MAP_TILE_21, TILECHR_MAP_TILE_22, TILECHR_MAP_TILE_23, TILECHR_MAP_TILE_24, TILECHR_MAP_TILE_25, TILECHR_MAP_TILE_26, TILECHR_MAP_TILE_27, TILECHR_MAP_TILE_28, TILECHR_MAP_TILE_29, TILECHR_MAP_TILE_30, TILECHR_MAP_TILE_31

; address 0 - 256 (bytes 256 - 512)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $0a, $21, $12, $08, $a3, $14, $5c, $64, $2f, $0e, $09, $8f, $50, $87, $48, $95, $c2, $a2, $c4, $80, $b2, $e1, $59, $1c, $a8, $c6, $4a, $2b, $14, $05, $e0, $85, $71, $28, $b9, $64, $3d, $11, $4b, $00, $78, $4b, $90, $66, $c4, $bc, $23, $2e, $29, $82, $48, $ea, $41, $78, $92, $dc, $1c, $20, $c9, $80, $41, $e4, $62, $12, $3c, $08, $ce, $0e, $63, $2b, $13, $45, $dc, $22, $f3, $6b, $9b, $73, $32, $d2, $a5, $44, $64, $21, $94, $08, $48, $50, $62, $88, $bc, $07, $36, $e8, $2a, $d8, $3c, $f0, $42, $a4, $fd, $00, $85, $21, $e4, $80, $79, $68, $0f, $d0, $03, $e2, $a4, $45, $f6, $0b, $b2, $9d, $40, $63, $02, $20, $07, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $26, $c0, $21, $21, $25, $81, $ee, $ba, $9e, $dc, $55, $de, $9e, $ec, $b9, $dd, $cc, $ce, $97, $dd, $50, $e6, $c0, $04, $26, $09, $9d, $88, $53, $e0, $2a, $ec, $1a, $78, $c1, $6c, $b8, $0e, $73, $9c, $e7, $39, $e4, $00, $5c, $00, $42, $00, $bc, $40, $8c, $64, $2e, $b9, $17, $84, $8d, $84, $52, $43, $08, $26, $f1, $04, $98, $a1, $31, $24, $bc, $42, $66, $23, $15, $04, $c4, $15, $10, $3a, $09, $34, $2c, $3c, $62, $18, $78, $14, $90, $0c, $88, $28, $49, $82, $48, $53, $50, $0a, $c8, $b5, $64, $a4, $b8, $f8, $4d, $0c, $2c, $96, $13, $17

; address 256 - 382 (bytes 0 - 126)
LUT_TILE_CHR_LO:
.byte <TILECHR_TILE_BORDER_EDGE, <TILECHR_TILE_BORDER_CORNER, <TILECHR_TILE_BORDER_CONJUNCTION, <TILECHR_TILE_BORDER_SPLIT, <TILECHR_TILE_CURSOR_0, <TILECHR_TILE_CURSOR_1, <TILECHR_TILE_FONT_PART_0, <TILECHR_TILE_FONT_PART_1, <TILECHR_TILE_FONT_PART_2, <TILECHR_TILE_FONT_PART_3, <TILECHR_TILE_FONT_PART_4, <TILECHR_TILE_FONT_PART_5, <TILECHR_TILE_FONT_PART_6, <TILECHR_TILE_FONT_PART_7, <TILECHR_TILE_FONT_PART_8, <TILECHR_TILE_FONT_PART_9, <TILECHR_TILE_FONT_PART_10, <TILECHR_TILE_FONT_PART_11, <TILECHR_TILE_FONT_PART_12, <TILECHR_TILE_FONT_PART_13, <TILECHR_TILE_FONT_PART_14, <TILECHR_TILE_FONT_PART_15, <TILECHR_TILE_FONT_PART_16, <TILECHR_TILE_FONT_PART_17, <TILECHR_TILE_BLACK_BELT_0, <TILECHR_TILE_BLACK_BELT_1, <TILECHR_TILE_BLACK_BELT_2, <TILECHR_TILE_BLACK_BELT_3, <TILECHR_TILE_BLACK_BELT_4, <TILECHR_TILE_BLACK_BELT_5, <TILECHR_TILE_BLACK_BELT_6, <TILECHR_TILE_BLACK_BELT_7, <TILECHR_TILE_BLACK_BELT_8, <TILECHR_TILE_BLACK_BELT_9, <TILECHR_TILE_BLACK_BELT_10, <TILECHR_TILE_BLACK_MAGE_0, <TILECHR_TILE_BLACK_MAGE_1, <TILECHR_TILE_BLACK_MAGE_2, <TILECHR_TILE_BLACK_MAGE_3, <TILECHR_TILE_BLACK_MAGE_4, <TILECHR_TILE_BLACK_MAGE_5, <TILECHR_TILE_BLACK_MAGE_6, <TILECHR_TILE_BLACK_MAGE_7, <TILECHR_TILE_BLACK_MAGE_8, <TILECHR_TILE_BLACK_MAGE_9, <TILECHR_TILE_BLACK_MAGE_10, <TILECHR_TILE_FIGHTER_0, <TILECHR_TILE_FIGHTER_1, <TILECHR_TILE_FIGHTER_2, <TILECHR_TILE_FIGHTER_3, <TILECHR_TILE_FIGHTER_4, <TILECHR_TILE_FIGHTER_5, <TILECHR_TILE_FIGHTER_6, <TILECHR_TILE_FIGHTER_7, <TILECHR_TILE_FIGHTER_8, <TILECHR_TILE_FIGHTER_9, <TILECHR_TILE_FIGHTER_10, <TILECHR_TILE_RED_MAGE_0, <TILECHR_TILE_RED_MAGE_1, <TILECHR_TILE_RED_MAGE_2, <TILECHR_TILE_RED_MAGE_3, <TILECHR_TILE_RED_MAGE_4, <TILECHR_TILE_RED_MAGE_5, <TILECHR_TILE_RED_MAGE_6, <TILECHR_TILE_RED_MAGE_7, <TILECHR_TILE_RED_MAGE_8, <TILECHR_TILE_RED_MAGE_9, <TILECHR_TILE_RED_MAGE_10, <TILECHR_TILE_THIEF_0, <TILECHR_TILE_THIEF_1, <TILECHR_TILE_THIEF_2, <TILECHR_TILE_THIEF_3, <TILECHR_TILE_THIEF_4, <TILECHR_TILE_THIEF_5, <TILECHR_TILE_THIEF_6, <TILECHR_TILE_THIEF_7, <TILECHR_TILE_THIEF_8, <TILECHR_TILE_THIEF_9, <TILECHR_TILE_THIEF_10, <TILECHR_TILE_WHITE_MAGE_0, <TILECHR_TILE_WHITE_MAGE_1, <TILECHR_TILE_WHITE_MAGE_2, <TILECHR_TILE_WHITE_MAGE_3, <TILECHR_TILE_WHITE_MAGE_4, <TILECHR_TILE_WHITE_MAGE_5, <TILECHR_TILE_WHITE_MAGE_6, <TILECHR_TILE_WHITE_MAGE_7, <TILECHR_TILE_WHITE_MAGE_8, <TILECHR_TILE_WHITE_MAGE_9, <TILECHR_TILE_WHITE_MAGE_10, <TILECHR_TILE_ICON_PART_0, <TILECHR_TILE_ICON_PART_1, <TILECHR_TILE_ICON_PART_2, <TILECHR_TILE_ICON_PART_3, <TILECHR_MAP_TILE_GRASS_0, <TILECHR_MAP_TILE_GRASS_1, <TILECHR_MAP_TILE_GRASS_2, <TILECHR_MAP_TILE_GRASS_3, <TILECHR_MAP_TILE_4, <TILECHR_MAP_TILE_5, <TILECHR_MAP_TILE_6, <TILECHR_MAP_TILE_7, <TILECHR_MAP_TILE_8, <TILECHR_MAP_TILE_9, <TILECHR_MAP_TILE_10, <TILECHR_MAP_TILE_11, <TILECHR_MAP_TILE_12, <TILECHR_MAP_TILE_13, <TILECHR_MAP_TILE_14, <TILECHR_MAP_TILE_15, <TILECHR_MAP_TILE_16, <TILECHR_MAP_TILE_17, <TILECHR_MAP_TILE_18, <TILECHR_MAP_TILE_19, <TILECHR_MAP_TILE_20, <TILECHR_MAP_TILE_21, <TILECHR_MAP_TILE_22, <TILECHR_MAP_TILE_23, <TILECHR_MAP_TILE_24, <TILECHR_MAP_TILE_25, <TILECHR_MAP_TILE_26, <TILECHR_MAP_TILE_27, <TILECHR_MAP_TILE_28, <TILECHR_MAP_TILE_29, <TILECHR_MAP_TILE_30, <TILECHR_MAP_TILE_31

; address 382 - 508 (bytes 0 - 126)
LUT_TILE_CHR_HI:
.byte >TILECHR_TILE_BORDER_EDGE, >TILECHR_TILE_BORDER_CORNER, >TILECHR_TILE_BORDER_CONJUNCTION, >TILECHR_TILE_BORDER_SPLIT, >TILECHR_TILE_CURSOR_0, >TILECHR_TILE_CURSOR_1, >TILECHR_TILE_FONT_PART_0, >TILECHR_TILE_FONT_PART_1, >TILECHR_TILE_FONT_PART_2, >TILECHR_TILE_FONT_PART_3, >TILECHR_TILE_FONT_PART_4, >TILECHR_TILE_FONT_PART_5, >TILECHR_TILE_FONT_PART_6, >TILECHR_TILE_FONT_PART_7, >TILECHR_TILE_FONT_PART_8, >TILECHR_TILE_FONT_PART_9, >TILECHR_TILE_FONT_PART_10, >TILECHR_TILE_FONT_PART_11, >TILECHR_TILE_FONT_PART_12, >TILECHR_TILE_FONT_PART_13, >TILECHR_TILE_FONT_PART_14, >TILECHR_TILE_FONT_PART_15, >TILECHR_TILE_FONT_PART_16, >TILECHR_TILE_FONT_PART_17, >TILECHR_TILE_BLACK_BELT_0, >TILECHR_TILE_BLACK_BELT_1, >TILECHR_TILE_BLACK_BELT_2, >TILECHR_TILE_BLACK_BELT_3, >TILECHR_TILE_BLACK_BELT_4, >TILECHR_TILE_BLACK_BELT_5, >TILECHR_TILE_BLACK_BELT_6, >TILECHR_TILE_BLACK_BELT_7, >TILECHR_TILE_BLACK_BELT_8, >TILECHR_TILE_BLACK_BELT_9, >TILECHR_TILE_BLACK_BELT_10, >TILECHR_TILE_BLACK_MAGE_0, >TILECHR_TILE_BLACK_MAGE_1, >TILECHR_TILE_BLACK_MAGE_2, >TILECHR_TILE_BLACK_MAGE_3, >TILECHR_TILE_BLACK_MAGE_4, >TILECHR_TILE_BLACK_MAGE_5, >TILECHR_TILE_BLACK_MAGE_6, >TILECHR_TILE_BLACK_MAGE_7, >TILECHR_TILE_BLACK_MAGE_8, >TILECHR_TILE_BLACK_MAGE_9, >TILECHR_TILE_BLACK_MAGE_10, >TILECHR_TILE_FIGHTER_0, >TILECHR_TILE_FIGHTER_1, >TILECHR_TILE_FIGHTER_2, >TILECHR_TILE_FIGHTER_3, >TILECHR_TILE_FIGHTER_4, >TILECHR_TILE_FIGHTER_5, >TILECHR_TILE_FIGHTER_6, >TILECHR_TILE_FIGHTER_7, >TILECHR_TILE_FIGHTER_8, >TILECHR_TILE_FIGHTER_9, >TILECHR_TILE_FIGHTER_10, >TILECHR_TILE_RED_MAGE_0, >TILECHR_TILE_RED_MAGE_1, >TILECHR_TILE_RED_MAGE_2, >TILECHR_TILE_RED_MAGE_3, >TILECHR_TILE_RED_MAGE_4, >TILECHR_TILE_RED_MAGE_5, >TILECHR_TILE_RED_MAGE_6, >TILECHR_TILE_RED_MAGE_7, >TILECHR_TILE_RED_MAGE_8, >TILECHR_TILE_RED_MAGE_9, >TILECHR_TILE_RED_MAGE_10, >TILECHR_TILE_THIEF_0, >TILECHR_TILE_THIEF_1, >TILECHR_TILE_THIEF_2, >TILECHR_TILE_THIEF_3, >TILECHR_TILE_THIEF_4, >TILECHR_TILE_THIEF_5, >TILECHR_TILE_THIEF_6, >TILECHR_TILE_THIEF_7, >TILECHR_TILE_THIEF_8, >TILECHR_TILE_THIEF_9, >TILECHR_TILE_THIEF_10, >TILECHR_TILE_WHITE_MAGE_0, >TILECHR_TILE_WHITE_MAGE_1, >TILECHR_TILE_WHITE_MAGE_2, >TILECHR_TILE_WHITE_MAGE_3, >TILECHR_TILE_WHITE_MAGE_4, >TILECHR_TILE_WHITE_MAGE_5, >TILECHR_TILE_WHITE_MAGE_6, >TILECHR_TILE_WHITE_MAGE_7, >TILECHR_TILE_WHITE_MAGE_8, >TILECHR_TILE_WHITE_MAGE_9, >TILECHR_TILE_WHITE_MAGE_10, >TILECHR_TILE_ICON_PART_0, >TILECHR_TILE_ICON_PART_1, >TILECHR_TILE_ICON_PART_2, >TILECHR_TILE_ICON_PART_3, >TILECHR_MAP_TILE_GRASS_0, >TILECHR_MAP_TILE_GRASS_1, >TILECHR_MAP_TILE_GRASS_2, >TILECHR_MAP_TILE_GRASS_3, >TILECHR_MAP_TILE_4, >TILECHR_MAP_TILE_5, >TILECHR_MAP_TILE_6, >TILECHR_MAP_TILE_7, >TILECHR_MAP_TILE_8, >TILECHR_MAP_TILE_9, >TILECHR_MAP_TILE_10, >TILECHR_MAP_TILE_11, >TILECHR_MAP_TILE_12, >TILECHR_MAP_TILE_13, >TILECHR_MAP_TILE_14, >TILECHR_MAP_TILE_15, >TILECHR_MAP_TILE_16, >TILECHR_MAP_TILE_17, >TILECHR_MAP_TILE_18, >TILECHR_MAP_TILE_19, >TILECHR_MAP_TILE_20, >TILECHR_MAP_TILE_21, >TILECHR_MAP_TILE_22, >TILECHR_MAP_TILE_23, >TILECHR_MAP_TILE_24, >TILECHR_MAP_TILE_25, >TILECHR_MAP_TILE_26, >TILECHR_MAP_TILE_27, >TILECHR_MAP_TILE_28, >TILECHR_MAP_TILE_29, >TILECHR_MAP_TILE_30, >TILECHR_MAP_TILE_31

; address 508 - 528 (bytes 0 - 20)
TILECHR_TILE_BORDER_EDGE:
.byte $5c, $04, $ff, $03, $00, $ff, $80, $07, $80, $fd, $90, $ff, $00, $60, $00, $ff, $80, $e0, $80, $bf

; address 528 - 567 (bytes 0 - 39)
TILECHR_TILE_BORDER_CORNER:
.byte $0c, $87, $07, $ff, $fe, $fc, $87, $fa, $06, $fc, $00, $f0, $fc, $fe, $ff, $07, $70, $fc, $06, $fa, $f0, $3f, $7f, $ff, $e0, $70, $3f, $60, $5f, $87, $e0, $ff, $7f, $3f, $87, $5f, $60, $3f, $00

; address 567 - 596 (bytes 0 - 29)
TILECHR_TILE_BORDER_CONJUNCTION:
.byte $7d, $a4, $38, $f8, $38, $98, $ef, $0f, $ef, $84, $38, $ff, $83, $ef, $00, $ff, $a4, $38, $3f, $38, $98, $ef, $e0, $ef, $10, $38, $60, $00, $ef

; address 596 - 608 (bytes 0 - 12)
TILECHR_TILE_BORDER_SPLIT:
.byte $52, $f0, $80, $38, $80, $ef, $24, $ff, $00, $18, $00, $ff

; address 608 - 656 (bytes 0 - 48)
TILECHR_TILE_CURSOR_0:
.byte $0c, $9f, $ff, $ef, $b3, $78, $07, $00, $8e, $7f, $6f, $07, $00, $0f, $07, $78, $bd, $ee, $07, $07, $6e, $7f, $ff, $ba, $f6, $ed, $fa, $f0, $7f, $07, $f8, $bb, $ff, $fe, $fd, $ff, $f8, $00, $1f, $70, $9e, $b5, $6c, $de, $0e, $60, $6a, $fb

; address 656 - 677 (bytes 0 - 21)
TILECHR_TILE_CURSOR_1:
.byte $82, $f0, $ff, $c0, $80, $f8, $fc, $06, $02, $fc, $00, $1a, $f8, $fc, $00, $0c, $c0, $e0, $06, $c0, $40

; address 677 - 726 (bytes 0 - 49)
TILECHR_TILE_FONT_PART_0:
.byte $5c, $c1, $3e, $7f, $3e, $61, $c3, $99, $c3, $a5, $3e, $1c, $3c, $1c, $63, $c3, $e7, $c7, $e7, $bf, $7f, $3f, $1e, $0f, $77, $7f, $3e, $7f, $81, $cf, $e7, $f3, $f9, $99, $c3, $d5, $3e, $7f, $1f, $7f, $3e, $7f, $c3, $99, $f9, $e3, $f9, $99, $c3

; address 726 - 773 (bytes 0 - 47)
TILECHR_TILE_FONT_PART_1:
.byte $1d, $7c, $70, $7c, $7e, $7f, $ff, $5d, $bf, $a7, $a3, $7f, $20, $61, $7f, $ff, $7f, $77, $af, $6f, $45, $7d, $39, $80, $61, $7e, $ff, $76, $77, $bf, $7f, $49, $7b, $32, $89, $5b, $03, $fb, $ff, $1f, $07, $57, $fd, $7d, $0f, $e3, $f8

; address 773 - 820 (bytes 0 - 47)
TILECHR_TILE_FONT_PART_2:
.byte $5d, $61, $7e, $ff, $7e, $77, $c9, $80, $b6, $80, $c9, $ff, $61, $6e, $ff, $7e, $77, $d9, $90, $b6, $80, $c1, $ff, $6d, $fe, $ff, $1b, $ff, $fe, $77, $81, $80, $f6, $80, $81, $ff, $4d, $ff, $db, $ff, $7e, $57, $80, $b6, $80, $c9, $ff

; address 820 - 863 (bytes 0 - 43)
TILECHR_TILE_FONT_PART_3:
.byte $5d, $6d, $7e, $ff, $c3, $e7, $66, $77, $c1, $80, $be, $9c, $dd, $ff, $4f, $ff, $e7, $ff, $7e, $3c, $5f, $80, $be, $9c, $c1, $e3, $ff, $48, $ff, $db, $51, $80, $b6, $ff, $4a, $ff, $1b, $03, $55, $80, $f6, $fe, $ff

; address 863 - 904 (bytes 0 - 41)
TILECHR_TILE_FONT_PART_4:
.byte $5c, $f7, $3e, $7f, $77, $7f, $77, $7f, $3e, $6f, $c3, $99, $91, $9f, $99, $c3, $94, $77, $7f, $77, $4c, $99, $81, $99, $a2, $7f, $1c, $7f, $61, $81, $e7, $81, $e8, $3e, $7f, $77, $07, $68, $c3, $99, $f9

; address 904 - 946 (bytes 0 - 42)
TILECHR_TILE_FONT_PART_5:
.byte $5c, $f7, $77, $7f, $7e, $7c, $7e, $7f, $77, $7f, $99, $93, $87, $8f, $87, $93, $99, $a0, $7f, $70, $60, $81, $9f, $91, $e7, $ff, $fe, $4b, $39, $29, $01, $13, $a1, $77, $7f, $77, $5b, $99, $91, $81, $89, $99

; address 946 - 995 (bytes 0 - 49)
TILECHR_TILE_FONT_PART_6:
.byte $5c, $e3, $3e, $7f, $77, $7f, $3e, $61, $c3, $99, $c3, $9f, $70, $7e, $7f, $77, $7f, $7e, $4d, $9f, $83, $99, $83, $d3, $3f, $7f, $77, $7f, $3e, $71, $c1, $93, $99, $c3, $ef, $77, $7f, $7e, $7f, $77, $7f, $7e, $7d, $99, $93, $87, $83, $99, $83

; address 995 - 1035 (bytes 0 - 40)
TILECHR_TILE_FONT_PART_7:
.byte $5c, $ff, $3e, $7f, $77, $3f, $7e, $77, $7f, $3e, $7f, $c3, $99, $f9, $c3, $9f, $99, $c3, $82, $1c, $7f, $41, $e7, $81, $e0, $3e, $7f, $77, $60, $c3, $99, $d8, $1c, $3e, $7f, $77, $68, $e7, $c3, $99

; address 1035 - 1082 (bytes 0 - 47)
TILECHR_TILE_FONT_PART_8:
.byte $5c, $c2, $66, $ff, $e7, $7a, $39, $11, $01, $29, $39, $b6, $77, $7f, $3e, $7f, $77, $5e, $99, $c3, $e7, $c3, $99, $9c, $1c, $3e, $7f, $77, $4c, $e7, $c3, $99, $be, $7f, $78, $3c, $1e, $0f, $7f, $7f, $81, $9f, $cf, $e7, $f3, $f9, $81

; address 1082 - 1128 (bytes 0 - 46)
TILECHR_TILE_FONT_PART_9:
.byte $5c, $d6, $3f, $7f, $3f, $3e, $00, $7e, $c4, $99, $c1, $f9, $c3, $ff, $c6, $7c, $7e, $7c, $70, $66, $87, $93, $87, $9f, $c6, $3c, $7e, $3c, $00, $7e, $c7, $93, $9f, $93, $c7, $ff, $c6, $3e, $7e, $3e, $0e, $66, $c3, $93, $c3, $f3

; address 1128 - 1176 (bytes 0 - 48)
TILECHR_TILE_FONT_PART_10:
.byte $5c, $c6, $3e, $7e, $3c, $00, $7e, $c3, $9f, $83, $9b, $c7, $ff, $ab, $70, $7c, $7e, $3c, $00, $5f, $9f, $87, $9f, $93, $c7, $ff, $f6, $7c, $7e, $3e, $7e, $3e, $00, $7e, $87, $f3, $c3, $93, $c3, $ff, $86, $7e, $7c, $70, $46, $93, $87, $9f

; address 1176 - 1215 (bytes 0 - 39)
TILECHR_TILE_FONT_PART_11:
.byte $5c, $81, $1c, $00, $47, $e7, $ff, $e7, $ff, $d1, $3c, $7e, $0e, $00, $77, $c7, $93, $f3, $ff, $f3, $ff, $aa, $7e, $7c, $7e, $70, $7e, $93, $87, $8f, $87, $93, $9f, $82, $1c, $3c, $41, $e7, $c7

; address 1215 - 1257 (bytes 0 - 42)
TILECHR_TILE_FONT_PART_12:
.byte $5c, $c6, $ce, $fe, $7c, $00, $6e, $73, $53, $03, $a7, $ff, $86, $7e, $7c, $00, $46, $93, $87, $ff, $c6, $3c, $7e, $3c, $00, $66, $c7, $93, $c7, $ff, $b6, $70, $7c, $7e, $7c, $00, $5e, $9f, $87, $93, $87, $ff

; address 1257 - 1307 (bytes 0 - 50)
TILECHR_TILE_FONT_PART_13:
.byte $5d, $69, $18, $3c, $fc, $00, $7a, $f7, $e3, $eb, $83, $ff, $67, $cc, $fc, $dc, $1c, $18, $7f, $bb, $83, $87, $bb, $f3, $f7, $ff, $63, $d8, $fc, $6c, $00, $7e, $b7, $a3, $ab, $8b, $db, $ff, $3b, $0c, $7e, $fe, $cc, $00, $3e, $fb, $c1, $81, $bb, $ff

; address 1307 - 1350 (bytes 0 - 43)
TILECHR_TILE_FONT_PART_14:
.byte $5c, $c2, $3e, $7e, $00, $62, $cb, $93, $ff, $f2, $1c, $3e, $7e, $77, $00, $72, $e7, $c3, $99, $ff, $aa, $7e, $ff, $e7, $00, $7a, $93, $83, $29, $39, $ff, $aa, $7e, $3c, $7e, $00, $7e, $93, $c7, $ef, $c7, $93, $ff

; address 1350 - 1390 (bytes 0 - 40)
TILECHR_TILE_FONT_PART_15:
.byte $5c, $f2, $78, $7c, $3e, $7e, $00, $7a, $8f, $e7, $c3, $93, $ff, $ba, $7e, $78, $3c, $7e, $00, $7e, $83, $9f, $cf, $e7, $83, $ff, $d0, $3c, $1c, $00, $d0, $cf, $e7, $ff, $90, $1c, $00, $50, $e7, $ff

; address 1390 - 1435 (bytes 0 - 45)
TILECHR_TILE_FONT_PART_16:
.byte $5c, $28, $3e, $00, $18, $c3, $ff, $9f, $1c, $1e, $0f, $77, $7f, $3e, $7f, $e7, $ff, $e7, $f3, $f9, $99, $c3, $80, $1c, $70, $e7, $ff, $e7, $ff, $67, $77, $3f, $1c, $7e, $77, $73, $00, $7f, $b9, $d9, $ef, $f7, $9b, $9d, $ff

; address 1435 - 1479 (bytes 0 - 44)
TILECHR_TILE_FONT_PART_17:
.byte $5d, $5b, $3e, $1e, $3e, $1e, $00, $7e, $e9, $f1, $ff, $e9, $f1, $ff, $16, $3e, $1e, $00, $1c, $e9, $f1, $ff, $12, $ee, $00, $14, $99, $ff, $7f, $e0, $f0, $78, $3c, $1e, $0f, $07, $7f, $9f, $cf, $e7, $f3, $f9, $fc, $ff

; address 1479 - 1530 (bytes 0 - 51)
TILECHR_TILE_BLACK_BELT_0:
.byte $8d, $3d, $f0, $f8, $3c, $3e, $fe, $0d, $60, $40, $80, $9f, $3c, $01, $0f, $1c, $5f, $af, $bf, $18, $04, $3c, $ff, $dc, $df, $ef, $ce, $fe, $be, $bc, $f0, $00, $44, $40, $00, $cf, $d7, $cf, $f7, $fb, $f8, $f0, $ff, $f4, $b8, $30, $70, $d8, $dc, $b8, $70

; address 1530 - 1581 (bytes 0 - 51)
TILECHR_TILE_BLACK_BELT_1:
.byte $8d, $3d, $f0, $f8, $3c, $3e, $fe, $0d, $60, $40, $80, $9f, $3c, $01, $0f, $1c, $5f, $af, $bf, $18, $04, $3c, $ff, $dc, $df, $ef, $ce, $fe, $be, $bc, $f0, $00, $44, $40, $00, $cf, $d7, $cf, $f7, $fb, $f8, $f0, $ff, $f4, $b8, $30, $70, $d8, $dc, $b8, $70

; address 1581 - 1632 (bytes 0 - 51)
TILECHR_TILE_BLACK_BELT_2:
.byte $8d, $3d, $f0, $f8, $3c, $3e, $fe, $0d, $60, $40, $80, $9f, $3c, $01, $0f, $1c, $5f, $af, $bf, $18, $04, $3c, $ff, $dc, $df, $ef, $ce, $fe, $be, $bc, $f0, $00, $44, $40, $00, $cf, $d7, $cf, $f7, $fb, $f8, $f0, $ff, $f4, $b8, $30, $70, $d8, $dc, $b8, $70

; address 1632 - 1652 (bytes 0 - 20)
TILECHR_TILE_BLACK_BELT_3:
.byte $82, $cc, $01, $01, $eb, $07, $03, $07, $0d, $00, $0f, $03, $f8, $fe, $97, $e0, $f0, $f8, $98, $cc

; address 1652 - 1677 (bytes 0 - 25)
TILECHR_TILE_BLACK_BELT_4:
.byte $82, $cc, $01, $01, $ff, $18, $3c, $7e, $ff, $1d, $0d, $00, $0f, $03, $f8, $ff, $ff, $38, $1c, $1e, $3f, $fe, $fc, $98, $ce

; address 1677 - 1702 (bytes 0 - 25)
TILECHR_TILE_BLACK_BELT_5:
.byte $82, $cc, $01, $01, $ff, $18, $3c, $7e, $ff, $1d, $0d, $00, $0f, $03, $f8, $fc, $ff, $38, $1c, $1e, $3f, $fe, $fc, $98, $cc

; address 1702 - 1726 (bytes 0 - 24)
TILECHR_TILE_BLACK_BELT_6:
.byte $42, $cc, $ff, $f8, $78, $7c, $3c, $36, $13, $30, $40, $03, $33, $77, $eb, $3f, $3e, $7c, $f8, $c0, $60, $03, $f0, $fc

; address 1726 - 1778 (bytes 0 - 52)
TILECHR_TILE_BLACK_BELT_7:
.byte $1c, $e7, $3c, $3e, $3f, $1f, $0f, $03, $e0, $1b, $01, $00, $c5, $0f, $00, $20, $3b, $7f, $f8, $f7, $ef, $eb, $53, $1f, $07, $cb, $7e, $fe, $fc, $f8, $60, $c0, $98, $00, $ff, $8e, $0e, $48, $30, $00, $08, $0e, $fe, $ff, $fe, $76, $b7, $cf, $af, $13, $f0, $c0

; address 1778 - 1792 (bytes 0 - 14)
TILECHR_TILE_BLACK_BELT_8:
.byte $42, $c8, $0f, $04, $44, $3e, $0e, $09, $78, $f0, $0e, $7e, $7c, $3e

; address 1792 - 1840 (bytes 0 - 48)
TILECHR_TILE_BLACK_BELT_9:
.byte $0c, $b8, $7f, $3f, $1f, $00, $a0, $01, $00, $b8, $08, $10, $78, $ff, $ff, $37, $77, $ef, $07, $00, $08, $04, $02, $de, $fe, $f0, $4c, $20, $18, $00, $7e, $c0, $70, $4c, $20, $18, $00, $cf, $1e, $0e, $1e, $fe, $fc, $fe, $86, $fe, $0e, $00

; address 1840 - 1860 (bytes 0 - 20)
TILECHR_TILE_BLACK_BELT_10:
.byte $42, $f0, $a0, $10, $00, $f8, $7f, $be, $c0, $7c, $00, $e7, $f8, $fe, $ff, $df, $5e, $10, $01, $3e

; address 1860 - 1915 (bytes 0 - 55)
TILECHR_TILE_BLACK_MAGE_0:
.byte $8d, $ca, $20, $60, $e0, $f0, $86, $20, $60, $70, $ad, $80, $00, $06, $00, $0d, $ff, $80, $b0, $68, $e0, $c6, $c0, $40, $6c, $bf, $f8, $fc, $fe, $7e, $0f, $03, $00, $ff, $d8, $98, $8c, $0e, $06, $03, $01, $00, $af, $01, $03, $07, $06, $0c, $08, $9e, $a0, $e0, $e8, $b0, $00

; address 1915 - 1967 (bytes 0 - 52)
TILECHR_TILE_BLACK_MAGE_1:
.byte $8c, $f8, $0f, $7f, $ff, $03, $00, $78, $07, $ff, $03, $00, $0f, $01, $09, $08, $01, $df, $fd, $fe, $60, $61, $69, $28, $00, $cf, $f0, $f8, $fc, $3c, $1e, $06, $ff, $e0, $80, $00, $c0, $f0, $38, $1c, $06, $0f, $02, $0e, $3c, $f8, $f8, $fc, $0c, $f4, $08, $00

; address 1967 - 2017 (bytes 0 - 50)
TILECHR_TILE_BLACK_MAGE_2:
.byte $4d, $4c, $40, $c0, $80, $ca, $20, $60, $e0, $f0, $30, $28, $c0, $ed, $dc, $d8, $00, $06, $00, $0c, $ff, $20, $60, $70, $f0, $78, $0c, $02, $00, $bf, $f8, $fc, $fe, $7e, $0f, $03, $00, $d7, $c1, $a1, $a3, $d7, $e6, $0c, $97, $01, $03, $07, $06, $0c

; address 2017 - 2036 (bytes 0 - 19)
TILECHR_TILE_BLACK_MAGE_3:
.byte $42, $c8, $fb, $ff, $79, $77, $6f, $58, $38, $18, $05, $06, $c0, $ec, $ce, $b4, $78, $f8, $fc

; address 2036 - 2059 (bytes 0 - 23)
TILECHR_TILE_BLACK_MAGE_4:
.byte $42, $c8, $fd, $03, $87, $cf, $7b, $40, $70, $30, $e5, $78, $30, $00, $06, $00, $fc, $ce, $b6, $7a, $78, $f8, $fc

; address 2059 - 2081 (bytes 0 - 22)
TILECHR_TILE_BLACK_MAGE_5:
.byte $42, $c8, $fc, $03, $07, $4f, $3f, $38, $b0, $e5, $78, $30, $00, $06, $00, $fc, $ce, $b6, $7a, $78, $f8, $fc

; address 2081 - 2101 (bytes 0 - 20)
TILECHR_TILE_BLACK_MAGE_6:
.byte $42, $c8, $f6, $04, $0b, $87, $6f, $5f, $1f, $e1, $f0, $60, $00, $80, $ec, $ff, $fe, $fc, $f8, $fc

; address 2101 - 2144 (bytes 0 - 43)
TILECHR_TILE_BLACK_MAGE_7:
.byte $03, $fb, $03, $18, $60, $0f, $c0, $f8, $e0, $80, $3d, $84, $42, $40, $48, $4c, $ff, $0c, $1e, $bb, $3d, $3f, $b7, $37, $33, $50, $80, $00, $fb, $4f, $66, $61, $31, $bf, $1e, $0e, $fa, $b0, $18, $1c, $0c, $80, $00

; address 2144 - 2171 (bytes 0 - 27)
TILECHR_TILE_BLACK_MAGE_8:
.byte $43, $cc, $7f, $3e, $3f, $7f, $7e, $fc, $f4, $e0, $51, $80, $00, $08, $e3, $e2, $46, $1f, $3f, $7c, $f3, $08, $00, $80, $c0, $80, $00

; address 2171 - 2225 (bytes 0 - 54)
TILECHR_TILE_BLACK_MAGE_9:
.byte $8d, $ef, $0c, $1c, $b8, $78, $7c, $fc, $fe, $6b, $08, $18, $38, $7c, $7e, $fd, $4e, $5f, $47, $07, $03, $01, $00, $bd, $40, $50, $30, $78, $7c, $fe, $df, $fe, $ff, $67, $61, $30, $10, $00, $f5, $6e, $2f, $07, $01, $80, $40, $01, $03, $b7, $fe, $ff, $f7, $77, $70, $63

; address 2225 - 2248 (bytes 0 - 23)
TILECHR_TILE_BLACK_MAGE_10:
.byte $42, $f0, $3c, $c0, $62, $1c, $00, $f0, $cf, $1f, $1e, $00, $f9, $e0, $18, $84, $04, $02, $00, $0d, $60, $e0, $c0

; address 2248 - 2302 (bytes 0 - 54)
TILECHR_TILE_FIGHTER_0:
.byte $0d, $7e, $76, $1d, $7e, $1f, $3e, $1f, $0f, $a0, $00, $80, $c0, $7d, $88, $bc, $3c, $e0, $40, $e0, $7e, $60, $44, $80, $07, $0e, $0f, $ab, $ff, $7f, $fd, $b4, $24, $28, $80, $00, $ff, $70, $21, $1a, $1e, $dd, $9d, $1c, $18, $ff, $87, $c2, $c1, $a1, $20, $64, $c0, $00

; address 2302 - 2352 (bytes 0 - 50)
TILECHR_TILE_FIGHTER_1:
.byte $0d, $7e, $76, $1d, $7e, $1f, $3e, $1f, $0f, $a0, $00, $80, $c0, $3d, $03, $3f, $e0, $40, $e0, $0e, $07, $0e, $0f, $ab, $ff, $7f, $fd, $b4, $24, $28, $80, $00, $ff, $70, $21, $1a, $9e, $dd, $9d, $1c, $18, $ff, $87, $c2, $c1, $21, $20, $44, $c0, $00

; address 2352 - 2407 (bytes 0 - 55)
TILECHR_TILE_FIGHTER_2:
.byte $0c, $ff, $40, $10, $54, $7f, $3f, $7f, $5f, $2b, $f8, $8b, $c1, $88, $80, $00, $fb, $08, $1f, $19, $18, $10, $90, $c0, $1d, $20, $67, $6f, $2b, $d7, $c8, $f8, $fc, $ff, $f0, $fc, $d8, $33, $03, $01, $00, $df, $b0, $c0, $e2, $61, $01, $26, $47, $37, $18, $1c, $9e, $c8, $b0

; address 2407 - 2424 (bytes 0 - 17)
TILECHR_TILE_FIGHTER_3:
.byte $03, $cc, $06, $83, $ff, $92, $03, $00, $08, $b1, $fe, $f0, $01, $00, $90, $09, $00

; address 2424 - 2456 (bytes 0 - 32)
TILECHR_TILE_FIGHTER_4:
.byte $02, $cc, $ff, $10, $38, $7c, $fe, $3e, $1f, $0f, $16, $1f, $04, $08, $10, $60, $e0, $ff, $38, $1c, $1e, $3f, $7e, $fc, $dc, $3e, $1f, $20, $10, $08, $00, $c0

; address 2456 - 2486 (bytes 0 - 30)
TILECHR_TILE_FIGHTER_5:
.byte $82, $cc, $fd, $10, $38, $7c, $fa, $36, $0f, $06, $1e, $04, $08, $10, $00, $ff, $38, $1c, $1e, $1f, $6e, $f4, $dc, $fe, $1f, $20, $10, $08, $00, $c0

; address 2486 - 2510 (bytes 0 - 24)
TILECHR_TILE_FIGHTER_6:
.byte $02, $cc, $ef, $fc, $7c, $3e, $1e, $1f, $0f, $06, $18, $3e, $00, $fd, $1f, $3e, $3c, $7c, $f8, $f0, $60, $18, $7c, $00

; address 2510 - 2563 (bytes 0 - 53)
TILECHR_TILE_FIGHTER_7:
.byte $83, $bb, $ff, $80, $5c, $fe, $f0, $fc, $fe, $ff, $fd, $fe, $b1, $d8, $dd, $ef, $5b, $b3, $bf, $ff, $88, $c4, $c0, $80, $18, $30, $38, $3e, $af, $fe, $ff, $fd, $fc, $e8, $48, $ff, $bb, $53, $4b, $a7, $bf, $ab, $9b, $34, $ff, $38, $10, $88, $42, $50, $4b, $58, $30

; address 2563 - 2578 (bytes 0 - 15)
TILECHR_TILE_FIGHTER_8:
.byte $02, $c8, $07, $40, $76, $77, $0f, $78, $38, $00, $80, $0d, $1f, $3e, $be

; address 2578 - 2615 (bytes 0 - 37)
TILECHR_TILE_FIGHTER_9:
.byte $02, $bb, $b8, $3f, $1b, $0d, $00, $de, $1c, $18, $3d, $7e, $3f, $7f, $f0, $e3, $27, $07, $00, $f8, $e0, $f0, $88, $c0, $00, $ff, $37, $17, $6b, $db, $3c, $c1, $fb, $fd, $a0, $80, $00

; address 2615 - 2630 (bytes 0 - 15)
TILECHR_TILE_FIGHTER_10:
.byte $02, $b0, $e0, $80, $60, $00, $cb, $f0, $f8, $78, $7c, $7e, $0c, $78, $00

; address 2630 - 2684 (bytes 0 - 54)
TILECHR_TILE_RED_MAGE_0:
.byte $03, $bf, $3a, $80, $c0, $fc, $fe, $fe, $21, $11, $19, $21, $91, $b1, $30, $9f, $80, $00, $0c, $08, $0e, $8e, $bf, $fe, $fc, $fe, $6a, $62, $32, $10, $fd, $20, $18, $1c, $8e, $0a, $02, $00, $af, $7f, $ff, $fe, $fc, $f8, $20, $ff, $bf, $0f, $07, $0f, $3e, $0c, $18, $20

; address 2684 - 2733 (bytes 0 - 49)
TILECHR_TILE_RED_MAGE_1:
.byte $03, $bf, $3a, $80, $c0, $fc, $fe, $9a, $01, $19, $d1, $30, $0f, $0c, $08, $0e, $8e, $bf, $fe, $fc, $fe, $6a, $62, $32, $10, $fd, $20, $18, $1c, $8e, $0a, $02, $00, $af, $7f, $ff, $fe, $fc, $f8, $a0, $ff, $bf, $0f, $07, $0f, $3e, $0c, $18, $20

; address 2733 - 2790 (bytes 0 - 57)
TILECHR_TILE_RED_MAGE_2:
.byte $ac, $33, $8f, $0f, $03, $00, $d0, $c0, $80, $00, $f7, $28, $07, $2f, $6f, $fb, $e3, $cc, $3f, $20, $60, $6f, $eb, $63, $00, $fd, $e6, $f6, $7a, $97, $80, $c0, $00, $bf, $06, $82, $60, $78, $30, $1e, $00, $ff, $76, $b6, $5a, $5c, $7c, $3e, $0e, $06, $3f, $88, $8c, $9c, $dc, $e8, $e0

; address 2790 - 2818 (bytes 0 - 28)
TILECHR_TILE_RED_MAGE_3:
.byte $02, $cc, $fe, $07, $7b, $43, $53, $57, $44, $0c, $1e, $13, $10, $00, $e1, $ff, $e1, $ef, $e1, $eb, $e3, $37, $2f, $1f, $1a, $e8, $00, $c0

; address 2818 - 2848 (bytes 0 - 30)
TILECHR_TILE_RED_MAGE_4:
.byte $02, $cc, $ff, $10, $38, $7d, $fe, $3f, $5e, $0c, $04, $1e, $04, $08, $10, $e1, $ff, $38, $dd, $1d, $3b, $7b, $87, $2f, $1f, $1e, $20, $10, $00, $c0

; address 2848 - 2878 (bytes 0 - 30)
TILECHR_TILE_RED_MAGE_5:
.byte $02, $cc, $ff, $10, $38, $7d, $fe, $3f, $1e, $0c, $04, $1e, $04, $08, $10, $01, $ff, $38, $dd, $1d, $3b, $7b, $87, $2f, $1f, $1e, $20, $10, $00, $c0

; address 2878 - 2902 (bytes 0 - 24)
TILECHR_TILE_RED_MAGE_6:
.byte $02, $cc, $ef, $fc, $7d, $be, $9f, $5f, $4f, $2f, $18, $3e, $00, $fe, $1f, $de, $3d, $7d, $79, $fb, $f3, $18, $7c, $00

; address 2902 - 2947 (bytes 0 - 45)
TILECHR_TILE_RED_MAGE_7:
.byte $82, $bf, $e0, $0d, $07, $00, $ff, $ed, $69, $0f, $38, $77, $ef, $fc, $0b, $f0, $1d, $99, $70, $00, $a0, $e0, $00, $f8, $18, $1c, $08, $06, $00, $ff, $b2, $97, $e6, $70, $bc, $de, $6f, $e0, $f9, $ac, $98, $08, $0c, $00, $10

; address 2947 - 2979 (bytes 0 - 32)
TILECHR_TILE_RED_MAGE_8:
.byte $02, $cc, $ff, $04, $44, $72, $77, $80, $8e, $7f, $f0, $fd, $78, $38, $00, $80, $70, $00, $17, $fd, $fa, $73, $7b, $bb, $03, $33, $1d, $0f, $80, $cc, $4c, $d4

; address 2979 - 3030 (bytes 0 - 51)
TILECHR_TILE_RED_MAGE_9:
.byte $0d, $3a, $60, $f0, $f8, $fc, $0f, $c0, $e0, $a0, $20, $fa, $08, $0c, $0e, $cf, $ef, $17, $de, $40, $c0, $02, $01, $00, $c0, $ef, $fc, $f8, $f0, $f8, $dc, $c0, $f0, $0f, $80, $c0, $40, $60, $e1, $3b, $3d, $7f, $3f, $bf, $80, $02, $03, $07, $05, $09, $01

; address 3030 - 3056 (bytes 0 - 26)
TILECHR_TILE_RED_MAGE_10:
.byte $02, $f0, $a7, $c8, $c0, $60, $20, $00, $f8, $37, $16, $80, $1c, $00, $fb, $e0, $38, $bc, $9e, $de, $c0, $c8, $19, $1e, $00, $16

; address 3056 - 3110 (bytes 0 - 54)
TILECHR_TILE_THIEF_0:
.byte $8d, $0d, $70, $40, $80, $7b, $0c, $76, $1e, $7e, $7c, $be, $ff, $e0, $f8, $fc, $30, $ef, $dc, $5f, $af, $df, $a0, $90, $20, $0f, $1c, $1f, $8f, $68, $80, $c0, $00, $8b, $fe, $fc, $f8, $00, $fb, $d4, $db, $bb, $b9, $fc, $f4, $78, $bf, $c7, $07, $03, $e3, $f1, $f0, $70

; address 3110 - 3157 (bytes 0 - 47)
TILECHR_TILE_THIEF_1:
.byte $8d, $0d, $70, $40, $80, $7b, $0c, $76, $1e, $7e, $7c, $be, $0f, $ef, $dc, $5f, $af, $0f, $0f, $1c, $1f, $8f, $68, $80, $c0, $00, $8b, $fe, $fc, $f8, $00, $fb, $d4, $db, $bb, $b9, $fc, $f4, $78, $bf, $c7, $07, $03, $e3, $f1, $f0, $70

; address 3157 - 3214 (bytes 0 - 57)
TILECHR_TILE_THIEF_2:
.byte $8c, $e8, $e1, $ce, $08, $00, $ff, $e1, $ee, $2f, $3f, $5f, $7f, $3d, $00, $fb, $0d, $0e, $19, $36, $7f, $6b, $eb, $db, $01, $00, $26, $6f, $0b, $eb, $e0, $70, $30, $00, $87, $fe, $fc, $f0, $00, $ff, $fe, $cf, $3f, $ff, $7d, $8f, $60, $70, $ff, $ce, $cf, $0f, $07, $00, $e0, $f8, $fc

; address 3214 - 3238 (bytes 0 - 24)
TILECHR_TILE_THIEF_3:
.byte $03, $cc, $07, $96, $f6, $f4, $93, $01, $00, $08, $09, $bc, $f4, $f3, $33, $13, $00, $b7, $09, $08, $00, $03, $01, $00

; address 3238 - 3266 (bytes 0 - 28)
TILECHR_TILE_THIEF_4:
.byte $02, $cc, $ff, $18, $3c, $7f, $ff, $1c, $19, $02, $0c, $0f, $03, $06, $04, $e1, $fe, $38, $1c, $1e, $7f, $9e, $c4, $38, $0d, $20, $00, $c4

; address 3266 - 3294 (bytes 0 - 28)
TILECHR_TILE_THIEF_5:
.byte $02, $cc, $ff, $18, $3c, $7f, $ff, $1c, $19, $02, $0c, $0f, $03, $06, $04, $01, $fe, $38, $1c, $1e, $7e, $9e, $c4, $38, $0d, $20, $00, $c4

; address 3294 - 3322 (bytes 0 - 28)
TILECHR_TILE_THIEF_6:
.byte $02, $cc, $ff, $fc, $78, $7c, $fe, $00, $07, $0c, $18, $0f, $7c, $78, $30, $03, $fa, $38, $1c, $7e, $1e, $00, $70, $1d, $60, $f8, $00, $88

; address 3322 - 3375 (bytes 0 - 53)
TILECHR_TILE_THIEF_7:
.byte $82, $7f, $ff, $6f, $bf, $ff, $7f, $3f, $1f, $07, $01, $ff, $f7, $f8, $f7, $ef, $e9, $41, $09, $00, $fe, $f0, $f8, $f7, $ef, $1b, $13, $5f, $e0, $62, $02, $00, $8b, $fe, $fc, $f8, $c0, $ef, $f7, $78, $ff, $af, $12, $f4, $f6, $bf, $70, $b7, $cf, $af, $12, $fc, $fe

; address 3375 - 3391 (bytes 0 - 16)
TILECHR_TILE_THIEF_8:
.byte $82, $c8, $0b, $7c, $7a, $f6, $0f, $78, $38, $40, $f0, $0f, $7e, $7c, $3e, $3f

; address 3391 - 3433 (bytes 0 - 42)
TILECHR_TILE_THIEF_9:
.byte $42, $bb, $f8, $bf, $1f, $0f, $03, $00, $bf, $0c, $18, $58, $bf, $ff, $7f, $ff, $f8, $ff, $3f, $1f, $03, $00, $f8, $f8, $f0, $e0, $80, $00, $df, $3b, $1d, $3d, $f3, $ff, $fc, $f8, $ce, $fb, $fd, $73, $0f, $00

; address 3433 - 3453 (bytes 0 - 20)
TILECHR_TILE_THIEF_10:
.byte $03, $70, $79, $a0, $d0, $10, $d0, $80, $79, $fc, $e0, $1c, $3c, $30, $3b, $11, $e0, $c1, $41, $00

; address 3453 - 3503 (bytes 0 - 50)
TILECHR_TILE_WHITE_MAGE_0:
.byte $4d, $7a, $c0, $20, $90, $58, $dc, $1c, $80, $40, $c0, $7c, $e0, $e1, $f2, $31, $c0, $7f, $e0, $c0, $40, $01, $de, $98, $9e, $f7, $de, $be, $7e, $ff, $f7, $ef, $1e, $e0, $c0, $80, $00, $ff, $c0, $c1, $d3, $dc, $bf, $57, $e1, $c0, $b0, $0f, $03, $00

; address 3503 - 3552 (bytes 0 - 49)
TILECHR_TILE_WHITE_MAGE_1:
.byte $4c, $fe, $53, $4f, $20, $1f, $0f, $03, $00, $e0, $17, $0f, $00, $cb, $2f, $0f, $00, $10, $28, $fd, $0e, $c8, $bc, $7e, $70, $05, $08, $fd, $de, $be, $7e, $fd, $fb, $ff, $1e, $e0, $c0, $80, $00, $9f, $fe, $f4, $08, $1c, $3c, $7e, $06, $c0, $e0

; address 3552 - 3604 (bytes 0 - 52)
TILECHR_TILE_WHITE_MAGE_2:
.byte $4d, $7a, $c0, $20, $90, $58, $dc, $1c, $80, $40, $c0, $7c, $fc, $fd, $7a, $c1, $00, $ff, $07, $fc, $d8, $48, $01, $1e, $d8, $de, $f7, $de, $be, $7e, $ff, $f7, $ef, $1e, $e0, $c0, $80, $00, $7f, $c1, $d3, $dc, $df, $f7, $e1, $c0, $f8, $0f, $cf, $83, $80, $00

; address 3604 - 3631 (bytes 0 - 27)
TILECHR_TILE_WHITE_MAGE_3:
.byte $02, $cc, $fa, $3f, $5e, $6d, $eb, $e7, $ef, $7f, $0a, $2c, $09, $61, $20, $07, $63, $c1, $3f, $fe, $f6, $79, $24, $36, $be, $fe, $f6

; address 3631 - 3659 (bytes 0 - 28)
TILECHR_TILE_WHITE_MAGE_4:
.byte $02, $cc, $fa, $03, $0e, $5d, $eb, $e7, $ef, $ff, $30, $02, $00, $09, $61, $20, $07, $63, $c1, $3f, $fe, $f6, $79, $24, $36, $be, $fe, $f6

; address 3659 - 3687 (bytes 0 - 28)
TILECHR_TILE_WHITE_MAGE_5:
.byte $02, $cc, $fa, $3f, $3e, $1d, $3b, $77, $6f, $df, $08, $1c, $18, $71, $30, $67, $23, $d2, $3f, $fe, $fc, $fe, $7a, $08, $6a, $3c, $fc, $fe

; address 3687 - 3716 (bytes 0 - 29)
TILECHR_TILE_WHITE_MAGE_6:
.byte $03, $cc, $7a, $cf, $f7, $f8, $ff, $fe, $7f, $40, $35, $18, $7f, $3f, $1e, $7e, $f8, $f0, $81, $1f, $7f, $ff, $de, $30, $00, $03, $1b, $5f, $ff

; address 3716 - 3754 (bytes 0 - 38)
TILECHR_TILE_WHITE_MAGE_7:
.byte $43, $bb, $1a, $80, $c0, $e0, $fc, $38, $4e, $77, $2b, $1b, $3b, $3f, $30, $b8, $38, $f8, $b8, $38, $9c, $f0, $e0, $c0, $00, $ff, $37, $6f, $1f, $fe, $fd, $c3, $80, $00, $e0, $b0, $e0, $00

; address 3754 - 3787 (bytes 0 - 33)
TILECHR_TILE_WHITE_MAGE_8:
.byte $03, $cc, $fd, $3c, $3e, $3b, $64, $9c, $74, $04, $fd, $8c, $86, $9b, $04, $1d, $75, $85, $f1, $38, $3e, $7f, $ff, $fc, $ff, $81, $8e, $2f, $1f, $7f, $1f, $3f, $7c

; address 3787 - 3828 (bytes 0 - 41)
TILECHR_TILE_WHITE_MAGE_9:
.byte $62, $bb, $fc, $7f, $7b, $3c, $1f, $07, $00, $fe, $01, $0f, $3f, $0f, $73, $7c, $ff, $f8, $e1, $4f, $3b, $0d, $00, $fc, $f6, $c1, $80, $00, $80, $00, $1f, $fc, $fb, $fe, $3e, $fe, $f0, $ff, $6d, $24, $00

; address 3828 - 3856 (bytes 0 - 28)
TILECHR_TILE_WHITE_MAGE_10:
.byte $42, $f0, $fc, $20, $80, $84, $63, $1c, $00, $f8, $77, $67, $0e, $0c, $00, $fa, $f8, $c6, $02, $81, $01, $00, $c7, $80, $00, $18, $38, $7b

; address 3856 - 3912 (bytes 0 - 56)
TILECHR_TILE_ICON_PART_0:
.byte $5d, $ff, $07, $0f, $1f, $be, $fc, $f8, $f0, $f8, $ff, $fc, $f8, $f1, $63, $87, $cf, $af, $77, $94, $1e, $ff, $1e, $99, $f1, $12, $f1, $ff, $7f, $d8, $f8, $78, $fc, $fe, $1f, $0f, $7f, $b7, $cf, $c7, $a3, $f1, $f8, $ff, $55, $3f, $1e, $ff, $0e, $6f, $e0, $f1, $ff, $00, $ff, $f9

; address 3912 - 3968 (bytes 0 - 56)
TILECHR_TILE_ICON_PART_1:
.byte $4c, $ff, $03, $07, $0e, $6c, $fc, $d8, $f8, $70, $fd, $fe, $fd, $fb, $f7, $b7, $6f, $9f, $87, $63, $3f, $3c, $00, $cf, $fd, $bd, $bf, $fd, $d7, $ff, $bb, $7f, $7e, $7f, $ff, $e3, $00, $f7, $a5, $99, $c3, $81, $42, $3c, $ff, $c0, $3f, $7f, $ef, $e3, $dd, $b6, $a2, $b6, $be, $80

; address 3968 - 4015 (bytes 0 - 47)
TILECHR_TILE_ICON_PART_2:
.byte $5d, $70, $18, $df, $ff, $6d, $f7, $b2, $82, $02, $45, $37, $3c, $7c, $fc, $f8, $e0, $37, $e3, $c3, $87, $5f, $bf, $7b, $7c, $fe, $e7, $c3, $e7, $fe, $73, $c3, $9d, $3e, $9d, $c3, $cc, $0e, $fe, $fc, $fe, $d5, $f9, $81, $83, $81, $f9

; address 4015 - 4029 (bytes 0 - 14)
TILECHR_TILE_ICON_PART_3:
.byte $52, $c0, $ce, $1e, $3f, $1e, $0c, $1e, $ad, $e3, $c1, $e3, $f7, $e3

; address 4029 - 4050 (bytes 0 - 21)
TILECHR_MAP_TILE_GRASS_0:
.byte $24, $3e, $08, $2c, $64, $40, $00, $16, $24, $48, $00, $58, $20, $10, $00, $57, $10, $08, $14, $08, $00

; address 4050 - 4097 (bytes 0 - 47)
TILECHR_MAP_TILE_GRASS_1:
.byte $5d, $7c, $70, $7c, $7e, $7f, $ff, $5d, $bf, $a7, $a3, $7f, $20, $61, $7f, $ff, $7f, $77, $af, $6f, $45, $7d, $39, $80, $61, $7e, $ff, $76, $77, $bf, $7f, $49, $7b, $32, $89, $5b, $03, $fb, $ff, $1f, $07, $57, $fd, $7d, $0f, $e3, $f8

; address 4097 - 4144 (bytes 0 - 47)
TILECHR_MAP_TILE_GRASS_2:
.byte $1d, $61, $7e, $ff, $7e, $77, $c9, $80, $b6, $80, $c9, $ff, $61, $6e, $ff, $7e, $77, $d9, $90, $b6, $80, $c1, $ff, $6d, $fe, $ff, $1b, $ff, $fe, $77, $81, $80, $f6, $80, $81, $ff, $4d, $ff, $db, $ff, $7e, $57, $80, $b6, $80, $c9, $ff

; address 4144 - 4187 (bytes 0 - 43)
TILECHR_MAP_TILE_GRASS_3:
.byte $1d, $6d, $7e, $ff, $c3, $e7, $66, $77, $c1, $80, $be, $9c, $dd, $ff, $4f, $ff, $e7, $ff, $7e, $3c, $5f, $80, $be, $9c, $c1, $e3, $ff, $48, $ff, $db, $51, $80, $b6, $ff, $4a, $ff, $1b, $03, $55, $80, $f6, $fe, $ff

; address 4187 - 4228 (bytes 0 - 41)
TILECHR_MAP_TILE_4:
.byte $1c, $f7, $3e, $7f, $77, $7f, $77, $7f, $3e, $6f, $c3, $99, $91, $9f, $99, $c3, $94, $77, $7f, $77, $4c, $99, $81, $99, $a2, $7f, $1c, $7f, $61, $81, $e7, $81, $e8, $3e, $7f, $77, $07, $68, $c3, $99, $f9

; address 4228 - 4261 (bytes 0 - 33)
TILECHR_MAP_TILE_5:
.byte $32, $7e, $f5, $10, $38, $7c, $38, $10, $00, $a0, $7f, $70, $60, $81, $9f, $91, $e7, $ff, $fe, $4b, $39, $29, $01, $13, $ff, $08, $3c, $47, $80, $50, $3c, $c3, $84

; address 4261 - 4307 (bytes 0 - 46)
TILECHR_MAP_TILE_6:
.byte $1c, $e0, $48, $f9, $ff, $0c, $32, $00, $9f, $70, $7e, $7f, $77, $7f, $7e, $4d, $9f, $83, $99, $83, $d3, $3f, $7f, $77, $7f, $3e, $71, $c1, $93, $99, $c3, $ef, $77, $7f, $7e, $7f, $77, $7f, $7e, $7d, $99, $93, $87, $83, $99, $83

; address 4307 - 4347 (bytes 0 - 40)
TILECHR_MAP_TILE_7:
.byte $1c, $ff, $3e, $7f, $77, $3f, $7e, $77, $7f, $3e, $7f, $c3, $99, $f9, $c3, $9f, $99, $c3, $82, $1c, $7f, $41, $e7, $81, $e0, $3e, $7f, $77, $60, $c3, $99, $d8, $1c, $3e, $7f, $77, $68, $e7, $c3, $99

; address 4347 - 4394 (bytes 0 - 47)
TILECHR_MAP_TILE_8:
.byte $1c, $c2, $66, $ff, $e7, $7a, $39, $11, $01, $29, $39, $b6, $77, $7f, $3e, $7f, $77, $5e, $99, $c3, $e7, $c3, $99, $9c, $1c, $3e, $7f, $77, $4c, $e7, $c3, $99, $be, $7f, $78, $3c, $1e, $0f, $7f, $7f, $81, $9f, $cf, $e7, $f3, $f9, $81

; address 4394 - 4440 (bytes 0 - 46)
TILECHR_MAP_TILE_9:
.byte $1c, $d6, $3f, $7f, $3f, $3e, $00, $7e, $c4, $99, $c1, $f9, $c3, $ff, $c6, $7c, $7e, $7c, $70, $66, $87, $93, $87, $9f, $c6, $3c, $7e, $3c, $00, $7e, $c7, $93, $9f, $93, $c7, $ff, $c6, $3e, $7e, $3e, $0e, $66, $c3, $93, $c3, $f3

; address 4440 - 4488 (bytes 0 - 48)
TILECHR_MAP_TILE_10:
.byte $1c, $c6, $3e, $7e, $3c, $00, $7e, $c3, $9f, $83, $9b, $c7, $ff, $ab, $70, $7c, $7e, $3c, $00, $5f, $9f, $87, $9f, $93, $c7, $ff, $f6, $7c, $7e, $3e, $7e, $3e, $00, $7e, $87, $f3, $c3, $93, $c3, $ff, $86, $7e, $7c, $70, $46, $93, $87, $9f

; address 4488 - 4527 (bytes 0 - 39)
TILECHR_MAP_TILE_11:
.byte $1c, $81, $1c, $00, $47, $e7, $ff, $e7, $ff, $d1, $3c, $7e, $0e, $00, $77, $c7, $93, $f3, $ff, $f3, $ff, $aa, $7e, $7c, $7e, $70, $7e, $93, $87, $8f, $87, $93, $9f, $82, $1c, $3c, $41, $e7, $c7

; address 4527 - 4569 (bytes 0 - 42)
TILECHR_MAP_TILE_12:
.byte $1c, $c6, $ce, $fe, $7c, $00, $6e, $73, $53, $03, $a7, $ff, $86, $7e, $7c, $00, $46, $93, $87, $ff, $c6, $3c, $7e, $3c, $00, $66, $c7, $93, $c7, $ff, $b6, $70, $7c, $7e, $7c, $00, $5e, $9f, $87, $93, $87, $ff

; address 4569 - 4619 (bytes 0 - 50)
TILECHR_MAP_TILE_13:
.byte $1d, $69, $18, $3c, $fc, $00, $7a, $f7, $e3, $eb, $83, $ff, $67, $cc, $fc, $dc, $1c, $18, $7f, $bb, $83, $87, $bb, $f3, $f7, $ff, $63, $d8, $fc, $6c, $00, $7e, $b7, $a3, $ab, $8b, $db, $ff, $3b, $0c, $7e, $fe, $cc, $00, $3e, $fb, $c1, $81, $bb, $ff

; address 4619 - 4662 (bytes 0 - 43)
TILECHR_MAP_TILE_14:
.byte $1c, $c2, $3e, $7e, $00, $62, $cb, $93, $ff, $f2, $1c, $3e, $7e, $77, $00, $72, $e7, $c3, $99, $ff, $aa, $7e, $ff, $e7, $00, $7a, $93, $83, $29, $39, $ff, $aa, $7e, $3c, $7e, $00, $7e, $93, $c7, $ef, $c7, $93, $ff

; address 4662 - 4702 (bytes 0 - 40)
TILECHR_MAP_TILE_15:
.byte $1c, $f2, $78, $7c, $3e, $7e, $00, $7a, $8f, $e7, $c3, $93, $ff, $ba, $7e, $78, $3c, $7e, $00, $7e, $83, $9f, $cf, $e7, $83, $ff, $d0, $3c, $1c, $00, $d0, $cf, $e7, $ff, $90, $1c, $00, $50, $e7, $ff

; address 4702 - 4747 (bytes 0 - 45)
TILECHR_MAP_TILE_16:
.byte $1c, $28, $3e, $00, $18, $c3, $ff, $9f, $1c, $1e, $0f, $77, $7f, $3e, $7f, $e7, $ff, $e7, $f3, $f9, $99, $c3, $80, $1c, $70, $e7, $ff, $e7, $ff, $67, $77, $3f, $1c, $7e, $77, $73, $00, $7f, $b9, $d9, $ef, $f7, $9b, $9d, $ff

; address 4747 - 4791 (bytes 0 - 44)
TILECHR_MAP_TILE_17:
.byte $1d, $5b, $3e, $1e, $3e, $1e, $00, $7e, $e9, $f1, $ff, $e9, $f1, $ff, $16, $3e, $1e, $00, $1c, $e9, $f1, $ff, $12, $ee, $00, $14, $99, $ff, $7f, $e0, $f0, $78, $3c, $1e, $0f, $07, $7f, $9f, $cf, $e7, $f3, $f9, $fc, $ff

; address 4791 - 4840 (bytes 0 - 49)
TILECHR_MAP_TILE_18:
.byte $5c, $c1, $3e, $7f, $3e, $61, $c3, $99, $c3, $a5, $3e, $1c, $3c, $1c, $63, $c3, $e7, $c7, $e7, $bf, $7f, $3f, $1e, $0f, $77, $7f, $3e, $7f, $81, $cf, $e7, $f3, $f9, $99, $c3, $d5, $3e, $7f, $1f, $7f, $3e, $7f, $c3, $99, $f9, $e3, $f9, $99, $c3

; address 4840 - 4887 (bytes 0 - 47)
TILECHR_MAP_TILE_19:
.byte $1d, $7c, $70, $7c, $7e, $7f, $ff, $5d, $bf, $a7, $a3, $7f, $20, $61, $7f, $ff, $7f, $77, $af, $6f, $45, $7d, $39, $80, $61, $7e, $ff, $76, $77, $bf, $7f, $49, $7b, $32, $89, $5b, $03, $fb, $ff, $1f, $07, $57, $fd, $7d, $0f, $e3, $f8

; address 4887 - 4934 (bytes 0 - 47)
TILECHR_MAP_TILE_20:
.byte $5d, $61, $7e, $ff, $7e, $77, $c9, $80, $b6, $80, $c9, $ff, $61, $6e, $ff, $7e, $77, $d9, $90, $b6, $80, $c1, $ff, $6d, $fe, $ff, $1b, $ff, $fe, $77, $81, $80, $f6, $80, $81, $ff, $4d, $ff, $db, $ff, $7e, $57, $80, $b6, $80, $c9, $ff

; address 4934 - 4977 (bytes 0 - 43)
TILECHR_MAP_TILE_21:
.byte $5d, $6d, $7e, $ff, $c3, $e7, $66, $77, $c1, $80, $be, $9c, $dd, $ff, $4f, $ff, $e7, $ff, $7e, $3c, $5f, $80, $be, $9c, $c1, $e3, $ff, $48, $ff, $db, $51, $80, $b6, $ff, $4a, $ff, $1b, $03, $55, $80, $f6, $fe, $ff

; address 4977 - 5018 (bytes 0 - 41)
TILECHR_MAP_TILE_22:
.byte $5c, $f7, $3e, $7f, $77, $7f, $77, $7f, $3e, $6f, $c3, $99, $91, $9f, $99, $c3, $94, $77, $7f, $77, $4c, $99, $81, $99, $a2, $7f, $1c, $7f, $61, $81, $e7, $81, $e8, $3e, $7f, $77, $07, $68, $c3, $99, $f9

; address 5018 - 5060 (bytes 0 - 42)
TILECHR_MAP_TILE_23:
.byte $5c, $f7, $77, $7f, $7e, $7c, $7e, $7f, $77, $7f, $99, $93, $87, $8f, $87, $93, $99, $a0, $7f, $70, $60, $81, $9f, $91, $e7, $ff, $fe, $4b, $39, $29, $01, $13, $a1, $77, $7f, $77, $5b, $99, $91, $81, $89, $99

; address 5060 - 5109 (bytes 0 - 49)
TILECHR_MAP_TILE_24:
.byte $5c, $e3, $3e, $7f, $77, $7f, $3e, $61, $c3, $99, $c3, $9f, $70, $7e, $7f, $77, $7f, $7e, $4d, $9f, $83, $99, $83, $d3, $3f, $7f, $77, $7f, $3e, $71, $c1, $93, $99, $c3, $ef, $77, $7f, $7e, $7f, $77, $7f, $7e, $7d, $99, $93, $87, $83, $99, $83

; address 5109 - 5149 (bytes 0 - 40)
TILECHR_MAP_TILE_25:
.byte $5c, $ff, $3e, $7f, $77, $3f, $7e, $77, $7f, $3e, $7f, $c3, $99, $f9, $c3, $9f, $99, $c3, $82, $1c, $7f, $41, $e7, $81, $e0, $3e, $7f, $77, $60, $c3, $99, $d8, $1c, $3e, $7f, $77, $68, $e7, $c3, $99

; address 5149 - 5196 (bytes 0 - 47)
TILECHR_MAP_TILE_26:
.byte $5c, $c2, $66, $ff, $e7, $7a, $39, $11, $01, $29, $39, $b6, $77, $7f, $3e, $7f, $77, $5e, $99, $c3, $e7, $c3, $99, $9c, $1c, $3e, $7f, $77, $4c, $e7, $c3, $99, $be, $7f, $78, $3c, $1e, $0f, $7f, $7f, $81, $9f, $cf, $e7, $f3, $f9, $81

; address 5196 - 5242 (bytes 0 - 46)
TILECHR_MAP_TILE_27:
.byte $5c, $d6, $3f, $7f, $3f, $3e, $00, $7e, $c4, $99, $c1, $f9, $c3, $ff, $c6, $7c, $7e, $7c, $70, $66, $87, $93, $87, $9f, $c6, $3c, $7e, $3c, $00, $7e, $c7, $93, $9f, $93, $c7, $ff, $c6, $3e, $7e, $3e, $0e, $66, $c3, $93, $c3, $f3

; address 5242 - 5290 (bytes 0 - 48)
TILECHR_MAP_TILE_28:
.byte $5c, $c6, $3e, $7e, $3c, $00, $7e, $c3, $9f, $83, $9b, $c7, $ff, $ab, $70, $7c, $7e, $3c, $00, $5f, $9f, $87, $9f, $93, $c7, $ff, $f6, $7c, $7e, $3e, $7e, $3e, $00, $7e, $87, $f3, $c3, $93, $c3, $ff, $86, $7e, $7c, $70, $46, $93, $87, $9f

; address 5290 - 5329 (bytes 0 - 39)
TILECHR_MAP_TILE_29:
.byte $5c, $81, $1c, $00, $47, $e7, $ff, $e7, $ff, $d1, $3c, $7e, $0e, $00, $77, $c7, $93, $f3, $ff, $f3, $ff, $aa, $7e, $7c, $7e, $70, $7e, $93, $87, $8f, $87, $93, $9f, $82, $1c, $3c, $41, $e7, $c7

; address 5329 - 5371 (bytes 0 - 42)
TILECHR_MAP_TILE_30:
.byte $5c, $c6, $ce, $fe, $7c, $00, $6e, $73, $53, $03, $a7, $ff, $86, $7e, $7c, $00, $46, $93, $87, $ff, $c6, $3c, $7e, $3c, $00, $66, $c7, $93, $c7, $ff, $b6, $70, $7c, $7e, $7c, $00, $5e, $9f, $87, $93, $87, $ff

; address 5371 - 5421 (bytes 0 - 50)
TILECHR_MAP_TILE_31:
.byte $5d, $69, $18, $3c, $fc, $00, $7a, $f7, $e3, $eb, $83, $ff, $67, $cc, $fc, $dc, $1c, $18, $7f, $bb, $83, $87, $bb, $f3, $f7, $ff, $63, $d8, $fc, $6c, $00, $7e, $b7, $a3, $ab, $8b, $db, $ff, $3b, $0c, $7e, $fe, $cc, $00, $3e, $fb, $c1, $81, $bb, $ff

; 5421 - 8192
.res 2771

