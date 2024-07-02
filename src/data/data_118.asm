.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_CLASS_NAME_NINJA, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $0b, $7e, $0c, $7e, $0d, $7e, $0e, $7e, $0f, $7e, $10, $7e, $11, $7e, $12, $7e, $13, $7e, $14, $7f, $7f, $15, $7e, $16, $7e, $17, $7e, $18, $7e, $19, $7e, $1a, $7e, $1b, $7e, $1c, $7e, $1d, $7e, $1e, $7f, $7f, $1f, $7e, $20, $7e, $21, $7e, $22, $7e, $23, $7e, $24, $7e, $46, $7e, $3f, $7e, $40, $7e, $7e, $7f, $7f, $01, $7e, $02, $7e, $03, $7e, $04, $7e, $05, $7e, $06, $7e, $07, $7e, $08, $7e, $09, $7e, $0a, $7f, $7f, $25, $7e, $26, $7e, $27, $7e, $28, $7e, $29, $7e, $2a, $7e, $2b, $7e, $2c, $7e, $2d, $7e, $2e, $7f, $7f, $2f, $7e, $30, $7e, $31, $7e, $32, $7e, $33, $7e, $34, $7e, $35, $7e, $36, $7e, $37, $7e, $38, $7f, $7f, $39, $7e, $3a, $7e, $3b, $7e, $3c, $7e, $3d, $7e, $3e, $7e, $41, $7e, $45, $7e, $43, $7e, $42, $00

; address 146 - 168 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $3d, $33, $39, $32, $2b, $7e, $3b, $25, $36, $36, $2d, $33, $36, $37, $7e, $25, $36, $36, $2d, $3a, $29, $00

; address 168 - 184 (bytes 0 - 16)
TEXT_INTRO_STORY_5:
.byte $1e, $2c, $29, $7e, $34, $29, $33, $34, $30, $29, $7e, $3b, $25, $2d, $38, $00

; address 184 - 194 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $0c, $39, $3d, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 194 - 202 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $0c, $30, $40, $17, $0b, $11, $0f, $00

; address 202 - 209 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $21, $17, $0b, $11, $13, $0d, $00

; address 209 - 215 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $18, $13, $18, $14, $0b, $00

; address 215 - 220 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 220 - 225 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 225 - 229 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 229 - 233 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 233 - 8192
.res 7959

