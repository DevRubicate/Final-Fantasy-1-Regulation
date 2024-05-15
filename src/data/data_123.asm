.segment "DATA_123"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_HOLDRESET, TEXT_SHOP_YOUHAVETOOMANY, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_TITLE_NEW_GAME, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $3c, $52, $55, $55, $5c, $5f, $7f, $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $44, $57, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $31, $52, $4f, $47, $7f, $3b, $2e, $3c, $2e, $3d, $7f, $5a, $4b, $4c, $4f, $48, $7f, $5c, $52, $58, $7f, $57, $58, $55, $51, $7f, $39, $38, $40, $2e, $3b, $7f, $52, $49, $49, $64, $64, $00

; address 81 - 105 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 105 - 121 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $2c, $61, $21, $29, $29, $20, $61, $37, $32, $37, $3d, $2e, $37, $2d, $38, $00

; address 121 - 130 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $37, $2e, $40, $61, $30, $2a, $36, $2e, $00

; address 130 - 137 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $34, $37, $32, $30, $31, $3d, $00

; address 137 - 144 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $2c, $35, $32, $37, $32, $2c, $00

; address 144 - 148 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 148 - 152 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 152 - 8192
.res 8040

