.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_INTRO_STORY_8, TEXT_TITLE_RESPOND_RATE, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLEARMOR, TEXT_HERO_2_NAME, TEXT_ITEM_DESCRIPTION, TEXT_DASH

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 98 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $25, $2d, $34, $2b, $37, $35, $2d, $7f, $7f, $21, $3c, $29, $41, $43, $7f, $3c, $37, $02, $3b, $29, $3e, $2d, $7f, $41, $37, $3d, $3a, $7f, $2c, $29, $3c, $29, $44, $00

; address 98 - 126 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $02, $02, $13, $1f, $23, $17, $1e, $02, $02, $02, $1d, $1e, $22, $17, $1b, $17, $28, $13, $02, $02, $02, $20, $13, $1b, $1d, $24, $13, $00

; address 126 - 150 (bytes 0 - 24)
TEXT_INTRO_STORY_8:
.byte $14, $37, $3d, $3a, $02, $25, $29, $3a, $3a, $31, $37, $3a, $3b, $02, $3f, $31, $34, $34, $02, $2b, $37, $35, $2d, $00

; address 150 - 171 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $20, $13, $21, $1e, $1d, $1c, $12, $02, $20, $0f, $22, $13, $02, $81, $86, $83, $5c, $10, $80, $01, $00

; address 171 - 185 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $15, $37, $34, $2c, $7f, $1d, $19, $46, $00

; address 185 - 194 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $25, $16, $17, $22, $13, $25, $17, $28, $00

; address 194 - 202 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $25, $2d, $34, $2b, $37, $35, $2d, $00

; address 202 - 209 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $10, $1b, $0f, $15, $17, $11, $00

; address 209 - 215 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $0f, $20, $1b, $1d, $20, $00

; address 215 - 220 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 220 - 225 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 225 - 227 (bytes 0 - 2)
TEXT_DASH:
.byte $45, $00

; 227 - 8192
.res 7965

