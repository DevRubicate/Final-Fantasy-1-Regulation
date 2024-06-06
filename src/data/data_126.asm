.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_DONTFORGET, TEXT_INTRO_STORY_7, TEXT_INTRO_STORY_9, TEXT_INTRO_STORY_1, TEXT_SHOP_WHOWILLTAKEIT, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_HERO_0_NAME, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $23, $33, $39, $7f, $2c, $25, $3a, $29, $7f, $32, $33, $38, $2c, $2d, $32, $2b, $7f, $38, $33, $7e, $37, $29, $30, $30, $7f, $7f, $0b, $32, $3d, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $0e, $33, $32, $46, $38, $7f, $2a, $33, $36, $2b, $29, $38, $3f, $7f, $2d, $2a, $7e, $3d, $33, $39, $7f, $30, $29, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $2b, $25, $31, $29, $3f, $00

; address 81 - 111 (bytes 0 - 30)
TEXT_INTRO_STORY_7:
.byte $21, $2c, $29, $32, $7e, $38, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $2d, $32, $7e, $28, $25, $36, $2f, $32, $29, $37, $37, $00

; address 111 - 137 (bytes 0 - 26)
TEXT_INTRO_STORY_9:
.byte $0b, $2a, $38, $29, $36, $7e, $25, $7e, $30, $33, $32, $2b, $7e, $2e, $33, $39, $36, $32, $29, $3d, $7e, $2a, $33, $39, $36, $00

; address 137 - 160 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $1e, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $3a, $29, $2d, $30, $29, $28, $7e, $2d, $32, $00

; address 160 - 178 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $38, $25, $2f, $29, $7f, $2d, $38, $42, $00

; address 178 - 188 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $0c, $39, $3d, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 188 - 196 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $21, $2c, $40, $17, $0b, $11, $0f, $00

; address 196 - 203 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $21, $0f, $0b, $1a, $19, $18, $00

; address 203 - 208 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 208 - 213 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 213 - 218 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 218 - 8192
.res 7974

