.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_HOLDRESET, TEXT_INTRO_STORY_4, TEXT_INTRO_STORY_2, TEXT_SHOP_THANKYOUWHATELSE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_WIZARD, LUT_METASPRITE_FRAMES_LO, LUT_METASPRITE_FRAMES_HI, METASPRITE_CURSOR_FRAMES_FRAMES, METASPRITE_CURSOR_FRAME_0, METASPRITE_BLACK_BELT_FRAMES_FRAMES, METASPRITE_BLACK_BELT_FRAME_0, METASPRITE_BLACK_BELT_FRAME_1, METASPRITE_BLACK_MAGE_FRAMES_FRAMES, METASPRITE_BLACK_MAGE_FRAME_0, METASPRITE_BLACK_MAGE_FRAME_1, METASPRITE_FIGHTER_FRAMES_FRAMES, METASPRITE_FIGHTER_FRAME_0, METASPRITE_FIGHTER_FRAME_1, METASPRITE_RED_MAGE_FRAMES_FRAMES, METASPRITE_RED_MAGE_FRAME_0, METASPRITE_RED_MAGE_FRAME_1, METASPRITE_THIEF_FRAMES_FRAMES, METASPRITE_THIEF_FRAME_0, METASPRITE_THIEF_FRAME_1, METASPRITE_WHITE_MAGE_FRAMES_FRAMES, METASPRITE_WHITE_MAGE_FRAME_0, METASPRITE_WHITE_MAGE_FRAME_1

; address 0 - 256 (bytes 1280 - 1536)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $00, $79, $9b, $b7, $5d, $7d, $aa, $f5, $89, $eb, $27, $77, $a3, $37, $54, $ad, $d4, $56, $a0, $b8, $00, $73, $9c, $e7, $39, $ce, $73, $9e, $58, $07, $92, $f9, $77, $f1, $4f, $ac, $1f, $d4, $0f, $48, $13, $80, $1e, $c0, $89, $b0, $3e, $94, $65, $68, $98, $80, $d1, $06, $a8, $24, $d5, $8a, $5b, $12, $d9, $56, $ab, $27, $39, $35, $51, $25, $fd, $45, $f6, $a2, $17, $52, $82, $c5, $54, $29, $b5, $01, $0a, $bc, $50, $65, $8f, $05, $d0, $c4, $ac, $66, $56, $31, $75, $20, $7c, $00, $ae, $2a, $9a, $b3, $a7, $76, $d4, $e9, $d7, $45, $0a, $58, $4e, $d7, $a8, $ba, $f7, $8b, $d7, $2b, $bd, $57, $ab, $ad, $77, $6c, $ae, $55, $7b, $2e, $d5, $26, $b0, $f1, $77, $0e, $ae, $5d, $68, $b7, $5b, $b4, $ea, $e9, $d5, $d2, $bd, $69, $aa, $79, $75, $4c, $bb, $67, $5b, $28, $dd, $ad, $ca, $ba, $55, $ab, $4c, $55, $d6, $bf, $59, $1b, $ad, $c5, $56, $fa, $bd, $d5, $cb, $bd, $5d, $7b, $3b, $d6, $5a, $ab, $d5, $4c, $ac, $29, $55, $76, $da, $45, $74, $8f, $69, $1e, $ca, $f6, $a9, $38, $87, $a1, $3e, $2a, $fc, $5e, $de, $b4, $03, $1e, $8a, $25, $93, $13, $0d, $b1, $c9, $7a, $44, $bd, $08, $d7, $a1, $30, $00, $4d, $50, $43, $d7, $04, $fe, $2a, $f0, $16, $a0, $b1, $41, $aa, $29, $54, $ea, $ab, $3e, $12, $95, $d4, $14, $aa, $b1, $55, $9a, $0c, $ad, $69, $66, $b0, $d5, $55, $fa, $c4, $3f, $68

; address 256 - 311 (bytes 0 - 55)
TEXT_TEMPLATE_HERO_MENU:
.byte $91, $7f, $7f, $1a, $02, $82, $86, $8f, $80, $01, $7f, $7f, $16, $1e, $7f, $02, $84, $90, $4c, $84, $91, $7f, $7f, $7f, $1b, $0f, $15, $17, $11, $7f, $81, $92, $4c, $81, $93, $4c, $81, $94, $4c, $81, $95, $4c, $7f, $81, $96, $4c, $81, $97, $4c, $81, $98, $4c, $81, $99, $00

; address 311 - 349 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $16, $37, $34, $2c, $7f, $20, $13, $21, $13, $22, $7f, $3f, $30, $31, $34, $2d, $7f, $41, $37, $3d, $7f, $3c, $3d, $3a, $36, $7f, $1e, $1d, $25, $13, $20, $7f, $37, $2e, $2e, $47, $47, $00

; address 349 - 377 (bytes 0 - 28)
TEXT_INTRO_STORY_4:
.byte $29, $36, $2c, $02, $3c, $30, $2d, $02, $2d, $29, $3a, $3c, $30, $02, $2a, $2d, $2f, $31, $36, $3b, $02, $3c, $37, $02, $3a, $37, $3c, $00

; address 377 - 402 (bytes 0 - 25)
TEXT_INTRO_STORY_2:
.byte $2c, $29, $3a, $33, $36, $2d, $3b, $3b, $02, $02, $22, $30, $2d, $02, $3f, $31, $36, $2c, $02, $3b, $3c, $37, $38, $3b, $00

; address 402 - 424 (bytes 0 - 22)
TEXT_SHOP_THANKYOUWHATELSE:
.byte $22, $30, $29, $36, $33, $7f, $41, $37, $3d, $47, $7f, $25, $30, $29, $3c, $7f, $2d, $34, $3b, $2d, $46, $00

; address 424 - 440 (bytes 0 - 16)
TEXT_TITLE_COPYRIGHT_SQUARE:
.byte $11, $02, $06, $0e, $0d, $0c, $02, $21, $1f, $23, $0f, $20, $13, $02, $02, $00

; address 440 - 449 (bytes 0 - 9)
TEXT_TITLE_CONTINUE:
.byte $11, $1d, $1c, $22, $17, $1c, $23, $13, $00

; address 449 - 457 (bytes 0 - 8)
TEXT_CLASS_NAME_BLACK_BELT:
.byte $10, $34, $44, $10, $13, $1a, $22, $00

; address 457 - 464 (bytes 0 - 7)
TEXT_CLASS_NAME_RED_WIZARD:
.byte $20, $13, $12, $25, $17, $28, $00

; address 464 - 471 (bytes 0 - 7)
LUT_METASPRITE_FRAMES_LO:
.byte <METASPRITE_CURSOR_FRAMES_FRAMES, <METASPRITE_BLACK_BELT_FRAMES_FRAMES, <METASPRITE_BLACK_MAGE_FRAMES_FRAMES, <METASPRITE_FIGHTER_FRAMES_FRAMES, <METASPRITE_RED_MAGE_FRAMES_FRAMES, <METASPRITE_THIEF_FRAMES_FRAMES, <METASPRITE_WHITE_MAGE_FRAMES_FRAMES

; address 471 - 478 (bytes 0 - 7)
LUT_METASPRITE_FRAMES_HI:
.byte >METASPRITE_CURSOR_FRAMES_FRAMES, >METASPRITE_BLACK_BELT_FRAMES_FRAMES, >METASPRITE_BLACK_MAGE_FRAMES_FRAMES, >METASPRITE_FIGHTER_FRAMES_FRAMES, >METASPRITE_RED_MAGE_FRAMES_FRAMES, >METASPRITE_THIEF_FRAMES_FRAMES, >METASPRITE_WHITE_MAGE_FRAMES_FRAMES

; address 478 - 480 (bytes 0 - 2)
METASPRITE_CURSOR_FRAMES_FRAMES:
.byte <METASPRITE_CURSOR_FRAME_0, >METASPRITE_CURSOR_FRAME_0

; address 480 - 487 (bytes 0 - 7)
METASPRITE_CURSOR_FRAME_0:
.byte $00, $00, $00, $02, $00, $01, $02

; address 487 - 491 (bytes 0 - 4)
METASPRITE_BLACK_BELT_FRAMES_FRAMES:
.byte <METASPRITE_BLACK_BELT_FRAME_0, >METASPRITE_BLACK_BELT_FRAME_0, <METASPRITE_BLACK_BELT_FRAME_1, >METASPRITE_BLACK_BELT_FRAME_1

; address 491 - 499 (bytes 0 - 8)
METASPRITE_BLACK_BELT_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $06, $07

; address 499 - 507 (bytes 0 - 8)
METASPRITE_BLACK_BELT_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; address 507 - 511 (bytes 0 - 4)
METASPRITE_BLACK_MAGE_FRAMES_FRAMES:
.byte <METASPRITE_BLACK_MAGE_FRAME_0, >METASPRITE_BLACK_MAGE_FRAME_0, <METASPRITE_BLACK_MAGE_FRAME_1, >METASPRITE_BLACK_MAGE_FRAME_1

; address 511 - 519 (bytes 0 - 8)
METASPRITE_BLACK_MAGE_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 519 - 527 (bytes 0 - 8)
METASPRITE_BLACK_MAGE_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; address 527 - 531 (bytes 0 - 4)
METASPRITE_FIGHTER_FRAMES_FRAMES:
.byte <METASPRITE_FIGHTER_FRAME_0, >METASPRITE_FIGHTER_FRAME_0, <METASPRITE_FIGHTER_FRAME_1, >METASPRITE_FIGHTER_FRAME_1

; address 531 - 539 (bytes 0 - 8)
METASPRITE_FIGHTER_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 539 - 547 (bytes 0 - 8)
METASPRITE_FIGHTER_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; address 547 - 551 (bytes 0 - 4)
METASPRITE_RED_MAGE_FRAMES_FRAMES:
.byte <METASPRITE_RED_MAGE_FRAME_0, >METASPRITE_RED_MAGE_FRAME_0, <METASPRITE_RED_MAGE_FRAME_1, >METASPRITE_RED_MAGE_FRAME_1

; address 551 - 559 (bytes 0 - 8)
METASPRITE_RED_MAGE_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 559 - 567 (bytes 0 - 8)
METASPRITE_RED_MAGE_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; address 567 - 571 (bytes 0 - 4)
METASPRITE_THIEF_FRAMES_FRAMES:
.byte <METASPRITE_THIEF_FRAME_0, >METASPRITE_THIEF_FRAME_0, <METASPRITE_THIEF_FRAME_1, >METASPRITE_THIEF_FRAME_1

; address 571 - 579 (bytes 0 - 8)
METASPRITE_THIEF_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 579 - 587 (bytes 0 - 8)
METASPRITE_THIEF_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; address 587 - 591 (bytes 0 - 4)
METASPRITE_WHITE_MAGE_FRAMES_FRAMES:
.byte <METASPRITE_WHITE_MAGE_FRAME_0, >METASPRITE_WHITE_MAGE_FRAME_0, <METASPRITE_WHITE_MAGE_FRAME_1, >METASPRITE_WHITE_MAGE_FRAME_1

; address 591 - 599 (bytes 0 - 8)
METASPRITE_WHITE_MAGE_FRAME_0:
.byte $00, $00, $01, $01, $00, $01, $02, $03

; address 599 - 607 (bytes 0 - 8)
METASPRITE_WHITE_MAGE_FRAME_1:
.byte $00, $00, $01, $01, $04, $05, $06, $07

; 607 - 8192
.res 7585

