.segment "DATA_122"

.export TEXT_EXAMPLE_EQUIP_LIST, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_SHOP_ITEMCOSTOK, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLEINN

; address 0 - 51 (bytes 0 - 51)
TEXT_EXAMPLE_EQUIP_LIST:
.byte $2e, $61, $32, $55, $52, $51, $61, $3c, $5a, $52, $55, $47, $7f, $2e, $61, $32, $55, $52, $51, $61, $31, $48, $4f, $50, $48, $57, $7f, $2e, $61, $2b, $55, $44, $46, $48, $4f, $48, $57, $7f, $61, $61, $40, $52, $52, $47, $48, $51, $61, $2a, $5b, $48, $00

; address 51 - 83 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $40, $4b, $52, $56, $48, $7f, $4c, $57, $48, $50, $7f, $47, $52, $61, $5c, $52, $58, $7f, $5a, $44, $51, $57, $61, $57, $52, $7f, $56, $48, $4f, $4f, $65, $00

; address 83 - 106 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $44, $49, $49, $52, $55, $47, $7f, $57, $4b, $44, $57, $60, $00

; address 106 - 120 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $30, $52, $4f, $47, $7f, $38, $34, $65, $00

; address 120 - 129 (bytes 0 - 9)
TEXT_TITLE_CONTINUE:
.byte $2c, $38, $37, $3d, $32, $37, $3e, $2e, $00

; address 129 - 137 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $2b, $4f, $60, $36, $2a, $30, $2e, $00

; address 137 - 144 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $2b, $36, $2a, $30, $32, $2c, $00

; address 144 - 148 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $32, $37, $37, $00

; 148 - 8192
.res 8044

