.segment "PRG_084"

.include "src/global-import.inc"

.import MenuCondStall, CoordToNTAddr
.import WaitVBlank_NoSprites, WaitForVBlank, MusicPlay, SetOWScroll_PPUOn, SetSMScroll

.export DrawBox, CyclePalettes, GetCharacterNamePtr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Draw Box  [$E063 :: 0x3E073]
;;
;;    Draws a box of given size, to given coords.  NT changes only, no attribute changes
;;   The box CANNOT cross an NT boundary (ie:  this routine isn't used for the dialog box
;;   which often does cross NT boundaries)
;;
;;   Y remains unchanged
;;
;;   IN:   menustall = Nonzero if the box is to be drawn 1 row per frame (stall between rows)
;;                      or zero if box is to be drawn immediately with no stalling
;;         box_x,y   = Desired Coords of box
;;         box_wd,ht = Desired width/height of box (must be at least 3x3 tiles)
;;         cur_bank  = Bank number to swap to (only used if stalling between rows)
;;
;;   OUT:  dest_x,y  = X,Y coords of inner box body (ie:  where you start drawing text or whatever)
;;
;;   TMP:  tmp+10 and tmp+11 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBox:
    LDA box_x         ; copy given coords to output coords
    STA dest_x
    LDA box_y
    STA dest_y
    CALL CoordToNTAddr ; convert those coords to an NT address (placed in ppu_dest)
    LDA box_wd        ; Get width of box
    SEC
    SBC #$02          ; subtract 2 to get width of "innards" (minus left and right borders)
    STA tmp+10        ;  put this new width in temp ram
    LDA box_ht        ; Do same with box height
    SEC
    SBC #$02
    STA tmp+11        ;  put new height in temp ram

    CALL DrawBoxRow_Top    ; Draw the top row of the box
    @Loop:                    ; Loop to draw all inner rows
      CALL DrawBoxRow_Mid  ;   draw inner row
      DEC tmp+11          ;   decrement our adjusted height
      BNE @Loop           ;   loop until expires
    CALL DrawBoxRow_Bot    ; Draw bottom row

    LDA soft2000          ; reset some PPU info
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL             ; and scroll information
    STA PPUSCROLL

    LDA dest_x        ; get dest X coord
    CLC
    ADC #$01          ; and increment it by 1  (an INC instruction would be more effective...)
    STA dest_x
    LDA dest_y        ; get dest Y coord
    CLC
    ADC #$02          ; and inc by 2
    STA dest_y        ;  dest_x and dest_y are now our output coords (where the game would want to start drawing text
                      ;  to be placed in this box

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw middle row of a box (used by DrawBox)   [$E0A5 :: 0x3E0B5]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBoxRow_Mid:
    FARCALL MenuCondStall  ; do the conditional stall
    LDA PPUSTATUS          ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR          ; Load up desired PPU address
    LDA ppu_dest
    STA PPUADDR
    LDX tmp+10         ; Load adjusted width into X (for loop counter)
    LDA #$FA           ; FA = L border tile
    STA PPUDATA          ;   draw left border

    LDA #$FF           ; FF = inner box body tile
    @Loop:
      STA PPUDATA        ;  draw box body tile
      DEX              ;    until X expires
      BNE @Loop

    LDA #$FB           ; FB = R border tile
    STA PPUDATA          ;  draw right border

    LDA ppu_dest       ; Add #$20 to PPU address so that it points to the next row
    CLC
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0             ; Add 0 to catch carry
    STA ppu_dest+1

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw bottom row of a box (used by DrawBox)   [$E0D7 :: 0x3E0E7]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   ppu_dest is not adjusted for output like it is for other box row drawing routines
;;   since this is the bottom row, no rows will have to be drawn after this one, so it'd
;;   be pointless
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBoxRow_Bot:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; Reset PPU Toggle
    LDA ppu_dest+1      ;  and load up PPU Address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; put adjusted width in X (for loop counter)
    LDA #$FC            ;  FC = DL border tile
    STA PPUDATA

    LDA #$FD            ;  FD = bottom border tile
    @Loop:
      STA PPUDATA         ;  Draw it
      DEX               ;   until X expires
      BNE @Loop

    LDA #$FE            ;  FE = DR border tile
    STA PPUDATA

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw top row of a box (used by DrawBox)   [$E0FC :: 0x3E10C]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBoxRow_Top:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR           ; set PPU Address appropriately
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; load the adjusted width into X (our loop counter)
    LDA #$F7            ; F7 = UL border tile
    STA PPUDATA           ;   draw UL border

    LDA #$F8            ; F8 = U border tile
    @Loop:
      STA PPUDATA         ;   draw U border
      DEX               ;     until X expires
      BNE @Loop

    LDA #$F9            ; F9 = UR border tile
    STA PPUDATA           ;   draw it

    LDA ppu_dest        ; Add #$20 to our input PPU address so that it
    CLC                 ;  points to the next row
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0              ; Add 0 to catch the carry
    STA ppu_dest+1

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Cycle Palettes   [$D946 :: 0x3D956]
;;
;;    Does that fugly palette cycling that acts as a transition into certain
;;  areas.  Like when you enter the main menu, or enter a shop, etc.
;;
;;    The cycling is very simple.  +1 is added to each non-black color until it reaches
;;  $xD (at which point it is replaced with $0F black).  Once all colors reach $0F, the
;;  cycling is complete.
;;
;;    This process can also be done in reverse.  When in reverse, all colors that were
;;  originally non-black start at $xC (where 'x' is their original brightness).  And -1 is done
;;  until they reach their original color.
;;
;;    Note that since the reversed process starts the colors at $xC -- this means that the
;;  reverse cycling will take EXTREMELY long if the palette contains any $xD, $xE, or $xF color
;;  other than $0F.... because the palette will have to cycle through *256* colors to reach
;;  the target color.  This is not a problem in the original game because it doesn't use any
;;  of those colors (they're mostly black, except for some $xD colors -- and $0D is notorious
;;  for screwing up the display on some television sets -- so they should all be avoided anyway).
;;  This could be a problem in some hacks, though... if they changed a palette to use one of
;;  those colors.
;;
;;  IN:  A = desired mode
;;
;;    Each of the 3 low bits in the desired mode indicates something:
;;
;;  bit 0 ($01) = set if cycling is to be done in reverse.  Clear if to be done normally
;;  bit 1 ($02) = set if in standard map.  Clear if not (overworld, or menu, or whatever)
;;  bit 2 ($04) = set if scroll is to be held at zero (for menus or whatever)
;;
;;    This value is dumped into 'palcyc_mode' and referred throughout this routine and
;;  supporting routines.  It determines which palette to use, what scroll to reset to,
;;  etc.
;;
;;    This routine will not exit until the cycling is complete.  Also, once it completes,
;;  it swaps in the menu bank, and turns off the PPU (unless it was reverse -- in which case
;;  the PPU stays on).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CyclePalettes:
    STA palcyc_mode             ; record the mode
    FARCALL WaitVBlank_NoSprites   ; wait for VBlank, and kill all sprites
    CALL PalCyc_SetScroll       ; set the scroll
    CALL PalCyc_GetInitialPal   ; load up the initial palette
    LDA #$01                    ; A will be a make-shift frame counter
    @Loop:
        PHA                         ; push the frame counter to back it up
        AND #$03                    ; mask low bits, and only take a step through the cycle
        BNE @NoStep                 ;   if zero (once every 4 frames)
            CALL PalCyc_Step        ; if a 4th frame, take a step through the cycle
            CPY #0                  ; check to see if Y is zero (cycling is complete)
            BEQ @Done               ; if cycling is complete, break out of this loop
        @NoStep:
        CALL WaitForVBlank          ; wait for VBlank
        CALL PalCyc_DrawPalette     ; draw the new palette
        CALL PalCyc_SetScroll       ; set the scroll
        FARCALL MusicPlay           ; and update music  (all the typical frame work)
        PLA                         ; pull the frame counter
        CLC
        ADC #1                      ; and add 1 to it
        JUMP @Loop                  ; and keep looping until cycling is complete
    @Done:
    PLA                         ; pull the frame counter just so it doesn't corrupt the stack (we're done with it)
    LDA palcyc_mode             ; get mode
    LSR A                       ; check 'reverse' bit
    BCS :+                      ; if NOT doing reverse....
        LDA #0                  ; ... then turn PPU off
        STA PPUMASK
    :   
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Set Scroll   [$D982 :: 0x3D992]
;;
;;    Sets the scroll appropriately, and also disables sprite rendering
;;
;;  IN:  palcyc_mode = indicates how to set the scroll:
;;
;;     bit 2 set ($04) = zero scroll
;;     bit 1 set ($02) = standard map scroll
;;     otherwise       = overworld scroll
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_SetScroll:
    LDA palcyc_mode      ; get desired scroll setup
    AND #$04             ; check bit 2
    BEQ @Not4            ; if bit 2 clear, jump ahead

  @Do_Zero:              ; otherwise, do zero scroll
    LDA soft2000
    STA PPUCTRL            ; set NT bits

    LDA #$0A
    STA PPUMASK            ; disable sprite rendering

    LDA #$00
    STA PPUSCROLL
    STA PPUSCROLL            ; zero scroll

    RTS                  ; exit

  @Not4:                 ; if bit 2 wasn't set... check bit 1
    LDA palcyc_mode
    AND #$02
    BNE @Do_SM           ; and branch appropriately

  @Do_OW:
    FARCALL SetOWScroll_PPUOn  ; set overworld scroll
    LDA #$0A
    STA PPUMASK              ; disable sprites
    RTS                    ; exit

  @Do_SM:
    CALL SetSMScroll      ; set standard map scroll
    LDA #$0A
    STA PPUMASK            ; disable sprites
    RTS                  ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Get Initial Palette  [$D9B3 :: 0x3D9C3]
;;
;;    Loads up pal_tmp with the initial palette to start cycling
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_GetInitialPal:
    LDX #0              ; start X (our loop counter) at zero
    LDA palcyc_mode     ; get the mode
    LSR A               ; shift 'reverse' bit into C
    BCC @CopyPal        ; if reverse bit is clear (cycling out), just copy the current palette and exit

      CALL @CopyPal      ; otherwise (reverse), copy the palettes, but then do more work...
      DEX               ; X=$0F after this DEX (CopyPal sets it to $10)
                        ;  we're going to use it as a loop down counter, from $0F through $00.

    ; if this is 'reversed' (cycling out), then we don't want the palettes to start at
    ; their normal values (otherwise the cycling will be over immediately), so we mess
    ; the colors up here

  @ScrambleLoop:
    LDA tmp_pal, X      ; get the color
    CMP #$0F            ; if it's black ($0F)
    BEQ @Skip           ;  skip it (don't change black)

    AND #$30            ; otherwise... isolate brightness bits
    ORA #$0C            ; and OR with color $0C (blue-green -- highest "legal" color other than black)
    STA tmp_pal, X      ; then write it back
  @Skip:
    DEX                 ; decrement our loop counter
    BPL @ScrambleLoop   ; and loop until it wraps ($10 iterations)

    RTS                 ; then exit!



  @CopyPal:
    LSR A               ; shift 'standard map' bit into C
    BCC @OutRoomLoop    ; if clear, we're not in a standard map... so do the 'outroom' palette
    LDA inroom          ; otherwise... check to see if we're inroom
    BEQ @OutRoomLoop    ; if we're not (inroom=0), then do outroom palette
                        ; otherwise do inroom:

    @InRoomLoop:
      LDA inroom_pal, X ; copy inroom palette to temp palette
      STA tmp_pal, X
      INX
      CPX #$10
      BCC @InRoomLoop   ; loop until X=$10 ($10 iterations)
    RTS                 ; then exit

    @OutRoomLoop:
      LDA cur_pal, X    ; copy outroom (cur_pal) to temp pal
      STA tmp_pal, X
      INX
      CPX #$10
      BCC @OutRoomLoop  ; loop until X=$10 ($10 iterations)
    RTS                 ; then exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Step   [$D9EF :: 0x3D9FF]
;;
;;   Takes the colors in the palette one 'step' through the cycle
;;
;;  OUT:  Y = the number of colors that aren't done cycling yet
;;                (zero = cycling is complete)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_Step:
    LDY #0            ; Y is our counter for colors that aren't done.
    LDX #0            ; X is our loop counter / index

    LDA palcyc_mode   ; get the mode
    LSR A             ; put 'reverse' bit in C
    BCS @Reverse      ; if it's set, do the 'reversed' cycling

  @NormalLoop:
    LDA tmp_pal, X    ; get this color
    CMP #$0F          ; check to see if it's black
    BEQ @NormalSkip   ; if it is, it's done cycling (stop at black), so skip it

    AND #$30          ; otherwise, get the brightness bits
    STA tmp           ; and back them up

    LDA tmp_pal, X    ; get the color again
    AND #$0F          ; and get the chroma bits
    CLC
    ADC #$01          ; add 1 to the chroma (cycle through the palette)
    CMP #$0D          ; see if chroma is >= $D  (result is put in C flag)

    ORA tmp           ; restore brightness bits

    BCC :+            ; then check C flag.  If chroma >= $0D....
      LDA #$0F        ; ... replace color with normal black $0F  ($xD, xE, and xF  all get changed to $0F)
    :   
    STA tmp_pal, X      ; write cycled color back
    INY               ; INY to count this color as 'not done yet'

  @NormalSkip:
    INX               ; increment the loop counter
    CPX #$10
    BNE @NormalLoop   ; and loop until X=$10
    RTS               ; then exit

    @Reverse:
    LSR A             ; shift 'standard map' mode bit into C
    BCC @OutroomLoop  ; if clear (not on standard map), do outroom cycling
    LDA inroom        ; otherwise... check inroom status
    BEQ @OutroomLoop  ; if clear, do outroom.  Otherwise, do inroom

  @InroomLoop:
    LDA tmp_pal, X     ; get this color
    CMP inroom_pal, X  ; compare to target color
    BEQ @InroomSkip    ; if equal, color is done

    SEC
    SBC #$01           ; otherwise, subtract 1 (from chroma)
    STA tmp_pal, X     ; and write back
    INY                ; then INY to count color as 'not done'

  @InroomSkip:
    INX                ; increment the loop counter
    CPX #$10
    BCC @InroomLoop    ; and keep looping until X=$10
    RTS                ; then exit


  @OutroomLoop:
    LDA tmp_pal, X     ; get this color
    CMP cur_pal, X     ; compare it to target color
    BEQ @OutroomSkip   ; if they're equal... this color is done

    SEC
    SBC #$01           ; otherwise, subtract 1 (from the chroma)
    STA tmp_pal, X     ; and write back to palette
    INY                ; INY to count the color as 'not done yet'

  @OutroomSkip:
    INX                ; increment the loop counter
    CPX #$10
    BCC @OutroomLoop   ; and keep looping until X=$10
    RTS                ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Draw Palette [$D918 :: 0x3D928]
;;
;;    Draws the temporary palette (tmp_pal).  BG colors only -- no sprite colors drawn.
;;  For use in palette cycling.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_DrawPalette:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX #0             ; X will be our loop counter.  Zero it

    LDA #$3F           ; set PPU addr to $3F00 (palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR

  @Loop:
      LDA tmp_pal, X   ; get color from tmp_pal
      STA PPUDATA        ; draw it
      INX
      CPX #$10         ; and keep looping ($10 iterations)
      BCC @Loop

    LDA PPUSTATUS          ; reset PPU toggle

    LDA #$3F           ; move PPU addr off of palettes
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    STA PPUADDR
    STA PPUADDR

    RTS                ; and exit

GetCharacterNamePtr:
    ; otherwise, it's a player
    AND #$03                    ; mask out the low bits to get the player ID
    ASL A                       ; @2 for pointer table
    TAX
    LDA lut_CharacterNamePtr, X ; run it though a lut to get the pointer to the player's name
    STA btldraw_subsrc
    INX
    LDA lut_CharacterNamePtr, X
    STA btldraw_subsrc+1
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut to get a character's name by their index  [$FCAA :: 0x3FCBA]

lut_CharacterNamePtr:
  .WORD ch_name
  .WORD ch_name+$40
  .WORD ch_name+$80
  .WORD ch_name+$C0

