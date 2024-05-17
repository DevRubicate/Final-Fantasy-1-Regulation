.segment "DATA_119"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_TITLE_NEW_GAME, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_HERO_2_NAME, TEXT_SHOP_TITLEINN

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $61, $61, $92, $61, $61, $35, $82, $86, $8f, $80, $02, $61, $61, $31, $39, $61, $84, $90, $1a, $84, $91, $7f, $7f, $3c, $57, $55, $61, $61, $61, $25, $20, $61, $61, $61, $35, $58, $46, $4e, $61, $61, $24, $20, $7f, $2a, $4a, $4c, $61, $61, $61, $25, $20, $61, $61, $61, $31, $4c, $57, $61, $61, $61, $21, $20, $7f, $3f, $4c, $57, $61, $61, $61, $27, $20, $61, $61, $61, $2d, $48, $49, $61, $61, $61, $21, $25, $7f, $32, $51, $57, $61, $61, $61, $23, $20, $61, $61, $61, $36, $2d, $48, $49, $61, $61, $23, $20, $7f, $40, $4c, $56, $61, $61, $61, $22, $20, $61, $61, $61, $2e, $59, $44, $47, $48, $61, $24, $20, $00

; address 124 - 140 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $2c, $61, $21, $29, $29, $20, $61, $37, $32, $37, $3d, $2e, $37, $2d, $38, $00

; address 140 - 149 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $37, $2e, $40, $61, $30, $2a, $36, $2e, $00

; address 149 - 157 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $40, $48, $4f, $46, $52, $50, $48, $00

; address 157 - 164 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $2b, $36, $2a, $30, $32, $2c, $00

; address 164 - 169 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 169 - 173 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $32, $37, $37, $00

; 173 - 8192
.res 8019

