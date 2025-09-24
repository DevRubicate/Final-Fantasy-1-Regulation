.segment "DATA_122"

.include "src/global-import.inc"

.export TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_TOOBAD, TEXT_INTRO_STORY_1, TEXT_SHOP_WHATDOYOUWANT, TEXT_INVENTORY, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_CLASS_NAME_THIEF, TEXT_HERO_0_NAME, TEXT_SHOP_TITLEITEM, LUT_TILE_ANIMATIONS_LO, LUT_TILE_ANIMATIONS_HI, TILE_ANIMATION_DATA_0, TILE_ANIMATION_DATA_1, TILE_ANIMATION_DATA_2, TILE_ANIMATION_DATA_3, TILE_ANIMATION_DATA_4

; address 0 - 256 (bytes 2048 - 2304)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $f2, $08, $84, $06, $00, $24, $00, $7a, $00, $0f, $00, $12, $00, $39, $cd, $c2, $d8, $41, $9b, $04, $07, $88, $01, $f0, $01, $20, $03, $9c, $f0, $94, $8a, $16, $41, $21, $21, $40, $48, $80, $50, $40, $78, $08, $90, $01, $ce, $4c, $10, $42, $00, $98, $00, $26, $00, $0e, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $c9, $82, $14, $c6, $ca, $04, $29, $0d, $94, $08, $52, $1b, $48, $10, $94, $36, $99, $6a, $cb, $55, $6c, $aa, $da, $66, $ad, $35, $56, $ca, $ad, $a5, $6a, $d3, $55, $57, $e8, $fd, $74, $7f, $ea, $3f, $dd, $3b, $fb, $4f, $7e, $a6, $dd, $53, $be, $a7, $df, $54, $2f, $b4, $04, $ba, $02, $fd, $02, $ae, $85, $d7, $01, $37, $01, $0a, $ad, $55, $da, $ab, $a5, $5a, $b3, $d5, $5c, $aa, $b6, $55, $ab, $2d, $59, $7a, $ab, $58, $04, $e8, $04, $24, $0d, $90, $0a, $48, $13, $08, $10, $84, $26, $04, $24, $00, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $73, $9c, $e7, $39, $ce, $72, $64, $02, $42, $04, $c2, $04, $21, $8d, $81, $08

; address 256 - 299 (bytes 0 - 43)
TEXT_SHOP_ALREADYKNOWSPELL:
.byte $27, $37, $3d, $7f, $29, $34, $3a, $2d, $29, $2c, $41, $7f, $33, $36, $37, $3f, $7f, $3c, $30, $29, $3c, $7f, $3b, $38, $2d, $34, $34, $44, $7f, $21, $37, $35, $2d, $37, $36, $2d, $7f, $2d, $34, $3b, $2d, $46, $00

; address 299 - 339 (bytes 0 - 40)
TEXT_SHOP_THISSPELLFULL:
.byte $22, $30, $31, $3b, $7f, $34, $2d, $3e, $2d, $34, $7f, $3b, $38, $2d, $34, $34, $7f, $31, $3b, $02, $2e, $3d, $34, $34, $7f, $7f, $21, $37, $35, $2d, $37, $36, $2d, $7f, $2d, $34, $3b, $2d, $46, $00

; address 339 - 371 (bytes 0 - 32)
TEXT_SHOP_WHOSEITEMSELL:
.byte $25, $30, $37, $3b, $2d, $7f, $31, $3c, $2d, $35, $7f, $2c, $37, $02, $41, $37, $3d, $7f, $3f, $29, $36, $3c, $02, $3c, $37, $7f, $3b, $2d, $34, $34, $46, $00

; address 371 - 398 (bytes 0 - 27)
TEXT_SHOP_TOOBAD:
.byte $22, $37, $37, $02, $2a, $29, $2c, $7f, $7f, $21, $37, $35, $2d, $45, $7f, $3c, $30, $31, $36, $2f, $7f, $2d, $34, $3b, $2d, $46, $00

; address 398 - 421 (bytes 0 - 23)
TEXT_INTRO_STORY_1:
.byte $22, $30, $2d, $02, $3f, $37, $3a, $34, $2c, $02, $31, $3b, $02, $3e, $2d, $31, $34, $2d, $2c, $02, $31, $36, $00

; address 421 - 439 (bytes 0 - 18)
TEXT_SHOP_WHATDOYOUWANT:
.byte $25, $30, $29, $3c, $02, $2c, $37, $7f, $41, $37, $3d, $7f, $3f, $29, $36, $3c, $46, $00

; address 439 - 449 (bytes 0 - 10)
TEXT_INVENTORY:
.byte $17, $1c, $24, $13, $1c, $22, $1d, $20, $27, $00

; address 449 - 457 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $25, $30, $44, $1b, $0f, $15, $13, $00

; address 457 - 464 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $25, $13, $0f, $1e, $1d, $1c, $00

; address 464 - 470 (bytes 0 - 6)
TEXT_CLASS_NAME_THIEF:
.byte $22, $16, $17, $13, $14, $00

; address 470 - 475 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 475 - 480 (bytes 0 - 5)
TEXT_SHOP_TITLEITEM:
.byte $17, $22, $13, $1b, $00

; address 480 - 485 (bytes 0 - 5)
LUT_TILE_ANIMATIONS_LO:
.byte <TILE_ANIMATION_DATA_0, <TILE_ANIMATION_DATA_1, <TILE_ANIMATION_DATA_2, <TILE_ANIMATION_DATA_3, <TILE_ANIMATION_DATA_4

; address 485 - 490 (bytes 0 - 5)
LUT_TILE_ANIMATIONS_HI:
.byte >TILE_ANIMATION_DATA_0, >TILE_ANIMATION_DATA_1, >TILE_ANIMATION_DATA_2, >TILE_ANIMATION_DATA_3, >TILE_ANIMATION_DATA_4

; address 490 - 493 (bytes 0 - 3)
TILE_ANIMATION_DATA_0:
.byte >MAP_TILE_GRASS_0, <MAP_TILE_GRASS_0, $ff

; address 493 - 496 (bytes 0 - 3)
TILE_ANIMATION_DATA_1:
.byte >MAP_TILE_GRASS_1, <MAP_TILE_GRASS_1, $ff

; address 496 - 499 (bytes 0 - 3)
TILE_ANIMATION_DATA_2:
.byte >MAP_TILE_GRASS_2, <MAP_TILE_GRASS_2, $ff

; address 499 - 502 (bytes 0 - 3)
TILE_ANIMATION_DATA_3:
.byte >MAP_TILE_GRASS_3, <MAP_TILE_GRASS_3, $ff

; address 502 - 505 (bytes 0 - 3)
TILE_ANIMATION_DATA_4:
.byte >TILE_CURSOR_1, <TILE_CURSOR_1, $ff

; 505 - 8192
.res 7687

