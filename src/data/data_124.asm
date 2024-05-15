.segment "DATA_124"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_MENU_SELECTION, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_SHOP_WHATDOYOUWANT, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_CLASS_NAME_MASTER, TEXT_CLASS_NAME_THIEF, TEXT_SHOP_TITLEITEM

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $42, $52, $58, $7f, $44, $4f, $55, $48, $44, $47, $5c, $7f, $4e, $51, $52, $5a, $7f, $57, $4b, $44, $57, $7f, $56, $53, $48, $4f, $4f, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 79 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $32, $3d, $2e, $36, $3c, $7f, $7f, $36, $2a, $30, $32, $2c, $7f, $7f, $40, $2e, $2a, $39, $38, $37, $7f, $7f, $2a, $3b, $36, $38, $3b, $7f, $7f, $3c, $3d, $2a, $3d, $3e, $3c, $00

; address 79 - 103 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 103 - 121 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $40, $4b, $44, $57, $61, $47, $52, $7f, $5c, $52, $58, $7f, $5a, $44, $51, $57, $65, $00

; address 121 - 130 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $40, $31, $32, $3d, $2e, $40, $32, $43, $00

; address 130 - 137 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $36, $2a, $3c, $3d, $2e, $3b, $00

; address 137 - 143 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $3d, $31, $32, $2e, $2f, $00

; address 143 - 148 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $32, $3d, $2e, $36, $00

; 148 - 8192
.res 8044

