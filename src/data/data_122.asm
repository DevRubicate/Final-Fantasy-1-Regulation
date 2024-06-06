.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_MENU_SELECTION, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_THANKYOUWHATELSE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_MASTER, TEXT_CLASS_NAME_THIEF, TEXT_HERO_1_NAME, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2

; address 0 - 55 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $16, $7e, $82, $86, $8f, $80, $01, $7f, $7f, $12, $1a, $7f, $7e, $84, $90, $48, $84, $91, $7f, $7f, $7f, $17, $0b, $11, $13, $0d, $7f, $81, $92, $48, $81, $93, $48, $81, $94, $48, $81, $95, $48, $7f, $81, $96, $48, $81, $97, $48, $81, $98, $48, $81, $99, $00

; address 55 - 91 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $13, $1e, $0f, $17, $1d, $7f, $7f, $17, $0b, $11, $13, $0d, $7f, $7f, $21, $0f, $0b, $1a, $19, $18, $7f, $7f, $0b, $1c, $17, $19, $1c, $7f, $7f, $1d, $1e, $0b, $1e, $1f, $1d, $00

; address 91 - 119 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $7e, $7e, $0f, $1b, $1f, $13, $1a, $7e, $7e, $7e, $19, $1a, $1e, $13, $17, $13, $24, $0f, $7e, $7e, $7e, $1c, $0f, $17, $19, $20, $0f, $00

; address 119 - 144 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $21, $0b, $1c, $1c, $13, $19, $1c, $7f, $7f, $1c, $29, $38, $39, $36, $32, $7f, $38, $33, $7f, $30, $2d, $2a, $29, $43, $00

; address 144 - 166 (bytes 0 - 22)
TEXT_SHOP_THANKYOUWHATELSE:
.byte $1e, $2c, $25, $32, $2f, $7f, $3d, $33, $39, $43, $7f, $21, $2c, $25, $38, $7f, $29, $30, $37, $29, $42, $00

; address 166 - 182 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $0d, $7e, $02, $0a, $09, $08, $7e, $1d, $1b, $1f, $0b, $1c, $0f, $7e, $7e, $00

; address 182 - 191 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $0c, $16, $0b, $0d, $15, $21, $13, $24, $00

; address 191 - 198 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $17, $0b, $1d, $1e, $0f, $1c, $00

; address 198 - 204 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $1e, $12, $13, $0f, $10, $00

; address 204 - 209 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 209 - 214 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 214 - 219 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 219 - 8192
.res 7973

