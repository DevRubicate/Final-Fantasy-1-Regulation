.segment "DATA_114"

.include "src/global-import.inc"

.export MASSIVE_CRAB_IMAGE, TEXT_ALPHABET, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_CLASS_NAME_NINJA, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, TEXT_SHOP_TITLEINN, TEXT_DASH, LUT_METATILE_TOP_LEFT, LUT_METATILE_TOP_LEFT_SIBLING2, LUT_MAP_METATILES_LO, LUT_MAP_METATILES_HI, MAP_0_METATILES

; address 0 - 256 (bytes 0 - 256)
MASSIVE_CRAB_IMAGE:
.byte $02, $99, $22, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $4e, $77, $68, $64, $a6, $03, $a0, $40, $44, $a1, $e1, $9a, $66, $a7, $c9, $1c, $2f, $be, $e1, $b0, $c0, $84, $80, $02, $4f, $07, $ea, $cc, $8d, $01, $1b, $76, $a4, $f4, $b1, $85, $1b, $0f, $2f, $56, $78, $7c, $f9, $73, $31, $03, $86, $8a, $9e, $71, $58, $d2, $01, $e7, $3c, $04, $0c, $88, $10, $c0, $39, $19, $00, $3c, $22, $70, $36, $20, $43, $c2, $84, $2c, $29, $03, $82, $0e, $80, $02, $bf, $3a, $9e, $14, $e7, $74, $40, $94, $90, $21, $55, $00, $06, $04, $9f, $c0, $83, $64, $61, $70, $ce, $39, $8f, $80, $9c, $73, $ce, $13, $40, $04, $88, $42, $0f, $2f, $1d, $36, $9e, $7a, $fe, $e8, $32, $11, $5e, $f1, $31, $b6, $71, $65, $a8, $e1, $10, $81, $c8, $01, $c8, $40, $59, $3d, $33, $2e, $b0, $48, $7c, $74, $fa, $45, $05, $2b, $60, $78, $02, $0c, $94, $50, $d8, $b1, $ca, $66, $d6, $99, $8e, $1f, $80, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39, $e7, $9c, $73, $ce, $39

; address 256 - 402 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $0f, $02, $10, $02, $11, $02, $12, $02, $13, $02, $14, $02, $15, $02, $16, $02, $17, $02, $18, $7f, $7f, $19, $02, $1a, $02, $1b, $02, $1c, $02, $1d, $02, $1e, $02, $1f, $02, $20, $02, $21, $02, $22, $7f, $7f, $23, $02, $24, $02, $25, $02, $26, $02, $27, $02, $28, $02, $4a, $02, $43, $02, $44, $02, $02, $7f, $7f, $05, $02, $06, $02, $07, $02, $08, $02, $09, $02, $0a, $02, $0b, $02, $0c, $02, $0d, $02, $0e, $7f, $7f, $29, $02, $2a, $02, $2b, $02, $2c, $02, $2d, $02, $2e, $02, $2f, $02, $30, $02, $31, $02, $32, $7f, $7f, $33, $02, $34, $02, $35, $02, $36, $02, $37, $02, $38, $02, $39, $02, $3a, $02, $3b, $02, $3c, $7f, $7f, $3d, $02, $3e, $02, $3f, $02, $40, $02, $41, $02, $42, $02, $45, $02, $49, $02, $47, $02, $46, $00

; address 402 - 424 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $41, $37, $3d, $36, $2f, $02, $3f, $29, $3a, $3a, $31, $37, $3a, $3b, $02, $29, $3a, $3a, $31, $3e, $2d, $00

; address 424 - 440 (bytes 0 - 16)
TEXT_INTRO_STORY_5:
.byte $22, $30, $2d, $02, $38, $2d, $37, $38, $34, $2d, $02, $3f, $29, $31, $3c, $00

; address 440 - 450 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $10, $3d, $41, $7f, $7f, $13, $40, $31, $3c, $00

; address 450 - 458 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $10, $34, $44, $1b, $0f, $15, $13, $00

; address 458 - 465 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $25, $1b, $0f, $15, $17, $11, $00

; address 465 - 471 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $1c, $17, $1c, $18, $0f, $00

; address 471 - 476 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 476 - 481 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 481 - 485 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $17, $1c, $1c, $00

; address 485 - 487 (bytes 0 - 2)
TEXT_DASH:
.byte $45, $00

; address 487 - 489 (bytes 0 - 2)
LUT_METATILE_TOP_LEFT:
.byte <TILE_ANIMATION_0, <TILE_ANIMATION_4

; address 489 - 491 (bytes 0 - 2)
LUT_METATILE_TOP_LEFT_SIBLING2:
.byte >TILE_ANIMATION_0, >TILE_ANIMATION_4

; address 491 - 492 (bytes 0 - 1)
LUT_MAP_METATILES_LO:
.byte <MAP_0_METATILES

; address 492 - 493 (bytes 0 - 1)
LUT_MAP_METATILES_HI:
.byte >MAP_0_METATILES

; address 493 - 498 (bytes 0 - 5)
MAP_0_METATILES:
.byte >METATILE_GRASS, <METATILE_GRASS, >METATILE_WATER, <METATILE_WATER, $ff

; 498 - 8192
.res 7694

