.segment "PRG_068"

.include "src/global-import.inc"

.import LoadMenuCHR

.export LoadBridgeSceneGFX

BridgeCHR:
    .byte $ff, $fe, $e8, $c0, $80, $80, $00, $00, $ff, $fe, $e8, $c0, $a0, $80, $00, $00
    .byte $ff, $fe, $00, $01, $ff, $ff, $ff, $fb, $01, $ff, $fe, $00, $00, $00, $04, $f8
    .byte $ff, $fe, $c9, $b3, $f3, $e3, $e3, $e3, $00, $3e, $4c, $08, $38, $38, $38, $38
    .byte $ff, $ff, $c1, $90, $b0, $f0, $f0, $f2, $00, $3c, $7c, $5e, $1e, $1f, $1b, $19
    .byte $ff, $ff, $fc, $f9, $f9, $79, $79, $39, $00, $07, $0c, $0c, $0c, $0c, $0c, $8c
    .byte $ff, $f0, $e0, $ee, $fc, $fc, $f9, $ff, $00, $0f, $10, $01, $02, $02, $04, $0f
    .byte $ff, $0f, $0f, $4f, $cf, $cf, $cf, $c7, $00, $e0, $e0, $e0, $60, $60, $60, $f0
    .byte $e3, $e3, $e3, $e3, $e3, $e3, $e3, $e3, $38, $38, $38, $38, $38, $38, $38, $38
    .byte $ff, $ff, $ff, $82, $ee, $ee, $ee, $ee, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $e0, $c0, $bf, $fe, $fe, $fe, $00, $1f, $3f, $40, $01, $03, $03, $03
    .byte $ff, $fe, $01, $83, $3f, $3f, $3f, $3f, $01, $fe, $fc, $c0, $80, $80, $80, $80
    .byte $ff, $ff, $f0, $e0, $ef, $d3, $e4, $f9, $00, $0f, $1f, $30, $30, $1c, $07, $01
    .byte $ff, $fb, $01, $01, $f3, $e7, $ff, $1f, $00, $fc, $fc, $0c, $08, $10, $00, $e0
    .byte $ff, $e1, $83, $f7, $e7, $c7, $c7, $c7, $00, $7c, $f8, $10, $30, $70, $70, $70
    .byte $c1, $83, $e7, $ef, $cf, $8f, $8f, $8f, $7c, $f8, $10, $20, $60, $e0, $e0, $e0
    .byte $ff, $fe, $fd, $f9, $fb, $f1, $f0, $f8, $00, $02, $06, $0c, $08, $1c, $1e, $0f
    .byte $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $0f, $0f, $0e, $0e, $0e, $0e, $0e, $0e
    .byte $07, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $f0, $00, $00, $00, $00, $00, $00, $00
    .byte $e3, $e3, $e3, $e3, $e6, $e4, $c1, $83, $38, $38, $38, $38, $32, $3e, $7c, $00
    .byte $f2, $f3, $f3, $f3, $e7, $e7, $c1, $83, $19, $18, $18, $18, $30, $30, $7c, $00
    .byte $39, $19, $19, $89, $89, $c1, $e1, $f3, $8c, $cc, $cc, $6c, $7c, $3c, $18, $08
    .byte $f0, $c0, $93, $f3, $e7, $e7, $c3, $c1, $1f, $24, $48, $08, $10, $10, $3c, $00
    .byte $07, $07, $e7, $f3, $f3, $f2, $f8, $f9, $f0, $30, $30, $18, $18, $19, $0e, $0c
    .byte $e3, $e3, $e3, $e3, $e3, $c7, $c0, $80, $38, $38, $38, $38, $38, $7f, $7f, $00
    .byte $ff, $ff, $ff, $ff, $fe, $fc, $01, $03, $00, $00, $00, $00, $02, $fe, $fc, $00
    .byte $fe, $fe, $fe, $fe, $fe, $fe, $fc, $fc, $03, $03, $03, $03, $03, $03, $07, $00
    .byte $3f, $3f, $3f, $3b, $73, $07, $07, $cf, $80, $80, $80, $84, $08, $f0, $30, $00
    .byte $f6, $ef, $cf, $a3, $d1, $e4, $f9, $fe, $10, $20, $70, $3c, $1e, $07, $01, $00
    .byte $13, $e1, $f9, $f1, $e3, $47, $0f, $1f, $1c, $04, $04, $0c, $18, $b0, $e0, $00
    .byte $c7, $e7, $e3, $f2, $f0, $f9, $fb, $ff, $70, $30, $38, $19, $1e, $0c, $00, $00
    .byte $8f, $8f, $0f, $0f, $0f, $8f, $8f, $8f, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
    .byte $fc, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $07, $03, $01, $00, $00, $00, $00, $00
    .byte $00, $1c, $32, $22, $61, $61, $7f, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $61, $61, $7e, $61, $61, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $61, $61, $60, $61, $61, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $61, $61, $61, $61, $61, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $60, $7f, $60, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $60, $7e, $60, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $6f, $61, $61, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $61, $61, $61, $7f, $61, $61, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1e, $0c, $0c, $0c, $0c, $0c, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $03, $03, $03, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $66, $7c, $62, $61, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $60, $60, $60, $60, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $41, $63, $63, $55, $5d, $49, $41, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $61, $71, $71, $69, $65, $63, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $61, $61, $61, $61, $61, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $61, $61, $61, $7e, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $61, $61, $61, $61, $66, $3b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $61, $61, $7e, $64, $62, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $3e, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $18, $18, $18, $18, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $62, $62, $62, $62, $62, $62, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $61, $61, $32, $32, $36, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $49, $49, $49, $49, $5d, $77, $22, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $77, $14, $1c, $14, $77, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $63, $36, $1c, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $03, $36, $1c, $36, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $fc, $f8, $f8, $f0, $c0, $e0, $e0, $f0, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $02, $00, $01, $03, $03, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $fe, $e8, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $20, $00, $00, $00
    .byte $7f, $7f, $7f, $7f, $7f, $63, $00, $00, $00, $00, $00, $00, $00, $10, $97, $08
    .byte $ff, $ff, $ff, $ff, $cd, $00, $00, $00, $00, $00, $00, $00, $10, $c0, $0b, $38
    .byte $ff, $ff, $ff, $ff, $29, $00, $00, $00, $00, $00, $00, $00, $16, $de, $00, $00
    .byte $ff, $ff, $ff, $fa, $90, $c0, $00, $80, $ff, $ff, $ff, $fa, $90, $c0, $00, $80
    .byte $ff, $ff, $ff, $ff, $ff, $f4, $41, $00, $00, $00, $00, $00, $00, $00, $01, $00
    .byte $ff, $ff, $ff, $f0, $c0, $e0, $80, $00, $00, $00, $00, $00, $20, $10, $78, $c6
    .byte $ff, $c3, $80, $80, $c0, $00, $00, $00, $00, $00, $40, $60, $38, $20, $00, $00
    .byte $ff, $ff, $7f, $0f, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $fa, $fd, $ff, $fb, $df, $ff, $7f, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $3c, $42, $9d, $a1, $a1, $9d, $42, $3c, $3c, $42, $9d, $a1, $a1, $9d, $42, $3c
    .byte $00, $11, $32, $12, $11, $10, $12, $11, $00, $11, $32, $12, $11, $10, $12, $11
    .byte $ff, $ff, $ff, $df, $b0, $00, $00, $00, $00, $00, $00, $00, $01, $2c, $00, $00
    .byte $ff, $ff, $ff, $38, $03, $00, $00, $00, $00, $00, $00, $84, $20, $00, $00, $00
    .byte $70, $38, $38, $78, $60, $40, $40, $00, $00, $00, $00, $00, $08, $00, $00, $00
    .byte $00, $c7, $28, $28, $e7, $28, $28, $c7, $00, $c7, $28, $28, $e7, $28, $28, $c7
    .byte $ff, $ff, $ff, $ff, $fe, $fc, $fc, $fe, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $f7, $e3, $e3, $63, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $e7, $c3, $c3, $e3, $c0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $f8, $f6, $fe, $fc, $f0, $f0, $e0, $00, $00, $00, $00, $00, $01, $01, $00
    .byte $e0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $83, $ec
    .byte $f8, $f8, $fc, $48, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $7f, $0e, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $13, $13, $17, $13, $2b, $2d, $3b, $7f
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $80, $88, $e8, $a8, $f8, $ac, $ac, $ec
    .byte $ff, $ff, $27, $db, $ff, $ff, $e4, $fb, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f9, $00, $00, $00, $00, $00, $00, $06, $0c
    .byte $ff, $ff, $c0, $84, $b8, $f8, $f8, $f9, $00, $3f, $7f, $46, $0e, $0e, $0e, $0f
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $fe, $7c, $00, $00, $00, $00, $00, $00, $01, $02
    .byte $8f, $8f, $8f, $9f, $9f, $3f, $7f, $ff, $e0, $e0, $e0, $c0, $c0, $80, $00, $00
    .byte $00, $3e, $82, $84, $04, $88, $88, $08, $00, $3e, $82, $84, $04, $88, $88, $08
    .byte $bf, $bf, $f4, $40, $80, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00
    .byte $18, $10, $80, $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $fc, $f0, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $e7, $c3, $c3, $c3, $81, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $c0, $c0, $f0, $e0, $f8, $f0, $f4, $f7, $01, $0f, $07, $06, $02, $01, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $c0, $00, $00, $00, $00, $33, $1c
    .byte $ff, $ff, $ff, $f8, $f1, $e3, $e3, $e3, $00, $00, $07, $0e, $18, $38, $38, $38
    .byte $ff, $ff, $bf, $7f, $ff, $ff, $ff, $ff, $00, $00, $80, $00, $00, $00, $00, $00
    .byte $ff, $ff, $bf, $6d, $87, $00, $00, $00, $3f, $1d, $5d, $ff, $7f, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $77, $11, $02, $00, $ee, $fc, $7e, $fe, $fe, $ff, $ff, $ff
    .byte $6f, $9f, $ff, $ff, $ff, $d7, $ef, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $f3, $e1, $f0, $f8, $fc, $fe, $ff, $ff, $18, $3c, $1e, $0f, $07, $03, $01, $00
    .byte $f8, $f8, $f8, $79, $33, $27, $0f, $9f, $0e, $0e, $0e, $0c, $98, $f0, $e0, $80
    .byte $39, $13, $07, $cf, $9f, $ff, $ff, $ff, $84, $c8, $f0, $e0, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ef, $4f, $af, $ef, $ef, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $e0, $e0, $c0, $c0, $83, $86, $8d, $9b, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $02, $01, $00, $00, $06, $8c, $8c, $1c, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $f5, $fd, $8f, $61, $80, $00, $00, $00, $00, $00, $00, $10, $38, $47
    .byte $80, $36, $bc, $f0, $e0, $40, $00, $00, $00, $00, $03, $0c, $0f, $02, $00, $80
    .byte $ff, $fd, $d0, $41, $80, $00, $00, $00, $00, $02, $2f, $be, $7f, $ff, $ff, $ff
    .byte $ff, $ff, $bf, $6f, $85, $60, $00, $7f, $00, $00, $40, $90, $fa, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $77, $71, $e2, $80, $00, $00, $00, $00, $88, $ef, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $f0, $00, $00, $00, $00, $00, $00, $32, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $81, $00, $00, $00, $00, $00, $20, $72, $fe, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $f8, $02, $00, $00, $00, $00, $10, $10, $b7, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $01, $01, $01, $01, $03, $01
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $1f, $00, $00, $00, $00, $00, $00, $02, $f7, $ff
    .byte $01, $02, $04, $08, $10, $20, $40, $80, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $10, $28, $28, $33, $4a, $44, $3a, $00, $10, $28, $28, $33, $4a, $44, $3a
    .byte $00, $c7, $28, $28, $e7, $20, $28, $c7, $00, $c7, $28, $28, $e7, $20, $28, $c7
    .byte $00, $1c, $a2, $a2, $a2, $a2, $a2, $1c, $00, $1c, $a2, $a2, $a2, $a2, $a2, $1c
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

BridgeNT:
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $f7, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8
    .byte $f8, $f8, $f8, $f8, $f8, $f9, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $56, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fa, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $fb, $6d, $6d, $6d, $6d, $6d, $66, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $fc, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd, $fd
    .byte $fd, $fd, $fd, $fd, $fd, $fe, $6d, $6d, $6d, $6d, $66, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $62, $63, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $58, $01, $02, $03, $04, $05, $06, $07, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $45, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $57, $10, $11, $12, $13, $14, $15, $16, $17, $18, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $42
    .byte $6d, $6d, $6d, $6d, $67, $68, $6d, $58, $01, $05, $06, $03, $04, $09, $0a, $05
    .byte $06, $0b, $0c, $0d, $0e, $08, $6a, $6d, $6d, $6d, $6d, $6d, $6d, $50, $51, $6b
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $57, $10, $11, $15, $16, $13, $14, $19, $1a, $15
    .byte $16, $1b, $1c, $1d, $1e, $6d, $6d, $6d, $4c, $4d, $4e, $4f, $6d, $60, $61, $6b
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $67, $68, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $0f, $59, $5a, $6d, $5e, $5f, $3a, $3b, $6b, $3d, $48, $70, $71, $6b
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $78, $6d, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $1f, $69, $6d, $6d, $6e, $6f, $4a, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $6d, $6d, $6d, $6d, $6d, $6d, $6d, $6d, $54, $55, $6d, $6d, $6d, $6d, $6d, $6d
    .byte $6d, $6d, $6d, $6d, $41, $41, $5c, $5d, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $72, $73, $74, $75, $72, $73, $72, $73, $64, $65, $79, $76, $77, $79, $79, $79
    .byte $79, $79, $79, $3c, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c
    .byte $6c, $6c, $00, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $6c, $6c, $33, $2c, $7b, $46, $6b, $47, $7c, $7d, $6c, $6c, $6c, $6c, $6c, $6c
    .byte $40, $00, $6b, $6b, $6b, $6b, $6b, $6b, $46, $47, $4b, $5b, $6b, $6b, $6b, $6b
    .byte $6c, $6c, $2d, $28, $2d, $33, $24, $2d, $23, $2e, $6c, $6c, $6c, $6c, $40, $00
    .byte $6b, $6b, $6b, $6b, $6b, $6b, $6b, $32, $30, $34, $20, $31, $24, $6b, $6b, $6b
    .byte $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $00, $6b
    .byte $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $6c, $00, $6b, $6b
    .byte $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b, $6b
    .byte $55, $55, $55, $55, $55, $55, $55, $55, $55, $ff, $ff, $ff, $ff, $77, $55, $55
    .byte $55, $ff, $ff, $ff, $ff, $77, $55, $55, $55, $ff, $ff, $ff, $ff, $77, $55, $55
    .byte $55, $55, $55, $55, $55, $55, $55, $95, $55, $55, $65, $55, $55, $95, $aa, $aa
    .byte $ea, $fa, $ba, $aa, $aa, $ea, $fa, $ba, $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Bridge Scene GFX  [$E8CB :: 0x3E8DB]
;;
;;    Loads all CHR required for the bridge scene.  Also
;;  loads the nametables for the bridge scene!
;;
;;    This is also used for the minigame, too.  Since it has the same nametable
;;  layout and much of the same CHR.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBridgeSceneGFX:
    LDA #0
    STA PPU_MASK                ; turn off PPU
    STA PAPU_EN                ; and APU

    LDA #<BridgeCHR     ; load a pointer to the bridge scene graphics (CHR first)
    STA tmp
    LDA #>BridgeCHR
    STA tmp+1
    LDX #$08                 ; load 8 rows of tiles ($800 bytes)
    LDY PPU_STATUS   ; reset PPU Addr toggle
    LDA #$00
    STA PPU_ADDR   ; write high byte of dest address
    STA PPU_ADDR   ; write low byte:  0
    LDY #$00
    @loop0:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPU_DATA         ; and write it to CHR-RAM
    INY               ; inc our source index
    BNE @loop0  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop0  ; if we've loaded all requested rows, exit.  Otherwise continue loading

    LDA #<BridgeNT ; reset the source pointer to the start of that NT data
    STA tmp
    LDA #>BridgeNT ; reset the source pointer to the start of that NT data
    STA tmp+1
    LDX #$04                 ; load 4 rows of tiles ($400 bytes)
    LDA #$00                 ; destination address = ppu $0000
    LDY PPU_STATUS   ; reset PPU Addr toggle
    LDA #$20
    STA PPU_ADDR   ; write high byte of dest address
    LDA #$00
    STA PPU_ADDR   ; write low byte:  0
    LDY #$00
    @loop1:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPU_DATA         ; and write it to NT
    INY               ; inc our source index
    BNE @loop1  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop1  ; if we've loaded all requested rows, exit.  Otherwise continue loading


    LDA #<BridgeNT ; reset the source pointer to the start of that NT data
    STA tmp
    LDA #>BridgeNT ; reset the source pointer to the start of that NT data
    STA tmp+1
    LDX #$04                 ; load 4 rows of tiles ($400 bytes)
    LDA #$00                 ; destination address = ppu $0000
    LDY PPU_STATUS   ; reset PPU Addr toggle
    LDA #$24
    STA PPU_ADDR   ; write high byte of dest address
    LDA #$00
    STA PPU_ADDR   ; write low byte:  0
    LDY #$00
    @loop2:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPU_DATA         ; and write it to NT
    INY               ; inc our source index
    BNE @loop2  ; if it didn't wrap, continue looping
    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop2  ; if we've loaded all requested rows, exit.  Otherwise continue loading

    FARJUMP LoadMenuCHR     ; after all that, load the usual menu graphics (box borders, font, etc) and exit
