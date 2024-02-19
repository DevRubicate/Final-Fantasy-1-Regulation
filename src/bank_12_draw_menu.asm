.segment "BANK_12"

.include "src/global-import.inc"

.import CHRLoadToA, LoadBorderPalette_Blue

.export LoadMenuBGCHRAndPalettes, LoadMenuCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Menu BG CHR and Palettes  [$EA9F :: 0x3EAAF]
;;
;;   Loads CHR and Palettes for menus
;;
;;   Does not load palettes or CHR for sprites
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadMenuBGCHRAndPalettes:
    CALL LoadMenuCHR
    CALL LoadOrbCHR
    JUMP LoadBorderPalette_Blue       ; Load up the blue border palette for menus

LoadMenuCHR:
    LDA #<LUT_MenuCHR
    STA tmp
    LDA #>LUT_MenuCHR
    STA tmp+1        ; source address = $8800
    LDX #8           ; 8 rows to load
    LDA #8           ; dest address = $0800
    JUMP CHRLoadToA

LoadOrbCHR:
    LDA #<LUT_OrbCHR                 ; from source address LUT_OrbCHR
    STA tmp
    LDA #>LUT_OrbCHR
    STA tmp+1
    LDX #$02                         ; we want 2 rows of tiles
    LDA #$06                         ; dest ppu address $0600
    JUMP CHRLoadToA                   ; load up desired CHR (this is the ORB graphics that appear in the upper-left corner of main menu








LUT_OrbCHR:
    .byte $03, $0f, $1f, $1f, $3f, $3f, $3b, $1f, $ff
    .byte $fc, $f0, $f0, $e0, $e0, $e0, $f0, $c0, $80, $e0, $f0, $f0, $f0, $b0, $f0, $ff
    .byte $0f, $07, $07, $03, $03, $03, $07, $1e, $2e, $73, $60, $67, $27, $0f, $20, $f0
    .byte $e8, $c0, $c0, $c8, $e8, $f0, $c0, $e0, $e0, $80, $20, $e8, $e8, $c0, $00, $07
    .byte $03, $01, $01, $01, $03, $0f, $03, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fd, $ff, $f8, $f1, $e3, $e7, $40, $c0, $fa, $f8, $fc, $fc, $fe, $fe, $bf
    .byte $bf, $15, $bf, $bf, $bf, $bf, $ff, $7f, $7f, $3f, $3f, $5f, $af, $73, $0c, $ef
    .byte $ff, $ff, $ff, $bf, $5f, $8f, $f3, $fe, $fe, $fc, $fc, $fa, $f5, $ce, $30, $ff
    .byte $ff, $ff, $ff, $fd, $fa, $f1, $cf, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fe, $f8, $f0, $e1, $e3, $c7, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $ff, $7f, $1f, $7f, $ff, $ff, $ff, $7f, $7f, $3f, $3f, $5f, $af, $73, $0c, $c7
    .byte $ef, $fc, $f8, $b8, $5c, $8f, $f3, $fe, $fe, $fc, $fc, $fa, $f5, $ce, $30, $ff
    .byte $ff, $3f, $1f, $1d, $3a, $f1, $cf, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $fc, $f3, $ef, $df, $df, $bf, $ba, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $3f, $cf, $f7, $fb, $fb, $fd, $ad, $7f, $7f, $3f, $bf, $5f, $2f, $d3, $3c, $a8
    .byte $90, $c0, $40, $a0, $f0, $3c, $cf, $fe, $fe, $fc, $fd, $fa, $f4, $cb, $3c, $15
    .byte $09, $03, $02, $05, $0f, $3c, $f3, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fe, $f8, $f0, $e0, $e1, $c3, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $ff, $3f, $0f, $3f, $ff, $ff, $ff, $7f, $7f, $3f, $bf, $5f, $af, $73, $0c, $c7
    .byte $ef, $ff, $7f, $bf, $5f, $8f, $f3, $fe, $fe, $fc, $fd, $fa, $f5, $ce, $30, $ff
    .byte $ff, $ff, $fe, $fd, $fa, $f1, $cf, $7f, $55, $41, $55, $22, $36, $1c, $08, $80
    .byte $80, $80, $94, $c1, $c1, $e3, $f7, $00, $08, $1c, $7f, $3e, $1c, $36, $22, $ff
    .byte $f7, $e3, $80, $c1, $e3, $c9, $dd, $00, $03, $0f, $1f, $1f, $3f, $3f, $3f, $ff
    .byte $fc, $f1, $e0, $e0, $c0, $c0, $c0, $00, $e0, $f8, $fc, $fc, $fe, $fe, $fe, $ff
    .byte $1f, $e7, $33, $1b, $09, $0d, $0d, $3f, $3f, $1f, $1f, $0f, $03, $00, $00, $c0
    .byte $c0, $e0, $e0, $f0, $fc, $ff, $ff, $fe, $fe, $fc, $fc, $f8, $e0, $00, $00, $01
    .byte $0d, $1f, $03, $07, $1f, $ff, $ff, $00, $01, $02, $04, $08, $10, $20, $40, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $08, $7c, $10, $3a, $4c, $24, $20, $1e, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $3c, $02, $02, $04, $18, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $28, $3e, $62, $14, $10, $08, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $08, $5c, $6a, $4a, $1c, $08, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $08, $0e, $08, $18, $2c, $12, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff


LUT_MenuCHR:
    .byte $00, $3e, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $18, $38, $18, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $06, $18, $30, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $0e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0e, $1e, $36, $26, $66, $7f, $06, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $7e, $03, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $7e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $63, $63, $06, $0c, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $3e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $3f, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1c, $1c, $14, $36, $3e, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $7e, $63, $63, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $60, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7c, $66, $63, $63, $63, $66, $7c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $62, $7e, $62, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $62, $7e, $62, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $67, $61, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $63, $7f, $63, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1e, $0c, $0c, $0c, $0c, $0c, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $07, $03, $03, $03, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $66, $6c, $78, $6c, $66, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $60, $60, $60, $61, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $77, $7f, $6b, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $73, $7b, $6f, $67, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $63, $7e, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $63, $6d, $66, $3b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $7e, $6c, $66, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $3e, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $ff, $99, $18, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $22, $36, $36, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $6b, $6b, $7f, $77, $22, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $41, $63, $36, $1c, $1c, $36, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c3, $66, $3c, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $43, $06, $0c, $18, $31, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $06, $1e, $36, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $3c, $36, $36, $36, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $36, $30, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $06, $06, $1e, $36, $36, $36, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $32, $3e, $30, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0c, $1a, $18, $3c, $18, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $1e, $14, $1c, $36, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $30, $3c, $36, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $0c, $00, $0c, $0c, $0c, $0c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0c, $00, $0c, $0c, $0c, $2c, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $33, $36, $3c, $36, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $18, $18, $18, $18, $18, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $7e, $6d, $6d, $6d, $6d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $36, $36, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $36, $36, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $36, $3c, $30, $30, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $36, $1e, $06, $06, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $36, $19, $19, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $38, $1e, $07, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $18, $3e, $18, $18, $18, $0c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $33, $33, $33, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $62, $62, $34, $3c, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $6d, $6d, $6d, $6d, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $1e, $0c, $1e, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $1e, $0c, $18, $30, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $7e, $0c, $18, $30, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $20, $40, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $18, $18, $08, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $3e, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $66, $66, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $08, $08, $08, $08, $08, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1c, $22, $22, $04, $08, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $60, $60, $60, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $60, $7e, $60, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $63, $94, $f7, $84, $73, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $3e, $12, $9e, $90, $10, $90, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3c, $66, $60, $3c, $06, $66, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $fd, $31, $33, $33, $33, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $cf, $c3, $63, $63, $e3, $33, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $d9, $19, $19, $19, $19, $19, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $9e, $b3, $b0, $9e, $83, $b3, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c6, $c6, $c6, $d6, $fe, $ee, $44, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f9, $c1, $c3, $f3, $c3, $c6, $f6, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c7, $c6, $66, $67, $e6, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c7, $6d, $6d, $cd, $0d, $0d, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $33, $b3, $bb, $b7, $b3, $b3, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $c0, $e0, $70, $39, $1e, $0c, $0a, $11, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $08, $77, $7f, $7f, $00, $08, $08, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $02, $06, $0e, $5c, $38, $30, $48, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $44, $75, $75, $74, $44, $04, $04, $04, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $60, $90, $90, $48, $08, $04, $02, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $28, $02, $40, $42, $42, $42, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c3, $bd, $7e, $7e, $3c, $66, $5a, $ff, $ff, $db, $ff, $ff, $ff, $ff, $e7
    .byte $7f, $41, $49, $5d, $49, $49, $22, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $3e, $01, $3e, $7f, $0f, $0f, $3e, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $38, $3c, $3c, $1e, $05, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $1c, $22, $41, $41, $41, $63, $3e, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7
    .byte $00, $e7, $ff, $7e, $7e, $7e, $7e, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $62, $64, $08, $10, $26, $46, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $1c, $08, $08, $1c, $3e, $3e, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f0, $d8, $d9, $db, $f3, $c3, $c1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $0c, $c0, $2d, $2c, $2c, $cc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $f1, $83, $f3, $1b, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $ce, $2d, $2d, $2d, $cd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3c, $66, $60, $3c, $06, $66, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $f9, $63, $63, $63, $31, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $cf, $2c, $2c, $2c, $cc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $b2, $be, $b0, $9e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $02, $02, $3a, $42, $7a, $0a, $72, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $88, $d8, $f9, $f9, $d9, $db, $db, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e1, $e3, $b3, $b3, $f3, $1b, $19, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e7, $33, $03, $73, $13, $33, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $9e, $33, $33, $30, $33, $33, $9e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7d, $60, $60, $78, $60, $60, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e7, $cc, $cc, $cd, $cc, $cc, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $99, $d9, $19, $df, $59, $d9, $99, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $bf, $ad, $8c, $8c, $8c, $8c, $8c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f1, $d9, $cd, $cd, $cd, $d9, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f3, $99, $99, $f1, $e1, $b1, $9b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $d9, $99, $99, $9d, $9b, $99, $d9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $b3, $b6, $bc, $b8, $bc, $b6, $b3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $3f, $7f, $7f, $78, $00, $00, $00, $00, $0f, $18, $30, $27
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $00, $ff
    .byte $00, $00, $00, $f8, $fc, $fe, $fe, $1e, $00, $00, $00, $00, $f0, $18, $0c, $e4
    .byte $78, $78, $78, $78, $78, $78, $78, $78, $27, $27, $27, $27, $27, $27, $27, $27
    .byte $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $e4, $e4, $e4, $e4, $e4, $e4, $e4, $e4
    .byte $78, $78, $7c, $7f, $7f, $3f, $1f, $00, $27, $27, $33, $18, $0f, $00, $00, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $00, $00
    .byte $1e, $1e, $3e, $fe, $fe, $fc, $f8, $00, $e4, $e4, $cc, $18, $f0, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
