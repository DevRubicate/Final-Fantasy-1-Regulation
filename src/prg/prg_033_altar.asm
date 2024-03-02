.segment "PRG_033"

.include "src/global-import.inc"

.import WaitForVBlank

.export DoAltarEffect

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Altar Frame  [$DADE :: 0x3DAEE]
;;
;;    This routine is called to wait for a frame for the Altar Effect.
;;  It syncs up the frame so that scanlines can be waited and the timed raster effect
;;  for the Altar Effect can be performed.
;;
;;    IN:  tmp+1  = number of monochrome scanlines
;;         tmp+15 = X scroll as written to PPU (sm_scroll_x * 16)
;;
;;    The routine exits about 593 cycles (roughly 5.2 scanlines) into VBlank.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AltarFrame:
    LDA tmp+1         ; get number of monochrome'd scanlines
    LSR A             ; divide by 8
    LSR A
    LSR A

    ORA #$30          ; use monochrome scanlines/8 as the volume for sq2 and noise effect
    STA PAPU_NCTL1         ;  this will cause the sound effect to fade in and fade out and more/less
    STA PAPU_CTL2         ;  lines of the effect are visible

    AND #$01          ; also use the low bit of lines/8 as a scroll adjustment
    EOR tmp+15        ; OR with desired X scroll
    STA PPUSCROLL         ; and record this as the scroll for the next frame.  This causes
                      ;  the screen to "shake" by 1 pixel every 8 frames.  This hides
                      ;  the unavoidable inperfection of the monochrome effect (unavoidable because
                      ;  you can't time the writes to the exact pixel no matter how careful you are)

    CALL WaitForVBlank    ; wait for VBlank.  This returns ~37 cycles into VBlank
    LDA #>oam         ; Do sprite DMA.  This burns another 513+2+4 cycles -- currently ~556 into VBl
    STA OAMDMA

    LDY #6            ; do a bit more stalling to get the time right where we want it (+2 cycs for LDY)
  @Loop:
      DEY
      BNE @Loop       ; 5*6 - 1 = 29 for loop
    RTS               ; +6 for RTS = routine exits ~593 cycs into VBl






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do an Altar Scanline [$DB0B :: 0x3DB1B]
;;
;;    This routine waits 109 cycles just like WaitAltarScanline, however it toggles monochrome
;;  mode at points within the scanline to create the altar effect.  Monochrome is switched on
;;  63 cycles in and switched off 103 cycles in, resulting in a monochrome effect for 40 cycles
;;  (120 pixels).  Since there's an effective 114 cycle delay between calls, each call occurs
;;  one dot/pixel later in the scanline than the previous, which results in the monochrome effect moving
;;  diagonally down-right rather than straight down.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DoAltarScanline:
    LDY #10         ; 8 cycs (CALL=6 + LDY=2)
   @Loop:
      DEY
      BNE @Loop     ; 5 cyc loop * 10 iterations - 1 = 49 cycs for loop.  49+8 = 57 cycs

      CRITPAGECHECK @Loop

    LDA #$1F        ; +2 = 59
    STA PPUMASK       ; +4 = 63 -- monochrome turned on 63 cycs in

    LDY #$1E        ; +2 = 65
    NOP             ; +2 = 67
    NOP             ; +2 = 69
    CALL @Burn12     ; +12= 81
    CALL @Burn12     ; +12= 93
    NOP             ; +2 = 95
    NOP             ; +2 = 97
    NOP             ; +2 = 99
    STY PPUMASK       ; +4 = 103 -- monochrome turned off 103 cycs in
                    ;   following RTS makes this routine 109 cycles long

  @Burn12:          ; the routine JSRs here to burn 12 cycles (CALL+RTS = 12 cycs)
    RTS




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Altar Effect [$DA4E :: 0x3DA5E]
;;
;;    This routine performs the "Altar" raster effect.  This effect occurs when you
;;  step on any one of the four altars which revive the orbs.  It creates a 'beam of light'
;;  that starts on the screen where the player is standing and moves towards the upper-left
;;  corner of the screen, while the screen gently shakes and a "voooom" sound effect is played.
;;
;;    Music is silenced during this time, and all input is ignored.  The game is essentially
;;  frozen until this routine exits and the effect is complete (it takes several frames).
;;
;;    The routine uses a few areas in temp RAM for a few things:
;;
;;    tmp    = number of scanlines to delay before starting to illuminate scanlines
;;    tmp+1  = number of scanlines to illuminate
;;    tmp+2  = 0 when the 'beam' is expanding upward from the player sprite to the UL corner
;;             1 when the 'beam' has reached the UL corner and begins retracting to the UL corner
;;              (moving away from the player sprite)
;;    tmp+15 = desired X scroll for the screen (as it needs to be written to PPUSCROLL)
;;
;;    "Illuminated" scanlines just have the monochrome effect switched on for part of them.  There
;;  are no palette changes involved in this effect.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DoAltarEffect:
    LDA sm_scroll_x      ; get the X scroll for the map
    ASL A                ; multiply it by 16 to get the value need to be written to PPUSCROLL
    ASL A
    ASL A
    ASL A
    STA tmp+15           ; record it for future use in the routine

    LDA NTsoft2000       ; copy the NT scroll to the main soft2000 var
    STA soft2000         ; 'soft2000' is written to PPUCTRL automatically every frame (in OnNMI)
                         ; This ensures that the NT scroll will be correct during this routine

    LDA #0
    STA tmp+2            ; clear the phase (start with beam expanding outward from player)
    STA altareffect      ; clear the altar effect flag

    LDA #138
    STA tmp              ; start with a 138 scanline delay before illumination
    LDA #2
    STA tmp+1            ; start with 2 scanlines illuminated

    LDA #$30
    STA PAPU_NCTL1            ; silence all audio channels by writing setting their volume to 0
    STA PAPU_CTL2
    STA PAPU_CTL1            ;  note this doesn't silence the triangle because tri has no volume control
    STA PAPU_TCR1            ; instead it marks the linear counter to silence the triangle after $30 clocks (12 frames)

    LDA #$0E
    STA PAPU_NFREQ1            ; set noise to play freq $E  (2nd lowest pitch possible for noise)
    LDA #$00
    STA PAPU_NFREQ2            ; start noise playback.  Note noise is still inaudible because its vol=0, but will
                         ; become audible as soon as its volume is changed (see AltarFrame)

    STA PAPU_FT2            ; set sq2's freq to $500 (low pitch) and start playback
    LDA #$05             ; again it isn't immediately audible, but will be as soon as its vol is changed
    STA PAPU_CT2

    LDA PPUSTATUS            ; reset PPU toggle (seems unnecessary here?)

    @MainLoop:

    CALL AltarFrame         ; do a frame and sync to desired raster time

    LDX tmp                ; delay 'tmp' scanlines
    @LinesDelay:
      CALL WaitAltarScanline
      DEX
      BNE @LinesDelay
          PAGECHECK @LinesDelay

    LDX tmp+1              ; then illuminate 'tmp+1' scanlines
    @LinesIllum:
      CALL DoAltarScanline
      DEX
      BNE @LinesIllum
          PAGECHECK @LinesIllum

    LDA tmp+2              ; check the phase to see if the beam is expanding/retracting
    BNE @RetractBeam       ; if retracting, jump ahead
                           ; otherwise, beam is expanding

  @ExpandBeam:
    LDA tmp+1           ; inc the number of illuminated scanlines by 2
    CLC
    ADC #$02
    STA tmp+1

    LDA tmp             ; and decrease the delay by 2 (moves top of beam up, but does not move
    SEC                 ; bottom of beam)
    SBC #$02
    STA tmp

    CMP #32             ; see if the delay is < 32 scanlines
    BCS @MainLoop       ; if not, continue as normal

    LDA #1              ; otherwise (< 32 scanline delay), beam has reached top (but not quite top of screen)
    STA tmp+2           ; switch the phase over so that it starts retracting the beam.
    JUMP @MainLoop       ; and continue looping

  @RetractBeam:
    LDA tmp+1           ; to retract the beam, simply reduce the number of illuminated lines by 2
    SEC                 ; and do not change the delay
    SBC #$02
    STA tmp+1

    CMP #$08            ; keep looping until < 8 lines are illuminated
    BCS @MainLoop       ;  at which point, we're done


  @Done:                ; altar effect is complete
    NOP
    NOP

    LDA tmp+15          ; restore the desired X scroll (to undo the possible shaking)
    STA PPUSCROLL

    LDA #$00            ; restart sq1, sq2, and tri so they can resume playing the music track
    STA PAPU_CT2           ;  however note that sq2 is currently playing the wrong note (freq was changed for
    STA PAPU_NCTL1           ;  the sound effect)
    STA PAPU_CTL2

    LDA #1              ; to prevent sq2 from playing the wrong note, mark it as playing a sound effect so
    STA sq2_sfx         ; the proper freq will be set by the music playback.

    RTS                 ; then exit!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Wait an Altar Scanline  [$DB00 :: 0x3DB10]
;;
;;    This routine is similar to WaitScanline, however it is specifically applicable
;;  to the Altar effect because it waits *exactly* 109 cycles (and not 108.66667).  This
;;  causes a wait a little longer than a full scanline (1 dot longer), which produces a diagonal
;;  raster effect, rather than a perfect vertical line.
;;
;;    JSRing to this routine eats exactly 109 cycles.  When placed inside a 'DEX/BNE' loop,
;;  this totals 114 cycles (DEX+BNE = 5 cycles) which is 1 dot longer than a scanline.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitAltarScanline:   ; CALL to routine = 6 cycles
    LDY #18          ; +2 = 8
  @Loop:
     DEY
     BNE @Loop       ; 5 cycle loop * 18 iterations - 1 = 89 cycles for loop
                     ; 8+89 = 97 cycs

       CRITPAGECHECK @Loop

    NOP              ; +2 = 99
    NOP              ; +2 = 101
    NOP              ; +2 = 103
    RTS              ; +6 = 109
