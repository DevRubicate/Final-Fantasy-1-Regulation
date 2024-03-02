.segment "PRG_050"

.include "src/global-import.inc"

.import DrawCursor, CHRLoad, CHRLoad_Cont, LoadBattleSpritePalettes, LoadMenuBGCHRAndPalettes, LoadBackdropPalette, MusicPlay, WaitForVBlank

.export DrawEquipMenuCursSecondary, DrawEquipMenuCurs, LoadBatSprCHRPalettes_NewGame, LoadNewGameCHRPal, LoadMenuCHRPal, LoadBatSprCHRPalettes
.export MenuCondStall


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
    FARJUMP DrawCursor               ; draw the cursor, and exit

  lut_EquipMenuCurs:
  .byte $40,$38,   $90,$38
  .byte $40,$48,   $90,$48
  .byte $40,$68,   $90,$68
  .byte $40,$78,   $90,$78
  .byte $40,$98,   $90,$98
  .byte $40,$A8,   $90,$A8
  .byte $40,$C8,   $90,$C8
  .byte $40,$D8,   $90,$D8


LoadMenuCHRPal:                ; does not load 'lit orb' palette, or the two middle palettes ($03C0-03CB)
    FARCALL LoadMenuBGCHRAndPalettes
    JUMP LoadBatSprCHRPalettes

LoadNewGameCHRPal:
    FARCALL LoadMenuBGCHRAndPalettes
    NOJUMP LoadBatSprCHRPalettes_NewGame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle Sprite CHR and Palettes  [$EAB9 :: 0x3EAC9]
;;
;;    Comes in 2 flavors.  The first loads all 6 class graphics and the cursor graphic
;;     This is used for the 'New Game' screen where you select your party
;;
;;    Next is the in-game flavor that loads 4 classes based on the characters in
;;     The party.  It also loads the cursor, as well as other in-battle sprites, such
;;     as those little magic and weapon animations, and the "fight cloud" that appears
;;     when you attack an enemy.
;;
;;    Both load all palettes used by battle sprites to $03Dx
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBatSprCHRPalettes_NewGame:
    LDA PPUSTATUS      ; Reset PPU Addr Toggle
    LDA #$10
    STA PPUADDR      ;  set dest PPU Addr to $1000
    LDA #$00
    STA PPUADDR

    LDA #<LUT_BatSprCHR
    STA tmp
    LDA #>LUT_BatSprCHR    ;  set source pointer
    STA tmp+1

    LDX #2*6       ;  12 rows (2 rows per class * 6 classes)
    CALL CHRLoad    ; Load up the CHR
    
    LDA #<(LUT_BatObjCHR + $400)  ; change source pointer to bottom half of cursor and related CHR
    STA tmp
    LDA #>(LUT_BatObjCHR + $400)  ; change source pointer to bottom half of cursor and related CHR
    STA tmp+1

    LDX #$04                      ; load 4 rows (bottom half)
    CALL CHRLoad_Cont   ; load cursor and other battle related CHR
    FARCALL LoadBattleSpritePalettes  ; load palettes for these sprites
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle Sprite CHR and Palettes  [$EAB9 :: 0x3EAC9]
;;
;;    Comes in 2 flavors.  The first loads all 6 class graphics and the cursor graphic
;;     This is used for the 'New Game' screen where you select your party
;;
;;    Next is the in-game flavor that loads 4 classes based on the characters in
;;     The party.  It also loads the cursor, as well as other in-battle sprites, such
;;     as those little magic and weapon animations, and the "fight cloud" that appears
;;     when you attack an enemy.
;;
;;    Both load all palettes used by battle sprites to $03Dx
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBatSprCHRPalettes:
    ;LDA #BANK_BTLCHR
    ;CALL SwapPRG  ; swap to bank 9
    LDA PPUSTATUS      ; reset ppu addr toggle
    LDA #$10
    STA PPUADDR      ; set dest ppu addr to $1000
    LDA #$00
    STA PPUADDR

    LDA ch_class      ; get character 1's class
    CALL @LoadClass    ;  load it
    LDA ch_class+$40  ; character 2's
    CALL @LoadClass
    LDA ch_class+$80  ; character 3's
    CALL @LoadClass
    LDA ch_class+$C0  ; character 4's
    CALL @LoadClass

    LDA #<LUT_BatObjCHR  ; low byte source
    STA tmp 
    LDA #>LUT_BatObjCHR  ; once all character's class graphics are loaded
    STA tmp+1            ;   change source pointer to $A800  (start of cursor and related battle CHR)
    LDX #$08             ; signal to load 8 rows

    CALL CHRLoad_Cont   ; load cursor and other battle related CHR
    FARCALL LoadBattleSpritePalettes  ; load palettes for these sprites

    @LoadClass:
    ASL A               ; double class index (each class has 2 rows of tiles)
    CLC
    ADC #>LUT_BatSprCHR ; add high byte of the source pointer
    STA tmp+1
    LDA #<LUT_BatSprCHR
    STA tmp
    LDX #$02            ; signal to load 2 rows
    JUMP CHRLoad         ; and load them!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Menu Conditional Stall   [$E12E :: 0x3E13E]
;;
;;    This will conditionally stall (wait) a frame for some menu routines.
;;   For example, if a box is to draw more slowly (one row drawn per frame)
;;   This is important and should be done when you attempt to draw when the PPU is on
;;   because it ensures that drawing will occur in VBlank
;;
;;  IN:  menustall = the flag to indicate whether or not to stall (nonzero = stall)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MenuCondStall:
    LDA menustall          ; check stall flag
    BEQ @Exit              ; if zero, we're not to stall, so just exit

      LDA soft2000         ;  we're stalling... so reset the scroll
      STA PPUCTRL
      LDA #0
      STA PPUSCROLL            ;  scroll inside menus is always 0
      STA PPUSCROLL

      FARCALL MusicPlay    ;  Keep the music playing
      CALL WaitForVBlank  ; then wait a frame

    @Exit:
    RTS


LUT_BatSprCHR:
    .byte $2b, $5f, $7f, $3f, $7f, $5c, $51, $0b, $00, $00, $00, $00, $00, $08, $01, $0b
    .byte $fc, $f0, $ff, $fc, $fe, $ff, $fc, $fe, $00, $00, $00, $00, $00, $00, $00, $30
    .byte $0b, $0f, $1f, $77, $30, $79, $6f, $79, $0b, $0f, $2f, $07, $00, $40, $60, $10
    .byte $fc, $f0, $9a, $3f, $bf, $dc, $ee, $fe, $b0, $c0, $84, $00, $00, $1c, $66, $f2
    .byte $e7, $e7, $03, $00, $03, $03, $03, $07, $e0, $e0, $00, $03, $00, $00, $00, $00
    .byte $fe, $c0, $c0, $20, $e0, $e0, $e0, $e0, $e0, $00, $00, $e0, $00, $00, $00, $00
    .byte $f6, $6f, $0f, $36, $fa, $7c, $38, $10, $e0, $60, $10, $08, $04, $00, $00, $00
    .byte $fe, $dc, $f4, $6e, $1f, $1e, $1c, $38, $c0, $00, $08, $10, $20, $00, $00, $00
    .byte $2b, $5f, $7f, $3f, $7f, $5c, $51, $0b, $00, $00, $00, $00, $00, $08, $01, $0b
    .byte $fc, $f0, $ff, $fc, $fe, $ff, $fc, $fe, $00, $00, $00, $00, $00, $00, $00, $30
    .byte $3b, $3f, $1f, $17, $10, $19, $0f, $09, $0b, $0f, $0f, $07, $00, $00, $00, $00
    .byte $fc, $f0, $9a, $3f, $bf, $d8, $ee, $fe, $b0, $c0, $84, $00, $00, $18, $66, $e2
    .byte $06, $0f, $0f, $36, $fa, $7c, $38, $10, $00, $00, $10, $08, $04, $00, $00, $00
    .byte $fe, $dc, $f4, $6e, $1f, $1e, $1c, $38, $c0, $00, $08, $10, $20, $00, $00, $00
    .byte $2b, $5f, $7f, $3f, $ff, $dc, $d1, $cb, $00, $00, $00, $00, $80, $88, $c1, $8b
    .byte $fc, $f0, $ff, $fc, $fd, $fb, $fb, $fb, $00, $00, $00, $00, $01, $03, $03, $33
    .byte $eb, $ff, $7f, $77, $38, $19, $1f, $08, $2b, $6f, $6f, $67, $20, $00, $00, $00
    .byte $f7, $ee, $9f, $7d, $fe, $d8, $c0, $b0, $b0, $c8, $9e, $1c, $1c, $18, $00, $00
    .byte $06, $0f, $1f, $1e, $00, $3e, $7c, $fc, $00, $00, $00, $00, $3e, $00, $00, $00
    .byte $60, $f0, $f0, $f8, $00, $3c, $3e, $1f, $00, $00, $00, $00, $7c, $00, $00, $00
    .byte $00, $00, $00, $00, $03, $26, $6f, $6f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $38, $f0, $fc, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $7f, $3f, $7f, $bf, $bf, $1f, $33, $7b, $00, $00, $00, $00, $00, $01, $41, $8b
    .byte $fc, $fe, $ff, $fe, $fe, $fe, $19, $ae, $00, $00, $00, $00, $04, $14, $00, $a6
    .byte $ef, $97, $78, $f7, $f7, $76, $78, $78, $0f, $07, $60, $f0, $80, $00, $38, $78
    .byte $cb, $9d, $60, $9e, $be, $3e, $3e, $1f, $cb, $81, $1e, $20, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $06, $0d, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $e0, $c4, $f8, $f0, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $30, $40, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $3f, $3f, $1f, $3f, $1e, $0f, $1f, $7f, $00, $00, $00, $00, $00, $03, $13, $71
    .byte $fe, $fd, $e0, $1e, $ed, $b5, $cb, $db, $00, $00, $00, $00, $00, $80, $c0, $c0
    .byte $bf, $be, $bc, $00, $fc, $fc, $fc, $f8, $00, $00, $00, $3c, $00, $00, $00, $00
    .byte $00, $3d, $7f, $5f, $3f, $2f, $2e, $01, $00, $3d, $7f, $5f, $37, $27, $20, $00
    .byte $00, $f0, $fc, $fe, $fe, $fe, $fe, $fe, $00, $f0, $fc, $fe, $fe, $fe, $ce, $8e
    .byte $0b, $0b, $0f, $0f, $66, $90, $00, $e1, $00, $00, $20, $60, $10, $69, $ee, $0c
    .byte $fc, $f8, $e0, $00, $07, $0f, $cf, $ce, $8c, $98, $6e, $7d, $f8, $30, $00, $30
    .byte $e1, $00, $00, $03, $00, $00, $00, $00, $00, $06, $07, $00, $07, $03, $03, $07
    .byte $c6, $04, $00, $e0, $00, $00, $00, $00, $38, $38, $c0, $00, $f8, $f0, $e0, $e0
    .byte $e1, $04, $06, $03, $00, $00, $00, $00, $0c, $02, $19, $1c, $ff, $7f, $3c, $18
    .byte $c4, $00, $00, $20, $00, $00, $00, $00, $38, $38, $c4, $9e, $7f, $1e, $1c, $38
    .byte $00, $3d, $7f, $5f, $3f, $2f, $2e, $01, $00, $3d, $7f, $5f, $37, $27, $20, $00
    .byte $00, $f0, $fc, $fe, $fe, $fe, $fe, $fe, $00, $f0, $fc, $fe, $fe, $fe, $ce, $8e
    .byte $0b, $0b, $0f, $0f, $06, $00, $00, $01, $00, $00, $00, $00, $00, $09, $0e, $0c
    .byte $fc, $f8, $e0, $00, $07, $0f, $cf, $ce, $8c, $98, $6e, $7d, $f8, $30, $00, $30
    .byte $01, $04, $06, $03, $00, $00, $00, $00, $0c, $02, $19, $1c, $ff, $7f, $3c, $18
    .byte $c4, $00, $00, $20, $00, $00, $00, $00, $38, $38, $c4, $9e, $7f, $1e, $1c, $38
    .byte $00, $3d, $7f, $5f, $3f, $2f, $ee, $e1, $00, $3d, $7f, $5f, $37, $27, $20, $00
    .byte $00, $f0, $fc, $fe, $fe, $fe, $fe, $fe, $00, $f0, $fc, $fe, $fe, $fe, $ce, $8e
    .byte $eb, $0b, $6f, $6f, $26, $00, $00, $01, $00, $60, $10, $10, $10, $19, $0e, $0c
    .byte $fc, $f8, $e0, $00, $07, $0f, $cf, $ce, $8c, $98, $6f, $7d, $f8, $30, $00, $30
    .byte $01, $18, $3c, $3e, $00, $00, $00, $00, $0c, $06, $03, $00, $7f, $3e, $3c, $7e
    .byte $c4, $00, $00, $7c, $30, $00, $00, $00, $38, $38, $80, $00, $0f, $3f, $0e, $1c
    .byte $00, $00, $00, $00, $01, $07, $1f, $3f, $00, $00, $00, $00, $01, $07, $1f, $3f
    .byte $00, $00, $00, $00, $c0, $f8, $fc, $fc, $00, $00, $00, $00, $c0, $f8, $fc, $fc
    .byte $7f, $ff, $bf, $6f, $5f, $5f, $13, $1b, $7f, $ff, $bf, $6f, $5f, $56, $52, $f2
    .byte $fe, $fe, $fe, $fe, $fe, $fc, $12, $af, $fe, $fe, $fc, $9c, $08, $08, $00, $00
    .byte $ef, $f7, $f8, $f0, $f0, $40, $38, $78, $00, $00, $00, $07, $06, $3a, $44, $04
    .byte $cf, $b7, $70, $70, $00, $00, $00, $00, $30, $48, $08, $87, $3f, $3e, $7c, $7e
    .byte $00, $00, $00, $00, $03, $0f, $1f, $bf, $00, $00, $00, $00, $03, $0f, $1f, $bf
    .byte $00, $00, $00, $00, $80, $e0, $f0, $f8, $00, $00, $00, $00, $80, $e0, $f0, $f8
    .byte $00, $00, $00, $00, $3e, $40, $2e, $6f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $7f, $ff, $bf, $5b, $07, $33, $f3, $ff, $7f, $ff, $bf, $58, $18, $0c, $0c
    .byte $f8, $fc, $f0, $80, $c0, $e0, $e0, $c0, $f8, $fc, $ff, $f3, $3d, $1d, $1d, $3b
    .byte $2e, $00, $00, $00, $20, $10, $1e, $1c, $00, $00, $5e, $5e, $5f, $6f, $60, $60
    .byte $00, $00, $00, $00, $00, $08, $0e, $01, $00, $07, $0f, $1f, $3f, $37, $3f, $30
    .byte $00, $00, $00, $00, $00, $00, $78, $00, $00, $f0, $f8, $f8, $fc, $fc, $fc, $fc
    .byte $0b, $0b, $3f, $df, $de, $19, $0f, $0f, $10, $00, $d0, $30, $38, $f8, $0d, $0e
    .byte $00, $00, $84, $4e, $ff, $f3, $9d, $ce, $fc, $fc, $7c, $38, $70, $fc, $62, $31
    .byte $0f, $00, $0d, $0d, $07, $07, $03, $07, $0e, $00, $0d, $0d, $07, $07, $03, $07
    .byte $cc, $98, $f8, $f0, $f0, $e0, $e0, $e0, $32, $60, $f8, $f0, $f0, $e0, $e0, $e0
    .byte $0f, $00, $0d, $1d, $ff, $7e, $3c, $18, $0e, $00, $0d, $1d, $ff, $7e, $3c, $18
    .byte $ce, $98, $fc, $fe, $3f, $1e, $1c, $38, $31, $60, $fc, $fe, $3f, $1e, $1c, $38
    .byte $00, $00, $00, $00, $00, $08, $0e, $01, $00, $07, $0f, $1f, $3f, $37, $3f, $30
    .byte $00, $00, $00, $00, $00, $00, $78, $00, $00, $f0, $f8, $f8, $fc, $fc, $fc, $fc
    .byte $0b, $0b, $3f, $df, $de, $19, $0f, $0f, $10, $00, $d0, $30, $38, $f8, $0d, $0e
    .byte $00, $00, $84, $4e, $ff, $f3, $9d, $ce, $fc, $fc, $7c, $38, $70, $fc, $62, $31
    .byte $0f, $00, $0d, $1d, $ff, $7e, $3c, $18, $0e, $00, $0d, $1d, $ff, $7e, $3c, $18
    .byte $cc, $98, $fc, $fe, $3f, $1e, $1c, $38, $30, $60, $fc, $fe, $3f, $1e, $1c, $38
    .byte $00, $00, $00, $00, $00, $08, $0e, $01, $00, $07, $0f, $1f, $3f, $37, $3f, $30
    .byte $00, $00, $00, $00, $00, $00, $78, $00, $00, $f0, $f8, $f8, $fc, $fc, $fc, $fc
    .byte $0b, $1b, $3f, $7f, $fe, $c8, $bb, $37, $10, $10, $10, $10, $18, $38, $40, $40
    .byte $00, $00, $84, $4e, $ff, $ff, $3e, $9e, $fc, $fc, $78, $30, $60, $e0, $c0, $60
    .byte $37, $03, $13, $36, $3c, $7c, $78, $f8, $40, $30, $13, $36, $3c, $7c, $78, $f8
    .byte $9c, $30, $f8, $f8, $7c, $7c, $3e, $3f, $60, $c0, $f8, $f8, $7c, $7c, $3e, $3f
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $0f, $1f, $3f
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $f8, $fc, $fc
    .byte $00, $00, $01, $1b, $07, $1f, $53, $eb, $3f, $3f, $3e, $3c, $3b, $20, $20, $00
    .byte $00, $00, $00, $98, $c0, $f0, $13, $af, $fe, $fe, $fe, $7e, $fe, $0e, $08, $00
    .byte $ef, $f7, $f8, $ff, $fe, $46, $3c, $7c, $00, $00, $00, $0f, $0e, $3e, $44, $04
    .byte $cf, $b7, $76, $fe, $3e, $3e, $7c, $7e, $30, $48, $0e, $8e, $3e, $3e, $7c, $7e
    .byte $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $1f, $3f, $7f, $7f
    .byte $00, $00, $18, $20, $4c, $70, $c0, $00, $00, $00, $18, $20, $4c, $f0, $f0, $fe
    .byte $00, $00, $00, $00, $7c, $c0, $ae, $6f, $00, $00, $00, $00, $00, $00, $10, $10
    .byte $02, $04, $08, $00, $07, $ef, $77, $37, $ff, $ff, $ff, $ff, $78, $10, $08, $08
    .byte $00, $00, $0e, $fe, $fe, $fe, $fe, $fe, $fe, $fc, $fe, $1e, $0e, $0e, $0e, $1e
    .byte $2e, $5e, $df, $ff, $ff, $ff, $fe, $f8, $10, $5e, $df, $ff, $ff, $ff, $fe, $f8
    .byte $00, $03, $0f, $0f, $0f, $0f, $1f, $3f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $c0, $c0, $80, $93, $7e, $fc, $e0, $00, $1e, $30, $78, $60, $80, $00, $10
    .byte $fc, $03, $0b, $2f, $6f, $97, $00, $ed, $00, $03, $0b, $0f, $00, $00, $00, $e1
    .byte $00, $00, $00, $20, $74, $76, $fe, $be, $f0, $f8, $fc, $de, $8a, $89, $00, $80
    .byte $ed, $ed, $44, $47, $40, $43, $7b, $07, $e1, $e1, $00, $00, $03, $00, $00, $00
    .byte $df, $ef, $37, $e3, $03, $e1, $ef, $e1, $c0, $c0, $00, $00, $e0, $00, $00, $00
    .byte $e5, $ed, $4e, $37, $fa, $7d, $38, $10, $e1, $e1, $10, $08, $04, $00, $00, $00
    .byte $df, $ef, $87, $6b, $1b, $1d, $dd, $38, $c0, $c0, $00, $10, $20, $00, $00, $00
    .byte $00, $03, $0f, $0f, $0f, $0f, $1f, $3f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $c0, $c0, $80, $93, $7e, $fc, $e0, $00, $1e, $30, $78, $60, $80, $00, $10
    .byte $fc, $03, $0b, $1f, $1f, $03, $0c, $0d, $00, $03, $0b, $0f, $00, $00, $00, $01
    .byte $00, $00, $00, $20, $74, $76, $fe, $bf, $f0, $f8, $fc, $de, $8a, $89, $00, $80
    .byte $05, $0d, $0e, $37, $fa, $7d, $38, $10, $01, $01, $10, $08, $04, $00, $00, $00
    .byte $df, $ef, $87, $6b, $1b, $1d, $dd, $38, $c0, $c0, $00, $10, $20, $00, $00, $00
    .byte $00, $03, $0f, $0f, $0f, $8f, $ff, $ff, $00, $00, $00, $00, $00, $80, $80, $c0
    .byte $00, $c0, $c0, $80, $97, $7a, $f6, $e6, $00, $1e, $30, $78, $60, $82, $06, $06
    .byte $cc, $e3, $fb, $6f, $6f, $2f, $07, $28, $00, $63, $eb, $6f, $60, $20, $00, $00
    .byte $06, $0e, $3e, $7c, $5c, $5a, $b6, $76, $e0, $e8, $dc, $9c, $8c, $88, $00, $00
    .byte $2f, $4f, $5f, $9f, $80, $be, $7d, $fc, $00, $00, $00, $00, $3e, $00, $00, $00
    .byte $f3, $f3, $fb, $79, $01, $3d, $de, $1f, $00, $00, $00, $00, $7c, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $07, $0d, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $e0, $e0, $00, $00, $00, $00, $06, $08, $1c, $18
    .byte $0b, $fc, $ef, $77, $38, $0f, $69, $ed, $00, $00, $00, $00, $00, $70, $99, $1d
    .byte $e0, $6f, $de, $bc, $70, $e6, $97, $b2, $10, $00, $00, $00, $0c, $08, $98, $ac
    .byte $e7, $7f, $8e, $f0, $f7, $72, $7c, $7c, $17, $00, $00, $70, $80, $00, $38, $78
    .byte $c9, $7f, $ff, $83, $bb, $7b, $73, $fa, $d4, $4c, $cc, $80, $00, $00, $00, $00
    .byte $00, $00, $03, $0f, $1f, $38, $33, $11, $00, $00, $00, $00, $00, $07, $0c, $0e
    .byte $00, $00, $84, $cc, $fd, $f8, $f8, $f3, $00, $00, $00, $00, $00, $01, $07, $0c
    .byte $00, $20, $60, $c0, $dc, $40, $de, $ff, $00, $00, $00, $00, $1c, $80, $16, $37
    .byte $17, $2f, $7f, $fc, $03, $0c, $ff, $7f, $08, $10, $00, $00, $00, $00, $e3, $63
    .byte $e0, $87, $73, $fd, $ff, $ff, $3e, $c0, $1f, $38, $0c, $02, $00, $00, $00, $c0
    .byte $de, $c0, $de, $de, $80, $bc, $38, $e0, $16, $00, $00, $00, $1e, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $1f, $2f, $00, $01, $07, $1f, $3f, $40, $80, $88
    .byte $00, $00, $00, $00, $00, $00, $00, $80, $3c, $fe, $fe, $f6, $fa, $fc, $7c, $3c
    .byte $11, $0b, $0b, $0f, $0e, $80, $e8, $ce, $41, $2b, $0b, $0f, $3e, $70, $07, $21
    .byte $c0, $c0, $80, $80, $00, $00, $00, $00, $1c, $98, $b8, $b0, $78, $14, $ee, $f6
    .byte $8c, $e8, $c7, $86, $e2, $41, $54, $3f, $63, $07, $20, $61, $09, $2c, $0a, $00
    .byte $00, $00, $00, $00, $40, $c8, $da, $3f, $f6, $fe, $fe, $fe, $be, $36, $24, $00
    .byte $8c, $e8, $c7, $86, $e2, $5d, $0c, $33, $63, $07, $20, $61, $09, $00, $02, $30
    .byte $00, $00, $00, $00, $40, $c8, $da, $3f, $f6, $fe, $fe, $fe, $be, $36, $24, $00
    .byte $00, $00, $00, $00, $00, $00, $0f, $17, $00, $00, $03, $0f, $1f, $20, $40, $44
    .byte $00, $00, $00, $00, $00, $00, $80, $c0, $1e, $ff, $ff, $fb, $fd, $7e, $3e, $1e
    .byte $08, $05, $05, $70, $7e, $bc, $c8, $0e, $20, $15, $05, $70, $71, $b3, $c7, $21
    .byte $e0, $e0, $c0, $00, $00, $00, $00, $00, $9e, $dc, $dc, $08, $f4, $fe, $fe, $fe
    .byte $4c, $08, $47, $06, $23, $01, $22, $37, $23, $67, $30, $71, $18, $1c, $1c, $08
    .byte $00, $00, $00, $00, $c0, $94, $f6, $3f, $fe, $fe, $fc, $fc, $3c, $6a, $08, $00
    .byte $00, $00, $00, $00, $00, $00, $0f, $17, $00, $00, $03, $0f, $1f, $20, $40, $44
    .byte $00, $00, $00, $00, $00, $00, $80, $c0, $1e, $ff, $ff, $fb, $fd, $7e, $3e, $1e
    .byte $88, $85, $c5, $77, $67, $40, $73, $63, $a0, $95, $a5, $07, $17, $30, $0b, $0b
    .byte $e0, $e0, $c0, $c0, $00, $00, $40, $70, $8e, $cc, $dc, $d8, $3c, $06, $3f, $0f
    .byte $40, $60, $40, $40, $00, $12, $36, $7f, $2c, $0f, $2f, $1f, $3f, $2d, $49, $00
    .byte $60, $20, $38, $30, $30, $1c, $98, $cc, $1f, $1f, $07, $0f, $8f, $83, $07, $03
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $0f, $1f
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $f0, $f8, $f8
    .byte $00, $00, $00, $1f, $3f, $3f, $04, $16, $3f, $7f, $60, $c0, $90, $88, $64, $16
    .byte $00, $00, $00, $00, $80, $c0, $40, $c0, $ec, $f4, $f8, $78, $38, $18, $1c, $de
    .byte $0f, $00, $00, $40, $c0, $f0, $10, $e9, $2f, $60, $df, $a8, $2e, $06, $06, $e1
    .byte $80, $00, $00, $80, $e0, $d4, $36, $df, $be, $7e, $7f, $7f, $1f, $2b, $09, $c0
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07, $1f, $3c, $7b, $7f
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $c1, $f6
    .byte $00, $00, $00, $00, $0c, $0e, $67, $77, $00, $00, $00, $1c, $6f, $8a, $e7, $57
    .byte $00, $00, $00, $00, $0d, $3b, $4f, $e1, $ff, $ff, $7c, $73, $02, $04, $40, $e0
    .byte $00, $00, $00, $00, $00, $24, $6d, $ff, $fe, $3e, $fe, $fb, $fc, $db, $92, $00
    .byte $7b, $38, $18, $00, $00, $00, $00, $80, $7b, $38, $19, $01, $81, $02, $c6, $78
    .byte $00, $00, $00, $00, $03, $ff, $07, $00, $00, $00, $00, $00, $00, $00, $78, $0f
    .byte $06, $1c, $38, $f0, $c0, $00, $80, $e0, $00, $02, $04, $0c, $38, $f8, $78, $10
    .byte $00, $08, $09, $21, $40, $71, $3f, $dc, $01, $00, $00, $20, $40, $71, $3f, $1c
    .byte $00, $00, $00, $08, $04, $fc, $18, $fc, $f8, $3c, $0e, $0b, $04, $fc, $18, $fc
    .byte $d8, $3e, $5e, $58, $6f, $77, $79, $ff, $18, $38, $58, $58, $6f, $77, $79, $ff
    .byte $fc, $fc, $fc, $f8, $78, $78, $b4, $ce, $fc, $fc, $fc, $f8, $78, $78, $b4, $ce
    .byte $30, $76, $76, $40, $7b, $cf, $b7, $7b, $30, $70, $70, $40, $7b, $cf, $87, $03
    .byte $fc, $fc, $fc, $f8, $78, $7a, $b6, $cf, $fc, $fc, $fc, $f8, $78, $7a, $b6, $cf
    .byte $00, $00, $00, $00, $03, $ff, $07, $00, $00, $00, $00, $00, $00, $00, $78, $0f
    .byte $06, $1c, $38, $f0, $c0, $00, $80, $e0, $00, $02, $04, $0c, $38, $f8, $78, $10
    .byte $00, $28, $69, $61, $60, $fe, $fe, $fd, $01, $20, $60, $60, $60, $fe, $fe, $fd
    .byte $00, $00, $00, $00, $08, $f4, $0c, $fc, $f8, $3c, $0e, $03, $08, $f4, $0c, $fc
    .byte $b0, $b6, $b6, $38, $3f, $4f, $37, $7b, $b0, $b0, $b0, $38, $3f, $4f, $07, $03
    .byte $fc, $fc, $fc, $f8, $78, $7a, $b6, $cf, $fc, $fc, $fc, $f8, $78, $7a, $b6, $cf
    .byte $00, $00, $00, $00, $03, $ff, $07, $00, $00, $00, $00, $00, $00, $00, $78, $0f
    .byte $06, $1c, $38, $f0, $c0, $00, $80, $e0, $00, $02, $04, $0c, $38, $f8, $78, $10
    .byte $00, $08, $89, $e1, $c0, $20, $df, $df, $00, $00, $00, $20, $00, $20, $1f, $1f
    .byte $00, $00, $00, $00, $04, $7a, $86, $fe, $fc, $1e, $07, $01, $04, $7a, $86, $fe
    .byte $9f, $1f, $5f, $6f, $6f, $87, $6b, $f4, $1f, $1f, $5f, $6f, $6f, $87, $0b, $04
    .byte $fc, $fc, $fc, $f8, $fc, $fc, $fe, $ff, $fc, $fc, $fc, $f8, $fc, $fc, $fe, $ff
    .byte $00, $00, $00, $04, $04, $06, $0e, $0f, $00, $00, $00, $02, $02, $01, $01, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60
    .byte $3f, $6f, $de, $f8, $7f, $3f, $00, $24, $00, $10, $21, $07, $00, $00, $1f, $20
    .byte $00, $00, $30, $70, $e0, $80, $00, $8c, $bc, $cf, $cf, $8f, $1e, $7c, $e0, $0c
    .byte $30, $78, $7e, $7d, $7e, $7f, $1f, $67, $30, $78, $7e, $7c, $7e, $7f, $1f, $07
    .byte $3e, $fe, $7f, $bf, $3f, $83, $dd, $be, $3e, $fe, $7f, $3f, $3f, $83, $c1, $80
    .byte $00, $01, $03, $7f, $3f, $0f, $03, $00, $00, $00, $c4, $80, $40, $30, $0c, $33
    .byte $78, $e0, $e0, $c0, $00, $c0, $81, $06, $00, $10, $10, $20, $e6, $3c, $79, $e6
    .byte $00, $00, $00, $1c, $62, $de, $1f, $cf, $00, $00, $00, $1c, $62, $c0, $00, $00
    .byte $00, $01, $07, $0f, $3f, $1f, $ef, $01, $7e, $f9, $f7, $cf, $7f, $1f, $0f, $01
    .byte $3d, $fd, $fc, $e0, $fe, $ff, $ff, $f8, $3c, $fc, $fc, $e0, $fe, $ff, $ff, $f8
    .byte $c0, $e2, $e2, $62, $04, $84, $18, $e0, $00, $02, $02, $02, $04, $84, $18, $e0
    .byte $06, $0d, $0f, $0f, $07, $00, $35, $f7, $00, $00, $00, $05, $07, $00, $45, $07
    .byte $c0, $b0, $e0, $d0, $70, $f0, $ea, $1f, $00, $00, $00, $80, $00, $a0, $a4, $00
    .byte $76, $68, $ff, $f9, $ee, $c7, $c7, $07, $06, $60, $e0, $60, $00, $c0, $c0, $00
    .byte $5e, $e1, $cf, $97, $2f, $ce, $fc, $f8, $00, $01, $0f, $07, $03, $00, $30, $30
    .byte $07, $03, $03, $00, $01, $01, $03, $07, $00, $00, $00, $01, $00, $00, $00, $00
    .byte $c0, $c0, $e0, $20, $c0, $e0, $c0, $c0, $00, $00, $00, $c0, $20, $00, $00, $00
    .byte $0f, $0f, $02, $1c, $3c, $fc, $78, $18, $00, $00, $1c, $02, $00, $00, $00, $00
    .byte $f8, $78, $34, $0e, $0f, $0f, $0e, $1c, $00, $04, $08, $10, $00, $00, $00, $00
    .byte $06, $0d, $0f, $1f, $37, $30, $3d, $3f, $00, $00, $00, $15, $37, $30, $35, $27
    .byte $c0, $b0, $e0, $d0, $70, $f0, $ea, $1f, $00, $00, $00, $80, $00, $a8, $a4, $00
    .byte $16, $08, $1f, $19, $0e, $07, $07, $07, $06, $00, $00, $00, $00, $00, $00, $00
    .byte $5e, $e1, $cf, $97, $2f, $ce, $fc, $f8, $00, $01, $0f, $07, $03, $00, $30, $30
    .byte $0f, $0f, $02, $1c, $3c, $fc, $78, $18, $00, $00, $1c, $02, $00, $00, $00, $00
    .byte $f8, $78, $34, $0e, $0f, $0f, $0e, $1c, $00, $04, $08, $10, $00, $00, $00, $00
    .byte $46, $6d, $6f, $6f, $67, $60, $75, $7f, $40, $60, $60, $05, $07, $00, $65, $67
    .byte $c1, $b5, $e3, $d3, $73, $f7, $eb, $17, $01, $05, $03, $80, $00, $a0, $a3, $07
    .byte $6e, $38, $3f, $19, $0e, $0f, $0f, $0f, $66, $20, $20, $00, $00, $00, $00, $00
    .byte $5f, $fe, $dc, $84, $18, $e0, $c0, $c0, $0f, $1e, $1c, $00, $00, $00, $00, $00
    .byte $0e, $0e, $1c, $04, $38, $38, $78, $f0, $00, $00, $00, $18, $04, $00, $00, $00
    .byte $e0, $f0, $70, $60, $18, $1c, $1e, $0f, $00, $00, $00, $18, $20, $00, $00, $00
    .byte $00, $00, $00, $00, $0b, $16, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $40, $d0, $f0, $e8, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $1f, $0f, $32, $fb, $f7, $6b, $fc, $ff, $00, $05, $42, $0b, $07, $43, $e0, $e0
    .byte $f0, $fa, $2f, $56, $df, $bf, $7f, $e0, $80, $c4, $20, $42, $c7, $83, $63, $60
    .byte $f1, $ff, $77, $7c, $b8, $b8, $dc, $7c, $f0, $f0, $40, $00, $00, $08, $1c, $1c
    .byte $5c, $e0, $dc, $3c, $38, $78, $78, $fc, $40, $1e, $20, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $7e, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $01, $07, $07, $1d, $3f, $7c, $71, $e1, $02, $00, $04, $1c, $3e, $0c, $e0, $e0
    .byte $a9, $54, $7d, $fe, $fe, $fd, $fb, $53, $00, $00, $00, $00, $00, $01, $03, $03
    .byte $8c, $d7, $fb, $e6, $f8, $b8, $f8, $f8, $40, $20, $00, $00, $30, $98, $88, $88
    .byte $00, $03, $07, $07, $00, $00, $35, $77, $00, $04, $08, $08, $0f, $00, $05, $00
    .byte $00, $e0, $f0, $d0, $30, $b8, $dc, $12, $00, $00, $00, $20, $c0, $c0, $20, $20
    .byte $f6, $f8, $38, $1d, $0f, $c7, $c0, $04, $00, $00, $45, $a2, $40, $c0, $c0, $00
    .byte $0f, $7f, $ef, $ef, $f3, $c1, $31, $f2, $40, $80, $00, $00, $04, $0a, $34, $38
    .byte $05, $05, $03, $03, $01, $00, $01, $03, $00, $00, $00, $00, $00, $00, $01, $00
    .byte $70, $60, $f0, $f0, $f0, $e0, $e0, $e0, $00, $00, $00, $00, $00, $00, $00, $80
    .byte $1b, $1e, $3f, $3f, $1e, $fc, $78, $18, $00, $00, $00, $00, $00, $40, $20, $00
    .byte $68, $b4, $7e, $7e, $3f, $0f, $0e, $1c, $00, $00, $00, $00, $00, $00, $06, $08
    .byte $00, $03, $07, $07, $00, $30, $75, $77, $00, $04, $08, $08, $0f, $00, $05, $00
    .byte $00, $e0, $f0, $d0, $38, $bc, $d8, $16, $00, $00, $00, $20, $c0, $c0, $20, $20
    .byte $76, $38, $18, $0d, $0f, $07, $00, $04, $00, $04, $05, $02, $00, $00, $00, $00
    .byte $0f, $7f, $ef, $ef, $f3, $c1, $31, $f2, $40, $80, $00, $00, $04, $0a, $34, $38
    .byte $1b, $1f, $3f, $3f, $1e, $fc, $78, $18, $00, $00, $00, $00, $00, $40, $20, $00
    .byte $28, $f4, $7e, $7e, $3f, $0f, $0e, $1c, $00, $00, $00, $00, $00, $00, $06, $08
    .byte $00, $03, $07, $07, $00, $00, $35, $77, $00, $04, $08, $08, $0f, $00, $05, $00
    .byte $00, $e0, $f0, $d0, $30, $b8, $dc, $12, $00, $00, $00, $20, $c0, $c0, $20, $20
    .byte $76, $fb, $fb, $e7, $47, $07, $14, $18, $00, $03, $03, $0f, $17, $28, $00, $00
    .byte $0f, $7f, $77, $8f, $06, $84, $10, $f0, $40, $00, $00, $a0, $50, $28, $00, $00
    .byte $05, $05, $03, $03, $01, $00, $01, $03, $00, $00, $00, $00, $00, $00, $01, $00
    .byte $70, $60, $f0, $f0, $f0, $e0, $e0, $e0, $00, $00, $00, $00, $00, $00, $00, $80
    .byte $00, $00, $00, $00, $01, $07, $0f, $0e, $00, $00, $00, $00, $00, $00, $00, $01
    .byte $00, $00, $00, $00, $c0, $f0, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $0e, $16, $20, $21, $45, $f7, $fb, $c8, $11, $09, $57, $51, $25, $00, $00, $04
    .byte $f0, $ec, $04, $05, $a3, $ef, $c0, $18, $08, $10, $ea, $0a, $a4, $00, $01, $5a
    .byte $f4, $fa, $f4, $67, $47, $07, $3f, $1e, $02, $01, $08, $10, $28, $14, $0e, $0e
    .byte $38, $3c, $ff, $7f, $3f, $3e, $08, $36, $bd, $00, $00, $00, $00, $00, $14, $08
    .byte $00, $00, $00, $00, $00, $00, $00, $3d, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $00, $00, $00, $40
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c
    .byte $7e, $b8, $71, $46, $df, $47, $47, $e7, $01, $46, $88, $b0, $00, $28, $50, $e8
    .byte $00, $7b, $f7, $ee, $6d, $ef, $df, $07, $80, $00, $00, $00, $00, $00, $00, $00
    .byte $16, $7c, $f8, $30, $c6, $bc, $d0, $e0, $0e, $07, $03, $0c, $1e, $0f, $07, $00


LUT_BatObjCHR:
  .byte $00
  .byte $70
  .byte $78
  .byte $7C
  .byte $3E
  .byte $1F
  .byte $0D
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $60
  .byte $B0
  .byte $D9
  .byte $69
  .byte $33
  .byte $02
  .byte $0D
  .byte $3B
  .byte $80
  .byte $40
  .byte $21
  .byte $11
  .byte $0F
  .byte $0E
  .byte $0F
  .byte $3B
  .byte $00
  .byte $10
  .byte $10
  .byte $18
  .byte $08
  .byte $0C
  .byte $06
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $06
  .byte $07
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $04
  .byte $0E
  .byte $17
  .byte $02
  .byte $20
  .byte $30
  .byte $38
  .byte $38
  .byte $3A
  .byte $1E
  .byte $0F
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E2
  .byte $72
  .byte $3B
  .byte $1D
  .byte $0A
  .byte $76
  .byte $19
  .byte $80
  .byte $42
  .byte $22
  .byte $13
  .byte $09
  .byte $06
  .byte $76
  .byte $19
  .byte $60
  .byte $70
  .byte $78
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $05
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $60
  .byte $B2
  .byte $59
  .byte $2D
  .byte $16
  .byte $0A
  .byte $4D
  .byte $32
  .byte $80
  .byte $42
  .byte $21
  .byte $11
  .byte $0A
  .byte $06
  .byte $4D
  .byte $32
  .byte $00
  .byte $00
  .byte $18
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $10
  .byte $08
  .byte $04
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $72
  .byte $39
  .byte $1D
  .byte $0D
  .byte $02
  .byte $05
  .byte $18
  .byte $00
  .byte $82
  .byte $41
  .byte $21
  .byte $13
  .byte $0E
  .byte $05
  .byte $18
  .byte $00
  .byte $00
  .byte $00
  .byte $19
  .byte $0A
  .byte $00
  .byte $01
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $13
  .byte $07
  .byte $1F
  .byte $3F
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $B0
  .byte $60
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $E0
  .byte $04
  .byte $00
  .byte $01
  .byte $02
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $7F
  .byte $3F
  .byte $1E
  .byte $0C
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $A0
  .byte $30
  .byte $18
  .byte $0C
  .byte $02
  .byte $01
  .byte $00
  .byte $C0
  .byte $80
  .byte $40
  .byte $20
  .byte $10
  .byte $0E
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $03
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $0A
  .byte $07
  .byte $03
  .byte $00
  .byte $80
  .byte $40
  .byte $20
  .byte $1C
  .byte $0A
  .byte $07
  .byte $03
  .byte $00
  .byte $0C
  .byte $08
  .byte $06
  .byte $83
  .byte $E1
  .byte $40
  .byte $38
  .byte $18
  .byte $1D
  .byte $0D
  .byte $05
  .byte $0E
  .byte $1F
  .byte $BF
  .byte $46
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $20
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $00
  .byte $80
  .byte $40
  .byte $30
  .byte $0E
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $4E
  .byte $30
  .byte $0C
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $10
  .byte $08
  .byte $04
  .byte $06
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $20
  .byte $10
  .byte $08
  .byte $06
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1E
  .byte $31
  .byte $21
  .byte $22
  .byte $12
  .byte $01
  .byte $1C
  .byte $7F
  .byte $7F
  .byte $F1
  .byte $E1
  .byte $E3
  .byte $73
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $40
  .byte $20
  .byte $14
  .byte $0A
  .byte $05
  .byte $02
  .byte $01
  .byte $E0
  .byte $70
  .byte $38
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $01
  .byte $60
  .byte $C0
  .byte $14
  .byte $38
  .byte $58
  .byte $0C
  .byte $06
  .byte $03
  .byte $60
  .byte $E4
  .byte $F0
  .byte $20
  .byte $9C
  .byte $0E
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $03
  .byte $C0
  .byte $E0
  .byte $70
  .byte $38
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $80
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $78
  .byte $3C
  .byte $1E
  .byte $0E
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A0
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $03
  .byte $00
  .byte $00
  .byte $F8
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $73
  .byte $53
  .byte $23
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $2C
  .byte $4C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0A
  .byte $04
  .byte $0A
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $11
  .byte $00
  .byte $04
  .byte $00
  .byte $11
  .byte $00
  .byte $00
  .byte $00
  .byte $50
  .byte $20
  .byte $50
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $88
  .byte $00
  .byte $20
  .byte $00
  .byte $88
  .byte $00
  .byte $00
  .byte $00
  .byte $14
  .byte $08
  .byte $14
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $22
  .byte $00
  .byte $08
  .byte $00
  .byte $22
  .byte $00
  .byte $00
  .byte $00
  .byte $50
  .byte $20
  .byte $50
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $88
  .byte $00
  .byte $20
  .byte $00
  .byte $88
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $0E
  .byte $1E
  .byte $0E
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $05
  .byte $2F
  .byte $04
  .byte $04
  .byte $00
  .byte $00
  .byte $20
  .byte $70
  .byte $F8
  .byte $70
  .byte $20
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $20
  .byte $74
  .byte $20
  .byte $00
  .byte $60
  .byte $00
  .byte $08
  .byte $1C
  .byte $3E
  .byte $1C
  .byte $08
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $09
  .byte $5D
  .byte $08
  .byte $00
  .byte $08
  .byte $00
  .byte $20
  .byte $70
  .byte $F8
  .byte $70
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $74
  .byte $A0
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $04
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $70
  .byte $74
  .byte $00
  .byte $00
  .byte $0E
  .byte $20
  .byte $00
  .byte $20
  .byte $A8
  .byte $20
  .byte $50
  .byte $04
  .byte $54
  .byte $04
  .byte $38
  .byte $3A
  .byte $00
  .byte $00
  .byte $07
  .byte $27
  .byte $00
  .byte $00
  .byte $54
  .byte $10
  .byte $28
  .byte $02
  .byte $2A
  .byte $52
  .byte $25
  .byte $00
  .byte $00
  .byte $00
  .byte $44
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $38
  .byte $3A
  .byte $00
  .byte $00
  .byte $07
  .byte $07
  .byte $00
  .byte $10
  .byte $54
  .byte $10
  .byte $28
  .byte $02
  .byte $4A
  .byte $12
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $08
  .byte $00
  .byte $00
  .byte $04
  .byte $40
  .byte $00
  .byte $00
  .byte $10
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $42
  .byte $00
  .byte $00
  .byte $71
  .byte $74
  .byte $00
  .byte $00
  .byte $0E
  .byte $4E
  .byte $00
  .byte $20
  .byte $A8
  .byte $20
  .byte $50
  .byte $04
  .byte $55
  .byte $A4
  .byte $4A
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $33
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $33
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $0C
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $FF
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $CC
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $CC
  .byte $FF
  .byte $FF
  .byte $30
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $FF
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $63
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $63
  .byte $9C
  .byte $B1
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $FE
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $3C
  .byte $E1
  .byte $FF
  .byte $FF
  .byte $FF
  .byte $43
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $BF
  .byte $63
  .byte $BC
  .byte $73
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FE
  .byte $FC
  .byte $F8
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FE
  .byte $FF
  .byte $E2
  .byte $87
  .byte $D0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0E
  .byte $3F
  .byte $7F
  .byte $00
  .byte $00
  .byte $00
  .byte $67
  .byte $19
  .byte $91
  .byte $CE
  .byte $9F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $F9
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $EC
  .byte $CF
  .byte $36
  .byte $F9
  .byte $FF
  .byte $FF
  .byte $7F
  .byte $7F
  .byte $3C
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $7F
  .byte $BF
  .byte $1C
  .byte $C3
  .byte $1D
  .byte $63
  .byte $00
  .byte $FF
  .byte $FF
  .byte $FF
  .byte $FE
  .byte $38
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FF
  .byte $7E
  .byte $19
  .byte $C7
  .byte $FE
  .byte $2C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $04
  .byte $0B
  .byte $0B
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $20
  .byte $D0
  .byte $D0
  .byte $07
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0B
  .byte $0B
  .byte $04
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $E0
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $D0
  .byte $D0
  .byte $20
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $0F
  .byte $1F
  .byte $3F
  .byte $3F
  .byte $7F
  .byte $7F
  .byte $03
  .byte $0C
  .byte $13
  .byte $2F
  .byte $5F
  .byte $5F
  .byte $BF
  .byte $BF
  .byte $00
  .byte $C0
  .byte $F0
  .byte $F8
  .byte $FC
  .byte $FC
  .byte $FE
  .byte $FE
  .byte $C0
  .byte $30
  .byte $C8
  .byte $F4
  .byte $FA
  .byte $FA
  .byte $FD
  .byte $FD
  .byte $7F
  .byte $7F
  .byte $3F
  .byte $3F
  .byte $1F
  .byte $0F
  .byte $03
  .byte $00
  .byte $BF
  .byte $BF
  .byte $5F
  .byte $5F
  .byte $2F
  .byte $13
  .byte $0C
  .byte $03
  .byte $FE
  .byte $FE
  .byte $FC
  .byte $FC
  .byte $F8
  .byte $F0
  .byte $C0
  .byte $00
  .byte $FD
  .byte $FD
  .byte $FA
  .byte $FA
  .byte $F4
  .byte $C8
  .byte $30
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $03
  .byte $03
  .byte $00
  .byte $02
  .byte $00
  .byte $08
  .byte $02
  .byte $24
  .byte $00
  .byte $15
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $C0
  .byte $E0
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $88
  .byte $00
  .byte $90
  .byte $C8
  .byte $03
  .byte $05
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $06
  .byte $03
  .byte $2A
  .byte $00
  .byte $01
  .byte $08
  .byte $01
  .byte $00
  .byte $C0
  .byte $60
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $B0
  .byte $C4
  .byte $00
  .byte $20
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $04
  .byte $01
  .byte $00
  .byte $40
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $44
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $10
  .byte $00
  .byte $40
  .byte $00
  .byte $00
  .byte $00
  .byte $40
  .byte $02
  .byte $10
  .byte $00
  .byte $24
  .byte $00
  .byte $08
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $20
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $3E
  .byte $3E
  .byte $7F
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $38
  .byte $CC
  .byte $16
  .byte $BF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $0B
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7E
  .byte $FF
  .byte $3E
  .byte $0C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $9C
  .byte $3E
  .byte $DC
  .byte $30
  .byte $42
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $13
  .byte $00
  .byte $3E
  .byte $02
  .byte $38
  .byte $00
  .byte $00
  .byte $00
  .byte $40
  .byte $3E
  .byte $FF
  .byte $FF
  .byte $FE
  .byte $00
  .byte $00
  .byte $00
  .byte $9C
  .byte $D8
  .byte $3C
  .byte $FE
  .byte $7C
  .byte $0F
  .byte $03
  .byte $0F
  .byte $03
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $F1
  .byte $3C
  .byte $93
  .byte $7C
  .byte $03
  .byte $28
  .byte $00
  .byte $00
  .byte $FF
  .byte $FE
  .byte $FE
  .byte $FF
  .byte $FC
  .byte $C0
  .byte $00
  .byte $00
  .byte $FF
  .byte $FC
  .byte $FE
  .byte $5C
  .byte $0A
  .byte $36
  .byte $08
  .byte $00
  .byte $07
  .byte $1F
  .byte $3E
  .byte $7F
  .byte $DF
  .byte $FF
  .byte $DF
  .byte $DF
  .byte $07
  .byte $18
  .byte $21
  .byte $60
  .byte $A0
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $C0
  .byte $1E
  .byte $FF
  .byte $FE
  .byte $E1
  .byte $DE
  .byte $D0
  .byte $80
  .byte $40
  .byte $FE
  .byte $01
  .byte $01
  .byte $1F
  .byte $3E
  .byte $30
  .byte $DF
  .byte $CF
  .byte $A7
  .byte $70
  .byte $1F
  .byte $FF
  .byte $FF
  .byte $3F
  .byte $A0
  .byte $B0
  .byte $F8
  .byte $7F
  .byte $1F
  .byte $FF
  .byte $FF
  .byte $3F
  .byte $90
  .byte $A0
  .byte $20
  .byte $40
  .byte $FC
  .byte $FF
  .byte $FE
  .byte $80
  .byte $70
  .byte $60
  .byte $E0
  .byte $C0
  .byte $FC
  .byte $FF
  .byte $FE
  .byte $80
  .byte $00
  .byte $22
  .byte $72
  .byte $38
  .byte $0A
  .byte $00
  .byte $30
  .byte $02
  .byte $62
  .byte $D5
  .byte $A8
  .byte $50
  .byte $28
  .byte $40
  .byte $D0
  .byte $42
  .byte $00
  .byte $20
  .byte $68
  .byte $70
  .byte $E0
  .byte $40
  .byte $8E
  .byte $20
  .byte $30
  .byte $5C
  .byte $94
  .byte $CC
  .byte $B8
  .byte $42
  .byte $09
  .byte $02
  .byte $08
  .byte $09
  .byte $00
  .byte $01
  .byte $71
  .byte $61
  .byte $08
  .byte $00
  .byte $10
  .byte $35
  .byte $98
  .byte $60
  .byte $AB
  .byte $92
  .byte $63
  .byte $09
  .byte $40
  .byte $10
  .byte $8E
  .byte $86
  .byte $C0
  .byte $88
  .byte $04
  .byte $00
  .byte $09
  .byte $16
  .byte $05
  .byte $C9
  .byte $27
  .byte $68
  .byte $C2
  .byte $96
  .byte $80
  .byte $40
  .byte $20
  .byte $18
  .byte $1E
  .byte $0F
  .byte $0F
  .byte $07
  .byte $80
  .byte $40
  .byte $20
  .byte $10
  .byte $08
  .byte $06
  .byte $07
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $30
  .byte $F0
  .byte $E0
  .byte $F9
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $10
  .byte $20
  .byte $C0
  .byte $E0
  .byte $BF
  .byte $07
  .byte $0F
  .byte $0C
  .byte $10
  .byte $20
  .byte $00
  .byte $80
  .byte $87
  .byte $03
  .byte $04
  .byte $08
  .byte $00
  .byte $20
  .byte $00
  .byte $80
  .byte $E0
  .byte $F0
  .byte $F0
  .byte $78
  .byte $18
  .byte $04
  .byte $02
  .byte $01
  .byte $C0
  .byte $E0
  .byte $60
  .byte $10
  .byte $08
  .byte $04
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $03
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $02
  .byte $05
  .byte $05
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $20
  .byte $D0
  .byte $D0
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $05
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $D0
  .byte $20
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
