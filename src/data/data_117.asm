.segment "DATA_117"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, LUT_METASPRITE_PALETTE_LO, LUT_METASPRITE_PALETTE_HI, METASPRITE_CURSOR_PALETTE, METASPRITE_BLACK_BELT_PALETTE, METASPRITE_BLACK_MAGE_PALETTE, METASPRITE_FIGHTER_PALETTE, METASPRITE_RED_MAGE_PALETTE, METASPRITE_THIEF_PALETTE, METASPRITE_WHITE_MAGE_PALETTE

; address 0 - 256 (bytes 768 - 1024)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $c4, $8a, $41, $21, $e1, $11, $21, $8e, $d6, $94, $b1, $12, $51, $37, $d1, $b2, $29, $06, $0d, $3c, $3c, $f4, $f8, $f1, $99, $70, $73, $f2, $6a, $9a, $a5, $59, $ad, $84, $c4, $40, $72, $20, $e6, $e4, $c1, $a9, $44, $09, $e6, $22, $5e, $8a, $6c, $b7, $90, $22, $21, $3d, $38, $71, $f0, $e0, $c4, $ed, $93, $3b, $33, $46, $d4, $be, $7a, $04, $9c, $1f, $c8, $b8, $79, $7b, $a3, $c0, $01, $89, $8e, $af, $28, $b9, $c6, $d3, $46, $50, $c0, $e3, $4d, $5d, $1f, $2d, $0b, $7e, $f6, $cd, $f3, $5e, $74, $4d, $1e, $6e, $28, $68, $d0, $74, $00, $f0, $70, $b4, $9f, $e7, $e9, $3c, $58, $a0, $74, $81, $0c, $82, $62, $f8, $f1, $f3, $e3, $57, $e8, $a1, $0b, $33, $99, $6d, $c1, $a6, $78, $00, $38, $27, $83, $22, $02, $64, $6e, $9d, $07, $22, $56, $6c, $b8, $c0, $3c, $01, $44, $84, $82, $37, $7f, $5b, $44, $08, $ec, $f0, $f3, $27, $6b, $b7, $b7, $74, $78, $e0, $72, $e1, $43, $49, $0d, $49, $a5, $11, $0f, $b2, $14, $b4, $50, $f2, $65, $46, $8a, $08, $3c, $01, $0c, $91, $06, $bf, $18, $6b, $f1, $0a, $79, $50, $c9, $61, $0f, $3f, $fc, $e8, $a1, $e3, $67, $6f, $ba, $5a, $6b, $34, $4a, $a5, $d2, $d2, $a0, $e3, $e3, $c7, $8f, $8f, $9f, $3f, $bf, $75, $db, $e6, $d6, $cd, $5e, $4f, $9b, $1f, $38, $f1, $f8, $f1, $e5, $f7, $ef, $df, $c5, $92, $e1, $49, $99, $3b, $23, $e2, $c4, $9f, $3f, $db

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

