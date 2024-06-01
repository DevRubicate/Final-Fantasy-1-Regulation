.segment "DATA_124"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_THISSPELLFULL, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_INTRO_STORY_8, TEXT_SHOP_THANKYOUWHATELSE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_MASTER, TEXT_SHOP_TITLECLINIC, SHOP_WHITEMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA_SIBLING2

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUCANTLEARNTHAT:
.byte $3c, $52, $55, $55, $5c, $5f, $7f, $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $4f, $48, $44, $55, $51, $7f, $57, $4b, $44, $57, $60, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 43 - 83 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $3d, $4b, $4c, $56, $7f, $4f, $48, $59, $48, $4f, $7f, $56, $53, $48, $4f, $4f, $7f, $4c, $56, $5e, $49, $58, $4f, $4f, $7f, $7f, $3c, $52, $50, $48, $52, $51, $48, $7f, $48, $4f, $56, $48, $65, $00

; address 83 - 111 (bytes 0 - 28)
TEXT_EQUIP_OPTIMIZE_REMOVE:
.byte $5e, $5e, $2e, $3a, $3e, $32, $39, $5e, $5e, $5e, $38, $39, $3d, $32, $36, $32, $43, $2e, $5e, $5e, $5e, $3b, $2e, $36, $38, $3f, $2e, $00

; address 111 - 135 (bytes 0 - 24)
TEXT_INTRO_STORY_8:
.byte $2f, $52, $58, $55, $5e, $40, $44, $55, $55, $4c, $52, $55, $56, $5e, $5a, $4c, $4f, $4f, $5e, $46, $52, $50, $48, $00

; address 135 - 157 (bytes 0 - 22)
TEXT_SHOP_THANKYOUWHATELSE:
.byte $3d, $4b, $44, $51, $4e, $7f, $5c, $52, $58, $64, $7f, $40, $4b, $44, $57, $7f, $48, $4f, $56, $48, $65, $00

; address 157 - 173 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $2c, $5e, $21, $29, $28, $27, $5e, $3c, $3a, $3e, $2a, $3b, $2e, $5e, $5e, $00

; address 173 - 181 (bytes 0 - 8)
TEXT_CLASS_NAME_FIGHTER:
.byte $2f, $32, $30, $31, $3d, $2e, $3b, $00

; address 181 - 188 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $36, $2a, $3c, $3d, $2e, $3b, $00

; address 188 - 195 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $2c, $35, $32, $37, $32, $2c, $00

; address 195 - 200 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA:
.byte $60, $62, $61, $63, $00

; address 200 - 205 (bytes 0 - 5)
SHOP_WHITEMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 205 - 8192
.res 7987

