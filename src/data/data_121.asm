.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, LUT_METASPRITE_PALETTE_LO, LUT_METASPRITE_PALETTE_HI, METASPRITE_CURSOR_PALETTE, METASPRITE_BLACK_BELT_PALETTE, METASPRITE_BLACK_MAGE_PALETTE, METASPRITE_FIGHTER_PALETTE, METASPRITE_RED_MAGE_PALETTE, METASPRITE_THIEF_PALETTE, METASPRITE_WHITE_MAGE_PALETTE

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 100 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $13, $1e, $0f, $17, $1d, $7f, $7f, $17, $0b, $11, $13, $0d, $7f, $7f, $21, $0f, $0b, $1a, $19, $18, $7f, $7f, $0b, $1c, $17, $19, $1c, $7f, $7f, $1d, $1e, $0b, $1e, $1f, $1d, $00

; address 100 - 127 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $38, $2c, $29, $2d, $36, $7e, $33, $32, $30, $3d, $7e, $2c, $33, $34, $29, $7e, $25, $7e, $34, $36, $33, $34, $2c, $29, $27, $3d, $00

; address 127 - 151 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 151 - 171 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $29, $25, $27, $2c, $7e, $2c, $33, $30, $28, $2d, $32, $2b, $7e, $25, $32, $7e, $19, $1c, $0c, $00

; address 171 - 187 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $0c, $39, $3d, $7f, $7f, $1d, $29, $30, $30, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 187 - 195 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $10, $13, $11, $12, $1e, $0f, $1c, $00

; address 195 - 203 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $23, $29, $37, $7f, $7f, $18, $33, $00

; address 203 - 210 (bytes 0 - 7)
LUT_METASPRITE_PALETTE_LO:
.byte <METASPRITE_CURSOR_PALETTE, <METASPRITE_BLACK_BELT_PALETTE, <METASPRITE_BLACK_MAGE_PALETTE, <METASPRITE_FIGHTER_PALETTE, <METASPRITE_RED_MAGE_PALETTE, <METASPRITE_THIEF_PALETTE, <METASPRITE_WHITE_MAGE_PALETTE

; address 210 - 217 (bytes 0 - 7)
LUT_METASPRITE_PALETTE_HI:
.byte >METASPRITE_CURSOR_PALETTE, >METASPRITE_BLACK_BELT_PALETTE, >METASPRITE_BLACK_MAGE_PALETTE, >METASPRITE_FIGHTER_PALETTE, >METASPRITE_RED_MAGE_PALETTE, >METASPRITE_THIEF_PALETTE, >METASPRITE_WHITE_MAGE_PALETTE

; address 217 - 221 (bytes 0 - 4)
METASPRITE_CURSOR_PALETTE:
.byte $1d, $10, $1e, $ff

; address 221 - 225 (bytes 0 - 4)
METASPRITE_BLACK_BELT_PALETTE:
.byte $1d, $10, $1e, $ff

; address 225 - 229 (bytes 0 - 4)
METASPRITE_BLACK_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; address 229 - 233 (bytes 0 - 4)
METASPRITE_FIGHTER_PALETTE:
.byte $1d, $10, $1e, $ff

; address 233 - 237 (bytes 0 - 4)
METASPRITE_RED_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; address 237 - 241 (bytes 0 - 4)
METASPRITE_THIEF_PALETTE:
.byte $1d, $10, $1e, $ff

; address 241 - 245 (bytes 0 - 4)
METASPRITE_WHITE_MAGE_PALETTE:
.byte $1d, $10, $1e, $ff

; 245 - 8192
.res 7947

