.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $02, $02, $92, $02, $02, $1a, $82, $86, $8f, $80, $02, $02, $02, $16, $1e, $02, $84, $90, $4c, $84, $91, $7f, $7f, $21, $3c, $3a, $02, $02, $02, $0a, $05, $02, $02, $02, $1a, $3d, $2b, $33, $02, $02, $09, $05, $7f, $0f, $2f, $31, $02, $02, $02, $0a, $05, $02, $02, $02, $16, $31, $3c, $02, $02, $02, $06, $05, $7f, $24, $31, $3c, $02, $02, $02, $0c, $05, $02, $02, $02, $12, $2d, $2e, $02, $02, $02, $06, $0a, $7f, $17, $36, $3c, $02, $02, $02, $08, $05, $02, $02, $02, $1b, $12, $2d, $2e, $02, $02, $08, $05, $7f, $25, $31, $3b, $02, $02, $02, $07, $05, $02, $02, $02, $13, $3e, $29, $2c, $2d, $02, $09, $05, $00

; address 124 - 149 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $25, $0f, $20, $20, $17, $1d, $20, $7f, $7f, $20, $2d, $3c, $3d, $3a, $36, $7f, $3c, $37, $7f, $34, $31, $2e, $2d, $47, $00

; address 149 - 171 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $25, $30, $37, $7f, $3b, $30, $29, $34, $34, $7f, $2a, $2d, $7f, $3a, $2d, $3e, $31, $3e, $2d, $2c, $7f, $00

; address 171 - 187 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $11, $02, $06, $0e, $0e, $05, $02, $1c, $17, $1c, $22, $13, $1c, $12, $1d, $00

; address 187 - 196 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $10, $1a, $0f, $11, $19, $25, $17, $28, $00

; address 196 - 203 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $19, $1c, $17, $15, $16, $22, $00

; address 203 - 210 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $11, $1a, $17, $1c, $17, $11, $00

; address 210 - 216 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 216 - 222 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; address 222 - 227 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 227 - 232 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 232 - 8192
.res 7960

