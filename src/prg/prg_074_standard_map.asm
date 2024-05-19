.segment "PRG_074"

.include "src/global-import.inc"

.import LoadSMTilesetData, LoadMapPalettes, DrawFullMap, WaitForVBlank, DrawMapPalette, SetSMScroll, GetSMTilePropNow, LoadPlayerMapmanCHR, LoadTilesetAndMenuCHR, LoadMapObjCHR
.import ScreenWipe_Open, CyclePalettes, LoadStandardMap, LoadMapObjects
.import StandardMapMovement, MusicPlay, PrepAttributePos, DoAltarEffect, ClearOAM, DrawSMSprites, EnterShop, BattleTransition, LoadBattleCHRPal, EnterBattle, LoadEpilogueSceneGFX, EnterEndingScene, ScreenWipe_Close, ScreenWipe_Close, DoOverworld
.import GetSMTargetCoords, CanTalkToMapObject, DrawMapObjectsNoUpdate, TalkToObject, TalkToSMTile, DrawDialogueBox, ShowDialogueBox, EnterMainMenu, EnterLineupMenu, UpdateJoy
.import CanPlayerMoveSM, StartMapMove, EnterShopMenu

.export PrepStandardMap, RedrawDoor, ProcessSMInput
.export EnterStandardMap, ReenterStandardMap, LoadStandardMapAndObjects, DoStandardMap

 ;; the LUT containing the music tracks for each tileset

LUT_TilesetMusicTrack:
    .byte $47, $48, $49, $4A, $4B, $4C, $4D, $4E

LUT_BattleRates:
    .byte $0a, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $18, $08, $08, $08, $09, $0a, $0b, $0c, $01, $08, $08, $08

LUT_NormTele_X:
    .byte $0c, $14, $12, $22, $05, $0a, $1b, $3d, $19, $1e, $12, $03, $2e, $23, $20, $1e
    .byte $03, $37, $27, $06, $3b, $33, $0c, $16, $02, $17, $0e, $0c, $0c, $0a, $01, $06
    .byte $15, $2d, $0c, $3d, $2f, $36, $30, $2d, $32, $10, $08, $13, $13, $18, $03, $07
    .byte $08, $10, $01, $14, $28, $03, $0d, $01, $01, $0f, $04, $08, $0e, $17, $0c, $0c

LUT_NormTele_Y:
    .byte $12, $11, $10, $25, $06, $09, $2d, $21, $35, $20, $02, $17, $17, $06, $1f, $02
    .byte $02, $05, $06, $14, $21, $0b, $0c, $16, $02, $37, $0c, $09, $10, $0c, $14, $05
    .byte $2a, $08, $1a, $31, $27, $29, $0a, $14, $30, $1f, $01, $15, $04, $17, $03, $36
    .byte $1b, $0f, $01, $12, $01, $20, $15, $01, $04, $07, $04, $04, $14, $16, $12, $07

LUT_NormTele_Map:
    .byte $18, $34, $1b, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $22, $23, $24, $25
    .byte $26, $25, $26, $0f, $26, $25, $19, $1a, $0b, $27, $19, $19, $19, $19, $19, $19
    .byte $2c, $2d, $2e, $2b, $2c, $2d, $2c, $2b, $2a, $28, $29, $2f, $30, $31, $32, $33
    .byte $37, $35, $36, $35, $34, $37, $38, $39, $3a, $3b, $19, $19, $19, $19, $08, $18

LUT_ExitTele_X:
    .byte $2a, $1e, $c5, $82, $99, $41, $bc, $3e, $c2, $00, $00, $00, $00, $00, $00, $00

LUT_ExitTele_Y:
    .byte $ae, $af, $b7, $2d, $9f, $bb, $cd, $38, $3b, $00, $00, $00, $00, $00, $00, $00

LUT_Tilesets:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $05, $02, $02, $03
    .byte $03, $03, $03, $03, $03, $03, $04, $04, $01, $01, $01, $04, $04, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $03, $03, $03, $04, $04, $05, $05, $05, $05, $05, $06
    .byte $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07, $02, $00, $00, $00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Standard Map  [$CF55 :: 0x3DF65]
;;
;;    Sets up everything for entering (or re-entering) a standard map except for
;;  map decompression and object loading.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepStandardMap:
    LDA #0
    STA PPUCTRL               ; disable NMIs
    STA PPUMASK               ; turn off the PPU
    STA PAPU_NCTL1               ; ??  tries to silence noise?  This doesn't really accomplish that.

    STA joy_select          ; zero a bunch of other map and input related stuff
    STA joy_start
    STA joy_a
    STA joy_b
    STA altareffect
    STA tileprop
    STA tileprop+1
    STA entering_shop

    CALL LoadSMCHR           ; load all the necessary CHR
    FARCALL LoadSMTilesetData   ; load tileset and TSA data
    FARCALL LoadMapPalettes     ; load palettes
    FARCALL DrawFullMap         ; draw the map onto the screen

    LDA sm_scroll_x         ; get the map x scroll
    AND #$10                ; isolate the odd NT bit
    CMP #$10                ; move it into C
    ROL A                   ; then rotate it into bit 0
    AND #$01                ; and isolate it again (low bit this time)
    ORA #$08                ; combine with Spr-pattern-page bit
    STA NTsoft2000          ; and record as soft2000
    STA soft2000

    CALL WaitForVBlank     ; wait for vblank
    CALL DrawMapPalette      ; so we can draw the palette
    CALL SetSMScroll         ; set the scroll

    LDA #0                  ; turn PPU off (but it's already off!)
    STA PPUMASK

    LDX cur_tileset               ; get the tileset
    LDA LUT_TilesetMusicTrack, X ; use it to get the music track tied to this tileset
    STA music_track               ; play it
    STA dlgmusic_backup           ; and record it so it can be restarted later by the dialogue box

    LDA #DOWN
    STA facing              ; start the player facing downward

    LDA sm_scroll_x         ; get the scroll coords and add 7 to them to get the player position
    CLC                     ; and record that position
    ADC #7
    STA sm_player_x
    LDA sm_scroll_y
    CLC
    ADC #7
    STA sm_player_y

    LDX cur_map                 ; use current map to index the rate LUT
    LDA LUT_BattleRates+1, X    ; get this map's rate (+1 because first entry is for overworld [unused])
    STA battlerate              ; and record it

    FARJUMP GetSMTilePropNow        ; then get the properties of the current tile, and exit


LoadSMCHR:                     ; standard map -- does not any palettes
    FARCALL LoadPlayerMapmanCHR
    FARCALL LoadTilesetAndMenuCHR
    FARJUMP LoadMapObjCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Redraw Door  [$CEBA :: 0x3CECA]
;;
;;    Redraws the necessary door tile when you enter/exit rooms.
;;  It must be called during VBlank.  Note it only makes NT changes, not attribute changes.
;;  Therefore open and closed door tiles must share the same palette.
;;
;;  IN:  inroom = current state of room transition
;;       doorppuaddr = PPU address at which to redraw door graphic
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RedrawDoor_Exit:
    RTS

RedrawDoor:
    LDA inroom                 ; check inroom status
    BEQ RedrawDoor_Exit        ; if not inroom, no redrawing required
    BMI RedrawDoor_Exit        ; if already inroom, no redrawing required (redraw only needed for the transition)

    AND #$07                   ; mask out the low bits
    CMP #$01
    BEQ @NormalOpen            ; if $01 -> opening a normal door
    CMP #$02
    BEQ @LockedOpen            ; $02 -> opening a locked door
    CMP #$05
    BEQ @NormalClose           ; $05 -> closing a normal door
                               ; else ($06) -> closing a locked door

  @LockedClose:
    LDA #$00                   ; new inroom status ($00 because we're leaving rooms)
    LDX #MAPTILE_LOCKEDDOOR    ; tile we're to draw
    JUMP @Redraw                ; redraw it

  @NormalClose:
    LDA #$00                   ; same...
    LDX #MAPTILE_CLOSEDDOOR    ; but use normal closed door tile instead of the locked door tile
    JUMP @Redraw

  @LockedOpen:
    LDA #$82                   ; $82 indicates inroom, but shows outroom sprites (locked rooms)
    LDX #MAPTILE_OPENDOOR
    JUMP @Redraw

  @NormalOpen:
    LDA #$81                   ; $81 indicates inroom and shows inroom sprites (normal rooms)
    LDX #MAPTILE_OPENDOOR

  @Redraw:
    STA inroom             ; record new inroom status (previously stuffed in A)
    LDA PPUSTATUS              ; reset PPU toggle

    LDA doorppuaddr+1      ; load the target PPU address
    STA PPUADDR
    LDA doorppuaddr
    STA PPUADDR
    LDA tsa_ul, X          ; and redraw upper two TSA tiles using the current tileset tsa data in RAM
    STA PPUDATA
    LDA tsa_ur, X
    STA PPUDATA

    LDA doorppuaddr+1      ; reload target PPU address
    STA PPUADDR
    LDA doorppuaddr
    ORA #$20               ; but add $20 to it to put it on the second row of the tile (bottom half)
    STA PPUADDR
    LDA tsa_dl, X          ; and redraw lower two TSA tiles
    STA PPUDATA
    LDA tsa_dr, X
    STA PPUDATA

    JUMP DrawMapPalette     ; then redraw the map palette (since inroom changed, so did the palette)
                           ;  and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Standard Map  [$CF2E :: 0x3CF3E]
;;
;;    Called when entering a standard map for the first time, or when
;;  changing standard maps.  Map needs to be decompressed and all objects
;;  reloaded.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterStandardMap:
    CALL LoadStandardMapAndObjects   ; decompress the map, load objects
    CALL PrepStandardMap             ; draw it, do other prepwork
    FARJUMP ScreenWipe_Open             ; do the screen wipe effect and exit once map is visible

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Reenter Standard Map  [$CF3A :: 0x3CF4A]
;;
;;    Called to reenter (but not reload) a standard map.  Like when you exit
;;  a shop or menu... the map and objects haven't changed, but the map
;;  needs to be redrawn and such.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReenterStandardMap:
    CALL PrepStandardMap   ; do map preparation stuff (redraw, etc)
    LDA #$03              ; then do palette cycling effect code 3 (standard map -- cycling in)
    FARJUMP CyclePalettes     ;  and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LoadStandardMapAndObjects
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadStandardMapAndObjects:
    LDA #$01
    STA mapflags          ; set the standard map flag

    LDA #0
    STA PPUCTRL             ; disable NMIs
    STA PPUMASK             ; turn off PPU

    FORCEDFARCALL LoadStandardMap   ; decompress the map
    FORCEDFARCALL LoadMapObjects    ; load up the objects for this map (townspeople/bats/etc)

    RTS                   ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LoadTeleportData
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadNormalTeleportData:
    LDX tileprop+1          ; get the teleport ID in X for indexing teleport data

    LDA LUT_NormTele_X, X   ; get the X coord to teleport to
    SEC                     ;  subtract 7 from desired player coord
    SBC #7                  ;  and wrap to get scroll pos
    AND #$3F
    STA sm_scroll_x

    LDA LUT_NormTele_Y, X   ; do same with Y coord
    SEC
    SBC #7
    AND #$3F
    STA sm_scroll_y

    LDA LUT_NormTele_Map, X ; get the map and record it
    STA cur_map

    TAX                     ; then throw the map in X, and use it to get
    LDA LUT_Tilesets, X     ; the tileset for this map
    STA cur_tileset
    RTS

LoadExitTeleportData:
    LDX tileprop+1          ; get the teleport ID in X
    LDA LUT_ExitTele_X, X   ;  get X coord
    SEC                     ;  subtract 7 to get the scroll
    SBC #7
    STA ow_scroll_x

    LDA LUT_ExitTele_Y, X   ; do same with Y coord
    SEC
    SBC #7
    STA ow_scroll_y
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Standard Map  [$C8B3 :: 0x3C8C3]
;;
;;    Enters a standard map, loads all appropriate objects, CHR, palettes... everything.
;;  Then does the standard map loop
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoStandardMap:
    CALL EnterStandardMap     ; load and prep map stuff
    NOJUMP StandardMapLoop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Standard Map Loop  [$C8B6 :: 0x3C8C6]
;;
;;    This is THE loop for game logic when in standard maps.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StandardMapLoop:
    CALL WaitForVBlank        ; wait for VBlank
    LDA #>oam                  ; and do Sprite DMA
    STA OAMDMA
    FARCALL StandardMapMovement    ; then do movement stuff (involves possible screen drawing) this also sets the scroll
    LDA framecounter
    CLC                        ; increment the two byte frame counter
    ADC #1                     ;  seriously... what did Nasir have against INC?
    STA framecounter           ;  this is criminally inefficient
    LDA framecounter+1
    ADC #0
    STA framecounter+1
    FARCALL MusicPlay   ; keep music playing
    LDA mapdraw_job            ; check the map draw job
    CMP #1                     ;  if the next job is to draw attributes
    BNE :+                     ;  then we need to prep them here so they're ready for
        FARCALL PrepAttributePos     ;  drawing next frame
    :   
    LDA move_speed              ; check the player's movement speed to see if they're in motion
    BNE @Continue               ;  if they are, skip over input and some other checks, and just continue to next loop iteration. This next bit is done only if the player isn't moving, or if they just completed a move this frame
    LDA altareffect             ; do the altar effect if its flag is set
    BEQ :+
        FARCALL DoAltarEffect
    :     
    LDA entering_shop     ; jump ahead to shop code if entering a shop
    BNE @Shop
    LDA tileprop                         ; lastly, check to see if a battle or teleport is triggered
    AND #TP_TELE_MASK | TP_BATTLEMARKER
    BNE @TeleOrBattle
        CALL ProcessSMInput    ; if none of those things -- process input, and continue
        @Continue:
        FARCALL ClearOAM            ; clear OAM
        FARCALL DrawSMSprites       ; and draw all sprites
        JUMP StandardMapLoop     ; then keep looping

    @Shop:
        LDA #0
        STA inroom              ; clear the inroom flags so that we're out of rooms when we enter the shop
        LDA #2                  ;   this is to counter the effect of shop enterances also being doors that enter rooms
        FARCALL CyclePalettes       ; do the palette cycle effect (code 2 -- standard map, cycle out)
        FARCALL EnterShopMenu       ; enter the shop
        CALL ReenterStandardMap  ;  then reenter the map
        JUMP StandardMapLoop     ;  and continue looping

    ;; here if the player is to teleport, or to start a fight
    @TeleOrBattle:
    CMP #TP_TELE_WARP       ; see if this is a teleport or fight
    BCS @TeleOrWarp         ;  if property flags >= TP_TELE_WARP, this is a teleport or Warp
        ;;  Otherwise, here, this is a BATTLE
        FARCALL GetSMTilePropNow    ; get 'now' tile properties (don't know why -- seems useless?)
        LDA #0
        STA tileprop            ; zero tile property byte to prevent unending battles from being triggered
        FARCALL BattleTransition    ; do the battle transition effect
        LDA #0                  ; then kill PPU, APU
        STA PPUMASK
        STA PAPU_EN
        FARCALL LoadBattleCHRPal    ; Load CHR and palettes for the battle
        LDA btlformation
        FARCALL EnterBattle       ; start the battle!
        BCC :+                  ;  see if this battle was the end game battle
            @VictoryLoop:
            FARCALL LoadEpilogueSceneGFX
            FARCALL EnterEndingScene
            JUMP @VictoryLoop
        :   
        CALL ReenterStandardMap  ; if this was just a normal battle, reenter the map
        JUMP StandardMapLoop     ; and resume the loop

    @TeleOrWarp:              ; code reaches here if we're teleporting or warping
        BNE @Teleport           ; if property flags = TP_TELE_WARP, this is a warp...
        FARCALL ScreenWipe_Close  ; ... so just close the screen with a wipe and RTS.  This RTS  will either go to the overworld loop, or to one "layer" up in this SM loop
        NAKEDJUMP DoOverworld         ; then jump to the overworld
    @Teleport:
        CMP #TP_TELE_NORM     ; lastly, see if this is a normal teleport (to standard map)
        BNE @ExitTeleport     ;    or exit teleport (to overworld map)

    @NormalTeleport:        ; normal teleport!
        FARCALL ScreenWipe_Close    ; wipe the screen closed
        CALL LoadNormalTeleportData
        JUMP DoStandardMap

    @ExitTeleport:
        FARCALL ScreenWipe_Close    ; wipe the screen closed
        CALL LoadExitTeleportData
        NAKEDJUMP DoOverworld         ; then jump to the overworld

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Process SM input   [$C23C :: 0x3C24C]
;;
;;    Updates joy data and does input processing for standard maps.  Shouldn't
;;  be called when player is in motion.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ProcessSMInput:  
    LDA joy_a              ; see if user pressed the A button
    BEQ @CheckStart        ; if not, skip ahead to check Start button.  Otherwise...

    ;;
    ;; A button pressed
    ;;

      LDA #0
      STA joy_a              ; clear A button marker
      STA dlgsfx             ;  and a few dialogue flags
      STA dlgflg_reentermap

      CALL WaitForVBlank      ; wait for VBlank and keep music playing
      FARCALL MusicPlay ;   seems weird to do this stuff here -- game probably doesn't need to wait a frame

      LDA facing               ; use the direction the player is facing
      FARCALL GetSMTargetCoords    ;  as the direction to get SM target coords

      FARCALL CanTalkToMapObject   ; see if there's a map object at those target coords
      STX talkobj              ; store the index to that object (if any) in talkobj
      PHP                      ; back up the C flag (whether or not there was an object to talk to)

      LDA #4*4                    ; redraw all map objects starting at the 4th sprite
      STA sprindex                ;  this will cause the object we're talking to (if any) to face the player
      FARCALL DrawMapObjectsNoUpdate  ;  we start at the 4th sprite so the player's sprite doesn't get overwritten

      PLP                ; restore C flag
      LDX talkobj        ; and index of object to talk to
      BCC @TalkToTile    ; examine C flag to see if there was an object to talk to.  If there was....

    LDA #0
    STA tileprop        ; clear tile properties (prevent unwanted teleport/battle)
    FARCALL TalkToObject    ; then talk to this object.
    JUMP @DialogueBox


    @TalkToTile:          ; if there was no object to talk to....
        FARCALL TalkToSMTile    ; ... talk to the SM tile instead (open TC or just get misc text)
        LDX #0              ; clear tile properties (prevent unwanted teleport/battle)
        STX tileprop

     ;; whether we talked to an object or the SM tile, here, A contains the dialogue
     ;; text ID we need to draw

    @DialogueBox:
    FARCALL DrawDialogueBox     ; draw the dialogue box and containing text
    CALL WaitForVBlank       ; wait a frame
    LDA #>oam                 ;   (this is all typical frame stuff -- set scroll, play music, etc)
    STA OAMDMA
    CALL SetSMScroll
    LDA #$1E
    STA PPUMASK
    FARCALL MusicPlay
    FARCALL ShowDialogueBox       ; actually show the dialogue box.  This routine exits once the box closes
    LDA dlgflg_reentermap     ; check the reenter map flag
    BEQ :+
        JUMP ReenterStandardMap  ; ... and reenter map if set
    :     
    LDA #0            ; then clear A, Start and Select button catchers
    STA joy_a
    STA joy_start
    STA joy_select
    RTS               ; and exit

  ;; if A button wasn't pressed, it jumps here to check for Start

    @CheckStart:

    LDA joy_start      ; check to see if Start pressed
    BEQ @CheckSelect   ; if not... jump ahead to check select.  Otherwise....

    ;;
    ;; Start button pressed
    ;;

      LDA #0
      STA joy_start            ; clear start button catcher

      FARCALL GetSMTilePropNow     ; get the properties of the tile we're standing on (for LUTE/ROD purposes)
      LDA #$02
      FARCALL CyclePalettes        ; cycle palettes out with code 2 (2=standard map)
      FARCALL EnterMainMenu        ; enter the main menu
      JUMP ReenterStandardMap   ; then reenter the map

  ;; if neither A nor Start pressed... jumps here to check select

    @CheckSelect:

    LDA joy_select       ; is select pressed?
    BEQ @CheckDirection  ; if not... jump ahead.  Otherwise...

 ;;
 ;; Select button pressed
 ;;

    FARCALL GetSMTilePropNow     ; do all the same stuff as when start is pressed.
    LDA #0                   ;   though I don't know why you'd need to get the now tile properties...
    STA joy_select
    LDA #$02
    FARCALL CyclePalettes
    FARCALL EnterLineupMenu      ; but since they pressed select -- enter lineup menu, not main menu
    JUMP ReenterStandardMap

  ;; A, Start, Select -- none of them pressed.  Now check directional buttons

    @CheckDirection:

    FARCALL UpdateJoy       ; update joy data
    LDA joy             ; get updated data, and isolate the directional buttons
    AND #$0F
    BNE @Move           ; if any buttons down, move in that direction
  @Exit:                ;  otherwise, just exit
      RTS
  @Move:
      STA facing           ; record directions pressed as our new facing direction
      FARCALL CanPlayerMoveSM  ; check to see if the player can move that way
      BCS @Exit            ; if not... exit
      FARJUMP StartMapMove     ; otherwise... start them moving that direction, and exit
