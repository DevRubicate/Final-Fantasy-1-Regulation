.segment "DATA_125"

.export TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_WHOWILLTAKEIT, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_RED_WIZARD, TEXT_CLASS_NAME_NINJA, TEXT_ITEM_NAME

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $42, $52, $58, $7f, $4b, $44, $59, $48, $7f, $51, $52, $57, $4b, $4c, $51, $4a, $7f, $57, $52, $61, $56, $48, $4f, $4f, $7f, $7f, $2a, $51, $5c, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 77 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $40, $48, $4f, $46, $52, $50, $48, $7f, $7f, $3c, $57, $44, $5c, $5f, $7f, $57, $52, $61, $56, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $47, $44, $57, $44, $60, $00

; address 77 - 103 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $48, $7f, $56, $53, $48, $4f, $4f, $65, $00

; address 103 - 121 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $57, $44, $4e, $48, $7f, $4c, $57, $65, $00

; address 121 - 130 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $2b, $35, $2a, $2c, $34, $40, $32, $43, $00

; address 130 - 137 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $3b, $2e, $2d, $40, $32, $43, $00

; address 137 - 143 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $37, $32, $37, $33, $2a, $00

; address 143 - 148 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, $5d, $02, $00

; 148 - 8192
.res 8044

