.segment "BANK_2C"

.include "src/global-import.inc"

.import SetSMScroll, WaitForVBlank, SetPPUAddrToDest, Impl_FARBYTE, MusicPlay, SeekItemStringPtr

.export SeekDialogStringPtr, DrawDialogueString


LUT_DialoguePtrTbl:
    .byte $00, $82, $09, $82, $5c, $82, $bd, $82, $d9, $82, $30, $83, $53, $83, $d1, $83
    .byte $ff, $83, $5e, $84, $78, $84, $94, $84, $cf, $84, $08, $85, $27, $85, $80, $85
    .byte $95, $85, $9c, $85, $ef, $85, $4c, $86, $7b, $86, $d9, $86, $2a, $87, $73, $87
    .byte $ad, $87, $ce, $87, $18, $88, $33, $88, $60, $88, $a4, $88, $d9, $88, $24, $89
    .byte $75, $89, $b2, $89, $fa, $89, $23, $8a, $70, $8a, $9d, $8a, $e4, $8a, $17, $8b
    .byte $4c, $8b, $52, $8b, $63, $8b, $b9, $8b, $23, $8c, $91, $8c, $f8, $8c, $57, $8d
    .byte $af, $8d, $04, $8e, $43, $8e, $6c, $8e, $80, $8e, $9b, $8e, $c0, $8e, $df, $8e
    .byte $02, $8f, $1a, $8f, $35, $8f, $62, $8f, $9b, $8f, $b4, $8f, $c0, $8f, $d9, $8f
    .byte $0e, $90, $3b, $90, $9e, $90, $c3, $90, $17, $91, $49, $91, $b3, $91, $be, $91
    .byte $d2, $91, $ea, $91, $0c, $92, $38, $92, $64, $92, $6d, $92, $b8, $92, $f3, $92
    .byte $35, $93, $79, $93, $c7, $93, $f1, $93, $2d, $94, $70, $94, $8b, $94, $bb, $94
    .byte $c1, $94, $e9, $94, $0f, $95, $2d, $95, $54, $95, $a1, $95, $dd, $95, $fb, $95
    .byte $36, $96, $7c, $96, $88, $96, $aa, $96, $f8, $96, $23, $97, $46, $97, $7b, $97
    .byte $9c, $97, $c3, $97, $0c, $98, $54, $98, $7f, $98, $b5, $98, $d6, $98, $f5, $98
    .byte $09, $99, $25, $99, $5b, $99, $79, $99, $a4, $99, $c6, $99, $f5, $99, $22, $9a
    .byte $2b, $9a, $48, $9a, $84, $9a, $9e, $9a, $ca, $9a, $ff, $9a, $09, $9b, $34, $9b

LUT_DialoguePtrTbl_Secondary:
    .byte $53, $9b, $92, $9b, $aa, $9b, $dd, $9b, $02, $9c, $3f, $9c, $6f, $9c, $a1, $9c
    .byte $d2, $9c, $00, $9d, $1e, $9d, $3d, $9d, $6f, $9d, $9d, $9d, $ea, $9d, $1f, $9e
    .byte $83, $9e, $e8, $9e, $08, $9f, $27, $9f, $69, $9f, $97, $9f, $d6, $9f, $24, $a0
    .byte $70, $a0, $9e, $a0, $f7, $a0, $5b, $a1, $d1, $a1, $00, $a2, $4e, $a2, $6d, $a2
    .byte $a3, $a2, $e9, $a2, $03, $a3, $5c, $a3, $78, $a3, $8a, $a3, $95, $a3, $bb, $a3
    .byte $e5, $a3, $35, $a4, $65, $a4, $94, $a4, $da, $a4, $f8, $a4, $16, $a5, $5c, $a5
    .byte $7d, $a5, $ca, $a5, $0f, $a6, $30, $a6, $4f, $a6, $89, $a6, $a1, $a6, $cb, $a6
    .byte $df, $a6, $23, $a7, $3d, $a7, $63, $a7, $94, $a7, $f1, $a7, $1e, $a8, $4e, $a8
    .byte $6e, $a8, $7c, $a8, $cf, $a8, $12, $a9, $36, $a9, $6f, $a9, $9d, $a9, $c1, $a9
    .byte $f5, $a9, $2f, $aa, $5d, $aa, $72, $aa, $96, $aa, $b6, $aa, $d8, $aa, $ff, $aa
    .byte $38, $ab, $48, $ab, $89, $ab, $ca, $ab, $28, $ac, $73, $ac, $bc, $ac, $05, $ad
    .byte $51, $ad, $76, $ad, $c2, $ad, $de, $ad, $07, $ae, $34, $ae, $6d, $ae, $9a, $ae
    .byte $b9, $ae, $c7, $ae, $eb, $ae, $22, $af, $53, $af, $7b, $af, $a2, $af, $d3, $af
    .byte $21, $b0, $42, $b0, $87, $b0, $b4, $b0, $e9, $b0, $fd, $b0, $1d, $b1, $28, $b1
    .byte $6f, $b1, $89, $b1, $9a, $b1, $af, $b1, $c0, $b1, $d1, $b1, $e2, $b1, $f3, $b1
    .byte $18, $b2, $33, $b2, $9c, $b2, $f2, $b2, $68, $b3, $d2, $b3, $3d, $b4, $56, $b4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DTE table   [$F050 :: 0x3F060]
;;
;;  first table is the 2nd character in a DTE pair
;;  second table is the 1st character in a DTE pair
;;
;;  don't ask me why it's reversed
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lut_DTE2:
  .byte $FF,$B7,$AB,$A8,  $FF,$B1,$A4,$FF,  $B1,$A8,$B6,$B5,  $B8,$FF,$B2,$FF
  .byte $AA,$A4,$B6,$AC,  $FF,$B5,$B6,$A5,  $A8,$BA,$A8,$B5,  $B2,$B7,$A6,$B7
  .byte $B1,$A7,$B1,$AC,  $A8,$B6,$A7,$A4,  $B0,$A9,$FF,$A8,  $BA,$FF,$A8,$B0
  .byte $92,$FF,$A9,$B2,  $AF,$B3,$BC,$A4,  $8A,$A8,$FF,$B5,  $B2,$AC,$FF,$AB
  .byte $A8,$B7,$AC,$A4,  $A6,$AF,$A8,$AF,  $A8,$B6,$FF,$AF,  $A8,$A7,$AC,$C3

lut_DTE1:
  .byte $A8,$FF,$B7,$AB,  $B6,$AC,$FF,$B7,  $A4,$B5,$FF,$A8,  $B2,$A7,$B7,$B1
  .byte $B1,$A8,$A8,$FF,  $B2,$A4,$AC,$FF,  $B9,$FF,$B0,$B2,  $FF,$B6,$FF,$A4
  .byte $A8,$B1,$B2,$AB,  $B6,$A4,$A8,$AB,  $FF,$FF,$B5,$AF,  $B2,$AA,$A6,$B2
  .byte $90,$BC,$B2,$B5,  $AF,$FF,$FF,$A6,  $96,$B7,$A9,$B8,  $BC,$B7,$AF,$FF
  .byte $B1,$AC,$B5,$BA,  $A4,$A4,$BA,$AC,  $A5,$B5,$B8,$FF,  $AA,$FF,$AF,$C3

SeekDialogStringPtr:
    ASL A                 ; double it (2 bytes per pointer)
    TAX                   ; and put in X for indexing
    BCS @HiTbl            ; if string ID was >= $80 use 2nd half of table, otherwise use first half

    @LoTbl:

    LDA LUT_DialoguePtrTbl, X        ; load up the pointer into text_ptr
    STA text_ptr
    LDA LUT_DialoguePtrTbl+1, X
    STA text_ptr+1
    JUMP @PtrLoaded                   ; then jump ahead

    @HiTbl:

    LDA LUT_DialoguePtrTbl_Secondary, X   ; same, but read from 2nd half of pointer table
    STA text_ptr
    LDA LUT_DialoguePtrTbl_Secondary+1, X
    STA text_ptr+1

    @PtrLoaded:             ; here, text_ptr points to the desired string
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Dialogue String [$DB64 :: 0x3DB74]
;;
;;    Draws a string to the dialogue.  This is similar to DrawComplexString, however
;;  unlike DrawComplexString, this routine is written to handle the drawing crossing an
;;  NT boundary.  The control codes are also a bit different (and there aren't near as many of them)
;;
;;  IN:             A = dialogue string ID to draw
;;       box_x, box_y = name might be confusing, these are actually the coords at which
;;                        to start string drawing (IE:  they're not really the coords of the
;;                        containing box).
;;         dlg_itemid = item ID for use with the $02 control code (see below)
;;
;;    tmp+7 is used as a "precautionary counter" that decrements every time a DTE code is
;;  used.  Once it expires, the game stalls for a frame.  Since all this drawing is done
;;  while the PPU is on, this helps ensure that writes don't spill out past the end of VBlank.
;;  A stall also occurs on line breaks.
;;
;;  Byte codes are as follows:
;;
;;  $00 = null terminator (marks end of string)
;;  $01 = line break (only seems to be used in the treasure chest "You Found..." dialogue)
;;  $02 = control code to draw an item name (item ID whose name to draw is in dlg_itemid)
;;  $03 = draw the name of the lead character, then stop string drawing (I believe this is BUGGED)
;;  $05 = line break
;;  $04,$06-19 = unused, but defaults to a line break
;;  $1A-79 = DTE codes
;;  $7A-FF = single tile output
;;
;;    I don't think code $03 is used anywhere in the game.  It's a little bizarre... maybe it was used
;;  in the J version?
;;
;;    Control code $02 is used for the treasure chest text in order to print the item you found.
;;  the item found is stored in dlg_itemid prior to this routine being called.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawDialogueString_Done:
    CALL SetSMScroll       ; when done drawing, simply reset the scroll
    RTS                   ; and exit

DrawDialogueString:

    CALL SeekDialogStringPtr

    LDA #BANK_DIALOGUE
    STA cur_bank          ; set cur_bank to bank containing dialogue text (for Music_Play)

    LDA #10
    STA tmp+7             ;  set precautionary counter to 10

    CALL WaitForVBlank   ; wait for VBlank

    LDA box_x             ; copy placement coords (box_*) to dest coords (dest_*)
    STA dest_x
    LDA box_y
    STA dest_y
    FARCALL SetPPUAddrToDest  ; then set the PPU address appropriately

    @Loop:
    LDY #0
    JSR Impl_FARBYTE
    BEQ DrawDialogueString_Done  ; if it's zero (null terminator), exit

    INC text_ptr                 ; otherwise increment the pointer
    BNE :+
        INC text_ptr+1             ;   inc high byte if low byte wrapped
    :   
    CMP #$1A
    BCC @ControlCode     ; if the byte is < $1A, it's a control code

    CMP #$7A
    BCC @DTE             ; if $1A-$79, it's a DTE code

    @SingleTile:
    
    STA PPUDATA            ; otherwise ($7A-$FF), it's a normal single tile.  Draw it

    LDA dest_x           ; increment the dest address by 1
    CLC
    ADC #1
    AND #$3F             ; and mask it with $3F so it wraps around both NTs appropriately
    STA dest_x           ; then write back

    AND #$1F             ; then mask with $1F.  If result is zero, it means we're crossing an NT boundary
    BNE @Loop            ;  if not zero, just continue looping
        FARCALL SetPPUAddrToDest  ;  otherwise if zero, PPU address needs to be reset (NT boundary crossed)
        JUMP @Loop             ;  then jump back to loop


    @DTE:                 ; if byte fetched was a DTE code ($1A-79)
    SEC
    SBC #$1A           ; subtract $1A to make the DTE code zero based
    TAX                ; put in X for indexing
    PHA                ; and push it to back it up (will need it again later)

    LDA lut_DTE1, X    ; get the first byte in the DTE pair
    STA PPUDATA          ; and draw it
    CALL @IncDest       ; update PPU dest address

    PLA                ; restore DTE code
    TAX                ; and put it in X again (X was corrupted by @IncDest call)
    LDA lut_DTE2, X    ; get second byte in DTE pair
    STA PPUDATA          ; draw it
    CALL @IncDest       ; and update PPU address again

    DEC tmp+7            ; decrement cautionary counter
    BNE @Loop            ; if it hasn't expired yet, keep drawing.  Otherwise...

    CALL SetSMScroll      ; we could be running out of VBlank time.  So set the scroll
    FARCALL MusicPlay    ; keep music playing
    CALL WaitForVBlank  ; then wait another frame before continuing drawing

    LDA #10
    STA tmp+7            ; reload precautionary counter
    FARCALL SetPPUAddrToDest ; and set PPU address appropriately
    JUMP @Loop            ; then resume drawing

    @ControlCode:          ; if the byte fetched was a control code ($01-19)
    CMP #$03             ; was the code $03?
    BNE @Code_Not03      ; if not jump ahead

    @PrintName:            ; Control Code $03 = prints the name of the lead character
    LDA ch_name          ; copy lead character's name to format buffer
    STA format_buf+3
    LDA ch_name+1        ; note that this does not back up the original string, which means
    STA format_buf+4     ; after this name is drawn, dialogue printing stops!  I don't know if
    LDA ch_name+2        ; that was intentional or not -- I don't see why it would be.  Therefore
    STA format_buf+5     ; I would say this is BUGGED, even though I don't think
    LDA ch_name+3        ; it's ever used in the game
    STA format_buf+6

    LDA #<(format_buf+3) ; make text_ptr point to the format buffer
    STA text_ptr
    LDA #>(format_buf+3)
    STA text_ptr+1

    JUMP @Loop            ; and continue printing (to print the name, then quit)

    @Code_Not03:           ; Control codes other than $03
    CMP #$02             ; was code $02
    BNE @Code_Not02_03   ; if not, jump ahead

    @PrintItemName:        ; Control Code $02 = prints the ID of the item stored in dlg_itemid (used for treasure chests)
    LDA text_ptr         ; push the text pointer to the stack to back it up
    PHA
    LDA text_ptr+1
    PHA

    LDA dlg_itemid       ; get the item ID whose name we're to print

    FARCALL SeekItemStringPtr

    STA text_ptr+1
    CALL @Loop            ; once pointer is loaded, CALL to the @Loop to draw the item name

    PLA                  ; then restore the original string pointer by pulling it from the stack
    STA text_ptr+1
    PLA
    STA text_ptr

    JUMP @Loop            ; and continue drawing the rest of the string

    @Code_Not02_03:          ; all other control codes besides 02 and 03
    CALL @LineBreak         ; just do a line break
    JUMP @Loop              ; then continue


    @IncDest:                  ; called by DTE bytes to increment the dest address by 1 column
    LDA dest_x             ; add 1 to the X coord
    CLC
    ADC #1
    AND #$3F               ; AND with $3F to wrap around NT boundaries properly
    STA dest_x

    AND #$1F               ; then check the low 5 bits.  If they're zero, we just crossed an NT boundary
    BNE :+
        FARJUMP SetPPUAddrToDest ; if crossed an NT boundary, the PPU address needs to be changed
    :   
    RTS                    ; then return

    @LineBreak:                ; wait a frame between each line break to help ensure we stay in VBlank
    CALL SetSMScroll        ; set the scroll
    FARCALL MusicPlay      ; and keep music playing

    LDA #8
    STA tmp+7              ; reload precautionary counter (but with only 8 instead of 10?)

    CALL WaitForVBlank    ; then wait for VBlank

    LDA box_x              ; reset dest X coord to given placement coord
    STA dest_x

    LDA dest_y             ; then add 1 to the dest Y coord to move it a line down
    CLC
    ADC #1
    CMP #30                ; but wrap from 29->0  because there are only 30 rows on the nametable
    BCC :+
        SBC #30
    :   
    STA dest_y

    FARJUMP SetPPUAddrToDest   ; then set the PPU address and continue string drawing
