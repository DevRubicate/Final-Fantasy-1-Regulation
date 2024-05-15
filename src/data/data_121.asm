.segment "DATA_121"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_THANKYOUWHATELSE, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_FIGHTER, TEXT_SHOP_YESNO, TEXT_HERO_0_NAME, TEXT_HERO_3_NAME

; address 0 - 55 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $35, $61, $82, $86, $8f, $80, $01, $7f, $7f, $31, $39, $7f, $61, $84, $90, $1a, $84, $91, $7f, $7f, $7f, $36, $2a, $30, $32, $2c, $7f, $81, $92, $1a, $81, $93, $1a, $81, $94, $1a, $81, $95, $1a, $7f, $81, $96, $1a, $81, $97, $1a, $81, $98, $1a, $81, $99, $00

; address 55 - 84 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $42, $52, $58, $61, $47, $52, $7f, $51, $52, $57, $7f, $51, $48, $48, $47, $61, $50, $5c, $7f, $4b, $48, $4f, $53, $7f, $51, $52, $5a, $60, $00

; address 84 - 106 (bytes 0 - 22)
TEXT_SHOP_THANKYOUWHATELSE:
.byte $3d, $4b, $44, $51, $4e, $7f, $5c, $52, $58, $64, $7f, $40, $4b, $44, $57, $7f, $48, $4f, $56, $48, $65, $00

; address 106 - 122 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $2b, $58, $5c, $7f, $7f, $3c, $48, $4f, $4f, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 122 - 130 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $2f, $32, $30, $31, $3d, $2e, $3b, $00

; address 130 - 138 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $42, $48, $56, $7f, $7f, $37, $52, $00

; address 138 - 143 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 143 - 148 (bytes 0 - 5)
TEXT_HERO_3_NAME:
.byte $90, $80, $03, $91, $00

; 148 - 8192
.res 8044

