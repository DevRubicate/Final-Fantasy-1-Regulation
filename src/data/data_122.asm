.segment "DATA_122"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_SHOP_WHATDOYOUWANT, TEXT_TITLE_SELECT_NAME, TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_KNIGHT, TEXT_CLASS_NAME_THIEF, TEXT_HERO_3_NAME, SHOP_ARMOR_CONERIA, SHOP_ARMOR_CONERIA_SIBLING2

; address 0 - 55 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $35, $61, $82, $86, $8f, $80, $01, $7f, $7f, $31, $39, $7f, $61, $84, $90, $1a, $84, $91, $7f, $7f, $7f, $36, $2a, $30, $32, $2c, $7f, $81, $92, $1a, $81, $93, $1a, $81, $94, $1a, $81, $95, $1a, $7f, $81, $96, $1a, $81, $97, $1a, $81, $98, $1a, $81, $99, $00

; address 55 - 89 (bytes 0 - 34)
TEXT_SHOP_WELCOMEWOULDYOUSTAY:
.byte $40, $48, $4f, $46, $52, $50, $48, $7f, $7f, $3c, $57, $44, $5c, $5f, $7f, $57, $52, $61, $56, $44, $59, $48, $7f, $5c, $52, $58, $55, $7f, $47, $44, $57, $44, $60, $00

; address 89 - 113 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 113 - 131 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $40, $4b, $44, $57, $61, $47, $52, $7f, $5c, $52, $58, $7f, $5a, $44, $51, $57, $65, $00

; address 131 - 144 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $3c, $2e, $35, $2e, $2c, $3d, $61, $61, $37, $2a, $36, $2e, $00

; address 144 - 152 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $2f, $32, $30, $31, $3d, $2e, $3b, $00

; address 152 - 159 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $34, $37, $32, $30, $31, $3d, $00

; address 159 - 165 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $3d, $31, $32, $2e, $2f, $00

; address 165 - 170 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; address 170 - 174 (bytes 0 - 4)
SHOP_ARMOR_CONERIA:
.byte $01, $02, $03, $00

; address 174 - 178 (bytes 0 - 4)
SHOP_ARMOR_CONERIA_SIBLING2:
.byte $00, $00, $00, $00

; 178 - 8192
.res 8014

