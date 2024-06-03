.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_INTRO_STORY_11, TEXT_TITLE_SELECT_NAME, TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_KNIGHT, TEXT_CLASS_NAME_THIEF, TEXT_HERO_3_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $0b, $7e, $0c, $7e, $0d, $7e, $0e, $7e, $0f, $7e, $10, $7e, $11, $7e, $12, $7e, $13, $7e, $14, $7f, $7f, $15, $7e, $16, $7e, $17, $7e, $18, $7e, $19, $7e, $1a, $7e, $1b, $7e, $1c, $7e, $1d, $7e, $1e, $7f, $7f, $1f, $7e, $20, $7e, $21, $7e, $22, $7e, $23, $7e, $24, $7e, $46, $7e, $3f, $7e, $40, $7e, $7e, $7f, $7f, $01, $7e, $02, $7e, $03, $7e, $04, $7e, $05, $7e, $06, $7e, $07, $7e, $08, $7e, $09, $7e, $0a, $7f, $7f, $25, $7e, $26, $7e, $27, $7e, $28, $7e, $29, $7e, $2a, $7e, $2b, $7e, $2c, $7e, $2d, $7e, $2e, $7f, $7f, $2f, $7e, $30, $7e, $31, $7e, $32, $7e, $33, $7e, $34, $7e, $35, $7e, $36, $7e, $37, $7e, $38, $7f, $7f, $39, $7e, $3a, $7e, $3b, $7e, $3c, $7e, $3d, $7e, $3e, $7e, $41, $7e, $45, $7e, $43, $7e, $42, $00

; address 146 - 166 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $29, $25, $27, $2c, $7e, $2c, $33, $30, $28, $2d, $32, $2b, $7e, $25, $32, $7e, $19, $1c, $0c, $00

; address 166 - 179 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $1d, $0f, $16, $0f, $0d, $1e, $7e, $7e, $18, $0b, $17, $0f, $00

; address 179 - 187 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $10, $13, $11, $12, $1e, $0f, $1c, $00

; address 187 - 194 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $15, $18, $13, $11, $12, $1e, $00

; address 194 - 200 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $1e, $12, $13, $0f, $10, $00

; address 200 - 205 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; address 205 - 209 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 209 - 213 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 213 - 8192
.res 7979

