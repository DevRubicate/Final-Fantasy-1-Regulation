.segment "BANK_1E"

.include "src/global-import.inc"

.import DisableAPU

.export ResetRAM, SetRandomSeed, GetRandom, ClearOAM, ClearZeroPage





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
; Execution time is an average of 125 cycles (excluding CALL and rts)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Clear OAM   [$C43C :: 0x3C44C]
;;
;;    Fills Shadow OAM with $F8 (which effectively clears it so no sprites are visible)
;;  also resets the sprite index to zero, so that the next sprite drawn will
;;  have top priority.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearOAM:
    LDX #$3F       ; use X as loop counter (looping $40 times)
    LDA #$F8       ; we'll be clearing to $F8

    @Loop:
        STA oam, X ; clear 4 bytes of OAM
        STA oam + $40, X
        STA oam + $80, X
        STA oam + $C0, X
        DEX          ; and continue looping until X expires
        BPL @Loop

    LDA #0         ; set sprite index to 0
    STA sprindex
    RTS            ; and exit



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Clear Zero Page  [$C454 :: 0x3C464]
;;
;;    Clears Zero Page RAM (or, more specifically, $0001-00EF -- not
;;  quite all of zero page
;;
;;    This is done after game start as a preparation measure.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearZeroPage:
    LDX #$EF          ; start from $EF and count down
    LDA #0
  @Loop:
      STA 0, X
      DEX
      BNE @Loop       ; clear RAM from $01-EF

    LDA #$1B          ; scramble the NPC directional RNG seed
    ORA npcdir_seed   ;  to make it a little more random
    STA npcdir_seed

    RTS
