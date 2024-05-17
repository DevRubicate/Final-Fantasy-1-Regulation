.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_HOLDRESET, TEXT_SHOP_TOOBAD, TEXT_SHOP_THANKYOUWHATELSE, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_MASTER, TEXT_CLASS_NAME_NINJA, TEXT_ITEM_NAME

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $42, $52, $58, $7f, $4b, $44, $59, $48, $7f, $51, $52, $57, $4b, $4c, $51, $4a, $7f, $57, $52, $61, $56, $48, $4f, $4f, $7f, $7f, $2a, $51, $5c, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $31, $52, $4f, $47, $7f, $3b, $2e, $3c, $2e, $3d, $7f, $5a, $4b, $4c, $4f, $48, $7f, $5c, $52, $58, $7f, $57, $58, $55, $51, $7f, $39, $38, $40, $2e, $3b, $7f, $52, $49, $49, $64, $64, $00

; address 81 - 108 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $3d, $52, $52, $61, $45, $44, $47, $7f, $7f, $3c, $52, $50, $48, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 108 - 130 (bytes 0 - 22)
TEXT_SHOP_THANKYOUWHATELSE:
.byte $3d, $4b, $44, $51, $4e, $7f, $5c, $52, $58, $64, $7f, $40, $4b, $44, $57, $7f, $48, $4f, $56, $48, $65, $00

; address 130 - 144 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $30, $52, $4f, $47, $7f, $38, $34, $65, $00

; address 144 - 152 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $2b, $4f, $60, $2b, $2e, $35, $3d, $00

; address 152 - 159 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $36, $2a, $3c, $3d, $2e, $3b, $00

; address 159 - 165 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $37, $32, $37, $33, $2a, $00

; address 165 - 170 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 170 - 8192
.res 8022

