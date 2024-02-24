.segment "BANK_19"

.include "src/global-import.inc"

.import DrawCursor

.export DrawEquipMenuCursSecondary, DrawEquipMenuCurs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Equip Menu Cursor  Primary/Secondary  [$BEA4 :: 0x3BEB4]
;;
;;    Draws the primary cursor for the equip menu, or both the primary and secondary cursors.
;;  If both are drawn... they "flicker" so that only a paticular one is drawn in any given frame.
;;  An example of when both are drawn would be when you are trading two items.
;;
;;  DrawEquipMenuCurs          =  draws just the primary
;;  DrawEquipMenuCursSecondary =  draws both in flicker fashion
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEquipMenuCursSecondary:
    LDA framecounter           ; get the frame counter
    LSR A                      ;  shift to put bit 1 in C (alternate which cursor to draw every other frame...
    LSR A                      ;  however... since the framecounter is incremented TWICE by EquipMenuFrame,
    BCS DrawEquipMenuCurs      ;  this really alternates *every* frame).  If odd frame.. just draw the primary cursor

    LDA cursor2                ; get secondary cursor
    ASL A                      ;  double it and put it in X for LUT indexing
    TAX
    LDA lut_EquipMenuCurs, X   ; get cursor X coord
    ORA #$04                   ; add (or really, OR) 4 to draw it a little to the right of the primary cursor
    BNE EquipMenuCurs_DoDraw   ; then draw it (always branches)

DrawEquipMenuCurs:
    LDA cursor                 ; get primary cursor
    ASL A                      ;  double it and put in X for LUT indexing
    TAX
    LDA lut_EquipMenuCurs, X   ; get cursor X coord... then draw

  EquipMenuCurs_DoDraw:
    STA spr_x                    ; record X coord
    LDA lut_EquipMenuCurs+1, X   ; then fetch
    STA spr_y                    ;    and record Y coord
    JUMP DrawCursor               ; draw the cursor, and exit

  lut_EquipMenuCurs:
  .byte $40,$38,   $90,$38
  .byte $40,$48,   $90,$48
  .byte $40,$68,   $90,$68
  .byte $40,$78,   $90,$78
  .byte $40,$98,   $90,$98
  .byte $40,$A8,   $90,$A8
  .byte $40,$C8,   $90,$C8
  .byte $40,$D8,   $90,$D8
