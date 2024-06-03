.segment "DATA_125"

.include "src/global-import.inc"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_DONTFORGET, TEXT_SHOP_NOBODYDEAD, TEXT_INTRO_STORY_2, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_NEW_GAME, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_HERO_1_NAME, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $23, $33, $39, $7f, $25, $30, $36, $29, $25, $28, $3d, $7f, $2f, $32, $33, $3b, $7f, $38, $2c, $25, $38, $7f, $37, $34, $29, $30, $30, $40, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $0e, $33, $32, $46, $38, $7f, $2a, $33, $36, $2b, $29, $38, $3f, $7f, $2d, $2a, $7e, $3d, $33, $39, $7f, $30, $29, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $2b, $25, $31, $29, $3f, $00

; address 81 - 110 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $23, $33, $39, $7e, $28, $33, $7f, $32, $33, $38, $7f, $32, $29, $29, $28, $7e, $31, $3d, $7f, $2c, $29, $30, $34, $7f, $32, $33, $3b, $40, $00

; address 110 - 135 (bytes 0 - 25)
TEXT_INTRO_STORY_2:
.byte $28, $25, $36, $2f, $32, $29, $37, $37, $7e, $7e, $1e, $2c, $29, $7e, $3b, $2d, $32, $28, $7e, $37, $38, $33, $34, $37, $00

; address 135 - 158 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $25, $2a, $2a, $33, $36, $28, $7f, $38, $2c, $25, $38, $40, $00

; address 158 - 174 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $0d, $7e, $02, $0a, $09, $08, $7e, $1d, $1b, $1f, $0b, $1c, $0f, $7e, $7e, $00

; address 174 - 183 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $18, $0f, $21, $7e, $11, $0b, $17, $0f, $00

; address 183 - 191 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $0c, $30, $40, $17, $0b, $11, $0f, $00

; address 191 - 198 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $21, $17, $0b, $11, $13, $0d, $00

; address 198 - 203 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 203 - 208 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 208 - 213 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 213 - 8192
.res 7979

