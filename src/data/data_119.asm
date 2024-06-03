.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_INTRO_STORY_1, TEXT_SHOP_WHOWILLTAKEIT, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_MASTER, TEXT_CLASS_NAME_NINJA, TEXT_SHOP_TITLEITEM, TEXT_DASH

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $7e, $7e, $92, $7e, $7e, $16, $82, $86, $8f, $80, $02, $7e, $7e, $12, $1a, $7e, $84, $90, $48, $84, $91, $7f, $7f, $1d, $38, $36, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $16, $39, $27, $2f, $7e, $7e, $05, $01, $7f, $0b, $2b, $2d, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $12, $2d, $38, $7e, $7e, $7e, $02, $01, $7f, $20, $2d, $38, $7e, $7e, $7e, $08, $01, $7e, $7e, $7e, $0e, $29, $2a, $7e, $7e, $7e, $02, $06, $7f, $13, $32, $38, $7e, $7e, $7e, $04, $01, $7e, $7e, $7e, $17, $0e, $29, $2a, $7e, $7e, $04, $01, $7f, $21, $2d, $37, $7e, $7e, $7e, $03, $01, $7e, $7e, $7e, $0f, $3a, $25, $28, $29, $7e, $05, $01, $00

; address 124 - 147 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $1e, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $3a, $29, $2d, $30, $29, $28, $7e, $2d, $32, $00

; address 147 - 165 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $38, $25, $2f, $29, $7f, $2d, $38, $42, $00

; address 165 - 179 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $11, $33, $30, $28, $7f, $19, $15, $42, $00

; address 179 - 187 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $0c, $30, $40, $0c, $0f, $16, $1e, $00

; address 187 - 194 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $17, $0b, $1d, $1e, $0f, $1c, $00

; address 194 - 200 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $18, $13, $18, $14, $0b, $00

; address 200 - 205 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $13, $1e, $0f, $17, $00

; address 205 - 207 (bytes 0 - 2)
TEXT_DASH:
.byte $41, $00

; 207 - 8192
.res 7985

