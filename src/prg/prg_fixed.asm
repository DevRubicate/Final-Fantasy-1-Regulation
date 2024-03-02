.segment "PRG_FIXED"

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
.import GameStart, LoadOWTilesetData, GetBattleFormation, LoadMenuCHRPal, LoadBatSprCHRPalettes, SwapBtlTmpBytes
.import OW_MovePlayer, OWCanMove, OverworldMovement, SetOWScroll, SetOWScroll_PPUOn, MapPoisonDamage, StandardMapMovement, CanPlayerMoveSM
.import UnboardBoat, UnboardBoat_Abs, Board_Fail, BoardCanoe, BoardShip, DockShip, IsOnBridge, IsOnCanal, FlyAirship, AnimateAirshipLanding, AnimateAirshipTakeoff, GetOWTile, LandAirship
.import ProcessOWInput, GetSMTileProperties, GetSMTilePropNow, TalkToSMTile, PlaySFX_Error, PrepDialogueBoxRow, SeekDialogStringPtr, GetBattleMessagePtr
.import DrawBattleString_ControlCode, SetPPUAddrToDest_Bank, CoordToNTAddr_Bank

; prg_10_overworld_object
.import MapObjectMove, AimMapObjDown, LoadMapObjects, DrawMapObjectsNoUpdate
; prg_1E_util
.import DisableAPU, ClearOAM, Dialogue_CoverSprites_VBl, UpdateJoy, PrepAttributePos
; prg_18_screen_wipe
.import ScreenWipe_Open, ScreenWipe_Close
; prg_16_overworld_tileset
.import LoadSMTilesetData
; prg_19_menu
.import MenuCondStall
; prg_1A_string
.import DrawComplexString_New, DrawItemBox, SeekItemStringAddress, SeekItemStringPtr, SeekItemStringPtrForEquip, DrawEquipMenuStrings
; prg_1B_map_chr
.import LoadOWBGCHR
; prg_1C_mapman_chr
.import LoadPlayerMapmanCHR
; prg_1D_world_map_obj_chr
.import LoadOWObjectCHR
; prg_1E_util

; prg_1F_standard_map_obj_chr
.import LoadMapObjCHR
; prg_20_battle_bg_chr
.import LoadBattleBackdropCHR, LoadBattleFormationCHR, LoadBattleBGPalettes, LoadBattleCHRPal, LoadBattlePalette, DrawBattleBackdropRow, LoadBattleAttributeTable, LoadBattleFormationInto_btl_formdata
; prg_21_altar
.import DoAltarEffect
; prg_22_bridge
.import LoadBridgeSceneGFX
; prg_23_epilogue
.import LoadEpilogueSceneGFX
; prg_24_sound_util
.import PlayDoorSFX, DialogueBox_Sfx, VehicleSFX
; prg_25_standard_map
.import PrepStandardMap, EnterStandardMap, ReenterStandardMap, LoadNormalTeleportData, LoadExitTeleportData, DoStandardMap
; prg_26_map
.import LoadMapPalettes, BattleTransition, StartMapMove, DrawMapAttributes, DoMapDrawJob, PrepSMRowCol, PrepRowCol
; prg_27_overworld_map
.import LoadOWCHR, EnterOverworldLoop, PrepOverworld, DoOverworld, LoadEntranceTeleportData, DoOWTransitions
; prg_28_battle_util
.import BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer, EnterBattle
.import DrawBattle_Division, DrawCombatBox, BattleDrawMessageBuffer, Battle_PPUOff, BattleBox_vAXY, BattleWaitForVBlank
.import BattleDrawMessageBuffer_Reverse, UndrawBattleBlock, DrawBattleBox, DrawRosterBox, DrawBattle_Number
.import BattleDraw_AddBlockToBuffer, DrawCommandBox, DrawBattleBox_NextBlock, UndrawNBattleBlocks, DrawBattleString_IncDstPtr
.import BattleMenu_DrawMagicNames, DrawBattleString_Code11
; prg_2A_draw_util
.import DrawBox, CyclePalettes, GetCharacterNamePtr
; prg_2B_dialog_util
.import ShowDialogueBox, EraseBox
; prg_2C_dialog_string
.import DrawDialogueString

.export DrawPalette
.export WaitForVBlank
.export FormatBattleString
.export BattleCrossPageJump
.export Impl_FARCALL, Impl_NAKEDJUMP, Impl_FARPPUCOPY
.export CHRLoadToA
.export WaitScanline, SetSMScroll
.export EnterOW_PalCyc
.export Copy256, CHRLoad, CHRLoad_Cont
.export CoordToNTAddr
.export DrawMapPalette
.export SetPPUAddr_XA, lut_EnemyRosterStrings
.export SetBattlePPUAddr, Battle_DrawMessageRow_VBlank
.export LoadOWMapRow, LoadStandardMap, SetPPUAddrToDest
.export Battle_DrawMessageRow, DrawBattleBoxAndText, DrawBattleBox_Row
.export DrawBattleString_DrawChar
.export lua_BattleCommandBoxInfo_txt0, lua_BattleCommandBoxInfo_txt1, lua_BattleCommandBoxInfo_txt2, lua_BattleCommandBoxInfo_txt3, lua_BattleCommandBoxInfo_txt4
.export DrawBattleSubString_Max8, BattleDrawLoadSubSrcPtr, DrawEnemyName, DrawEntityName, DrawString_SpaceRun
.export DrawBattleMessage, DrawBattleString_Code0C, DrawBattle_IncSrcPtr, ReadFarByte, SetBattlePPUAddr

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
    FARCALL CyclePalettes       ; cycle palettes with code=01 (overworld, reverse cycle)
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

SetPPUAddrToDest:
    LDA #($1E * 2) | %10000000
    STA MMC5_PRG_BANK1
    JSR SetPPUAddrToDest_Bank
    LDA current_bank1
    STA MMC5_PRG_BANK1
    RTS

CoordToNTAddr:
    LDA #($1E * 2) | %10000000
    STA MMC5_PRG_BANK1
    JSR CoordToNTAddr_Bank
    LDA current_bank1
    STA MMC5_PRG_BANK1
    RTS

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
    FARCALL BattleWaitForVBlank
    
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
;;  DrawBattleBox_FetchBlock  [$F5FB :: 0x3F60B]
;;
;;  Fetches a block of data to draw for the battle box
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBox_FetchBlock:
    LDY #$00                          ; copy 5 bytes of data
    : 
    LDA (btldraw_blockptrstart), Y  ;  from the $8C pointer
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
    FARCALL DrawBattleBox                   ; use it to draw the box
    @Loop:
        FARCALL DrawBattleBox_NextBlock       ; move to next block (text block)
        LDY #$00
        LDA (btldraw_blockptrstart), Y    ; if the header byte is zero
        BEQ DrawBattleBox_Exit            ; exit
        CALL DrawBattleBox_FetchBlock      ; otherwise, fetch the block
        CALL DrawBattleString              ; and use it to draw text
        JUMP @Loop                         ; keep going until null terminator is found
    
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
    FARCALL GetBattleMessagePtr
    STX btl_tmpvar3                 ; store target pointer in temp ram
    STY btl_tmpvar4
    
    LDA btl_msgdraw_srcptr_bank
    BEQ @noBank
    STA current_bank1
    STA MMC5_PRG_BANK1
    @noBank:
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

lua_BattleCommandBoxInfo_txt0:  .byte $EF, $F0, $F1, $F2, $00     ; "FIGHT"
lua_BattleCommandBoxInfo_txt1:  .byte $EB, $EC, $ED, $EE, $00     ; "MAGIC"
lua_BattleCommandBoxInfo_txt2:  .byte $F3, $F4, $F5, $F6, $00     ; "DRINK"
lua_BattleCommandBoxInfo_txt3:  .byte $92, $9D, $8E, $96, $00     ; "ITEM"
lua_BattleCommandBoxInfo_txt4:  .byte $9B, $9E, $97, $00          ; "RUN"
  
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
    FARCALL SwapBtlTmpBytes     ; swap out btltmp bytes to back them up
    
    STX btldraw_src         ; store source pointer
    STY btldraw_src+1
    
    LDY #$00                ; copy the actual string data to a buffer in RAM
    @Loop:
        LDA (btldraw_src), Y  ;   (presumably so we can swap out banks without fear
        STA btl_stringbuf, Y  ;    of swapping out our source data)
        INY
        CPY #$20              ; no strings can be longer than $20 characters.
        BNE @Loop
      
    LDA #<btl_stringbuf     ; Change source pointer to point to our buffered
    STA btldraw_src         ;   string data
    LDA #>btl_stringbuf
    STA btldraw_src+1
    
    LDA #<btl_stringoutputbuf   ; Set our output pointer to point to
    STA btldraw_dst             ;   our string output buffer
    LDA #>btl_stringoutputbuf
    STA btldraw_dst+1
    
    ; Iterate the string and draw each character
    @Loop2:
    LDX #$00
    LDA (tmp_90, X)        ; get the first char
    BEQ @Done           ; stop at the null terminator
    CMP #$48
    BCS :+
        FARCALL DrawBattleString_ControlCode    ; if <  #$48
        JUMP :++
    :     
    CALL DrawBattleString_ExpandChar    ; if >= #$48
    :   
    CALL DrawBattle_IncSrcPtr    ; Inc the source pointer and continue looping
    JUMP @Loop2
    
    @Done:
    LDA #$00
    LDY #$00
    STA (btldraw_dst), Y            ; add null terminator
    INY
    STA (btldraw_dst), Y
    FARJUMP SwapBtlTmpBytes     ; swap back the original btltmp bytes, then exit

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
    TYA
    PHA
    LDA btltemppointer         ; get the char code
    CALL DrawBattleString_DrawChar
    PLA
    TAY
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
    LDA #$FF
    STA (btldraw_dst), Y        ; and top part in position [0]
    FARJUMP DrawBattleString_IncDstPtr


;;  DrawBattleString_Code0C  [$FB2F :: 0x3FB3F]
DrawBattleString_Code0C:            ; print a number (indirect)
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y            ; pointer to a pointer to the number to print
    STA btldraw_subsrc
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y
    STA btldraw_subsrc+1
    FARJUMP DrawBattle_Number

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
    @Loop:
        LDY #$00
        STA (btldraw_dst), Y      ; print top/bottom portions as empty space
        INY
        STA (btldraw_dst), Y
        FARCALL DrawBattleString_IncDstPtr
        DEX
        BNE @Loop
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
    
    FARCALL GetCharacterNamePtr
    
    LDY #$00
    @Loop: 
        LDA (btldraw_subsrc), Y           ; draw each character in the character's name
        CALL DrawBattleString_ExpandChar
        INY
        CPY #$04                          ; draw 4 characters
        BNE @Loop
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
    : 
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

ReadFarByte:
    LDA Var2
    STA MMC5_PRG_BANK1
    LDA (Var0), Y
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
    STA current_bank1
    STA MMC5_PRG_BANK1
    STY trampoline_low
    STX trampoline_high
    JMP (trampoline_low)

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
    STX MMC5_RAM_PROTECT_2  ; Allow writing to PRG-RAM B  
    INX                     ; 02
    STX MMC5_RAM_PROTECT_1  ; Allow writing to PRG-RAM A
    STX MMC5_EXRAM_MODE     ; ExRAM mode Ex2   
    STX MMC5_PRG_MODE       ; set MMC5 to PRG mode 2
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
