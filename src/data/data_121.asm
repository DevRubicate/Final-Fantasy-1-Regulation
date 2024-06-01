.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_SPELL_LIST, TEXT_INTRO_STORY_7, TEXT_INTRO_STORY_9, TEXT_INTRO_STORY_1, TEXT_SHOP_WHATDOYOUWANT, TEXT_TITLE_SELECT_NAME, TEXT_CLASS_NAME_RED_MAGE, TEXT_MENU_GOLD, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2

; address 0 - 64 (bytes 0 - 64)
TEXT_TEMPLATE_SPELL_LIST:
.byte $93, $83, $03, $00, $7f, $7f, $8d, $a2, $83, $03, $00, $7f, $7f, $93, $83, $03, $01, $7f, $7f, $8d, $a2, $83, $03, $01, $7f, $7f, $93, $83, $03, $02, $7f, $7f, $8d, $a2, $83, $03, $02, $7f, $7f, $93, $83, $03, $03, $7f, $7f, $8d, $a2, $83, $03, $03, $7f, $7f, $93, $83, $03, $04, $7f, $7f, $8d, $a2, $83, $03, $04, $00

; address 64 - 94 (bytes 0 - 30)
TEXT_INTRO_STORY_7:
.byte $40, $4b, $48, $51, $5e, $57, $4b, $48, $5e, $5a, $52, $55, $4f, $47, $5e, $4c, $56, $5e, $4c, $51, $5e, $47, $44, $55, $4e, $51, $48, $56, $56, $00

; address 94 - 120 (bytes 0 - 26)
TEXT_INTRO_STORY_9:
.byte $2a, $49, $57, $48, $55, $5e, $44, $5e, $4f, $52, $51, $4a, $5e, $4d, $52, $58, $55, $51, $48, $5c, $5e, $49, $52, $58, $55, $00

; address 120 - 143 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $3d, $4b, $48, $5e, $5a, $52, $55, $4f, $47, $5e, $4c, $56, $5e, $59, $48, $4c, $4f, $48, $47, $5e, $4c, $51, $00

; address 143 - 161 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $40, $4b, $44, $57, $5e, $47, $52, $7f, $5c, $52, $58, $7f, $5a, $44, $51, $57, $65, $00

; address 161 - 174 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $3c, $2e, $35, $2e, $2c, $3d, $5e, $5e, $37, $2a, $36, $2e, $00

; address 174 - 182 (bytes 0 - 8)
TEXT_CLASS_NAME_RED_MAGE:
.byte $3b, $48, $47, $36, $2a, $30, $2e, $00

; address 182 - 189 (bytes 0 - 7)
TEXT_MENU_GOLD:
.byte $8b, $85, $60, $1c, $5e, $30, $00

; address 189 - 195 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 195 - 201 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; 201 - 8192
.res 7991

