.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_TOOBAD, TEXT_INTRO_STORY_1, TEXT_SHOP_WHATDOYOUWANT, TEXT_INVENTORY, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_CLASS_NAME_THIEF, TEXT_HERO_0_NAME, TEXT_SHOP_TITLEITEM, TEXT_SHOP_TITLEINN

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $27, $37, $3d, $7f, $29, $34, $3a, $2d, $29, $2c, $41, $7f, $33, $36, $37, $3f, $7f, $3c, $30, $29, $3c, $7f, $3b, $38, $2d, $34, $34, $44, $7f, $21, $37, $35, $2d, $37, $36, $2d, $7f, $2d, $34, $3b, $2d, $46, $00

; address 43 - 83 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $22, $30, $31, $3b, $7f, $34, $2d, $3e, $2d, $34, $7f, $3b, $38, $2d, $34, $34, $7f, $31, $3b, $02, $2e, $3d, $34, $34, $7f, $7f, $21, $37, $35, $2d, $37, $36, $2d, $7f, $2d, $34, $3b, $2d, $46, $00

; address 83 - 115 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $25, $30, $37, $3b, $2d, $7f, $31, $3c, $2d, $35, $7f, $2c, $37, $02, $41, $37, $3d, $7f, $3f, $29, $36, $3c, $02, $3c, $37, $7f, $3b, $2d, $34, $34, $46, $00

; address 115 - 142 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $22, $37, $37, $02, $2a, $29, $2c, $7f, $7f, $21, $37, $35, $2d, $45, $7f, $3c, $30, $31, $36, $2f, $7f, $2d, $34, $3b, $2d, $46, $00

; address 142 - 165 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $22, $30, $2d, $02, $3f, $37, $3a, $34, $2c, $02, $31, $3b, $02, $3e, $2d, $31, $34, $2d, $2c, $02, $31, $36, $00

; address 165 - 183 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $25, $30, $29, $3c, $02, $2c, $37, $7f, $41, $37, $3d, $7f, $3f, $29, $36, $3c, $46, $00

; address 183 - 193 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $17, $1c, $24, $13, $1c, $22, $1d, $20, $27, $00

; address 193 - 201 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $25, $30, $44, $1b, $0f, $15, $13, $00

; address 201 - 208 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $25, $13, $0f, $1e, $1d, $1c, $00

; address 208 - 214 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $22, $16, $17, $13, $14, $00

; address 214 - 219 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 219 - 224 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $17, $22, $13, $1b, $00

; address 224 - 228 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $17, $1c, $1c, $00

; 228 - 8192
.res 7964

