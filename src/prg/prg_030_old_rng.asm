.segment "PRG_030"

.include "src/global-import.inc"

.export BattleRNG

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleRNG
;;
;;    This routine is basically like C's 'rand()' function.  It updates an RNG state (btl_rngstate), and uses
;;  That state to produce a random 8-bit value.
;;
;;    To generate the value, it simply runs the state through a scrambling lut.  What's strange is that it uses
;;  it's own LUT and not the LUT at $F100.  Why it has 2 separate luts to do the same thing is beyond me.
;;
;;    IMPORTANT NOTE!!!!  ChaosDeath in bank B assumes that calling this routine 256 times consecutively will
;;  produce every value between 00,FF.  As a result, this RNG must not have a period longer than 256.  This
;;  means a more complex RNG cannot really be implemented here.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleRNG:
    LDX btl_rngstate
    INC btl_rngstate
    LDA @Scramble_lut, X
    RTS
    
  @Scramble_lut:
    .byte $ae, $d0, $38, $8a, $ed, $60, $db, $72, $5c, $59, $27, $d8, $0a, $4a, $f4, $34
    .byte $08, $a9, $c3, $96, $56, $3b, $f1, $55, $f8, $6b, $31, $ef, $6d, $28, $ac, $41
    .byte $68, $1e, $2a, $c1, $e5, $8f, $50, $f5, $3e, $7b, $b7, $4c, $14, $39, $12, $cd
    .byte $b2, $62, $8b, $82, $3c, $ba, $63, $85, $3a, $17, $b8, $2e, $b5, $be, $20, $cb
    .byte $46, $51, $2c, $cf, $03, $78, $53, $97, $06, $69, $eb, $77, $86, $e6, $ea, $74
    .byte $0c, $21, $e2, $40, $d4, $5a, $3d, $c7, $2b, $94, $d5, $8c, $44, $fd, $ee, $d2
    .byte $43, $00, $bb, $fa, $c6, $1d, $98, $a0, $d3, $54, $5f, $5e, $dc, $a8, $00, $af
    .byte $93, $a1, $e1, $6c, $04, $de, $b6, $d7, $36, $16, $c5, $c8, $c4, $e4, $0f, $02
    .byte $ab, $e8, $33, $99, $73, $11, $6a, $09, $67, $f3, $ff, $a2, $df, $32, $0e, $1f
    .byte $0d, $90, $25, $64, $75, $b3, $65, $2f, $c9, $b0, $da, $5d, $9f, $ec, $29, $ce
    .byte $e3, $f0, $91, $7a, $58, $45, $24, $1c, $47, $a4, $89, $18, $2d, $cc, $bd, $6f
    .byte $80, $f6, $81, $22, $e9, $07, $70, $fb, $dd, $ad, $35, $a6, $61, $b4, $a3, $fe
    .byte $b1, $30, $4b, $15, $48, $6e, $4f, $5b, $13, $9c, $83, $92, $01, $c2, $19, $7f
    .byte $1a, $1b, $71, $b9, $3f, $4e, $9b, $bf, $9e, $87, $0b, $10, $57, $f2, $26, $79
    .byte $9a, $05, $c0, $e0, $f7, $4d, $7d, $ca, $52, $9d, $f9, $bc, $aa, $fc, $8d, $7e
    .byte $d1, $a5, $42, $e7, $d6, $76, $a7, $84, $8e, $66, $7c, $23, $88, $37, $49, $d9
