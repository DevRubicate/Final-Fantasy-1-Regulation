.segment "BANK_24"

.include "src/global-import.inc"

.export PlayDoorSFX, DialogueBox_Sfx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Play Door SFX  [$CF1E :: 0x3CF2E]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlayDoorSFX:
    LDA #%00001100  ; enable noise decay, set decay speed to $0C (moderately slow)
    STA PAPU_NCTL1
    LDA #$0E
    STA PAPU_NFREQ1       ; set freq to $0E  (2nd lowest possible for noise)
    LDA #$30
    STA PAPU_NFREQ2       ; start noise playback -- set length counter to stop after $25 frames
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DialogueBox_Sfx   [$D6C7 :: 0x3D6D7]
;;
;;    Plays the opening/closing sound effect heard when you open/close the dialogue
;;  box.  Note it does not change 'sq2_sfx' -- that is done outside this routine
;;
;;  IN:   A=$8E for the sweep-up sound (opening)
;;        A=$95 for the sweep-down sound (closing)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DialogueBox_Sfx:
    LDX #$38
    STX PAPU_CTL2      ; 12.5% duty (harsh), volume=8
    STA PAPU_RAMP2      ; for open ($8E):  sweep period=0 (fastest), sweep upwards in pitch, shift=6 (shallow steps)
                   ; for close ($95): sweep period=1 (fast), sweep down in pitch, shift=5 (not as shallow)

    LSR A          ; rotate sweep value by 2 bits
    ROR A
    EOR #$FF       ; and invert
    STA PAPU_FT2      ; use that as low byte of F value
                   ; for open:   F = $0DC
                   ; for close:  F = $035

    LDA #0         ; set high byte of F value to 0, and reload length counter
    STA PAPU_CT2
    RTS            ; and exit
