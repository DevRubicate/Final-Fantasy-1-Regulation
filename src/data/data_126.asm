.segment "DATA_126"

.export TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_DONTFORGET, TEXT_SHOP_RETURNLIFE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_SHOP_BUYEXIT, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLEARMOR, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 40 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $3d, $4b, $4c, $56, $7f, $4f, $48, $59, $48, $4f, $7f, $56, $53, $48, $4f, $4f, $7f, $4c, $56, $61, $49, $58, $4f, $4f, $7f, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 40 - 78 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $2d, $52, $51, $5e, $57, $7f, $49, $52, $55, $4a, $48, $57, $5f, $7f, $4c, $49, $61, $5c, $52, $58, $7f, $4f, $48, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $4a, $44, $50, $48, $5f, $00

; address 78 - 103 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $40, $2a, $3b, $3b, $32, $38, $3b, $7f, $7f, $3b, $48, $57, $58, $55, $51, $7f, $57, $52, $7f, $4f, $4c, $49, $48, $64, $00

; address 103 - 119 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $2c, $61, $21, $29, $28, $27, $61, $3c, $3a, $3e, $2a, $3b, $2e, $61, $61, $00

; address 119 - 129 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $2b, $58, $5c, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 129 - 137 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $40, $48, $4f, $46, $52, $50, $48, $00

; address 137 - 143 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $2a, $3b, $36, $38, $3b, $00

; address 143 - 148 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 148 - 153 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 153 - 8192
.res 8039

