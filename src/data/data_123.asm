.segment "DATA_123"

.include "src/global-import.inc"

.export TEXT_EXAMPLE_EQUIP_LIST, TEXT_MENU_SELECTION, TEXT_INTRO_STORY_6, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_TITLE_RESPOND_RATE, TEXT_SHOP_BUYSELLEXIT, TEXT_CLASS_NAME_BLACK_MAGE, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_HERO_1_NAME, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2

; address 0 - 51 (bytes 0 - 51)
TEXT_EXAMPLE_EQUIP_LIST:
.byte $2e, $5e, $32, $55, $52, $51, $5e, $3c, $5a, $52, $55, $47, $7f, $2e, $5e, $32, $55, $52, $51, $5e, $31, $48, $4f, $50, $48, $57, $7f, $2e, $5e, $2b, $55, $44, $46, $48, $4f, $48, $57, $7f, $5e, $5e, $40, $52, $52, $47, $48, $51, $5e, $2a, $5b, $48, $00

; address 51 - 87 (bytes 0 - 36)
TEXT_MENU_SELECTION:
.byte $32, $3d, $2e, $36, $3c, $7f, $7f, $36, $2a, $30, $32, $2c, $7f, $7f, $40, $2e, $2a, $39, $38, $37, $7f, $7f, $2a, $3b, $36, $38, $3b, $7f, $7f, $3c, $3d, $2a, $3d, $3e, $3c, $00

; address 87 - 114 (bytes 0 - 27)
TEXT_INTRO_STORY_6:
.byte $57, $4b, $48, $4c, $55, $5e, $52, $51, $4f, $5c, $5e, $4b, $52, $53, $48, $5e, $44, $5e, $53, $55, $52, $53, $4b, $48, $46, $5c, $00

; address 114 - 138 (bytes 0 - 24)
TEXT_SHOP_YOUCANTCARRYANYMORE:
.byte $42, $52, $58, $7f, $46, $44, $51, $5e, $57, $7f, $46, $44, $55, $55, $5c, $7f, $44, $51, $5c, $50, $52, $55, $48, $00

; address 138 - 159 (bytes 0 - 21)
TEXT_TITLE_RESPOND_RATE:
.byte $3b, $2e, $3c, $39, $38, $37, $2d, $5e, $3b, $2a, $3d, $2e, $5e, $81, $86, $83, $5c, $10, $80, $01, $00

; address 159 - 175 (bytes 0 - 16)
TEXT_SHOP_BUYSELLEXIT:
.byte $2b, $58, $5c, $7f, $7f, $3c, $48, $4f, $4f, $7f, $7f, $2e, $5b, $4c, $57, $00

; address 175 - 183 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_MAGE:
.byte $2b, $4f, $60, $36, $2a, $30, $2e, $00

; address 183 - 190 (bytes 0 - 7)
TEXT_SHOP_TITLEWHITEMAGIC:
.byte $40, $36, $2a, $30, $32, $2c, $00

; address 190 - 195 (bytes 0 - 5)
TEXT_HERO_1_NAME:
.byte $90, $80, $01, $91, $00

; address 195 - 200 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 200 - 205 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; 205 - 8192
.res 7987

