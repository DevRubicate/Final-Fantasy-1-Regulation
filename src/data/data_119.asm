.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_5, TEXT_SHOP_BUYEXIT, TEXT_CLASS_NAME_WHITE_WIZARD, TEXT_SHOP_YESNO, TEXT_SHOP_TITLEARMOR, TEXT_ITEM_NAME

; address 0 - 124 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $5e, $5e, $92, $5e, $5e, $35, $82, $86, $8f, $80, $02, $5e, $5e, $31, $39, $5e, $84, $90, $1a, $84, $91, $7f, $7f, $3c, $57, $55, $5e, $5e, $5e, $25, $20, $5e, $5e, $5e, $35, $58, $46, $4e, $5e, $5e, $24, $20, $7f, $2a, $4a, $4c, $5e, $5e, $5e, $25, $20, $5e, $5e, $5e, $31, $4c, $57, $5e, $5e, $5e, $21, $20, $7f, $3f, $4c, $57, $5e, $5e, $5e, $27, $20, $5e, $5e, $5e, $2d, $48, $49, $5e, $5e, $5e, $21, $25, $7f, $32, $51, $57, $5e, $5e, $5e, $23, $20, $5e, $5e, $5e, $36, $2d, $48, $49, $5e, $5e, $23, $20, $7f, $40, $4c, $56, $5e, $5e, $5e, $22, $20, $5e, $5e, $5e, $2e, $59, $44, $47, $48, $5e, $24, $20, $00

; address 124 - 146 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $5c, $52, $58, $51, $4a, $5e, $5a, $44, $55, $55, $4c, $52, $55, $56, $5e, $44, $55, $55, $4c, $59, $48, $00

; address 146 - 162 (bytes 0 - 16)
TEXT_INTRO_STORY_5:
.byte $3d, $4b, $48, $5e, $53, $48, $52, $53, $4f, $48, $5e, $5a, $44, $4c, $57, $00

; address 162 - 172 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $2b, $58, $5c, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 172 - 181 (bytes 0 - 9)
TEXT_CLASS_NAME_WHITE_WIZARD:
.byte $40, $31, $32, $3d, $2e, $40, $32, $43, $00

; address 181 - 189 (bytes 0 - 8)
TEXT_SHOP_YESNO:
.byte $42, $48, $56, $7f, $7f, $37, $52, $00

; address 189 - 195 (bytes 0 - 6)
TEXT_SHOP_TITLEARMOR:
.byte $2a, $3b, $36, $38, $3b, $00

; address 195 - 200 (bytes 0 - 5)
TEXT_ITEM_NAME:
.byte $93, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 200 - 8192
.res 7992

