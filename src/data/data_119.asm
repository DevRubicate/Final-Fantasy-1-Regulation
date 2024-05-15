.segment "DATA_119"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_TITLE_RESPOND_RATE, TEXT_TITLE_SELECT_NAME, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_HERO_2_NAME, LUT_TILE_CHR, TILE_SEA, LUT_TILE_CHR_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 92 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $61, $61, $2e, $3a, $3e, $32, $39, $61, $61, $61, $38, $39, $3d, $32, $36, $32, $43, $2e, $61, $61, $61, $3b, $2e, $36, $38, $3f, $2e, $00

; address 92 - 113 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $3b, $2e, $3c, $39, $38, $37, $2d, $61, $3b, $2a, $3d, $2e, $61, $81, $86, $83, $5c, $10, $80, $01, $00

; address 113 - 126 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $3c, $2e, $35, $2e, $2c, $3d, $61, $61, $37, $2a, $36, $2e, $00

; address 126 - 134 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $40, $4b, $60, $36, $2a, $30, $2e, $00

; address 134 - 141 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $40, $36, $2a, $30, $32, $2c, $00

; address 141 - 146 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 146 - 147 (bytes 0 - 1)
LUT_TILE_CHR:
.byte <TILE_SEA

; address 147 - 151 (bytes 0 - 4)
TILE_SEA:
.byte $06, $27, $80, $ff

; address 151 - 152 (bytes 0 - 1)
LUT_TILE_CHR_SIBLING2:
.byte >TILE_SEA

; 152 - 8192
.res 8040

