.segment "BANK_10"

.include "src/registers.inc"
.include "src/constants.inc"
.include "src/macros.inc"
.include "src/ram-definitions.inc"
.include "src/global-import.inc"

.import lut_2x2MapObj_Right, lut_2x2MapObj_Left, lut_2x2MapObj_Up, lut_2x2MapObj_Down, MapObjectMove

.export DrawMMV_OnFoot, Draw2x2Sprite, DrawMapObject, AnimateAndDrawMapObject, UpdateAndDrawMapObjects




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  UpdateAndDrawMapObjects  [$E4C7 :: 0x3E4D7]
;;
;;    Updates map objects (so townspeople, etc walk around the map), and draws
;;  all onscreen objects.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateAndDrawMapObjects:
    LDA framecounter    ; use low bit of frame counter to alternate between drawing
    LSR A               ; forwards and backwards.  This performs a form of OAM cycling which
    BCS @DoBackward     ; causes sprites to flicker rather than completely disappear if too many
                        ; are on a scanline
  @DoForeward:
    LDX #0                ; forward loop draws objects starting with the first, and counting up
   @ForewardLoop:
     LDA mapobj_id, X              ; get the object ID
     BEQ :+                        ; if it'd ID is nonzero, animate and draw it --
       CALL AnimateAndDrawMapObject ;   don't draw an object that doesn't exist
:    TXA                           ; add $10 to the object index 
     CLC
     ADC #$10
     TAX
     CMP #$F0                      ; and loop until all 15 objects drawn
     BCC @ForewardLoop
    JUMP MapObjectMove              ; then move a map object and exit

  @DoBackward:            ; backward loop is exactly the same, only it starts at the last object
    LDX #$E0              ;   first, and counts down
   @BackwardLoop:
     LDA mapobj_id, X
     BEQ :+
       CALL AnimateAndDrawMapObject
:    TXA
     SEC
     SBC #$10
     TAX
     BCS @BackwardLoop    ; loop until index wraps
    JUMP MapObjectMove     ; then move a map object and exit




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Animate And Draw Map Object  [$E688 :: 0x3E698]
;;
;;    Animates a map object's gradual motion between two tiles as it takes a step
;;  and draws the object to the screen (provided said object is visible onscreen)
;;
;;  IN:  X = index of desired object to animate/draw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AnimateAndDrawMapObject:
    LDA mapobj_pl, X       ; check to see if the object is being shoved by the player
    BNE @Move              ; if they are, keep them moving every frame.  Otherwise...

      LDA framecounter     ; use the low bit of the frame counter to move the object every
      AND #1               ; other frame (1 pixel every 2 frames, vs. 1 pixel per frame when shoved)
      BNE DrawMapObject    ; if an odd frame, skip over movement to the drawing stuff

  @Move:
    LDA mapobj_spdX, X       ; check X speed
    BEQ @Move_Y              ; if nonzero, move X, otherwise jump ahead to check Y speed

     CLC
     ADC mapobj_ctrX, X      ; add speed to move counter
     AND #$0F                ; mask low bits (16 pixels per tile)
     STA mapobj_ctrX, X      ; record new counter

     BNE DrawMapObject       ; if this did not complete the move, jump ahead to draw

      LDA #0                 ; full 16 pixels moved (step to next tile is completed)
      STA mapobj_spdX, X     ; zero the speed, and other things
      STA mapobj_face, X
      STA mapobj_pl, X

      LDA mapobj_physX, X    ; copy the physical X position to the graphic X position
      STA mapobj_gfxX, X

      JUMP DrawMapObject      ; and jump ahead to the drawing code


  @Move_Y:                   ; if x speed was zero...
    LDA mapobj_spdY, X       ; check y speed
    BEQ DrawMapObject        ; if it, too, is zero, no movement to be done, so jump ahead to drawing

     CLC                     ; otherwise add Y speed to Y movement counter
     ADC mapobj_ctrY, X
     AND #$0F                ; wrap and record it
     STA mapobj_ctrY, X

     BNE DrawMapObject       ; if the move has been completed....

      LDA #$00               ; ... zero speed and stuff
      STA mapobj_spdY, X
      STA mapobj_face, X
      STA mapobj_pl, X

      LDA mapobj_physY, X    ; and copy physical pos to graphical pos
      STA mapobj_gfxY, X

   ; no JUMP or RTS, code flows seamlessly into DrawMapObject



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Object  [$E6D8 :: 0x3E6E8]
;;
;;    Draws a map object if it is visible.
;;
;;  IN:  X = index of object to draw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapObject:
    LDA inroom           ; check inroom flag
    AND #1               ;   specifically the low bit (in normal rooms, but not locked rooms)
    BEQ @OutRoom

  @InRoom:
     LDA mapobj_flgs, X   ; check flags for this object
     BMI @DoDraw          ; if the sprite's inroom flag is set, draw it
     BPL @DontDraw        ;  otherwise, don't (hide it) -- always branches

  @OutRoom:
     LDA mapobj_flgs, X   ; same deal if the player is out of rooms -- check the object's flag
     BMI @DontDraw        ;  and don't draw if the object is in a room

  @DoDraw:
    LDA mapobj_ctrY, X    ; get this object's Y counter (fine Y scroll)
    CLC
    SBC move_ctr_y        ; offset it by the player's (screen's) fine Y scroll
    AND #$0F              ; wrap at 16
    STA tmp               ; and back up.  This is the fine Y pos of the sprite

    LDA mapobj_gfxY, X    ; get the graphic Y position (coarse Y scroll)
    SBC sm_scroll_y       ; offset by coarse screen scroll
    AND #$3F              ; wrap around edge of map.  This is now the coarse Y pos of the sprite
    CMP #$10              ; ensure coarse Y scroll puts the object on the actual screen
    BCS @DontDraw         ; if not, don't draw it

    ASL A                 ; multiply coarse scroll by 16
    ASL A
    ASL A
    ASL A
    ORA tmp               ; and add fine scroll to get the actual Y pos
    CMP #$E8              ; if the actual Y pos is off the bottom of the screen
    BCS @DontDraw         ; don't draw (this seems redundant)

    SBC #2                ; subtract !3! (not 2 -- C is clear here) from the Y coord to move it
    STA spr_y             ; off center a bit for aesthetics.  Set this as spr_y for future drawing


    LDA mapobj_ctrX, X    ; do all the same business, but with X coords to get the X position
    SEC
    SBC move_ctr_x
    AND #$0F
    STA tmp

    LDA mapobj_gfxX, X
    SBC sm_scroll_x
    AND #$3F
    CMP #$10
    BCS @DontDraw

    ASL A
    ASL A
    ASL A
    ASL A
    ORA tmp
    CMP #$F8              ; $F8 is off the right side of the screen, not E8 (screen is wider than it is tall)
    BCC @ObjectOnScreen

   @DontDraw:      ; it jumps to here is the object is off-screen or otherwise hidden
      SEC          ; I have no idea what the SEC is for -- success/failure indication comes to mind, but
      RTS          ;  there's no CLC on success, and C is never checked anyway.
                   ; exit if object is not to be drawn


   ; game reaches here if object is onscreen and visible (a sprite will definately be drawn)

  @ObjectOnScreen:
    STA spr_x            ; dump above calculated X coord into spr_x (spr_x,y are now properly calc'd)

    STX tmp+15           ; back up the object index so we can use X for something else
    LDA mapobj_pl, X     ; see if the player is talking to this object
    BMI @FacePlayer      ; if yes, jump ahead to face the player

    LDA mapobj_flgs, X   ; check the stationary flag
    AND #$40             ;  if the object is stationary, have them constantly walk in place
    BNE @WalkInPlace

    LDA mapobj_id, X          ; see if the object is a sky warrior (bat)
    CMP #OBJID_SKYWAR_FIRST
    BCC @NotSkyWar            ; if ID < first sky warrior, not sky warrior
    CMP #OBJID_SKYWAR_LAST+1
    BCS @NotSkyWar            ; if ID > last sky war (>= last+1), not sky war
                         ; otherwise, sky warriors, like bats, always walk in place
                         ;  so that they're always flapping their wings

  @WalkInPlace:
    LDA framecounter       ; for walking in place animations, use the frame counter to get
    LSR A                  ;  the image.  move bit 4 into relevent bit (toggles image every
    JUMP @PerformNormalDraw ;  16 frames)

  @NotSkyWar:
    CMP #OBJID_BAT       ; if not a sky warrior, check to see if it's an ordinary bat
    BEQ @WalkInPlace     ;  if yes, have it walk in place as well
                         ;  otherwise, do the normal walking animation

    LDA mapobj_ctrX, X   ; for normal walking animation, use the movement counter
    ORA mapobj_ctrY, X   ;  (x OR y, whichever is active) to get the image.
    ASL A                ; move bit 2 into relevent bit (toggles image every 4 pixels moved)

  @PerformNormalDraw:
    AND #$08                 ; isolate relevent bit for animation (previously calculated)
    CLC
    ADC mapobj_tsaptr, X     ; add that to the sprite's TSA pointer to have them face
    STA tmp                  ;   the right way
    LDA mapobj_tsaptr+1, X
    ADC #0
    STA tmp+1                ; tmp now points to the desired 2x2 sprite contruction table

    TXA                      ; set the tile additive for the sprite to the object index+$10
    CLC                      ; (first $10 tiles are for the player's mapman graphic, all other
    ADC #$10                 ;  map objects have their own $10 tiles)
    STA tmp+2

    CALL Draw2x2Sprite        ; Draw it!
    LDX tmp+15               ; restore the object index to X (was changed by above JSR)
    RTS                      ; and exit!

     ; game branches here if the object is to be drawn facing the player
     ;   (if the player is talking to this object)

  @FacePlayer:
    AND #$7F                 ; (mapobj_pl,X is currently in A) -- clear the 'face player' bit
    STA mapobj_pl, X         ; and write it back.

    TXA                      ; set tile additive to $10+object index
    CLC
    ADC #$10
    STA tmp+2

    LDA facing               ; get direction player is facing
    LSR A
    BCS @FacePlayer_Left     ; if player is facing right, face this object left
    LSR A
    BCS @FacePlayer_Right    ; if player is facing left, face this right
    LSR A
    BCS @FacePlayer_Up       ; if down, up
                             ; otherwise up, so face down
  @FacePlayer_Down:
    LDA #<lut_2x2MapObj_Down     ; low byte of pointer in A
    LDX #>lut_2x2MapObj_Down     ; high byte in X
    BNE @FacePlayer_Draw         ;  always branches
  @FacePlayer_Up:                  ;   and do all the same for up/right/left
    LDA #<lut_2x2MapObj_Up
    LDX #>lut_2x2MapObj_Up
    BNE @FacePlayer_Draw
  @FacePlayer_Right:
    LDA #<lut_2x2MapObj_Right
    LDX #>lut_2x2MapObj_Right
    BNE @FacePlayer_Draw
  @FacePlayer_Left:
    LDA #<lut_2x2MapObj_Left
    LDX #>lut_2x2MapObj_Left

  @FacePlayer_Draw:
    STA tmp               ; low byte previously in A (from above)
    STX tmp+1             ; high byte from X -- tmp is now pointing to the proper 2x2 table

    CALL Draw2x2Sprite     ; draw the sprite
    LDX tmp+15            ; restore X to the previously backed-up object index
    RTS                   ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawMMV_OnFoot  [$E2F0 :: 0x3E300]
;;
;;    Support routine for DrawPlayerMapmanSprite.  Draws the player
;;  'on foot' MapMan Vehicle (MMV) at given coords (ie: no vehicle)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMMV_OnFoot:
    LDA #0
    STA tmp+2                      ; zero the tile additive

    LDA #<lut_PlayerMapmanSprTbl   ; add the offset to the
    CLC                            ;  address of the sprite table (facing/animation changes)
    ADC tmp
    STA tmp                        ; and store in low byte of pointer

    LDA #>lut_PlayerMapmanSprTbl   ; include carry in high byte of pointer
    ADC #0
    STA tmp+1                      ; then draw it and exit

       ; no JUMP or RTS -- flows seamlessly into Draw2x2Sprite

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw 2x2 sprite  [$E301 :: 0x3E311]
;;
;;    Draws a given 2x2 tile sprite at given X,Y coords
;;
;;  IN:  spr_x,spr_y = desired X,Y coords of sprite (upper left corner)
;;       (tmp)       = pointer to sprite data table (see below)
;;       tmp+2       = tile addition
;;
;;    The given sprite data is drawn into oam starting on the next sprite indicated
;;  by 'sprindex'.  Afterwards, 'sprindex' is incremented by 16 (4 sprites) so the
;;  next sprite will be drawn after this one.
;;
;;    (tmp) must point to an 8-byte buffer containing tile and attribute information
;;  for each of the tiles that make up this 2x2 sprite.  This buffer must be in the following
;;  format:
;;
;;    byte 0 = tile number for UL sprite
;;    byte 1 = attribute byte for UL sprite
;;    byte 2 = tile number for DL
;;    byte 3 = attribute for DL
;;    bytes 4,5 = same for UR sprite
;;    bytes 6,7 = same for DR sprite
;;
;;  note that it goes UL,DL,UR,DR instead of UL,UR,DL,DR like you may expect
;;
;;  tmp+2 is added to every tile number so you can offset the tiles by a given amount.
;;    this allows the same buffer to be used for multiple sprites that have different
;;    tiles, but the same attribute info (like standard map objects, for example)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Draw2x2Sprite:
    LDY #0           ; zero Y (will be our index to the given buffer
    LDX sprindex     ; get the sprite index in X

    LDA spr_y        ; load up desired Y coord
    STA oam+$0, X    ;  set UL and UR sprite Y coords
    STA oam+$8, X
    CLC
    ADC #$08         ; add 8 to Y coord
    STA oam+$4, X    ;  set DL and DR Y coords
    STA oam+$C, X

    LDA spr_x        ; load up X coord
    STA oam+$3, X    ;  set UL and DL X coords
    STA oam+$7, X
    CLC
    ADC #$08         ; add 8
    STA oam+$B, X    ;  and set UR and DR X coords
    STA oam+$F, X

    LDA (tmp), Y     ; get UL tile from the buffer
    INY              ;  inc our buffer index
    CLC
    ADC tmp+2        ; add the tile offset to the tile ID
    STA oam+$1, X    ; write it to oam
    LDA (tmp), Y     ; get UL attribute byte from buffer
    INY              ;  inc buffer index
    STA oam+$2, X    ; write to oam

    LDA (tmp), Y     ; repeat this process again.. but for the DL sprite
    INY
    CLC
    ADC tmp+2
    STA oam+$5, X
    LDA (tmp), Y
    INY
    STA oam+$6, X

    LDA (tmp), Y     ; and again for the UR sprite
    INY
    CLC
    ADC tmp+2
    STA oam+$9, X
    LDA (tmp), Y
    INY
    STA oam+$A, X

    LDA (tmp), Y     ; and lastly for the DR sprite
    INY
    CLC
    ADC tmp+2
    STA oam+$D, X
    LDA (tmp), Y
    STA oam+$E, X

    LDA sprindex     ; now that all 4 sprites have been fully loaded
    CLC              ;  increment the sprite index by 16 (4 sprites)
    ADC #16
    STA sprindex
    RTS              ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Player mapman sprite tables [$E427 :: 0x3E437]
;;
;;     Sprite tables for use with Draw2x2Sprite.  Used for drawing
;;  the player mapman.  There are eight 8-byte tables, 2 tables for
;;  each direction (1 for each frame of animation).


lut_PlayerMapmanSprTbl:
  .BYTE $09,$40, $0B,$41, $08,$40, $0A,$41   ; facing right, frame 0
  .BYTE $0D,$40, $0F,$41, $0C,$40, $0E,$41   ; facing right, frame 1
  .BYTE $08,$00, $0A,$01, $09,$00, $0B,$01   ; facing left,  frame 0
  .BYTE $0C,$00, $0E,$01, $0D,$00, $0F,$01   ; facing left,  frame 1
  .BYTE $04,$00, $06,$01, $05,$00, $07,$01   ; facing up,    frame 0
  .BYTE $04,$00, $07,$41, $05,$00, $06,$41   ; facing up,    frame 1
  .BYTE $00,$00, $02,$01, $01,$00, $03,$01   ; facing down,  frame 0
  .BYTE $00,$00, $03,$41, $01,$00, $02,$41   ; facing down,  frame 1
