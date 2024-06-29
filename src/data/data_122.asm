.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_INTRO_STORY_8, TEXT_TITLE_RESPOND_RATE, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLEBLACKMAGIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, TEXT_SHOP_TITLEINN

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 98 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $21, $29, $30, $27, $33, $31, $29, $7f, $7f, $1d, $38, $25, $3d, $3f, $7f, $38, $33, $7e, $37, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $28, $25, $38, $25, $40, $00

; address 98 - 126 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $7e, $7e, $0f, $1b, $1f, $13, $1a, $7e, $7e, $7e, $19, $1a, $1e, $13, $17, $13, $24, $0f, $7e, $7e, $7e, $1c, $0f, $17, $19, $20, $0f, $00

; address 126 - 150 (bytes 0 - 24)
TEXT_INTRO_STORY_8:
.byte $10, $33, $39, $36, $7e, $21, $25, $36, $36, $2d, $33, $36, $37, $7e, $3b, $2d, $30, $30, $7e, $27, $33, $31, $29, $00

; address 150 - 171 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $1c, $0f, $1d, $1a, $19, $18, $0e, $7e, $1c, $0b, $1e, $0f, $7e, $81, $86, $83, $5c, $10, $80, $01, $00

; address 171 - 185 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $11, $33, $30, $28, $7f, $19, $15, $42, $00

; address 185 - 194 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $21, $12, $13, $1e, $0f, $21, $13, $24, $00

; address 194 - 202 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $21, $29, $30, $27, $33, $31, $29, $00

; address 202 - 209 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $0c, $17, $0b, $11, $13, $0d, $00

; address 209 - 215 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 215 - 221 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; address 221 - 225 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $13, $18, $18, $00

; 225 - 8192
.res 7967

