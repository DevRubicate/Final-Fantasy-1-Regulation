.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_INTRO_STORY_11, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_YESNO, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEITEM, TEXT_DASH, LUT_METASPRITE_FRAMES, LUT_METASPRITE_FRAMES_SIBLING2, METASPRITE_CURSOR_FRAMES, METASPRITE_CURSOR_FRAME_0, METASPRITE_CURSOR_FRAME_1, METASPRITE_FIGHTER_FRAMES, METASPRITE_FIGHTER_FRAME_0, METASPRITE_FIGHTER_FRAME_1

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $7e, $7e, $92, $7e, $7e, $16, $82, $86, $8f, $80, $02, $7e, $7e, $12, $1a, $7e, $84, $90, $48, $84, $91, $7f, $7f, $1d, $38, $36, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $16, $39, $27, $2f, $7e, $7e, $05, $01, $7f, $0b, $2b, $2d, $7e, $7e, $7e, $06, $01, $7e, $7e, $7e, $12, $2d, $38, $7e, $7e, $7e, $02, $01, $7f, $20, $2d, $38, $7e, $7e, $7e, $08, $01, $7e, $7e, $7e, $0e, $29, $2a, $7e, $7e, $7e, $02, $06, $7f, $13, $32, $38, $7e, $7e, $7e, $04, $01, $7e, $7e, $7e, $17, $0e, $29, $2a, $7e, $7e, $04, $01, $7f, $21, $2d, $37, $7e, $7e, $7e, $03, $01, $7e, $7e, $7e, $0f, $3a, $25, $28, $29, $7e, $05, $01, $00

; address 124 - 148 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $27, $25, $36, $36, $3d, $7f, $25, $32, $3d, $31, $33, $36, $29, $00

; address 148 - 168 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $29, $25, $27, $2c, $7e, $2c, $33, $30, $28, $2d, $32, $2b, $7e, $25, $32, $7e, $19, $1c, $0c, $00

; address 168 - 182 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $11, $33, $30, $28, $7f, $19, $15, $42, $00

; address 182 - 191 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $21, $12, $13, $1e, $0f, $21, $13, $24, $00

; address 191 - 199 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $23, $29, $37, $7f, $7f, $18, $33, $00

; address 199 - 205 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $0b, $1c, $17, $19, $1c, $00

; address 205 - 210 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $13, $1e, $0f, $17, $00

; address 210 - 212 (bytes 0 - 2)
TEXT_DASH:
.byte $41, $00

; address 212 - 214 (bytes 0 - 2)
LUT_METASPRITE_FRAMES:
.byte <METASPRITE_CURSOR_FRAMES, <METASPRITE_FIGHTER_FRAMES

; address 214 - 216 (bytes 0 - 2)
LUT_METASPRITE_FRAMES_SIBLING2:
.byte >METASPRITE_CURSOR_FRAMES, >METASPRITE_FIGHTER_FRAMES

; address 216 - 220 (bytes 0 - 4)
METASPRITE_CURSOR_FRAMES:
.byte <METASPRITE_CURSOR_FRAME_0, >METASPRITE_CURSOR_FRAME_0, <METASPRITE_CURSOR_FRAME_1, >METASPRITE_CURSOR_FRAME_1

; address 220 - 227 (bytes 0 - 7)
METASPRITE_CURSOR_FRAME_0:
.byte $00, $00, $00, $02, $00, $01, $02

; address 227 - 234 (bytes 0 - 7)
METASPRITE_CURSOR_FRAME_1:
.byte $00, $00, $00, $02, $04, $05, $06

; address 234 - 238 (bytes 0 - 4)
METASPRITE_FIGHTER_FRAMES:
.byte <METASPRITE_FIGHTER_FRAME_0, >METASPRITE_FIGHTER_FRAME_0, <METASPRITE_FIGHTER_FRAME_1, >METASPRITE_FIGHTER_FRAME_1

; address 238 - 246 (bytes 0 - 8)
METASPRITE_FIGHTER_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 246 - 254 (bytes 0 - 8)
METASPRITE_FIGHTER_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; 254 - 8192
.res 7938

