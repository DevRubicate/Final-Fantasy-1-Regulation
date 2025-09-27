.segment "DATA_116"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_WHOREVIVE, TEXT_TITLE_COPYRIGHT_NINTENDO, TEXT_CLASS_NAME_BLACK_WIZARD, TEXT_CLASS_NAME_KNIGHT, TEXT_SHOP_TITLECLINIC, SHOP_WEAPON_CONERIA, SHOP_WEAPON_CONERIA_SIBLING2, SHOP_BLACKMAGIC_CONERIA, SHOP_BLACKMAGIC_CONERIA_SIBLING2, LUT_METATILE_TOP_RIGHT, LUT_METATILE_TOP_RIGHT_SIBLING2

; address 0 - 256 (bytes 512 - 768)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $4c, $08, $11, $20, $8a, $5f, $c7, $26, $52, $00, $17, $55, $42, $8a, $04, $1c, $2f, $a6, $06, $13, $25, $2f, $6a, $1d, $9a, $40, $78, $cc, $46, $84, $04, $15, $92, $62, $c1, $02, $8a, $12, $31, $90, $8c, $a0, $50, $b0, $be, $46, $c4, $08, $19, $10, $21, $71, $e6, $8c, $9d, $29, $39, $43, $2f, $ce, $18, $99, $53, $83, $22, $47, $9f, $9c, $3d, $71, $32, $e2, $f8, $a9, $09, $41, $23, $ea, $e6, $1d, $20, $32, $80, $c8, $90, $28, $21, $43, $b2, $a1, $4c, $c2, $02, $30, $31, $4a, $5a, $01, $e0, $9c, $87, $80, $01, $c1, $39, $e7, $03, $80, $47, $00, $ce, $13, $38, $3e, $38, $61, $e4, $00, $90, $43, $51, $c5, $4e, $6d, $fb, $1c, $c3, $1f, $3b, $0e, $e9, $7c, $b3, $42, $97, $c8, $d0, $6d, $4f, $6b, $35, $ab, $7f, $00, $ce, $39, $c7, $03, $82, $73, $ce, $39, $3d, $20, $bc, $20, $e1, $31, $fa, $f1, $e3, $e7, $07, $2c, $3c, $53, $39, $4c, $ae, $85, $2a, $f7, $50, $62, $70, $21, $e0, $9c, $8f, $ff, $c9, $59, $ea, $53, $61, $41, $08, $2b, $21, $a0, $e0, $b4, $f7, $c2, $53, $0b, $36, $9f, $ae, $e7, $3b, $b1, $d6, $9e, $80, $02, $c0, $c3, $c8, $d1, $ab, $a3, $03, $21, $0e, $16, $a1, $58, $50, $95, $0b, $44, $08, $19, $b0, $71, $61, $82, $16, $d4, $9b, $13, $57, $d9, $40, $6f, $0d, $3d, $23, $07, $1f, $be, $fc, $a8, $f3, $e3, $b7, $5a, $51, $a5, $69, $a6, $16, $b9, $36, $d2

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

