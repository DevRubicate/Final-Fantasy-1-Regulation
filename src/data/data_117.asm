.segment "DATA_117"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, LUT_METASPRITE_PALETTE_LO, LUT_METASPRITE_PALETTE_HI, METASPRITE_CURSOR_PALETTE, METASPRITE_BLACK_BELT_PALETTE, METASPRITE_BLACK_MAGE_PALETTE, METASPRITE_FIGHTER_PALETTE, METASPRITE_RED_MAGE_PALETTE, METASPRITE_THIEF_PALETTE, METASPRITE_WHITE_MAGE_PALETTE

; address 0 - 256 (bytes 768 - 1024)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $8b, $05, $e2, $83, $69, $43, $f4, $24, $3b, $28, $bf, $c4, $46, $1b, $80, $11, $40, $3e, $00, $33, $d1, $0b, $ab, $12, $d9, $4a, $bd, $b9, $d4, $f5, $35, $91, $65, $75, $0a, $6d, $51, $57, $aa, $bf, $3e, $a6, $ab, $37, $76, $a3, $2d, $e2, $aa, $b3, $4a, $ef, $05, $55, $aa, $8c, $f4, $2a, $a8, $05, $20, $08, $44, $1e, $29, $87, $f5, $84, $26, $a4, $09, $a5, $89, $2f, $d2, $9e, $f9, $35, $5c, $d2, $ef, $0b, $6d, $45, $aa, $a8, $55, $1c, $f8, $0a, $92, $06, $9b, $09, $a6, $03, $68, $80, $f4, $20, $88, $a9, $ba, $b9, $15, $da, $85, $7c, $c7, $df, $7c, $df, $9a, $0c, $ce, $a2, $95, $c0, $5b, $50, $5a, $d8, $79, $d4, $84, $ce, $01, $ac, $a1, $aa, $ea, $09, $2e, $8c, $1d, $03, $89, $a5, $01, $68, $89, $21, $0a, $a1, $0f, $30, $38, $37, $c1, $37, $76, $34, $ef, $62, $9a, $ec, $46, $76, $c4, $b7, $62, $ae, $ee, $19, $fa, $53, $7f, $2c, $fb, $ca, $5f, $e5, $37, $f2, $cb, $ee, $a7, $57, $4a, $fd, $a5, $b6, $c0, $59, $58, $94, $ad, $a9, $7a, $c5, $5d, $6d, $3f, $d6, $57, $ab, $35, $f5, $ca, $ab, $2c, $6f, $dd, $1e, $fa, $ed, $ff, $ab, $bf, $75, $7e, $fb, $fd, $d7, $bf, $be, $7d, $71, $2f, $d8, $32, $ef, $a9, $fe, $d4, $b7, $57, $4b, $ed, $65, $ee, $b3, $dd, $b3, $c4, $89, $41, $74, $05, $c2, $0c, $b0, $4a, $6a, $14, $fa, $2a, $cc, $d6, $5d, $f0, $83, $96, $cd, $71, $5a

; address 256 - 320 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 320 - 356 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $17, $22, $13, $1b, $21, $7f, $7f, $1b, $0f, $15, $17, $11, $7f, $7f, $25, $13, $0f, $1e, $1d, $1c, $7f, $7f, $0f, $20, $1b, $1d, $20, $7f, $7f, $21, $22, $0f, $22, $23, $21, $00

; address 356 - 383 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $3c, $30, $2d, $31, $3a, $02, $37, $36, $34, $41, $02, $30, $37, $38, $2d, $02, $29, $02, $38, $3a, $37, $38, $30, $2d, $2b, $41, $00

; address 383 - 407 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $27, $37, $3d, $7f, $2b, $29, $36, $4a, $3c, $7f, $2b, $29, $3a, $3a, $41, $7f, $29, $36, $41, $35, $37, $3a, $2d, $00

; address 407 - 427 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $2d, $29, $2b, $30, $02, $30, $37, $34, $2c, $31, $36, $2f, $02, $29, $36, $02, $1d, $20, $10, $00

; address 427 - 443 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $10, $3d, $41, $7f, $7f, $21, $2d, $34, $34, $7f, $7f, $13, $40, $31, $3c, $00

; address 443 - 451 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $14, $17, $15, $16, $22, $13, $20, $00

; address 451 - 459 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $27, $2d, $3b, $7f, $7f, $1c, $37, $00

; address 459 - 466 (bytes 0 - 7)
LUT_METASPRITE_PALETTE_LO:
.byte <METASPRITE_CURSOR_PALETTE, <METASPRITE_BLACK_BELT_PALETTE, <METASPRITE_BLACK_MAGE_PALETTE, <METASPRITE_FIGHTER_PALETTE, <METASPRITE_RED_MAGE_PALETTE, <METASPRITE_THIEF_PALETTE, <METASPRITE_WHITE_MAGE_PALETTE

; address 466 - 473 (bytes 0 - 7)
LUT_METASPRITE_PALETTE_HI:
.byte >METASPRITE_CURSOR_PALETTE, >METASPRITE_BLACK_BELT_PALETTE, >METASPRITE_BLACK_MAGE_PALETTE, >METASPRITE_FIGHTER_PALETTE, >METASPRITE_RED_MAGE_PALETTE, >METASPRITE_THIEF_PALETTE, >METASPRITE_WHITE_MAGE_PALETTE

; address 473 - 477 (bytes 0 - 4)
METASPRITE_CURSOR_PALETTE:
.byte $1d, $10, $1e, $ff

; address 477 - 481 (bytes 0 - 4)
METASPRITE_BLACK_BELT_PALETTE:
.byte $1d, $10, $1e, $ff

; address 481 - 485 (bytes 0 - 4)
METASPRITE_BLACK_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; address 485 - 489 (bytes 0 - 4)
METASPRITE_FIGHTER_PALETTE:
.byte $1d, $10, $1e, $ff

; address 489 - 493 (bytes 0 - 4)
METASPRITE_RED_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; address 493 - 497 (bytes 0 - 4)
METASPRITE_THIEF_PALETTE:
.byte $1d, $10, $1e, $ff

; address 497 - 501 (bytes 0 - 4)
METASPRITE_WHITE_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; 501 - 8192
.res 7691

