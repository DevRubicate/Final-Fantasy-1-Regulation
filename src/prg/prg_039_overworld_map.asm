.segment "PRG_039"

.include "src/global-import.inc"

.import LoadOWBGCHR, LoadPlayerMapmanCHR, LoadOWObjectCHR, WaitForVBlank, GetOWTile, OverworldMovement
.import MusicPlay, PrepAttributePos, ProcessOWInput
.import ClearOAM, DrawOWSprites, VehicleSFX, ScreenWipe_Open
.import LoadOWTilesetData, LoadMapPalettes, DrawFullMap, DrawMapPalette, SetOWScroll_PPUOn
.import CyclePalettes, LoadBridgeSceneGFX, EnterBridgeScene, CyclePalettes, CyclePalettes, EnterShop, EnterMainMenu, EnterOW_PalCyc, EnterMinimap, EnterLineupMenu, BattleTransition, LoadBattleCHRPal, EnterBattle, ScreenWipe_Close, DoStandardMap

.export LoadOWCHR, EnterOverworldLoop, PrepOverworld, DoOverworld, LoadEntranceTeleportData

LUT_EntrTele_X:
    .byte $1e, $10, $13, $29, $01, $0b, $3d, $01, $13, $0c, $10, $16, $0c, $14, $17, $1b
    .byte $07, $0c, $02, $39, $16, $0f, $12, $15, $11, $0b, $05, $13, $2b, $3a, $00, $00

LUT_EntrTele_Y:
    .byte $12, $17, $20, $16, $10, $17, $3d, $0c, $17, $23, $1f, $18, $15, $1e, $18, $0f
    .byte $01, $0f, $02, $38, $0b, $0b, $0d, $1b, $1f, $0e, $03, $24, $1d, $37, $00, $00

LUT_EntrTele_Map:
    .byte $10, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e
    .byte $0f, $10, $11, $12, $13, $14, $15, $16, $17, $3c, $3c, $10, $10, $10, $00, $00

LUT_Tilesets:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $05, $02, $02, $03
    .byte $03, $03, $03, $03, $03, $03, $04, $04, $01, $01, $01, $04, $04, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $03, $03, $03, $04, $04, $05, $05, $05, $05, $05, $06
    .byte $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07, $02, $00, $00, $00


LoadOWCHR:                     ; overworld map -- does not load any palettes
    FARCALL LoadOWBGCHR
    FARCALL LoadPlayerMapmanCHR
    FARJUMP LoadOWObjectCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Overworld  [$C0CB :: 0x3C0DB]
;;
;;    Called when you enter (or exit to) the overworld.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoOverworld:
    CALL PrepOverworld          ; do all overworld preparation
    FARCALL ScreenWipe_Open        ; then do the screen wipe effect
    NOJUMP EnterOverworldLoop   ; then enter the overworld loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Main Overworld Game Logic Loop  [$C0D1 :: 0x3C0E1]
;;
;;   This is where everything spawns from on the overworld.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterOverworldLoop:

    FARCALL GetOWTile       ; get the current overworld tile information

   ;;
   ;; THE overworld loop
   ;;

  @Loop:  
    CALL WaitForVBlank        ; wait for VBlank
    LDA #>oam                  ; and do sprite DMA
    STA OAMDMA

    FARCALL OverworldMovement      ; do any pending movement animations and whatnot
                               ;   also does any required map drawing and updates
                               ;   the scroll appropriately

    LDA framecounter           ; increment the *two byte* frame counter
    CLC                        ;   what does this game have against the INC instruction?
    ADC #1
    STA framecounter
    LDA framecounter+1
    ADC #0
    STA framecounter+1

    FARCALL MusicPlay   ; Keep the music playing

    LDA mapdraw_job            ; check to see if drawjob number 1 is pending
    CMP #1
    BNE :+
        FARCALL PrepAttributePos     ; if it is, do necessary prepwork so it can be drawn next frame
    :
    LDA move_speed             ; check to see if the player is currently moving
    BNE :+                     ; if not....
        LDA vehicle_next         ;   replace current vehicle with 'next' vehicle
        STA vehicle
        CALL DoOWTransitions      ; check for any transitions that need to be done
        FARCALL ProcessOWInput       ; process overworld input
    :
    FARCALL ClearOAM           ; clear OAM
    FARCALL DrawOWSprites      ; and draw all overworld sprites
    FARCALL VehicleSFX

    JUMP @Loop         ; then jump back to loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Overworld  [$C6FD :: 0x3C70D]
;;
;;    Sets up everything for entering (or re-entering) the world map.
;;  INCLUDING map decompression.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepOverworld:
    LDA #0
    STA PPUCTRL           ; disable NMIs
    STA PPUMASK           ; turn off PPU
    STA PAPU_EN           ; silence APU

    STA scroll_y        ; zero a whole bunch of other things:
    STA tileprop
    STA tileprop+1
    STA inroom
    STA entering_shop
    STA facing
    STA joy_a
    STA joy_b
    STA joy_start
    STA joy_select
    STA mapflags        ; zeroing map flags indicates we're on the overworld map

    CALL LoadOWCHR           ; load up necessary CHR
    FARCALL LoadOWTilesetData   ; the tileset
    FARCALL LoadMapPalettes     ; palettes
    FORCEDFARCALL DrawFullMap         ; then draw the map

    LDA ow_scroll_x      ; get ow scroll X
    AND #$10             ; isolate the '16' bit (nametable bit)
    CMP #$10             ; move it to C (C set if we're to use NT @ $2400)
    ROL A                ; roll that bit into bit 0
    AND #$01             ; isolate it
    ORA #$08             ; OR with 8 (sprites use right-hand pattern table)
    STA NTsoft2000       ; record this as our soft2000
    STA soft2000

    CALL WaitForVBlank       ; wait for a VBlank
    CALL DrawMapPalette        ; before drawing the palette
    FARCALL SetOWScroll_PPUOn     ; the setting the scroll and turning PPU on
    LDA #0                    ;  .. but then immediately turn PPU off!
    STA PPUMASK                 ;     (stupid -- why doesn't it just call the other SetOWScroll that doesn't turn PPU on)

    LDX vehicle
    LDA @lut_VehicleMusic, X  ; use the current vehicle as an index
    STA music_track           ;   to get the proper music track -- and play it

    RTS                   ; then exit!

  ;;  The lut for knowing which track to play based on the current vehicle

  @lut_VehicleMusic:
  .byte $44               ; unused
  .byte $44               ; on foot
  .byte $44,$44           ; canoe (2nd byte unused)
  .byte $45,$45,$45,$45   ; ship (last 3 bytes unused)
  .byte $46               ; airship

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LoadTeleportData
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadEntranceTeleportData:

    LDA tileprop+1          ; get the teleport ID
    AND #$3F                ;  remove the teleport/battle bits, leaving just the teleport ID
    TAX                     ;  put the ID in X for indexing

    LDA LUT_EntrTele_X, X   ; get the X coord, and subtract 7 from it to get the scroll
    SEC
    SBC #7
    AND #$3F                ; wrap around edge of the map
    STA sm_scroll_x

    LDA LUT_EntrTele_Y, X   ; do same with Y coord
    SEC
    SBC #7
    AND #$3F
    STA sm_scroll_y

    LDA LUT_EntrTele_Map, X ; get the map
    STA cur_map

    TAX                     ; throw map in X
    LDA LUT_Tilesets, X     ; and use it to get the tileset for this map
    STA cur_tileset

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Overworld Transitions  [$C140 :: 0x3C150]
;;
;;    Called to do any transitions that need to be done from the overworld.
;;  This includes teleports, battles, entering the caravan, etc.  Anything that
;;  takes the game off of the overworld.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoOWTransitions:
    LDA bridgescene       ; see if the bridge scene has been triggered
    BEQ @SkipBridgeScene  ;   if not triggered... skip it
    BMI @SkipBridgeScene  ;   if we've already done it in the past, skip it

    LDA #0
    FARCALL CyclePalettes      ; cycle palettes with code=00 (overworld, cycle out)

    FARCALL LoadBridgeSceneGFX ; load CHR and NT for the bridge scene
    FARCALL EnterBridgeScene ; do the bridge scene.

    LDA #$04
    FARCALL CyclePalettes   ; cycle out from bridge scene with code 4 (zero scroll, cycle out)
    JUMP EnterOW_PalCyc  ; then re-enter overworld

    @SkipBridgeScene:

    LDA entering_shop     ; see if we're entering a shop (caravan)
    BEQ @SkipShop         ; if not... skip it

    FARCALL GetOWTile       ; Get overworld tile (why do this here?  doesn't make sense)
    LDA #$00
    FARCALL CyclePalettes   ; cycle out the palette
    FARCALL EnterShop       ; and enter the shop!
    JUMP EnterOW_PalCyc  ; then re-enter overworld

    @SkipShop:
    BIT tileprop+1      ; check properties of tile we just moved to
    BMI @Teleport       ; if bit 7 set.. it's a teleport tile
    BVS @Battle         ; otherwise... if bit 6 set, we are to engage in battle

      ;;  If we reach here, there is nothing special that happened due to the player
      ;;   moving.  So check for start/select button presses

    LDA joy_start         ; did they press start?
    BEQ @SkipStart        ; if not... skip it
        LDA #0
        STA joy_start       ; clear start button catcher
        STA PAPU_NCTL1           ; silence noise channel (stop ship/airship sound effects)
        FARCALL GetOWTile       ; get overworld tile (needed for some items, like the Floater)
        LDA #$00
        FARCALL CyclePalettes   ; cycle out the palette
        FARCALL EnterMainMenu   ; and enter the main menu
        JUMP EnterOW_PalCyc  ; then re-enter the overworld

    @SkipStart:
    LDA joy_select        ; check to see if they pressed select
    BEQ @Exit             ; if not... nothing else to check.  Just exit

    LDA #$00            ; otherwise... if they did press select..
    STA PAPU_NCTL1           ; silence noise (stop ship/airship sound effects)
    FARCALL CyclePalettes   ; cycle out the palette

    LDA joy
    AND #$40            ; see if the B button is being held down
    BEQ @Lineup         ;  if not... jump to the lineup menu.  Otherwise do the minimap screen

    @Minimap:
        FARCALL EnterMinimap     ; do the minimap
        JUMP EnterOW_PalCyc   ; then re-enter overworld

    @Lineup:
        FARCALL EnterLineupMenu  ; enter the lineup menu
        JUMP EnterOW_PalCyc   ; then re-enter overworld

    @Exit:
    RTS

    @Battle:
        FARCALL GetOWTile          ; Get overworld tile (needed for battle backdrop)
        FARCALL BattleTransition   ; Do the flashy transition effect
        LDA #$00
        STA PPUMASK              ; turn off the PPU
        STA PAPU_EN              ; and APU
        FARCALL LoadBattleCHRPal   ; Load all necessary CHR for battles, and some palettes
        LDA btlformation
        FARCALL EnterBattle      ; start the battle!
        JUMP EnterOW_PalCyc     ; then re-enter overworld

    @Teleport:
        FARCALL GetOWTile           ; Get OW tile (so we know the battle backdrop for the map we're entering)
        FARCALL ScreenWipe_Close    ; wipe the screen closed
        CALL LoadEntranceTeleportData
        LDA #0                  ; clear the inroom flag (enter maps outside of rooms)
        STA inroom
        NAKEDJUMP DoStandardMap


