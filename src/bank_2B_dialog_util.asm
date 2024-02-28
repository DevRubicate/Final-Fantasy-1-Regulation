.segment "BANK_2B"

.include "src/global-import.inc"

.import PrepRowCol, WaitForVBlank, DrawMapRowCol, SetSMScroll, MusicPlay, PrepAttributePos, PrepDialogueBoxAttr, DrawMapAttributes
.import DrawDialogueString

.export DrawDialogueBox, PrepDialogueBoxRow

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
    CALL DrawMapAttributes      ; and draw the attributes for this row
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
    JUMP DrawDialogueString   ; draw it, then exit!

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
