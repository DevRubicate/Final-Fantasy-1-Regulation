.segment "BANK_1E"

.include "src/registers.inc"
.include "src/constants.inc"
.include "src/macros.inc"
.include "src/ram-definitions.inc"

.import DisableAPU

.export ResetRAM, SetRandomSeed, GetRandom





ResetRAM:
    LDA #0    
    LDX #0
   @loop:
    STA $0000, X
    STA $0200, X
    STA $0300, X
    STA $0400, X
    STA $0500, X
    STA $0600, X
    STA $0700, X
    INX
    BNE @loop
    RTS


SetRandomSeed:
    lda #16
    sta rng_seed+0
    sta rng_seed+0
    rts


; GetRandom
;
; Returns a random 8-bit number in A (0-255), clobbers Y (0).
;
; Requires a 2-byte value on the zero page called "seed".
; Initialize seed to any value except 0 before the first call to prng.
; (A seed value of 0 will cause prng to always return 0.)
;
; This is a 16-bit Galois linear feedback shift register with polynomial $0039.
; The sequence of numbers it generates will repeat after 65535 calls.
;
; Execution time is an average of 125 cycles (excluding jsr and rts)

GetRandom:
    ldy #8     ; iteration count (generates 8 bits)
    lda rng_seed+0
    @loop:
    asl        ; shift the register
    rol rng_seed+1
    bcc @carryClear
    eor #$39   ; apply XOR feedback whenever a 1 bit is shifted out
    @carryClear:
    dey
    bne @loop
    sta rng_seed+0
    cmp #0     ; reload flags
    rts
