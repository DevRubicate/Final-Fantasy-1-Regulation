.segment "DATA_125"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_YOUHAVENOTHING, TEXT_INTRO_STORY_7, TEXT_INTRO_STORY_9, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_WHOWILLTAKEIT, TEXT_TITLE_NEW_GAME, TEXT_CLASS_NAME_RED_MAGE, TEXT_MENU_GOLD, TEXT_CLASS_NAME_THIEF, TEXT_HERO_1_NAME, TEXT_ITEM_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $1d, $33, $36, $36, $3d, $3f, $7f, $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $30, $29, $25, $36, $32, $7f, $38, $2c, $25, $38, $40, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 86 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $23, $33, $39, $7f, $2c, $25, $3a, $29, $7f, $32, $33, $38, $2c, $2d, $32, $2b, $7f, $38, $33, $7e, $37, $29, $30, $30, $7f, $7f, $0b, $32, $3d, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 86 - 116 (bytes 0 - 30)
TEXT_INTRO_STORY_7:
.byte $21, $2c, $29, $32, $7e, $38, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $2d, $32, $7e, $28, $25, $36, $2f, $32, $29, $37, $37, $00

; address 116 - 142 (bytes 0 - 26)
TEXT_INTRO_STORY_9:
.byte $0b, $2a, $38, $29, $36, $7e, $25, $7e, $30, $33, $32, $2b, $7e, $2e, $33, $39, $36, $32, $29, $3d, $7e, $2a, $33, $39, $36, $00

; address 142 - 166 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 166 - 184 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $38, $25, $2f, $29, $7f, $2d, $38, $42, $00

; address 184 - 193 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $18, $0f, $21, $7e, $11, $0b, $17, $0f, $00

; address 193 - 201 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $1c, $29, $28, $17, $0b, $11, $0f, $00

; address 201 - 208 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $7e, $11, $00

; address 208 - 214 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $1e, $12, $13, $0f, $10, $00

; address 214 - 219 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 219 - 224 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 224 - 228 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 228 - 232 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 232 - 8192
.res 7960

