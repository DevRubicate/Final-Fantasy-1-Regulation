.segment "PRG_060"

.include "src/global-import.inc"

.import WaitForVBlank, DrawPalette, MusicPlay, SetBattlePPUAddr, Battle_WritePPUData

.export ResetRAM, SetRandomSeed, GetRandom, ClearOAM, ClearZeroPage, DisableAPU
.export FadeInBatSprPalettes, FadeOutBatSprPalettes, Dialogue_CoverSprites_VBl
.export PlaySFX_Error, UpdateJoy, PrepAttributePos, Battle_ReadPPUData, WriteAttributesToPPU
.export WaitVBlank_NoSprites, SetPPUAddrToDest_Bank, CoordToNTAddr_Bank




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
    STA $5C00, X
    STA $5D00, X
    STA $5E00, X
    STA $5F00, X
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  PlaySFX_Error   [$DB26 :: 0x3DB36]
;;
;;    Plays the error sound effect.  This sound effect isn't a simple sweep like
;;  most of the other menu sound effects... so it requires a few frames of attention.
;;  it's also hardcoded in this routine.  Because of the combination of these, this routine
;;  doesn't exit until the sound effect is complete... which is why the game will actually
;;  pause for a few frames while this sound effect is playing!
;;
;;    This sound effect is accomplished by rapidly playing the same tone 16 times (one each
;;  frame for 16 frames).  The tone is set to sweep upwards rapidly, so the sweep unit will ultimately
;;  silence the tone before the next is played.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlaySFX_Error:
    LDA #1           ; mark that square 2 will be used as a sound effect for 1 frame
    STA sq2_sfx      ;  though the MusicPlay routine is not called here, so it's actually longer.
                     ; this will not take effect until after this routine exits... so it's really
                     ; 1 frame after this routine exits

    LDA #$30
    STA PAPU_CTL1        ; silence square 1 (set volume to 0)
    STA PAPU_TCR1        ; attempt (and fail) to silence triangle (this just sets the linear reload.. but without
                     ;   a write to $400B, it will not take effect)
    STA PAPU_NCTL1        ; silence noise (set vol to 0)

    LDY #$0F         ; loop 16 times
  @Loop:
      CALL @Frame     ; do a frame
      DEY            ; dec Y
      BPL @Loop      ; and repeat until Y wraps

    LDA #$30         ; then silence sq2 (vol to zero)
    STA PAPU_CTL2
    LDA #$00
    STA PAPU_FT2        ; and reset sq2's freq to 0
    RTS              ; then exit

  @Frame:
    CALL WaitForVBlank    ; wait a frame

    LDA #%10001100    ;  50% duty, decay speed=%1100, no fixed volume, length enabled
    STA PAPU_CTL2
    LDA #%10001001    ;  sweep upwards in pitch, speed=0 (fast!), shift=1 (large steps!)
    STA PAPU_RAMP2

    LDA #$80
    STA PAPU_FT2         ; set initial freq to $080 (but it will sweep upwards in pitch quickly)
    LDA #$00          ; and length to $0A  (longer than 1 frame... so length might as well be disabled
    STA PAPU_CT2         ;   because this is written every frame)
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Update Joy  [$D7C2 :: 0x3D7D2]
;;
;;    Reads and processes joypad data, updating:
;;      joy
;;      joy_select
;;      joy_start
;;      joy_b
;;      joy_a
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateJoy:
    CALL ReadJoypadData
    CALL ProcessJoyButtons
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Read Joypad Data  [$D7C9 :: 0x3D7D9]
;;
;;    This strobes the joypad and reads joy data into our 'joy' variable
;;
;;  OUT:  X is 0 on exit
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReadJoypadData:
    LDA #1
    STA JOYPAD    ; strobe joypad (refreshes the latch with up to date joy data)
    LDA #0
    STA JOYPAD

    LDX #$08     ; loop 8 times (have to read each of the 8 buttons 1 at a time)
    @Loop:
      LDA JOYPAD  ; get the button state
      AND #$03   ;  button state gets put in bit 0 usually, but it's on bit 1 for the Famicom if
      CMP #$01   ;  the user is using the seperate controllers.  So doing this AND+CMP combo will set
                 ;  the C flag if either of those bits are set (making this routine FC friendly)
      ROL joy    ; rotate the C flag (the button state) into our RAM
      DEX
      BNE @Loop  ; loop until X expires (8 reads, once for each button)

    LDA joypadState
    EOR #0
    STA joypadStateIgnore

    LDA joy
    STA joypadState
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Process Joy Buttons  [$D7E2 :: 0x3D7F2]
;;
;;    This routine examines 'joy' and 'joy_ignore' to determine which buttons are being pressed
;;  joy_start, joy_select, joy_a, and joy_b are all incremented by 1 if their respective buttons
;;  have been pressed... but they are not incremented if a button is being held (ie:  the increment
;;  only happens when you press the button from a released state).
;;
;;    The realtime press/release state of all buttons remains unchanged in 'joy'
;;
;;    'joy_ignore' is altered, but only so it can be examined the next time this routine is called.
;;  Other routines do not use 'joy_ignore'
;;
;;  Note: X is assumed to be 0 on routine entry
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessJoyButtons:
    LDA joy         ; get joypad data
    AND #$03        ; check Left and Right button states
    BEQ :+          ; if either are pressed...
      LDX #$03      ;   X=$03, otherwise, X=$00
    :   
    STX tmp+1       ; back that value up

    LDA joy         ; get joy data again
    AND #$0C        ; this time, check Up and Down buttons
    BEQ :+
      TXA           ; if either are pressed, OR previous value with $0C
      ORA #$0C      ;  tmp+1 is now a mask indicating which directional buttons we want to keep
      STA tmp+1     ;  directional buttons not included in the mask will be discarded

    :   
    LDA joy         ; get joy data -- do some EOR magic
    EOR joy_ignore  ;  invert it with all the buttons to ignore.
    AND tmp+1       ;  mask out the directional buttons to keep
    EOR joy_ignore  ;  and re-invert, restoring ALL buttons *except* the directional we want to keep
    STA joy_ignore  ;  write back to ignore (so that these buttons will be ignored next time joy data is polled
    EOR joy         ; EOR again with current joy data.

   ; okay this requires a big explanation because it's insane.
   ; directional buttons (up/down/left/right) are treated seperately than other buttons (A/B/Select/Start)
   ;  The game creates a mask with those directional buttons so that the most recently pressed direction
   ;  is ignored, even after it's released.
   ;
   ; To illustrate this... imagine that joy buttons have 4 possible states:
   ;  lifted   (0 -> 0)
   ;  pressed  (0 -> 1)
   ;  held     (1 -> 1)
   ;  released (1 -> 0)
   ;
   ;   For directional buttons (U/D/L/R), the above code will produce the following results:
   ; lifted:   joy_ignore = 0      A = 0
   ; pressed:  joy_ignore = 1      A = 0
   ; held:     joy_ignore = 1      A = 0
   ; released: joy_ignore = 1      A = 0
   ;
   ;   For nondirectional buttons (A/B/Sel/Start), the above produces the following:
   ; lifted:   joy_ignore = 0      A = 0
   ; pressed:  joy_ignore = 0      A = 1
   ; held:     joy_ignore = 1      A = 0
   ; released: joy_ignore = 1      A = 1
   ;
   ;  Yes... it's very confusing.  But not a lot more I can do to explain it though  x_x
   ; Afterwards, A is the non-directioal buttons whose state has transitioned (either pressed or released)

    TAX            ; put transitioned buttons in X (temporary, to back them up)

    AND #$10        ; see if the Start button has transitioned
    BEQ @select     ;  if not... skip ahead to select button check
    LDA joy         ; get current joy
    AND #$10        ; see if start is being pressed (as opposed to released)
    BEQ :+          ;  if it is....
      INC joy_start ;   increment our joy_start var
    :   
    LDA joy_ignore  ; then, toggle the ignore bit so that it will be ignored next time (if being pressed)
    EOR #$10        ;  or will no longer be ignored (if being released)
    STA joy_ignore  ;  the reason for the ignore is because you don't want a button to be pressed
                    ;  a million times as you hold it (like rapid-fire)

    @select:
    TXA             ; restore the backed up transition byte
    AND #$20        ; and do all the same things... but with the select button
    BEQ @btn_b
    LDA joy
    AND #$20
    BEQ :+
      INC joy_select
    :   
    LDA joy_ignore
    EOR #$20
    STA joy_ignore

    @btn_b:
    TXA
    AND #$40
    BEQ @btn_a
    LDA joy
    AND #$40
    BEQ :+
      INC joy_b
    :   
    LDA joy_ignore
    EOR #$40
    STA joy_ignore


    @btn_a:
    TXA
    AND #$80
    BEQ @Exit
    LDA joy
    AND #$80
    BEQ :+
      INC joy_a
    :   
    LDA joy_ignore
    EOR #$80
    STA joy_ignore

    @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Row or Column Attribute Positions  [$D401 :: 0x3D411]
;;
;;    Calculates and preps the drawing positions and masks for attribute updates.
;;   This routine just fills the intermediate drawing buffer with information to draw later
;;
;;    Current row/column draw information is used... and OVERWRITTEN!, so either this must be
;;   the last thing you do when preparing things to draw, or row/column info must be restored after
;;   calling this.
;;
;;    This routine might seem more complicated than it is, unless you're familiar with how
;;   the attribute tables are layed out.
;;
;;    Attribute bytes are not prepared here -- they're prepared with map TSA data in other routines
;;
;;   OUT:  mapdraw_nty, mapdraw_ntx are overwritten and become garbage
;;
;;   TMP:  tmp through tmp+2 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepAttributePos:
    LDY #$00        ; zero Y -- our dest index

    @Loop:
    LDA mapdraw_nty ; get target NT row
    LDX #$0F        ; X=$0F (for odd rows -- bottom half of attribute block)
    LSR A           ; see if row is odd
    BCC :+
       LDX #$F0     ; X=$F0 (for even rows -- top half of attribute block)
    :   
    ASL A
    ASL A           ; A now = (target_NT_row AND $0E) * 8
    ASL A           ;    which is the row of attribute blocks to use
    STA tmp         ; put it in tmp (low byte of dest ppu address)
    STX tmp+1       ; put X (our high/low block mask) in tmp+1
    LDA mapdraw_ntx ; get target NT column
    LDX #$23        ; X=$23 (for left-hand attribute table)
    CMP #$10        ; see if column >= $10... if it is, we need the right-hand attribute table
    BCC :+
       AND #$0F     ;   need right-hand attribute, mask column to low 4 bits
       LDX #$27     ;   X=$27 to indicate right-hand attribute  (NT at $2400 instead of PPUCTRL)

    :   
    STX tmp+2       ; put the high byte of the dest ppu address in tmp+2
    LDX #$33        ; X=$33 (for even columns)
    LSR A           ; divide column by 2
    BCC :+          ; see if it was even or odd
       LDX #$CC     ;   X=$CC (for odd columns)
    :   
    ORA tmp         ; OR column/2 with low byte of dest address
    STA tmp         ;    (this is almost the final address for the desired attribute byte)
    TXA             ; Put X (our left/right block mask) in A
    AND tmp+1       ; Combine with our high/low block mask to get the final attribute mask
    STA tmp+1       ;  store final mask in tmp+1

    LDA tmp+2             ; put high byte of dest ppu address in drawing buffer
    STA draw_buf_at_hi, Y
    LDA tmp               ; get low byte of dest ppu address
    ORA #$C0              ;   or with #$C0 so that it's finalized (Attributes start at $23C0.. not $2300)
    STA draw_buf_at_lo, Y ;   and put it in drawing buf
    LDA tmp+1             ; and finally, copy the attribute mask
    STA draw_buf_at_msk, Y

    LDA mapflags
    AND #$02         ; check to see if we're doing a row or column
    BNE @IncByColumn ; if column.. inc by column

         ; otherwise... inc by row
       LDA mapdraw_ntx  ; get current column to draw
       CLC
       ADC #$01         ; increment it by 1 (so that we draw the next column in this row)
       AND #$1F
       STA mapdraw_ntx  ; write it back (overwriting row/column draw information!)
       INY              ; inc our dest counter
       CPY #$10         ; and loop until we've prepped all 16 columns
       BCS @Exit
       JUMP @Loop

    @IncByColumn:
       LDA mapdraw_nty  ; get current row to draw
       CLC
       ADC #$01         ; increment by 1
       CMP #$0F         ; but wrap $0E->$00 because there's only 15 rows of tiles per NT
       BCC :+
         SBC #$0F
    :
    STA mapdraw_nty  ; write it back (overwriting row/column draw information!)
       INY              ; inc our dest counter
       CPY #$0F         ; and loop until we've prepped all 15 rows in this column
       BCS @Exit
       JUMP @Loop
    @Exit: 
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_ReadPPUData  [$F268 :: 0x3F278]
;;
;;    Reads a given number of bytes from PPU memory.
;;
;;  input:
;;     btltmp+4,5 = pointer to write data to
;;     btltmp+6,7 = the PPU address to read from
;;     btltmp+8   = the number of bytes to read
;;
;;  This routine will swap back to the battle_bank prior to exiting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
Battle_ReadPPUData:
    CALL WaitForVBlank         ; Wait for VBlank
    CALL SetBattlePPUAddr        ; Set given PPU Address to read from
    LDA PPUDATA                   ; Throw away buffered byte
    LDY #$00
    LDX btltmp+8                ; btltmp+8 is number of bytes to read
    @Loop:
        LDA PPUDATA
        STA (btltmp+4), Y           ; write to (btltmp+4)
        INY
        DEX
        BNE @Loop
      
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  WriteAttributesToPPU [$A702 :: 0x2E712]
;;
;;  Reads the data from btltmp_attr
;;  Write to the attribute table in PPU memory
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WriteAttributesToPPU:
    LDA #<btltmp_attr       ; set source pointer
    STA btltmp+4
    LDA #>btltmp_attr
    STA btltmp+5
    
    LDA #<$23C0             ; set dest address
    STA btltmp+6
    LDA #>$23C0
    STA btltmp+7
    
    LDA #$40                ; copy 4 tiles
    STA btltmp+8
    
    FORCEDFARCALL Battle_WritePPUData   ; actually do the write, then exit
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  WaitVBlank_NoSprites  [$D89F :: 0x3D8AF]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitVBlank_NoSprites:
    CALL ClearOAM              ; clear OAM
    CALL WaitForVBlank       ; wait for VBlank
    LDA #>oam
    STA OAMDMA                 ; then do sprite DMA (hide all sprites)
    RTS                       ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddrToDest  [$DC80 :: 0x3DC90]
;;
;;    Sets the PPU address to have it start drawing at the coords
;;  given by dest_x, dest_y.  The difference between this and the below
;;  CoordToNTAddr routine is that this one actually sets the PPU address
;;  (whereas the below simply does the conversion without setting PPU
;;  address) -- AND this one works when dest_x is between 00-3F (both nametables)
;;  whereas CoordToNTAddr only works when dest_x is between 00-1F (one nametable)
;;
;;  IN:  dest_x, dest_y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddrToDest_Bank:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX dest_x         ; get dest_x in X
    LDY dest_y         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

 @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    STA PPUADDR                ; write it
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    STA PPUADDR                ; and write as low byte
    RTS

 @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    STA PPUADDR                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    STA PPUADDR                ;  for our low byte of PPU address
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Convert Coords to NT Addr   [$DCAB :: 0x3DCBB]
;;
;;   Converts a X,Y coord pair to a Nametable address
;;
;;   Y remains unchanged
;;
;;   IN:    dest_x
;;          dest_y
;;
;;   OUT:   ppu_dest, ppu_dest+1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CoordToNTAddr_Bank:
    LDX dest_y                ; put the Y coord (row) in X.  We'll use it to index the NT lut
    LDA dest_x                ; put X coord (col) in A
    AND #$1F                  ; wrap X coord
    ORA lut_NTRowStartLo, X   ; OR X coord with low byte of row start
    STA ppu_dest              ;  this is the low byte of the addres -- record it
    LDA lut_NTRowStartHi, X   ; fetch high byte based on row
    STA ppu_dest+1            ;  and record it
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$DCF4 :: 0x3DD04]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row
;;    Really, they just shortcut a multiplication by $20 ($20 tiles per row)
;;

lut_NTRowStartLo:
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0

lut_NTRowStartHi:
  .byte $20,$20,$20,$20,$20,$20,$20,$20
  .byte $21,$21,$21,$21,$21,$21,$21,$21
  .byte $22,$22,$22,$22,$22,$22,$22,$22
  .byte $23,$23,$23,$23,$23,$23,$23,$23
