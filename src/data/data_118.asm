.segment "DATA_118"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_CLASS_NAME_RED_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_HERO_1_NAME, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $61, $61, $92, $61, $61, $35, $82, $86, $8f, $80, $02, $61, $61, $31, $39, $61, $84, $90, $1a, $84, $91, $7f, $7f, $3c, $57, $55, $61, $61, $61, $25, $20, $61, $61, $61, $35, $58, $46, $4e, $61, $61, $24, $20, $7f, $2a, $4a, $4c, $61, $61, $61, $25, $20, $61, $61, $61, $31, $4c, $57, $61, $61, $61, $21, $20, $7f, $3f, $4c, $57, $61, $61, $61, $27, $20, $61, $61, $61, $2d, $48, $49, $61, $61, $61, $21, $25, $7f, $32, $51, $57, $61, $61, $61, $23, $20, $61, $61, $61, $36, $2d, $48, $49, $61, $61, $23, $20, $7f, $40, $4c, $56, $61, $61, $61, $22, $20, $61, $61, $61, $2e, $59, $44, $47, $48, $61, $24, $20, $00

; address 124 - 132 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $3b, $48, $47, $36, $2a, $30, $2e, $00

; address 132 - 139 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $40, $2e, $2a, $39, $38, $37, $00

; address 139 - 144 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 144 - 149 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 149 - 154 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 154 - 8192
.res 8038

