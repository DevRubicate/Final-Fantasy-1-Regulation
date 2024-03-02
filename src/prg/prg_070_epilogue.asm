.segment "PRG_070"

.include "src/global-import.inc"

.import LoadMenuCHR

.export LoadEpilogueSceneGFX

EpilogueCHR:
    .byte $ff, $ff, $ff, $e7, $ff, $ff, $ff, $ff, $00, $00, $00, $18, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $f3, $fb, $f5, $f5, $b0, $99, $31, $2d, $00, $08, $14, $34, $30, $39, $31, $2d
    .byte $f7, $f3, $c3, $e3, $e7, $0c, $ca, $ce, $21, $61, $63, $63, $67, $0c, $ca, $ce
    .byte $ff, $fe, $fe, $c8, $d4, $c0, $05, $08, $00, $00, $00, $40, $c6, $c4, $05, $08
    .byte $ff, $9f, $2b, $41, $51, $02, $20, $22, $00, $00, $20, $40, $70, $02, $21, $22
    .byte $00, $00, $00, $40, $84, $80, $05, $48, $01, $7f, $bf, $49, $96, $c4, $05, $48
    .byte $fc, $03, $20, $40, $50, $02, $20, $22, $fc, $9f, $2a, $41, $71, $02, $21, $22
    .byte $00, $00, $00, $40, $c4, $c0, $05, $08, $ff, $fe, $fe, $c8, $d6, $c4, $05, $08
    .byte $00, $00, $20, $40, $50, $02, $20, $22, $ff, $9f, $2b, $41, $71, $02, $21, $22
    .byte $80, $c0, $d0, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $01, $81, $c0
    .byte $00, $00, $e0, $ff, $ff, $ff, $ff, $ff, $7c, $13, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $11, $f3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ee
    .byte $30, $00, $00, $00, $00, $e0, $ff, $ff, $30, $00, $04, $7c, $13, $00, $00, $00
    .byte $3c, $06, $0a, $08, $04, $00, $00, $ff, $3c, $06, $0a, $08, $34, $dd, $00, $00
    .byte $72, $51, $01, $30, $00, $00, $00, $00, $72, $51, $01, $30, $00, $04, $7c, $13
    .byte $05, $3c, $06, $0a, $08, $04, $00, $00, $0d, $3c, $06, $0a, $08, $34, $dd, $00
    .byte $7f, $2f, $1f, $47, $07, $03, $07, $3f, $00, $00, $10, $40, $20, $00, $80, $00
    .byte $72, $51, $01, $30, $00, $00, $00, $00, $72, $51, $01, $30, $00, $04, $7c, $13
    .byte $05, $3c, $06, $0a, $08, $04, $00, $00, $0d, $3c, $06, $0a, $08, $34, $dd, $00
    .byte $14, $0a, $08, $04, $06, $00, $00, $00, $14, $0a, $08, $04, $06, $62, $5f, $e0
    .byte $08, $40, $18, $30, $10, $00, $00, $00, $48, $40, $18, $30, $10, $30, $3b, $60
    .byte $00, $00, $00, $00, $00, $00, $f0, $70, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $8f
    .byte $c3, $e3, $e7, $0c, $ca, $ce, $05, $3c, $63, $63, $67, $0c, $ca, $ce, $0d, $3c
    .byte $00, $02, $04, $05, $1f, $8f, $cf, $ff, $ff, $ff, $ff, $fe, $fe, $7b, $3c, $10
    .byte $ff, $eb, $41, $51, $02, $20, $22, $08, $00, $20, $40, $70, $02, $21, $22, $48
    .byte $17, $73, $20, $04, $00, $85, $08, $04, $00, $01, $00, $16, $84, $85, $0a, $04
    .byte $ff, $fc, $fe, $fb, $fc, $e8, $ee, $f4, $00, $01, $00, $00, $00, $0a, $0c, $04
    .byte $be, $d9, $00, $02, $20, $20, $80, $05, $01, $45, $01, $92, $24, $22, $84, $0d
    .byte $ff, $ff, $2d, $a0, $11, $20, $08, $32, $00, $24, $21, $a4, $53, $20, $0c, $32
    .byte $ff, $57, $26, $06, $63, $b3, $81, $80, $00, $00, $00, $22, $73, $b3, $89, $88
    .byte $20, $61, $43, $63, $67, $0c, $ca, $ce, $34, $61, $63, $63, $67, $0c, $ca, $ce
    .byte $38, $30, $00, $40, $c4, $c2, $05, $08, $38, $30, $24, $56, $d4, $c2, $07, $09
    .byte $0e, $4f, $7f, $ff, $2f, $ef, $ff, $ff, $f1, $ff, $f9, $b3, $d3, $39, $04, $43
    .byte $ff, $fc, $fe, $fb, $fc, $e8, $ee, $f4, $00, $01, $00, $00, $00, $0a, $0c, $04
    .byte $ff, $ff, $3f, $3f, $3f, $bf, $ef, $ae, $00, $00, $00, $80, $40, $00, $00, $00
    .byte $00, $00, $00, $70, $fb, $34, $00, $00, $ff, $ff, $ff, $ff, $84, $cf, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $07, $01, $00, $00, $80, $00, $10, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $71, $80, $99, $00, $1a, $ac, $08, $03
    .byte $06, $0a, $09, $04, $00, $00, $ff, $ff, $06, $0a, $09, $34, $dd, $00, $00, $00
    .byte $0a, $08, $00, $01, $00, $00, $00, $ff, $0a, $08, $14, $01, $62, $5f, $e0, $00
    .byte $40, $18, $30, $10, $00, $00, $00, $ff, $40, $18, $30, $10, $30, $3b, $60, $00
    .byte $db, $e7, $c7, $e7, $f1, $a2, $d0, $f3, $00, $00, $10, $00, $00, $00, $04, $00
    .byte $f0, $d4, $c0, $d4, $f2, $d0, $fa, $c6, $00, $15, $00, $0e, $02, $00, $00, $00
    .byte $f8, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $7f, $ef, $fb, $a2, $f2, $b4, $f9, $08
    .byte $0f, $1f, $1f, $3f, $7f, $7f, $7f, $3f, $f0, $e0, $e8, $c3, $9a, $81, $8d, $c0
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $2f, $4f, $07, $7f, $1f, $7f, $bf, $1a
    .byte $ff, $af, $af, $47, $57, $03, $21, $03, $00, $00, $20, $40, $70, $00, $20, $42
    .byte $ff, $ee, $f4, $f4, $b0, $99, $31, $ed, $00, $08, $10, $34, $32, $39, $33, $0d
    .byte $fa, $ff, $ff, $fe, $fe, $fe, $ff, $ff, $9f, $ff, $ff, $a3, $99, $01, $29, $e2
    .byte $f0, $d4, $c0, $d4, $72, $50, $3a, $46, $00, $15, $00, $0e, $02, $40, $00, $00
    .byte $1a, $b2, $dc, $e6, $d6, $02, $c2, $a0, $00, $02, $00, $80, $c0, $00, $16, $00
    .byte $ff, $1f, $4f, $7f, $9f, $4f, $ef, $bf, $00, $00, $40, $00, $10, $60, $00, $00
    .byte $3f, $1f, $1f, $df, $5f, $0f, $9f, $ff, $c5, $e1, $e0, $64, $a2, $f0, $e0, $f8
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9d, $44, $a0, $22, $04, $00, $00, $16
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $6d, $2c, $1c, $1b, $1f, $4b, $2e, $7f
    .byte $00, $00, $00, $00, $10, $19, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e9
    .byte $00, $00, $00, $00, $00, $00, $00, $80, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $85, $c0, $f7, $81, $54, $bc, $04, $17, $20, $00, $00, $00, $56, $3c, $00, $00
    .byte $c2, $a8, $ee, $4c, $81, $0b, $7e, $56, $00, $28, $ea, $4c, $4b, $03, $00, $04
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ef, $fb, $a3, $f2, $b4, $f9, $08
    .byte $f0, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c3, $b8, $ef, $b3, $c4, $01, $06
    .byte $3f, $7f, $fe, $3f, $00, $00, $1e, $07, $fc, $80, $01, $c0, $ff, $ff, $e1, $f8
    .byte $39, $10, $00, $40, $d4, $c2, $05, $08, $38, $10, $44, $56, $d4, $c2, $07, $09
    .byte $ff, $fe, $fe, $c8, $d4, $c0, $05, $08, $00, $00, $00, $40, $c6, $c4, $05, $08
    .byte $e0, $c0, $00, $73, $80, $00, $09, $00, $1f, $3f, $ff, $8c, $7f, $ff, $f6, $ff
    .byte $00, $00, $00, $80, $e0, $00, $80, $00, $ff, $ff, $ff, $7f, $1f, $ff, $7f, $ff
    .byte $00, $70, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $cf, $03, $f7, $7e, $74, $c7, $66
    .byte $00, $00, $01, $0b, $07, $07, $07, $07, $ff, $ff, $fe, $f4, $f9, $fa, $fd, $fc
    .byte $00, $00, $c0, $f8, $f8, $f8, $fe, $fe, $ff, $ff, $7f, $7f, $ff, $df, $ef, $4f
    .byte $0f, $3f, $3f, $1f, $9f, $ff, $ff, $ff, $fd, $cd, $ee, $f9, $f2, $d8, $f5, $d7
    .byte $ab, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $54, $03, $00, $00, $00, $00, $00, $00
    .byte $d4, $a1, $d2, $3f, $f2, $ff, $ff, $ff, $2b, $5e, $2d, $c0, $0d, $00, $00, $00
    .byte $e9, $23, $f4, $a1, $7d, $94, $ff, $ff, $16, $dc, $0b, $5e, $82, $6b, $00, $00
    .byte $57, $c5, $12, $7f, $ff, $bf, $ff, $ff, $a8, $3a, $ed, $80, $00, $40, $00, $00
    .byte $ab, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $54, $03, $00, $00, $00, $00, $00, $00
    .byte $d4, $a1, $d6, $ff, $fb, $ff, $ff, $ff, $2b, $5e, $29, $00, $04, $00, $00, $00
    .byte $e9, $23, $f5, $bf, $ff, $df, $ff, $ff, $16, $dc, $0a, $40, $00, $20, $00, $00
    .byte $57, $ed, $ba, $7f, $ff, $ff, $ff, $ff, $a8, $12, $45, $80, $00, $00, $00, $00
    .byte $fc, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $8f, $0f, $4f, $1b, $4f, $06, $04, $01
    .byte $06, $0f, $0f, $1f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $eb, $bc, $f0
    .byte $00, $cf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f9, $b3, $13, $29, $04, $43
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1c, $37, $23, $39, $50, $41, $02, $02
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $3a, $b5, $e0, $e8, $70, $d0, $29
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $c9, $c6, $70, $fa, $48, $18, $5c
    .byte $ff, $fc, $fe, $fb, $fc, $e0, $e2, $f0, $00, $01, $00, $00, $00, $02, $00, $00
    .byte $ff, $ff, $3f, $3f, $3f, $bf, $ef, $af, $00, $00, $00, $80, $40, $00, $00, $00
    .byte $fb, $fd, $3e, $3f, $3b, $b9, $ee, $af, $00, $00, $06, $80, $40, $00, $02, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $4c, $60, $60, $12, $70, $20, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $31, $9f, $78, $40, $e2, $00, $01, $00
    .byte $ff, $fe, $ff, $ff, $f8, $c2, $ff, $ff, $00, $01, $00, $00, $07, $3d, $00, $00
    .byte $e0, $3f, $cf, $87, $70, $00, $f0, $ff, $00, $c0, $30, $78, $8f, $ff, $0f, $00
    .byte $00, $00, $e0, $ff, $0f, $00, $3e, $ff, $7c, $13, $00, $00, $f0, $ff, $c1, $00
    .byte $00, $00, $00, $00, $e0, $8f, $00, $ff, $00, $04, $7c, $13, $00, $70, $ff, $00
    .byte $30, $00, $00, $00, $00, $e0, $47, $0f, $30, $00, $04, $7c, $13, $00, $b8, $f0
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $10, $18, $7c, $3c, $14, $0a, $b2, $f1
    .byte $ff, $ff, $ff, $ff, $ff, $ef, $ee, $ee, $00, $00, $00, $00, $00, $00, $08, $08
    .byte $ff, $ff, $fd, $f8, $fc, $f0, $14, $18, $00, $00, $00, $00, $86, $c4, $04, $08
    .byte $ef, $cf, $a7, $e7, $d5, $02, $28, $22, $00, $00, $20, $60, $70, $00, $e9, $22
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $13, $37, $3f, $2f, $f8
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $01, $0e, $b8, $fd, $ce, $fd, $5f
    .byte $fe, $d4, $c0, $d4, $f2, $f0, $fa, $c6, $00, $15, $00, $0e, $02, $00, $00, $00
    .byte $1f, $bf, $df, $e7, $d7, $03, $cf, $bf, $00, $00, $00, $80, $c0, $00, $10, $00
    .byte $1f, $ba, $dc, $e1, $d4, $03, $ce, $a8, $00, $02, $00, $83, $c4, $00, $10, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $02, $a7, $25, $02, $06, $62, $c2, $f1
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $67, $0c, $08, $30, $3f, $ff, $cf, $6f
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $60, $c4, $70, $00, $00, $82, $f5, $e8
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1b, $06, $0f, $05, $0c, $05, $91, $82
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $d1, $a1, $65, $91, $e0, $2c, $b2, $ba
    .byte $cb, $22, $8c, $6c, $c6, $1a, $a2, $26, $69, $26, $98, $7e, $c6, $3a, $aa, $76
    .byte $d9, $a3, $00, $8d, $6e, $02, $80, $80, $45, $a7, $00, $8d, $6f, $03, $88, $a3
    .byte $ff, $ff, $f9, $f8, $f8, $f0, $e0, $80, $00, $00, $00, $00, $00, $04, $1c, $13
    .byte $c5, $fc, $86, $ca, $08, $04, $00, $00, $09, $3c, $06, $0a, $08, $34, $dd, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $01, $00, $27, $33, $4c, $d0, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $f0, $e8, $00, $0f, $05, $01, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $62, $56, $11, $00, $85, $e0, $e6, $20
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $a0, $e8, $78, $d0, $00, $80, $18, $e0
    .byte $c2, $a8, $ee, $4c, $81, $0b, $fe, $d6, $00, $28, $ea, $4c, $4b, $03, $00, $04
    .byte $bf, $37, $85, $a5, $47, $5b, $cf, $3f, $00, $00, $80, $a0, $40, $c0, $00, $00
    .byte $9d, $34, $82, $a4, $40, $5a, $cc, $38, $00, $04, $86, $a0, $40, $c0, $00, $02
    .byte $c0, $e0, $e0, $f0, $f4, $fe, $ff, $ff, $ff, $bf, $7f, $1f, $db, $45, $1a, $00
    .byte $03, $0f, $3f, $3f, $7f, $ff, $ff, $ff, $fd, $f3, $de, $fd, $e8, $e2, $c0, $08
    .byte $08, $7c, $10, $3a, $4c, $24, $20, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $02, $02, $04, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $28, $3e, $62, $14, $10, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $08, $5c, $6a, $4a, $1c, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $08, $0e, $08, $18, $2c, $12, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

EpilogueNT:
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $f7, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8
    .byte $f8, $f8, $f8, $f8, $f8, $f9, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $01, $01, $01, $01, $01, $01, $01, $45, $52, $46
    .byte $01, $01, $01, $01, $fc, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    .byte $fd, $fd, $fd, $fd, $fd, $fe, $01, $01, $01, $01, $3f, $42, $43, $2e, $2f, $32
    .byte $01, $01, $19, $25, $01, $01, $3f, $42, $43, $01, $01, $01, $2e, $2f, $32, $39
    .byte $3a, $01, $17, $3f, $42, $43, $45, $46, $01, $01, $3a, $01, $43, $36, $37, $38
    .byte $0d, $51, $2d, $3a, $3f, $42, $43, $01, $19, $44, $0b, $0d, $36, $37, $38, $3d
    .byte $3e, $19, $22, $0d, $51, $52, $47, $50, $51, $52, $3e, $39, $51, $60, $64, $65
    .byte $53, $54, $55, $79, $0d, $19, $7a, $69, $6a, $6b, $53, $54, $60, $64, $65, $69
    .byte $53, $72, $73, $59, $53, $64, $65, $69, $53, $54, $59, $59, $72, $73, $6a, $6b
    .byte $02, $5a, $5a, $64, $65, $69, $6c, $6d, $72, $02, $02, $72, $73, $6a, $6b, $6c
    .byte $6d, $26, $27, $02, $02, $02, $6b, $6c, $72, $02, $02, $74, $75, $64, $65, $69
    .byte $1d, $1e, $1d, $1e, $1d, $1e, $1f, $1d, $1e, $1d, $1e, $1d, $1e, $1f, $1d, $1e
    .byte $1d, $1e, $1d, $1e, $1f, $1d, $1e, $1d, $1e, $1d, $1e, $1d, $1e, $1d, $1e, $1d
    .byte $10, $11, $10, $07, $09, $0a, $08, $13, $13, $14, $15, $14, $13, $13, $14, $15
    .byte $14, $18, $1b, $1a, $03, $04, $05, $06, $03, $04, $05, $30, $31, $04, $05, $06
    .byte $0c, $0c, $0e, $0f, $13, $14, $13, $12, $02, $0c, $0c, $0e, $04, $05, $06, $06
    .byte $10, $11, $20, $21, $10, $11, $20, $21, $10, $11, $20, $40, $41, $06, $05, $06
    .byte $02, $02, $02, $48, $49, $4a, $4b, $02, $5b, $5c, $5d, $5e, $5f, $0f, $0f, $0f
    .byte $0f, $28, $29, $2a, $13, $14, $15, $16, $13, $14, $15, $16, $13, $14, $15, $16
    .byte $02, $00, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $4c, $4d
    .byte $4e, $4e, $4f, $4e, $4f, $4c, $56, $57, $4c, $4d, $4e, $4f, $4e, $4f, $02, $1c
    .byte $02, $02, $02, $02, $02, $02, $00, $02, $02, $02, $00, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $00, $02, $66, $67, $02, $02, $02, $02, $02, $1c, $58, $2c
    .byte $02, $02, $02, $00, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $00
    .byte $02, $02, $02, $02, $56, $57, $76, $77, $23, $24, $02, $1c, $2b, $2c, $68, $3c
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $00, $02, $02, $02, $02, $02, $02, $02
    .byte $02, $02, $02, $02, $66, $67, $76, $77, $33, $34, $35, $2c, $3b, $3c, $78, $33
    .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $00, $02, $02
    .byte $02, $61, $62, $63, $05, $06, $6e, $6f, $10, $13, $14, $15, $14, $15, $14, $15
    .byte $02, $02, $02, $02, $02, $00, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    .byte $70, $71, $10, $16, $15, $16, $21, $21, $10, $11, $21, $21, $10, $11, $21, $21
    .byte $55, $55, $55, $55, $55, $55, $55, $55, $55, $ff, $ff, $ff, $ff, $77, $55, $55
    .byte $55, $ff, $ff, $ff, $ff, $77, $55, $55, $55, $ff, $ff, $ff, $ff, $77, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $55, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa
    .byte $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Epilogue Scene GFX  [$E89C :: 0x3E8AC]
;;
;;    Loads all CHR required for the epilogue scene.  Also
;;  loads the nametables for the bridge/ending scene!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadEpilogueSceneGFX:
    LDA #$00                ; This routine is 100% identical to 
    STA PPUMASK               ;   LoadBridgeSceneGFX below, except it loads CHR from
    STA PAPU_EN               ;   a different address.
   
    LDA #<EpilogueCHR     ; load a pointer to the bridge scene graphics (CHR first)
    STA tmp
    LDA #>EpilogueCHR
    STA tmp+1
    LDX #$08                 ; load 8 rows of tiles ($800 bytes)
    LDY PPUSTATUS   ; reset PPU Addr toggle
    LDA #$00
    STA PPUADDR   ; write high byte of dest address
    STA PPUADDR   ; write low byte:  0
    LDY #$00
    @loop0:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPUDATA         ; and write it to CHR-RAM
    INY               ; inc our source index
    BNE @loop0  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop0  ; if we've loaded all requested rows, exit.  Otherwise continue loading

    LDA #<EpilogueNT ; reset the source pointer to the start of that NT data
    STA tmp
    LDA #>EpilogueNT ; reset the source pointer to the start of that NT data
    STA tmp+1
    LDX #$04                 ; load 4 rows of tiles ($400 bytes)
    LDA #$00                 ; destination address = ppu $0000
    LDY PPUSTATUS   ; reset PPU Addr toggle
    LDA #$20
    STA PPUADDR   ; write high byte of dest address
    LDA #$00
    STA PPUADDR   ; write low byte:  0
    LDY #$00
    @loop1:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPUDATA         ; and write it to NT
    INY               ; inc our source index
    BNE @loop1  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop1  ; if we've loaded all requested rows, exit.  Otherwise continue loading

    LDA #<EpilogueNT ; reset the source pointer to the start of that NT data
    STA tmp
    LDA #>EpilogueNT ; reset the source pointer to the start of that NT data
    STA tmp+1
    LDX #$04                 ; load 4 rows of tiles ($400 bytes)
    LDA #$00                 ; destination address = ppu $0000
    LDY PPUSTATUS   ; reset PPU Addr toggle
    LDA #$24
    STA PPUADDR   ; write high byte of dest address
    LDA #$00
    STA PPUADDR   ; write low byte:  0
    LDY #$00
    @loop2:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPUDATA         ; and write it to NT
    INY               ; inc our source index
    BNE @loop2  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop2  ; if we've loaded all requested rows, exit.  Otherwise continue loading
    
    FARJUMP LoadMenuCHR
