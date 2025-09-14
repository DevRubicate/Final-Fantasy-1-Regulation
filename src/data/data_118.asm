.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_CLASS_NAME_NINJA, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, TEXT_SHOP_TITLEINN, TEXT_DASH, LUT_METATILE_TOP_LEFT, LUT_METATILE_TOP_LEFT_SIBLING2, LUT_MAP_METATILES_LO, LUT_MAP_METATILES_HI, MAP_0_METATILES

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $0f, $02, $10, $02, $11, $02, $12, $02, $13, $02, $14, $02, $15, $02, $16, $02, $17, $02, $18, $7f, $7f, $19, $02, $1a, $02, $1b, $02, $1c, $02, $1d, $02, $1e, $02, $1f, $02, $20, $02, $21, $02, $22, $7f, $7f, $23, $02, $24, $02, $25, $02, $26, $02, $27, $02, $28, $02, $4a, $02, $43, $02, $44, $02, $02, $7f, $7f, $05, $02, $06, $02, $07, $02, $08, $02, $09, $02, $0a, $02, $0b, $02, $0c, $02, $0d, $02, $0e, $7f, $7f, $29, $02, $2a, $02, $2b, $02, $2c, $02, $2d, $02, $2e, $02, $2f, $02, $30, $02, $31, $02, $32, $7f, $7f, $33, $02, $34, $02, $35, $02, $36, $02, $37, $02, $38, $02, $39, $02, $3a, $02, $3b, $02, $3c, $7f, $7f, $3d, $02, $3e, $02, $3f, $02, $40, $02, $41, $02, $42, $02, $45, $02, $49, $02, $47, $02, $46, $00

; address 146 - 168 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $41, $37, $3d, $36, $2f, $02, $3f, $29, $3a, $3a, $31, $37, $3a, $3b, $02, $29, $3a, $3a, $31, $3e, $2d, $00

; address 168 - 184 (bytes 0 - 16)
TEXT_INTRO_STORY_5:
.byte $22, $30, $2d, $02, $38, $2d, $37, $38, $34, $2d, $02, $3f, $29, $31, $3c, $00

; address 184 - 194 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $10, $3d, $41, $7f, $7f, $13, $40, $31, $3c, $00

; address 194 - 202 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $10, $34, $44, $1b, $0f, $15, $13, $00

; address 202 - 209 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $25, $1b, $0f, $15, $17, $11, $00

; address 209 - 215 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $1c, $17, $1c, $18, $0f, $00

; address 215 - 220 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 220 - 225 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 225 - 229 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $17, $1c, $1c, $00

; address 229 - 231 (bytes 0 - 2)
TEXT_DASH:
.byte $45, $00

; address 231 - 233 (bytes 0 - 2)
LUT_METATILE_TOP_LEFT:
.byte <TILE_ANIMATION_0, <TILE_ANIMATION_4

; address 233 - 235 (bytes 0 - 2)
LUT_METATILE_TOP_LEFT_SIBLING2:
.byte >TILE_ANIMATION_0, >TILE_ANIMATION_4

; address 235 - 236 (bytes 0 - 1)
LUT_MAP_METATILES_LO:
.byte <MAP_0_METATILES

; address 236 - 237 (bytes 0 - 1)
LUT_MAP_METATILES_HI:
.byte >MAP_0_METATILES

; address 237 - 242 (bytes 0 - 5)
MAP_0_METATILES:
.byte >METATILE_GRASS, <METATILE_GRASS, >METATILE_WATER, <METATILE_WATER, $ff

; 242 - 8192
.res 7950

