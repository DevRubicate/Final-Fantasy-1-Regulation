.segment "BANK_FIXED"

.include "src/registers.inc"
.include "src/constants.inc"
.include "src/macros.inc"
.include "src/ram-definitions.inc"

.import EnterMinimap
.import data_EnemyNames, PrepBattleVarsAndEnterBattle, lut_BattleRates, data_BattleMessages, lut_BattleFormations
.import lut_BattlePalettes
.import EnterEndingScene, MusicPlay, EnterMiniGame, EnterBridgeScene, __Nasir_CRC_High_Byte
.import PrintNumber_2Digit, PrintPrice, PrintCharStat, PrintGold
.import TalkToObject, EnterLineupMenu, NewGamePartyGeneration
.import EnterMainMenu, EnterShop, EnterTitleScreen, EnterIntroStory
.import data_EpilogueCHR, data_EpilogueNT, data_BridgeNT
.import EnvironmentStartupRoutine
.import BattleRNG, GetSMTargetCoords, CanTalkToMapObject
.import DrawMMV_OnFoot, Draw2x2Sprite, DrawMapObject, AnimateAndDrawMapObject, UpdateAndDrawMapObjects, DrawSMSprites, DrawOWSprites, DrawPlayerMapmanSprite, AirshipTransitionFrame
.import ResetRAM, SetRandomSeed, GetRandom, LoadBatSprCHRPalettes_NewGame
.import OpenTreasureChest, AddGPToParty, LoadPrice, LoadBattleBackdropPalette
.import LoadMenuBGCHRAndPalettes, LoadMenuCHR, LoadBackdropPalette, LoadShopBGCHRPalettes, LoadTilesetAndMenuCHR
.import GameStart, LoadOWTilesetData, GetBattleFormation, LoadMenuCHRPal, LoadBatSprCHRPalettes
.import OW_MovePlayer, OWCanMove, OverworldMovement, SetOWScroll, SetOWScroll_PPUOn, MapPoisonDamage, StandardMapMovement, CanPlayerMoveSM
.import UnboardBoat, UnboardBoat_Abs, Board_Fail, BoardCanoe, BoardShip, DockShip, IsOnBridge, IsOnCanal, FlyAirship, AnimateAirshipLanding, AnimateAirshipTakeoff, GetOWTile, LandAirship
.import ProcessOWInput, GetSMTileProperties, GetSMTilePropNow, TalkToSMTile, PlaySFX_Error

; bank_1E_util
.import DisableAPU, ClearOAM, Dialogue_CoverSprites_VBl, UpdateJoy, PrepAttributePos
; bank_18_screen_wipe
.import ScreenWipe_Open, ScreenWipe_Close
; bank_16_overworld_tileset
.import LoadSMTilesetData
; bank_19_menu
.import MenuCondStall
; bank_1A_string
.import DrawComplexString_New, DrawItemBox
; bank_1B_map_chr
.import LoadOWBGCHR
; bank_1C_mapman_chr
.import LoadPlayerMapmanCHR
; bank_1D_world_map_obj_chr
.import LoadOWObjectCHR
; bank_1F_standard_map_obj_chr
.import LoadMapObjCHR
; bank_20_battle_bg_chr
.import LoadBattleBackdropCHR, LoadBattleFormationCHR, LoadBattleBGPalettes, LoadBattleCHRPal, LoadBattlePalette, DrawBattleBackdropRow, LoadBattleAttributeTable, LoadBattleFormationInto_btl_formdata
; bank_21_altar
.import DoAltarEffect
; bank_22_bridge
.import LoadBridgeSceneGFX
; bank_23_epilogue
.import LoadEpilogueSceneGFX
; bank_24_sound_util
.import PlayDoorSFX, DialogueBox_Sfx, VehicleSFX
; bank_25_standard_map
.import PrepStandardMap, EnterStandardMap, ReenterStandardMap, LoadNormalTeleportData, LoadExitTeleportData, DoStandardMap
; bank_26_map
.import LoadMapPalettes, BattleTransition
; bank_27_overworld_map
.import LoadOWCHR, EnterOverworldLoop, PrepOverworld, DoOverworld, LoadEntranceTeleportData, DoOWTransitions
; bank_28_battle_util
.import BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer
; bank_2A_draw_util
.import DrawBox

.export DrawImageRect
.export DrawPalette
.export DrawEquipMenuStrings, EraseBox
.export WaitForVBlank
.export SwapBtlTmpBytes, FormatBattleString, DrawBattleMagicBox
.export BattleWaitForVBlank, Battle_WritePPUData, Battle_ReadPPUData
.export DrawCombatBox, DrawBattleItemBox, DrawDrinkBox, UndrawNBattleBlocks, DrawCommandBox, DrawRosterBox
.export BattleCrossPageJump
.export Impl_FARCALL, Impl_FARJUMP,Impl_NAKEDJUMP, Impl_FARBYTE, Impl_FARBYTE2, Impl_FARPPUCOPY
.export lut_2x2MapObj_Right, lut_2x2MapObj_Left, lut_2x2MapObj_Up, lut_2x2MapObj_Down, MapObjectMove
.export CHRLoadToA
.export DoMapDrawJob
.export WaitScanline, SetSMScroll
.export CyclePalettes, EnterOW_PalCyc
.export StartMapMove, Copy256, CHRLoad, CHRLoad_Cont
.export CoordToNTAddr
.export DrawFullMap, DrawMapPalette
.export WaitVBlank_NoSprites
.export LoadStandardMap, LoadMapObjects
.export EnterBattle
.export DrawDialogueBox, DrawMapObjectsNoUpdate, ShowDialogueBox


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Wait a Scanline  [$D788 :: 0x3D798]
;;
;;    JSRing to this routine eats up exactly 109 cycles 2 times out of 3, and 108
;;  cycles 1 time out of 3.  So it effectively eats 108.6667 cycles.  This includes
;;  the CALL.  When placed inside a simple 'DEX/BNE' loop (DEX+BNE = 5 cycles), it
;;  burns 113.6667 cycles, which is EXACTLY one scanline.
;;
;;    This is used as a timing mechanism for some PPU effects like the screen
;;  wipe transition that occurs when you switch maps.
;;
;;    tmp+2 is used as the 3-step counter to switch between waiting 108 and 109
;;  cycles.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitScanline:
    LDY #16          ; +2 cycles
   @Loop:
      DEY            ;   +2
      BNE @Loop      ;   +3  (5 cycle loop * 16 iterations = 80-1 = 79 cycles for loop)

  CRITPAGECHECK @Loop      ; ensure above loop does not cross page boundary

    LDA tmp+2        ; +3
    DEC tmp+2        ; +5
    BNE @NoReload    ; +3 (if no reload -- 2/3)
                     ;   or +2 (if reload -- 1/3)

  CRITPAGECHECK @NoReload  ; ensure jump to NoReload does not require jump across page boundary

  @Reload:
    LDA #3           ; +2   Both Reload and NoReload use the same
    STA tmp+2        ; +3    amount of cycles.. but Reload reloads tmp+2
    RTS              ; +6    with 3 so that it counts down again

  @NoReload:
    LDA #0           ; +2
    LDA tmp+2        ; +3   LDA -- not STA.  It's just burning cycles, not changing tmp+2
    RTS              ; +6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DialogueBox_Frame  [$D6A1 :: 0x3D6B1]
;;
;;    Does frame work related to drawing the dialogue box.  This mainly involves timing the screen
;;  splits required to make the dialogue box visible.
;;
;;  IN:  tmp+10 = "offscreen" NT (soft2000 XOR #$01) -- NT containing dialogue box
;;       tmp+11 = number of scanlines (-8) the dialogue box is to be visible.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DialogueBox_Frame:
    FARCALL Dialogue_CoverSprites_VBl   ; modify OAM to cover sprites behind the dialogue box, then wait for VBlank
    LDA #>oam          ; do sprite DMA
    STA OAMDMA          ; after waiting for VBlank and Sprite DMA, the game is roughly 556 cycles into VBlank

    LDA tmp+10         ; set NT scroll to draw the "offscreen" NT (the one with the dialogue box)
    STA PPUCTRL

        ; now the game loops to burn VBlank time, so that it can start doing raster effects to split the screen

    LDY #$FC           ; count Y down from $FC
  @BurnVBlankLoop:     ; On entry to this loop, game is about 565 cycles into VBlank)
    DEY                    ; 2 cycles
    NOP                    ; +2=4
    NOP                    ; +2=6
    NOP                    ; +2=8
    BNE @BurnVBlankLoop    ; +3=11   (11*$FC)-1 = 2771 cycles burned in loop.
                           ;         2771 + 565 = 3336 cycles since VBl start
                           ; First visible rendered scanline starts 2387 cycles into VBlank
                           ; 3336 - 2387 = 949 cycles into rendering
                           ; 949 / 113.6667 = currently on scanline ~8.3
       PAGECHECK @BurnVBlankLoop

        ; here, thanks to above loop, the game is ~8.3 scanlines into rendering.  Since scroll changes
        ;  are not visible until the end of the scanline, you can round up and say that we're on scanline 9
        ;  since that'll be when scroll changes are first visible.

    LDX tmp+11             ; get the height of the box
    DEX                    ; decrement it BEFORE burning scanlines (since we're on scanline 9, this would
                           ;   mean the last visible dialogue box line is 8+N  -- where N is tmp+11)

  @ScanlineLoop:
    CALL WaitScanline       ; burn the desired number of scanlines
    DEX
    BNE @ScanlineLoop

       PAGECHECK @ScanlineLoop

      ; now... the dialogue box has been visible for 8+N scanlines, and we're to its bottom line
      ; so we don't want it to be visible any more for the rest of this frame

    LDA soft2000                   ; so get the normal "onscreen" NT
    STA PPUCTRL                      ; and set it
    FARJUMP MusicPlay       ; then call the Music Play routine and exit



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Overworld -- PalCyc   [$C762 :: 0x3C772]
;;
;;    Enters the overworld with the palette cycling effect
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterOW_PalCyc:
    FARCALL PrepOverworld       ; do all necessary overworld preparation
    LDA #$01
    CALL CyclePalettes       ; cycle palettes with code=01 (overworld, reverse cycle)
    NAKEDJUMP EnterOverworldLoop  ; then enter the overworld loop


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Set SM Scroll  [$CCA1 :: 0x3CCB1]
;;
;;     Sets the scroll for the standard maps.
;;
;;    Changes to SetSMScroll can impact the timing of some raster effects.
;;  See ScreenWipeFrame for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSMScroll:
    LDA NTsoft2000      ; get the NT scroll bits
    STA soft2000        ; and record them in both soft2000
    STA PPUCTRL           ; and the actual PPUCTRL

    LDA sm_scroll_x     ; get the standard map scroll position
    ASL A
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Full Map   [$CFE7 :: 0x3CFF7]
;;
;;    Draws 15 rows of tiles for the map, filling the entire screen.
;;  It accomplishes this by adding 15 to the map scroll, then faking
;;  upward movement to draw rows bottom first.
;;
;;    For Standard maps, this does no map decompression.  However for the overworld,
;;  each row is decompressed prior to drawing.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawFullMap:
    LDA #0
    STA scroll_y         ; zero y scroll

    LDA mapflags         ; see if we're on the overworld or not
    LSR A                ; put SM flag in C
    BCS @SM              ;  and jump ahead if in SM
  @OW:
     LDA ow_scroll_y     ; add 15 to OW scroll Y
     CLC
     ADC #15
     STA ow_scroll_y
     JUMP @StartLoop

  @SM:
     LDA sm_scroll_y     ; same, but add to sm scroll
     CLC
     ADC #15
     AND #$3F            ; and wrap around map boundary
     STA sm_scroll_y

  @StartLoop:
    LDA #$08
    STA facing           ; have the player face upwards (for purposes of following loop)

   @Loop:
      CALL StartMapMove       ; start a fake move upwards (to prep the next row for drawing)
      CALL DrawMapRowCol      ; then draw the row that just got prepped
      FARCALL PrepAttributePos   ; prep attributes for that row
      CALL DrawMapAttributes  ; and draw them
      CALL ScrollUpOneRow     ; then force a scroll upward one row

      LDA scroll_y           ; check scroll_y
      BNE @Loop              ; and loop until it reaches 0 again (15 iterations)

    LDA #0
    STA facing           ; clear facing
    STA mapdraw_job      ; clear the draw job (all drawing is done)
    STA move_speed       ; clear move speed (player isn't moving)

       ; those above 3 lines essentially "cancel" the fake moves that were only
       ;   performed to draw the map.

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Start Map Move    [$D023 :: 0x3D033]
;;
;;    This routine starts the player moving in the direction they're facing.
;;
;;    The routine does not check to see if a move is legal.  Once this
;;  routine is called, it's assumed it's a legal move and the player starts
;;  moving unconditionally.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartMapMove:
    LDA scroll_y         ; copy Y scroll to 
    STA mapdraw_nty      ;   nt draw Y

    LDA #$FF             ; put overworld mask ($FF -- ow is 256x256 tiles )
    STA tmp+8            ; in tmp+8 for later
    LDX ow_scroll_x      ; put scrollx in X
    LDY ow_scroll_y      ; and scrolly in Y

    LDA mapflags         ; get mapflags
    LSR A                ; shift SM bit into C
    BCC :+               ; if we're in a standard map...

      LDX sm_scroll_x    ; ... replace above OW data with SM versions
      LDY sm_scroll_y    ; scrollx in X, scrolly in Y
      LDA #$3F           ; and sm mask ($3F -- 64x64) in tmp+8
      STA tmp+8
    : 

    STX mapdraw_x        ; store desired scrollx in mapdraw_x
    STY mapdraw_y        ; and Y scroll

    TXA                  ; then put X scroll in A
    AND #$1F             ; mask out low bits (32 tiles in a 2-NT wide window)
    STA mapdraw_ntx      ; and that's our nt draw X

    LDA facing           ; check which direction we're facing
    LSR A                ; shift until we find the appropriate direction, and branch to it
    BCS @Right
    LSR A
    BCS @Left
    LSR A
    BCS @Down
    LSR A
    BCS @Up

    RTS                  ; if not facing any direction (doing initial map draw), just exit


  @Right:
    LDA sm_scroll_x      ; update player's SM coord to be the SM scroll
    CLC                  ;  +7 (to center him on screen), +1 (to move him right one)
    ADC #7+1
    AND #$3F             ; and wrap around edge of map
    STA sm_player_x

    LDA mapdraw_x        ; add 16 to the mapdraw_x (draw a column on the right side -- 16 tiles to right of screen)
    CLC
    ADC #16

  @Horizontal:
    AND tmp+8            ; mask column with map mask ($FF for OW, $3F for SM)
    STA mapdraw_x        ; set that as our new mapdraw_x

    AND #$1F             ; from that, calculate the NTX
    STA mapdraw_ntx

    LDA mapflags         ; set the 'draw column' map flag
    ORA #$02
    STA mapflags

    CALL PrepRowCol       ; and prep the column

  @Finalize:
    LDA #$02
    STA mapdraw_job      ; mark that drawjob #2 needs to be done (tiles need drawing)

    LDA #$01
    STA move_speed       ; set movement speed to move in desired direction

    LDA mapflags         ; check map flags
    LSR A                ; put SM flag in C
    BCS @Exit            ; if in a SM, just exit

    LDA vehicle          ; otherwise (OW), get current vehicle
    CMP #$02
    BCC @Exit            ; if vehicle is < 2 (on foot), exit (speed remains 1)

    LSR A                ; otherwise, replace speed with vehicle/2
    STA move_speed       ;  which works out to:  canoe=1   ship=2   airship=4

  @Exit:
    RTS

  @Left:
    LDA sm_scroll_x      ; exactly the same as @Right... except..
    CLC
    ADC #7-1             ; 7-1 to move him left, instead of right
    AND #$3F
    STA sm_player_x

    LDA mapdraw_x
    SEC
    SBC #1               ; and subtract 1 from the mapdraw column (one tile left of screen)

    JUMP @Horizontal


  @Down:
    LDA sm_scroll_y      ; calculate player SM Y position
    CLC                  ; based on SM scroll Y
    ADC #7+1             ; +7 to center him, +1 to move him down 1
    AND #$3F             ; mask to wrap around map boundaries
    STA sm_player_y

    LDA #15              ; want to add 15 rows to mapdraw_y.  For whatever reason
    STA tmp              ;   this addition is done in @Vertical.  So write the desired addivite to tmp

    LDA mapdraw_nty      ; add $F to the NT Y
    CLC                  ;   just so we can subtract it later
    ADC #$0F             ; Waste of time.  The row to draw to is the row that we're scrolled to
    CMP #$0F             ;   so we don't need to change mapdraw_nty at all when moving down
    BCC @Vertical        ; will never branch

    SEC                  ; subtract the $F we just added (dumb)
    SBC #$0F
    JUMP @Vertical

  @Up:
    LDA sm_scroll_y      ; same idea as @Down
    CLC
    ADC #7-1             ; only -1 to move up 1 tile
    AND #$3F
    STA sm_player_y

    LDA #-1              ; we want to subtract 1 from mapdraw_y
    STA tmp              ;  which is the same as adding -1  ($FF)

    LDA mapdraw_nty
    SEC
    SBC #$01             ; subtract 1 from mapdraw_nty.  Unlike for @Down -- this is actually important
    BCS @Vertical
    CLC
    ADC #$0F             ; but wrap from 0->E

  @Vertical:
    STA mapdraw_nty      ; record new NT Y

    LDA mapdraw_y        ; get mapdraw_y
    CLC
    ADC tmp              ; add our additive to it (down = 15,up = -1)
    AND tmp+8            ; mask with map size to keep within map bound
    STA mapdraw_y        ; write back

    LDA mapflags         ; turn off the 'draw column' map flag
    AND #~$02            ; to indicate we want to draw a row
    STA mapflags

    CALL LoadOWMapRow     ; need to decompress a new row when moving vertically on the OW map
    CALL PrepRowCol       ; then prep the row
    JUMP @Finalize        ; and jump to @Finalize to do final stuff


    RTS                  ; useless RTS (impossible to reach)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Map Draw Job  [$D0E9 :: 0x3D0F9]
;;
;;     This performs the indicated map drawing job.
;;
;;  job=1  update map attributes to reflect the new row/col being scrolled in
;;  job=2  update map tiles to reflect the new row/col
;;  other  do nothing
;;
;;     The mapdraw_job is then decremented to indicate the previous
;;  job was complete (and move onto the next job)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoMapDrawJob:
    LDA PPUSTATUS           ; reset PPU toggle  (seems odd to do here...)

    LDA mapdraw_job     ; find which job we're to do
    SEC
    SBC #1              ; decrement the job (to mark this job as complete 
    STA mapdraw_job     ;   and to move to the next job)

    BEQ @Attributes     ; if original job was 1 (0 after decrement)... do attributes

    CMP #1              ; otherwise, if original job was 2 (1 after decrement)
    BEQ @Tiles          ;   ... do a row/column of tiles

    RTS                 ; if job was neither of those, do nothing and just exit

  @Tiles:
    CALL DrawMapRowCol       ; draw a row or column of tiles
    RTS                     ;  and exit

  @Attributes:
    CALL DrawMapAttributes   ; draw attributes
    RTS                     ;  and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ScrollUpOneRow  [$D102 :: 0x3D112]
;;
;;    This is used by DrawFullMap to "scroll" up one row so that
;;  the next row can be drawn.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScrollUpOneRow:
    LDA mapflags        ; see if this is OW or SM by checking map flags
    LSR A
    BCC @OW             ; if OW, jump ahead to OW

  @SM:
    LDA sm_scroll_y     ; otherwise (SM), subtract 1 from the sm_scroll
    SEC
    SBC #$01
    AND #$3F            ; and wrap where needed
    STA sm_scroll_y

    JUMP @Finalize

  @OW:
    LDA ow_scroll_y     ; if OW, subtract 1 from ow_scroll
    SEC
    SBC #$01
    STA ow_scroll_y

  @Finalize:
    LDA scroll_y        ; then subtract 1 from scroll_y
    SEC
    SBC #$01
    BCS :+
      ADC #$0F          ; and wrap 0->E
    :   
    STA scroll_y
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Standard Map   [$D126 :: 0x3D136]
;;
;;  Called to load the standard 64x64 tile maps (towns, dungeons, etc.. anything that isn't overworld)
;;
;;  TMP:  tmp to tmp+5 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadStandardMap:
    LDA #BANK_STANDARDMAPS
    CALL SwapPRG     ; swap to bank containing start of standard maps
    LDA cur_map       ; get current map ID
    ASL A             ; double it, and throw it in X (to get index for pointer table)
    TAX
    LDA lut_SMPtrTbl, X   ; get low byte of pointer
    STA tmp               ; put in tmp (low byte of our source pointer)
    LDA lut_SMPtrTbl+1, X ; get high byte of pointer
    TAY                   ; copy to Y (temporary hold)
    AND #$3F          ; convert pointer to useable CPU address (bank will be loaded into $8000-FFFF)
    ORA #$80          ;   AND with #$3F and ORA with #$80 will determine where in the bank the map will start
    STA tmp+1         ; put converted high byte to our pointer.  (tmp) is now the pointer to the start of the map
                      ;   provided the proper bank is swapped in
    TYA               ; restore original high byte of pointer
    ROL A
    ROL A                  ; right shift it by 6 (high 2 bytes become low 2 bytes).
    ROL A                  ;    These ROLs are a shorter way to do it than LSRs.  Effectively dividing the pointer by PAPU_CTL1
    AND #$03               ; mask out low 2 bits (gets bank number for start of this map)
    ORA #BANK_STANDARDMAPS ; Add standard map bank (use ORA to avoid unwanted carry from above ROLs)
    STA tmp+5              ; put bank number in temp ram for future reference
    CALL SwapPRG          ; swap to desired bank
    LDA #<mapdata
    STA tmp+2
    LDA #>mapdata     ; set destination pointer to point to mapdata (start of decompressed map data in RAM).
    STA tmp+3         ; (tmp+2) is now the dest pointer, (tmp) is now the source pointer
    JUMP DecompressMap ; start decompressing the map

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Map routines' Semi-local RTS   [$D156 :: 0x3D166]
;;
;;   It is branched/jumped to by map loading routines
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Map_RTS:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load World Map Row  [$D157 :: 0x3D167]
;;
;;  Called to load a single row of an overworld map.  Since only so many can be in RAM at once
;;    a new row needs to be loaded every time the player moves up or down on the overworld map.
;;
;;  IN:   mapflags  = indicates whether or not we're on the overworld map
;;        mapdraw_y = indicates which row needs to be loaded
;;
;;  TMP:  tmp to tmp+7 used
;;
;;  NOTES:  overworld map cannot cross bank boundary.  Entire map and all its pointers must all fit on one bank
;;     (which shouldn't be a problem).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadOWMapRow:
    LDA mapflags     ; get StandardMap flag (to test to see if we're really in the overworld or not)
    LSR A            ; shift flag into C
    BCS Map_RTS      ; if flag is set (in standard map), we're not in the overworld, so don't do anything -- just exit

    LDA #BANK_OWMAP  ;  swap to bank contianing overworld map
    CALL SwapPRG

    LDA #>lut_OWPtrTbl ;  set (tmp+6) to the start of the pointers for the rows of the OW map.
    STA tmp+7          ;   we will then index this pointer table to get the pointer for the start of the row
    LDA #<lut_OWPtrTbl ;  Need to use a pointer because there are 256 rows, which means 512 bytes for indexing
    STA tmp+6          ;    so normal indexing won't work -- have to use indirect mode

    LDA mapdraw_y    ;  Load the row we need to load
    TAX              ;  stuff it in X (temporary)
    ASL A            ;  double it (2 bytes per pointer)
    BCC :+           ;  if there was carry...
      INC tmp+7      ;     inc the high byte of our temp pointer
    :   
    TAY              ;  put low byte in Y for indexing
    LDA (tmp+6), Y   ;  load low byte of row pointer
    STA tmp          ;  put it in tmp
    INY              ;  inc our index
    LDA (tmp+6), Y   ;  load high byte, and put it in tmp+!
    STA tmp+1        ;  (tmp) is now our source pointer for the row

    TXA              ;  get our row number (previously stuffed in X)
    AND #$0F         ;  mask out the low 4 bits
    ORA #>mapdata    ;  and ORA with high byte of mapdata destination
    STA tmp+3        ;  use this as high byte of dest pointer (to receive decompressed map)
    LDA #<mapdata    ;   the row will be decompressed to $7x00-$7xFF
    STA tmp+2        ;   where 'x' is the low 4 bits of the row number
                     ;  (tmp+2) is now our dest pointer for the row
    NOJUMP DecompressMap

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DecompressMap
;;
;;   Decompressed a map from the given source buffer, and puts it in the given dest buffer
;;
;;  IN:  (tmp)   = pointer to source buffer (containing compressed map -- it's assumed it's between $8000-BFFF)
;;       (tmp+2) = pointer to dest buffer (to receive decompressed map.  typically $7xxx)
;;
;;  TMP: tmp to tmp+5 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DecompressMap:
    LDY #0          ;  zero Y, our index
    LDA (tmp), Y    ;  read a byte from source
    BPL @SingleTile ;  if high byte clear (not a run), jump ahead to place a single tile
    CMP #$FF        ;  otherwise check for $FF (termination code)
    BEQ Map_RTS     ;  if == $FF, branch to exit

    ; code reaches here if loaded source byte was $80-FE  (need a run of this tile)
    AND #$7F        ;  take low 7 bits (tile to run)
    STA tmp+4       ;  put tile in temp ram
    INC tmp         ;  inc low byte of src pointer (need to leave Y=0)
    BNE @TileRun    ;  if it didn't wrap, jump ahead to TileRun sublabel

      INC tmp+1     ;    low byte of src pointer wrapped, so inc high byte
      BIT tmp+1     ;    check to see if high byte went over $BF (crossed bank boundary)
      BVC @TileRun  ;    if it didn't, proceed to TileRun
      CALL @NextBank ;    otherwise, we need to swap in the next bank, first

  @TileRun:
    LDA (tmp), Y    ;   get next src byte (length of run)
    TAX             ;   put length of run in X
    LDA tmp+4       ;   get tile ID
  @RunLoop:
      STA (tmp+2), Y ;   write tile ID to dest buffer
      INY            ;   INY to increment our dest index
      BEQ @Full256   ;   if Y wrapped... this run was a full 256 tiles long (maximum).  Jump ahead
      DEX            ;   decrement X (our run length)
      BNE @RunLoop   ;   if it isn't zero yet, we jump back to the loop

      TYA            ;   add Y to the low byte of our dest pointer
      CLC
      ADC tmp+2
      STA tmp+2
      BCC :+              ;   if adding Y caused a carry, we'll need to inc the high byte
    @Full256:
        INC tmp+3         ;   inc high byte of dest pointer
 :    INC tmp             ;   inc low byte of src pointer
      BNE DecompressMap   ;   if it didn't wrap, jump back to main map loading loop
      JUMP @IncSrcHigh     ;   otherwise (did wrap), need to increment the high byte of the source pointer

  @SingleTile:
    STA (tmp+2), Y       ;  write tile to dest buffer
    INC tmp+2            ;  increment low byte of dest pointer
    BNE :+               ;  if it wrapped...
      INC tmp+3          ;     inc high byte of dest pointer
 :  INC tmp              ;  inc low byte of src pointer
    BNE DecompressMap    ;  if no wrapping, just continue with map decompression.  Otherwise...

  @IncSrcHigh:
    INC tmp+1            ;  increment high byte of source pointer
    BIT tmp+1            ;  check to see if we've reached end of PRG bank (BIT will set V if the value is >= $C0)
    BVC DecompressMap    ;  if we haven't, just continue with map decompression
    CALL @NextBank        ;  otherwise swap in the next bank
    JUMP DecompressMap    ;  and continue decompression

    ;; NextBank local subroutine
    ;;  called via CALL when a map crosses a bank boundary (so a new bank needs to be swapped in)
    @NextBank:
    LDA #>$8000   ; reset high byte of source pointer to start of the bank:  $8000
    STA tmp+1
    LDA tmp+5     ; get original bank number
    CLC
    ADC #$01      ; increment it by 1
    JUMP SwapPRG ; swap that new bank in and exit
    RTS           ; useless RTS (impossible to reach)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Standard Map Row or Column [$D1E4 :: 0x3D1F4]
;;
;;   Preps the TSA and Attribute bytes of the given row of a Standard map for drawing
;;    Standard maps mainly.  Overworld does not always use this routine.  See PrepRowCol
;;
;;   Data loaded is put in the intermediate drawing buffer to be later drawn
;;    via DrawMapAttributes and DrawMapRowCol
;;
;;   Note while this loads the attribute byte, it does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;  IN:  X     = Assumed to be set to 0.  This routine does not explicitly set it
;;       (tmp) = pointer to start of map data to prep
;;       tmp+2 = low byte of pointer to the start of the ROW indicated by (tmp).
;;                 basically is (tmp) minus column information
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepSMRowCol:
    LDA mapflags      ; see if we're drawing a row/column
    AND #$02
    BNE @ColumnLoop

  @RowLoop:
    LDY #$00          ; zero Y for following index
    LDA (tmp), Y      ; read a tile from source
    TAY               ; put the tile in Y for a source index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; increment source pointer by 1
    CLC
    ADC #1
    AND #$3F          ; but wrap from $3F->00 (standard maps are only 64 tiles wide)
    ORA tmp+2         ; ORA with original address to retain bits 6,7
    STA tmp           ; write incremented+wrapped address back to pointer
    INX               ; increment our dest index
    CPX #$10          ; and loop until it reaches 16 (full row)
    BCC @RowLoop
    RTS

  @ColumnLoop:
    LDY #$00          ; More of the same, as above.  Only we draw a column instead of a row
    LDA (tmp), Y      ; get the tile
    TAY               ; and put it in Y to index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; Add 64 ($40) to our source pointer (since maps are 64 tiles wide)
    CLC
    ADC #$40
    STA tmp
    LDA tmp+1
    ADC #$00          ; Add any carry from the low byte addition
    AND #$0F          ; wrap at $0F
    ORA #>mapdata     ; and ORA with high byte of map data to keep the pointer looking at map data at in RAM $7xxx
    STA tmp+1
    INX               ; increment dest pointer
    CPX #$10          ; and loop until it reaches 16 (more than a full column -- probably could only go to 15)
    BCC @ColumnLoop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Map Row or Column [$D258 :: 0x3D268]
;;
;;    Same job as PrepSMRowCol, (see that description for details)
;;   The difference is that PrepSMRowCol is specifically geared for Standard Maps,
;;   whereas this routine is built to cater to both Standard and overworld maps (this routine
;;   will jump to PrepSMRowCol where appropriate)
;;
;;   Again note that this does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepRowCol:
    LDX #$00          ; zero X (our dest index)
    LDA mapflags      ; see if we're on the overworld, or in a standard map
    LSR A
    BCC @DoOverworld  ; if we're on the overworld, jump ahead to overworld routine

       ; otherwise (we're in a standard map) -- do some pointer prepwork
       ; then call PrepSMRowCol

       LDA mapdraw_y     ; load the row number we're prepping
       LSR A             ; right shift by 2, rotating bits into tmp+2
       ROR tmp+2         ;  this is effectively the same as rotating left by 6 (multiply by 64)
       LSR A             ;  only much shorter in code
       ROR tmp+2         ; tmp+2 is now *almost* the low byte of the src pointer for the start of this row (still has garbage bits)
       ORA #>mapdata     ; after ORing, A is now the high byte of the src pointer
       STA tmp+1         ; write the src pointer to tmp
       LDA tmp+2         ; get low byte
       AND #$C0          ;  kill garbage bits
       STA tmp+2         ;  and write back
       ORA mapdraw_x     ; OR with current column number
       STA tmp           ; write low byte with column to
       JUMP PrepSMRowCol  ; tmp, tmp+1, and tmp+2 are all prepped to what PrepSMRowCol needs -- so call it

    @DoOverworld:

   LDA mapdraw_y ; get the row number
   AND #$0F      ; mask out the low 4 bits (only 16 rows of the OW map are loaded at a time)
   ORA #>mapdata
   STA tmp+1     ; tmp+1 is now the high byte of the src pointer
   LDA mapdraw_x
   STA tmp       ; and the low byte ($10) is just the column number
   LDA mapflags
   AND #$02      ; see if we are to load a row or a column
   BNE @DoColumn ; jump ahead to column routine if doing a column

  @DoRow:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get desired tile from the map
     TAY           ; put that tile in Y to act as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     INC tmp       ; increment low byte of src pointer.  no need to catch wrapping, as the map wraps at 256 tiles
     INX           ; increment our dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full row)
     BCC @DoRow
     RTS

  @DoColumn:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get tile from the map
     TAY           ; and use it as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     LDA tmp+1     ; load high byte of src pointer
     CLC
     ADC #$01      ;  increment it by 1 (next row in the column)
     AND #$0F      ;  but wrap as to not go outside of map data in RAM
     ORA #>mapdata
     STA tmp+1     ; write incremented and wrapped high byte back
     INX           ; increment dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full column)
     BCC @DoColumn
     RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Row or Column  [$D2E9 :: 0x3D2F9]
;;
;;   This will draw all the tiles in 1 row OR 1 column to the nametable
;;   This is done every time the player takes a step on the map to keep the nametables
;;    updated so that the map appears to be drawn correctly as the player scrolls around
;;
;;   Tiles' TSA have been pre-rendered to an intermediate buffer ($0780-07BF)
;;     draw_buf_ul = UL portion of the tiles
;;     draw_buf_ur = UR portion
;;     draw_buf_dl = DL portion
;;     draw_buf_dr = DR portion
;;
;;   This routine simply copies that pre-rendered data to the NT, so that it becomes
;;    visible on-screen
;;
;;   This routine does not update attributes (see DrawMapAttributes)
;;
;;   16 tiles are drawn if it is to draw a full row.  15 if it is to draw a full column.
;;
;;   Code seems verbose here, like it could've been coded to be smaller, however this is
;;    time critical drawing code (must all be completed in VBlank), so it being more verbose
;;    and lengthy probably keeps it faster than it would be otherwise.. which is very important
;;    for this kind of thing.
;;
;;   mapdraw_nty and mapdraw_ntx the Y,X coords on the NT to start drawing to.  Columns
;;    will draw downward from this point, and rows will draw rightward.
;;
;;  TMP:  tmp through tmp+2 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapRowCol:
    LDX mapdraw_nty           ; get target row draw to
    LDA lut_2xNTRowStartLo, X ; use it to index LUT to find NT address of that row
    STA tmp
    LDA lut_2xNTRowStartHi, X
    STA tmp+1                 ; (tmp) now dest address
    LDA mapdraw_ntx           ; get target column to draw to
    CMP #$10
    BCS @UseNT2400            ; if column >= $10, we need to switch to NT at $2400, otherwise, use NT at PPUCTRL

              ; if column < $10 (use NT PPUCTRL)
    TAX                 ; back up column to X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.  Dest pointer now points to NT start of desired tile
    STA tmp
    JUMP @DetermineRowOrCol

    @UseNT2400:     ; if column >= $10 (use NT $2400)

    AND #$0F            ; mask low bits
    TAX                 ; put column in X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.
    STA tmp
    LDA tmp+1           ; add 4 to high byte (changing NT from PPUCTRL to $2400)
    CLC
    ADC #$04            ; Dest pointer is now prepped
    STA tmp+1

       ; no matter which NT (PPUCTRL/$2400) is being drawn to, both forks reconnect here
    @DetermineRowOrCol:

    LDA mapflags          ; find out if we're moving drawing a row or column
    AND #$02
    BEQ @DoRow
    JUMP @DoColumn


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoRow:

    TXA              ; put column number in A
    EOR #$0F         ; invert it
    TAX              ; put it back in X, increment it, then create a back-up of it in tmp+2
    INX              ; This creates a down-counter:  it is '16 - column_number', indicating the number of
    STX tmp+2        ;   columns that must be drawn until we reach the NT boundary
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; reset PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest addr
    LDA tmp
    STA PPUADDR

    @RowLoop_U:

    LDA draw_buf_ul, Y ; load 2 tiles from drawing buffer and draw them
    STA PPUDATA          ;   first UL
    LDA draw_buf_ur, Y ;   then UR
    STA PPUDATA
    INY              ; inc source index (to look at next tile)
    DEX              ; dec down counter
    BNE :+           ; if it expired, we've reached NT boundary

      LDA tmp+1      ; at NT boundary... so load high byte
      EOR #$04       ;  toggle NT bit
      STA PPUADDR      ;  and write back as the new high byte
      LDA tmp        ; then get low byte
      AND #$E0       ;  snap it to start of the row
      STA PPUADDR      ;  and write back as the new low byte

    :   
    CPY #$10         ; see if we've drawn 16 tiles yet (one full row)
    BCC @RowLoop_U   ; if not, continue looping

    LDA tmp
    CLC              ; add #$20 to low byte of dest pointer so that
    ADC #$20         ;  it points it to the next row of NT tiles
    STA tmp
    LDA tmp+1
    STA PPUADDR        ; then re-copy the dest addr to set the PPU address
    LDA tmp
    STA PPUADDR
    LDY #$00         ; zero our source index again
    LDX tmp+2        ; restore X to our down counter

    @RowLoop_D:

    LDA draw_buf_dl, Y ; repeat same tile copying work done above,
    STA PPUDATA          ;   but this time we're drawing the bottom half of the tiles
    LDA draw_buf_dr, Y ;   first DL
    STA PPUDATA          ;   then DR
    INY                ; inc source index (next tile)
    DEX                ; dec down counter (for NT boundary)
    BNE :+
    
      LDA tmp+1      ; at NT boundary again.. same deal.  load high byte of dest
      EOR #$04       ;   toggle NT bit
      STA PPUADDR      ;   and write back
      LDA tmp        ; load low byte
      AND #$E0       ;   snap to start of row
      STA PPUADDR      ;   write back

    :   
    CPY #$10
    BCC @RowLoop_D   ; loop until all 16 tiles drawn
    RTS              ; and RTS out (full rown drawn)


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoColumn:

    LDA #$0F         ; prep down counter so that it
    SEC              ;  is 15 - target_row
    SBC mapdraw_nty  ;  This is the number of rows to draw until we reach NT boundary (to be used as down counter)
    TAX              ; put downcounter in X for immediate use
    STX tmp+2        ; and back it up in tmp+2 for future use
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; clear PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest address
    LDA tmp
    STA PPUADDR
    LDA #$04
    STA PPUCTRL        ; set PPU to "inc-by-32" mode -- for drawing columns of tiles at a time

    @ColLoop_L:

    LDA draw_buf_ul, Y ; draw the left two tiles that form this map tile
    STA PPUDATA          ;   first UL
    LDA draw_buf_dl, Y ;   then DL
    STA PPUDATA
    DEX              ; dec our down counter.
    BNE :+           ;   once it expires, we've reach the NT boundary

      LDA tmp+1      ; at NT boundary.. get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte
      AND #$1F       ;   snap to top, while retaining current column
      STA PPUADDR      ;   and write back

    :   
    INY              ; inc our source index
    CPY #$0F
    BCC @ColLoop_L   ; and loop until we've drawn 15 tiles (one full column)


                     ; now that the left-hand tiles are drawn, draw the right-hand tiles
    LDY #$00         ; clear our source index
    LDA tmp+1        ; restore dest address
    STA PPUADDR
    LDA tmp          ; but add 1 to the low byte (to move to right-hand column)
    CLC              ;   note:  the game does not write back to tmp -- why not?!!
    ADC #$01
    STA PPUADDR
    LDX tmp+2        ; restore down counter into X

    @ColLoop_R:

    LDA draw_buf_ur, Y ; load right-hand tiles and draw...
    STA PPUDATA          ;   first UR
    LDA draw_buf_dr, Y ;   then DR
    STA PPUDATA
    DEX                ; dec down counter
    BNE :+             ; if it expired, we're at the NT boundary

      LDA tmp+1      ; at NT boundary, get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte of dest
      CLC            ;   and add 1 (this could've been avoided if it wrote back to tmp above)
      ADC #$01       ;   anyway -- adding 1 move to right-hand column (again)
      AND #$1F       ;   snap to top of NT, while retaining current column
      STA PPUADDR      ;   and write to low byte of PPU address

    :   
    INY              ; inc our source index
    CPY #$0F         ; loop until we've drawn 15 tiles
    BCC @ColLoop_R   ;  once we have... 
    RTS              ;  RTS out!  (full column drawn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Attributes   [$D46F :: 0x3D47F]
;;
;;    This uses a little EOR magic to set the appropriate bits in the attribute table.
;;   The general idea is... each map tile has an attribute byte assigned to it.  This byte
;;   is always the same 2 bits repeated 4 times:  $00, $55, $AA, or $FF.  This byte is copied
;;   to the intermediate drawing buffer in full... along with a mask ($03, $0C, $30, or $C0)
;;   to indicate which bits of the attribute byte we are to replace (since each map tile only
;;   represents 2 bits of the attribute byte).
;;
;;    The EOR magic works on the following 2 rules about EOR:
;;      1)  a EOR b = c.  and c EOR b = a.  IE:  EORing with the same value twice gets you the original value
;;      2)  0 EOR b = b.  IE:  EOR works just as OR does if the original source is 0
;;
;;    The code applies this in 3 parts.  To illustrate, I'll use diagrams.  Each letter represents a
;;     bit in the attribute byte.  For this example, let's say the code is to replace bits 2-3 of the attribute byte:
;;
;;      [aaaa aaaa]    <---  'a' = original attribute bits
;;   Step 1 = EOR by the tile's attribute bits
;;      [iiii iiii]    <---  'i' = original attribute bits EOR'd with desired attribute bits
;;   Step 2 = Mask out desired attribute bits
;;      [0000 ii00]    <---  The mask isolates the bits we're interested in
;;   Step 3 = EOR by original attribute byte
;;      [aaaa ddaa]    <---  'a' = original attribute bits, 'd' = desired attribute bits
;;
;;   This works because 0 EOR a = a
;;                  and i EOR a = d  (because a EOR d = i, as per step 1)
;;
;;   This code is timing critical, as it's done every time the player takes a step on the map
;;
;;   The intermediate drawing buffer is used as follows:
;;    draw_buf_attr:    desired attribute byte for tile 'x'
;;    draw_buf_at_hi:   high byte of PPU address in attribute tables for tile 'x'
;;    draw_buf_at_lo:   low byte of PPU address
;;    draw_buf_at_msk:  mask indicating which attribute bits are to be changed in given byte.
;;
;;   TMP:  tmp and tmp+1 are used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapAttributes:
    LDA mapflags
    LDX #$10        ; set X to $10 (if row)
    AND #$02        ; check if we're drawing a row or column
    BEQ :+ 
      LDX #$0F      ; set X to $0F (if column)
    :
    STX tmp+1       ; dump X to tmp+1.  This is our upper-bound
    LDX #$00        ; clear X (source index)
    LDA PPUSTATUS       ; reset PPU toggle

    @Loop:
    LDA draw_buf_at_hi, X  ; set our PPU addr to desired value
    STA PPUADDR
    LDA draw_buf_at_lo, X
    STA PPUADDR
    LDA PPUDATA              ; dummy PPU read to fill read buffer
    LDA PPUDATA              ; read the attribute byte at the desired address
    STA tmp                ; back it up in temp ram
    EOR draw_buf_attr, X   ; EOR with attribute byte to make attribute bits inversed (so that the next EOR will correct them)
    AND draw_buf_at_msk, X ; mask out desired attribute bits
    EOR tmp                ; EOR again with original byte, correcting desired attribute bits, and restoring other bits
    LDY draw_buf_at_hi, X  ; reload desired PPU address with Y (so not to disrupt A)
    STY PPUADDR
    LDY draw_buf_at_lo, X
    STY PPUADDR
    STA PPUDATA              ; write new attribute byte back to attribute tables
    INX                    ; inc our source index
    CPX tmp+1              ; and loop until it reaches our upper-bound
    BCC @Loop
    RTS             ; exit once we've done them all

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
  :   STA mapdraw_nty

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

  :   CALL WaitForVBlank        ; then wait for VBl again
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
    FORCEDFARJUMP DrawDialogueString   ; draw it, then exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Dialogue Box Attributes  [$D53E :: 0x3D54E]
;;
;;    Prepares the draw_buf_attr for the dialogue box.  Note that
;;  the map row must've been prepped before this -- as this is drawn
;;  over it, and it doesn't change all bytes in the buffer (+0 and +$F
;;  remain unchanged)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepDialogueBoxAttr:
    LDX #$0E               ; Loop from $E to 1
    LDA #$FF               ; and set attributes to use palette set 3
  @Loop:
      STA draw_buf_attr, X
      DEX
      BNE @Loop            ; loop until X=0 (do not change draw_buf_attr+0!)
    RTS                    ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Dialogue Box Row  [$D549 :: 0x3D559]
;;
;;    Prepares a row of 16x16 tiles to be drawn for the desired row of the dialogue
;;  box.  Note that the map row must've been prepped before this -- as the dialogue
;;  box is simply written over it.  Some map graphics are still visible underneath
;;  the dialogue box (dialogue box doesn't write over every graphic in the row)
;;
;;  IN:  dlgbox_row = the row of the dialogue box to draw (1-7)
;;
;;  OUT: dlgbox_row = decremented by 1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepDialogueBoxRow:
    DEC dlgbox_row     ; decrement the row (drawing bottom up)
    BEQ @Exit          ; if this is the very top row, draw nothing -- since the map is visible
                       ;  for the top 16 pixels of the screen

    LDA dlgbox_row
    CMP #6             ; Otherwise, see if this is the bottom row
    BEQ @BottomRow     ;   if it is, prepare it specially

    CMP #1
    BEQ @TopRow        ; same with the top row of the dialogue box (2nd row of 16x16 tiles)

                 ; otherwise, just draw a normal "inner" row

  @InnerRows:
    LDA #$FA           ; use tile $FA for the leftmost tile in the row (left box graphic)
    STA tmp
    LDA #$FF           ; tile $FF for all other tiles in the row (inner box graphic / empty space)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep UL tiles

    LDA #$FB           ; $FB as rightmost tile in row (right box graphic)
    STA tmp
    CALL DlgBoxPrep_UR  ;  prep UR tiles

    CALL DlgBoxPrep_DL  ; then prep the fixed DL/DR tiles
    JUMP DlgBoxPrep_DR  ;   and exit

  @TopRow:
    LDA #$F7           ; use tile $F7 for the leftmost tile in the row (UL box graphic)
    STA tmp
    LDA #$F8           ; use tile $F8 for every other tile in the row (top box graphic)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep the UL tiles

    LDA #$F9           ; use tile $F9 for the rightmost tile in the row (UR box graphic)
    STA tmp
    CALL DlgBoxPrep_UR  ;  prep the UR tiles

    CALL DlgBoxPrep_DL  ; then prep the fixed DL/DR tiles
    JUMP DlgBoxPrep_DR  ;   and exit

  @BottomRow:
    LDA #$FC           ; use tile $FC for the leftmost tile in the row (DL box graphic)
    STA tmp
    LDA #$FD           ; use tile $FD for every other tile in the row (bottom box graphic)
    STA tmp+1
    CALL DlgBoxPrep_UL  ;  prep the UL tiles

    LDA #$FE           ; use tile $FE for the rightmost tile in the row (DR box graphic)
    STA tmp
    JUMP DlgBoxPrep_UR  ;  prep the UR tiles and exit

                 ; notice that for the bottom row, the border graphics are drawn on the
                 ; top half of the tile, and that the bottom half of the tile is not changed.

  @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Dialogue Box Prep Support Routines  [$D59A :: 0x3D5AA]
;;
;;    These routines fill each portion of the TSA draw buffer for the dialogue
;;  box.  UL and UR are configurable and take tmp and tmp+1 as parameters, but
;;  DL and DR are fixed and will draw the same tiles every time.
;;
;;    Each routine fills draw_buf_xx+1 to draw_buf_xx+$E.  +0 and +$F are not
;;  changed because the map is to remain visible in the left and right 16-pixels
;;  of the screen.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;;
 ;;  UL  [$D59A ::0x3D5AA]
 ;;   tmp   = tile for leftmost tile
 ;;   tmp+1 = tile for all other tiles
 ;;

DlgBoxPrep_UL:
    LDA tmp               ; get the desired leftmost tile
    STA draw_buf_ul+1     ; record it

    LDX #$02
    LDA tmp+1             ; then get the main tile
   @Loop:
      STA draw_buf_ul, X  ; and record it for +2 to +$E
      INX
      CPX #$0F
      BCC @Loop           ; stop when X gets to $F (don't want to change $F)
    RTS                   ; and exit

 ;;
 ;;  UR  [$D5AC ::0x3D5BC]
 ;;   tmp   = tile for all other tiles
 ;;   tmp+1 = tile for rightmost tile
 ;;

DlgBoxPrep_UR:
    LDA tmp+1             ; get main tile
    LDX #$01
   @Loop:
      STA draw_buf_ur, X  ; and write it to +1 to +$D
      INX
      CPX #$0E
      BCC @Loop

    LDA tmp               ; then copy the right-most tile to +$E
    STA draw_buf_ur+$E
    RTS

 ;;
 ;;  DL  [$D5BE :: 0x3D5CE]
 ;;

DlgBoxPrep_DL:
    LDA #$FA              ; load hardcoded tile $FA (box left border graphic)
    STA draw_buf_dl+1     ; to leftmost tile

    LDX #$02
    LDA #$FF              ; then hardcoded tile $FF (blank space / box inner graphic)
   @Loop:
      STA draw_buf_dl, X  ;   to the rest of the row
      INX
      CPX #$0F
      BCC @Loop
    RTS

 ;;
 ;;  DR  [$D5D0 :: 0x3D5E0]
 ;;

DlgBoxPrep_DR:
    LDA #$FF              ; load hardcoded tile $FF (blank space / box inner graphic)
    LDX #$01
   @Loop:
      STA draw_buf_dr, X  ;   to all tiles in row except the rightmost
      INX
      CPX #$0E
      BCC @Loop

    LDA #$FB              ; load hardcoded tile $FB (box right border graphic)
    STA draw_buf_dr+$E    ; to rightmost tile
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$D5E2 :: 0x3D5F2]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row of map tiles
;;    Really, they just shortcut a multiplication by $40
;;
;;  "2x" because they're really 2 rows (each row is $20, these increment by $40).  This is because
;;  map tiles are 2 ppu tiles tall

lut_2xNTRowStartLo:    .byte  $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
lut_2xNTRowStartHi:    .byte  $20,$20,$20,$20,$21,$21,$21,$21,$22,$22,$22,$22,$23,$23,$23,$23

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Show Dialogue Box [$D602 :: 0x3D612]
;;
;;    This makes the dialogue box and contained text visible (but doesn't draw it to NT,
;;  that must've already been done -- see DrawDialogueBox).  Once the box is fully visible,
;;  it plays any special TC sound effect or fanfare music associated with the box and waits
;;  for player input to close the box -- and returns once the box is no longer visible.
;;
;;  IN:  dlgsfx = 0 if no special sound effect needed.  1 if special fanfare, else do treasure chest ditty.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShowDialogueBox:
    LDA #3
    STA tmp+2              ; reset the 3-step counter for WaitScanline

    LDA #53
    STA sq2_sfx            ; indicate sq2 is going to be playing a sound effect for the next 53 frames
    LDA #$8E
    FARCALL DialogueBox_Sfx    ; and play the "upward sweep" sound effect that plays when the dialogue box opened.

    LDA soft2000           ; get the onscreen NT
    EOR #$01               ; toggle the NT bit to make it the offscreen NT (where the dialogue box is drawn)
    STA tmp+10             ; store "offscreen" NT in tmp+10

    LDA #$08               ; start the visibility scanline at 8(+8).  This means the first scanline of the box
    STA tmp+11             ;  that's visible will be on scanline 16 -- which is the start of where the box is drawn

     ; open the dialogue box

   @OpenLoop:
      CALL DialogueBox_Frame; do a frame

      LDA tmp+11
      CLC
      ADC #2
      STA tmp+11           ; increment the visible scanlines by 2 (box grows 2 pixels/frame)

      CMP #$60             ; see if visiblity lines >= $60 (bottom row of dialogue box)
      BCC @OpenLoop        ; keep looping until the entire box is visible


    LDA dlgsfx             ; see if a sound effect needs to be played
    BEQ @WaitForButton_1   ; if not (dlgsfx = 0), skip ahead
    LDX #$54               ; Use music track $54 for sfx (special fanfare music)
    CMP #1
    BEQ :+                 ; if dlgsfx > 1...
      LDX #$58             ;  ... then use track $58 instead (treasure chest ditty)
    :   
    STX music_track        ; write the desired track to the music_track to get it started

  ; there are two seperate 'WaitForButton' loops because the dialogue box closes when the
  ; user presses A, or when they press any directional button.  The first loop waits
  ; for all directional buttons to be lifted, and the second loop waits for a directional
  ; button to be pressed.  Both loops exit the dialogue box when A is pressed.  Having
  ; the first loop wait for directions to be lifted prevents the box from closing immediately
  ; if you have a direction held.

  @WaitForButton_1:           ;  The loop that waits for the direction to lift
    CALL DialogueBox_Frame   ; Do a frame
    FARCALL UpdateJoy           ; update joypad data
    LDA joy_a               ; check A button
    BNE @ExitDialogue       ; and exit if A pressed

    LDA music_track         ; otherwise, check the music track
    CMP #$81                ; see if it's set to $81 (special sound effect is done playing)
    BNE :+                  ; if not, skip ahead (either no sound effect, or sound effect is still playing)
      LDA dlgmusic_backup      ; if sound effect is done, get the backup track
      STA music_track          ; and restart it
      LDA #0
      STA dlgsfx               ; then clear the dlgsfx flag
    :   
    LDA joy                 ; check directional buttons
    AND #$0F
    BNE @WaitForButton_1    ; and continue first loop until they're all lifted

  @WaitForButton_2:           ;  The loop that waits for a direciton to press
    CALL DialogueBox_Frame   ; exactly the same as above loop
    FARCALL UpdateJoy
    LDA joy_a
    BNE @ExitDialogue

    LDA music_track
    CMP #$81
    BNE :+
      LDA dlgmusic_backup
      STA music_track
      LDA #0
      STA dlgsfx
    :   
    LDA joy
    AND #$0F
    BEQ @WaitForButton_2    ; except here, we loop until a direction is pressed (BEQ instead of BNE)



  @ExitDialogue:
    LDA dlgsfx              ; see if a sfx is still playing
    BEQ @StartClosing       ; if not, start closing the dialogue box immediately


  @WaitForSfx:              ; otherwise (sfx is still playing
    LDA music_track         ;   we need to wait for it to end.  check the music track
    CMP #$81                ; and see if it's $81 (sfx over)
    BEQ @SfxIsDone          ; if it is, break out of this loop
      CALL DialogueBox_Frame   ; otherwise, keep doing frames
      JUMP @WaitForSfx         ; and loop until the sfx is done

  @SfxIsDone:
    LDA dlgmusic_backup     ; once the sfx is done restore the music track to the backup value
    STA music_track
    LDA #0
    STA dlgsfx              ; and clear sfx flag



  @StartClosing:
    LDA #37
    STA sq2_sfx            ; indicate that sq2 is to be playing a sfx for the next 37 frames
    LDA #$95
    FARCALL DialogueBox_Sfx    ; and start the downward sweep sound effect you hear when you close the dialogue box

  @CloseLoop:
      CALL DialogueBox_Frame; do a frame

      LDA tmp+11        ; subtract 3 from the dialogue visibility scanline (move it 3 lines up
      SEC               ;    retracting box visibility)
      SBC #3
      STA tmp+11        ; box closes 3 pixels/frame.

      CMP #$12          ; and keep looping until line is below $12
      BCS @CloseLoop


    RTS          ; then the dialogue box is done!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Draw Palette  [$D850 :: 0x3D860]
;;
;;     Copies the palette from its RAM location (cur_pal) to the PPU
;;   There's also an additional routine here, DrawMapPalette, which will
;;   draw the normal palette, or the "in room" palette depending on whether or
;;   not the player is currently inside rooms.  This is called by maps only
;;
;;     Changes to DrawMapPalette can impact the timing of some raster effects.
;;   See ScreenWipeFrame for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPalette:
    LDA PPUSTATUS       ; Reset PPU toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00        ; set X to zero (our source index)
    JUMP _DrawPalette_Norm   ; and copy the normal palette

DrawMapPalette:
    LDA PPUSTATUS       ; Reset PPU Toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00        ; clear X (our source index)
    LDA inroom      ; check in-room flag
    BEQ _DrawPalette_Norm   ; if we're not in a room, copy normal palette...otherwise...

    @InRoomLoop:
      LDA inroom_pal, X ; if we're in a room... the BG palette (first $10 colors) come from
      STA PPUDATA         ;   $03E0 instead
      INX
      CPX #$10          ; loop $10 times to copy the whole BG palette
      BCC @InRoomLoop   ;   once the BG palette is drawn, continue drawing the sprite palette per normal

    _DrawPalette_Norm:
    LDA cur_pal, X     ; get normal palette
    STA PPUDATA          ;  and draw it
    INX
    CPX #$20           ; loop until $20 colors have been drawn (full palette)
    BCC _DrawPalette_Norm

    LDA PPUSTATUS          ; once done, do the weird thing NES games do
    LDA #$3F           ;  reset PPU address to start of palettes ($3F00)
    STA PPUADDR          ;  and then to $0000.  Most I can figure is that they do this
    LDA #$00           ;  to avoid a weird color from being displayed when the PPU is off
    STA PPUADDR
    STA PPUADDR
    STA PPUADDR
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  WaitVBlank_NoSprites  [$D89F :: 0x3D8AF]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitVBlank_NoSprites:
    FARCALL ClearOAM              ; clear OAM
    CALL WaitForVBlank       ; wait for VBlank
    LDA #>oam
    STA OAMDMA                 ; then do sprite DMA (hide all sprites)
    RTS                       ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Draw Palette [$D918 :: 0x3D928]
;;
;;    Draws the temporary palette (tmp_pal).  BG colors only -- no sprite colors drawn.
;;  For use in palette cycling.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_DrawPalette:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX #0             ; X will be our loop counter.  Zero it

    LDA #$3F           ; set PPU addr to $3F00 (palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR

  @Loop:
      LDA tmp_pal, X   ; get color from tmp_pal
      STA PPUDATA        ; draw it
      INX
      CPX #$10         ; and keep looping ($10 iterations)
      BCC @Loop

    LDA PPUSTATUS          ; reset PPU toggle

    LDA #$3F           ; move PPU addr off of palettes
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    STA PPUADDR
    STA PPUADDR

    RTS                ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Cycle Palettes   [$D946 :: 0x3D956]
;;
;;    Does that fugly palette cycling that acts as a transition into certain
;;  areas.  Like when you enter the main menu, or enter a shop, etc.
;;
;;    The cycling is very simple.  +1 is added to each non-black color until it reaches
;;  $xD (at which point it is replaced with $0F black).  Once all colors reach $0F, the
;;  cycling is complete.
;;
;;    This process can also be done in reverse.  When in reverse, all colors that were
;;  originally non-black start at $xC (where 'x' is their original brightness).  And -1 is done
;;  until they reach their original color.
;;
;;    Note that since the reversed process starts the colors at $xC -- this means that the
;;  reverse cycling will take EXTREMELY long if the palette contains any $xD, $xE, or $xF color
;;  other than $0F.... because the palette will have to cycle through *256* colors to reach
;;  the target color.  This is not a problem in the original game because it doesn't use any
;;  of those colors (they're mostly black, except for some $xD colors -- and $0D is notorious
;;  for screwing up the display on some television sets -- so they should all be avoided anyway).
;;  This could be a problem in some hacks, though... if they changed a palette to use one of
;;  those colors.
;;
;;  IN:  A = desired mode
;;
;;    Each of the 3 low bits in the desired mode indicates something:
;;
;;  bit 0 ($01) = set if cycling is to be done in reverse.  Clear if to be done normally
;;  bit 1 ($02) = set if in standard map.  Clear if not (overworld, or menu, or whatever)
;;  bit 2 ($04) = set if scroll is to be held at zero (for menus or whatever)
;;
;;    This value is dumped into 'palcyc_mode' and referred throughout this routine and
;;  supporting routines.  It determines which palette to use, what scroll to reset to,
;;  etc.
;;
;;    This routine will not exit until the cycling is complete.  Also, once it completes,
;;  it swaps in the menu bank, and turns off the PPU (unless it was reverse -- in which case
;;  the PPU stays on).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CyclePalettes:
    STA palcyc_mode             ; record the mode
    CALL WaitVBlank_NoSprites   ; wait for VBlank, and kill all sprites
    CALL PalCyc_SetScroll       ; set the scroll
    CALL PalCyc_GetInitialPal   ; load up the initial palette
    LDA #$01                    ; A will be a make-shift frame counter
    @Loop:
    PHA                         ; push the frame counter to back it up
    AND #$03                    ; mask low bits, and only take a step through the cycle
    BNE @NoStep                 ;   if zero (once every 4 frames)
        CALL PalCyc_Step        ; if a 4th frame, take a step through the cycle
        CPY #0                  ; check to see if Y is zero (cycling is complete)
        BEQ @Done               ; if cycling is complete, break out of this loop
    @NoStep:
    CALL WaitForVBlank          ; wait for VBlank
    CALL PalCyc_DrawPalette     ; draw the new palette
    CALL PalCyc_SetScroll       ; set the scroll
    FARCALL MusicPlay           ; and update music  (all the typical frame work)
    PLA                         ; pull the frame counter
    CLC
    ADC #1                      ; and add 1 to it
    JUMP @Loop                  ; and keep looping until cycling is complete
    @Done:
    PLA                         ; pull the frame counter just so it doesn't corrupt the stack (we're done with it)
    LDA palcyc_mode             ; get mode
    LSR A                       ; check 'reverse' bit
    BCS :+                      ; if NOT doing reverse....
        LDA #0                  ; ... then turn PPU off
        STA PPUMASK
    :   
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Set Scroll   [$D982 :: 0x3D992]
;;
;;    Sets the scroll appropriately, and also disables sprite rendering
;;
;;  IN:  palcyc_mode = indicates how to set the scroll:
;;
;;     bit 2 set ($04) = zero scroll
;;     bit 1 set ($02) = standard map scroll
;;     otherwise       = overworld scroll
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_SetScroll:
    LDA palcyc_mode      ; get desired scroll setup
    AND #$04             ; check bit 2
    BEQ @Not4            ; if bit 2 clear, jump ahead

  @Do_Zero:              ; otherwise, do zero scroll
    LDA soft2000
    STA PPUCTRL            ; set NT bits

    LDA #$0A
    STA PPUMASK            ; disable sprite rendering

    LDA #$00
    STA PPUSCROLL
    STA PPUSCROLL            ; zero scroll

    RTS                  ; exit

  @Not4:                 ; if bit 2 wasn't set... check bit 1
    LDA palcyc_mode
    AND #$02
    BNE @Do_SM           ; and branch appropriately

  @Do_OW:
    FARCALL SetOWScroll_PPUOn  ; set overworld scroll
    LDA #$0A
    STA PPUMASK              ; disable sprites
    RTS                    ; exit

  @Do_SM:
    CALL SetSMScroll      ; set standard map scroll
    LDA #$0A
    STA PPUMASK            ; disable sprites
    RTS                  ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Get Initial Palette  [$D9B3 :: 0x3D9C3]
;;
;;    Loads up pal_tmp with the initial palette to start cycling
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_GetInitialPal:
    LDX #0              ; start X (our loop counter) at zero
    LDA palcyc_mode     ; get the mode
    LSR A               ; shift 'reverse' bit into C
    BCC @CopyPal        ; if reverse bit is clear (cycling out), just copy the current palette and exit

      CALL @CopyPal      ; otherwise (reverse), copy the palettes, but then do more work...
      DEX               ; X=$0F after this DEX (CopyPal sets it to $10)
                        ;  we're going to use it as a loop down counter, from $0F through $00.

    ; if this is 'reversed' (cycling out), then we don't want the palettes to start at
    ; their normal values (otherwise the cycling will be over immediately), so we mess
    ; the colors up here

  @ScrambleLoop:
    LDA tmp_pal, X      ; get the color
    CMP #$0F            ; if it's black ($0F)
    BEQ @Skip           ;  skip it (don't change black)

    AND #$30            ; otherwise... isolate brightness bits
    ORA #$0C            ; and OR with color $0C (blue-green -- highest "legal" color other than black)
    STA tmp_pal, X      ; then write it back
  @Skip:
    DEX                 ; decrement our loop counter
    BPL @ScrambleLoop   ; and loop until it wraps ($10 iterations)

    RTS                 ; then exit!



  @CopyPal:
    LSR A               ; shift 'standard map' bit into C
    BCC @OutRoomLoop    ; if clear, we're not in a standard map... so do the 'outroom' palette
    LDA inroom          ; otherwise... check to see if we're inroom
    BEQ @OutRoomLoop    ; if we're not (inroom=0), then do outroom palette
                        ; otherwise do inroom:

    @InRoomLoop:
      LDA inroom_pal, X ; copy inroom palette to temp palette
      STA tmp_pal, X
      INX
      CPX #$10
      BCC @InRoomLoop   ; loop until X=$10 ($10 iterations)
    RTS                 ; then exit

    @OutRoomLoop:
      LDA cur_pal, X    ; copy outroom (cur_pal) to temp pal
      STA tmp_pal, X
      INX
      CPX #$10
      BCC @OutRoomLoop  ; loop until X=$10 ($10 iterations)
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Palette Cycle -- Step   [$D9EF :: 0x3D9FF]
;;
;;   Takes the colors in the palette one 'step' through the cycle
;;
;;  OUT:  Y = the number of colors that aren't done cycling yet
;;                (zero = cycling is complete)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PalCyc_Step:
    LDY #0            ; Y is our counter for colors that aren't done.
    LDX #0            ; X is our loop counter / index

    LDA palcyc_mode   ; get the mode
    LSR A             ; put 'reverse' bit in C
    BCS @Reverse      ; if it's set, do the 'reversed' cycling

  @NormalLoop:
    LDA tmp_pal, X    ; get this color
    CMP #$0F          ; check to see if it's black
    BEQ @NormalSkip   ; if it is, it's done cycling (stop at black), so skip it

    AND #$30          ; otherwise, get the brightness bits
    STA tmp           ; and back them up

    LDA tmp_pal, X    ; get the color again
    AND #$0F          ; and get the chroma bits
    CLC
    ADC #$01          ; add 1 to the chroma (cycle through the palette)
    CMP #$0D          ; see if chroma is >= $D  (result is put in C flag)

    ORA tmp           ; restore brightness bits

    BCC :+            ; then check C flag.  If chroma >= $0D....
      LDA #$0F        ; ... replace color with normal black $0F  ($xD, xE, and xF  all get changed to $0F)
    :   
    STA tmp_pal, X      ; write cycled color back
    INY               ; INY to count this color as 'not done yet'

  @NormalSkip:
    INX               ; increment the loop counter
    CPX #$10
    BNE @NormalLoop   ; and loop until X=$10
    RTS               ; then exit

    @Reverse:
    LSR A             ; shift 'standard map' mode bit into C
    BCC @OutroomLoop  ; if clear (not on standard map), do outroom cycling
    LDA inroom        ; otherwise... check inroom status
    BEQ @OutroomLoop  ; if clear, do outroom.  Otherwise, do inroom

  @InroomLoop:
    LDA tmp_pal, X     ; get this color
    CMP inroom_pal, X  ; compare to target color
    BEQ @InroomSkip    ; if equal, color is done

    SEC
    SBC #$01           ; otherwise, subtract 1 (from chroma)
    STA tmp_pal, X     ; and write back
    INY                ; then INY to count color as 'not done'

  @InroomSkip:
    INX                ; increment the loop counter
    CPX #$10
    BCC @InroomLoop    ; and keep looping until X=$10
    RTS                ; then exit


  @OutroomLoop:
    LDA tmp_pal, X     ; get this color
    CMP cur_pal, X     ; compare it to target color
    BEQ @OutroomSkip   ; if they're equal... this color is done

    SEC
    SBC #$01           ; otherwise, subtract 1 (from the chroma)
    STA tmp_pal, X     ; and write back to palette
    INY                ; INY to count the color as 'not done yet'

  @OutroomSkip:
    INX                ; increment the loop counter
    CPX #$10
    BCC @OutroomLoop   ; and keep looping until X=$10
    RTS                ; then exit

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
    TAX                   ; put string ID in X temporarily

    LDA #BANK_DIALOGUE
    STA cur_bank          ; set cur_bank to bank containing dialogue text (for Music_Play)
    CALL SwapPRG         ; and swap to that bank

    TXA                   ; get the string ID back
    ASL A                 ; double it (2 bytes per pointer)
    TAX                   ; and put in X for indexing
    BCS @HiTbl            ; if string ID was >= $80 use 2nd half of table, otherwise use first half

    @LoTbl:

    LDA lut_DialoguePtrTbl, X        ; load up the pointer into text_ptr
    STA text_ptr
    LDA lut_DialoguePtrTbl+1, X
    STA text_ptr+1
    JUMP @PtrLoaded                   ; then jump ahead

    @HiTbl:

    LDA lut_DialoguePtrTbl+$100, X   ; same, but read from 2nd half of pointer table
    STA text_ptr
    LDA lut_DialoguePtrTbl+$101, X
    STA text_ptr+1

    @PtrLoaded:             ; here, text_ptr points to the desired string

    LDA #10
    STA tmp+7             ;  set precautionary counter to 10

    CALL WaitForVBlank   ; wait for VBlank

    LDA box_x             ; copy placement coords (box_*) to dest coords (dest_*)
    STA dest_x
    LDA box_y
    STA dest_y
    CALL SetPPUAddrToDest  ; then set the PPU address appropriately

    @Loop:

    LDY #0                       ; zero Y for indexing
    LDA (text_ptr), Y            ; get the next byte in the string
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
        CALL SetPPUAddrToDest  ;  otherwise if zero, PPU address needs to be reset (NT boundary crossed)
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
        CALL SetPPUAddrToDest ; and set PPU address appropriately
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
      ASL A                ; double it (2 bytes per pointer)
      TAX                  ; and put in X for indexing
      BCS @ItemHiTbl       ; if the item ID was >= $80, use second half of pointer table

      @ItemLoTbl:
        LDA lut_ItemNamePtrTbl, X    ; load pointer from first half if ID <= $7F
        STA text_ptr
        LDA lut_ItemNamePtrTbl+1, X
        JUMP @ItemPtrLoaded

      @ItemHiTbl:
        LDA lut_ItemNamePtrTbl+$100, X   ; or from 2nd half if ID >= $80
        STA text_ptr
        LDA lut_ItemNamePtrTbl+$101, X

      @ItemPtrLoaded:
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
      JUMP SetPPUAddrToDest ; if crossed an NT boundary, the PPU address needs to be changed
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

    NOJUMP SetPPUAddrToDest   ; then set the PPU address and continue string drawing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddrToDest  [$DC80 :: 0x3DC90]
;;
;;    Sets the PPU address to have it start drawing at the coords
;;  given by dest_x, dest_y.  The difference between this and the below
;;  CoordToNTAddr routine is that this one actually sets the PPU address
;;  (whereas the below simply does the conversion without setting PPU
;;  address) -- AND this one works when dest_x is between 00-3F (both nametables)
;;  whereas CoordToNTAddr only works when dest_x is between 00-1F (one nametable)
;;
;;  IN:  dest_x, dest_y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddrToDest:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX dest_x         ; get dest_x in X
    LDY dest_y         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

 @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    STA PPUADDR                ; write it
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    STA PPUADDR                ; and write as low byte
    RTS

 @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    STA PPUADDR                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    STA PPUADDR                ;  for our low byte of PPU address
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Convert Coords to NT Addr   [$DCAB :: 0x3DCBB]
;;
;;   Converts a X,Y coord pair to a Nametable address
;;
;;   Y remains unchanged
;;
;;   IN:    dest_x
;;          dest_y
;;
;;   OUT:   ppu_dest, ppu_dest+1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CoordToNTAddr:
    LDX dest_y                ; put the Y coord (row) in X.  We'll use it to index the NT lut
    LDA dest_x                ; put X coord (col) in A
    AND #$1F                  ; wrap X coord
    ORA lut_NTRowStartLo, X   ; OR X coord with low byte of row start
    STA ppu_dest              ;  this is the low byte of the addres -- record it
    LDA lut_NTRowStartHi, X   ; fetch high byte based on row
    STA ppu_dest+1            ;  and record it
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Image Rectangle  [$DCBC :: 0x3DCCC]
;;
;;    Draws a rectangle of given dimensions with tiles supplies by a buffer.
;;  This allows for simple drawing of a rectangular image.
;;
;;    Note that the image can not cross page boundaries.  Also, no stalling
;;  is performed, so the PPU must be off during a draw.  Also note this routine does not
;;  do any attribute updating.  Image buffer cannot consist of more than 256 tiles.
;;
;;  IN:   dest_x,  dest_y = Coords at which to draw the rectangle
;;       dest_wd, dest_ht = dims of rectangle
;;            (image_ptr) = points to a buffer containing the image to draw
;;                  tmp+2 = tile additive.  This value is added to every non-zero tile in the image
;;
;;    Such a shame this seems to only be used for drawing the shopkeeper.  Really seems like
;;  it would be a more widely used routine.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawImageRect:
    CALL CoordToNTAddr    ; convert the given destination to a usable PPU address
    LDY #0               ; zero our source index, Y

    LDA dest_ht          ; get our height
    STA tmp              ;  and store it in tmp (this will be our row loop down counter)

  @RowLoop:
    LDA PPUSTATUS            ; reset PPU toggle
    LDA ppu_dest+1       ; load up desired PPU address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX dest_wd          ; load width into X (column down counter)
   @ColLoop:
    LDA (image_ptr), Y  ; get a tile from the image
    BEQ :+              ; if it's nonzero....
        CLC
        ADC tmp+2         ; ...add our modifier to it
    :     
    STA PPUDATA           ; draw it
    INY                 ; inc source index
    DEX                 ; dec our col loop counter
    BNE @ColLoop        ; continue looping until X expires

    LDA ppu_dest          ; increment the PPU dest by $20 (one row)
    CLC
    ADC #$20
    STA ppu_dest

    LDA ppu_dest+1        ; include carry in the high byte
    ADC #0
    STA ppu_dest+1

    DEC tmp               ; decrement tmp, our row counter
    BNE @RowLoop          ; and loop until it expires

    RTS                   ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$DCF4 :: 0x3DD04]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row
;;    Really, they just shortcut a multiplication by $20 ($20 tiles per row)
;;

lut_NTRowStartLo:
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0

lut_NTRowStartHi:
  .byte $20,$20,$20,$20,$20,$20,$20,$20
  .byte $21,$21,$21,$21,$21,$21,$21,$21
  .byte $22,$22,$22,$22,$22,$22,$22,$22
  .byte $23,$23,$23,$23,$23,$23,$23,$23



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Erase Box  [$E146 :: 0x3E156]
;;
;;     Same idea as DrawBox -- only instead of drawing a box, it erases one.
;;   erases bottom row first, and works it's way up.
;;
;;  IN:  box_x, box_y, box_wd, box_ht, menustall
;;  TMP: tmp+11 used
;;
;;   cur_bank must also be set appropriately, as this routine can FARCALL MusicPlay
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraseBox:
    LDA box_x          ; copy box X coord to dest_x
    STA dest_x
    LDA box_y          ; get box Y coord
    CLC
    ADC box_ht         ;  add the box height, and then subtract 1
    SEC
    SBC #$01           ;  and write that to dest_y
    STA dest_y         ;  this puts dest_y to the last row
    CALL CoordToNTAddr  ; fill ppu_dest appropriately
    LDA box_ht         ; get the box height
    STA tmp+11         ; and put it in temp RAM (will be down counter for loop)

  @RowLoop:
     LDA menustall      ; see if we need to stall the menu (draw one row per frame)
     BEQ @NoStall       ; if not, skip over this stalling code

       LDA soft2000         ; reset scroll
       STA PPUCTRL
       LDA #0
       STA PPUSCROLL
       STA PPUSCROLL
       FARCALL MusicPlay    ; call music play routine
       CALL WaitForVBlank  ; and wait for vblank

   @NoStall:
     LDA PPUSTATUS          ; reset PPU toggle
     LDA ppu_dest+1     ; set the desired PPU address
     STA PPUADDR
     LDA ppu_dest
     STA PPUADDR

     LDX box_wd         ; get box width in X (downcounter for upcoming loop)
     LDA #0             ; zero A
   @ColLoop:
       STA PPUDATA        ; draw tile 0 (blank tile)
       DEX              ; decrement X
       BNE @ColLoop     ; loop until X expires (box_wd iterations)

     LDA ppu_dest        ; subtract $20 from the PPU address (move it one row up)
     SEC
     SBC #$20
     STA ppu_dest

     LDA ppu_dest+1      ; catch borrow
     SBC #0
     STA ppu_dest+1

     DEC tmp+11          ; decrement our row counter
     BNE @RowLoop        ;  if we still have rows to erase, keep looping


    LDA soft2000    ; otherwise, we're done.  Reset the scroll
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL
    STA PPUSCROLL
    RTS             ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Objects No Update  [$E4F6 :: 0x3E506]
;;
;;    A shortened version of above UpdateAndDrawMapObjects routine.  It
;;  draws all map objects, but without OAM cycling, and does not update
;;  or animate any of them.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapObjectsNoUpdate:
    LDX #0
  @Loop:                   ; loop through all 15 objects
    LDA mapobj_id, X
    BEQ :+                ; check their ID, and only draw them if they actually exist
       FARCALL DrawMapObject   ;  (id is nonzero)
    :    
    TXA
    CLC
    ADC #$10              ; add $10 to index to point to next object
    TAX
    CMP #$F0              ; loop until all 15 objects checked
    BCC @Loop
    RTS                    ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Map Object Move  [$E50A :: 0x3E51A]
;;
;;    Called every frame to update standard map objects (though objects
;;  are updated serially, with only one object updated per frame).  Objects
;;  simply count down a 'wait' timer, then pick a random direction and try
;;  to walk in that direction, provided the move is legal.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MapObjectMove:
    LDA cur_mapobj           ; increment the current map object
    CLC                      ;  only one object is updated per frame
    ADC #$10
    AND #$F0
    CMP #$F0                 ; wrap after 15 objects (don't do the 16th object -- there isn't a 16th)
    BCC :+
      LDA #0
    :   
    STA cur_mapobj

    TAX                      ; put the index of the object to update in X
    LDA mapobj_id, X         ; get this object's ID
    BEQ @Exit                ; if the ID is zero (object doesn't exist), do nothing

    LDA mapobj_flgs, X       ; check the object's flags to see if they're stationary
    AND #$40                 ;  -- stationary bit
    ORA mapobj_face, X       ; also check the face var ?to see if they're already moving?  not sure exactly
    BEQ :+                   ; if not stationary, and face=0, then continue on, otherwise exit

       @Exit:
         RTS

    :   
    LDA inroom               ; check to see if the player is in a room
    AND #1                   ;  specifically, normal rooms (but not locked rooms)
    BEQ @NotInRoom           ; if player is in a room....
      LDA mapobj_flgs, X     ; ... check this object's inroom flag
      BPL @Exit              ; if player in room and object out of room, do not update object
                             ; not sure what the point of this is -- however it WILL prevent you from
                             ; being able to shove an object out of the way if they're blocking the
                             ; exit door from the outside (this happened to be before)
                             ; while I wouldn't say this is BUGGED -- I would recommend removing it
                             ; for a general improvement hack

  @NotInRoom:
    LDA mapobj_movectr, X    ; check the object's movement down counter
    BEQ @TakeStep            ; if it's zero (expired), have the object take another step
      SEC
      SBC #1                 ;  otherwise simply decrement it by 1, and exit
      STA mapobj_movectr, X  ;  (what did NASIR have against DEC?)
      RTS


  ;; Reaches here if the object is to attempt to take another step

  @TakeStep:
    LDA mapobj_physX, X      ; to take a new step, copy the object's physical coords
    STA tmp+4                ;  to temp ram
    LDA mapobj_physY, X
    STA tmp+5

    LDA framecounter         ; use the frame counter, and the runtime direcitonal seed
    ADC npcdir_seed          ; to produce a pseudo-random number.  This number will determine
    STA npcdir_seed          ; which direction to move.  Update the seed, as well.
    AND #3                   ; mask with 3 to get one of four values (directions to move)

    CMP #2                   ; now check which direction to go, and fork appropriately
    BCC @Step_LorR           ; if < 2 (0 or 1), move left or right
    BEQ @Step_Up             ; if == 2, move up
                             ; otherwise (3), move down



  @Step_Down:
    LDA tmp+5                ; get Y pos
    CLC
    ADC #1                   ; add 1 to it, and wrap it around the edge of the map
    AND #$3F
    STA tmp+5                ; then write it back

    CALL CanMapObjMove        ; test to see if moving to this new pos is legal
    BCS @CantStep            ; if check failed (step illegal), can't step here, so just exit

    LDA tmp+5                ; otherwise step is legal
    STA mapobj_physY, X      ;  so copy tested Y coord to the actual physical Y coord of this object
    LDA #1
    STA mapobj_spdY, X       ; set their Y movement speed to move +1 (down)
    LDA #8
    STA mapobj_face, X       ; set their face (why?)

    LDA mapobj_id, X         ; finally, check the object ID.  Bats need to be drawn differently
    CMP #OBJID_SKYWAR_FIRST  ; so check to see if the object is one of the sky warriors (bats)
    BCC :+                   ;  or just a normal bat.  If it is, force it to face leftward.
    CMP #OBJID_SKYWAR_LAST+1 ; The reason for this is because when normal objects move up/down
    BCC @ForceFaceLeft       ; the top half doesn't animate, and the bottom half just mirrors itself
    CMP #OBJID_BAT           ; This would look really funky with the bat graphic (would look like garbage)
    BEQ @ForceFaceLeft       ; So we have them face to the left, in order to have fresh graphics for each frame.

    :     
    LDA #<lut_2x2MapObj_Down   ; reaches here if not a bat.  Just load up the pointer
    STA mapobj_tsaptr, X       ;  to the downward 2x2 tsa table
    LDA #>lut_2x2MapObj_Down
    JUMP @StepDone              ; then jump ahead to final cleanup stuff

 ;; jumps here if the attempted move was illegal

  @CantStep:
    RTS                      ; simply exit.  No muss, no fuss



  @Step_Up:                  ; stepping upward is the same process as stepping down
    LDA tmp+5                ;  except for a few differences
    SEC
    SBC #1                   ; subtract 1 rather than add 1 (to move up instead of down)
    AND #$3F
    STA tmp+5

    CALL CanMapObjMove
    BCS @CantStep

    LDA tmp+5
    STA mapobj_physY, X
    STA mapobj_gfxY, X       ; update the graphic position immediately because it's a negative move
    LDA #-1
    STA mapobj_spdY, X
    LDA #$0F
    STA mapobj_ctrY, X       ; set the Y counter to max right away -- this has to do with how
    LDA #4                   ;  talking to objects is handled.  Because gfxY is changed immediately,
    STA mapobj_face, X       ;  leaving ctrY zero would cause the talking routine to mess up a bit
                             ; see CanTalkToMapObject for why

    LDA mapobj_id, X           ; do the same thing to check for bat objects and force them to face
    CMP #OBJID_SKYWAR_FIRST    ;  leftward
    BCC :+
    CMP #OBJID_SKYWAR_LAST+1
    BCC @ForceFaceLeft
    CMP #OBJID_BAT
    BEQ @ForceFaceLeft

    :     
    LDA #<lut_2x2MapObj_Up
    STA mapobj_tsaptr, X
    LDA #>lut_2x2MapObj_Up
    JUMP @StepDone


  ;; jumps here if trying to move left or right

  @Step_LorR:
    CMP #0
    BEQ @Step_Right          ; fork to left or right if random value was 0 or 1


  @Step_Left:
    LDA tmp+4             ; same process as moving up/down, but we work with X coord/speeds/etc
    SEC
    SBC #1
    AND #$3F
    STA tmp+4

    CALL CanMapObjMove
    BCS @CantStep

    LDA tmp+4
    STA mapobj_gfxX, X    ; update graphic position immediately (again, seems unnecessary)
    STA mapobj_physX, X
    LDA #-1
    STA mapobj_spdX, X
    LDA #$0F
    STA mapobj_ctrX, X    ; set counter to max for same reason we did when moving up (negative move)
    LDA #2                ;  no need to check for bat graphics here, because left/right movement
    STA mapobj_face, X    ;  will draw bat graphics just fine

  @ForceFaceLeft:                  ; @ForceFaceLeft is jumped to for bat graphics (see above)
      LDA #<lut_2x2MapObj_Left
      STA mapobj_tsaptr, X
      LDA #>lut_2x2MapObj_Left
      JUMP @StepDone




  @Step_Right:              ; moving right... more of the same
    LDA tmp+4
    CLC
    ADC #1
    AND #$3F
    STA tmp+4

    CALL CanMapObjMove
    BCS @CantStep

    LDA tmp+4
    STA mapobj_physX, X
    LDA #1
    STA mapobj_spdX, X
    LDA #1
    STA mapobj_face, X

    LDA #<lut_2x2MapObj_Right
    STA mapobj_tsaptr, X
    LDA #>lut_2x2MapObj_Right


  @StepDone:                ; moving all directions meet up here for final cleanup
    STA mapobj_tsaptr+1, X  ; record high byte of desired TSA pointer
    LDA framecounter        ; use the framecounter directly as a pRNG
    AND #$07
    STA mapobj_movectr, X   ; to set the delay until the next movement
    RTS                     ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  CanMapObjMove  [$E630 :: 0x3E640]
;;
;;    Checks to see if a map object can step on a given tile.  Does not actually
;;  perform the move, it only checks to see if the move is legal.
;;
;;  IN:  tmp+4 = X coord to check (where object is attempting to move to)
;;       tmp+5 = Y coord to check
;;           X = index of the object we're checking for
;;
;;  OUT:     C = clear if move legal, set if move illegal
;;
;;    X remains totally unchanged by this routine.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CanMapObjMove:             ; first thing to check is the map
    LDA tmp+5              ; get target Y coord
    LSR A
    LSR A                  ; right shift 2 to get high byte of *64
    ORA #>mapdata          ; OR with high byte of map buffer
    STA tmp+1              ; record this as high byte of pointer
    LDA tmp+5              ; reload Y coord
    ROR A
    ROR A
    ROR A
    AND #$C0               ; left shift by 6 and isolate high bits (Y * 64)
    ORA tmp+4              ; OR with desired X coord to get low byte of pointer
    STA tmp                ; record it
    LDY #0                 ; zero Y for indexing
    LDA (tmp), Y           ; get the tile on the map at the given coords

    ASL A                  ; double the tile number (2 bytes of properties per tile)
    TAY                    ; throw in Y for indexing
    LDA tileset_data, Y    ; fetch the first byte of properties for this tile
    AND #TP_TELE_MASK | TP_NOMOVE  ; see if this tile is a teleport tile, or a tile you can't move on
    BEQ :+                 ; if either teleport or nomove, NPCs can't walk here, so 
      SEC                  ;  SEC to indicate failure (can't move)
      RTS                  ; and exit

    :   
    LDA sm_player_x        ; now check to see if they're trying to move on top of the player
    CMP tmp+4
    BNE :+
    LDA sm_player_y
    CMP tmp+5
    BNE :+
      SEC                  ; if they are, SEC for failure and exit
      RTS

    :   
    LDY #0                 ; now we loop through all other objects to see if we're hitting them
  @Loop:                   ; X is index of test object, Y is index of loop object
    STY tmp                ; dump Y to tmp so we can compare to X
    CPX tmp                ; compare the indeces so that the object doesn't collide with itself
    BEQ :+
    LDA mapobj_id, Y       ; then check the loop object to make sure it exists (ID is nonzero)
    BEQ :+
    LDA tmp+4              ; then check X coords of each
    CMP mapobj_physX, Y
    BNE :+
    LDA tmp+5              ; and Y coords
    CMP mapobj_physY, Y
    BNE :+
      SEC                  ; reaches here if loop object is colliding with test object
      RTS                  ; SEC for failure and exit

    :   
    TYA                    ; otherwise, add $10 to our loop index to test next object
    CLC
    ADC #$10
    TAY
    CMP #$F0               ; compare to $F0 to check all 15 objects
    BCC @Loop              ; loop until all 15 objects checked

    CLC                    ; once all objects checked out, if there wasn't a collision, CLC
    RTS                    ;  to indicate success, and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUTs for 2x2 sprites that make up map objects (townspeople, etc)  [$E7AB :: 0x3E7BB]
;;
;;    These are used with Draw2x2Sprite.  See that routine for details of
;;  the format of these tables
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lut_2x2MapObj_Right:
 .byte $09,$42,$0B,$43,$08,$42,$0A,$43   ; standing
 .byte $0D,$42,$0F,$43,$0C,$42,$0E,$43   ; walking

lut_2x2MapObj_Left:
 .byte $08,$02,$0A,$03,$09,$02,$0B,$03
 .byte $0C,$02,$0E,$03,$0D,$02,$0F,$03

lut_2x2MapObj_Up:
 .byte $04,$02,$06,$03,$05,$02,$07,$03
 .byte $04,$02,$07,$43,$05,$02,$06,$43

lut_2x2MapObj_Down:
 .byte $00,$02,$02,$03,$01,$02,$03,$03
 .byte $00,$02,$03,$43,$01,$02,$02,$43

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Map Objects  [$E7EB :: 0x3E7FB]
;;
;;    This loads all objects for the current standard map.
;;
;;    Each map has $30 bytes of object information.  $0F objects per map, 3 bytes
;;  per object (last 3 bytes are padding and go unused):
;;   byte 0 = object ID
;;   byte 1 = object X coord and behavior flags
;;   byte 2 = object Y coord
;;
;;    Objects get loaded to the 'mapobj' buffer.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadMapObjects:
    LDA #<mapobj
    STA tmp+14
    LDA #>mapobj
    STA tmp+15      ; set dest pointer to point to 'mapobj'

    LDA #$0F        ; set loop counter to $0F ($0F objects to load per map)
    STA tmp+11

    LDA #0
    STA tmp+13      ; zero high byte of source pointer
    LDA cur_map     ; get current map
    ASL A           ;  all this shifting and mathmatics is to multiply by $30
    ROL tmp+13      ;    ($30 bytes per map)
    ASL A           ;  This is done by shifting to get *$20 and *$10, then adding them together
    ROL tmp+13
    ASL A
    ROL tmp+13
    ASL A
    ROL tmp+13
    LDY tmp+13
    STA tmp+12
    ASL tmp+12
    ROL tmp+13
    CLC
    ADC tmp+12
    STA tmp+12
    TYA
    ADC tmp+13            ;  here, we have "cur_map * $30"
    ADC #>lut_MapObjects  ;  add the pointer to the LUT to the high byte to get the final source pointer
    STA tmp+13            ;  tmp+12 now points to "lut_MapObjects + (cur_map * $30)"

    LDA #BANK_OBJINFO     ; swap to the bank containing map object information
    CALL SwapPRG

  @Loop:
     LDY #0
     LDA (tmp+12), Y          ; read the object ID from source buffer
     CALL LoadSingleMapObject  ; load the object

     LDA tmp+12           ; add 3 to the source pointer to look at the next map object
     CLC
     ADC #3
     STA tmp+12
     LDA tmp+13
     ADC #0
     STA tmp+13

     DEC tmp+11           ; decrement loop counter
     BNE @Loop            ; and loop until all $F objects have been loaded

    RTS        ; then exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Single Map Object [$E83B :: 0x3E84B]
;;
;;    Loads a single map object from given source buffer
;;
;;  IN:       A = ID of this map object
;;       tmp+12 = pointer to source map data
;;       tmp+14 = pointer to dest buffer (to load object data to).  Typically points somewhere in 'mapobj'
;;
;;    tmp+14 is incremented after this routine is called so that the next object will be
;;  loaded into the next spot in RAM.  Source pointer is not incremented, however.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadSingleMapObject:
    LDY #<mapobj_rawid
    STA (tmp+14), Y         ; record this object's raw ID

    LDY #0                  ; reset Y to zero so we can start copying the rest of the object info
    TAX                     ; put object ID in X for indexing
    LDA game_flags, X       ; get the object's visibility flag
    AND #$01                ; isolate it
    BEQ :+                  ;   if the object is invisible, replace the ID with zero (no object)
      TXA                   ;   otherwise, restore the raw ID into A (unchanged)
    :   
    STA (tmp+14), Y         ; record raw ID (or 0 if sprite is invisible) as the 'to-use' object ID

    INY                     ; inc Y to look at next source byte
    LDA (tmp+12), Y         ; get next source byte (X coord and behavior flags)
    STA tmp+6               ; back it up
    AND #$C0                ; isolate the behavior flags
    STA (tmp+14), Y         ; record them

    INY                     ; inc Y to look at next source byte
    LDA (tmp+12), Y         ; get next source byte (Y coord)
    STA tmp+7               ; back it up
    LDA tmp+6               ; reload backed up X coord
    AND #$3F                ; mask out the low bits (remove behavior flags, wrap to 64 tiles)
    STA (tmp+14), Y         ; and record it as this object's physical X position
    LDY #<mapobj_gfxX
    STA (tmp+14), Y         ;  and as the object's graphical X position

    LDA tmp+7               ; restore backed up Y coord
    AND #$3F                ; isolate low bits (wrap to 64 tiles)
    LDY #<mapobj_physY
    STA (tmp+14), Y         ; record as physical Y coord
    LDY #<mapobj_gfxY
    STA (tmp+14), Y         ; and graphical Y coord

    LDY #<mapobj_ctrX       ; zero movement counters and speed vars
    LDA #0
    STA (tmp+14), Y
    INY
    STA (tmp+14), Y
    INY
    STA (tmp+14), Y
    INY
    STA (tmp+14), Y

    LDY #<mapobj_movectr    ; zero some other stuff
    STA (tmp+14), Y
    INY
    STA (tmp+14), Y
    INY
    STA (tmp+14), Y

    LDY #<mapobj_tsaptr      ; set the object's TSA pointer so that they're facing downward
    LDA #<lut_2x2MapObj_Down
    STA (tmp+14), Y
    INY
    LDA #>lut_2x2MapObj_Down
    STA (tmp+14), Y

    LDA tmp+14              ; increment the dest pointer to point to the next object's space in RAM
    CLC
    ADC #$10
    STA tmp+14

    RTS                     ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  CHR Row Loading To Given Address 'A'  [$E95A :: 0x3E96A]
;;
;;  Reads a given number of CHR rows from the given buffer, and writes to the specified
;;  address in CHR-RAM.  Destination address is stored in A upon entry
;;  It is assumed the proper PRG bank is swapped in
;;
;;  The difference between CHRLoadToA and CHRLoad is that CHRLoadToA explicitly sets
;;   the PPU address first, whereas CHRLoad does not
;;
;;
;;  IN:   A     = high byte of dest address (low byte is $00)
;;        X     = number of rows to load (1 row = 16 tiles or 256 bytes)
;;        (tmp) = source pointer to graphic data.  It is assumed the proper bank is swapped in
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHRLoadToA:
    LDY PPUSTATUS   ; reset PPU Addr toggle
    STA PPUADDR   ; write high byte of dest address
    LDA #0
    STA PPUADDR   ; write low byte:  0
    NOJUMP CHRLoad

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  CHR Row Loading    [$E965 :: 0x3E975]
;;
;;  Reads a given number of CHR rows from the given buffer, and writes them to the PPU
;;  It is assumed that the proper PRG bank is swapped in, and that the dest PPU address
;;  has already been set
;;
;;  CHRLoad       zeros Y (source index) before looping
;;  CHRLoad_Cont  does not (retains Y's original value upon call)
;;
;;
;;  IN:   X     = number of rows to load (1 row = 16 tiles or 256 bytes)
;;        (tmp) = source pointer to graphic data.  It is assumed the proper bank is swapped in
;;        Y     = additional source index   (for CHRLoad_Cont only)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHRLoad:
    LDY #$00

CHRLoad_Cont:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPUDATA         ; and write it to CHR-RAM
    INY               ; inc our source index
    BNE CHRLoad_Cont  ; if it didn't wrap, continue looping

    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE CHRLoad_Cont  ; if we've loaded all requested rows, exit.  Otherwise continue loading
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Equip Menu Strings  [$ECDA :: 0x3ECEA]
;;
;;    String is placed at str_buf+$10 because first 16 bytes are used for item_box
;;  (the equipment list)
;;
;;    This routine is called when the equip menus change.  If an item is equipped/unequipped
;;  or dropped, or traded.  As such, the entire string of changed items needs to be redrawn.
;;  therefore for drawing empty slots, multiple blank tiles (FF) must be drawn to erase the
;;  item name that was previously drawn.  Blank tiles must also extend past the end of
;;  shorter equipment names.  So that if you have "Wooden" and trade it with "Cap", you're
;;  not left with "Capden".
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEquipMenuStrings:
    LDA #0                       ; string will be placed at str_buf+$10, and will be 8 bytes long
    STA str_buf+$19              ; so put the null terminator at the end right-off

    LDA #1
    STA menustall                ; the PPU is currently on, so set menustall.

    LDA #$1C-1                   ; A=$1C-1  (1C = start of weapon names in the item list)
    LDX equipoffset
    CPX #ch_weapons - ch_stats   ; buf if we're not dealing with weapons....
    BEQ :+
      LDA #$44-1                 ; A=$44-1  (44 = start of armor names in the item list)
    :   
    STA draweq_stradd            ; this value will be later added to the weapon/armor ID to get
                                 ; the proper string ID.  For now, just stuff it in RAM
                                 ; minus 1 because 0 is an empty slot

    LDA #>(str_buf+$10)          ; set high byte of text pointer
    STA text_ptr+1               ; low byte is set later (why not here?)

    LDA #$00                     ; Set A to zero.  This is our loop counter
  @MainLoop:
    PHA                          ; push the loop counter to the stack
    TAX                          ; then move it to X
    ASL A
    TAY                          ; and move it*2 to Y

    LDA lut_EquipStringPositions, Y     ; use Y to index a positioning LUT
    STA dest_x                          ;  load up x,y coords for this string
    LDA lut_EquipStringPositions+1, Y
    STA dest_y

    LDA #BANK_ITEMS
    CALL SwapPRG                ; swap to the bank containing the item strings

    LDA #$FF                     ; fill first 2 bytes of the string with blank spaces (tile FF)
    STA str_buf+$10              ; later, these spaces will be replaced with "E-" if the item
    STA str_buf+$11              ;  is currently equipped.

    LDA item_box, X              ; get the current item ID
    STA tmp+2                    ; and stick it in temp ram for later

    AND #$7F                     ; remove the equip bit (get just the item ID)
    BNE @LoadName                ; if nonzero, load up the other name...

      LDA #$FF                   ; otherwise (zero), slot is empty, just fill the string with spaces
      STA str_buf+$12
      STA str_buf+$13
      STA str_buf+$14
      STA str_buf+$15
      STA str_buf+$16
      STA str_buf+$17
      STA str_buf+$18
      BNE @NotEquipped           ; then skip ahead (always branches)

  @LoadName:                     ; if the slot is not empty....
    CLC                          ; add the weapon/armor offset to the equipment ID.
    ADC draweq_stradd            ;  now A is the proper item ID

    ASL A                        ; double it
    TAX                          ; and stuff it in X to load up the pointer
    LDA lut_ItemNamePtrTbl, X    ; fetch the pointer and store it to (tmp)
    STA tmp
    LDA lut_ItemNamePtrTbl+1, X
    STA tmp+1

    LDY #$06                     ; copy 7 characters from the item name (doesn't look for null termination)
   @LoadNameLoop:
      LDA (tmp), Y               ; load a character in the string
      STA str_buf+$12, Y         ; and write it to our string buffer.  +2 because the first 2 bytes are the equip state
      DEY                        ; (that "E-" if equipped).  Then decrement Y
      BPL @LoadNameLoop          ; and loop until it wraps (7 iterations)

    LDA tmp+2                    ; get the item ID (to see if it's equipped)
    BPL @NotEquipped             ; if not equipped... skip ahead.  Otherwise

      LDA #$C7                   ; draw special "E" tile
      STA str_buf+$10
      LDA #$C2                   ; and "-" tile.
      STA str_buf+$11            ; draw them to indicate item is equipped

  @NotEquipped:
    LDA #<(str_buf+$10)          ; finally load the low byte of our text pointer
    STA text_ptr                 ;  why this isn't done above with the high byte is beyond me
    FARCALL DrawComplexString_New; then draw the complex string

    PLA                          ; pull the main loop counter
    CLC
    ADC #$01                     ; increment it by one
    CMP #16                      ; and loop until it reaches 16 (16 equipment names to draw)
    BCC @MainLoop

    LDA #BANK_MENUS              ; once all names are drawn
    STA cur_bank                 ; set cur and ret banks (not necessary?) to the MENUS bank
    STA ret_bank
    CALL SwapPRG                ; then swap back to that bank
    RTS                          ; and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  lut for Equip string positions  [$ED72 :: 0x3ED82]
;;
;;   X,Y positions for equipment text to be printed in equip menus

lut_EquipStringPositions:
  .byte $0A, $07,       $14, $07        ; character 0
  .byte $0A, $09,       $14, $09
  
  .byte $0A, $0D,       $14, $0D        ; character 1
  .byte $0A, $0F,       $14, $0F
  
  .byte $0A, $13,       $14, $13        ; character 2
  .byte $0A, $15,       $14, $15
  
  .byte $0A, $19,       $14, $19        ; character 3
  .byte $0A, $1B,       $14, $1B

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Set Battle PPU Addr  [$F233 :: 0x3F243]
;;
;;  Sets PPU addr to be whatever address is indicated by btltmp+6
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetBattlePPUAddr:
    LDA btltmp+7
    STA PPUADDR
    LDA btltmp+6
    STA PPUADDR
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_WritePPUData  [$F23E :: 0x3F24E]
;;
;;    Copies a block of data to PPU memory.  Note that no more than 256 bytes can be copied at a time
;;  with this routine
;;
;;  input:
;;     btltmp+4,5 = pointer to get data from
;;     btltmp+6,7 = the PPU address to write to
;;     btltmp+8   = the number of bytes to write
;;     btltmp+9   = the bank to swap in
;;
;;  This routine will swap back to the battle_bank prior to exiting
;;  It will also reset the scroll.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_WritePPUData:
    LDA btltmp+9                ; swap in the desired bank
    CALL SwapPRG
    
    CALL WaitForVBlank
    CALL SetBattlePPUAddr        ; use btltmp+6,7 to set PPU addr
    
    LDY #$00                    ; Y is loop up-counter
    LDX btltmp+8                ; X is loop down-counter
    
  @Loop:
      LDA (btltmp+4), Y         ; copy source data to PPU
      STA PPUDATA
      INY
      DEX
      BNE @Loop
      
    LDA battle_bank             ; swap battle_bank back in
    CALL SwapPRG
    
    LDA #$00                    ; reset scroll before exiting
    STA PPUMASK
    STA PPUSCROLL
    STA PPUSCROLL
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_ReadPPUData  [$F268 :: 0x3F278]
;;
;;    Reads a given number of bytes from PPU memory.
;;
;;  input:
;;     btltmp+4,5 = pointer to write data to
;;     btltmp+6,7 = the PPU address to read from
;;     btltmp+8   = the number of bytes to read
;;
;;  This routine will swap back to the battle_bank prior to exiting
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
Battle_ReadPPUData:
    CALL WaitForVBlank         ; Wait for VBlank
    CALL SetBattlePPUAddr        ; Set given PPU Address to read from
    LDA PPUDATA                   ; Throw away buffered byte
    LDY #$00
    LDX btltmp+8                ; btltmp+8 is number of bytes to read
  @Loop:
      LDA PPUDATA
      STA (btltmp+4), Y           ; write to (btltmp+4)
      INY
      DEX
      BNE @Loop
      
    LDA battle_bank             ; swap back to desired battle bank, then exit
    JUMP SwapPRG
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleCrossPageJump  [$F284 :: 0x3F294]
;;
;;  Called from a swappable bank to jump to a routine in a different bank.
;;
;;         A = the target bank   (also updates battle_bank)
;;  blttmp+6 = the address of the routine to jump to

BattleCrossPageJump:
    STA battle_bank
    CALL SwapPRG
    JMP (btltmp+6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Battle  [$F28D :: 0x3F29D]
;;
;;    Called to initiate a battle.  Does a lot of prepwork, then calls
;;  another routine to do more prepwork and enter the battle loop.
;;
;;    This routine assumes some CHR and palettes have already been loaded.
;;  Specifically... LoadBattleCHRPal should have been called prior to this routine.
;;
;;    Also somewhat oddly, absolute mode is forced for a lot of zero page vars
;;  here (hence all the "a:" crap).  I have yet to understand that.  Must've been
;;  an assembler quirk.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterBattle:
    CALL WaitForVBlank       ; wait for VBlank and do Sprite DMA
    LDA #>oam                 ;  this seems incredibly pointless as the screen is turned
    STA OAMDMA                 ;  off at this point

    ;; Load formation data to buffer in RAM

    FARCALL LoadBattleFormationInto_btl_formdata

    ;; Turn off PPU and clear nametables

    LDA #0
    STA menustall           ; disable menu stalling
    CALL Battle_PPUOff         ; turn PPU off
    LDA PPUSTATUS                 ; reset PPU toggle

    LDX #>PPUCTRL
    LDA #<PPUCTRL
    CALL SetPPUAddr_XA         ; set PPU address to PPUCTRL (start of nametable)

    LDY #8                    ; loops to clear $0800 bytes of NT data (both nametables)
    @ClearNT_OuterLoop:
        LDX #0
        @ClearNT_InnerLoop:         ; inner loop clears $100 bytes
            STA PPUDATA
            DEX
            BNE @ClearNT_InnerLoop
        DEY                       ; outer loop runs inner loop 8 times
        BNE @ClearNT_OuterLoop    ;  clearing $800 bytes total

    ;; Draw Various (hardcoded) boxes on the screen

    LDA #1              ; box at 1,1
    STA box_x         ; with dims 16,18
    LDX #16             ;  this is the box housing the enemies (big box on the left)
    LDY #18
    CALL BattleBox_vAXY

    LDA #17             ; box at 17,1
    STA box_x         ; with dims 8,16
    LDA #1              ;  this is the box housing the player sprites (box on right)
    LDX #8
    LDY #18
    CALL BattleBox_vAXY

    LDA #25               ; draw the four boxes that will house player stats
    LDX #21               ; draw them from the bottom up so that top boxes appear to lay over
    CALL Battle_PlayerBox  ;  top of the bottom boxes
    LDX #15
    CALL Battle_PlayerBox
    LDX #9
    CALL Battle_PlayerBox
    LDX #3
    CALL Battle_PlayerBox

    FARCALL LoadBattleAttributeTable

    ;; Load palettes

    LDX #0
    @PalLoop:                   ; copy the loaded palettes (backdrop, menu, sprites)
        LDA cur_pal, X          ;  to the battle palette buffer
        STA btl_palettes, X
        INX
        CPX #$20
        BNE @PalLoop            ; all $20 bytes

    LDA btlform_plts          ; use the formation data to get the ID of the palettes to load
    LDY #4                    ;   load the first one into the 2nd palette slot ($xxx4)
    FARCALL LoadBattlePalette
    LDA btlform_plts+1        ;   and the second one into the 3rd slot ($xxx8)
    LDY #8
    FARCALL LoadBattlePalette

  ;; Draw the battle backdrop

    LDA #<$2042                 ; draw the first row of the backdrop
    LDY #0<<2                   ;  to $2042
    FARCALL DrawBattleBackdropRow
    LDA #<$2062                 ; then at $2062
    LDY #1<<2                   ;   draw the next row
    FARCALL DrawBattleBackdropRow
    LDA #<$2082                 ; etc
    LDY #2<<2
    FARCALL DrawBattleBackdropRow
    LDA #<$20A2
    LDY #3<<2
    FARCALL DrawBattleBackdropRow   ; 4 rows total

  ;; Clear the '$FF' tile so it's fully transparent instead of
  ;;   fully solid (normally is innards of box body)

    CALL WaitForVBlank     ; wait for VBlank again  (why!  PPU is off!)
    LDX #>$0FF0
    LDA #<$0FF0             ;  set PPU addr to $0FF0 (CHR for tile $FF)
    CALL SetPPUAddr_XA

    LDA #0
    LDX #$10
  @ClearFFLoop:
      STA PPUDATA             ; write $10 zeros to clear the tile
      DEX
      BNE @ClearFFLoop

    LDA #BANK_BATTLE        ; swap in the battle bank
    STA battle_bank
    CALL SwapPRG
    JMP PrepBattleVarsAndEnterBattle            ; and jump to battle routine!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddr_XA  [$F3BF :: 0x3F3CF]
;;
;;    Sets the PPU Addr to XXAA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddr_XA:
    STX PPUADDR   ; write X as high byte
    STA PPUADDR   ; A as low byte
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_PlayerBox  [$F3C6 :: 0x3F3D6]
;;
;;    Draws a box with width=6 and height=7, at coords A,X  (X=Y coord).
;;  This box is used to house the player name and HP in battle.
;;
;;  This routine takes care to not change A,X or Y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_PlayerBox:
    STA a:box_x        ; record A as X coord
    STX a:box_y        ; record X as Y coord

    PHA                ; then back up A and X
    TXA
    PHA

    LDX #6
    STX a:box_wd       ; set width to 6
    INX
    STX a:box_ht       ; and height to 7

    CALL Battle_PPUOff  ; turn off the PPU
    FARCALL DrawBox        ; draw the box

    PLA                ; restore backed up A, X
    TAX
    PLA

    RTS                ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_Box_vAXY   [$F3E2 :: 0x3F3F2]
;;
;;     Draws a box at coords v,A (where 'v' is box_x) and with dims X,Y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleBox_vAXY:
    STA a:box_y         ; just dump A,X,Y to box_y, box_wd, and box_ht
    STX a:box_wd
    STY a:box_ht
    CALL Battle_PPUOff   ; turn the PPU off
    FARJUMP DrawBox         ; then draw the box

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_PPUOff  [$F3F1 :: 0x3F401]
;;
;;    Used to turn the PPU off for Battles.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_PPUOff:
    LDA #0
    STA a:soft2000     ; clear soft2000
    STA PPUCTRL          ; disable NMIs
    STA PPUMASK          ; and turn off PPU
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleWaitForVBlank  [$F4A1 :: 0x3F4B1]
;;
;;  Identical to WaitForVBlank, but uses btl_soft2000 instead of the regular soft2000
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleWaitForVBlank:
    LDA btl_soft2000
    STA a:soft2000
    JUMP WaitForVBlank
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDrawMessageBuffer  [$F4AA :: 0x3F4BA]
;;
;;  Takes 'btl_msgbuffer' and actually draws it to the PPU.
;;
;;  This process takes 12 frames, as it draws 1 row for each frame.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDrawMessageBuffer:
    LDA #<$2240     ; set target PPU address to $2240
    STA btl_tmpvar3         ; This has the start of the bottom row of the bounding box for 
    LDA #>$2240     ;  enemies
    STA btl_tmpvar4
    
    LDA #<btl_msgbuffer     ; set source pointer to point to message data buffer
    STA btl_varI
    LDA #>btl_msgbuffer
    STA btl_varJ
    
    LDA #$0C
    STA tmp_68b9               ; loop down-counter ($0C rows)
  @Loop:
      CALL Battle_DrawMessageRow_VBlank  ; draw a row
      
      LDA btl_tmpvar1           ; add $20 to the source pointer to draw next row
      CLC
      ADC #$20
      STA btl_varI
      LDA btl_varJ
      ADC #$00
      STA btl_varJ
      
      LDA btl_tmpvar3           ; add $20 to the target PPU address
      CLC
      ADC #$20
      STA btl_tmpvar3
      LDA btl_tmpvar4
      ADC #$00
      STA btl_tmpvar4
      
      FARCALL Battle_UpdatePPU_UpdateAudio_FixedBank    ; update audio (since we did a frame), and reset scroll
      
      DEC tmp_68b9         ; loop for each row
      BNE @Loop
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_DrawMessageRow_VBlank  [$F4E5 :: 0x3F4F5]
;;  Battle_DrawMessageRow         [$F4E8 :: 0x3F4F8]
;;
;;  Draws a row of tiles in the 'message' area on the battle screen.
;;  The row consists of $19 tiles.
;;
;;  input:  btl_varI,btl_varJ = pointer to data to draw
;;          btl_tmpvar3,btl_tmpvar4 = PPU address to draw to.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_DrawMessageRow_VBlank:
    CALL BattleWaitForVBlank
    
Battle_DrawMessageRow:
    LDA btl_tmpvar4
    STA PPUADDR           ; set provided PPU address
    LDA btl_tmpvar3
    STA PPUADDR
    LDY #$00
  @Loop:
      LDA (btl_varI), Y      ; read $19 bytes from source pointer
      STA PPUDATA         ;  and draw them
      INY
      CPY #$19
      BNE @Loop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDrawMessageBuffer_Reverse  [$F4FF :: 0x3F50F]
;;
;;  Takes 'btl_msgbuffer' and actually draws it to the PPU, but draws
;;     the rows in reverse order (bottom up)
;;
;;  Takes 6 frames worth of time, as it draws 2 rows per frame.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDrawMessageBuffer_Reverse:
    LDA #<$23A0         ; start drawing at the bottom row
    STA btl_tmpvar3
    LDA #>$23A0
    STA btl_tmpvar4
    
    LDA #<(btl_msgbuffer + $B*$20)  ; start with the last row of source data
    STA btl_varI
    LDA #>(btl_msgbuffer + $B*$20)
    STA btl_varJ
    
    LDA #$06                ; loop down counter.  6 iterations, 2 rows per iterations
    STA tmp_68b9               ;    = $C rows
    
  @Loop:
      CALL Battle_DrawMessageRow_VBlank  ; draw a row
      CALL @AdjustPointers               ; move ptrs to prev row
      CALL Battle_DrawMessageRow         ; draw another one
      CALL @AdjustPointers               ; move ptrs again
      FARCALL Battle_UpdatePPU_UpdateAudio_FixedBank    ; update audio and stuffs
      
      DEC tmp_68b9
      BNE @Loop         ; loop until all rows drawn
    RTS

  @AdjustPointers:
    LDA btl_tmpvar1     ; subtract $20 from the source pointer
    SEC
    SBC #$20
    STA btl_varI
    LDA btl_varJ
    SBC #$00
    STA btl_varJ
    
    LDA btl_tmpvar3     ; and from the dest pointer
    SEC
    SBC #$20
    STA btl_tmpvar3
    LDA btl_tmpvar4
    SBC #$00
    STA btl_tmpvar4
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  GetBattleMessagePtr  [$F544 :: 0x3F554]
;;
;;  Gets a pointer to the given X,Y position in the battle message buffer.
;;
;;  input:  X = desired X coord
;;          Y = desired Y coord
;;
;;  output:  YX = 16-bit ptr
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetBattleMessagePtr:
    LDA #$00
    STA btl_tmpvar2     ; zero high byte of temp memory
    
    TYA         ; multiply Y coord by $20
    ASL A
    ROL btl_varJ
    ASL A
    ROL btl_varJ
    ASL A
    ROL btl_varJ
    ASL A
    ROL btl_varJ
    ASL A
    ROL btl_varJ     ; high byte gets rolled into btl_varJ
    STA btl_tmpvar1     ; low byte in btl_varI
    
    TXA         ; Add X coord to low byte
    CLC
    ADC btl_varI
    STA btl_varI
    
    LDA #$00    ; add any carry to high byte
    ADC btl_varJ
    STA btl_varJ
    
    CLC                 ; lastly, sum that result with 'btl_msgbuffer'
    LDA #<btl_msgbuffer
    ADC btl_varI
    TAX                 ; low byte in X
    LDA #>btl_msgbuffer
    ADC btl_varJ
    TAY                 ; high byte in Y
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_Row  [$F572 :: 0x3F582]
;;
;;  Draws a single row of tiles for a box
;;
;;  input:
;;               btl_varI,89 = dest pointer to draw to      (updated to point to next row after the routine exits)
;;    btl_msgdraw_width = width of the box
;;       btltmp_boxleft = tile to draw for left side
;;     btltmp_boxcenter = tile to draw for center
;;      btltmp_boxright = tile to draw for right side
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBox_Row:
    LDY #$00
    LDA btltmp_boxleft      ; draw the left tile
    STA (btl_varI), Y
    
    LDX btl_msgdraw_width
    DEX                     ; X is the width-2 (-2 to remove the left/right sides)
    DEX                     ;  this becomes the number of center tiles to draw
    INY
    
    LDA btltmp_boxcenter
  @Loop:                    ; draw all the center tiles
      STA (btl_varI), Y
      INY
      DEX
      BNE @Loop
      
    LDA btltmp_boxright     ; lastly, draw the right tile
    STA (btl_varI), Y
    
    LDA btl_tmpvar1         ; add $20 to the dest pointer to have it point to
    CLC             ;  the next row
    ADC #$20
    STA btl_varI
    LDA btl_varJ
    ADC #$00
    STA btl_varJ
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox  [$F59B :: 0x3F5AB]
;;
;;  Draws a box!
;;
;;  input:
;;      btl_msgdraw_x
;;      btl_msgdraw_y
;;      btl_msgdraw_width
;;      btl_msgdraw_height
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
DrawBattleBox:
    LDX btl_msgdraw_x           ; get X,Y coords of box
    LDY btl_msgdraw_y
    CALL GetBattleMessagePtr
    STX btl_varI                     ; put in btl_varI,btl_varJ, this is our destination pointer
    STY btl_varJ
    
    LDA #$F7                    ; draw the top row of the box
    STA btltmp_boxleft
    LDA #$F8
    STA btltmp_boxcenter
    LDA #$F9
    STA btltmp_boxright
    CALL DrawBattleBox_Row
    
    LDA btl_msgdraw_height      ; get the height of the box
    SEC
    SBC #$02                    ; subtract 2 to make this the number of center rows to draw
    STA temp_68b6                   ; store in temp
    
    LDA #$FA                    ; Draw all the center rows
    STA btltmp_boxleft
    LDA #$FF
    STA btltmp_boxcenter
    LDA #$FB
    STA btltmp_boxright
  @Loop:
      CALL DrawBattleBox_Row
      DEC temp_68b6
      BNE @Loop
      
    LDA #$FC                    ; draw the bottom row
    STA btltmp_boxleft
    LDA #$FD
    STA btltmp_boxcenter
    LDA #$FE
    STA btltmp_boxright
    CALL DrawBattleBox_Row
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_NextBlock  [$F5ED :: 0x3F5FD]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
DrawBattleBox_NextBlock:
    LDA btldraw_blockptrstart   ; just add 5 to the block pointer
    CLC
    ADC #$05
    STA btldraw_blockptrstart
    LDA btldraw_blockptrstart+1
    ADC #$00
    STA btldraw_blockptrstart+1
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_FetchBlock  [$F5FB :: 0x3F60B]
;;
;;  Fetches a block of data to draw for the battle box
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBox_FetchBlock:
    LDY #$00                          ; copy 5 bytes of data
    : LDA (btldraw_blockptrstart), Y  ;  from the $8C pointer
      STA btl_msgdraw_hdr, Y          ;  to the btl_msgdraw vars
      INY
      CPY #$05
      BNE :-
    NOJUMP DrawBattleBox_Exit

DrawBattleBox_Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBoxAndText  [$F608 :: 0x3F618]
;;
;;  Draws a box and the text contained in it.
;;
;;  input:  btldraw_blockptrstart points to the the block data
;;
;;    Block data consists of one or more 5-byte blocks.  The first block specifies the box
;;  to draw, and the following blocks specify the text to be drawn inside it.
;;
;;  First box block:
;;    byte 0 = header (0 - see below)
;;    byte 1 = X position
;;    byte 2 = Y position
;;    byte 3 = width
;;    byte 4 = height
;;
;;  Following text blocks:
;;    byte 0   = header (1 - see below)
;;    byte 1   = X position
;;    byte 2   = Y position
;;    byte 3,4 = pointer to source string
;;
;;  The header byte is tricky to explain.  Each "box" consists of 1 box block + N text blocks.
;;  Therefore the drawing routine will draw 1 block for sure, then will draw additional blocks until
;;  a 0 header byte is found.  This allows it to draw a variable number of text blocks for each box.
;;
;;  So the way it works is, 'box' blocks have a 0 header byte, and text blocks have a 1 header byte.
;;  This means you can chain multiple boxes together, and the drawing routine will know where to stop
;;  drawing because it will hit a 0 header.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBoxAndText:
    CALL DrawBattleBox_FetchBlock        ; get the first box block
    CALL DrawBattleBox                   ; use it to draw the box
  @Loop:
      CALL DrawBattleBox_NextBlock       ; move to next block (text block)
      LDY #$00
      LDA (btldraw_blockptrstart), Y    ; if the header byte is zero
      BEQ DrawBattleBox_Exit            ; exit
      CALL DrawBattleBox_FetchBlock      ; otherwise, fetch the block
      CALL DrawBattleString              ; and use it to draw text
      JUMP @Loop                         ; keep going until null terminator is found

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBlockBuffer  [$F648 :: 0x3F658]
;;
;;  Draw the added blocks to the btl_msgbuffer, then draw the message buffer
;;  to the PPU, and reset the block pointer to the beginning of the buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBlockBuffer:
    CALL DrawBattleBoxAndText        ; Render blocks to the msg buffer
    CALL BattleDrawMessageBuffer     ; Draw message buffer to the PPU
    
    INC btl_msgdraw_blockcount      ; Count the number of blocks we've drawn
    
    LDA btldraw_blockptrstart       ; reset the end pointer to point
    STA btldraw_blockptrend         ;   to the start of the buffer
    LDA btldraw_blockptrstart+1
    STA btldraw_blockptrend+1
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  UndrawBattleBlock  [$F65A :: 0x3F66A]
;;
;;  This erases or "undraws" a battle block.  It does this by wiping the message buffer,
;;  then redrawing all blocks (except for the last one).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UndrawBattleBlock:
    LDA btl_msgdraw_blockcount
    STA tmp_6aa4                       ; backup the block count
    DEC tmp_6aa4                       ; reduce the count by 1 so we draw one less
    FARCALL ClearBattleMessageBuffer    ; erase everything in the buffer
    
    LDA #<btlbox_blockdata          ; reset the blockptr
    STA btldraw_blockptrstart
    LDA #>btlbox_blockdata
    STA btldraw_blockptrstart+1
    
    LDA #$00
    STA btl_msgdraw_blockcount      ; clear the block count
    
  @Loop:
      LDA btl_msgdraw_blockcount    ; compare block count
      CMP tmp_6aa4                     ;   to 1-less-than original block count
      BEQ :+                        ; if we've reached that, we're done
      CALL DrawBattleBoxAndText      ; otherwise, draw another block
      INC btl_msgdraw_blockcount
      JUMP @Loop                     ; and repeat

  : CALL BattleDrawMessageBuffer_Reverse ; reverse-draw to erase the block from the screen
    LDA btldraw_blockptrstart           ; move the end pointer to this position, so
    STA btldraw_blockptrend             ; the block we dropped will be actually removed
    LDA btldraw_blockptrstart+1
    STA btldraw_blockptrend+1
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDraw_AddBlockToBuffer  [$F690 :: 0x3F6A0]
;;
;;  Adds the block stored in 'msgdraw' to the end of the block buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDraw_AddBlockToBuffer:
    TYA                 ; backup Y
    PHA
    
    LDY #$00
  @Loop:
      LDA btl_msgdraw_hdr, Y        ; copy 5 bytes from the msgdraw buffer
      STA (btldraw_blockptrend), Y  ; to the end of our block data
      INY
      CPY #$05
      BNE @Loop
      
    LDA btldraw_blockptrend         ; then add 5 bytes to the end pointer
    CLC                             ; to move it up
    ADC #$05
    STA btldraw_blockptrend
    LDA btldraw_blockptrend+1
    ADC #$00
    STA btldraw_blockptrend+1
    
    LDA #$00                        ; add a null terminator to the end of the
    TAY                             ; block data
    STA (btldraw_blockptrend), Y
    
    PLA                             ; retore Y, and exit
    TAY
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  UndrawNBattleBlocks  [$F6B3 :: 0x3F6C3]
;;
;;  This progressively erases 'N' battle blocks.
;;
;;  A = 'N', the number of blocks to undraw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UndrawNBattleBlocks:
    AND #$FF            ; see if A==0
    BEQ @Exit           ; if zero, just exit
    
    STA tmp_6aa5           ; otherwise, store in temp to use as a downcounter
  @Loop:
      CALL UndrawBattleBlock ; undraw one
      DEC tmp_6aa5             ; dec
      BNE @Loop             ; loop until no more to undraw
  @Exit:
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawRosterBox  [$F6C3 :: 0x3F6D3]
;;
;;    Draws the enemy roster box, containing the names of all the enemies
;;  you're fighting.
;;
;;  in:  btldraw_blockptrstart/end = pointer to a block of memory used for drawing
;;         blocks.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawRosterBox:
    LDY #$05                        ; copy 5 bytes from the roster
    : LDA lut_EnemyRosterBox-1, Y   ;   box to msgdraw
      STA btl_msgdraw_hdr-1, Y      ; (-1 because Y is 1-based in this loop)
      DEY
      BNE :-
      
    CALL BattleDraw_AddBlockToBuffer ; add msgdraw to our block buffer
    INC btl_msgdraw_hdr         ; inc the header so its nonzero
    INC btl_msgdraw_x           ; move right 2 columns
    INC btl_msgdraw_x
    DEC btl_msgdraw_y           ; move up 1 row because we move down 2 rows later,
                                ;  and we really only want to move down 1.
    
    LDY #$00
  @RosterLoop:
      INC btl_msgdraw_y               ; after each row, move down 2 rows
      INC btl_msgdraw_y
    
      TYA
      CALL GetPointerToRosterString    ; put the pointer in tmp_68b3
      LDA tmp_68b3                       ; ... just to move it to btl_msgdraw_srcptr
      STA btl_msgdraw_srcptr          ; (why doesn't GetPointerToRosterString just
      LDA tmp_68b4                       ;  put it in btl_msgdraw_srcptr directly?)
      STA btl_msgdraw_srcptr+1
    
      CALL BattleDraw_AddBlockToBuffer ; Add this block to the draw buffer
      INY
      CPY #$04
      BNE @RosterLoop                 ; loop 4 times (to print each enemy in the roster
      
    JUMP DrawBlockBuffer            ; Then actually draw it!
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawCommandBox  [$F700 :: 0x3F710]
;;
;;    Draws the command box ("Fight", "Magic", "Drink", etc)
;;
;;  in:  btldraw_blockptrstart/end = pointer to a block of memory used for drawing
;;         blocks.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawCommandBox:
    LDY #$00
    LDX #$00
  @Loop:
      LDA lua_BattleCommandBoxInfo, Y           ; copy 6*5 bytes (6 blocks)
      STA btl_msgdraw_hdr, X
      INX
      CPX #$05
      BNE :+                                    ; every 5 bytes, add the block to the
        CALL BattleDraw_AddBlockToBuffer         ;  output buffer
        LDX #$00
    : INY
      CPY #6*5              ; 6 blocks * 5 bytes per block
      BNE @Loop
      
    JUMP DrawBlockBuffer            ; then finally draw it
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawCombatBox  [$F71C :: 0x3F72C]
;;
;;  input:  A = ID of box to draw (0-4)
;;         YX = pointer to text data to put in that box
;;
;;  Combat boxes are the boxes that pop up during combat that show attackers/damage/etc.
;;  See lut_CombatBoxes for more.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawCombatBox:
    STX tmp_68b3           ; stuff X,Y in temp mem
    STY tmp_68b4
    
    ASL A               ; Y = A * 8  (8 bytes per box)
    ASL A
    ASL A
    TAY
    
    LDX #$00
    : LDA lut_CombatBoxes, Y    ; copy first 5 bytes (Box data)
      STA btl_msgdraw_hdr, X
      INX
      INY
      CPX #$05
      BNE :-
    CALL BattleDraw_AddBlockToBuffer ; add the block
    
    LDX #$00
    : LDA lut_CombatBoxes, Y    ; copy 3 more bytes (Text data)
      STA btl_msgdraw_hdr, X
      INX
      INY
      CPX #$03
      BNE :-
      
    LDA tmp_68b3                   ; use temp mem (YX provided at start of routine)
    STA btl_msgdraw_srcptr      ;  as pointer to text data
    LDA tmp_68b4
    STA btl_msgdraw_srcptr+1
    
    CALL BattleDraw_AddBlockToBuffer ; add this text block
    JUMP DrawBlockBuffer             ; then draw it.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ClearUnformattedCombatBoxBuffer  [$F757 :: 0x3F767]
;;
;;  Clears it with *spaces*, not with null.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearUnformattedCombatBoxBuffer:
    LDY #$00                ; pretty self explanitory routine
    LDA #$FF
    : STA btl_unfmtcbtbox_buffer, Y    ; fill buffer ($80 bytes) with $FF
      INY
      CPY #$80
      BNE :-
      
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleMagicBox  [$F764 :: 0x3F774]
;;
;;    Draws the "Magic box" that appears in the battle menu when the player
;;  selects the MAGIC option in the battle menu.
;;
;;  input:     tmp_6af8 = The page to draw.  0 will draw L1-4 spell page, 1 will draw L5-8 spell page
;;    btlcmd_curchar = the character whose spells we're drawing
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleMagicBox:
    LDY #$05                                ; prep the block for the magic/item box
    : LDA lut_CombatItemMagicBox-1, Y
      STA btl_msgdraw_hdr-1, Y
      DEY
      BNE :-
    CALL BattleDraw_AddBlockToBuffer         ; add it to the block buffer
    
    CALL ClearUnformattedCombatBoxBuffer     ; clear the unformatted buffer (so we can draw to it)
    
    INC btl_msgdraw_hdr     ; inc hdr (should be 1 for text blocks)
    INC btl_msgdraw_x       ; move down+right 1 tile for text
    INC btl_msgdraw_y
    
    LDA #$00
    STA temp_68b5               ; loop counter / row index
    
    LDA btlcmd_curchar
    CALL ShiftLeft6          ; get current character*$40
    CLC
    ADC #<ch_magicdata      ; and add with ch_magic dat
    STA btl_tmpvar1                 ; to get a pointer to this character's magic list
    LDA #$00                ;   and put it in btl_varI,89
    ADC #>ch_magicdata
    STA btl_varJ
    
    LDA tmp_6af8               ; See if we're drawing the top or bottom page
    BNE @BottomPage
    
  @TopPage:
    LDA temp_68b5               ; row index
    ASL A
    ASL A                   ; row index * 4 in Y
    TAY                     ; used as source index to get the magic
    
    ASL A
    ASL A
    ASL A                   ; row index * $20 in X
    TAX                     ; used as dest index to the unformatted buffer
    
    ; Print the 'L#' text on the left side of the box
    LDA #$95                        ; 'L'
    STA btl_unfmtcbtbox_buffer, X
    LDA temp_68b5
    CLC
    ADC #$81                        ; '1' + row (level)
    STA btl_unfmtcbtbox_buffer+1, X
    
    ; Print the names of the spells
    CALL BattleMenu_DrawMagicNames
    
    ; Print the MP amount
    LDA #ch0_curmp - ch_magicdata    ; since btl_varI,89 points to magic list, and the
    CLC                             ;  MP is right after that, just change the Y index
    ADC temp_68b5                       ;  to access the MP.
    TAY                             ; Add the row counter to get this level's MP count
    
    LDA (btl_varI), Y                    ; get the MP count
    CLC
    ADC #$80                        ; + $80 to convert to the tile
    STA btl_unfmtcbtbox_buffer + 12, X  ; print that tile
    LDA #$00
    STA btl_unfmtcbtbox_buffer + 13, X  ; null terminate the string
    
    
    TXA                             ; get the dest index, and add to the pointer
    CLC                             ;  to the unformatted buffer.
    ADC #<btl_unfmtcbtbox_buffer    ; set the source pointer
    STA btl_msgdraw_srcptr
    LDA #$00
    ADC #>btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr+1
    
    CALL BattleDraw_AddBlockToBuffer ; Add that block to the block buffer
    
    INC btl_msgdraw_y               ; then move down 2 rows
    INC btl_msgdraw_y
    INC temp_68b5                       ; inc the row counter
    LDA temp_68b5
    CMP #$04
    BNE @TopPage                    ; and loop until all 4 rows drawn
    JUMP @Done
    
    
  @BottomPage:                      ; This is identical to @TopPage, only it changes
    LDA temp_68b5                       ;  a few constants to print the bottom page instead.
    ASL A                           ; Comments here will be sparse.
    ASL A
    TAY
    
    ASL A
    ASL A
    ASL A
    TAX
    
    TYA                             ; Add 4*4 to move to L4 spells
    CLC
    ADC #4*4
    TAY
    
    LDA #$95                        ; 'L'
    STA btl_unfmtcbtbox_buffer, X
    LDA temp_68b5
    CLC
    ADC #$85                        ; '5' + row
    STA btl_unfmtcbtbox_buffer+1, X
    CALL BattleMenu_DrawMagicNames
    
    LDA #ch0_curmp - ch_magicdata + 4
    CLC
    ADC temp_68b5
    TAY
    
    LDA (btl_varI), Y
    CLC
    ADC #$80
    STA btl_unfmtcbtbox_buffer + 12, X
    LDA #$00
    STA btl_unfmtcbtbox_buffer + 13, X
    
    TXA
    CLC
    ADC #<btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr
    LDA #$00
    ADC #>btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr+1
    
    CALL BattleDraw_AddBlockToBuffer
    
    INC btl_msgdraw_y
    INC btl_msgdraw_y
    INC temp_68b5
    LDA temp_68b5
    CMP #$04
    BNE @BottomPage

  @Done:
    JUMP DrawBlockBuffer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleMenu_DrawMagicNames  [$F844 :: 0x3F854]
;;
;;  Prints a row of spell names to the unformatted combat box buffer.  The below string is printed:
;;    __ __ __ xx xx FF xx xx FF xx xx
;;
;;  '__' bytes are skipped.  These are filled with the "L# " text in another routine
;;  'xx xx' bytes are either '0E id' to print the spell name, or '10 04' to print 4 spaces if the slot is empty
;;
;;  input:   btl_varI,89 + Y = source pointer + index to the player's spells to print
;;                    X = dest index to print to in the unformatted buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleMenu_DrawMagicNames:
    LDA #$0E
    STA btl_unfmtcbtbox_buffer + 3, X   ; set the 3 '0E' control codes to print item names
    STA btl_unfmtcbtbox_buffer + 6, X
    STA btl_unfmtcbtbox_buffer + 9, X
    
    LDA (btl_varI), Y                        ; check slot 0
    BNE :+                              ; if it's empty (no spell)
      LDA #$10
      STA btl_unfmtcbtbox_buffer + 3, X ; replace 0E code with 10 code to print spaces
      LDA #$04
      STA btl_unfmtcbtbox_buffer + 4, X ; 04 to print 4 spaces
      JUMP @Column1
  : CLC                                 ; otherwise (not empty), onvert from a 1-based magic index
    ADC #MG_START-1                     ; to a 0-based item index, and put the index after the '0E' code
    STA btl_unfmtcbtbox_buffer + 4, X

  @Column1:                             ; Then repeat the above process for each of the 3 columns
    INY
    LDA (btl_varI), Y
    BNE :+
      LDA #$10
      STA btl_unfmtcbtbox_buffer + 6, X
      LDA #$04
      STA btl_unfmtcbtbox_buffer + 7, X
      JUMP @Column2
  : CLC
    ADC #MG_START-1
    STA btl_unfmtcbtbox_buffer + 7, X
    
  @Column2:
    INY
    LDA (btl_varI), Y
      BNE :+
      LDA #$10
      STA btl_unfmtcbtbox_buffer + 9, X
      LDA #$04
      STA btl_unfmtcbtbox_buffer + 10, X
      JUMP @Done
  : CLC
    ADC #MG_START-1
    STA btl_unfmtcbtbox_buffer + 10, X
    
  @Done:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ShiftLeft routines  [$F897 :: 0x3F8A7]
;;
;;  Convenience routines to shift left a few times.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ShiftLeft6:
    ASL A
ShiftLeft5:
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleItemBox  [$F89E :: 0x3F8AE]
;;
;;    Draws the "Item box" that appears in the battle menu when the player
;;  selects the ITEM option in the battle menu
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleItemBox:
    LDY #$05                                ; 5 bytes of block data
    : LDA lut_CombatItemMagicBox-1, Y       ; copy over the block data for the Item box
      STA btl_msgdraw_hdr-1, Y
      DEY
      BNE :-
    CALL BattleDraw_AddBlockToBuffer         ; Add the block to the buffer to be drawn
    CALL ClearUnformattedCombatBoxBuffer     ; Chear the unformatted buffer (we'll be drawing to it shortly)
    
    INC btl_msgdraw_hdr     ; hdr=1 for contained text
    INC btl_msgdraw_x       ; move draw coords right+down 1 tile
    INC btl_msgdraw_y
    
    LDA #$00
    STA temp_68b5               ; loop counter and equip slot to print (0-3)
    
    LDA btlcmd_curchar
    CALL ShiftLeft6          ; Get the char stat index in X (00,40,80,C0)
    TAX                     ;  This will be the source index
    
    ; Loop 4 times, once for each row.
    ; 
    ; Each row consists of 8 bytes of unformatted data:
    ;    FF 0E xx FF FF 0E xx 00        where:
    ; FF    = space
    ; 0E xx = code to draw item 'xx's name
    ; 00    = null terminator
    ;
    ; Alternatively, instead of '0E xx', it will output '10 07' if the weapon slot is empty
    ;   which will draw 07 spaces.
    ; If the armor slot is empty, then it'll null terminate the string with 00 instead of
    ;   having the 2nd '0E xx'.
    ;
    ; Strangely, even though only 8 bytes are used, the game spaces rows $20 bytes apart
  @MainLoop:
    LDA temp_68b5               ; Row number * $20 in Y
    CALL ShiftLeft5          ; This is the offset in the unformatted buffer to print to
    TAY
    
    LDA #$0E
    STA btl_unfmtcbtbox_buffer + 1, Y   ; put in the 0E control codes
    STA btl_unfmtcbtbox_buffer + 5, Y
    
    LDA ch_weapons, X                   ; check the weapon slot
    BEQ @NoWeapon                       ; if it's not empty...
      AND #$7F                          ; mask off the 'equipped' bit
      CLC
      ADC #TCITYPE_WEPSTART-1           ; convert from 1-based weapon index, to 0-based item index
      JUMP :+
  @NoWeapon:                            ; if it IS empty
      LDA #$10
      STA btl_unfmtcbtbox_buffer + 1, Y ; replace the 0E control code with 10 control code
      LDA #$07                          ; 7 spaces
  : STA btl_unfmtcbtbox_buffer + 2, Y
    
    LDA ch_armor, X                     ; check armor slot
    BEQ :+                              ; if zero, jump ahead to print the 0 as a null terminator.
      AND #$7F                          ; if nonzero, turn off the equipped bit
      CLC
      ADC #TCITYPE_ARMSTART-1           ; convert from 1-based armor index to 0-based item index
  : STA btl_unfmtcbtbox_buffer + 6, Y
  
    LDA #$00
    STA btl_unfmtcbtbox_buffer + 7, Y   ; null terminate the string
    
    TYA                                 ; set the source pointer to the unformatted
    CLC                                 ;  buffer + the offset
    ADC #<btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr
    LDA #$00
    ADC #>btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr+1
    
    CALL BattleDraw_AddBlockToBuffer     ; then draw this row
    
    INX                                 ; inc source index
    INC btl_msgdraw_y                   ; move drawing down 2 rows
    INC btl_msgdraw_y
    INC temp_68b5                           ; inc the row counter
    LDA temp_68b5
    CMP #$04                            ; loop until 4 rows are drawn
    BNE @MainLoop
    
    ; Finally, after all rows added, Actually draw the block buffer and exit
    JUMP DrawBlockBuffer
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawDrinkBox  [$F921 :: 0x3F931]
;;
;;    Draws the "Drink box" that appears in the battle menu when the player
;;  selects the DRINK option in the battle menu
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawDrinkBox:
    LDY #$05
    : LDA lut_CombatDrinkBox-1, Y       ; load the specs for the drink box
      STA btl_msgdraw_hdr-1, Y          ; -1 because Y is 1-based
      DEY
      BNE :-
    CALL BattleDraw_AddBlockToBuffer     ; add the box to the block buffer
    
    CALL ClearUnformattedCombatBoxBuffer ; clear the unformatted buffer (we'll be drawing to it)
    
    INC btl_msgdraw_hdr                 ; For text, hdr=1
    INC btl_msgdraw_x                   ; move text right+down 1 tile from where the box was drawn
    INC btl_msgdraw_y
    LDA btl_potion_heal
    BEQ :+                              ; if there are any heal potions
      STA btl_unfmtcbtbox_buffer + 5    ; set buffer to:   FF 0E 19 FF 11 xx xx 00  noting:
      LDA #$11                          ;   FF       = space
      STA btl_unfmtcbtbox_buffer + 4    ;   0E 19    = 0E prints an item name, 19 indicates the Heal Potion item
      LDA #$19                          ;   11 xx xx = 11 prints a number, xx xx is the qty (which in this case is 
      STA btl_unfmtcbtbox_buffer + 2    ;                  the number of potions
      LDA #$0E
      STA btl_unfmtcbtbox_buffer + 1
      
  : LDA #$00
    STA btl_unfmtcbtbox_buffer + 6      ; The high byte of the qty
    STA btl_unfmtcbtbox_buffer + 7      ; The null terminator
    
    LDA #<btl_unfmtcbtbox_buffer        ; set the block pointer to the data
    STA btl_msgdraw_srcptr
    LDA #>btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr+1
    CALL BattleDraw_AddBlockToBuffer     ; and add the block (drawing the Heal Potions)
    
    
    INC btl_msgdraw_y                   ; move down 2 rows for Pure portions
    INC btl_msgdraw_y
    LDA btl_potion_pure
    BEQ :+
      STA btl_unfmtcbtbox_buffer + $25  ; Exact same deal as above, only it works for the Pure Potion
      LDA #$11
      STA btl_unfmtcbtbox_buffer + $24
      LDA #$1A
      STA btl_unfmtcbtbox_buffer + $22
      LDA #$0E
      STA btl_unfmtcbtbox_buffer + $21

  : LDA #$00
    STA btl_unfmtcbtbox_buffer + $26
    STA btl_unfmtcbtbox_buffer + $27
    
    LDA #<(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr
    LDA #>(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr+1
    CALL BattleDraw_AddBlockToBuffer     ; add the block for the Pure potions
    
    JUMP DrawBlockBuffer                 ; then draw the actual blocks and exit
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  GetPointerToRosterString  [$F99C :: 0x3F9AC]
;;
;;  A is the roster entry to get (0-3)
;;
;;  A pointer to that roster string is put in tmp_68b3 (temp memory)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetPointerToRosterString:
    ASL A                           ; *2 (2 bytes per string)
    CLC
    ADC #<lut_EnemyRosterStrings    ; add to the lut address
    STA tmp_68b3
    LDA #$00
    ADC #>lut_EnemyRosterStrings
    STA tmp_68b4
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString  [$F9AB :: 0x3F9BB]
;;
;;  Formats and prints a battle string (See FormatBattleString for the format of the string)
;;
;;  input:  btl_msgdraw_x,y     = dest pointer to draw the string to
;;          btl_msgdraw_srcptr  = source pointer to the string
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString:
    LDX btl_msgdraw_x
    LDY btl_msgdraw_y
    CALL GetBattleMessagePtr
    STX btl_tmpvar3                 ; store target pointer in temp ram
    STY btl_tmpvar4
    
    LDX btl_msgdraw_srcptr
    LDY btl_msgdraw_srcptr+1
    CALL FormatBattleString  ; draw the battle string to the output buffer
    
    LDY #$00                ; move 'top bytes' from string output buffer to the
    LDX #$00                ;  actual draw buffer
  @TopLoop:
      LDA btl_stringoutputbuf, X
      BEQ @StartBottomLoop
      STA (btl_tmpvar3), Y
      INY
      INX                   ; INX *2 because top/bottom tiles are interleaved
      INX
      JUMP @TopLoop          ; loop until we hit the null terminator
    
  @StartBottomLoop:         ; move 'bottom bytes'
    LDY #$20
    LDX #$00
  @BottomLoop:
      LDA btl_stringoutputbuf+1, X
      BEQ @Exit
      STA (btl_tmpvar3), Y
      INY
      INX
      INX
      JUMP @BottomLoop
    
  @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  small lut for the enemy roster box  [$F9E4 :: 0x3F9F4]
;;  This is the box drawn around the enemy names in the battle screen.

lut_EnemyRosterBox:
;       hdr   X    Y  width  height
  .byte $00, $01, $00, $0B, $0A
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Combat box lut          [$F9E9 :: 0x3F9F9]
;;
;;  These are all the boxes that pop up during combat to show attackers/damage/etc

lut_CombatBoxes:
;             BOX                      TEXT
;       hdr    X    Y   wd   ht     hdr    X    Y
  .byte $00, $01, $01, $0A, $04,    $01, $02, $02       ; attacker name
  .byte $00, $0B, $01, $0C, $04,    $01, $0C, $02       ; their attack ("FROST", "2Hits!" etc)
  .byte $00, $01, $04, $0A, $04,    $01, $02, $05       ; defender name
  .byte $00, $0B, $04, $0B, $04,    $01, $0C, $05       ; damage
  .byte $00, $01, $07, $18, $04,    $01, $02, $08       ; bottom message ("Terminated", "Critical Hit", etc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Combat Item/Magic Box lut    [$FA11 :: 0x3FA21]
;;
;;      The box that pops up for the ITEM and MAGIC menus

lut_CombatItemMagicBox:
;       hdr    X    Y   wd   ht 
  .byte $00, $02, $01, $16, $0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Combat Drink Box lut    [$FA16 :: 0x3FA26]
;;
;;      The weird miniature box that pops up for the DRINK menu

lut_CombatDrinkBox:
;       hdr    X    Y   wd   ht 
  .byte $00, $03, $01, $0C, $06
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut for the battle command box  [$FA1B :: 0x3FA2B]

lua_BattleCommandBoxInfo:
;       hdr,  X    Y    W    H
  .byte $00, $0C, $00, $0D, $0A         ; box
;       hdr,  X    Y    ptr
  .byte $01, $0E, $01, <@txt0, >@txt0   ; text
  .byte $01, $0E, $03, <@txt1, >@txt1
  .byte $01, $0E, $05, <@txt2, >@txt2
  .byte $01, $0E, $07, <@txt3, >@txt3
  .byte $01, $14, $01, <@txt4, >@txt4
  
  
  @txt0:  .byte $EF, $F0, $F1, $F2, $00     ; "FIGHT"
  @txt1:  .byte $EB, $EC, $ED, $EE, $00     ; "MAGIC"
  @txt2:  .byte $F3, $F4, $F5, $F6, $00     ; "DRINK"
  @txt3:  .byte $92, $9D, $8E, $96, $00     ; "ITEM"
  @txt4:  .byte $9B, $9E, $97, $00          ; "RUN"
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut for enemy roster strings  [$FA51 :: 0x3FA61]

lut_EnemyRosterStrings:
  .byte $08, $00        ; these are just the roster control codes, followed by the null terminator
  .byte $09, $00
  .byte $0A, $00
  .byte $0B, $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  FormatBattleString  [$FA59 :: 0x3FA69]
;;
;;  input:   XY points to the buffer containing the null terminated string to draw
;;
;;  output:  btl_stringoutputbuf - contains the formatted output string (INTERLEAVED - See below)
;;
;;    The source string can contain the following control codes:
;;
;;  00       = null terminator (marks end of string)
;;  02       = print attacker's name
;;  03       = print defender's name
;;  04       = print character 0's name
;;  05       = print character 1's name
;;  06       = print character 2's name
;;  07       = print character 3's name
;;  08       = print enemy roster entry 0
;;  09       = print enemy roster entry 1
;;  0A       = print enemy roster entry 2
;;  0B       = print enemy roster entry 3
;;  0C xx yy = yyxx is a pointer to a number to print
;;  0E xx    = print attack name.  For player attacks, 'xx' is the item index (which can also
;;             be a magic name).
;;             For enemy attacks, 'xx' is either a special enemy attack index (like "FROST", etc)
;;             or is an item index.  Whether it is special attack or not is determined by btl_attackid
;;  0F xx    = Draws a battle message.  xx = the ID to the battle message.  Note that this ID is
;;             1-based, NOT zero based like you'd expect
;;  10 xx    = print a run of spaces.  xx = the run length
;;  11 xx yy = yyxx is a number to print
;;
;;  Values >= $48 are printed as normal tiles.
;;
;;    Other values below $48 that are not control codes will either do nothing
;;  or will do a glitched version of one of the above codes.
;;
;;    Note that the output string produced by this routine is interleaved.  There are 2 bytes per
;;  character, the first being the "top" portion of the char, and the second being the "bottom"
;;  portion.  This was used in the Japanese ROM to more easily print some Hiragana, but in the US
;;  version it is totally useless and the top portion is always blank space (tile $FF).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FormatBattleString:
    LDA #$00
    STA loop_counter               ;  ????  no idea what this does
    
    CALL SwapBtlTmpBytes     ; swap out btltmp bytes to back them up
    
    STX btldraw_src         ; store source pointer
    STY btldraw_src+1
    
    LDY #$00                ; copy the actual string data to a buffer in RAM
    : LDA (btldraw_src), Y  ;   (presumably so we can swap out banks without fear
      STA btl_stringbuf, Y  ;    of swapping out our source data)
      INY
      CPY #$20              ; no strings can be longer than $20 characters.
      BNE :-
      
    LDA #<btl_stringbuf     ; Change source pointer to point to our buffered
    STA btldraw_src         ;   string data
    LDA #>btl_stringbuf
    STA btldraw_src+1
    
    LDA #<btl_stringoutputbuf   ; Set our output pointer to point to
    STA btldraw_dst             ;   our string output buffer
    LDA #>btl_stringoutputbuf
    STA btldraw_dst+1
    
    ; Iterate the string and draw each character
  @Loop:
    LDX #$00
    LDA (tmp_90, X)        ; get the first char
    BEQ @Done           ; stop at the null terminator
    CMP #$48
    BCS :+
        CALL DrawBattleString_ControlCode    ; if <  #$48
        JUMP :++
    :     
    CALL DrawBattleString_ExpandChar    ; if >= #$48
    :   
    CALL DrawBattle_IncSrcPtr    ; Inc the source pointer and continue looping
    JUMP @Loop
    
  @Done:
    LDA #$00
    LDY #$00
    STA (btldraw_dst), Y            ; add null terminator
    INY
    STA (btldraw_dst), Y
    JUMP SwapBtlTmpBytes     ; swap back the original btltmp bytes, then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_ExpandChar  [$FAA6 :: 0x3FAB6]
;;
;;  Takes a single character, expands it to top/bottom pair, and then draws it
;;     btldraw_dst = pointer to the output buffer
;;               A = char to draw
;;
;;  Most of this routine isn't used because the text printed in the US version
;;     does not have a top part.  Most of it is a big else/if chain to determine
;;     which top part to use.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_ExpandChar:
    STA btltemppointer         ; char code
    PHA             ; backup A/X/Y
    TXA
    PHA
    TYA
    PHA
    LDA btltemppointer         ; get the char code
    CMP #$7A
    BCS :+
      BCC @c01_79
      
  : LDX #$FF        ; if the character is >= $7A (normal character), no decoration
    BNE @Output     ;   use $FF (blank space) as decoration

  @c01_79:          ; code 01-79
    LDX #$C0        ; use $C0 as default decoration
    CMP #$57
    BCS @c57_79
    ADC #$47
    BNE @Output
    
  @c57_79:
    CMP #$5C
    BCS @c5C_79
    ADC #$4C
    BNE @Output
    
  @c5C_79:
    CMP #$6B
    BCS @c6B_79
    ADC #$73
    BNE @Output
  
  @c6B_79:
    CMP #$70
    BCS @c70_79
    ADC #$78
    BNE @Output
    
  @c70_79:
    LDX #$C1
    CMP #$75
    BCS @c75_79
    ADC #$33
    BNE @Output
    
  @c75_79:
    CLC
    ADC #$6E
  
  @Output:
    CALL DrawBattleString_DrawChar
    PLA
    TAY
    PLA
    TAX
    PLA             ; restore backup
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_DrawChar  [$FAF1 :: 0x3FB01]
;;
;;  Draws a single character to the output buffer
;; btldraw_dst = pointer to the output buffer
;;           X = top part of char
;;           A = bottom part of char
;;
;;  See DrawBattleSubString for explanation of top/bottom parts
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_DrawChar:
    LDY #$01
    STA (btldraw_dst), Y        ; put bottom part is position [1]
    DEY
    TXA
    STA (btldraw_dst), Y        ; and top part in position [0]
    JUMP DrawBattleString_IncDstPtr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattle_Division   [$FAFC :: 0x3FB0C]
;;
;;    Kind of a junky division routine that is used by FormatBattleString
;;  to draw numerical values.
;;
;;  end result:
;;                  A = btltmp6,7 / YX
;;          btltmp6,7 = btltmp6,7 % YX   (remainder)
;;
;;    This division routine is a simple "keep subtracting until we
;;  fall below zero".  Which means that if btltmp+6,7 is zero, the
;;  routine will loop forever and the game will deadlock.  This routine
;;  is kind of junky.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattle_Division:
    LDA #$00
    STA btl_magdataptr         ; initialize result with zero
  @Loop:
    STX btlsfxnse_len
    LDA btltmp+6
    SEC
    SBC btlsfxnse_len
    PHA             ; low byte = btlsfxnse_len-X, back it up
    
    STY btlsfxnse_len
    LDA btltmp+7
    SBC btlsfxnse_len         ; high byte = $97-Y
    
    BMI @Done       ; if result is negative, we're done
    
    INC btl_magdataptr         ; otherwise, increment our result counter
    STA btltmp+7    ; overwrite btltmp+6 with the result of the subtraction
    PLA
    STA btltmp+6
    JUMP @Loop       ; and keep going until we fall below zero
    
  @Done:            ; once the result is negative
    PLA             ; throw away the back-up byte
    LDA btl_magdataptr         ; and put the result in A before exiting
    RTS

;;  DrawBattleString_Code11  [$FB1E :: 0x3FB2E]
DrawBattleString_Code11:            ; print a number 
    CALL DrawBattle_IncSrcPtr        ;   pointer to the number to print is in the source string
    LDA btldraw_src
    STA btldraw_subsrc              ; since the number is embedded in the source string, just use
    LDA btldraw_src+1               ; the pointer to the source string as the pointer to the number
    STA btldraw_subsrc+1
    CALL DrawBattle_IncSrcPtr
    JUMP DrawBattle_Number

;;  DrawBattleString_Code0C  [$FB2F :: 0x3FB3F]
DrawBattleString_Code0C:            ; print a number (indirect)
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y            ; pointer to a pointer to the number to print
    STA btldraw_subsrc
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y
    STA btldraw_subsrc+1
    NOJUMP DrawBattle_Number

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattle_Number  [$FB3D :: 0x3FB4D]
;;
;;  Converts a number to text and prints it (for FormatBattleString)
;;
;;  input:
;;    btldraw_subsrc = pointer to the 2-byte number to draw.
;;    Y should be 0 upon entry
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattle_Number:
    LDA (btldraw_subsrc), Y     ; get the number to print, stuff it in tmp_96,tmp_97
    STA tmp_96
    INY
    LDA (btldraw_subsrc), Y
    STA tmp_97
    
    LDX #<10000
    LDY #>10000
    CALL DrawBattle_Division
    STA tmp_9a                     ; start pulling digits out and stuff them in tmp_9a
    LDX #<1000
    LDY #>1000
    CALL DrawBattle_Division
    STA tmp_9b
    LDX #<100
    LDY #>100
    CALL DrawBattle_Division
    STA tmp_9c
    LDX #<10
    CALL DrawBattle_Division
    STA tmp_9d
    
    LDX #$00
  @FindFirstDigit:
    LDA tmp_9a, X          ; keep getting individual digits  (note that INX is done before 
    INX                 ;    this digit is printed, so we have to read from tmp_9a-1 when printing)
    CPX #$05            ; skip ahead to printing the 1's digit 
    BEQ @OnesDigit      ;  if we've exhausted all 5 digits.
    ORA #$00            ; Otherwise, check this digit (OR to update Z flag)
    BEQ @FindFirstDigit ;  if it's zero, don't print anything, and move to next digit
    
  @PrintDigits:
    LDY #$01                ; Y=1 to print the bottom part first
    LDA tmp_9a-1, X            ; get the digit
    ORA #$80                ; OR with #$80 to get the tile
    STA (btldraw_dst), Y    ; print the numerical tile
    LDA #$FF
    DEY
    STA (btldraw_dst), Y    ; print the empty space for the top part
    
    CALL DrawBattleString_IncDstPtr
    INX
    CPX #$05
    BNE @PrintDigits            ; loop until only the 1s digit is left
    
  @OnesDigit:
    LDA btltmp+6                    ; fetch the 1s digit
    ORA #$80
    LDX #$FF
    JUMP DrawBattleString_DrawChar   ; and print it
    
;;  DrawBattleString_Code11_Short  [$FB93 :: 0x3FBA3]
;;    Just jumps to the actual routine.  Only exists here because the routine is too
;;  far away to branch to.
DrawBattleString_Code11_Short:
    JUMP DrawBattleString_Code11

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_ControlCode  [$FB96 :: 0x3FBA6]
;;
;;    Print a control code.  See FormatBattleString for details
;;  A = the control code
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_ControlCode:
    CMP #$02
    BEQ @PrintAttacker          ; code:  02
    CMP #$03
    BEQ @PrintDefender          ; code:  03
    CMP #$08
    BCC @PrintCharacterName     ; codes: 04-07
    CMP #$0C
    BCC @PrintRoster            ; codes: 08-0B
    BEQ DrawBattleString_Code0C ; code:  0C
    CMP #$0E
    BEQ @PrintAttackName        ; code:  0E
    CMP #$0F
    BEQ DrawBattleMessage       ; code:  0F
    CMP #$10
    BNE :+
      JUMP DrawString_SpaceRun   ; code:  10
  : CMP #$11
    BEQ DrawBattleString_Code11_Short   ; code:  11
    
  @Exit:
    RTS

  @PrintAttacker:       ; code: 02
    LDA btl_attacker
    JUMP DrawEntityName
  @PrintDefender:       ; code: 03
    LDA btl_defender
    JUMP DrawEntityName
  
  @PrintCharacterName:  ; codes:  04-07
    SEC
    SBC #$04            ; subtract 4 to make it zero based
    ORA #$80            ; OR with $80 to make it a character entity ID
    JUMP DrawEntityName  ; then print it as an entity
    
    ; Print an entry on the enemy roster
  @PrintRoster:             ; codes: 08-0B
    SEC                     ; subtract 8 to make it zero based
    SBC #$08
    TAX
    LDA btl_enemyroster, X  ; get the roster entry
    CMP #$FF
    BEQ @Exit               ; if 'FF', that signals an empty slot, so don't print anything.
    JUMP DrawEnemyName       ; then draw that enemy's name
    
    
  @PrintAttackName:     ; code:  0E
    LDA #BANK_ITEMS
    CALL SwapPRG
    LDA btl_attacker                ; check the attacker.  If the high bit is set (it's a player).
    BMI @PrintAttackName_AsItem     ; Player special attacks are always items (or spells, which are stored with items)
    
    LDA btl_attackid                ; otherwise, this is an enemy, so get his attack
    CMP #$42                        ; if it's >= 42, then it's a special enemy attack
    BCC @PrintAttackName_AsItem     ; but less than 42, print it as an item (magic spell)
    
    LDA #>(lut_EnemyAttack - $42*2) ; subtract $42*2 from the start of the lookup table because the enemy attack
    LDX #<(lut_EnemyAttack - $42*2) ;   index starts at $42
    JUMP :+
    
  @PrintAttackName_AsItem: ; attack is less than $42
    LDA #>lut_ItemNamePtrTbl
    LDX #<lut_ItemNamePtrTbl
    
  : CALL BattleDrawLoadSubSrcPtr
    JUMP DrawBattleSubString_Max8
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDrawLoadSubSrcPtr  [$FC00 :: 0x3FC10]
;;
;;  input:       XA = 16-bit pointer to the start of a pointer table
;;
;;  output:  btldraw_subsrc
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDrawLoadSubSrcPtr:
    STA tmp_97             ; high byte of pointer table
    
    CALL DrawBattle_IncSrcPtr
    LDA (tmp_90), Y        ; get the desired index
    
    ASL A               ; multiply by 2 (2 bytes per pointer)
    PHP                 ; backup the carry
    STA tmp_96             ; use as low byte
    
    TXA                 ; get X (low byte of pointer table)
    CLC
    ADC tmp_96             ; add with low byte of index
    STA tmp_96             ; use as final low byte
    
    LDA #$00            ; add the carry from the X addition
    ADC tmp_97
    PLP                 ; also add the carry from the above *2
    ADC #$00
    STA tmp_97             ; use as final high byte
    
    LDY #$00            ; get the pointer, store in btldraw_subsrc
    LDA (tmp_96), Y
    STA btldraw_subsrc
    INY
    LDA (tmp_96), Y
    STA btldraw_subsrc+1
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleMessage  [$FC26 :: 0x3FC36]
;;
;;  control code $0F
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleMessage:
    LDA #BANK_BTLMESSAGES
    CALL SwapPRG
    LDA #>(data_BattleMessages - 2)     ; -2 because battle message is 1-based
    LDX #<(data_BattleMessages - 2)
    CALL BattleDrawLoadSubSrcPtr
    LDA #$3F
    STA btldraw_max
    JUMP DrawBattleSubString

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawString_SpaceRun  [$FC39 :: 0x3FC49]
;;
;;  control code $10
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawString_SpaceRun:
    CALL DrawBattle_IncSrcPtr    ; inc ptr
    LDA (btldraw_src), Y        ; get the run length
    TAX
    LDA #$FF                    ; blank space tile
    : LDY #$00
      STA (btldraw_dst), Y      ; print top/bottom portions as empty space
      INY
      STA (btldraw_dst), Y
      CALL DrawBattleString_IncDstPtr
      DEX
      BNE :-
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawEntityName  [$FC4F :: 0x3FC5F]
;;
;;  input:
;;            A = ID of enemy slot or player whose name to draw
;;  btldraw_dst = pointer to draw to
;;
;;  If A has the high bit set, the player name is drawn
;;  Otherwise, A is the enemy slot whose name we're to draw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEntityName:
    BPL @Enemy                  ; if high bit is clear, it's an enemy
    
    ; otherwise, it's a player
    AND #$03                    ; mask out the low bits to get the player ID
    ASL A                       ; @2 for pointer table
    TAX
    LDA lut_CharacterNamePtr, X ; run it though a lut to get the pointer to the player's name
    STA btldraw_subsrc
    INX
    LDA lut_CharacterNamePtr, X
    STA btldraw_subsrc+1
    
    LDY #$00
    : LDA (btldraw_subsrc), Y           ; draw each character in the character's name
      CALL DrawBattleString_ExpandChar
      INY
      CPY #$04                          ; draw 4 characters
      BNE :-
    RTS
    
  @Enemy:
    ASL A           ; mulitply A by $14  ($14 bytes per entry in btl_enemystats)
    ASL A           ; first, multiply by 4
    STA temp_94     ;    store it in temp
    ASL A           ; then multiply by $10
    ASL A
    CLC
    ADC temp_94     ; add with stored *4
    TAX             ; put in X to index
    
    LDA btl_enemystats + en_enemyid, X   ; get this enemy's ID
    NOJUMP DrawEnemyName

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawEnemyName  [$FC7A :: 0x3FC8A]
;;
;;  input:
;;            A = ID of enemy whose name to draw
;;  btldraw_dst = pointer to draw to
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEnemyName:
    PHA                     ; back up enemy ID
    LDA #BANK_ENEMYNAMES
    CALL SwapPRG           ; swap in bank with enemy names
    PLA                     ; get enemy ID
    ASL A                   ; *2 to use as index
    TAX
    
    LDA data_EnemyNames, X      ; get source pointer from pointer table
    STA btldraw_subsrc
    LDA data_EnemyNames+1, X
    STA btldraw_subsrc+1
    
    NOJUMP DrawBattleSubString_Max8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleSubString_Max8  [$FC8D :: 0x3FC9D]
;;
;;  Same as DrawBattleSubString, but sets the maximum string length to 8 characters
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleSubString_Max8:
    LDA #$08
    STA btldraw_max
    NOJUMP DrawBattleSubString
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleSubString  [$FC94 :: 0x3FCA4]
;;
;;  btldraw_subsrc = pointer to read from
;;  btldraw_dst = pointer to draw to
;;  btldraw_max = maximum number of characters to draw
;;
;;  Note that this routine seems to be built for the Japanese game where characters
;;    could consist of 2 parts.  For example the Hiragana GU is the same as KU with an
;;    additional quote-like character drawn above it.  As such, each character is drawn
;;    with a "top part" and a "bottom part"
;;
;;  In the US version, the top part is never used, and is just a blank space.  So a good
;;    portion of DrawBattleString_ExpandChar is now worthless and could be trimmed out.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleSubString:
    LDY #$00
  @Loop:
    LDA (btldraw_subsrc), Y         ; get a byte of text
    BEQ @Exit                       ; if null terminator, exit
    CALL DrawBattleString_ExpandChar ; Draw it
    
    INY                             ; keep looping until null terminator is found
    CPY btldraw_max                 ;  or until we reach the given maximum
    BEQ @Exit
    BNE @Loop
    
  @Exit:
    LDA battle_bank                 ; swap back to battle bank
    JUMP SwapPRG                   ;   and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut to get a character's name by their index  [$FCAA :: 0x3FCBA]

lut_CharacterNamePtr:
  .WORD ch_name
  .WORD ch_name+$40
  .WORD ch_name+$80
  .WORD ch_name+$C0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattle_IncSrcPtr  [$FCB2 :: 0x3FCC2]
;;
;;  Inrements the source pointer.  Also resets Y to zero so that
;;  the next source byte can be easily read.  Why this routine doesn't also
;;  read the source byte is beyond me.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattle_IncSrcPtr:
    LDY #$00
    INC btldraw_src
    BNE :+
      INC btldraw_src+1
  : RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_IncDstPtr  [$FCC2 :: 0x3FCD2]
;;
;;  Incremenets the destination pointer by 2 for the DrawBattleSubString routine(s)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_IncDstPtr:
    INC btldraw_dst
    BNE :+
      INC btldraw_dst+1
  : INC btldraw_dst
    BNE :+
      INC btldraw_dst+1
  : RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SwapBtlTmpBytes  [$FCCF :: 0x3FCDF]
;;
;;  Backs up the btltmp bytes by swapping them into another place in memory
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SwapBtlTmpBytes:
    PHA         ; backup A,X
    TXA
    PHA
    
    LDX #$0F
  @Loop:
      LDA btltmp, X             ; swap data from btltmp with btltmp_backseat
      PHA
      LDA btltmp_backseat, X
      STA btltmp, X
      PLA
      STA btltmp_backseat, X
      DEX
      BPL @Loop
      
    PLA         ; restory A,X
    TAX
    PLA
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Copy 256  [$CC74 :: 0x3CC84]
;;
;;    Copies 256 bytes from (tmp) to (tmp+2).  High byte of dest pointer (tmp+3)
;;  is incremented.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Copy256:
    LDY #0             ; start Y at zero
  
    @Loop:
        LDA (tmp), Y     ; copy a byte
        STA (tmp+2), Y
        INY
        BNE @Loop        ; loop until Y wraps (256 iterations)

    INC tmp+3          ; inc dest pointer
    RTS                ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   NMI Vector [$FE9C :: 0x3FEAC] 
;;
;;     This is called when an NMI occurs.  FF1 has a bizarre way
;;    of doing NMIs.  It calls a Wait for VBlank routine, which enables
;;    NMIs, and does an infinite JUMP loop.  When an NMI is triggered,
;;    It does not RTI (since that would put it back in that infinite
;;    loop).  Instead, it tosses the RTI address and does an RTS, which
;;    returns to the area in code that called the Wait for Vblank routine
;;
;;     Changes to this routine can impact the timing of various raster effects,
;;    potentially breaking them.  It is recommended that you don't change this
;;    routine unless you're very careful.  Unedited, this routine exits no earlier
;;    than 37 cycles after NMI (30 cycles used in this routine, plus 7 for the NMI)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OnNMI:
    LDA soft2000
    STA PPUCTRL      ; set the PPU state
    LDA PPUSTATUS      ; clear VBlank flag and reset 2005/2006 toggle
    PLA
    PLA
    PLA            ; pull the RTI return info off the stack
    RTS            ; return to the game

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Wait for VBlank [$FEA8 :: 0x3FEB8]
;;
;;    This does an infinite loop in wait for an NMI to be triggered
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitForVBlank:
    LDA PPUSTATUS      ; check VBlank flag
    LDA soft2000   ; Load desired PPU state
    ORA #$80       ; flip on the Enable NMI bit
    STA PPUCTRL      ; and write it to PPU status reg

OnIRQ:                   ; IRQs point here, but the game doesn't use IRQs, so it's moot
    @LoopForever:
    JMP @LoopForever     ; then loop forever! (or really until the NMI is triggered)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SwapPRG  [$FE1A :: 0x3FE2A]
;;
;;   Swaps so the desired bank of PRG ROM is visible in the $8000-$BFFF range
;;
;;  IN:   A = desired bank to swap to (00-0F)
;;
;;  OUT:  A = 0
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SwapPRG:  
    STA actual_bank ; JIGS - see LongCall 
    ASL A       ; Double the page number (MMC5 uses 8K pages, but FF1 uses 16K pages)
    ORA #$80    ; Turn on the high bit to indicate we want ROM and not RAM
    STA current_bank1
    STA MMC5_PRG_BANK1   ; Swap to the desired page
    LDA far_depth
    BEQ @noDebugger
    ;DEBUG
    @noDebugger:
    LDA #0      ; IIRC Some parts of FF1 expect A to be zero when this routine exits
    RTS

Impl_FARBYTE:
    LDA cur_bank
    ASL A       ; Double the page number (MMC5 uses 8K pages, but FF1 uses 16K pages)
    ORA #$80    ; Turn on the high bit to indicate we want ROM and not RAM
    STA MMC5_PRG_BANK1
    LDA (text_ptr), Y
    PHA
    LDA current_bank1
    STA MMC5_PRG_BANK1
    PLA
    RTS

Impl_FARBYTE2:
    STA MMC5_PRG_BANK1
    LDA (tmp), Y
    PHA
    LDA current_bank1
    STA MMC5_PRG_BANK1
    PLA
    RTS

Impl_FARPPUCOPY:
    STA MMC5_PRG_BANK1
    @loop:
            LDA (tmp), Y      ; read a byte from source pointer
            STA PPUDATA       ; and write it to CHR-RAM
            INY               ; inc our source index
        BNE @loop         ; if it didn't wrap, continue looping
        INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
        DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop         ; if we've loaded all requested rows, exit.  Otherwise continue loading
    LDA current_bank1
    STA MMC5_PRG_BANK1
    RTS

Impl_NAKEDJUMP:
    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y
        
        JMP (trampoline_low)

    ; Activate the trampoline
    RTS


Impl_FARJUMP:

    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Save what page the bank is currently in
    LDA current_bank1
    PHA

    ; Push this address to the stack so we can return here
    CALL @jump
    ; We just got back so time to rewind

    ; Save A
    STA safecall_reg_a

    ; Pull what page our bank used to be in and switch back
    PLA
    STA current_bank1
    STA MMC5_PRG_BANK1

    PHP
    ; Decrement our depth counter
    DEC far_depth
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Return to original caller
    RTS

    @jump:

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y
        
        JMP (trampoline_low)

    ; Activate the trampoline
    RTS

Impl_FARCALL:
    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Save back the high address
    PHA

    ; Load back the low address
    LDA trampoline_low
    ADC #3
    PHA

    ; Save what page the bank is currently in
    LDA current_bank1
    PHA

    ; Push this address to the stack so we can return here
    CALL @jump
    ; We just got back so time to rewind

    ; Save A
    STA safecall_reg_a

    ; Pull what page our bank used to be in and switch back
    PLA
    STA current_bank1
    STA MMC5_PRG_BANK1

    PHP
    ; Decrement our depth counter
    DEC far_depth
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Return to orginal caller
    RTS

    @jump:

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        ; temp removal of trampoline trick
        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y

        ; temp non-trampoline JUMP
        JMP (trampoline_low)

    ; Activate the trampoline
    ;RTS

.segment "RESET_VECTOR"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Entry / Reset  [$FE2E :: 0x3FE3E]
;;
;;   Entry point for the program.  Does NES and mapper prepwork, and gets
;;   everything started
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OnReset:
    SEI                     ; Set Interrupt flag (prevent IRQs from occuring)
    
    ; MMC5
    LDX #0
    STX MMC5_PCM_MODE_IRQ   ; Disable MMC5 PCM and IRQs
    STX MMC5_IRQ_STATUS     ; Disable MMC5 scanline IRQs
    STX MMC5_UPPER_CHR_BANK ; Check doc on MMC5 to see what this does
    STX MMC5_RAM_BANK       ; swap battery-backed PRG RAM into $6000 page.     
    STX MMC5_SPLIT_MODE     ; disable split-screen mode
    STX MMC5_CHR_MODE       ; 8k CHR swap mode (no swapping)
    STX MMC5_CHR_BANK7      ; Swap in first CHR Page
    INX                     ; 01
    STX MMC5_PRG_MODE       ; set MMC5 to 16k PRG mode
    STX MMC5_RAM_PROTECT_2  ; Allow writing to PRG-RAM B  
    INX                     ; 02
    STX MMC5_RAM_PROTECT_1  ; Allow writing to PRG-RAM A
    STX MMC5_EXRAM_MODE     ; ExRAM mode Ex2   
    LDX #$44
    STX MMC5_MIRROR         ; Vertical mirroring
    LDX #$FF        
    STX MMC5_PRG_BANK3

    LDA #0
    STA PAPU_MODCTL         ; disble DMC IRQs
    STA PPUCTRL             ; Disable NMIs
    LDA #$C0
    STA FRAMECTR_CTL        ; set alternative pAPU frame counter method, reset the frame counter, and disable APU IRQs

    LDA #$06
    STA PPUMASK             ; disable Spr/BG rendering (shut off PPU)
    CLD                     ; clear Decimal flag (just a formality, doesn't really do anything)

    LDX #$02                ; wait for 2 vblanks to occurs (2 full frames)
    @Loop: 
        BIT PPUSTATUS         ;  This is necessary because the PPU requires some time to "warm up"
        BPL @Loop             ;  failure to do this will result in the PPU basically not working
        DEX
        BNE @Loop

    FARCALL ResetRAM

    FARCALL DisableAPU
    SWITCH GameStart
    JMP GameStart           ; jump to the start of the game!

.segment "VECTORS"

  .WORD OnNMI
  .WORD OnReset
  .WORD OnIRQ     ;IRQ vector points to an infinite loop (IRQs should never occur)
