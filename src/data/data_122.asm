.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_TOOBAD, TEXT_SHOP_YOUHAVETOOMANY, TEXT_INTRO_STORY_11, TEXT_SHOP_ITEMCOSTOK, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_HERO_0_NAME, TEXT_HERO_2_NAME, TEXT_SHOP_TITLEINN

; address 0 - 55 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $35, $5e, $82, $86, $8f, $80, $01, $7f, $7f, $31, $39, $7f, $5e, $84, $90, $1a, $84, $91, $7f, $7f, $7f, $36, $2a, $30, $32, $2c, $7f, $81, $92, $1a, $81, $93, $1a, $81, $94, $1a, $81, $95, $1a, $7f, $81, $96, $1a, $81, $97, $1a, $81, $98, $1a, $81, $99, $00

; address 55 - 89 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $40, $48, $4f, $46, $52, $50, $48, $7f, $7f, $3c, $57, $44, $5c, $5f, $7f, $57, $52, $5e, $56, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $47, $44, $57, $44, $60, $00

; address 89 - 116 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $3d, $52, $52, $5e, $45, $44, $47, $7f, $7f, $3c, $52, $50, $48, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 116 - 140 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 140 - 160 (bytes 0 - 20)
TEXT_INTRO_STORY_11:
.byte $48, $44, $46, $4b, $5e, $4b, $52, $4f, $47, $4c, $51, $4a, $5e, $44, $51, $5e, $38, $3b, $2b, $00

; address 160 - 174 (bytes 0 - 14)
TEXT_SHOP_ITEMCOSTOK:
.byte $88, $84, $5c, $da, $7f, $30, $52, $4f, $47, $7f, $38, $34, $65, $00

; address 174 - 182 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $40, $4b, $60, $36, $2a, $30, $2e, $00

; address 182 - 189 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $40, $2e, $2a, $39, $38, $37, $00

; address 189 - 194 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 194 - 199 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 199 - 203 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $32, $37, $37, $00

; 203 - 8192
.res 7989

