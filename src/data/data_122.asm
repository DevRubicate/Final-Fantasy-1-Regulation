.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_INTRO_STORY_6, TEXT_INTRO_STORY_8, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_RED_WIZARD, TEXT_SHOP_TITLEARMOR, TEXT_ITEM_DESCRIPTION

; address 0 - 55 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $16, $7e, $82, $86, $8f, $80, $01, $7f, $7f, $12, $1a, $7f, $7e, $84, $90, $48, $84, $91, $7f, $7f, $7f, $17, $0b, $11, $13, $0d, $7f, $81, $92, $48, $81, $93, $48, $81, $94, $48, $81, $95, $48, $7f, $81, $96, $48, $81, $97, $48, $81, $98, $48, $81, $99, $00

; address 55 - 89 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $21, $29, $30, $27, $33, $31, $29, $7f, $7f, $1d, $38, $25, $3d, $3f, $7f, $38, $33, $7e, $37, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $28, $25, $38, $25, $40, $00

; address 89 - 116 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $38, $2c, $29, $2d, $36, $7e, $33, $32, $30, $3d, $7e, $2c, $33, $34, $29, $7e, $25, $7e, $34, $36, $33, $34, $2c, $29, $27, $3d, $00

; address 116 - 140 (bytes 0 - 24)
TEXT_INTRO_STORY_8:
.byte $10, $33, $39, $36, $7e, $21, $25, $36, $36, $2d, $33, $36, $37, $7e, $3b, $2d, $30, $30, $7e, $27, $33, $31, $29, $00

; address 140 - 162 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $21, $2c, $33, $7f, $37, $2c, $25, $30, $30, $7f, $26, $29, $7f, $36, $29, $3a, $2d, $3a, $29, $28, $7f, $00

; address 162 - 178 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $0d, $7e, $02, $0a, $0a, $01, $7e, $18, $13, $18, $1e, $0f, $18, $0e, $19, $00

; address 178 - 187 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $0c, $16, $0b, $0d, $15, $21, $13, $24, $00

; address 187 - 194 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $1c, $0f, $0e, $21, $13, $24, $00

; address 194 - 200 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $0b, $1c, $17, $19, $1c, $00

; address 200 - 205 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 205 - 8192
.res 7987

