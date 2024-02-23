.segment "BANK_10"

.include "src/global-import.inc"

.import lut_2x2MapObj_Right, lut_2x2MapObj_Left, lut_2x2MapObj_Up, lut_2x2MapObj_Down, MapObjectMove, WaitForVBlank, ClearOAM, MusicPlay_NoSwap
.import DoMapDrawJob, BattleStepRNG, GetBattleFormation, MusicPlay, SM_MovePlayer, SetSMScroll, RedrawDoor

.export DrawMMV_OnFoot, Draw2x2Sprite, DrawMapObject, AnimateAndDrawMapObject, UpdateAndDrawMapObjects, DrawSMSprites, DrawOWSprites, DrawPlayerMapmanSprite, AirshipTransitionFrame
.export OW_MovePlayer, OWCanMove, OverworldMovement, SetOWScroll_PPUOn, MapPoisonDamage, SetOWScroll, StandardMapMovement



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld movement  [$C335 :: 0x3C345]
;;
;;    This moves the party on the overworld, and deals them poison damage
;;  when appropriate.  It also sets the scroll appropriately.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OverworldMovement:
    LDA move_speed        ; check movement speed
    BEQ SetOWScroll_PPUOn ; if zero (we're not moving), just set the scroll and exit

    CALL OW_MovePlayer     ; otherwise... process party movement

    LDA vehicle           ; check the current vehicle
    CMP #$01              ; are they on foot?
    BNE :+                ; if not, just exit
      JUMP MapPoisonDamage ; if they are... distribute poison damage
    :   
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Set OW Scroll  [$C346 :: 0x3C356]
;;
;;    Sets the scroll for the overworld map.  And optionally
;;  turns the screen on (seperate entry point)
;;
;;    Changes to SetOWScroll can impact the timing of some raster effects.
;;  See ScreenWipeFrame for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetOWScroll_PPUOn:
    LDA #$1E
    STA PPUMASK           ; turn the PPU on!

SetOWScroll:
    LDA NTsoft2000      ; get the NT scroll bits
    STA soft2000        ; and record them in both soft2000
    STA PPUCTRL           ; and the actual PPUCTRL

    LDA PPUSTATUS           ; reset PPU toggle

    LDA ow_scroll_x     ; get the overworld scroll position (use this as a scroll_x,
    ASL A               ;    since there is no scroll_x)
    ASL A
    ASL A
    ASL A               ; *16 (tiles are 16 pixels wide)
    ORA move_ctr_x      ; OR with move counter (effectively makes the move counter the fine scroll)
    STA PPUSCROLL           ; write this as our X scroll

    LDA scroll_y        ; get scroll_y
    ASL A
    ASL A
    ASL A
    ASL A               ; *16 (tiles are 16 pixels tall)
    ORA move_ctr_y      ; OR with move counter
    STA PPUSCROLL           ; and set as Y scroll

    RTS                 ; then exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Can Move  [$C47D :: 0x3C48D]
;;
;;    Checks to see if the player can move in the given direction.  If they can,
;;  it does a little additional work to prep everything for future action.
;;
;;  IN:      A = direction you're facing
;;
;;  OUT:     C = set if cannot move in this direction.  Cleared if can.
;;       tmp+2 = X coord moved to (assuming move was successful)
;;       tmp+3 = Y coord moved to (assuming move was successful)
;;    tileprop = first byte of properties of tile you tried to move to
;;
;;
;;    Additionally... if you can move in a direction (C cleared), the following information
;;  is output:
;;
;;  tileprop+1 = bit 7 set if teleport, with low bits determining teleport ID
;;
;;  tileprop+1 = bit 7 clear and bit 6 set if you are to engage in a random encounter
;;               after moving onto this tile
;;
;;  btlformation = if you are to engage in a random encounter, this is the battle formation
;;                 ID to engage in.
;;
;;  entering_shop = nonzero if moving onto the caravan
;;
;;  shop_id       = set to caravan's shop ID number if entering caravan.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OWCanMove:
    LSR A         ; determine which direction we're moving
    BCS @Right    ;   and branch accordingly
    LSR A
    BCS @Left
    LSR A
    BCS @Down

  @Up:
    LDX #7        ; for each direction, put x-coord add in X, and y-coord add in Y
    LDY #7-1      ; these will be added to the map scroll to determine player position.
    JUMP @Calc     ; Player is always 7 tiles from left, and 7 tiles from top of screen
                  ; -- so base is 7.  For up, you'd add one less to Y (to move up one tile)
  @Down:          ;  and so on for each directon.
    LDX #7
    LDY #7+1
    JUMP @Calc

  @Right:
    LDX #7+1
    LDY #7
    JUMP @Calc

  @Left:
    LDX #7-1
    LDY #7

  @Calc:
    TXA              ; get X add
    CLC
    ADC ow_scroll_x  ; add to it the OW scroll X
    STA tmp          ; store as low byte of map pointer
    STA tmp+2        ; and also throw in tmp+2 (uncompromised X coord)

    TYA              ; get Y add
    CLC
    ADC ow_scroll_y  ; add to it the OW scroll Y
    STA tmp+3        ; throw it in tmp+3 (uncompromised Y coord)
    AND #$0F         ; then mask with F to keep it within the portion of the map that's loaded
    ORA #>mapdata    ; and OR with high byte of mapdata pointer
    STA tmp+1        ; and write as high byte of pointer

    LDY #0                 ; zero Y for indexing
    LDA (tmp), Y           ; get the tile at desired coords

    ASL A                  ; double it and throw it in X (2 bytes per tile properties)
    TAX
    LDA tileset_prop, X    ; copy tile properties from tileset
    STA tileprop
    LDA tileset_prop+1, X
    STA tileprop+1

    LDA tileprop     ; get first byte of tile properties
    AND vehicle      ; AND with current vehicle to find out whether or not this vehicle can move there
    BEQ :+           ; if zero -- movement is allowed for this vehicle, jump ahead

      SEC            ; otherwise SEC to indicate failure (movement forbidden for this vehicle)
      RTS            ; and exit
    :   
    BIT tileprop+1   ; put bit 6 of tileprop+1 in V
    BVS @Fighting    ; if bit 6 was set (fighting occurs on this tile), jump ahead

    LDA vehicle      ; otherwise, get the vehicle
    CMP #$01         ; check to see if we're on foot
    BEQ @OnFoot      ; if we are, do additional checks

  @Success_1:        ; otherwise (not on foot) Success!
    CLC              ; CLC to indicate success
    RTS              ; and exit

  @OnFoot:
    LDA tileprop         ; get tile properties
    AND #OWTP_SPEC_MASK  ; mask out special bits
    BEQ @Success_1       ; if nothing special, success!

    CMP #OWTP_SPEC_CHIME ; is the chime necessary?
    BEQ @NeedChime       ; if yes... check to make sure we have it

    CMP #OWTP_SPEC_CARAVAN  ; is this the caravan?
    BNE @Success_1          ; if not, success!

  @Caravan:
    LDA game_flags+OBJID_FAIRY
    AND #$01             ; check the fairy map object to see if she's visible
    BNE @Success_2       ; if she is (bottle has been opened already), prevent entering caravan (exit now)

    LDA #$01             ; otherwise, we need to indicate the player is entering the caravan
    STA entering_shop    ; set entering_shop to nonzero
    LDA #70
    STA shop_id          ; shop ID=70 ($46) = caravan's shop ID

    @Success_2:
      CLC
      RTS

  @NeedChime:
    LDA item_chime       ; see if they have the chime in their inventory
    BNE @Success_1       ; if they do -- success
    SEC                  ; otherwise, failure
    RTS

  @Fighting:
    LDA #10              ; 10 / 256 chance of getting in a random encounter normally
    LDX vehicle          ; check the current vehicle
    CPX #$04             ; see if it's the ship
    BNE :+               ; if it is....
       LDA #3            ;   ... 3 / 256 chance instead  (more infrequent battles at sea)
    :
    STA tmp              ; store chance of battle in tmp
    CALL BattleStepRNG    ; get a random number for battle steps
    CMP tmp              ; compare it to our chance
    BCC @DoEncounter     ; if the random number < our odds -- do a random encounter

      LDA #0             ; otherwise, no random encounter
      STA tileprop+1     ; clear tileprop+1 to indicate no battle yet
      CLC                ; CLC for success
      RTS                ; and exit

  @DoEncounter:
    LDA tileprop+1       ; find out which type of counter we're to do
    AND #$03             ;   by checking the low 2 bytes of tileprop+1

    BEQ @LandDomain      ; if 0, get battle from land domain

    CMP #2
    BEQ @SeaDomain       ; if 2, get battle from sea domain
                         ;   else, get from river domain

   ;; Note that river and land domains just add 7 to the scroll to get
   ;;  player position... however this gets the player's position BEFORE
   ;;  the move.  So if you get in a battle just as you cross a domain boundary,
   ;;  the battle formation will be chosen from the domain you're leaving, rather
   ;;  than the domain you're entering.  Some might say that's BUGGED -- especially
   ;;  when you consider the ACTUAL player position has already been recorded to tmp+2
   ;;  tmp+3 -- so it could just load those and not do any math.

  @RiverDomain:
    LDA ow_scroll_y      ; get OW Y scroll
    CLC
    ADC #7               ; add 7 to get player position

    ASL A                ; rotate bit 7 ($80) into bit 0 ($01)
    ROL A

    AND #$01             ; isolate bit 1
    ORA #$40             ; and add $40 to it  (ie:  domain $40 for upper half of map, $41 for lower half)
    @gotoGetBattleFormation:
    JUMP GetBattleFormation

  @SeaDomain:
    LDA #$42                ; all of the world's sea uses the same domain:  $42
    BNE @gotoGetBattleFormation  ; always branches


   ;; For land domains... the entire map is divided into an 8x8 grid.  Each element in this
   ;;  grid has it's own domain -- and consists of 32x32 map tiles
  @LandDomain:
    LDA ow_scroll_x    ; get X scroll
    CLC
    ADC #$07           ; add 7 to get player X coord
    ROL A              ; rotate left by 4
    ROL A              ;   which ultimately is just a shorter way
    ROL A              ;   of right-shifting by 5 (high 3 bits become the low 3 bits)
    ROL A
    AND #%00000111     ; mask out the low 3 bits
    STA tmp            ; and write to tmp.  This is the column of the domain grid

    LDA ow_scroll_y    ; get Y scroll
    CLC
    ADC #$07           ; add 7 to get player Y coord
    LSR A              ; right shift by 2
    LSR A
    AND #%00111000     ; and mask out the high bits -- this is the row of the domain grid
    ORA tmp            ; OR with column for the desired domain.
                       ;  A is now the desired domain number
    JUMP GetBattleFormation


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Move Right  [$C36C :: 0x3C37C]
;;
;;    See OW_MovePlayer for details
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


OWMove_Right:
    LDA mapdraw_job        ; is there a draw job to do?
    BEQ @NoJob             ; if not... no job
      CALL DoMapDrawJob     ; otherwise, do the job

  @NoJob:
    CALL SetOWScroll_PPUOn  ; turn on PPU, set scroll

    LDA move_ctr_x         ; add movement speed
    CLC                    ;  to our X move counter
    ADC move_speed
    AND #$0F               ; mask low bits to keep within a tile
    BEQ @FullTile          ; if result is zero, we've moved a full tile

    STA move_ctr_x         ; otherwise, simply write back the counter
    RTS                    ;  and exit

  @FullTile:
    STA move_speed         ; after moving a full tile, zero movement speed
    STA move_ctr_x         ; and move counter

    LDA ow_scroll_x        ; +1 to our overworld scroll X
    CLC
    ADC #$01
    STA ow_scroll_x

    AND #$10               ; get nametable bit of scroll ($10=use nt@$2400, $00=use nt@PPUCTRL)
    LSR NTsoft2000         ; shift out and discard old NTX scroll bit
    CMP #$10               ; sets C if A=$10 (use nt@$2400).  clears C otherwise
    ROL NTsoft2000         ; shift C into NTX scroll bit (indicating the proper NT to use)

    RTS                    ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Move Left  [$C396 :: 0x3C3A6]
;;
;;    See OW_MovePlayer for details
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OWMove_Left:
    LDA mapdraw_job        ; is there a draw job to do?
    BEQ @NoJob             ; if not... no job
      CALL DoMapDrawJob     ; otherwise... do the job

  @NoJob:
    CALL SetOWScroll_PPUOn  ; set scroll and turn PPU on

    LDA move_ctr_x         ; get the move counter.  If zero, we need to move one tile to left
    BNE @NoTileChg         ;   otherwise we don't need to change tiles

    LDA ow_scroll_x        ; subtract 1 from the OW X scroll
    SEC
    SBC #$01
    STA ow_scroll_x

    AND #$10               ; get the nametable bit ($10=use nt@$2400... $00=use nt@PPUCTRL)
    LSR NTsoft2000         ; shift out and discard old NTX scroll bit
    CMP #$10               ; sets C if A=$10 (use nt@$2400).  clears C otherwise
    ROL NTsoft2000         ; shift C into NTX scroll bit (indicating the proper NT to use)

    LDA move_ctr_x         ; get the move counter

  @NoTileChg:
    SEC                    ; A=move counter at this point
    SBC move_speed         ; subtract the move speed from the counter
    AND #$0F               ; mask it to keep it in the tile
    BEQ @FullTile          ; if zero, we've moved a full tile

    STA move_ctr_x         ; otherwise, just write the move counter back
    RTS                    ; and exit

  @FullTile:
    STA move_speed         ; if we've moved a full tile, zero our speed
    STA move_ctr_x         ; and our counter
    RTS                    ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Move Player  [$C3C4 :: 0x3C3D4]
;;
;;    This moves the player's sprite in the direction they're facing
;;  at their current movement speed.  It also draw the necessary map
;;  drawing jobs when apppropriate.
;;
;;    For vertical movement... drawing jobs are performed halfway between tiles
;;  (8 pixels in).  For Horizontal movement, they're performed immediately.  The reason
;;  for this is because the game is using Vertical mirroring, which means changes made to the
;;  top of the screen can be seen on the bottom.  So drawing between tiles when moving vertically
;;  minimizes garbage appearing at the top or bottom of the screen.  No such caution is needed
;;  (or desired) for horizontal movement, because the extra nametable on the X axis prevents
;;  such garbage from appearing altogether.
;;
;;    Note that most of the routines this jumps to are jumped to with branches
;;  so this routine must be relatively close to all those routines.
;;
;;    This routine will set the PPU scroll BEFORE doing additional scrolling.  Basically
;;  meaning that the scroll you see on-screen is 1 frame behind what the game is
;;  tracking.  This is intentional, because all sprites also have this 'delay'... because
;;  OAM has to wait until next frame before it can be DMA'd.  So this keeps the BG
;;  and sprites both in sync by keeping them both a frame behind (otherwise, sprites
;;  would appear to shift over 1 pixel during scrolling).
;;
;;    The scroll must be set AFTER all drawing is complete.  This is why each routine
;;  jumped to here calls SetOWScroll_PPUOn instead of this routine just calling it once.
;;  Since each routine needs to do drawing jobs under specific conditions... those drawing
;;  jobs must be done BEFORE the scroll is set (has to do with how NES scrolling works).
;;  Therefore, once this routine is called, the scroll is set, so no further drawing
;;  can be done this frame!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OW_MovePlayer:
    LDA facing          ; check to see which way we're facing
    LSR A
    BCS OWMove_Right    ; moving right
    LSR A
    BCS OWMove_Left     ; moving left
    LSR A
    BCS OWMove_Down     ; moving down
    JUMP OWMove_Up       ; moving up

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Move Down  [$C3D2 :: 0x3C3E2]
;;
;;    See OW_MovePlayer for details
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OWMove_Down:
    LDA mapdraw_job     ; see if a drawing job needs to be performed
    BEQ @NoJob          ; if not... skip ahead

    CMP #$01            ; if drawing job=1 (attributes)...
    BEQ @Job            ;   do it right away

    LDA move_ctr_y      ; otherwise, only do the job if we're halfway between tiles
    CMP #$08            ;   (8 pixels between the move)
    BNE @NoJob          ; if not 8 pixels between the move... don't do the job

  @Job:
    CALL DoMapDrawJob       ; do the map drawing job, then proceed normally

  @NoJob:
    CALL SetOWScroll_PPUOn  ; turn the PPU on, and set the appropriate overworld scroll

    LDA move_ctr_y         ; get the Y move counter
    CLC
    ADC move_speed         ; add our movement speed to it
    AND #$0F               ; and mask it to keep it within the current tile
    BEQ @FullTile          ; if it's now zero, we've moved 1 full tile

    STA move_ctr_y         ; otherwise, simply record the new move counter
    RTS                    ; and exit

  @FullTile:               ; if we've moved a full tile
    STA move_speed         ; zero our move speed (A=0 here) to stop moving
    STA move_ctr_y         ; also zero our move counter

    INC ow_scroll_y        ; update the overworld scroll

    LDA scroll_y           ; and update our map scroll
    CLC
    ADC #1                 ;   by adding 1 to it
    CMP #$0F
    BCC :+
      SBC #$0F             ;   and make it wrap from E->0  (nametables are only 15 tiles tall.. not 16)
:   STA scroll_y           ; write it back
    RTS                    ; and exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Overworld Move Up  [$C406 :: 0x3C416]
;;
;;    See OW_MovePlayer for details
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OWMove_Up:
    LDA mapdraw_job        ; see if a job needs to be done
    BEQ @NoJob             ; if not, no job

    CMP #$01
    BEQ @Job               ; if job=1, do it right away

    LDA move_ctr_y         ; otherwise, only do it when we're halfway between tiles
    CMP #$08
    BNE @NoJob

  @Job:
    CALL DoMapDrawJob

  @NoJob:
    CALL SetOWScroll_PPUOn  ; turn PPU on and set scroll

    LDA move_ctr_y         ; get move counter
    BNE @NoTileChg         ; if it's zero, we need to change tiles.  Otherwise, skip ahead

    DEC ow_scroll_y        ; dec the OW scroll

    LDA scroll_y           ; subtract 1 from the map scroll Y
    SEC
    SBC #$01
    BCS :+
      ADC #$0F             ; and have it wrap from 0->E
:   STA scroll_y           ; then write it back

    LDA move_ctr_y         ; get move counter again

  @NoTileChg:
    SEC                    ; here, A=move counter
    SBC move_speed         ; subtract the movement speed from the counter
    AND #$0F               ; mask it to keep it in a 16x16 tile 
    BEQ @FullTile          ; if it's now zero... we've moved a full tile

    STA move_ctr_y         ; otherwise, simply write back the move counter
    RTS                    ;  and exit

  @FullTile:
    STA move_speed         ; if we moved a full tile, zero the move speed (stop player from moving)
    STA move_ctr_y         ; and zero the move counter
    RTS                    ; then exit


















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawSMSprites  [$E40F :: 0x3E41F]
;;
;;    Draws all sprites for standard maps, and updates/animates
;;  map objects (townspeople, etc).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DrawSMSprites:
    LDY #1
    CALL DrawPlayerMapmanSprite    ; draw the player mapman sprite (on foot -- no ship/airship/etc)
    NOJUMP UpdateAndDrawMapObjects   ; then update and draw all map objects, and exit!


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
      NOJUMP DrawMapObject




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
    NOJUMP Draw2x2Sprite

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
  .byte $09,$40, $0B,$41, $08,$40, $0A,$41   ; facing right, frame 0
  .byte $0D,$40, $0F,$41, $0C,$40, $0E,$41   ; facing right, frame 1
  .byte $08,$00, $0A,$01, $09,$00, $0B,$01   ; facing left,  frame 0
  .byte $0C,$00, $0E,$01, $0D,$00, $0F,$01   ; facing left,  frame 1
  .byte $04,$00, $06,$01, $05,$00, $07,$01   ; facing up,    frame 0
  .byte $04,$00, $07,$41, $05,$00, $06,$41   ; facing up,    frame 1
  .byte $00,$00, $02,$01, $01,$00, $03,$01   ; facing down,  frame 0
  .byte $00,$00, $03,$41, $01,$00, $02,$41   ; facing down,  frame 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw OW Sprites   [$E225 :: 0x3E235]
;;
;;    Draws all sprites for the overworld
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DrawOWSprites:
    LDY vehicle            ; put current vehicle in Y
    CPY #$08
    BEQ @InAirship         ; check to see if the player is in the airship
    CPY #$04
    BEQ @InShip            ; or the ship
    CPY #$02
    BEQ @InCanoe           ; or the canoe
                           ; if none of those, they're on foot.

  @OnFoot:
    CALL DrawPlayerMapmanSprite  ; draw the mapman sprite

    LDA inforest         ; check to see if we're in the forest
    BEQ @NotInForest     ; if not, skip ahead

      LDA sprindex       ; if we are in a forest... hide the bottom half of the player by
      SEC                ;   getting the sprite index
      SBC #$0C           ; subtract $C and put it in X (this will point it to the 
      TAX                ;   2nd of the 4 8x8 sprites drawn -- DL player mapman sprite)

      LDA #$F4           ; new Y coord = $F4 (offscreen -- removes the sprite)
      STA oam+$00, X     ;  hide DL sprite
      STA oam+$08, X     ;  hide DR sprite

  @NotInForest:
    LDA airship_vis      ; check airship visibility
    BEQ @HideAirship     ; if not visible, skip ahead and don't draw the airship

    CMP #$1F             ; if visibility = $1F -- airship is fully visible
    BCS @ShowAirship     ; so skip ahead and draw it
                         ;  otherwise the airship is "flashing" because you just
                         ;  raised it with the floater.
    INC airship_vis      ; increment the visibility counter
    LSR A                ; shift bit 1 into C
    LSR A                ;  and only draw it if bit 1 is clear
    BCS @HideAirship     ;  effectively toggles visibility every 2 frames to make it flash

  @ShowAirship:
    CALL DrawOWObj_Airship
  @HideAirship:
    CALL DrawOWObj_Ship
    JUMP DrawOWObj_BridgeCanal

  @InAirship:                    ; if in the airship, draw everything normally
    CALL DrawPlayerMapmanSprite   ;  except do NOT draw the airship
    CALL DrawOWObj_Ship
    JUMP DrawOWObj_BridgeCanal

  @InShip:                       ; same deal if in ship -- don't draw the ship
    CALL DrawOWObj_BridgeCanal    ; but also... draw the bridge and canal OVER the mapman sprite
    LDY #$04                     ;   this makes it so the ship goes under the bridge rather than over
    CALL DrawPlayerMapmanSprite   ; reload Y with the vehicle (4=ship) before calling this
    JUMP DrawOWObj_Airship

  @InCanoe:                      ; canoe is nothing special.. just draw all the sprites
    CALL DrawPlayerMapmanSprite
    CALL DrawOWObj_Ship
    CALL DrawOWObj_Airship
    JUMP DrawOWObj_BridgeCanal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Overworld Object routines  [$E373 :: 0x3E383]
;;
;;    Each of these routines draws a certain overworld object
;;  at its current coords.  There are three distinct routines, one for the
;;  ship, one for the airship, and one for both the bridge and canal.
;;
;;    Note that the ship/airship are for when those items are not acting
;;  as the current vehicle (ie:  it's the docked ship, and the landed airship --
;;  when the vehicle is not in use).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;
 ;;  Ship
 ;;

DrawOWObj_Ship:
    LDA ship_vis            ; get ship visibility flag
    BEQ DrawOWObj_Exit      ; if zero, ship isn't available yet -- so don't draw it

    LDX ship_x              ; get x coord in X
    LDY ship_y              ; get y coord in Y
    CALL ConvertOWToSprite   ; convert those coords to sprite coords
    BCS DrawOWObj_Exit      ; if sprite out of bounds, don't draw it

    LDA #0
    STA tmp                 ; no additional offset to sprite table
    LDA #$20                ; tile additive of $20 (ship graphics)
    JUMP Draw2x2Vehicle      ; draw the vehicle, and exit

 ;;
 ;;  Airship
 ;;

DrawOWObj_Airship:
    LDA airship_vis         ; get airship visibility flag
    BEQ DrawOWObj_Exit      ; if zero, airship isn't available yet -- so don't draw it

    LDX airship_x           ; get x coord in X
    LDY airship_y           ; and y coord in Y
    CALL ConvertOWToSprite   ; convert those coords to sprite coords
    BCS DrawOWObj_Exit      ; if sprite out of bounds, don't draw it

    LDA #0
    STA tmp                 ; no additional offset to sprite table
    LDA #$38                ; tile additive of $38 (airship graphics)
    JUMP Draw2x2Vehicle      ; draw the vehicle, and exit

 ;;
 ;;  a common exit shared by these routines
 ;;

DrawOWObj_Exit:
    RTS

 ;;
 ;;  Bridge and Canal
 ;;

DrawOWObj_BridgeCanal:
    LDA bridge_vis          ; check if bridge is visible
    BEQ @Canal              ; if not.. skip it and proceed to canal

    LDX bridge_x            ; get and convert X,Y coords
    LDY bridge_y
    CALL ConvertOWToSprite
    BCS @Canal              ; if out of bounds, skip to canal

    LDA #$08                ; otherwise, draw with table offset $08 (bridge)
    CALL @Draw               ;  then proceed to canal

  @Canal:
    LDA canal_vis           ; if not visible
    BEQ DrawOWObj_Exit      ;    exit

    LDX canal_x
    LDY canal_y
    CALL ConvertOWToSprite
    BCS DrawOWObj_Exit      ; if coords are out of bounds, exit

    LDA #$10                ; otherwise, draw iwth table offset $10 (canal)

  @Draw:
    CLC
    ADC #<lut_OWObjectSprTbl  ; add table offset (in A) to low byte of table
    STA tmp                   ; and store in our pointer
    LDA #>lut_OWObjectSprTbl
    ADC #0
    STA tmp+1                 ; include carry in high byte of pointer

    LDA #$10                  ; set the tile additive to $10
    STA tmp+2

    JUMP Draw2x2Sprite         ; draw the sprite, and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  OW object sprite table  [$E4A7 :: 0x3E4B7]
;;
;;    Same, but for the misc overworld objects (airship shadow, bridge, and canal)
;;  Only one 8-byte table per object, since facing isn't applicable, and there's
;;  no animation involved
;;
;;    Really.. the game SHOULD'VE just used 1 8-byte table... since all 3 tables
;;  are identical except for the tile ID used (but that can be adjusted with the
;;  tile additive -- I mean that's exactly what it's for, right?)
;;
;;    Also, somewhat stupidly, the tile IDs in these tables aren't even correct.
;;  to get the right graphics you have to use a tile additive of $10

lut_OWObjectSprTbl:
  .byte $00,$03, $02,$03, $01,$03, $03,$03     ; airship shadow
  .byte $04,$03, $06,$03, $05,$03, $07,$03     ; bridge
  .byte $08,$03, $0A,$03, $09,$03, $0B,$03     ; canal










;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Vehicle mapman sprite tables  [$E467 :: 0x3E477]
;;
;;    Same as above, but for OW vehicles (canoe, ship, airship)
;;
;;    Tile IDs in this table are not usable as-is.  For proper vehicle
;;  tiles to be drawn, the following additives must be used:
;;
;;   canoe   = $50
;;   ship    = $20
;;   airship = $38


lut_VehicleSprTbl:
  .byte $11,$42, $13,$42, $10,$42, $12,$42   ; R 0
  .byte $15,$42, $17,$42, $14,$42, $16,$42   ; R 1
  .byte $10,$02, $12,$02, $11,$02, $13,$02   ; L 0
  .byte $14,$02, $16,$02, $15,$02, $17,$02   ; L 1
  .byte $00,$02, $02,$02, $01,$02, $03,$02   ; U 0
  .byte $04,$02, $06,$02, $05,$02, $07,$02   ; U 1
  .byte $08,$02, $0A,$02, $09,$02, $0B,$02   ; D 0
  .byte $0C,$02, $0E,$02, $0D,$02, $0F,$02   ; D 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Convert Overworld Coord to Sprite Coord   [$E3DF :: 0x3E3EF]
;;
;;     Converts X/Y overworld map coords to X/Y sprite coords based
;;  on the current scroll.
;;
;;  IN:   X, Y
;;
;;  OUT:  spr_x, spr_y
;;                   C = set if sprite is not visible on current screen
;;                       clear if visible
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ConvertOWToSprite:
    TYA                 ; put the Y coord in A
    SEC
    SBC ow_scroll_y     ; subtract the current ow scroll
    CMP #$10            ; see if result is >= $10
    BCS @OutOfBounds    ; if it is -- out of bounds

    ASL A               ; multiply that tile by 16
    ASL A               ;   to get the pixel (16 pixels per tile)
    ASL A
    ASL A

    CLC                 ; CLEAR carry (subtract an additional 1 in the folling SBC)
                        ;   this is because NES sprites are drawn 1 scanline below their specified
                        ;   Y coord.

    SBC move_ctr_y      ; then subtract the Y move counter (fine Y scroll)
    CMP #$EC            ; if >= $EF, out of bounds
    BCS @OutOfBounds

    STA spr_y           ; otherwise, Y coord is in bounds.  record it
                        ;   then do the same for X...

    TXA                 ; put X coord in A
    SEC
    SBC ow_scroll_x     ; subtract OW scroll
    CMP #$10            ; out of bounds if >= $10
    BCS @OutOfBounds

    ASL A               ; multiply by 16
    ASL A
    ASL A
    ASL A

    SEC                 ; SEC (no additional 1 this time)
    SBC move_ctr_x      ; subtract fine X scroll
    BCC @OutOfBounds    ; if that moved the sprite off the left of the screen, out of bounds

    CMP #$F8            ; otherwise, if >= $F8
    BCS @OutOfBounds    ;  out of bounds

    STA spr_x           ; otherwise.. in bounds!  record X coord
    CLC                 ; CLC to indicate in bounds
    RTS                 ; and exit

  @OutOfBounds:
    SEC                 ; SEC to indicate out of bounds
    RTS                 ; and exit









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawMMV_Ship    [$E2D5 :: 0x3E2E5]
;;
;;    Support routine for DrawPlayerMapmanSprite.  Draws the ship MapMan Vehicle (MMV)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMMV_Ship:
    LDA #$20
    STA tmp+2               ; tile additive = $20 (ship graphics)
    JUMP Draw2x2Vehicle_Set  ; draw the 2x2 vehicle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawMMV_Canoe    [$E2DC :: 0x3E2EC]
;;
;;    Support routine for DrawPlayerMapmanSprite.  Draws the canoe MapMan Vehicle (MMV)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMMV_Canoe:
    LDA #$50          ; tile additive = $50 (canoe graphics)
    NOJUMP Draw2x2Vehicle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw 2x2 Vehicle  [$E2DE :: 0x3E2EE]
;;
;;  IN:  tmp         = sprite table pointer offset
;;       spr_x,spr_y = sprite coords
;;       A           = tile additive (Draw2x2Vehicle only)
;;       tmp+2       = tile additive (Draw2x2Vehicle_Set only)
;;
;;    The tile additive should be one of the following to draw the desired vehicle:
;;   canoe   = $50
;;   ship    = $20
;;   airship = $38
;;
;;    The two entry points just look for the tile additive in different places.  Other
;;  than that, they're the same
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Draw2x2Vehicle:
    STA tmp+2                 ; store tile additive (in A) to tmp+2
                              ;  then proceed to 'Set' version of routine
    NOJUMP Draw2x2Vehicle_Set

Draw2x2Vehicle_Set:
    LDA tmp                   ; add low byte of sprite table
    CLC                       ; to our offset
    ADC #<lut_VehicleSprTbl
    STA tmp                   ; and store as low byte of our pointer

    LDA #>lut_VehicleSprTbl   ; then inclue any carry in the high byte of our pointer
    ADC #0
    STA tmp+1

    JUMP Draw2x2Sprite         ; draw the 2x2 sprite, then exit









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Player Mapman sprite  [$E281 :: 0x3E291]
;;
;;    Draws the mapman sprite for the player.  Handles animations
;;  and vehicle changes as well.
;;
;;  IN:  Y = current vehicle.  ('vehicle' var in RAM is not used by this routine -- this
;;                               is so standard maps can override it)
;;
;;    Note that this routine branches to support routines... so those support routines
;;  must be stored nearby this one.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DrawPlayerMapmanSprite:
    LDA #$70
    STA spr_x              ; set X coord to $70 (7 tiles from left of screen)

    LDA lut_VehicleSprY, Y ; get proper Y coord from LUT (different vehicles have different Y coords)

    CPY #$08
    BNE @NotAirship      ; see if vehicle is airship.  If it is...

      STA spr_y          ; record Y coord
      LDA framecounter   ; use framecounter as animator (propellers always spinning)
      ASL A              ; double the frame counter to make animation quicker (each pic lasts 4 frames)
      JUMP @SetFacing     ; jump ahead to facing code


  @NotAirship:           ; if not airship..
      STA spr_y          ; record Y
      LDA move_ctr_x     ; use X move counter as animator (second half of step is a different pic)
      BNE @SetFacing     ; if X counter is nonzero (moving left/right), use it, otherwise
      LDA move_ctr_y     ;   use Y coord instead

  @SetFacing:
    AND #$08             ; mask out bit 3 of animation source.  This determines which of the two
                         ;  pics to draw

    LDX facing                           ; put facing in X
    ORA lut_VehicleFacingSprTblOffset, X ; use it as index to get sprite table offset
    STA tmp                              ; store sprite table offset in tmp (low byte of spr tbl pointer)

    CPY #$01           ; Check vehicle to see if they're on foot
    BNE @notOnFoot
    JUMP DrawMMV_OnFoot

    @notOnFoot:
    CPY #$02           ; or in the canoe
    BEQ DrawMMV_Canoe

    CPY #$04           ; or in the ship
    BEQ DrawMMV_Ship

       ; if none of those, it's the airship!
    LDA #$38
    STA tmp+2               ; tile additive = $38 (airship graphics)
    CALL Draw2x2Vehicle_Set  ; draw the 2x2 vehicle
    NOJUMP DrawAirshipShadow      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Airship Shadow  [$E2B8 :: 0x3E2C8]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawAirshipShadow:
    LDA framecounter         ; get frame counter
    LSR A                    ; shift low bit into C
    BCC @Exit                ; if low bit clear, draw nothing (exit)
                             ;  this results in the shadow being drawn every other frame, which
                             ;  how it "flickers"
    LDA #$6F
    STA spr_y                ; Y coord = $6F
    LDA #$70
    STA spr_x                ; X coord = $70

    LDA #$10
    STA tmp+2                ; tile additive = $10 (airship shadow graphics)

    LDA #<lut_OWObjectSprTbl ; and get OW Object sprite table pointer
    STA tmp
    LDA #>lut_OWObjectSprTbl
    STA tmp+1

    JUMP Draw2x2Sprite        ; then draw the 2x2 sprite and exit

  @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Vehicle facing table offset  [$E417 :: 0x3E427]
;;
;;    The value in this table gets added to the pointer of the sprite table to use
;; when drawing mapman/vehicle sprites (the tables themselves are stored just below).
;;
;;   In short... a different table is used to draw a sprite based on which direction
;; it's facing.  This table indicates which of those tables to use.
;;
;;   right = +$00
;;   left  = +$10
;;   down  = +$30
;;   up    = +$20
;;
;;   'facing' is used as the index for this table.  Normally, this is only either
;;  1, 2, 4, or 8... but could be anywhere between 0-F if the player is pressing
;;  multiple directions at once.  In calculations for determining facing, low bits
;;  are given priority (ie:  if you're pressing up+right, you'll move right because
;;  right is bit 0).  To have the images match this priority, this table has been
;;  built appropriately

lut_VehicleFacingSprTblOffset:
  .byte $00,$00,$10,$00,$30,$00,$10,$00,$20,$00,$10,$00,$30,$00,$10,$00
 ;       R   R   L   R   D   R   L   R   U   R   L   R   D   R   L   R   ; direction used
 ;       -   r   l   rl  d   rd  ld rld  u   ru  lu rlu  du rdu ldu rldu ; directions being pressed (lowest bits take priority)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Vehicle sprite Y coord LUT  [$E36A :: 0x3E37A]
;;
;;     Many of these bytes are unused/padding.

lut_VehicleSprY:
  .byte     $6C
  .byte $6C               ; on foot
  .byte $6F,$6F           ; canoe
  .byte $6F,$6F,$6F,$6F   ; ship
  .byte $4F               ; airship
    ;    ^^  used column



;;
;;  AirshipTransitionFrame  [$E1E1 :: 0x3E1F1]
;;    Does a frame during airship transitions (landing/taking off)
;;

AirshipTransitionFrame:
    CALL WaitForVBlank   ; wait for VBlank
    LDA #>oam             ; then do sprite DMA
    STA OAMDMA

    LDA framecounter      ; increment the frame counter by 1
    CLC                   ;   (why doesn't it just use INC?)
    ADC #$01
    STA framecounter

    CALL SetOWScroll_PPUOn     ; Set Scroll
    FARCALL ClearOAM              ; Clear OAM
    FARCALL MusicPlay  ; And call music play

    LDA #$70
    STA spr_x          ; draw the airship at x coord=$70 (same column that player is drawn)

    LDA tmp+10
    STA spr_y          ; get Y coord from our current animation (in tmp+10)

    LDA framecounter   ; use the frame counter to handle propeller animation
    AND #$08           ;  each image lasts for 8 frames
    STA tmp            ; store this as the table offset

    LDA #$38           ; tile additive = $38  (airship graphics)
    CALL Draw2x2Vehicle ; draw the 2x2 vehicle (airship)
    CALL DrawAirshipShadow       ; then draw the airship shadow
    CALL DrawOWObj_Ship          ;  and ship
    CALL DrawOWObj_BridgeCanal   ;  and bridge/canal

    LDA #%00111000
    STA PAPU_NCTL1            ; set noise volume to 8

    LDA framecounter     ; use framecounter as frequency for noise
    STA PAPU_NFREQ1            ;   this will result in a the pitch starting high, then quickly sweeping
                         ;   downward, then becoming very high again.  Repeating that pattern very
                         ;   quickly (cycles through all pitches once every 16 frames)
                         ; also will switch between "shhhhh" long mode and "bzzzzz" short mode every
                         ;  128 frames

    LDA #0               ; write to last noise reg just to prime the length counter
    STA PAPU_NFREQ2            ;  ensures noise will be audible

    RTS                  ; frame is complete!  Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Standard Map Movement  [$CC80 :: 0x3CC90]
;;
;;    This moves the party on the standard maps, deals movement damage where appropriate,
;;  and does various other things related to movement.  It also sets the scroll appropriate
;;  for the screen.
;;
;;    Note however it does not do collision detection or the like -- it simply carries out moves
;;  that have already begun -- just like OverworldMovement.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StandardMapMovement:
    LDA #$1E
    STA PPUMASK             ; turn the PPU on

    CALL RedrawDoor        ; redraw an opening/closing door if necessary

    LDA PPUSTATUS             ; reset PPU toggle (seems unnecessary, here)

    LDA move_speed        ; see if the player is moving
    BNE @noSetScroll       ; if not, just skip ahead and set the scroll
        CALL SetSMScroll
        RTS
    @noSetScroll:
                          ; the rest of this is only done during movement
      CALL SM_MovePlayer     ; Move the player in the desired direction
      CALL MapPoisonDamage   ; do poison damage

      LDA tileprop          ; get the properties for this tile
      AND #TP_SPEC_MASK     ; mask out the special bits
      CMP #TP_SPEC_DAMAGE   ; see if it's a damage tile (frost/lava)
      BNE :+                ; if it is...
        JUMP MapTileDamage   ;  ... do map tile damage
  :   RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Map Tile Damage  [$C7DE :: 0x3C7EE]
;;
;;    Flashes the screen, plays the "ksssshhh" sound effect, and assigns
;;  map tile damage for when the player is walking over damage tiles like
;;  lava/frost.
;;
;;    Note it does not check to see if the player is on such a damage tile -- it assumes
;;  that check has been done already.  Therefore this routine must only be called when the
;;  player is on such a tile.  Also, this routine must only be called when the player is moving,
;;  otherwise HP would rapidly drain (1 HP per frame) from just the player standing stationary on
;;  the tile.
;;
;;    This routine branches (not JUMP!) to AssignMapTileDamage, so it must be somewhere near that routine.
;;  Seems odd that it does that -- it's like it just lets this routine be interrupted by MapPoisonDamage
;;  for whatever reason.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


MapTileDamage:
    LDA framecounter      ; get the frame counter
    AND #$01              ; isolate low bit and use as a quick monochrome toggle
    ORA #$1E              ; OR with typical PPU flags
    STA PPUMASK             ; and write to PPU reg.  This results in a rapid toggle between
                          ;  normal/monochrome mode (toggles every frame).  This produces the flashy effect

    LDA #$0F              ; set noise to slowest decay rate (starts full volume, decays slowly)
    STA PAPU_NCTL1
    LDA #$0D
    STA PAPU_NFREQ1             ; set noise freq to $0D (low)
    LDA #$00
    STA PAPU_NFREQ2             ; set length counter to $0A (silence sound after 5 frames)
                          ; this gets the noise channel playing the "kssssh" sound effect

    LDA move_speed            ; check move_speed (will be zero when the move is complete)
    BEQ AssignMapTileDamage   ; if the move is complete, assign damage (a branch instead of a jump?  -_-)
    RTS                       ; otherwise, just exit

                  ; damage is only assigned at end of move because we only want to assign damage once per
                  ; step, whereas this routine is called once per frame.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Assign Map Tile Damage [$C861 :: 0x3C871]
;;
;;    Deals 1 damage to all party members (for standard map damaging tiles
;;  -- Frost/Lava).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AssignMapTileDamage:
    LDX #$00              ; zero loop counter and char index

  @Loop:
    LDA ch_curhp+1, X     ; check high byte of HP
    BNE @DmgSubtract      ; if nonzero (> 255 HP), deal this guy damage

    LDA ch_curhp, X       ; otherwise, check low byte
    CMP #2                ; if < 2, skip damage (don't take away their last HP)
    BCC @DmgSkip

  @DmgSubtract:
    LDA ch_curhp, X       ; subtract 1 HP
    SEC
    SBC #1
    STA ch_curhp, X
    LDA ch_curhp+1, X
    SBC #0
    STA ch_curhp+1, X

  @DmgSkip:
    TXA                   ; add $40 to char index (next character in party)
    CLC
    ADC #$40
    TAX

    BNE @Loop             ; loop until it wraps (4 iterations)
    RTS                   ; then exit



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Map Poison Damage [$C7FB :: 0x3C80B]
;;
;;    Deals poison damage (-1 HP) to any poisoned party member, and plays
;;  the harsh "you're poisoned" sound effect.
;;
;;    It is called only when the player is moving.  If it is called when the player
;;  is stationary, then the sound effect would never stop, and party HP would rapidly
;;  drain (1 HP per frame!)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MapPoisonDamage:       ; first thing is to check if ANY characters are poisoned.
    LDA ch_ailments    ; if nobody is poisoned, do nothing.
    CMP #$03                     ; get char 0's ailments... see if they=3 (poison)
    BEQ @DoIt                    ; if yes... "DoIt"

    LDA ch_ailments + (1<<6)     ; and do the same with chars 1,2 and 3
    CMP #$03
    BEQ @DoIt
    LDA ch_ailments + (2<<6)
    CMP #$03
    BEQ @DoIt
    LDA ch_ailments + (3<<6)
    CMP #$03
    BEQ @DoIt

    RTS                          ; if nobody poisoned, just exit

  @DoIt:
                            ; play the "you're poisoned" sound effect
    LDA #%00111010          ; 12.5% duty (harsh), volume=$A
    STA PAPU_CTL2
    LDA #%10000001          ; sweep downward in pitch
    STA PAPU_RAMP2
    LDA #$60
    STA PAPU_FT2               ; start at F=$060
    STA PAPU_CT2

    LDA #$06                ; indicate sq2 is busy with sound effects for 6 frames
    STA sq2_sfx

    LDA move_speed          ; see if party is moving (or really, "has moved")
    BEQ @DoDamage           ; if not... do damage
    RTS                     ; otherwise... don't do damage... just exit.
            ;   This might take some explaining.  This seems contradictory to what I say in the routine
            ; description ("It is called only when the player is moving").  Due to the order in which
            ; this routine is called... move_speed will be zero at this point if the player just completed
            ; a move across a tile (ie:  they moved a full 16 pixels).  move_speed will be nonzero if they
            ; moved less than that.
            ;   Without doing this check, poisoned characters would be damaged every FRAME rather than every step
            ; (which would end up being -16 HP per step, since the player moves 1 pixel per frame).  With this check,
            ; damage is only dealt once the move is completed (so only once per step)

  @DoDamage:
    LDX #0         ; X will be our loop counter and char index

  @DmgLoop:
    LDA ch_ailments, X    ; get this character's ailments
    CMP #$03              ; see if it = 3 (poison)
    BNE @DmgSkip          ; if not... skip this character

    LDA ch_curhp+1, X     ; check high byte of HP
    BNE @DmgSubtract      ; if nonzero (> 255 HP), deal this character damage

    LDA ch_curhp, X       ; otherwise, check low byte of HP
    CMP #2                ; see if >= 2 (don't take away their last HP)
    BCC @DmgSkip          ; if < 2, skip this character
                          ; otherwise... deal him damage

  @DmgSubtract:
    LDA ch_curhp, X       ; subtract 1 from HP
    SEC
    SBC #1
    STA ch_curhp, X
    LDA ch_curhp+1, X
    SBC #0
    STA ch_curhp+1, X

  @DmgSkip:
    TXA                   ; add $40 char index
    CLC
    ADC #$40
    TAX

    BNE @DmgLoop          ; and loop until it wraps (4 iterations)
    RTS                   ; then exit

