.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_INTRO_STORY_3, TEXT_INVENTORY, TEXT_TITLE_NEW_GAME, TEXT_SHOP_WELCOME, TEXT_CLASS_NAME_NINJA, TEXT_SHOP_TITLEITEM, TEXT_DASH

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $2a, $5e, $2b, $5e, $2c, $5e, $2d, $5e, $2e, $5e, $2f, $5e, $30, $5e, $31, $5e, $32, $5e, $33, $7f, $7f, $34, $5e, $35, $5e, $36, $5e, $37, $5e, $38, $5e, $39, $5e, $3a, $5e, $3b, $5e, $3c, $5e, $3d, $7f, $7f, $3e, $5e, $3f, $5e, $40, $5e, $41, $5e, $42, $5e, $43, $5e, $5e, $5e, $5f, $5e, $60, $5e, $5e, $7f, $7f, $20, $5e, $21, $5e, $22, $5e, $23, $5e, $24, $5e, $25, $5e, $26, $5e, $27, $5e, $28, $5e, $29, $7f, $7f, $44, $5e, $45, $5e, $46, $5e, $47, $5e, $48, $5e, $49, $5e, $4a, $5e, $4b, $5e, $4c, $5e, $4d, $7f, $7f, $4e, $5e, $4f, $5e, $50, $5e, $51, $5e, $52, $5e, $53, $5e, $54, $5e, $55, $5e, $56, $5e, $57, $7f, $7f, $58, $5e, $59, $5e, $5a, $5e, $5b, $5e, $5c, $5e, $5d, $5e, $62, $5e, $63, $5e, $64, $5e, $65, $00

; address 146 - 162 (bytes 0 - 16)
TEXT_INTRO_STORY_3:
.byte $57, $4b, $48, $5e, $56, $48, $44, $5e, $4c, $56, $5e, $5a, $4c, $4f, $47, $00

; address 162 - 172 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $32, $37, $3f, $2e, $37, $3d, $38, $3b, $42, $00

; address 172 - 181 (bytes 0 - 9)
TEXT_TITLE_NEW_GAME:
.byte $37, $2e, $40, $5e, $30, $2a, $36, $2e, $00

; address 181 - 189 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $40, $48, $4f, $46, $52, $50, $48, $00

; address 189 - 195 (bytes 0 - 6)
TEXT_CLASS_NAME_NINJA:
.byte $37, $32, $37, $33, $2a, $00

; address 195 - 200 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $32, $3d, $2e, $36, $00

; address 200 - 202 (bytes 0 - 2)
TEXT_DASH:
.byte $62, $00

; 202 - 8192
.res 7990

