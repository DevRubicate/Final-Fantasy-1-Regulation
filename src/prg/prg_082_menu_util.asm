.segment "PRG_082"

.include "src/global-import.inc"

.export DrawOBSprite, PtyGen_DrawChars, IsEquipLegal

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Armor Type LUT  [$BCD1 :: 0x3BCE1]
;;
;;   This LUT determines which type of armor each armor piece is.  The 4 basic types are:
;;
;;  0 = body armor
;;  1 = shield
;;  2 = helmet
;;  3 = gloves / gauntlets
;;
;;   Note the numbers themselves really don't signify anything.  They're only there to
;;  prevent a player from equipping multiple pieces of armor of the same type.  So you could
;;  have 256 different types of armor if you wanted (even though there are only 40 pieces of
;;  armor  ;P).
;;

lut_ArmorTypes:
  .byte    0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0        ; 16 pieces of body armor
  .byte    1,1,1,1,1, 1,1,1,1                        ; 9 shields
  .byte    2,2,2,2,2, 2,2                            ; 7 helmets
  .byte    3,3,3,3,3, 3,3,3                          ; 8 gauntlets


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Armor Permissions LUT  [$BFA0 :: 0x3BFB0]
;;
;;    Same deal as above, only for the armor instead of the weapons.

lut_ArmorPermissions:
  .WORD   $0000,$00C3,$06CB,$07CF,$07DF,   $06CB,$07CF,$07CF,$0FDF,$0FDF
  .WORD   $0000,$0000,$0000,$0000,$0FFD,   $0FFE,$07CF,$07CF,$07CF,$07CF
  .WORD   $07CF,$0FDF,$0FDF,$02CB,$0208,   $0000,$07CF,$07CF,$07CF,$0FDF
  .WORD   $0FCF,$0000,$0000,$07CF,$07CF,   $07CB,$0FCB,$07CB,$0FDF,$0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Weapon Permissions LUT   [$BF50 :: 0x3BF60]
;;
;;    Weapon permissions.  Each word corresponds to the equip permissions for
;;  a weapon.  See lut_ClassEquipBit for which bit corresponds to which class.
;;  Note again that bit set = weapon CANNOT be equipped by that class.

lut_WeaponPermissions:
  .WORD   $0DE7,$028A,$0400,$02CB,$074D,   $06CB,$07CF,$02CB,$0DE7,$028A
  .WORD   $05C7,$02CB,$06CB,$07CF,$02CB,   $028A,$06CB,$074D,$07CF,$06CB
  .WORD   $06CB,$02CB,$06CB,$06CB,$02CB,   $06CB,$02CB,$0504,$07CF,$0F6D
  .WORD   $0FAE,$0FCB,$0FFE,$0FCB,$0FCA,   $0FCD,$0FCB,$0FEF,$0FDF,$0000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Class Equip Bit LUT   [$BCB9 :: 0x3BCC9]
;;
;;    For weapon/armor equip permissions, each bit coresponds to a class.  If the class's
;;  bit is set for the permissions word... then that piece of equipment CANNOT be equipped
;;  by that class.  Permissions are stored in words (2 bytes) instead of just 1 byte because
;;  there are more than 8 classes
;;
;;    This lookup table is used to get the bit which represents a given class.  The basic
;;  formula is "equip_bit = ($800 >> class_id)".  So Fighter=$800, Thief=$400, etc
;;

lut_ClassEquipBit: ;  FT   TH   BB   RM   WM   BM      KN   NJ   MA   RW   WW   BW
   .WORD            $800,$400,$200,$100,$080,$040,   $020,$010,$008,$004,$002,$001

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
    LDX #0         ; Simply call @DrawOne four times, each time
    LDA ptygen_spr_x, X   ; load desired X,Y coords for the sprite
    STA spr_x
    LDA ptygen_spr_y, X
    STA spr_y
    LDX #0
    CALL @DrawOne     ;  having the index of the char to draw in X

    LDX #$10
    LDA ptygen_spr_x, X   ; load desired X,Y coords for the sprite
    STA spr_x
    LDA ptygen_spr_y, X
    STA spr_y
    LDX #1
    CALL @DrawOne

    LDX #$20
    LDA ptygen_spr_x, X   ; load desired X,Y coords for the sprite
    STA spr_x
    LDA ptygen_spr_y, X
    STA spr_y
    LDX #2
    CALL @DrawOne

    LDX #$30
    LDA ptygen_spr_x, X   ; load desired X,Y coords for the sprite
    STA spr_x
    LDA ptygen_spr_y, X
    STA spr_y
    LDX #3
  @DrawOne:

    LDA partyGenerationClass, X   ; get the class
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Is Equip Legal [$BC0A :: 0x3BC1A]
;;
;;     Checks to see if a specific class can equip a specific item.
;;  ALSO!  This routine modifies the item_box to de-equip all items of the same
;;  type that this character is equipping.  So if you test to see if a weapon is
;;  equippable, and it is, then all other weapons will be unequipped by this routine.
;;  Or if you try to equip a helmet.. all other helmets will be unequipped.
;;
;;  IN:            A = 1-based ID of item to check (0=blank item)
;;       equipoffset = indicates to check weapon or armor
;;            cursor = 4* the character ID whose class we're to check against
;;
;;  OUT:           C = set if equipping is illegal for this class (can't equip it)
;;                     clear if legal (can)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


IsEquipLegal:
    SEC
    SBC #$01          ; subtract 1 from the item ID to make it zero based
    ASL A             ; double it
    STA tmp           ; tmp = (2*item_id)

    LDA cursor        ; get the cursor
    ASL A
    ASL A
    ASL A
    ASL A
    AND #$C0          ; shift and mask to get usable character index
    TAX               ; put char index in X

    LDA ch_class, X   ; get the character's class
    ASL A             ; double it (2 bytes for equip permissions)
    TAX               ; and put in X to index the equip bit

    LDA lut_ClassEquipBit, X        ; get the class permissions bit position word
    STA tmp+4                       ;  and put in tmp+4,5
    LDA lut_ClassEquipBit+1, X
    STA tmp+5

    LDY equipoffset              ; now, see if we're dealing with weapons or armor
    CPY #ch_weapons-ch_stats
    BNE @Armor

  @Weapon:
    LDX tmp                        ; get the weapon id (*2)
    LDA lut_WeaponPermissions, X   ; use it to get the weapon permissions word (low byte)
    AND tmp+4                      ; mask with low byte of class permissions
    STA tmp                        ;  temporarily store result
    LDA lut_WeaponPermissions+1, X ; then do the same with the high byte of the permissions word
    AND tmp+5                      ;  mask with high byte of class permissions
    ORA tmp                        ; then combine with results of low mask
                          ;  here... any nonzero value will indicate that the item cannot be equipped

    CMP #$01              ; compare with 1 (any nonzero value will set C)
    BCC :+                ; if C is set (can't equip)....
      RTS                 ;   ... just exit.  otherwise...

:   LDA cursor            ; get the cursor (character id*4)
    AND #$0C              ; isolate the character bits
    TAX                   ; and put in X for indexing

    LDA item_box, X       ; unequip all weapons
    AND #$7F
    STA item_box, X
    LDA item_box+1, X
    AND #$7F
    STA item_box+1, X
    LDA item_box+2, X
    AND #$7F
    STA item_box+2, X
    LDA item_box+3, X
    AND #$7F
    STA item_box+3, X

    RTS                   ; then exit (C is still clear, indicating item can be equipped)

  @Armor:
    LDX tmp                       ; get the armor id (*2)
    LDA lut_ArmorPermissions, X   ; use it to get the armor permissions word
    AND tmp+4                     ;  and mask it with the class permissions word
    STA tmp
    LDA lut_ArmorPermissions+1, X
    AND tmp+5
    ORA tmp               ; and OR both high and low bytes of result together.  A nonzero result here indicates
                          ;  armor cannot be equipped

    CMP #$01              ; compare with 1 (any nonzero value sets C)
    BCC :+                ; if armor can't be equipped....
      RTS                 ; .. just exit.  Otherwise...

:   TXA                   ; get back the armor_id*2
    LSR A                 ; /2 to restore armor_id
    TAX                   ; and put back in X

    LDA lut_ArmorTypes, X ; use armor ID to index and find out what kind of armor it is (body, helmet, shield, etc)
    STA tmp+2             ; store armor type in tmp+2

    LDA cursor            ; store current cursor in tmp (seems dumb... we could just reference cursor directly)
    STA tmp
    AND #$0C              ; mask out the charater bits  (char ID * 4)
    STA tmp+1             ;  store that in tmp+1  (loop's item to unequip)

    LDY #$04              ; set Y (loop counter) to 4 (loop 4 times)

  @ArmorLoop:
    LDA tmp+1             ; get the loop item index
    CMP tmp               ; compare to the item we're trying to equip
    BEQ @ArmorSkip        ; if they're equal, skip over this item (seems pointless... the item we're checking wouldn't be equipped)

    LDX tmp+1             ; put loop item index in X
    LDA item_box, X       ;  use it to get that item from the item_box
    BPL @ArmorSkip        ; if that item is not equipped, skip it

    SEC                   ; otherwise (it is equipped), subtract $81 to get the armor ID
    SBC #$81
    TAX                   ; put armor ID in X
    LDA lut_ArmorTypes, X ; use that to look up what type of armor this is

    CMP tmp+2             ; compare that to the type of armor we're trying to equip
    BNE @ArmorSkip        ; if it doesn't match (different kind of armor), skip it

                          ; otherwise... it's a match!  need to unequip it.
    LDX tmp+1             ; get this loop item index in X
    LDA item_box, X       ; use it to get the item from the item box
    AND #$7F              ;    unequip it
    STA item_box, X       ;    then write it back

  @ArmorSkip:
    INC tmp+1             ; increment our loop item counter (to examine next item in the item box)
    DEY                   ; decrement our loop counter
    BNE @ArmorLoop        ; and keep looping until it expires

    CLC                   ; once we're done with all that, CLC to indicate the item can be equipped
    RTS                   ; and exit

