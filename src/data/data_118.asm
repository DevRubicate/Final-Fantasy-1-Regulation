.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_SHOP_WHOREVIVE, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_WIZARD, TEXT_CLASS_NAME_NINJA, TEXT_HERO_3_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $0b, $7e, $0c, $7e, $0d, $7e, $0e, $7e, $0f, $7e, $10, $7e, $11, $7e, $12, $7e, $13, $7e, $14, $7f, $7f, $15, $7e, $16, $7e, $17, $7e, $18, $7e, $19, $7e, $1a, $7e, $1b, $7e, $1c, $7e, $1d, $7e, $1e, $7f, $7f, $1f, $7e, $20, $7e, $21, $7e, $22, $7e, $23, $7e, $24, $7e, $46, $7e, $3f, $7e, $40, $7e, $7e, $7f, $7f, $01, $7e, $02, $7e, $03, $7e, $04, $7e, $05, $7e, $06, $7e, $07, $7e, $08, $7e, $09, $7e, $0a, $7f, $7f, $25, $7e, $26, $7e, $27, $7e, $28, $7e, $29, $7e, $2a, $7e, $2b, $7e, $2c, $7e, $2d, $7e, $2e, $7f, $7f, $2f, $7e, $30, $7e, $31, $7e, $32, $7e, $33, $7e, $34, $7e, $35, $7e, $36, $7e, $37, $7e, $38, $7f, $7f, $39, $7e, $3a, $7e, $3b, $7e, $3c, $7e, $3d, $7e, $3e, $7e, $41, $7e, $45, $7e, $43, $7e, $42, $00

; address 146 - 168 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $21, $2c, $33, $7f, $37, $2c, $25, $30, $30, $7f, $26, $29, $7f, $36, $29, $3a, $2d, $3a, $29, $28, $7f, $00

; address 168 - 184 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $0c, $39, $3d, $7f, $7f, $1d, $29, $30, $30, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 184 - 192 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $0c, $30, $40, $0c, $0f, $16, $1e, $00

; address 192 - 199 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $1c, $0f, $0e, $21, $13, $24, $00

; address 199 - 205 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $18, $13, $18, $14, $0b, $00

; address 205 - 210 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; address 210 - 214 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 214 - 218 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 218 - 8192
.res 7974

