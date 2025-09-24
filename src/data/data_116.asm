.segment "DATA_116"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2, LUT_METATILE_TOP_RIGHT, LUT_METATILE_TOP_RIGHT_SIBLING2

; address 0 - 256 (bytes 512 - 768)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $18, $0b, $c3, $05, $e1, $70, $e9, $b8, $3b, $5c, $42, $ef, $04, $77, $81, $8b, $a4, $49, $e8, $63, $76, $3c, $5a, $6e, $9f, $00, $18, $b0, $84, $4c, $82, $24, $21, $88, $13, $e1, $86, $12, $c5, $e1, $86, $38, $70, $00, $73, $9c, $e7, $3c, $80, $0b, $80, $08, $40, $17, $80, $07, $39, $c7, $a0, $0c, $c0, $49, $d8, $9b, $68, $93, $b6, $22, $ed, $5d, $1e, $0c, $b0, $4d, $76, $84, $fb, $62, $ef, $54, $67, $7b, $4f, $76, $5d, $33, $5a, $af, $68, $07, $39, $ce, $73, $9c, $e7, $3f, $80, $07, $c0, $03, $c2, $60, $9e, $b0, $c1, $34, $96, $a2, $3f, $58, $3e, $ed, $4d, $56, $c6, $f5, $a6, $ab, $56, $ee, $a1, $2d, $a0, $dc, $91, $5a, $a2, $44, $46, $c4, $04, $20, $0f, $28, $ce, $82, $dd, $16, $a9, $95, $5a, $ea, $dd, $eb, $35, $99, $53, $be, $2e, $6c, $80, $b9, $00, $85, $41, $b1, $01, $81, $61, $e5, $b2, $11, $7b, $19, $d6, $8e, $2c, $6e, $29, $17, $08, $4b, $c4, $46, $51, $10, $e8, $c0, $9d, $65, $29, $b1, $81, $5e, $2d, $c4, $4f, $60, $33, $ac, $89, $f6, $c4, $97, $58, $9e, $ea, $65, $fe, $94, $fd, $6e, $1f, $93, $2b, $49, $c1, $a8, $a2, $70, $0a, $90, $94, $51, $a0, $94, $4c, $47, $a9, $61, $e5, $6c, $7a, $96, $85, $4f, $62, $ab, $b1, $29, $db, $12, $fd, $8a, $fa, $d2, $60, $c8, $44, $70, $21, $61, $a2, $59, $01, $78, $93, $3a, $14, $b7, $c5, $4f, $60, $37, $1d, $2b

; address 256 - 380 (bytes 0 - 124)
TEXT_TEMPLATE_HERO_EQUIP_STATUS:
.byte $91, $02, $02, $92, $02, $02, $1a, $82, $86, $8f, $80, $02, $02, $02, $16, $1e, $02, $84, $90, $4c, $84, $91, $7f, $7f, $21, $3c, $3a, $02, $02, $02, $0a, $05, $02, $02, $02, $1a, $3d, $2b, $33, $02, $02, $09, $05, $7f, $0f, $2f, $31, $02, $02, $02, $0a, $05, $02, $02, $02, $16, $31, $3c, $02, $02, $02, $06, $05, $7f, $24, $31, $3c, $02, $02, $02, $0c, $05, $02, $02, $02, $12, $2d, $2e, $02, $02, $02, $06, $0a, $7f, $17, $36, $3c, $02, $02, $02, $08, $05, $02, $02, $02, $1b, $12, $2d, $2e, $02, $02, $08, $05, $7f, $25, $31, $3b, $02, $02, $02, $07, $05, $02, $02, $02, $13, $3e, $29, $2c, $2d, $02, $09, $05, $00

; address 380 - 405 (bytes 0 - 25)
TEXT_SHOP_RETURNLIFE:
.byte $25, $0f, $20, $20, $17, $1d, $20, $7f, $7f, $20, $2d, $3c, $3d, $3a, $36, $7f, $3c, $37, $7f, $34, $31, $2e, $2d, $47, $00

; address 405 - 427 (bytes 0 - 22)
TEXT_SHOP_WHOREVIVE:
.byte $25, $30, $37, $7f, $3b, $30, $29, $34, $34, $7f, $2a, $2d, $7f, $3a, $2d, $3e, $31, $3e, $2d, $2c, $7f, $00

; address 427 - 443 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_NINTENDO:
.byte $11, $02, $06, $0e, $0e, $05, $02, $1c, $17, $1c, $22, $13, $1c, $12, $1d, $00

; address 443 - 452 (bytes 0 - 9)
TEXT_CLASS_NAME_BLACK_WIZARD:
.byte $10, $1a, $0f, $11, $19, $25, $17, $28, $00

; address 452 - 459 (bytes 0 - 7)
TEXT_CLASS_NAME_KNIGHT:
.byte $19, $1c, $17, $15, $16, $22, $00

; address 459 - 466 (bytes 0 - 7)
TEXT_SHOP_TITLECLINIC:
.byte $11, $1a, $17, $1c, $17, $11, $00

; address 466 - 472 (bytes 0 - 6)
SHOP_WEAPON_CONERIA:
.byte $82, $81, $80, $83, $84, $00

; address 472 - 478 (bytes 0 - 6)
SHOP_WEAPON_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00, $00

; address 478 - 483 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA:
.byte $41, $43, $42, $40, $00

; address 483 - 488 (bytes 0 - 5)
SHOP_BLACKMAGIC_CONERIA_SIBLING2:
.byte $00, $00, $00, $00, $00

; address 488 - 490 (bytes 0 - 2)
LUT_METATILE_TOP_RIGHT:
.byte <TILE_ANIMATION_1, <TILE_ANIMATION_4

; address 490 - 492 (bytes 0 - 2)
LUT_METATILE_TOP_RIGHT_SIBLING2:
.byte >TILE_ANIMATION_1, >TILE_ANIMATION_4

; 492 - 8192
.res 7700

