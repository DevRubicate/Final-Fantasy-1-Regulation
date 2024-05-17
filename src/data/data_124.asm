.segment "DATA_124"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_WHOREVIVE, TEXT_INVENTORY, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_YESNO, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEITEM, TEXT_DASH

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $3c, $52, $55, $55, $5c, $5f, $7f, $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $44, $57, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 83 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $3d, $4b, $4c, $56, $7f, $4f, $48, $59, $48, $4f, $7f, $56, $53, $48, $4f, $4f, $7f, $4c, $56, $61, $49, $58, $4f, $4f, $7f, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 83 - 109 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $48, $7f, $56, $53, $48, $4f, $4f, $65, $00

; address 109 - 131 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $40, $4b, $52, $7f, $56, $4b, $44, $4f, $4f, $7f, $45, $48, $7f, $55, $48, $59, $4c, $59, $48, $47, $7f, $00

; address 131 - 141 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $32, $37, $3f, $2e, $37, $3d, $38, $3b, $42, $00

; address 141 - 150 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $40, $31, $32, $3d, $2e, $40, $32, $43, $00

; address 150 - 158 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $42, $48, $56, $7f, $7f, $37, $52, $00

; address 158 - 165 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $2c, $35, $32, $37, $32, $2c, $00

; address 165 - 170 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $32, $3d, $2e, $36, $00

; address 170 - 172 (bytes 0 - 2)
TEXT_DASH:
.byte $62, $00

; 172 - 8192
.res 8020

