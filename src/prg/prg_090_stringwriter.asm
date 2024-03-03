.segment "PRG_090"

.include "src/global-import.inc"
.include "src/lib/yxa2dec.asm"

.import WaitForVBlank, MenuCondStall

.export StringWriter, PlotBox, WriteClassNameByIndex, WriteHeroNameByIndex



ClassStringPtrLo:
    .lobytes CLASS_NAME_FIGHTER, CLASS_NAME_THIEF, CLASS_NAME_BLACK_BELT, CLASS_NAME_RED_MAGE, CLASS_NAME_WHITE_MAGE, CLASS_NAME_BLACK_MAGE
ClassStringPtrHi:
    .hibytes CLASS_NAME_FIGHTER, CLASS_NAME_THIEF, CLASS_NAME_BLACK_BELT, CLASS_NAME_RED_MAGE, CLASS_NAME_WHITE_MAGE, CLASS_NAME_BLACK_MAGE
ClassStringPtrBank:
    .byte TextBank(CLASS_NAME_FIGHTER), TextBank(CLASS_NAME_THIEF), TextBank(CLASS_NAME_BLACK_BELT), TextBank(CLASS_NAME_RED_MAGE), TextBank(CLASS_NAME_WHITE_MAGE), TextBank(CLASS_NAME_BLACK_MAGE)

HeroStringPtrLo:
    .lobytes HERO_0_NAME, HERO_1_NAME, HERO_2_NAME, HERO_3_NAME
HeroStringPtrHi:
    .hibytes HERO_0_NAME, HERO_1_NAME, HERO_2_NAME, HERO_3_NAME
HeroStringPtrBank:
    .byte TextBank(HERO_0_NAME), TextBank(HERO_1_NAME), TextBank(HERO_2_NAME), TextBank(HERO_3_NAME)






StringWriter:
    CALL WaitForVBlank   ; wait for VBlank
    TXA
    PHA
    CALL SetPPUAddrToDest  ; then set the PPU address appropriately



    LDA stringwriterDestX
    STA stringwriterNewlineOrigin



    CALL Print
    JMP @SkipCall
    @Loop:
        CALL PrintAdvance
        @SkipCall:
        BEQ @Done
        CMP #223 ; $7F + $60
        BEQ @Newline
            STA PPUDATA            ; otherwise ($7A-$FF), it's a normal single tile.  Draw it
            ; Char
            LDA stringwriterDestX           ; increment the dest address by 1
            CLC
            ADC #1
            AND #$3F                        ; and mask it with $3F so it wraps around both NTs appropriately
            STA stringwriterDestX           ; then write back
            JUMP @Loop

        @Newline:
            LDA stringwriterNewlineOrigin
            STA stringwriterDestX
            INC stringwriterDestY
            CALL SetPPUAddrToDest  ; then set the PPU address appropriately
            JUMP @Loop

    @Done:
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL

    PLA
    TAX
    RTS


PrintAdvance:
    INC Var5
    BNE :+
        INC Var6
    :
Print:
    LDA Var7
    STA MMC5_PRG_BANK2

    LDY #0
    LDA (Var5), Y
    BMI @Control
    BNE :++
        LDX stringwriterStackIndex
        BEQ :+
            DEC stringwriterStackIndex
            LDA stringwriterStackLo-1, X
            STA Var5
            LDA stringwriterStackHi-1, X
            STA Var6
            LDA stringwriterStackBank-1, X
            STA Var7
            JUMP PrintAdvance
        :
        RTS
    :
    ; Add CHR offset so this becomes a valid character
    CLC
    ADC #$60
    RTS


    @Control:
        CMP #254
        BEQ @SetHero
        CMP #253
        BEQ @Hero
        JUMP PrintAdvance

    @SetHero:
        INC Var5
        BNE :+
            INC Var6
        :
        LDA (Var5), Y
        STA stringwriterSetHero
        JUMP PrintAdvance

    @Hero:
        INC Var5
        BNE :+
            INC Var6
        :
        CALL SaveStringWriterStack
        JUMP PrintHeroData
    @Digit:
        INC Var5
        BNE :+
            INC Var6
        :
        CALL SaveStringWriterStack
        JUMP PrintNumber
    @Done:
    RTS

SaveStringWriterStack:
    LDX stringwriterStackIndex
    INC stringwriterStackIndex
    LDA Var5
    STA stringwriterStackLo, X
    LDA Var6
    STA stringwriterStackHi, X
    LDA Var7
    STA stringwriterStackBank, X
    RTS


PrintHeroData:
    LDA (Var5), Y
    BEQ @PrintHeroName
    CMP #1
    BEQ @PrintHeroClass
    CMP #2
    BEQ @PrintHeroLevel
    LDA #0
    RTS

    @PrintHeroName:
        LDA stringwriterSetHero
        STA MMC5_MULTI_1
        LDA #(heroName1 - heroName0)
        STA MMC5_MULTI_2
        LDA MMC5_MULTI_1
        CLC
        ADC #<heroName0
        STA Var5
        LDA #>heroName0
        ADC #0
        STA Var6
        JUMP Print
 

    @PrintHeroClass:
        LDX stringwriterSetHero
        LDA partyGenerationClass, X
        TAX
        LDA ClassStringPtrLo, X
        STA Var5
        LDA ClassStringPtrHi, X
        STA Var6
        LDA ClassStringPtrBank, X
        STA Var7
        JUMP Print

    @PrintHeroLevel:
        LDX stringwriterSetHero
        LDA heroLevel,X
        CLC
        ADC #2
        RTS
        ;STA stringwriterBinary
        ;LDA #0
        ;STA stringwriterBinary
        ;CALL BinToDec
        ;CALL PrintNumber
        ;RTS

PrintNumber:
    LDA (Var5), Y
    PHA
    AND #%00000111
    TAX
    LDA yxa2decJumpTableHi, X
    PHA
    LDA yxa2decJumpTableLo, X
    PHA

    
    RTS

yxa2decJumpTableHi:
    .hibytes a_to_1_digit, a_to_2_digits-1, a_to_3_digits-1, xa_to_4_digits-1, xa_to_5_digits-1, yxa_to_6_digits-1, yxa_to_7_digits-1, yxa_to_8_digits-1
yxa2decJumpTableLo:
    .lobytes a_to_1_digit, a_to_2_digits-1, a_to_3_digits-1, xa_to_4_digits-1, xa_to_5_digits-1, yxa_to_6_digits-1, yxa_to_7_digits-1, yxa_to_8_digits-1


a_to_1_digit:
    DEBUG
    RTS



WriteHeroNameByIndex:
    LDA HeroStringPtrLo, X
    STA Var5
    LDA HeroStringPtrHi, X
    STA Var6
    LDA HeroStringPtrBank, X
    STA Var7
    CALL StringWriter
    RTS

WriteClassNameByIndex:
    LDA ClassStringPtrLo, X
    STA Var5
    LDA ClassStringPtrHi, X
    STA Var6
    LDA ClassStringPtrBank, X
    STA Var7
    CALL StringWriter
    RTS


BinToDec:
    LDA #0
    STA stringwriterDecimal+0
    STA stringwriterDecimal+1
    STA stringwriterDecimal+2
    STA stringwriterDecimal+3
    STA stringwriterDecimal+4
    STA stringwriterDecimal+5
    LDX #16
    @Loop:
    ASL stringwriterBinary+0
    ROL stringwriterBinary+1

    LDY stringwriterDecimal+0
    LDA BinToDecTable, y
    ROL
    STA stringwriterDecimal+0

    LDY stringwriterDecimal+1
    LDA BinToDecTable, y
    ROL
    STA stringwriterDecimal+1

    LDY stringwriterDecimal+2
    LDA BinToDecTable, y
    ROL
    STA stringwriterDecimal+2

    LDY stringwriterDecimal+3
    LDA BinToDecTable, y
    ROL
    STA stringwriterDecimal+3

    ROL stringwriterDecimal+4

    DEX
    BNE @Loop
    RTS

BinToDecTable:
    .byte $00, $01, $02, $03, $04, $80, $81, $82, $83, $84


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
    LDX stringwriterDestX         ; get dest_x in X
    LDY stringwriterDestY         ; and dest_y in Y
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
    LDY stringwriterDestY                ; put the Y coord (row) in Y.  We'll use it to index the NT lut
    LDA stringwriterDestX                ; put Y coord (col) in A
    AND #$1F                  ; wrap Y coord
    ORA lut_NTRowStartLo, Y   ; OR Y coord with low byte of row start
    STA ppu_dest              ;  this is the low byte of the addres -- record it
    LDA lut_NTRowStartHi, Y   ; fetch high byte based on row
    STA ppu_dest+1            ;  and record it
    RTS

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Draw Box  [$E063 :: 0x3E073]
;;
;;    Draws a box of given size, to given coords.  NT changes only, no attribute changes
;;   The box CANNOT cross an NT boundary (ie:  this routine isn't used for the dialog box
;;   which often does cross NT boundaries)
;;
;;   Y remains unchanged
;;
;;   IN:   menustall = Nonzero if the box is to be drawn 1 row per frame (stall between rows)
;;                      or zero if box is to be drawn immediately with no stalling
;;         box_x,y   = Desired Coords of box
;;         box_wd,ht = Desired width/height of box (must be at least 3x3 tiles)
;;         cur_bank  = Bank number to swap to (only used if stalling between rows)
;;
;;   OUT:  dest_x,y  = X,Y coords of inner box body (ie:  where you start drawing text or whatever)
;;
;;   TMP:  tmp+10 and tmp+11 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBox:
    CALL CoordToNTAddr ; convert those coords to an NT address (placed in ppu_dest)
    LDA box_wd        ; Get width of box
    SEC
    SBC #$02          ; subtract 2 to get width of "innards" (minus left and right borders)
    STA tmp+10        ;  put this new width in temp ram
    LDA box_ht        ; Do same with box height
    SEC
    SBC #$02
    STA tmp+11        ;  put new height in temp ram

    CALL WaitForVBlank   ; wait for VBlank
    CALL PlotBoxRow_Top    ; Draw the top row of the box
    @Loop:                    ; Loop to draw all inner rows
      CALL PlotBoxRow_Mid  ;   draw inner row
      DEC tmp+11          ;   decrement our adjusted height
      BNE @Loop           ;   loop until expires
    CALL PlotBoxRow_Bot    ; Draw bottom row

    LDA soft2000          ; reset some PPU info
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL             ; and scroll information
    STA PPUSCROLL


    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw middle row of a box (used by PlotBox)   [$E0A5 :: 0x3E0B5]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Mid:
    FARCALL MenuCondStall  ; do the conditional stall
    LDA PPUSTATUS          ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR          ; Load up desired PPU address
    LDA ppu_dest
    STA PPUADDR
    LDX tmp+10         ; Load adjusted width into X (for loop counter)
    LDA #$FA           ; FA = L border tile
    STA PPUDATA          ;   draw left border

    LDA #$FF           ; FF = inner box body tile
    @Loop:
      STA PPUDATA        ;  draw box body tile
      DEX              ;    until X expires
      BNE @Loop

    LDA #$FB           ; FB = R border tile
    STA PPUDATA          ;  draw right border

    LDA ppu_dest       ; Add #$20 to PPU address so that it points to the next row
    CLC
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0             ; Add 0 to catch carry
    STA ppu_dest+1

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw bottom row of a box (used by PlotBox)   [$E0D7 :: 0x3E0E7]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   ppu_dest is not adjusted for output like it is for other box row drawing routines
;;   since this is the bottom row, no rows will have to be drawn after this one, so it'd
;;   be pointless
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Bot:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; Reset PPU Toggle
    LDA ppu_dest+1      ;  and load up PPU Address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; put adjusted width in X (for loop counter)
    LDA #$FC            ;  FC = DL border tile
    STA PPUDATA

    LDA #$FD            ;  FD = bottom border tile
    @Loop:
      STA PPUDATA         ;  Draw it
      DEX               ;   until X expires
      BNE @Loop

    LDA #$FE            ;  FE = DR border tile
    STA PPUDATA

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw top row of a box (used by PlotBox)   [$E0FC :: 0x3E10C]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Top:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR           ; set PPU Address appropriately
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; load the adjusted width into X (our loop counter)
    LDA #$F7            ; F7 = UL border tile
    STA PPUDATA           ;   draw UL border

    LDA #$F8            ; F8 = U border tile
    @Loop:
      STA PPUDATA         ;   draw U border
      DEX               ;     until X expires
      BNE @Loop

    LDA #$F9            ; F9 = UR border tile
    STA PPUDATA           ;   draw it

    LDA ppu_dest        ; Add #$20 to our input PPU address so that it
    CLC                 ;  points to the next row
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0              ; Add 0 to catch the carry
    STA ppu_dest+1

    RTS



