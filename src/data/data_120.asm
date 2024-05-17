.segment "DATA_120"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_RED_MAGE, TEXT_CLASS_NAME_RED_WIZARD, TEXT_SHOP_TITLEARMOR, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 96 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $40, $4b, $52, $56, $48, $7f, $4c, $57, $48, $50, $7f, $47, $52, $61, $5c, $52, $58, $7f, $5a, $44, $51, $57, $61, $57, $52, $7f, $56, $48, $4f, $4f, $65, $00

; address 96 - 119 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $44, $49, $49, $52, $55, $47, $7f, $57, $4b, $44, $57, $60, $00

; address 119 - 135 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $2c, $61, $21, $29, $28, $27, $61, $3c, $3a, $3e, $2a, $3b, $2e, $61, $61, $00

; address 135 - 145 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $2b, $58, $5c, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 145 - 153 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $3b, $48, $47, $36, $2a, $30, $2e, $00

; address 153 - 160 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $3b, $2e, $2d, $40, $32, $43, $00

; address 160 - 166 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $2a, $3b, $36, $38, $3b, $00

; address 166 - 171 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 171 - 176 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 176 - 8192
.res 8016

