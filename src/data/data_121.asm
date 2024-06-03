.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_INTRO_STORY_7, TEXT_SHOP_TOOBAD, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_TITLE_RESPOND_RATE, TEXT_INVENTORY, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_YESNO, TEXT_SHOP_TITLECLINIC, TEXT_ITEM_NAME

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 94 (bytes 0 - 30)
TEXT_INTRO_STORY_7:
.byte $21, $2c, $29, $32, $7e, $38, $2c, $29, $7e, $3b, $33, $36, $30, $28, $7e, $2d, $37, $7e, $2d, $32, $7e, $28, $25, $36, $2f, $32, $29, $37, $37, $00

; address 94 - 121 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $1e, $33, $33, $7e, $26, $25, $28, $7f, $7f, $1d, $33, $31, $29, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 121 - 145 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 145 - 166 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $1c, $0f, $1d, $1a, $19, $18, $0e, $7e, $1c, $0b, $1e, $0f, $7e, $81, $86, $83, $5c, $10, $80, $01, $00

; address 166 - 176 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $13, $18, $20, $0f, $18, $1e, $19, $1c, $23, $00

; address 176 - 185 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $21, $12, $13, $1e, $0f, $21, $13, $24, $00

; address 185 - 193 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $23, $29, $37, $7f, $7f, $18, $33, $00

; address 193 - 200 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $0d, $16, $13, $18, $13, $0d, $00

; address 200 - 205 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 205 - 8192
.res 7987

