.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2, LUT_METATILE_TOP_RIGHT, LUT_METATILE_TOP_RIGHT_SIBLING2

; address 0 - 256 (bytes 1024 - 1280)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e5, $72, $87, $ce, $0b, $83, $c8, $74, $0c, $75, $83, $d8, $76, $1f, $fa, $41, $eb, $07, $98, $63, $ac, $16, $18, $70, $d8, $71, $1c, $7e, $23, $a4, $1e, $83, $b0, $ff, $d8, $76, $1d, $a2, $f1, $8b, $ca, $23, $0e, $13, $83, $ca, $0b, $1c, $e0, $b1, $d0, $31, $d0, $31, $c8, $72, $1c, $60, $f2, $84, $c7, $20, $c3, $1c, $83, $85, $c8, $38, $5d, $07, $11, $cc, $38, $5c, $c7, $30, $c7, $48, $5d, $60, $f6, $1d, $c7, $61, $d8, $79, $83, $c4, $72, $1c, $87, $28, $3c, $60, $f1, $1c, $a1, $31, $c6, $0b, $0c, $71, $1c, $60, $f1, $83, $c8, $38, $3d, $60, $b1, $d2, $0f, $58, $3d, $87, $68, $3d, $87, $61, $d8, $72, $83, $c6, $0b, $83, $c6, $27, $18, $3c, $47, $20, $e1, $72, $1c, $47, $38, $2c, $74, $1d, $a1, $72, $1c, $47, $31, $c6, $0f, $21, $c6, $0f, $21, $c6, $0f, $28, $2e, $0f, $30, $c7, $40, $c7, $48, $5c, $62, $f1, $8c, $e2, $74, $85, $d4, $76, $1e, $c7, $81, $c4, $74, $83, $dc, $7f, $fc, $3b, $0f, $03, $ac, $1f, $03, $a4, $1e, $90, $d8, $71, $58, $71, $b9, $c4, $e7, $0f, $98, $70, $58, $e9, $07, $a8, $ec, $3b, $0e, $d3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e

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

