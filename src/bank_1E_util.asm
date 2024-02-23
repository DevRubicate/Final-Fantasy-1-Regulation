.segment "BANK_1E"

.include "src/global-import.inc"

.import WaitForVBlank, DrawPalette, MusicPlay

.export ResetRAM, SetRandomSeed, GetRandom, ClearOAM, ClearZeroPage, DisableAPU
.export FadeInBatSprPalettes, FadeOutBatSprPalettes, Dialogue_CoverSprites_VBl





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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Disable APU  [$C469 :: 0x3C479]
;;
;;    Silences all channels and prevents them from being audible until they are
;;  re-enabled (requires another write to PAPU_EN).  Channels will become reenabled
;;  once the music engine starts a new track.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DisableAPU:
    LDA #$30
    STA PAPU_CTL1   ; set Squares and Noise volume to 0
    STA PAPU_CTL2   ;  clear triangle's linear counter (silencing it next clock)
    STA PAPU_TCR1
    STA PAPU_NCTL1
    LDA #$00
    STA PAPU_EN   ; disable all channels
    RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Dialogue_CoverSprites_VBl  [$FF02 :: 0x3FF12]
;;
;;     Edits OAM to hide sprites that are behind the dialogue box
;;  then waits for a VBlank
;;
;;  IN:  tmp+11 = Y coord cutoff point (sprites above this scanline will be hidden)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Dialogue_CoverSprites_VBl:
    LDX #4*4           ; start looking at sprites after the first 4 sprites (first 4 are the player, who is never covered)
  @Loop:
    LDA oam_y, X       ; get the sprite's Y coord
    CMP tmp+11         ; compare it to our cutoff scanline (result in C)
    LDA oam_a, X       ; then get the attribute byte for this sprite

    BCS @FGPrio        ; if spriteY >= cutoffY, sprite has foreground priority, otherwise, BG priority

   @BGPrio:
      ORA #$20         ; for BG prio, set the priority attribute bit in the attribute byte
      BNE @SetPrio     ; and jump ahead (always branches)
   @FGPrio:
      AND #~$20        ; for FG prio, clear priority bit

  @SetPrio:
    STA oam_a, X       ; record priority bit
    INX
    INX
    INX
    INX                ; then increment X by 4 to look at the next sprite

    BNE @Loop          ; keep looping until all sprites examined

    JUMP WaitForVBlank   ; then wait for VBlank, and exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Dim Battle Sprite Palettes [$FF20 :: 0x3FF30]
;;
;;    Dims the battle sprite palettes (first two sprite palettes)
;;  by 1 shade.
;;
;;  OUT:  C = set if some colors are still not black
;;            clear if all colors have been dimmed to black
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DimBatSprPalettes:
    LDY #0             ; Y will count how many colors are not yet black
    LDX #7             ; X will be our loop down counter and palette index

  @Loop:
    LDA cur_pal+$10, X ; get color in current palette
    CMP #$0F           ; check if it's black ($0F)
    BEQ @Skip          ; if it is... skip it

    SEC
    SBC #$10           ; otherwise, subtract $10 (dim it)
    BPL :+             ; if that caused it to dro below zero...
      LDA #$0F         ; ...replace it with black ($0F)
    :   
    STA cur_pal+$10, X       ; write the new color back to the palette
    INY                ; and increment Y to mark this color as not fully dimmed yet

  @Skip:
    DEX                ; decrement the loop counter
    BNE @Loop          ; and keep looping until it reaches 0 (only 7 iterations because color 0 is transparent)
    CPY #$01           ; set C if Y is nonzero (to indicate some colors are not yet black)
    RTS                ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Brighten Battle Sprite Palettes  [$FF40 :: 0x3FF50]
;;
;;    Opposite of above routine.  Brightens the battle sprite palettes
;;  by 1 shade.
;;
;;  OUT:  C = set if some colors are still not back to normal ('fully brightened')
;;            clear if all colors are back to normal.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BrightenBatSprPalettes:
    LDY #0              ; Y will count how many colors are not fully brightened
    LDX #$07            ; X will be loop down counter and palette index (7 iterations)
  @Loop:
    LDA cur_pal+$10, X  ; get the current color in the palette
    CMP tmp_pal, X      ; compare it to our backed up palette
    BEQ @Skip           ; if it matches.. color is already restored.  Skip it

    CMP #$0F            ; otherwise check to see if the color is black
    BNE @AddBright      ; if not black... just add to the color's brightness

    LDA tmp_pal, X      ; if black... get the desired color
    AND #$0F            ;  and mask out the low bits so we have the darkest shade of that color
    BPL @SetClr         ;  jump ahead (always branches)

  @AddBright:
    CLC
    ADC #$10            ; add one shade to the color's brightness

 @SetClr:
    STA cur_pal+$10, X  ; write this color back to the palette
    INY                 ; and increment Y to count this color as not fully brightened yet

 @Skip:
    DEX                 ; decrement X and loop until it expires
    BNE @Loop

    CPY #$01            ; then set C if Y is nonzero (to indicate not all colors are fully bright)
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Back Up Battle Sprite Palettes [$FF64 :: 0x3FF74]
;;
;;    Copies the battle sprite palettes to the temp palette
;;  so that they can be restored easily later
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BackUpBatSprPalettes:
    LDX #$07            ; X is our loop counter.  Going to back up 7 colors (color 0 is transparent)
  @Loop:
    LDA cur_pal+$10, X  ; copy the color...
    STA tmp_pal, X
    DEX                 ; decrement X
    BNE @Loop           ; loop until X expires
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Frame  [$FF70 :: 0x3FF80]
;;
;;    Updates the palette and does a frame.
;;  Frame is very minimal.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PaletteFrame:
    CALL WaitForVBlank        ; Wait for VBlank
    CALL DrawPalette          ; then update the palette
    LDA #0                   ; reset the scroll
    STA PPUSCROLL
    STA PPUSCROLL
    FARJUMP MusicPlay       ; update music engine, then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Fade Out Battle Sprite Palettes [$FF90 :: 0x3FFA0]
;;
;;    Fades out the battle sprite palettes until they're all fully black
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FadeOutBatSprPalettes:
    CALL BackUpBatSprPalettes    ; back up the unedited battle sprite palettes

  @Loop:
    CALL PaletteFrame            ; do a frame (updating palettes)
    INC framecounter            ; increment the frame counter
    LDA framecounter
    AND #$07                    ; check low 3 bits of frame counter
    BNE @Loop                   ; and loop until they're all clear (effectively waits 8 frames)

    CALL DimBatSprPalettes       ; every 8 frames... dim the palettes a bit
    BCS @Loop                   ; and jump back to the loop if there are any that aren't blackened yet

    RTS                         ; exit once palette is all black

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Fade In Battle Sprite Palettes [$FFA8 :: 0x3FFB8]
;;
;;    Opposite of above routine.  Fades in the battle sprites until
;;  they're back to their original colors.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FadeInBatSprPalettes:           ; Exactly the same as FadeOutBatSprPalettes... except...
    CALL PaletteFrame            ; no need to back up the palettes first
    INC framecounter
    LDA framecounter
    AND #$07
    BNE FadeInBatSprPalettes

    CALL BrightenBatSprPalettes  ; brighten them instead of dimming them.
    BCS FadeInBatSprPalettes

    RTS

