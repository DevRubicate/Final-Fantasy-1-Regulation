.segment "PRG_048"

.include "src/global-import.inc"

.import WaitScanline, DrawMapPalette, WaitForVBlank, SetOWScroll, SetSMScroll, ClearSprites

.export ScreenWipe_Open, ScreenWipe_Close

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Start Screen Wipe  [$D79D :: 0x3D7AD]
;;
;;    Does prepwork for the screen wipe effect (for map transitions)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


StartScreenWipe:
    FARCALL ClearSprites
    CALL WaitForVBlank   ; then wait for VBlank

    LDA #$01              ; silence all channels except for square 1
    STA PAPU_EN             ;   this stops all music.  Square 1 is used for the wipe sound effect

    LDA #$38              ; 12.5% duty (harsh), volume=8
    STA PAPU_CTL1
    LDA #%10001010        ; sweep downwards in pitch with speed=0 (fast!) and shift=2 (medium)
    STA PAPU_RAMP1             ;  don't set F-value here, though -- that isn't done until
                          ;  ScreenWipeFrame

    RTS                   ; exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Screen Wipe  [$D6DC :: 0x3D6EC]
;;
;;    These routines do the screen wipe effect that is performed as a map
;;  transition (like when you enter a town or go down a staircase).
;;
;;  ScreenWipe_Open opens the screen up
;;  ScreenWipe_Close closes it
;;
;;    They both do pretty much the same thing, but in reverse order.  When
;;  ScreenWipe_Open exits, the PPU is left on, and when ScreenWipe_Close
;;  exits, the PPU is switched off.
;;
;;    Neither routine returns until the wipe effect is complete (takes several frames)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;
 ;; ScreenWipe_Open  [$D6DC :: 0x3D6EC]
 ;;

ScreenWipe_Open:
    CALL StartScreenWipe     ; do screen wipe prepwork

    LDA #122+11             ; start the wipe at scanline 122 (just below the center of the screen
    STA tmp+4               ;  -- it probably should've been 120)
    LDA #1                  ; start with just 1 scanline visible
    STA tmp+5

  @Loop:
      CALL ScreenWipeFrame   ; do a frame with these wipe params

      LDA tmp+4             ; move the opened part up by subtracting 2 from the start scanline
      SEC
      SBC #2
      STA tmp+4

      LDA tmp+5             ; move the bottom part down by adding 4 to the visible scanlines
      CLC                   ;  note this only moves the bottom of the wipe down 2 scanlines
      ADC #4                ;  because the above -2 offsets this
      STA tmp+5

      CMP #224              ; continue until 224 scanlines are visible (full frame minus 8
      BCC @Loop             ;  lines off the top and bottom)

    LDA #$1E                ; then jump to the finalization with A=1E (PPU On)
    JUMP ScreenWipe_Finalize

 ;;
 ;; ScreenWipe_Close  [$D701 :: 0x3D711]
 ;;

ScreenWipe_Close:
    CALL StartScreenWipe     ; do screen wipe prepwork

    LDA #10+11              ; start the wipe at scanline 10 
    STA tmp+4
    LDA #220+1              ; start with 221 scanlines visible
    STA tmp+5               ;  this will make lines 10-230 visible
                            ;  wipe will be centered on the screen

  @Loop:
      CALL ScreenWipeFrame   ; do a frame with these wipe params

      LDA tmp+4             ; move the top portion of the wipe down by
      CLC                   ;  adding 2 to the start line
      ADC #2
      STA tmp+4

      LDA tmp+5             ; move the bottom portion up by
      SEC                   ;  subtracting 4 from the stop line.  Note
      SBC #4                ;  this only moves the bottom up by 2 scanlines, not 4
      STA tmp+5             ;  (because adding 2 above offsets this as well)

      CMP #1                ; see if we're down to just 1 scanline being visible
      BNE @Loop             ;  if we are, we're done.  If not, keep wiping

    LDA #$00           ; now that the wipe is complete...
                       ;   flow into ScreenWipe_Finalize with A=0 (to turn off PPU)

 ;;
 ;; ScreenWipe_Finalize  [$D723 :: 0x3D733] -- just finishes up some stuff for the screen wipe
 ;;

ScreenWipe_Finalize:
    STA PPU_MASK          ; turn on/off the PPU (Close turns it off, Open turns it on)
    LDA #0
    STA PAPU_FT1          ; then silence the Sq1 sound effect by setting its F-value to zero
    STA PAPU_CT1

    RTS                ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Screen Wipe Frame  [$D72F :: 0x3D73F]
;;
;;    Called every frame of the screen wipe effect (transition between maps).
;;  Does Sprite DMA, draws the palette, and sets the scroll.
;;
;;    In addition to doing these somewhat ordinary tasks... the routine takes
;;  a more or less fixed amount of time.  If CALL'd to immediately after waiting
;;  for VBlank, this routine should exit approximately ~1105 cycles into VBlank
;;  (~9.7 scanlines into VBlank -- about 11 scanlines before onscreen rendering starts)
;;  Timing here isn't super-critical.  However drastic changes in the length
;;  of this routine could impact the screen wipe effect.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScreenWipeFrame_Prep:
    CALL DrawMapPalette  ; draw the palette

    LDA mapflags        ; see if we're on the overworld or standard map
    LSR A
    BCS :+
      FARJUMP SetOWScroll   ; and set scroll appropriately
    :   
    JUMP SetSMScroll     ;  then exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Screen Wipe Frame  [$D742 :: 0x3D752]
;;
;;    Does a single frame of the Screen Wipe effect (map transition).  Updates
;;  the screen wipe sound effect as well.
;;
;;  IN:  tmp+4 = number of scanlines (-11) off the top of the screen that are to be hidden
;;       tmp+5 = number of scanlines in the middle of the screen that are to be visible
;;
;;    'tmp+4' effectively determines where the video gets turned on, and tmp+4 + tmp+5 determines
;;  where the video gets turned off again.  Note that this routine starts counting scanlines 11
;;  lines BEFORE onscreen redering begins... so tmp+4 should be 11 higher than what is actually
;;  desired.
;;
;;    To draw the 'black' portions of the wipe effect, the game simply disables BG rendering
;;  for that portion of the screen.  However, Sprite rendering remains on for the full frame!
;;  So any onscreen sprites will be visible even in portions of the screen where they shouldn't be.
;;  The game gets around this by clearing OAM when it does a screen wipe.  Sprites must be enabled
;;  because if both BG and sprite are disabled, the PPU is switched off and scroll is not updated
;;  as the screen is rendered -- which would completely distort scrolling for the wipe effect.
;;
;;
;;    This routine calls a lot of other routines before it syncs itself up for the timed loops.
;;  If you edit any of the following routines:
;;
;;  - ScreenWipeFrame_Prep
;;  - OnNMI
;;  - DrawMapPalette
;;  - SetOWScroll
;;  - SetSMScroll
;;
;;    then you could potentially mess up the timing for this routine, causing the wipe to occur
;;  offcenter.  If that happens, you can tweak the first '@InitialWait' loop in this routine
;;  to sort of resync it again.  You can also modify what the game writes to tmp+4 in routines
;;  which CALL to here in order to tweak the timing (tmp+4 would make big changes, @InitialWait would
;;  make minor changes)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScreenWipeFrame:
    CALL WaitForVBlank          ; wait for VBlank
    CALL ScreenWipeFrame_Prep     ; then do prepwork for this frame

    LDX #10                  ; This loop "fine-tunes" the wait.  It works out to 1+5*X cycles
    @InitialWait:            ;  so you can change the value X loads here to increase/decrease
      DEX                    ;  the wait.
      BNE @InitialWait       ; Ultimately, at the end of this loop, you should be about ~1156 cycles
    PAGECHECK @InitialWait   ;  into VBlank (a little under 11 scanlines until onscreen rendering starts)
                             ; If you edit routines SetOWScroll, SetSMScroll, or DrawMapPalette and
                             ;  it messes with the screen wipe effect, you can modify this loop
                             ;  to attempt to realign the timing.

    LDA #$10                 ; turn BG rendering off
    STA PPU_MASK
    LDX tmp+4                ; wait for tmp+4 scanlines
    @WaitLines_Off:
      CALL WaitScanline
      DEX
      BNE @WaitLines_Off
    PAGECHECK @WaitLines_Off

    LDA #$1E                 ; turn BG rendering on
    STA PPU_MASK
    LDX tmp+5                ; wait for tmp+5 scanlines
    @WaitLines_On:
      CALL WaitScanline
      DEX
      BNE @WaitLines_On
    PAGECHECK @WaitLines_On

    LDA #$10                 ; then turn BG rendering back off.  Leave it off for the rest of the frame
    STA PPU_MASK

    LDA tmp+5           ; check the number of visible scanlines
    AND #$0C            ; mask out bits 2,3
    BNE @Exit           ; if either are nonzero, exit
                        ; otherwise... modify the playing wipe sound effect
                        ;  updating the sound effect this way makes it effectively update only
                        ;  once every 4 frames.

     LDA tmp+5
     EOR #$FF           ; invert the number of visible scanlines (so that fewer scanlines visible
     ASL A              ;   = higher period = lower pitch)
     ROL tmp            ; then multiply by 8, rotating carry into tmp (high bits of tmp are unimportant
     ASL A              ;  as they only set the length counter).
     ROL tmp
     ASL A
     STA PAPU_FT1          ; then write that period to sq1's F value
     ROL tmp
     LDA tmp
     STA PAPU_CT1          ; output F value is -N * 8 where 'N' is the visible scanlines

  @Exit:
    RTS
