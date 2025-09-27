.segment "DATA_119"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_HOLDRESET, TEXT_INTRO_STORY_4, TEXT_INTRO_STORY_2, TEXT_SHOP_THANKYOUWHATELSE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_WIZARD, LUT_METASPRITE_FRAMES_LO, LUT_METASPRITE_FRAMES_HI, METASPRITE_CURSOR_FRAMES_FRAMES, METASPRITE_CURSOR_FRAME_0, METASPRITE_BLACK_BELT_FRAMES_FRAMES, METASPRITE_BLACK_BELT_FRAME_0, METASPRITE_BLACK_BELT_FRAME_1, METASPRITE_BLACK_MAGE_FRAMES_FRAMES, METASPRITE_BLACK_MAGE_FRAME_0, METASPRITE_BLACK_MAGE_FRAME_1, METASPRITE_FIGHTER_FRAMES_FRAMES, METASPRITE_FIGHTER_FRAME_0, METASPRITE_FIGHTER_FRAME_1, METASPRITE_RED_MAGE_FRAMES_FRAMES, METASPRITE_RED_MAGE_FRAME_0, METASPRITE_RED_MAGE_FRAME_1, METASPRITE_THIEF_FRAMES_FRAMES, METASPRITE_THIEF_FRAME_0, METASPRITE_THIEF_FRAME_1, METASPRITE_WHITE_MAGE_FRAMES_FRAMES, METASPRITE_WHITE_MAGE_FRAME_0, METASPRITE_WHITE_MAGE_FRAME_1

; address 0 - 256 (bytes 1280 - 1536)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $3d, $1b, $3b, $f1, $31, $e9, $66, $6f, $ad, $99, $bd, $d8, $09, $4c, $26, $c4, $09, $58, $18, $11, $60, $1a, $56, $c9, $8b, $f6, $85, $1b, $dd, $08, $e0, $9c, $f3, $02, $80, $5f, $74, $08, $38, $10, $21, $80, $0d, $a4, $cb, $df, $83, $ab, $4e, $4a, $1c, $00, $b5, $af, $c5, $d7, $f2, $ae, $d7, $dd, $cf, $00, $e7, $9c, $f3, $30, $30, $00, $38, $e7, $9c, $17, $c0, $c7, $97, $cf, $f1, $83, $c1, $03, $24, $64, $e4, $b4, $f0, $31, $21, $62, $c4, $71, $e8, $00, $9c, $0d, $b8, $dc, $7f, $67, $63, $54, $96, $8f, $de, $51, $84, $0c, $00, $de, $83, $07, $04, $27, $03, $80, $e8, $e4, $7b, $c7, $37, $fb, $ec, $21, $03, $66, $88, $36, $b9, $10, $38, $38, $fa, $66, $9a, $2b, $a8, $51, $6f, $0c, $0e, $bc, $f9, $31, $0f, $62, $5c, $c1, $1b, $7b, $d1, $aa, $5b, $6e, $92, $fa, $9d, $f7, $fb, $bf, $ff, $ee, $df, $3f, $67, $9f, $c4, $42, $14, $25, $06, $25, $1e, $89, $f5, $fd, $ed, $c6, $e7, $e5, $d7, $eb, $d7, $c5, $04, $ce, $17, $97, $63, $06, $27, $e4, $7d, $fb, $e8, $f3, $67, $cf, $bf, $be, $4d, $11, $ef, $c3, $01, $13, $ce, $0a, $59, $fe, $d7, $fd, $ff, $7e, $fb, $39, $7c, $61, $2a, $d2, $48, $2d, $01, $83, $a8, $a0, $a5, $d3, $d3, $fd, $40, $72, $4c, $8c, $be, $83, $a3, $b1, $e8, $a5, $c4, $f6, $fb, $02, $06, $c0, $54, $9c, $1c, $79, $e0, $c1, $0f, $d9, $59, $98, $55, $ae

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

