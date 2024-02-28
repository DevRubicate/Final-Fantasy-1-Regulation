.segment "BANK_2B"

.include "src/global-import.inc"

.import PrepRowCol, PrepDialogueBoxRow, WaitForVBlank, DrawMapRowCol, SetSMScroll, MusicPlay, PrepAttributePos, PrepDialogueBoxAttr, DrawMapAttributes
.import DrawDialogueString

.export DrawDialogueBox

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
