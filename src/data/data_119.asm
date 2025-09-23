.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, LUT_METASPRITE_PALETTE_LO, LUT_METASPRITE_PALETTE_HI, METASPRITE_CURSOR_PALETTE, METASPRITE_BLACK_BELT_PALETTE, METASPRITE_BLACK_MAGE_PALETTE, METASPRITE_FIGHTER_PALETTE, METASPRITE_RED_MAGE_PALETTE, METASPRITE_THIEF_PALETTE, METASPRITE_WHITE_MAGE_PALETTE

; address 0 - 256 (bytes 1280 - 1536)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f0, $7b, $0e, $d0, $79, $c8, $70, $b8, $8e, $30, $ba, $43, $e7, $17, $88, $71, $98, $70, $d8, $e5, $0b, $ac, $1e, $c3, $b0, $ff, $07, $ac, $1e, $b0, $ba, $42, $e9, $0b, $a4, $2e, $90, $ba, $c1, $ed, $05, $8e, $81, $c1, $e5, $07, $88, $e6, $1c, $2e, $41, $86, $1c, $17, $07, $90, $70, $b9, $41, $e3, $07, $9c, $1e, $e3, $b8, $ef, $07, $b0, $ec, $3b, $8e, $a3, $b0, $ec, $3b, $0e, $c3, $ff, $f7, $0b, $ac, $1f, $c3, $ff, $ff, $23, $b0, $ff, $ff, $ff, $61, $da, $0f, $ff, $ff, $f9, $87, $07, $94, $4e, $30, $b8, $c1, $70, $79, $c2, $e9, $07, $a8, $fe, $1c, $1e, $a3, $98, $eb, $0b, $a0, $f2, $1c, $1e, $70, $58, $e2, $39, $41, $ed, $07, $ac, $1e, $90, $ba, $42, $e9, $0b, $a4, $2e, $90, $ba, $41, $71, $5c, $46, $1c, $3e, $41, $c1, $ea, $3b, $0f, $ff, $47, $60, $c7, $38, $3c, $62, $f4, $85, $d2, $17, $38, $7c, $67, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e6, $39, $f3, $e7, $c4, $ff, $c8, $76

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

