.segment "DATA_125"

.include "src/global-import.inc"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_DONTFORGET, TEXT_INTRO_STORY_4, TEXT_INTRO_STORY_2, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_WIZARD, TEXT_CLASS_NAME_THIEF, TEXT_HERO_3_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $42, $52, $58, $7f, $44, $4f, $55, $48, $44, $47, $5c, $7f, $4e, $51, $52, $5a, $7f, $57, $4b, $44, $57, $7f, $56, $53, $48, $4f, $4f, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $2d, $52, $51, $5e, $57, $7f, $49, $52, $55, $4a, $48, $57, $5f, $7f, $4c, $49, $5e, $5c, $52, $58, $7f, $4f, $48, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $4a, $44, $50, $48, $5f, $00

; address 81 - 110 (bytes 0 - 29)
TEXT_INTRO_STORY_4:
.byte $44, $51, $47, $5e, $57, $4b, $48, $5e, $56, $48, $44, $55, $57, $4b, $5e, $45, $48, $4a, $4c, $51, $56, $5e, $57, $52, $5e, $55, $52, $57, $00

; address 110 - 135 (bytes 0 - 25)
TEXT_INTRO_STORY_2:
.byte $47, $44, $55, $4e, $51, $48, $56, $56, $5e, $5e, $3d, $4b, $48, $5e, $5a, $4c, $51, $47, $5e, $56, $57, $52, $53, $56, $00

; address 135 - 157 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $40, $4b, $52, $7f, $56, $4b, $44, $4f, $4f, $7f, $45, $48, $7f, $55, $48, $59, $4c, $59, $48, $47, $7f, $00

; address 157 - 173 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $2c, $5e, $21, $29, $29, $20, $5e, $37, $32, $37, $3d, $2e, $37, $2d, $38, $00

; address 173 - 181 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $2b, $4f, $60, $2b, $2e, $35, $3d, $00

; address 181 - 188 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $3b, $2e, $2d, $40, $32, $43, $00

; address 188 - 194 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $3d, $31, $32, $2e, $2f, $00

; address 194 - 199 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; address 199 - 203 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 203 - 207 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 207 - 8192
.res 7985

