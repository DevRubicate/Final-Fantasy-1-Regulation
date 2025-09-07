.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_ITEM_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, LUT_METASPRITE_PALETTE_LO, LUT_METASPRITE_PALETTE_HI, METASPRITE_CURSOR_PALETTE, METASPRITE_BLACK_BELT_PALETTE, METASPRITE_BLACK_MAGE_PALETTE, METASPRITE_FIGHTER_PALETTE, METASPRITE_RED_MAGE_PALETTE, METASPRITE_THIEF_PALETTE, METASPRITE_WHITE_MAGE_PALETTE

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_ITEM_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 100 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $17, $22, $13, $1b, $21, $7f, $7f, $1b, $0f, $15, $17, $11, $7f, $7f, $25, $13, $0f, $1e, $1d, $1c, $7f, $7f, $0f, $20, $1b, $1d, $20, $7f, $7f, $21, $22, $0f, $22, $23, $21, $00

; address 100 - 127 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $3c, $30, $2d, $31, $3a, $02, $37, $36, $34, $41, $02, $30, $37, $38, $2d, $02, $29, $02, $38, $3a, $37, $38, $30, $2d, $2b, $41, $00

; address 127 - 151 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $27, $37, $3d, $7f, $2b, $29, $36, $4a, $3c, $7f, $2b, $29, $3a, $3a, $41, $7f, $29, $36, $41, $35, $37, $3a, $2d, $00

; address 151 - 171 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $2d, $29, $2b, $30, $02, $30, $37, $34, $2c, $31, $36, $2f, $02, $29, $36, $02, $1d, $20, $10, $00

; address 171 - 187 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $10, $3d, $41, $7f, $7f, $21, $2d, $34, $34, $7f, $7f, $13, $40, $31, $3c, $00

; address 187 - 195 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $14, $17, $15, $16, $22, $13, $20, $00

; address 195 - 203 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $27, $2d, $3b, $7f, $7f, $1c, $37, $00

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

