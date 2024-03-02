.segment "PRG_036"

.include "src/global-import.inc"

.export PlayDoorSFX, DialogueBox_Sfx, VehicleSFX

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




VehicleSFX:
    LDA vehicle       ; Get currnt vehicle
    AND #$0C          ; isolate ship and airship bits
    BEQ @RTS         ; if not in ship or airship, just jump back to the loop
                      ;   otherwise... there's a sound effect we need to be playing

    CMP #$08          ; see if we're in the airship
    BNE @ShipSFX      ; if not.. jump ahead to Ship SFX

  @AirshipSFX:
    LDA #$38          ; The airship sound effect performed here is exactly the same
    STA PAPU_NCTL1         ;  as the one desribed in AirshipTransitionFrame  (see that routine
    LDA framecounter  ;  for details).  Only difference here is that the framecounter
    ASL A             ;  is doubled -- which means the sound effect cycles twice as fast,
    JUMP @PlaySFX      ;  so it sounds like the propellers are spinning faster.

  @ShipSFX:
    LDA framecounter  ; get frame counter
    BPL :+            ; if it's negative...
      EOR #$FF        ;  invert it
  :   LSR A             ; then right shift by 4.
    LSR A             ; this produces a triangle pattern between 0-7:
    LSR A             ;     0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0,0,1,2,3....  etc
    LSR A
    ORA #$30          ; use this pattern as the noise volume
    STA PAPU_NCTL1         ;   so the noise is constantly, slowly fading in and out (sounds like ocean waves)
    LDA #$0A          ; use a fixed frequency of $0A

  @PlaySFX:
    STA PAPU_NFREQ1         ; write specified frequency
    LDA #0
    STA PAPU_NFREQ2         ; write to last noise reg to reload length counter and get channel started
    @RTS:
    RTS
