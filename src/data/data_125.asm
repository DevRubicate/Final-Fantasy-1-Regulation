.segment "DATA_125"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_YOUHAVENOTHING, TEXT_INTRO_STORY_7, TEXT_INTRO_STORY_9, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_WHOWILLTAKEIT, TEXT_TITLE_NEW_GAME, TEXT_CLASS_NAME_RED_MAGE, TEXT_MENU_GOLD, TEXT_TITLE_START, TEXT_TITLE_EXIT, TEXT_HERO_3_NAME, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2, LUT_METATILE_BOTTOM_RIGHT, LUT_METATILE_BOTTOM_RIGHT_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $21, $37, $3a, $3a, $41, $43, $7f, $27, $37, $3d, $7f, $2b, $29, $36, $4a, $3c, $7f, $34, $2d, $29, $3a, $36, $7f, $3c, $30, $29, $3c, $44, $7f, $21, $37, $35, $2d, $37, $36, $2d, $7f, $2d, $34, $3b, $2d, $46, $00

; address 43 - 86 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $27, $37, $3d, $7f, $30, $29, $3e, $2d, $7f, $36, $37, $3c, $30, $31, $36, $2f, $7f, $3c, $37, $02, $3b, $2d, $34, $34, $7f, $7f, $0f, $36, $41, $45, $7f, $3c, $30, $31, $36, $2f, $7f, $2d, $34, $3b, $2d, $46, $00

; address 86 - 116 (bytes 0 - 30)
TEXT_INTRO_STORY_7:
.byte $25, $30, $2d, $36, $02, $3c, $30, $2d, $02, $3f, $37, $3a, $34, $2c, $02, $31, $3b, $02, $31, $36, $02, $2c, $29, $3a, $33, $36, $2d, $3b, $3b, $00

; address 116 - 142 (bytes 0 - 26)
TEXT_INTRO_STORY_9:
.byte $0f, $2e, $3c, $2d, $3a, $02, $29, $02, $34, $37, $36, $2f, $02, $32, $37, $3d, $3a, $36, $2d, $41, $02, $2e, $37, $3d, $3a, $00

; address 142 - 166 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $27, $37, $3d, $7f, $2b, $29, $36, $4a, $3c, $7f, $2b, $29, $3a, $3a, $41, $7f, $29, $36, $41, $35, $37, $3a, $2d, $00

; address 166 - 184 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $25, $30, $37, $7f, $3f, $31, $34, $34, $7f, $3c, $29, $33, $2d, $7f, $31, $3c, $46, $00

; address 184 - 193 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $1c, $13, $25, $02, $15, $0f, $1b, $13, $00

; address 193 - 201 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $20, $2d, $2c, $1b, $0f, $15, $13, $00

; address 201 - 208 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $02, $15, $00

; address 208 - 214 (bytes 0 - 6)
TEXT_TITLE_START:
.byte $21, $22, $0f, $20, $22, $00

; address 214 - 219 (bytes 0 - 5)
TEXT_TITLE_EXIT:
.byte $13, $26, $17, $22, $00

; address 219 - 224 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; address 224 - 229 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 229 - 234 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; address 234 - 236 (bytes 0 - 2)
LUT_METATILE_BOTTOM_RIGHT:
.byte <TILE_ANIMATION_3, <TILE_ANIMATION_4

; address 236 - 238 (bytes 0 - 2)
LUT_METATILE_BOTTOM_RIGHT_SIBLING2:
.byte >TILE_ANIMATION_3, >TILE_ANIMATION_4

; 238 - 8192
.res 7954

