.segment "BANK_28"

.include "src/global-import.inc"

.import BattleRNG, WaitForVBlank, MusicPlay
.import LoadBattleFormationInto_btl_formdata, SetPPUAddr_XA, LoadBattleAttributeTable
.import LoadBattlePalette, DrawBattleBackdropRow, PrepBattleVarsAndEnterBattle, Battle_DrawMessageRow_VBlank
.import BattleDraw_AddBlockToBuffer, ClearUnformattedCombatBoxBuffer, DrawBlockBuffer, DrawBox, Battle_DrawMessageRow
.import DrawBattleBoxAndText

.export BattleScreenShake, BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer, EnterBattle, DrawDrinkBox
.export DrawBattle_Division, DrawCombatBox, DrawEOBCombatBox, BattleBox_vAXY, Battle_PPUOff, BattleWaitForVBlank, BattleDrawMessageBuffer, GetBattleMessagePtr
.export BattleDrawMessageBuffer_Reverse, UndrawBattleBlock, Battle_PlayerBox

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  lut for End of Battle text  [$A00E :: 0x3201E]
;;
;;    Strings used for DrawEOBCombatBox.  I have no idea why some of the
;; string data is stored here, and some of it is stored way back at $9950.

lut_EOBText:
  .WORD @MnstPrsh               ; 0
  .WORD @ExpUp                  ; 1
  .WORD @ExpVal                 ; 2
  .WORD @Gold                   ; 3
  .WORD @GoldVal                ; 4
  .WORD @LevUp                  ; 5
  .WORD eobtext_NameLN          ; 6
  .WORD eobtext_HPMax           ; 7
  .WORD eobtext_Npts            ; 8
  .WORD eobtext_PartyPerished   ; 9
  
  @MnstPrsh: .byte $0F, $3D, $0F, $3C, $00      ; "Monsters perished"
  @ExpUp:    .byte $0F, $49, $00                ; "EXP up"
  @ExpVal:   .byte $0C
             .WORD eob_exp_reward
             .byte $99, $00                     ; "##P"  where ## is the experience reward
  @Gold:     .byte $90, $98, $95, $8D, $00      ; "GOLD"
  @GoldVal:  .byte $0C
             .WORD eob_gp_reward
             .byte $90, $00, $00                ; "##G"   where ## is the GP reward
  @LevUp:    .byte $0F, $30, $00                ; "Lev. up!"

eobtext_NameLN:
  .byte $02, $FF, $95, $0C
  .WORD eobtext_print_level
  .byte $00                                 ; "<Name> L##", where <Name> is btl_attacker's name and ## is value at $687A
eobtext_HPMax:
  .byte $0F, $31, $00                       ; "HP max"
eobtext_Npts:
  .byte $0C
  .WORD eobtext_print_hp
  .byte $0F, $32, $00                       ; "##pts." where ## is value at $687C
eobtext_PartyPerished:
  .byte $04, $0F, $3E, $0F, $3C, $00        ; "<Name> party perished", where <Name> is the party leader's name

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
;;  Combat box lut          [$F9E9 :: 0x3F9F9]
;;
;;  These are all the boxes that pop up during combat to show attackers/damage/etc

LUT_CombatBoxes:
;             BOX                      TEXT
;       hdr    X    Y   wd   ht     hdr    X    Y
  .byte $00, $01, $01, $0A, $04,    $01, $02, $02       ; attacker name
  .byte $00, $0B, $01, $0C, $04,    $01, $0C, $02       ; their attack ("FROST", "2Hits!" etc)
  .byte $00, $01, $04, $0A, $04,    $01, $02, $05       ; defender name
  .byte $00, $0B, $04, $0B, $04,    $01, $0C, $05       ; damage
  .byte $00, $01, $07, $18, $04,    $01, $02, $08       ; bottom message ("Terminated", "Critical Hit", etc)

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
    FARJUMP PrepBattleVarsAndEnterBattle            ; and jump to battle routine!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleScreenShake  [$F440 :: 0x3F450]
;;
;;  Shakes the screen for a few frames (when an enemy attacks)
;;
;;  This routine takes 13 frames, and during that time, the sound effects
;;  are NOT updated.  This results in the sound effect the game makes when
;;  an enemy attacks to hang on the low-pitch 'BOOM' noise longer than
;;  its sound effect data indicates it should.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleScreenShake:
    LDA #$06
    STA loop_counter           ; loop down counter.  6*2 = 12 frames  (2 frames per loop)
  @Loop:
      CALL @Stall2Frames ; wait 2 frames
      
      FARCALL BattleRNG
      AND #$03          ; get a random number betwee 0-3
      STA PPUSCROLL         ; use as X scroll
      FARCALL BattleRNG
      AND #$03          ; another random number
      STA PPUSCROLL         ; for Y scroll
      
      DEC loop_counter
      BNE @Loop
    
    JUMP Battle_UpdatePPU_UpdateAudio_FixedBank  ; 1 more frame (with reset scroll)
    
    
  @Stall2Frames:
    CALL @Frame          ; do 1 frame
    LDX #$00            ; wait around -- presumably so we don't try
    : NOP               ;   to wait during VBlank (even though that wouldn't
      NOP               ;   be a problem anyway)
      NOP
      DEX
      BNE :-            ; flow into doing another frame
    
  @Frame:
    CALL WaitForVBlank
    JUMP BattleUpdateAudio_FixedBank


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_UpdatePPU_UpdateAudio_FixedBank  [$F485 :: 0x3F495]
;;
;;  Resets scroll and PPUMASK, then updates audio.
;;
;;  Used by only a few routines in the fixed bank.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_UpdatePPU_UpdateAudio_FixedBank:
    LDA btl_soft2001
    STA PPUMASK
    LDA #$00            ; reset scroll
    STA PPUSCROLL
    STA PPUSCROLL
    NOJUMP BattleUpdateAudio_FixedBank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleUpdateAudio_FixedBank  [$F493 :: 0x3F4A3]
;;
;;  Same idea as BattleUpdateAudio from bank $C... just in the fixed bank.
;;
;;  Note that this routine does NOT update battle sound effects.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
BattleUpdateAudio_FixedBank:
    LDA a:music_track
    BPL :+
      LDA btl_followupmusic
      STA a:music_track
    :   
    FARJUMP MusicPlay


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ClearBattleMessageBuffer  [$F620 :: 0x3F630]
;;
;;  Clears the battle message buffer in memory, but does not do any actual drawing.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearBattleMessageBuffer:
    ; Clear the message buffer
    LDY #$00
    LDA #$00
    : STA btl_msgbuffer, Y      ; clear the message buffer
      STA btl_msgbuffer+$80, Y  ;   (write $180 bytes)
      INY
      BNE :-
    
    ; After the message buffer is clear, it has to draw the bottom row of the
    ;  bounding box for the enemies/player.  This gets drawn over by other boxes.
    
    LDA #$FD                    ; tile FD is the bottom-box tile
    : STA btl_msgbuffer+1, Y    ; draw the row
      INY
      CPY #$17
      BNE :-
    
    LDA #$FC                    ; FC = lower left corner tile
    STA btl_msgbuffer+$01       ; for enemy box
    STA btl_msgbuffer+$11       ; for player box
    LDA #$FE                    ; FE = lower right corner tile
    STA btl_msgbuffer+$10       ; for enemy box
    STA btl_msgbuffer+$18       ; for player box
    
    RTS

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
    : 
    LDA lut_CombatDrinkBox-1, Y       ; load the specs for the drink box
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
    : 
    LDA #$00
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
    : 
    LDA #$00
    STA btl_unfmtcbtbox_buffer + $26
    STA btl_unfmtcbtbox_buffer + $27
    
    LDA #<(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr
    LDA #>(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr+1
    CALL BattleDraw_AddBlockToBuffer     ; add the block for the Pure potions
    
    JUMP DrawBlockBuffer                 ; then draw the actual blocks and exit

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawCombatBox  [$F71C :: 0x3F72C]
;;
;;  input:  A = ID of box to draw (0-4)
;;         YX = pointer to text data to put in that box
;;
;;  Combat boxes are the boxes that pop up during combat that show attackers/damage/etc.
;;  See LUT_CombatBoxes for more.
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
    : LDA LUT_CombatBoxes, Y    ; copy first 5 bytes (Box data)
      STA btl_msgdraw_hdr, X
      INX
      INY
      CPX #$05
      BNE :-
    CALL BattleDraw_AddBlockToBuffer ; add the block
    
    LDX #$00
    : LDA LUT_CombatBoxes, Y    ; copy 3 more bytes (Text data)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawEOBCombatBox  [$9F3B :: 0x2DF4B]
;;
;;    Draws an "End of Battle" (EOB) combat box.  These are boxes containing
;;  text that is shown at the end of battle... like "Level up!" kind of stuff.
;;
;;  input:  A = combat box ID to draw
;;          X = EOB string ID   (see lut_EOBText for valid values)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEOBCombatBox:
    STA temporary_1               ; backup the combo box ID
    
    LDA #$0B          ; set the current bank for the music driver
    STA cur_bank          ; seems weird to do this here...
    
    TXA                     ; Get the EOB string ID to print
    ASL A                   ; x2 to use as index
    
    TAY
    LDX lut_EOBText, Y      ; load pointer from lut
    LDA lut_EOBText+1, Y    ; and put in YX
    TAY
    
    LDA temporary_1               ; restore combo box ID in A
    FORCEDFARCALL DrawCombatBox     ; A = box ID, YX = pointer to string
    
    INC btl_combatboxcount  ; count this combat box
    RTS                     ; and exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_Box_vAXY   [$F3E2 :: 0x3F3F2]
;;
;;     Draws a box at coords v,A (where 'v' is box_x) and with dims X,Y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleBox_vAXY:
    STA box_y         ; just dump A,X,Y to box_y, box_wd, and box_ht
    STX box_wd
    STY box_ht
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
    STA soft2000     ; clear soft2000
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
    STA soft2000
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
      
      CALL Battle_UpdatePPU_UpdateAudio_FixedBank    ; update audio (since we did a frame), and reset scroll
      
      DEC tmp_68b9         ; loop for each row
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
      CALL Battle_UpdatePPU_UpdateAudio_FixedBank    ; update audio and stuffs
      
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
    CALL ClearBattleMessageBuffer    ; erase everything in the buffer
    
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
        FORCEDFARCALL DrawBattleBoxAndText      ; otherwise, draw another block
        INC btl_msgdraw_blockcount
        JUMP @Loop                     ; and repeat
    : 
    CALL BattleDrawMessageBuffer_Reverse ; reverse-draw to erase the block from the screen
    LDA btldraw_blockptrstart           ; move the end pointer to this position, so
    STA btldraw_blockptrend             ; the block we dropped will be actually removed
    LDA btldraw_blockptrstart+1
    STA btldraw_blockptrend+1
    
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
    STA box_x        ; record A as X coord
    STX box_y        ; record X as Y coord

    PHA                ; then back up A and X
    TXA
    PHA

    LDX #6
    STX box_wd       ; set width to 6
    INX
    STX box_ht       ; and height to 7

    CALL Battle_PPUOff  ; turn off the PPU
    FARCALL DrawBox        ; draw the box

    PLA                ; restore backed up A, X
    TAX
    PLA

    RTS                ; and exit!
