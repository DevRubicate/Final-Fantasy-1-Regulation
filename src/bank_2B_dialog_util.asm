.segment "BANK_2B"

.include "src/global-import.inc"

.import PrepRowCol, WaitForVBlank, DrawMapRowCol, SetSMScroll, MusicPlay, PrepAttributePos, PrepDialogueBoxAttr, DrawMapAttributes
.import DrawDialogueString, UpdateJoy, DialogueBox_Sfx, CoordToNTAddr, WaitScanline, Dialogue_CoverSprites_VBl

.export DrawDialogueBox, PrepDialogueBoxRow, ShowDialogueBox, EraseBox, DialogueBox_Frame


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Show Dialogue Box [$D602 :: 0x3D612]
;;
;;    This makes the dialogue box and contained text visible (but doesn't draw it to NT,
;;  that must've already been done -- see DrawDialogueBox).  Once the box is fully visible,
;;  it plays any special TC sound effect or fanfare music associated with the box and waits
;;  for player input to close the box -- and returns once the box is no longer visible.
;;
;;  IN:  dlgsfx = 0 if no special sound effect needed.  1 if special fanfare, else do treasure chest ditty.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShowDialogueBox:
    LDA #3
    STA tmp+2              ; reset the 3-step counter for WaitScanline

    LDA #53
    STA sq2_sfx            ; indicate sq2 is going to be playing a sound effect for the next 53 frames
    LDA #$8E
    FARCALL DialogueBox_Sfx    ; and play the "upward sweep" sound effect that plays when the dialogue box opened.

    LDA soft2000           ; get the onscreen NT
    EOR #$01               ; toggle the NT bit to make it the offscreen NT (where the dialogue box is drawn)
    STA tmp+10             ; store "offscreen" NT in tmp+10

    LDA #$08               ; start the visibility scanline at 8(+8).  This means the first scanline of the box
    STA tmp+11             ;  that's visible will be on scanline 16 -- which is the start of where the box is drawn

     ; open the dialogue box

   @OpenLoop:
      CALL DialogueBox_Frame; do a frame

      LDA tmp+11
      CLC
      ADC #2
      STA tmp+11           ; increment the visible scanlines by 2 (box grows 2 pixels/frame)

      CMP #$60             ; see if visiblity lines >= $60 (bottom row of dialogue box)
      BCC @OpenLoop        ; keep looping until the entire box is visible


    LDA dlgsfx             ; see if a sound effect needs to be played
    BEQ @WaitForButton_1   ; if not (dlgsfx = 0), skip ahead
    LDX #$54               ; Use music track $54 for sfx (special fanfare music)
    CMP #1
    BEQ :+                 ; if dlgsfx > 1...
      LDX #$58             ;  ... then use track $58 instead (treasure chest ditty)
    :   
    STX music_track        ; write the desired track to the music_track to get it started

    ; there are two seperate 'WaitForButton' loops because the dialogue box closes when the
    ; user presses A, or when they press any directional button.  The first loop waits
    ; for all directional buttons to be lifted, and the second loop waits for a directional
    ; button to be pressed.  Both loops exit the dialogue box when A is pressed.  Having
    ; the first loop wait for directions to be lifted prevents the box from closing immediately
    ; if you have a direction held.

    @WaitForButton_1:           ;  The loop that waits for the direction to lift
    CALL DialogueBox_Frame   ; Do a frame
    FARCALL UpdateJoy           ; update joypad data
    LDA joy_a               ; check A button
    BNE @ExitDialogue       ; and exit if A pressed

    LDA music_track         ; otherwise, check the music track
    CMP #$81                ; see if it's set to $81 (special sound effect is done playing)
    BNE :+                  ; if not, skip ahead (either no sound effect, or sound effect is still playing)
        LDA dlgmusic_backup      ; if sound effect is done, get the backup track
        STA music_track          ; and restart it
        LDA #0
        STA dlgsfx               ; then clear the dlgsfx flag
    :   
    LDA joy                 ; check directional buttons
    AND #$0F
    BNE @WaitForButton_1    ; and continue first loop until they're all lifted

    @WaitForButton_2:           ;  The loop that waits for a direciton to press
    CALL DialogueBox_Frame   ; exactly the same as above loop
    FARCALL UpdateJoy
    LDA joy_a
    BNE @ExitDialogue

    LDA music_track
    CMP #$81
    BNE :+
        LDA dlgmusic_backup
        STA music_track
        LDA #0
        STA dlgsfx
    :   
    LDA joy
    AND #$0F
    BEQ @WaitForButton_2    ; except here, we loop until a direction is pressed (BEQ instead of BNE)

    @ExitDialogue:
    LDA dlgsfx              ; see if a sfx is still playing
    BEQ @StartClosing       ; if not, start closing the dialogue box immediately

    @WaitForSfx:              ; otherwise (sfx is still playing
    LDA music_track         ;   we need to wait for it to end.  check the music track
    CMP #$81                ; and see if it's $81 (sfx over)
    BEQ @SfxIsDone          ; if it is, break out of this loop
        CALL DialogueBox_Frame   ; otherwise, keep doing frames
        JUMP @WaitForSfx         ; and loop until the sfx is done

    @SfxIsDone:
    LDA dlgmusic_backup     ; once the sfx is done restore the music track to the backup value
    STA music_track
    LDA #0
    STA dlgsfx              ; and clear sfx flag

    @StartClosing:
    LDA #37
    STA sq2_sfx            ; indicate that sq2 is to be playing a sfx for the next 37 frames
    LDA #$95
    FARCALL DialogueBox_Sfx    ; and start the downward sweep sound effect you hear when you close the dialogue box

    @CloseLoop:
    CALL DialogueBox_Frame; do a frame

    LDA tmp+11        ; subtract 3 from the dialogue visibility scanline (move it 3 lines up
    SEC               ;    retracting box visibility)
    SBC #3
    STA tmp+11        ; box closes 3 pixels/frame.

    CMP #$12          ; and keep looping until line is below $12
    BCS @CloseLoop

    RTS          ; then the dialogue box is done!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Dialogue Box  [$D4B1 :: 0x3D4C1]
;;
;;    Draws the dialogue box on the "offscreen" NT.  Since the PPU is on during this time, all drawing
;;  must be done in VBlank and thus takes several frames.
;;
;;  IN:  A = ID of dialogue text to draw.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawDialogueBox:
    PHA               ; push the dialogue text ID to the stack for later use (much later)

    LDA #6+1          ; we will be drawing rows from the bottom up...
    STA dlgbox_row    ;  so set dlgbox_row to indicate 1+ the bottom row (row 6) needs drawing

    LDA sm_scroll_y   ; get our map scroll
    CLC
    ADC #6+1          ; add to get 1+ the bottom row on which the dialogue box will be drawn
    AND #$3F          ; wrap to keep it in bounds of the map
    STA mapdraw_y     ; and record that to our draw_y -- this is the first map row we'll be reloading

    LDA scroll_y      ; get screen scroll y
    CLC
    ADC #6+1          ; move to the 1+ bottom row of the dialogue box
    CMP #$0F
    BCC :+
        SBC #$0F        ;   wrap $E->$0
    :   
    STA mapdraw_nty   ; store this as the target NT row on which we'll be drawing
                      ;  in addition to being to row which we're drawing... this is also the loop
                      ;  down counter for the upcoming loop

    LDA #$01          ; set mapflags to indicate we're drawing rows of tiles (don't want to draw columns)
    STA mapflags      ;   and that we're on a standard map

    ;;  Now that our vars are set up, this loop will draw each row

    @RowLoop:
    LDA mapdraw_y      ; predecrement the row of the map we are to draw
    SEC
    SBC #1
    AND #$3F           ;    mask to keep inside the map boundaries
    STA mapdraw_y

    LDA mapdraw_nty    ; and predecrement the destination NT address
    SEC
    SBC #1
    BCS :+
        ADC #$0F         ;    wrap 0->$E
    :   
    STA mapdraw_nty

    LDA sm_scroll_x    ; get the X scroll
    STA mapdraw_x      ; record that as our map column to start drawing from
    AND #$1F           ; then isolate the low 5 bits (where on which NT we're to draw it)
    EOR #$10           ; toggle the NT bit so it draws "offscreen"
    STA mapdraw_ntx    ; and that is our target NT address

    CALL PrepRowCol             ; prep map row/column graphics
    CALL PrepDialogueBoxRow     ; prep dialogue box graphics on top of that
    CALL WaitForVBlank        ; then wait for VBl
    CALL DrawMapRowCol          ; and draw what we just prepped
    CALL SetSMScroll            ; then set the scroll (so the next frame is drawn correctly)
    FARCALL MusicPlay                ; and update the music
    FARCALL PrepAttributePos       ; then prep attribute position data
    LDA mapdraw_nty            ; get dest NT address
    CMP scroll_y               ; compare it to the screen scroll
    BEQ :+                     ; if they're the same (drawing the top/last row)
        CALL PrepDialogueBoxAttr  ; ... then skip over dialogue box attribute prepping (dialogue box isn't visible top row)
    :   
    CALL WaitForVBlank        ; then wait for VBl again
    FARCALL DrawMapAttributes      ; and draw the attributes for this row
    CALL SetSMScroll            ; then set the scroll to keep rendering looking good
    FARCALL MusicPlay   ; and keep the music playing

    LDA mapdraw_nty            ; do the same check as above (see if this is the top/last row)
    CMP scroll_y
    BNE @RowLoop               ; if it isn't, keep looping.  Otherwise the Dialogue box is fully drawn!

    ;; now that the box is drawn, we need to draw the containing text
    ;;   coords at which the text is to be draw are stored in box_x, box_y -- don't let
    ;;   the var name trick you.

    LDA sm_scroll_x     ; get the X scroll of the map
    CLC                 ; then add $10+2 to it.  $10 to put the text on the "offscreen" NT
    ADC #$10+2          ;   and 2 to put it two map tiles (32 pixels) into that screen.
    AND #$1F            ; mask with $1F to wrap around both NTs properly
    ASL A               ; then double it, to convert from 16x16 tiles to 8x8 tiles
    STA box_x           ; this is our target X coord for the text

    LDA scroll_y        ; get the screen scroll for Y
    ASL A               ; double it to convert from 16x16 map tiles to 8x8 PPU tiles
    CLC
    ADC #4              ; add 4 to move it 32 pixels down from the top of the NT
    CMP #30             ; but wrap 29->0  (NTs are only 30 tiles tall)
    BCC :+
        SBC #30
    :   
    STA box_y           ; this is our target Y coord for the text

    LDA #$80            ; enable menu stalling (kind of pointless because the upcoming routine
    STA menustall       ;  doesn't check it

    PLA                      ; then pull the dialogue text ID that was pushed at the start of the routine
    FARJUMP DrawDialogueString   ; draw it, then exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Dialogue Box Row  [$D549 :: 0x3D559]
;;
;;    Prepares a row of 16x16 tiles to be drawn for the desired row of the dialogue
;;  box.  Note that the map row must've been prepped before this -- as the dialogue
;;  box is simply written over it.  Some map graphics are still visible underneath
;;  the dialogue box (dialogue box doesn't write over every graphic in the row)
;;
;;  IN:  dlgbox_row = the row of the dialogue box to draw (1-7)
;;
;;  OUT: dlgbox_row = decremented by 1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepDialogueBoxRow:
    DEC dlgbox_row     ; decrement the row (drawing bottom up)
    BEQ @Exit          ; if this is the very top row, draw nothing -- since the map is visible
                       ;  for the top 16 pixels of the screen

    LDA dlgbox_row
    CMP #6             ; Otherwise, see if this is the bottom row
    BEQ @BottomRow     ;   if it is, prepare it specially

    CMP #1
    BEQ @TopRow        ; same with the top row of the dialogue box (2nd row of 16x16 tiles)

                 ; otherwise, just draw a normal "inner" row

  @InnerRows:
    LDA #$FA           ; use tile $FA for the leftmost tile in the row (left box graphic)
    STA tmp
    LDA #$FF           ; tile $FF for all other tiles in the row (inner box graphic / empty space)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep UL tiles

    LDA #$FB           ; $FB as rightmost tile in row (right box graphic)
    STA tmp
    CALL DlgBoxPrep_UR  ;  prep UR tiles

    CALL DlgBoxPrep_DL  ; then prep the fixed DL/DR tiles
    JUMP DlgBoxPrep_DR  ;   and exit

  @TopRow:
    LDA #$F7           ; use tile $F7 for the leftmost tile in the row (UL box graphic)
    STA tmp
    LDA #$F8           ; use tile $F8 for every other tile in the row (top box graphic)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep the UL tiles

    LDA #$F9           ; use tile $F9 for the rightmost tile in the row (UR box graphic)
    STA tmp
    CALL DlgBoxPrep_UR  ;  prep the UR tiles

    CALL DlgBoxPrep_DL  ; then prep the fixed DL/DR tiles
    JUMP DlgBoxPrep_DR  ;   and exit

  @BottomRow:
    LDA #$FC           ; use tile $FC for the leftmost tile in the row (DL box graphic)
    STA tmp
    LDA #$FD           ; use tile $FD for every other tile in the row (bottom box graphic)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep the UL tiles

    LDA #$FE           ; use tile $FE for the rightmost tile in the row (DR box graphic)
    STA tmp
    JUMP DlgBoxPrep_UR  ;  prep the UR tiles and exit

                 ; notice that for the bottom row, the border graphics are drawn on the
                 ; top half of the tile, and that the bottom half of the tile is not changed.

  @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Dialogue Box Prep Support Routines  [$D59A :: 0x3D5AA]
;;
;;    These routines fill each portion of the TSA draw buffer for the dialogue
;;  box.  UL and UR are configurable and take tmp and tmp+1 as parameters, but
;;  DL and DR are fixed and will draw the same tiles every time.
;;
;;    Each routine fills draw_buf_xx+1 to draw_buf_xx+$E.  +0 and +$F are not
;;  changed because the map is to remain visible in the left and right 16-pixels
;;  of the screen.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;
 ;;  UL  [$D59A ::0x3D5AA]
 ;;   tmp   = tile for leftmost tile
 ;;   tmp+1 = tile for all other tiles
 ;;

DlgBoxPrep_UL:
    LDA tmp               ; get the desired leftmost tile
    STA draw_buf_ul+1     ; record it

    LDX #$02
    LDA tmp+1             ; then get the main tile
   @Loop:
      STA draw_buf_ul, X  ; and record it for +2 to +$E
      INX
      CPX #$0F
      BCC @Loop           ; stop when X gets to $F (don't want to change $F)
    RTS                   ; and exit

 ;;
 ;;  UR  [$D5AC ::0x3D5BC]
 ;;   tmp   = tile for all other tiles
 ;;   tmp+1 = tile for rightmost tile
 ;;

DlgBoxPrep_UR:
    LDA tmp+1             ; get main tile
    LDX #$01
   @Loop:
      STA draw_buf_ur, X  ; and write it to +1 to +$D
      INX
      CPX #$0E
      BCC @Loop

    LDA tmp               ; then copy the right-most tile to +$E
    STA draw_buf_ur+$E
    RTS

 ;;
 ;;  DL  [$D5BE :: 0x3D5CE]
 ;;

DlgBoxPrep_DL:
    LDA #$FA              ; load hardcoded tile $FA (box left border graphic)
    STA draw_buf_dl+1     ; to leftmost tile

    LDX #$02
    LDA #$FF              ; then hardcoded tile $FF (blank space / box inner graphic)
   @Loop:
      STA draw_buf_dl, X  ;   to the rest of the row
      INX
      CPX #$0F
      BCC @Loop
    RTS

 ;;
 ;;  DR  [$D5D0 :: 0x3D5E0]
 ;;

DlgBoxPrep_DR:
    LDA #$FF              ; load hardcoded tile $FF (blank space / box inner graphic)
    LDX #$01
   @Loop:
      STA draw_buf_dr, X  ;   to all tiles in row except the rightmost
      INX
      CPX #$0E
      BCC @Loop

    LDA #$FB              ; load hardcoded tile $FB (box right border graphic)
    STA draw_buf_dr+$E    ; to rightmost tile
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Erase Box  [$E146 :: 0x3E156]
;;
;;     Same idea as DrawBox -- only instead of drawing a box, it erases one.
;;   erases bottom row first, and works it's way up.
;;
;;  IN:  box_x, box_y, box_wd, box_ht, menustall
;;  TMP: tmp+11 used
;;
;;   cur_bank must also be set appropriately, as this routine can FARCALL MusicPlay
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBox:
    LDA box_x          ; copy box X coord to dest_x
    STA dest_x
    LDA box_y          ; get box Y coord
    CLC
    ADC box_ht         ;  add the box height, and then subtract 1
    SEC
    SBC #$01           ;  and write that to dest_y
    STA dest_y         ;  this puts dest_y to the last row
    CALL CoordToNTAddr  ; fill ppu_dest appropriately
    LDA box_ht         ; get the box height
    STA tmp+11         ; and put it in temp RAM (will be down counter for loop)

    @RowLoop:
    LDA menustall      ; see if we need to stall the menu (draw one row per frame)
    BEQ @NoStall       ; if not, skip over this stalling code

    LDA soft2000         ; reset scroll
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL
    STA PPUSCROLL
    FARCALL MusicPlay    ; call music play routine
    CALL WaitForVBlank  ; and wait for vblank

    @NoStall:
    LDA PPUSTATUS          ; reset PPU toggle
    LDA ppu_dest+1     ; set the desired PPU address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX box_wd         ; get box width in X (downcounter for upcoming loop)
    LDA #0             ; zero A
    @ColLoop:
    STA PPUDATA        ; draw tile 0 (blank tile)
    DEX              ; decrement X
    BNE @ColLoop     ; loop until X expires (box_wd iterations)

    LDA ppu_dest        ; subtract $20 from the PPU address (move it one row up)
    SEC
    SBC #$20
    STA ppu_dest

    LDA ppu_dest+1      ; catch borrow
    SBC #0
    STA ppu_dest+1

    DEC tmp+11          ; decrement our row counter
    BNE @RowLoop        ;  if we still have rows to erase, keep looping


    LDA soft2000    ; otherwise, we're done.  Reset the scroll
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL
    STA PPUSCROLL
    RTS             ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DialogueBox_Frame  [$D6A1 :: 0x3D6B1]
;;
;;    Does frame work related to drawing the dialogue box.  This mainly involves timing the screen
;;  splits required to make the dialogue box visible.
;;
;;  IN:  tmp+10 = "offscreen" NT (soft2000 XOR #$01) -- NT containing dialogue box
;;       tmp+11 = number of scanlines (-8) the dialogue box is to be visible.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DialogueBox_Frame:
    FARCALL Dialogue_CoverSprites_VBl   ; modify OAM to cover sprites behind the dialogue box, then wait for VBlank
    LDA #>oam          ; do sprite DMA
    STA OAMDMA          ; after waiting for VBlank and Sprite DMA, the game is roughly 556 cycles into VBlank

    LDA tmp+10         ; set NT scroll to draw the "offscreen" NT (the one with the dialogue box)
    STA PPUCTRL

        ; now the game loops to burn VBlank time, so that it can start doing raster effects to split the screen

    LDY #$FC           ; count Y down from $FC
  @BurnVBlankLoop:     ; On entry to this loop, game is about 565 cycles into VBlank)
    DEY                    ; 2 cycles
    NOP                    ; +2=4
    NOP                    ; +2=6
    NOP                    ; +2=8
    BNE @BurnVBlankLoop    ; +3=11   (11*$FC)-1 = 2771 cycles burned in loop.
                           ;         2771 + 565 = 3336 cycles since VBl start
                           ; First visible rendered scanline starts 2387 cycles into VBlank
                           ; 3336 - 2387 = 949 cycles into rendering
                           ; 949 / 113.6667 = currently on scanline ~8.3
       PAGECHECK @BurnVBlankLoop

        ; here, thanks to above loop, the game is ~8.3 scanlines into rendering.  Since scroll changes
        ;  are not visible until the end of the scanline, you can round up and say that we're on scanline 9
        ;  since that'll be when scroll changes are first visible.

    LDX tmp+11             ; get the height of the box
    DEX                    ; decrement it BEFORE burning scanlines (since we're on scanline 9, this would
                           ;   mean the last visible dialogue box line is 8+N  -- where N is tmp+11)

  @ScanlineLoop:
    CALL WaitScanline       ; burn the desired number of scanlines
    DEX
    BNE @ScanlineLoop

       PAGECHECK @ScanlineLoop

      ; now... the dialogue box has been visible for 8+N scanlines, and we're to its bottom line
      ; so we don't want it to be visible any more for the rest of this frame

    LDA soft2000                   ; so get the normal "onscreen" NT
    STA PPUCTRL                      ; and set it
    FARJUMP MusicPlay       ; then call the Music Play routine and exit
