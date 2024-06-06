.segment "DATA_124"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_INTRO_STORY_3, TEXT_INVENTORY, TEXT_CLASS_NAME_RED_MAGE, TEXT_MENU_GOLD, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $1d, $33, $36, $36, $3d, $3f, $7f, $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $30, $29, $25, $36, $32, $7f, $38, $2c, $25, $38, $40, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 83 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $1e, $2c, $2d, $37, $7f, $30, $29, $3a, $29, $30, $7f, $37, $34, $29, $30, $30, $7f, $2d, $37, $7e, $2a, $39, $30, $30, $7f, $7f, $1d, $33, $31, $29, $33, $32, $29, $7f, $29, $30, $37, $29, $42, $00

; address 83 - 112 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $23, $33, $39, $7e, $28, $33, $7f, $32, $33, $38, $7f, $32, $29, $29, $28, $7e, $31, $3d, $7f, $2c, $29, $30, $34, $7f, $32, $33, $3b, $40, $00

; address 112 - 138 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $30, $29, $25, $36, $32, $7f, $38, $2c, $29, $7f, $37, $34, $29, $30, $30, $42, $00

; address 138 - 161 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $25, $2a, $2a, $33, $36, $28, $7f, $38, $2c, $25, $38, $40, $00

; address 161 - 177 (bytes 0 - 16)
TEXT_INTRO_STORY_3:
.byte $38, $2c, $29, $7e, $37, $29, $25, $7e, $2d, $37, $7e, $3b, $2d, $30, $28, $00

; address 177 - 187 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $13, $18, $20, $0f, $18, $1e, $19, $1c, $23, $00

; address 187 - 195 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $1c, $29, $28, $17, $0b, $11, $0f, $00

; address 195 - 202 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $7e, $11, $00

; address 202 - 208 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 208 - 214 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; 214 - 8192
.res 7978

