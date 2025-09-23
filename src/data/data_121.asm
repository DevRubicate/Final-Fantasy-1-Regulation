.segment "DATA_121"

.include "src/global-import.inc"

.export TEXT_TEMPLATE_HERO_MENU, TEXT_SHOP_HOLDRESET, TEXT_INTRO_STORY_4, TEXT_INTRO_STORY_2, TEXT_SHOP_THANKYOUWHATELSE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_CONTINUE, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_WIZARD, LUT_METASPRITE_FRAMES_LO, LUT_METASPRITE_FRAMES_HI, METASPRITE_CURSOR_FRAMES_FRAMES, METASPRITE_CURSOR_FRAME_0, METASPRITE_BLACK_BELT_FRAMES_FRAMES, METASPRITE_BLACK_BELT_FRAME_0, METASPRITE_BLACK_BELT_FRAME_1, METASPRITE_BLACK_MAGE_FRAMES_FRAMES, METASPRITE_BLACK_MAGE_FRAME_0, METASPRITE_BLACK_MAGE_FRAME_1, METASPRITE_FIGHTER_FRAMES_FRAMES, METASPRITE_FIGHTER_FRAME_0, METASPRITE_FIGHTER_FRAME_1, METASPRITE_RED_MAGE_FRAMES_FRAMES, METASPRITE_RED_MAGE_FRAME_0, METASPRITE_RED_MAGE_FRAME_1, METASPRITE_THIEF_FRAMES_FRAMES, METASPRITE_THIEF_FRAME_0, METASPRITE_THIEF_FRAME_1, METASPRITE_WHITE_MAGE_FRAMES_FRAMES, METASPRITE_WHITE_MAGE_FRAME_0, METASPRITE_WHITE_MAGE_FRAME_1

; address 0 - 256 (bytes 1792 - 2048)
MASSIVE_CRAB_IMAGE_EXTENDED:
.byte $07, $e1, $d8, $7f, $1f, $fc, $0f, $c3, $b0, $ff, $ff, $ff, $21, $d2, $0f, $41, $dc, $75, $1d, $47, $c8, $3c, $43, $1c, $a0, $f3, $1d, $47, $98, $5c, $60, $f1, $1c, $60, $f1, $1c, $43, $0e, $0f, $30, $c7, $40, $c7, $48, $2c, $74, $86, $e3, $f3, $87, $d2, $0f, $41, $d2, $17, $38, $3c, $47, $18, $3c, $c3, $1f, $a1, $77, $82, $c7, $51, $de, $0f, $e1, $f2, $17, $48, $5d, $60, $f5, $84, $c7, $28, $2e, $17, $18, $2e, $17, $18, $9c, $67, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e7, $cf, $9f, $3e, $7c, $f9, $f3, $e4, $b8, $bc, $62, $72, $89, $ca, $1f, $38, $5d, $21, $74, $83, $ff, $ff, $ff, $ff, $07, $61, $d8, $76, $1d, $87, $61, $d8, $76, $8b, $ca, $2f, $18, $ce, $7c, $f8, $fd, $47, $61, $d8, $76, $0c, $73, $82, $e2, $f1, $8b, $c6, $3f, $61, $d8, $71, $1c, $c7, $11, $d8, $7d, $1f, $43, $1d, $47, $61, $c4, $74, $1d, $87, $11, $d0, $71, $1d, $03, $83, $ca, $0f, $11, $d0, $31, $d4, $73, $1c, $47, $51, $cc, $71, $1c, $87, $11, $ca, $0b, $1c, $c7, $18, $3c, $87, $61, $d8, $73, $1d, $87, $61, $fc, $79, $1d, $87, $61, $d8, $76, $83, $cc, $71

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

