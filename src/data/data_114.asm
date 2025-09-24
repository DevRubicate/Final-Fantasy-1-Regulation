.segment "DATA_114"

.include "src/global-import.inc"

.export MASSIVE_CRAB_IMAGE, TEXT_ALPHABET, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_CLASS_NAME_NINJA, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, TEXT_SHOP_TITLEINN, TEXT_DASH, LUT_METATILE_TOP_LEFT, LUT_METATILE_TOP_LEFT_SIBLING2, LUT_MAP_METATILES_LO, LUT_MAP_METATILES_HI, MAP_0_METATILES

; address 0 - 256 (bytes 0 - 256)
MASSIVE_CRAB_IMAGE:
.byte $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $cc, $e8, $7b, $98, $c9, $3e, $1e, $34, $13, $a0, $89, $05, $70, $2b, $30, $1a, $ee, $b1, $4d, $e0, $bc, $c1, $29, $43, $66, $82, $14, $d8, $09, $bb, $04, $ab, $89, $ab, $9c, $06, $db, $02, $ab, $03, $f6, $64, $2d, $e8, $2d, $ad, $0d, $79, $c2, $bb, $e8, $07, $39, $ce, $72, $60, $00, $78, $00, $84, $01, $78, $10, $3c, $00, $17, $00, $03, $c2, $04, $20, $8b, $c1, $09, $75, $c8, $9b, $62, $5e, $19, $93, $01, $cb, $80, $08, $40, $1f, $00, $91, $80, $92, $e1, $32, $49, $19, $29, $2c, $1c, $e7, $39, $ce, $73, $9e, $40, $05, $c0, $24, $20, $0b, $9b, $88, $72, $f0, $26, $a8, $56, $74, $95, $cd, $29, $6f, $13, $b5, $6d, $ba, $d5, $a3, $33, $78, $2d, $b4, $06, $98, $0b, $d0, $0a, $58, $45, $50, $79, $e8, $85, $cf, $64, $24, $dc, $4d, $b0, $e0, $a3, $69, $12, $98, $f4, $14, $26, $b0, $1d, $e8, $03, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $97, $4a, $04, $d6, $16, $89, $33, $f1, $85, $9f, $02, $0f, $72, $03, $c8, $01, $ba, $81, $b7, $a2, $f6, $c2, $26, $a7, $94, $84, $21, $4f, $c0, $03, $9e, $a5, $9d, $5b, $da, $27, $34, $66, $65, $45, $da, $10, $c5

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

