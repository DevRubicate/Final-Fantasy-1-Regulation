.segment "DATA_120"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_SHOP_TOOBAD, TEXT_SHOP_WHOREVIVE, TEXT_INVENTORY, TEXT_CLASS_NAME_BLACK_BELT, TEXT_MENU_GOLD, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 91 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $3d, $52, $52, $61, $45, $44, $47, $7f, $7f, $3c, $52, $50, $48, $62, $7f, $57, $4b, $4c, $51, $4a, $7f, $48, $4f, $56, $48, $65, $00

; address 91 - 113 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $40, $4b, $52, $7f, $56, $4b, $44, $4f, $4f, $7f, $45, $48, $7f, $55, $48, $59, $4c, $59, $48, $47, $7f, $00

; address 113 - 123 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $32, $37, $3f, $2e, $37, $3d, $38, $3b, $42, $00

; address 123 - 131 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $2b, $4f, $60, $2b, $2e, $35, $3d, $00

; address 131 - 138 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $61, $30, $00

; address 138 - 144 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 144 - 150 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; 150 - 8192
.res 8042

