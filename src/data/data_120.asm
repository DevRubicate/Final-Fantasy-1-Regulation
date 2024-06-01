.segment "DATA_120"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_SHOP_WHOWILLTAKEIT, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_ITEM_DESCRIPTION

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 96 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $40, $4b, $52, $56, $48, $7f, $4c, $57, $48, $50, $7f, $47, $52, $5e, $5c, $52, $58, $7f, $5a, $44, $51, $57, $5e, $57, $52, $7f, $56, $48, $4f, $4f, $65, $00

; address 96 - 122 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $48, $7f, $56, $53, $48, $4f, $4f, $65, $00

; address 122 - 145 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $44, $49, $49, $52, $55, $47, $7f, $57, $4b, $44, $57, $60, $00

; address 145 - 163 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $57, $44, $4e, $48, $7f, $4c, $57, $65, $00

; address 163 - 172 (bytes 0 - 9)
TEXT_TITLE_CONTINUE:
.byte $2c, $38, $37, $3d, $32, $37, $3e, $2e, $00

; address 172 - 181 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $2b, $35, $2a, $2c, $34, $40, $32, $43, $00

; address 181 - 188 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $34, $37, $32, $30, $31, $3d, $00

; address 188 - 195 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $2b, $36, $2a, $30, $32, $2c, $00

; address 195 - 200 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 200 - 8192
.res 7992

