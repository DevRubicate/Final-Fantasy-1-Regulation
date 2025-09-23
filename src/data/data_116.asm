.segment "DATA_116"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_CLASS_NAME_NINJA, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, TEXT_SHOP_TITLEINN, TEXT_DASH, LUT_METATILE_TOP_LEFT, LUT_METATILE_TOP_LEFT_SIBLING2, LUT_MAP_METATILES_LO, LUT_MAP_METATILES_HI, MAP_0_METATILES

; address 0 - 256 (bytes 512 - 768)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $37, $38, $9c, $a0, $f2, $1c, $47, $40, $c7, $58, $2e, $17, $20, $e1, $f1, $8f, $ca, $17, $58, $5d, $21, $74, $89, $ca, $1b, $1c, $61, $f1, $9b, $f8, $75, $1d, $43, $1d, $03, $82, $c7, $10, $e0, $b0, $e0, $b8, $2e, $0b, $0c, $38, $3c, $87, $18, $3c, $87, $18, $5c, $47, $10, $c3, $83, $c4, $30, $c7, $20, $c3, $1c, $60, $b8, $5c, $47, $28, $3c, $43, $0c, $72, $0c, $31, $c6, $0f, $28, $2e, $17, $28, $2e, $0f, $20, $c3, $1c, $83, $0c, $72, $0c, $31, $ca, $23, $0c, $71, $0e, $0b, $1c, $43, $1c, $83, $0c, $72, $0c, $38, $2e, $0b, $1c, $83, $83, $c8, $71, $1c, $e0, $b8, $2e, $0b, $84, $e1, $38, $4c, $30, $e1, $30, $c7, $18, $2c, $31, $c6, $0b, $0c, $71, $1c, $43, $1c, $47, $38, $2c, $7f, $e8, $39, $0e, $21, $8e, $30, $58, $63, $8c, $36, $1c, $17, $05, $c1, $61, $8e, $50, $b8, $c2, $e7, $0b, $a4, $2e, $70, $f9, $c3, $e5, $13, $88, $71, $78, $c7, $e7, $0f, $94, $4e, $23, $94, $16, $3a, $41, $ea, $39, $42, $63, $8c, $37, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf

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

