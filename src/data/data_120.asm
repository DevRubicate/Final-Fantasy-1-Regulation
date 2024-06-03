.segment "DATA_120"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_SHOP_WHOSEITEMSELL, TEXT_INTRO_STORY_9, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_WHATDOYOUWANT, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_RED_MAGE, TEXT_MENU_GOLD, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 96 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $21, $2c, $33, $37, $29, $7f, $2d, $38, $29, $31, $7f, $28, $33, $7e, $3d, $33, $39, $7f, $3b, $25, $32, $38, $7e, $38, $33, $7f, $37, $29, $30, $30, $42, $00

; address 96 - 122 (bytes 0 - 26)
TEXT_INTRO_STORY_9:
.byte $0b, $2a, $38, $29, $36, $7e, $25, $7e, $30, $33, $32, $2b, $7e, $2e, $33, $39, $36, $32, $29, $3d, $7e, $2a, $33, $39, $36, $00

; address 122 - 146 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 146 - 164 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $21, $2c, $25, $38, $7e, $28, $33, $7f, $3d, $33, $39, $7f, $3b, $25, $32, $38, $42, $00

; address 164 - 180 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $0c, $39, $3d, $7f, $7f, $1d, $29, $30, $30, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 180 - 188 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $1c, $29, $28, $17, $0b, $11, $0f, $00

; address 188 - 195 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $7e, $11, $00

; address 195 - 201 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 201 - 207 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; 207 - 8192
.res 7985

