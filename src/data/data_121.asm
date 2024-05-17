.segment "DATA_121"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_WHOWILLTAKEIT, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_MENU_GOLD, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 93 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $42, $52, $58, $61, $47, $52, $7f, $51, $52, $57, $7f, $51, $48, $48, $47, $61, $50, $5c, $7f, $4b, $48, $4f, $53, $7f, $51, $52, $5a, $60, $00

; address 93 - 117 (bytes 0 - 24)
TEXT_SHOP_YOUHAVETOOMANY:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 117 - 135 (bytes 0 - 18)
TEXT_SHOP_WHOWILLTAKEIT:
.byte $40, $4b, $52, $7f, $5a, $4c, $4f, $4f, $7f, $57, $44, $4e, $48, $7f, $4c, $57, $65, $00

; address 135 - 144 (bytes 0 - 9)
TEXT_TITLE_CONTINUE:
.byte $2c, $38, $37, $3d, $32, $37, $3e, $2e, $00

; address 144 - 153 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $2b, $35, $2a, $2c, $34, $40, $32, $43, $00

; address 153 - 160 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $61, $30, $00

; address 160 - 166 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 166 - 172 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; 172 - 8192
.res 8020

