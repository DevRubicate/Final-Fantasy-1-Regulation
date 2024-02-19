.segment "BANK_0F"

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
    .incbin "bin/0F_FCF1_rngtable.bin"
