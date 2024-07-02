.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $7e, $7e, $92, $7e, $7e, $16, $82, $86, $8f, $80, $02, $7e, $7e, $12, $1a, $7e, $84, $90, $48, $84, $91, $7f, $7f, $1d, $38, $36, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $16, $39, $27, $2f, $7e, $7e, $05, $01, $7f, $0b, $2b, $2d, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $12, $2d, $38, $7e, $7e, $7e, $02, $01, $7f, $20, $2d, $38, $7e, $7e, $7e, $08, $01, $7e, $7e, $7e, $0e, $29, $2a, $7e, $7e, $7e, $02, $06, $7f, $13, $32, $38, $7e, $7e, $7e, $04, $01, $7e, $7e, $7e, $17, $0e, $29, $2a, $7e, $7e, $04, $01, $7f, $21, $2d, $37, $7e, $7e, $7e, $03, $01, $7e, $7e, $7e, $0f, $3a, $25, $28, $29, $7e, $05, $01, $00

; address 124 - 149 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $21, $0b, $1c, $1c, $13, $19, $1c, $7f, $7f, $1c, $29, $38, $39, $36, $32, $7f, $38, $33, $7f, $30, $2d, $2a, $29, $43, $00

; address 149 - 171 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $21, $2c, $33, $7f, $37, $2c, $25, $30, $30, $7f, $26, $29, $7f, $36, $29, $3a, $2d, $3a, $29, $28, $7f, $00

; address 171 - 187 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $0d, $7e, $02, $0a, $0a, $01, $7e, $18, $13, $18, $1e, $0f, $18, $0e, $19, $00

; address 187 - 196 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $0c, $16, $0b, $0d, $15, $21, $13, $24, $00

; address 196 - 203 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $15, $18, $13, $11, $12, $1e, $00

; address 203 - 210 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $0d, $16, $13, $18, $13, $0d, $00

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

