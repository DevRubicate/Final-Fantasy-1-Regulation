.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_TOOBAD, TEXT_INTRO_STORY_1, TEXT_SHOP_WHATDOYOUWANT, TEXT_INVENTORY, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_CLASS_NAME_NINJA, TEXT_HERO_2_NAME, TEXT_ITEM_DESCRIPTION, TEXT_DASH

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $23, $33, $39, $7f, $25, $30, $36, $29, $25, $28, $3d, $7f, $2f, $32, $33, $3b, $7f, $38, $2c, $25, $38, $7f, $37, $34, $29, $30, $30, $40, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 83 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $1e, $2c, $2d, $37, $7f, $30, $29, $3a, $29, $30, $7f, $37, $34, $29, $30, $30, $7f, $2d, $37, $7e, $2a, $39, $30, $30, $7f, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 83 - 115 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $21, $2c, $33, $37, $29, $7f, $2d, $38, $29, $31, $7f, $28, $33, $7e, $3d, $33, $39, $7f, $3b, $25, $32, $38, $7e, $38, $33, $7f, $37, $29, $30, $30, $42, $00

; address 115 - 142 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $1e, $33, $33, $7e, $26, $25, $28, $7f, $7f, $1d, $33, $31, $29, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 142 - 165 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $1e, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $3a, $29, $2d, $30, $29, $28, $7e, $2d, $32, $00

; address 165 - 183 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $21, $2c, $25, $38, $7e, $28, $33, $7f, $3d, $33, $39, $7f, $3b, $25, $32, $38, $42, $00

; address 183 - 193 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $13, $18, $20, $0f, $18, $1e, $19, $1c, $23, $00

; address 193 - 201 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $21, $2c, $40, $17, $0b, $11, $0f, $00

; address 201 - 208 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $21, $0f, $0b, $1a, $19, $18, $00

; address 208 - 214 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $18, $13, $18, $14, $0b, $00

; address 214 - 219 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 219 - 224 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 224 - 226 (bytes 0 - 2)
TEXT_DASH:
.byte $41, $00

; 226 - 8192
.res 7966

