.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_SHOP_WHOSEITEMSELL, TEXT_INTRO_STORY_6, TEXT_INTRO_STORY_8, TEXT_TITLE_RESPOND_RATE, TEXT_TITLE_SELECT_NAME, TEXT_TITLE_NEW_GAME, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLECLINIC, TEXT_ITEM_DESCRIPTION, LUT_METASPRITE_FRAMES, LUT_METASPRITE_FRAMES_SIBLING2, METASPRITE_CURSOR_FRAMES, METASPRITE_CURSOR_FRAMES_SIBLING2, METASPRITE_CURSOR_FRAME_0, METASPRITE_CURSOR_FRAME_1

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 96 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $21, $2c, $33, $37, $29, $7f, $2d, $38, $29, $31, $7f, $28, $33, $7e, $3d, $33, $39, $7f, $3b, $25, $32, $38, $7e, $38, $33, $7f, $37, $29, $30, $30, $42, $00

; address 96 - 123 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $38, $2c, $29, $2d, $36, $7e, $33, $32, $30, $3d, $7e, $2c, $33, $34, $29, $7e, $25, $7e, $34, $36, $33, $34, $2c, $29, $27, $3d, $00

; address 123 - 147 (bytes 0 - 24)
TEXT_INTRO_STORY_8:
.byte $10, $33, $39, $36, $7e, $21, $25, $36, $36, $2d, $33, $36, $37, $7e, $3b, $2d, $30, $30, $7e, $27, $33, $31, $29, $00

; address 147 - 168 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $1c, $0f, $1d, $1a, $19, $18, $0e, $7e, $1c, $0b, $1e, $0f, $7e, $81, $86, $83, $5c, $10, $80, $01, $00

; address 168 - 181 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $1d, $0f, $16, $0f, $0d, $1e, $7e, $7e, $18, $0b, $17, $0f, $00

; address 181 - 190 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $18, $0f, $21, $7e, $11, $0b, $17, $0f, $00

; address 190 - 198 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $21, $29, $30, $27, $33, $31, $29, $00

; address 198 - 205 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $0d, $16, $13, $18, $13, $0d, $00

; address 205 - 210 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; address 210 - 211 (bytes 0 - 1)
LUT_METASPRITE_FRAMES:
.byte <METASPRITE_CURSOR_FRAMES

; address 211 - 212 (bytes 0 - 1)
LUT_METASPRITE_FRAMES_SIBLING2:
.byte >METASPRITE_CURSOR_FRAMES

; address 212 - 214 (bytes 0 - 2)
METASPRITE_CURSOR_FRAMES:
.byte <METASPRITE_CURSOR_FRAME_0, <METASPRITE_CURSOR_FRAME_1

; address 214 - 216 (bytes 0 - 2)
METASPRITE_CURSOR_FRAMES_SIBLING2:
.byte >METASPRITE_CURSOR_FRAME_0, >METASPRITE_CURSOR_FRAME_1

; address 216 - 220 (bytes 0 - 4)
METASPRITE_CURSOR_FRAME_0:
.byte $00, $00, $03, $01

; address 220 - 224 (bytes 0 - 4)
METASPRITE_CURSOR_FRAME_1:
.byte $00, $00, $03, $01

; 224 - 8192
.res 7968

