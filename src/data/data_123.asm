.segment "DATA_123"

.include "src/global-import.inc"

.export TEXT_EXAMPLE_EQUIP_LIST, TEXT_SHOP_HOLDRESET, TEXT_INTRO_STORY_4, TEXT_INTRO_STORY_2, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_HERO_2_NAME, TEXT_SHOP_TITLEINN

; address 0 - 51 (bytes 0 - 51)
TEXT_EXAMPLE_EQUIP_LIST:
.byte $0f, $7e, $13, $36, $33, $32, $7e, $1d, $3b, $33, $36, $28, $7f, $0f, $7e, $13, $36, $33, $32, $7e, $12, $29, $30, $31, $29, $38, $7f, $0f, $7e, $0c, $36, $25, $27, $29, $30, $29, $38, $7f, $7e, $7e, $21, $33, $33, $28, $29, $32, $7e, $0b, $3c, $29, $00

; address 51 - 89 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $12, $33, $30, $28, $7f, $1c, $0f, $1d, $0f, $1e, $7f, $3b, $2c, $2d, $30, $29, $7f, $3d, $33, $39, $7f, $38, $39, $36, $32, $7f, $1a, $19, $21, $0f, $1c, $7f, $33, $2a, $2a, $43, $43, $00

; address 89 - 117 (bytes 0 - 28)
TEXT_INTRO_STORY_4:
.byte $25, $32, $28, $7e, $38, $2c, $29, $7e, $29, $25, $36, $38, $2c, $7e, $26, $29, $2b, $2d, $32, $37, $7e, $38, $33, $7e, $36, $33, $38, $00

; address 117 - 142 (bytes 0 - 25)
TEXT_INTRO_STORY_2:
.byte $28, $25, $36, $2f, $32, $29, $37, $37, $7e, $7e, $1e, $2c, $29, $7e, $3b, $2d, $32, $28, $7e, $37, $38, $33, $34, $37, $00

; address 142 - 164 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $3d, $33, $39, $32, $2b, $7e, $3b, $25, $36, $36, $2d, $33, $36, $37, $7e, $25, $36, $36, $2d, $3a, $29, $00

; address 164 - 180 (bytes 0 - 16)
TEXT_INTRO_STORY_5:
.byte $1e, $2c, $29, $7e, $34, $29, $33, $34, $30, $29, $7e, $3b, $25, $2d, $38, $00

; address 180 - 189 (bytes 0 - 9)
TEXT_TITLE_CONTINUE:
.byte $0d, $19, $18, $1e, $13, $18, $1f, $0f, $00

; address 189 - 197 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $0c, $30, $40, $17, $0b, $11, $0f, $00

; address 197 - 204 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $21, $17, $0b, $11, $13, $0d, $00

; address 204 - 209 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 209 - 213 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $13, $18, $18, $00

; 213 - 8192
.res 7979

