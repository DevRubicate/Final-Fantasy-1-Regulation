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
.import TalkToObject, EnterLineupMenu
.import EnterMainMenu, EnterIntroStory
.import data_EpilogueCHR, data_EpilogueNT, data_BridgeNT
.import EnvironmentStartupRoutine
.import BattleRNG, GetSMTargetCoords, CanTalkToMapObject
.import DrawMMV_OnFoot, Draw2x2Sprite, DrawMapObject, AnimateAndDrawMapObject, UpdateAndDrawMapObjects, DrawSMSprites, DrawOWSprites, DrawPlayerMapmanSprite, AirshipTransitionFrame
.import ResetRAM, SetRandomSeed, GetRandom, LoadBatSprCHRPalettes_NewGame
.import OpenTreasureChest, AddGPToParty, LoadPrice, LoadBattleBackdropPalette
.import LoadMenuBGCHRAndPalettes, LoadMenuCHR, LoadBackdropPalette, LoadShopBGCHRPalettes, LoadTilesetAndMenuCHR
.import GameStart, LoadMenuCHRPal, LoadBatSprCHRPalettes
.import OverworldMovement, SetOWScroll, SetOWScroll_PPUOn, MapPoisonDamage, StandardMapMovement, CanPlayerMoveSM
.import UnboardBoat_Abs, Board_Fail, BoardCanoe, BoardShip, DockShip, IsOnBridge, IsOnCanal, FlyAirship, AnimateAirshipLanding, AnimateAirshipTakeoff
.import ProcessOWInput, PlaySFX_Error, PrepDialogueBoxRow, SeekDialogStringPtr, GetBattleMessagePtr
.import DrawBattleString_ControlCode, SetPPUAddrToDest_Bank, CoordToNTAddr_Bank
.import Video_Start, ClearVideoStack, ClearSprites

; prg_10_overworld_object
.import MapObjectMove, LoadMapObjects, DrawMapObjectsNoUpdate
; prg_1E_util
.import DisableAPU, Dialogue_CoverSprites_VBl, UpdateJoy, PrepAttributePos
; prg_18_screen_wipe
.import ScreenWipe_Open, ScreenWipe_Close
; prg_19_menu
.import MenuCondStall
; prg_1A_string
.import DrawComplexString_New, DrawItemBox, SeekItemStringAddress, SeekItemStringPtr, SeekItemStringPtrForEquip, DrawEquipMenuStrings
; prg_1B_map_chr

; prg_1C_mapman_chr
.import LoadPlayerMapmanCHR
; prg_1D_world_map_obj_chr
.import LoadOWObjectCHR
; prg_1E_util

; prg_1F_standard_map_obj_chr
.import LoadMapObjCHR
; prg_20_battle_bg_chr
.import LoadBattleBackdropCHR, LoadBattleFormationCHR, LoadBattleBGPalettes, LoadBattleCHRPal, LoadBattleAttributeTable
; prg_21_altar
.import DoAltarEffect
; prg_22_bridge
.import LoadBridgeSceneGFX
; prg_23_epilogue
.import LoadEpilogueSceneGFX
; prg_24_sound_util
.import PlayDoorSFX, DialogueBox_Sfx, VehicleSFX
; prg_25_standard_map
.import LoadNormalTeleportData, LoadExitTeleportData
; prg_26_map
.import BattleTransition
; prg_27_overworld_map
.import LoadOWCHR, PrepOverworld, LoadEntranceTeleportData
; prg_28_battle_util
.import BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer
.import DrawBattle_Division, DrawCombatBox, BattleDrawMessageBuffer, Battle_PPUOff, BattleBox_vAXY
.import BattleDrawMessageBuffer_Reverse, UndrawBattleBlock, DrawBattleBox, DrawRosterBox, DrawBattle_Number
.import BattleDraw_AddBlockToBuffer, DrawCommandBox, DrawBattleBox_NextBlock, UndrawNBattleBlocks, DrawBattleString_IncDstPtr
.import BattleMenu_DrawMagicNames, DrawBattleString_Code11
; prg_2A_draw_util
.import DrawBox
; prg_2B_dialog_util
.import ShowDialogueBox, EraseBox
.import BankTest

.export DrawPalette
.export WaitForVBlank
.export Impl_FARCALL, Impl_NAKEDJUMP, Impl_FARPPUCOPY
.export CHRLoadToA
.export WaitScanline
.export Copy256, CHRLoad, CHRLoad_Cont
.export CoordToNTAddr
.export DrawMapPalette
.export SetPPUAddr_XA, lut_EnemyRosterStrings
.export Battle_DrawMessageRow_VBlank
.export SetPPUAddrToDest
.export Battle_DrawMessageRow
.export lua_BattleCommandBoxInfo_txt0, lua_BattleCommandBoxInfo_txt1, lua_BattleCommandBoxInfo_txt2, lua_BattleCommandBoxInfo_txt3, lua_BattleCommandBoxInfo_txt4
.export DrawString_SpaceRun
.export DrawBattle_IncSrcPtr, ReadFarByte

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
    LDA PPU_STATUS       ; Reset PPU toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPU_ADDR
    LDA #$00
    STA PPU_ADDR
    LDX #$00        ; set X to zero (our source index)
    JUMP _DrawPalette_Norm   ; and copy the normal palette

DrawMapPalette:
    LDA PPU_STATUS       ; Reset PPU Toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPU_ADDR
    LDA #$00
    STA PPU_ADDR
    LDX #$00        ; clear X (our source index)
    LDA inroom      ; check in-room flag
    BEQ _DrawPalette_Norm   ; if we're not in a room, copy normal palette...otherwise...

    @InRoomLoop:
      LDA inroom_pal, X ; if we're in a room... the BG palette (first $10 colors) come from
      ;STA PPU_DATA         ;   $03E0 instead
      INX
      CPX #$10          ; loop $10 times to copy the whole BG palette
      BCC @InRoomLoop   ;   once the BG palette is drawn, continue drawing the sprite palette per normal

    _DrawPalette_Norm:
    LDA cur_pal, X     ; get normal palette
    ;STA PPU_DATA          ;  and draw it
    INX
    CPX #$20           ; loop until $20 colors have been drawn (full palette)
    BCC _DrawPalette_Norm

    LDA PPU_STATUS          ; once done, do the weird thing NES games do
    LDA #$3F           ;  reset PPU address to start of palettes ($3F00)
    STA PPU_ADDR          ;  and then to $0000.  Most I can figure is that they do this
    LDA #$00           ;  to avoid a weird color from being displayed when the PPU is off
    STA PPU_ADDR
    STA PPU_ADDR
    STA PPU_ADDR
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
    LDY PPU_STATUS   ; reset PPU Addr toggle
    STA PPU_ADDR   ; write high byte of dest address
    LDA #0
    STA PPU_ADDR   ; write low byte:  0
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
    ;STA PPU_DATA         ; and write it to CHR-RAM
    INY               ; inc our source index
    BNE CHRLoad_Cont  ; if it didn't wrap, continue looping

    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE CHRLoad_Cont  ; if we've loaded all requested rows, exit.  Otherwise continue loading
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddr_XA  [$F3BF :: 0x3F3CF]
;;
;;    Sets the PPU Addr to XXAA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddr_XA:
    STX PPU_ADDR   ; write X as high byte
    STA PPU_ADDR   ; A as low byte
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

    
Battle_DrawMessageRow:
    ;LDA btl_tmpvar4
    STA PPU_ADDR           ; set provided PPU address
    ;LDA btl_tmpvar3
    STA PPU_ADDR
    LDY #$00
  @Loop:
      ;LDA (btl_varI), Y      ; read $19 bytes from source pointer
      ;STA PPU_DATA         ;  and draw them
      INY
      CPY #$19
      BNE @Loop
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawString_SpaceRun  [$FC39 :: 0x3FC49]
;;
;;  control code $10
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawString_SpaceRun:
    CALL DrawBattle_IncSrcPtr    ; inc ptr
    ;LDA (btldraw_src), Y        ; get the run length
    TAX
    LDA #$FF                    ; blank space tile
    @Loop:
        LDY #$00
        ;STA (btldraw_dst), Y      ; print top/bottom portions as empty space
        INY
        ;STA (btldraw_dst), Y
        DEX
        BNE @Loop
    RTS
    
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
    ;INC btldraw_src
    BNE :+
        ;INC btldraw_src+1
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
;;     Changes to this routine can impact the timing of various raster effects,
;;    potentially breaking them.  It is recommended that you don't change this
;;    routine unless you're very careful.  Unedited, this routine exits no earlier
;;    than 37 cycles after NMI (30 cycles used in this routine, plus 7 for the NMI)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LagFrame:
    LDA PPU_STATUS      ; clear VBlank flag and reset 2005/2006 toggle
    INC vBlankCounter
    PLA
    CLI
    RTI

OnNMI:
    SEI                                         ; 2 cycle
    PHA                                         ; 2 cycle

    LDA #>oam                                   ; 2 cycle
    STA OAM_DMA                                  ; 4 cycles + 514 cycles

    ; if vBlank was not anticipated, do a lagframe update instead
    LDA vBlankAnticipated                       ; 4 cycle
    BEQ LagFrame                                ; 2 cycle
    LDA #0                                      ; 2 cycle
    STA vBlankAnticipated                       ; 4 cycle

    LDA VideoCursor                             ; 4 cycle
    BEQ @noVideo                                ; 2 cycle
    TXA                                         ; 2 cycle
    PHA                                         ; 2 cycle
    TYA                                         ; 2 cycle
    PHA                                         ; 2 cycle
    LDA current_bank1                           ; 4 cycle
    PHA                                         ; 2 cycle
    LDA #(.bank(Video_Start) | %10000000)       ; 4 cycle
    STA MMC5_PRG_BANK1                          ; 4 cycle
    JSR Video_Start                             ; 6 cycle
    PLA
    STA MMC5_PRG_BANK1
    PLA
    TAY
    PLA
    TAX
    @noVideo:
    
    LDA #0
    STA spriteRAMCursor

    LDA #(256 - 96) ; Save 96 bytes for the normal stack
    STA VideoStackTally

    LDA #(256 - (<(1684/2)))
    STA VideoCost
    LDA #(255 - (>(1684/2)))
    STA VideoCost+1

    INC generalCounter
    LDA PPU_STATUS      ; clear VBlank flag and reset 2005/2006 toggle
    INC vBlankCounter

    PLA
    CLI
    RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Wait for VBlank [$FEA8 :: 0x3FEB8]
;;
;;    This does an infinite loop in wait for an NMI to be triggered
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitForVBlank:
    ; Add the terminator to the end of the video stack
    LDX VideoCursor
    LDA #$80
    STA VideoStack+0,X
    STA VideoStack+1,X

    LDA PPU_STATUS      ; check VBlank flag
    LDA soft2000   ; Load desired PPU state
    ORA #$80       ; flip on the Enable NMI bit
    STA PPU_CTRL      ; and write it to PPU status reg
    INC vBlankAnticipated
    LDA vBlankCounter
    @LoopForever:
    CMP vBlankCounter
    BEQ @LoopForever     ; then loop forever! (or really until the NMI is triggered)
    RTS

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
            ;STA PPU_DATA       ; and write it to CHR-RAM
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
    STX current_bank1
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

    LDX #3
    STX MMC5_CHR_MODE       ; 1k CHR swap mode

    LDA #0
    STA PAPU_MODCTL         ; disble DMC IRQs
    LDA #%00100000
    STA PPU_CTRL            ; Disable NMIs
    LDA #$C0
    STA FRAMECTR_CTL        ; set alternative pAPU frame counter method, reset the frame counter, and disable APU IRQs

    LDA #$06
    STA PPU_MASK             ; disable Spr/BG rendering (shut off PPU)
    CLD                     ; clear Decimal flag (just a formality, doesn't really do anything)

    LDX #$02                ; wait for 2 vblanks to occurs (2 full frames)
    @Loop: 
        BIT PPU_STATUS         ;  This is necessary because the PPU requires some time to "warm up"
        BPL @Loop             ;  failure to do this will result in the PPU basically not working
        DEX
        BNE @Loop

    FARCALL ResetRAM

    LDA #(256 - 96) ; Save 96 bytes for the normal stack
    STA VideoStackTally

    LDA #(256 - (<(1684/2)))
    STA VideoCost
    LDA #(255 - (>(1684/2)))
    STA VideoCost+1


    FARCALL DisableAPU
    SWITCH GameStart
    JMP GameStart           ; jump to the start of the game!

.segment "VECTORS"

  .WORD OnNMI
  .WORD OnReset
  .WORD OnIRQ     ;IRQ vector points to an infinite loop (IRQs should never occur)
