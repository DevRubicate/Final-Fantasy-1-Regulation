.segment "DATA_120"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_TOOBAD, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_WHATDOYOUWANT, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_ITEM_NAME, LUT_METASPRITE_PALETTE, METASPRITE_CURSOR_PALETTE, LUT_METASPRITE_PALETTE_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 98 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $21, $29, $30, $27, $33, $31, $29, $7f, $7f, $1d, $38, $25, $3d, $3f, $7f, $38, $33, $7e, $37, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $28, $25, $38, $25, $40, $00

; address 98 - 125 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $1e, $33, $33, $7e, $26, $25, $28, $7f, $7f, $1d, $33, $31, $29, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 125 - 149 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 149 - 167 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $21, $2c, $25, $38, $7e, $28, $33, $7f, $3d, $33, $39, $7f, $3b, $25, $32, $38, $42, $00

; address 167 - 183 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $0d, $7e, $02, $0a, $0a, $01, $7e, $18, $13, $18, $1e, $0f, $18, $0e, $19, $00

; address 183 - 191 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $10, $13, $11, $12, $1e, $0f, $1c, $00

; address 191 - 198 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $15, $18, $13, $11, $12, $1e, $00

; address 198 - 205 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $0c, $17, $0b, $11, $13, $0d, $00

; address 205 - 210 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 210 - 211 (bytes 0 - 1)
LUT_METASPRITE_PALETTE:
.byte <METASPRITE_CURSOR_PALETTE

; address 211 - 215 (bytes 0 - 4)
METASPRITE_CURSOR_PALETTE:
.byte $1d, $10, $1e, $ff

; address 215 - 216 (bytes 0 - 1)
LUT_METASPRITE_PALETTE_SIBLING2:
.byte >METASPRITE_CURSOR_PALETTE

; 216 - 8192
.res 7976

