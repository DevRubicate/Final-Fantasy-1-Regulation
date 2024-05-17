.segment "DATA_125"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_DONTFORGET, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_TITLE_RESPOND_RATE, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_HERO_1_NAME, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $42, $52, $58, $7f, $44, $4f, $55, $48, $44, $47, $5c, $7f, $4e, $51, $52, $5a, $7f, $57, $4b, $44, $57, $7f, $56, $53, $48, $4f, $4f, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $2d, $52, $51, $5e, $57, $7f, $49, $52, $55, $4a, $48, $57, $5f, $7f, $4c, $49, $61, $5c, $52, $58, $7f, $4f, $48, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $4a, $44, $50, $48, $5f, $00

; address 81 - 109 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $61, $61, $2e, $3a, $3e, $32, $39, $61, $61, $61, $38, $39, $3d, $32, $36, $32, $43, $2e, $61, $61, $61, $3b, $2e, $36, $38, $3f, $2e, $00

; address 109 - 130 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $3b, $2e, $3c, $39, $38, $37, $2d, $61, $3b, $2a, $3d, $2e, $61, $81, $86, $83, $5c, $10, $80, $01, $00

; address 130 - 146 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $2b, $58, $5c, $7f, $7f, $3c, $48, $4f, $4f, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 146 - 154 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $2b, $4f, $60, $36, $2a, $30, $2e, $00

; address 154 - 161 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $40, $36, $2a, $30, $32, $2c, $00

; address 161 - 166 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 166 - 171 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 171 - 176 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 176 - 8192
.res 8016

