.segment "BANK_29"

.include "src/global-import.inc"

.export DrawOBSprite, PtyGen_DrawChars

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUT for battle sprite palettes  [$ECA4 :: 0x3ECB4]
;;
;;    each byte indicates which palette (or, more specifically, the entire attribute byte)
;;  is used for each class' battle sprite.  01 is the white/red palette (fighters, red mages, etc)
;;  00 is the blue/brown palette (black mage, thief, etc)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lutClassBatSprPalette:
  .byte $01,$00,$00,$01,$01,$00    ; unpromoted classes
  .byte $01,$01,$00,$01,$01,$00    ; promoted classes


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Out of Battle Sprite [$EBFC :: 0x3EC0C]
;;
;;    This will draw the battle sprite which represents the given party member.
;;  It will draw the class, and will draw him standing if healthy, hunched if poisoned,
;;  hunched and greyed if stoned, and will not draw him at all if dead.
;;
;;    This is specifically for out of battle sprites because in battle, other stances
;;  are possible.
;;
;;  IN:   A           = char index ($00,$40,$80, or $C0) of the character we want to draw
;;        spr_x,spr_y = coords to draw the sprite at
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawOBSprite_Exit:
    RTS

DrawOBSprite:
    TAX                   ; put character index in X
    LSR A                 ;  divide char index by 2
    STA tmp               ;  and put it in tmp  (tmp is now $00,$20,$40, or $60 -- 2 rows of tiles per character)

    LDA ch_class, X               ; get the char's class
    TAY                           ; use it as an index
    LDA lutClassBatSprPalette, Y  ;  to find which palette that class's battle sprite uses
    STA tmp+1                     ;  put palette in tmp+1

    LDA ch_ailments, X    ; get out of battle ailment byte
    BEQ @Standing         ;  if zero, no ailments... draw normal stance (standing upright)
    CMP #$01              ; if 1, character is dead
    BEQ DrawOBSprite_Exit ;  so don't draw any sprite, just exit
    CMP #$03              ; if 3, character is poisoned
    BEQ @Crouched         ;  draw in crouched position
    LDA #$03              ; otherwise (ailment byte = 2), character is stoned
    STA tmp+1             ;  change palette byte to 3 (stoned palette)
    BNE @Crouched         ;  always branches -- draw in crouched position

  @Crouched:              ; to draw sprite as crouched... at #$14 to the
    LDA #$14              ;   tile number to draw.

  @Standing:              ; to really draw sprite as standing, A must be 0 here
    CLC                   ; add tile offset to tmp
    ADC tmp               ;  tmp is now the start of the tiles which make up this sprite
    STA tmp               ;  and tmp+1 is the palette to use
    NOJUMP DrawSimple2x3Sprite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Simple 2x3 Sprite [$EC24 :: 0x3EC34]
;;
;;    Draws a simple 2x3 sprite (an out of battle sprite).  This is called
;;  by above DrawOBSprite routine, but is also called by the party generation screen
;;  since the party creation screen cannot use DrawOBSprite to draw its sprites
;;  (because DrawOBSprite examines characters stats and assumes the CHR for each
;;  character is loaded seperately)
;;
;;  IN:  tmp         = tile ID to start drawing from
;;       tmp+1       = attributes (palette) for all tiles of this sprite
;;       spr_x,spr_y = coords to draw sprite
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawSimple2x3Sprite:
    LDX sprindex       ; put sprite index in X

    LDA spr_x          ; get X coord
    STA oam+$03, X     ;  write to UL, ML, and DL sprites
    STA oam+$0B, X
    STA oam+$13, X
    CLC
    ADC #$08           ; add 8 to X coord
    STA oam+$07, X     ;  write to UR, MR, and DR sprites
    STA oam+$0F, X
    STA oam+$17, X

    LDA spr_y          ; get Y coord
    STA oam+$00, X     ; write to UL, UR sprites
    STA oam+$04, X
    CLC
    ADC #$08           ; add 8
    STA oam+$08, X     ; write to ML, MR sprites
    STA oam+$0C, X
    CLC
    ADC #$08           ; add another 8
    STA oam+$10, X       ; write to DL, DR sprites
    STA oam+$14, X

    LDA tmp            ; get the tile ID to draw
    STA oam+$01, X     ; draw UL tile
    CLC
    ADC #$01           ; increment, 
    STA oam+$05, X     ;  then draw UR
    CLC
    ADC #$01           ; inc again
    STA oam+$09, X     ;  then ML
    CLC
    ADC #$01
    STA oam+$0D, X     ;  then MR
    CLC
    ADC #$01
    STA oam+$11, X     ;  then DL
    CLC
    ADC #$01
    STA oam+$15, X     ;  then DR

    LDA tmp+1          ; get attribute byte
    STA oam+$02, X     ; and draw it to all 6 sprites
    STA oam+$06, X
    STA oam+$0A, X
    STA oam+$0E, X
    STA oam+$12, X
    STA oam+$16, X

    TXA                ; put sprite index in A
    CLC
    ADC #6*4           ; increment it by 6 sprites (4 bytes per sprite)
    STA sprindex       ; and write it back (so next sprite drawn is drawn after this one in oam)
    RTS                ;  and exit!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  PtyGen_DrawChars  [$9F4E :: 0x39F5E]
;;
;;    Draws the sprites for all 4 characters on the party gen screen.
;;  This routine uses DrawSimple2x3Sprite to draw the sprites.
;;  See that routine for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PtyGen_DrawChars:
    LDX #$00         ; Simply call @DrawOne four times, each time
    CALL @DrawOne     ;  having the index of the char to draw in X
    LDX #$10
    CALL @DrawOne
    LDX #$20
    CALL @DrawOne
    LDX #$30

  @DrawOne:
    LDA ptygen_spr_x, X   ; load desired X,Y coords for the sprite
    STA spr_x
    LDA ptygen_spr_y, X
    STA spr_y

    LDA ptygen_class, X   ; get the class
    TAX
    LDA lutClassBatSprPalette, X   ; get the palette that class uses
    STA tmp+1             ; write the palette to tmp+1  (used by DrawSimple2x3Sprite)

    TXA               ; multiply the class index by $20
    ASL A             ;  this gets the tiles in the pattern tables which have this
    ASL A             ;  sprite's CHR ($20 tiles is 2 rows, there are 2 rows of tiles
    ASL A             ;  per class)
    ASL A
    ASL A
    STA tmp           ; store it in tmp for DrawSimple2x3Sprite
    JUMP DrawSimple2x3Sprite


