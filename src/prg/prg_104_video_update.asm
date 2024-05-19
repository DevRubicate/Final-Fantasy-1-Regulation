.segment "PRG_104"

.include "src/global-import.inc"

.export VideoUpdate_Start, ClearVideoStack
.export VideoUpdate_Inc1_Address, VideoUpdate_Address, VideoUpdate_Inc32_Address, VideoUpdate_Inc1_Address_Set, VideoUpdate_Address_Set, VideoUpdate_Inc32_Address_Set, VideoUpdate_Inc1_Address_Set_Write, VideoUpdate_Address_Set_Write, VideoUpdate_Inc32_Address_Set_Write, VideoUpdate_Inc1_Write_Set, VideoUpdate_Write_Set, VideoUpdate_Inc32_Write_Set, VideoUpdate_Inc1_Set, VideoUpdate_Set, VideoUpdate_Inc32_Set, VideoUpdate_MassWrite
.export VideoUpdateWriteStackBytes, VideoUpdateRepeatValueSetValueWriteValue

.export VideoUpdate_Address_WriteAttribute, VideoUpdate_WriteAttributeRepeat, VideoUpdate_SetFillColor, VideoUpdate_UploadPalette0, VideoUpdate_UploadPalette1, VideoUpdate_UploadPalette2, VideoUpdate_UploadPalette3, VideoUpdate_UploadPalette4, VideoUpdate_UploadPalette5, VideoUpdate_UploadPalette6, VideoUpdate_UploadPalette7



.res $81

VideoUpdate_Terminate:
    ;LDA #>(VideoUpdate_Terminate-1)
    ;.REPEAT 129, i
    ;    STA VideoUpdateStack + i
    ;.ENDREPEAT
    LDA #0
    STA VideoUpdateCursor
    LDX StackPointerBackup
    TXS

    LDA #$50
    STA VideoUpdateStackTally

    LDA #$B2
    STA VideoUpdateCost
    LDA #$FC
    STA VideoUpdateCost+1

    ; We have to restore the scroll as this is messed up by our writing to the PPU
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL
    RTS

; We have 2273 cycles of safe time, 50 spent before here, 20 spent here, so that leave 2203 cycles
; left. But we need 513 for OAM DAMA, so 1690 / 256 = 6.5~, so each "cost point" will correspond to 6.5 cycles
VideoUpdate_Start:
    LDA PPU_STAT            ; 4 cycle
    TSX                     ; 2 cycle
    STX StackPointerBackup  ; 4 cycle
    LDX #$FF                ; 2 cycle
    TXS                     ; 2 cycle
    RTS                     ; 6 cycle




VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc1_Address:
    LDA #%10000000
    STA PPU_CTL1
VideoUpdate_Address:
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ClearVideoStack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearVideoStack:
    LDA #>(VideoUpdate_Terminate-1)
    .REPEAT 200, i
        STA VideoUpdateStack + i
    .ENDREPEAT
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc32_Address:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdate_Inc1_Address_Set
;
; Cycles: 26
; Cost: 13
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
    VideoUpdate_Inc1_Address_Set:
        LDA #%10000000                  ; 2 cycle
        STA PPU_CTL1                    ; 4 cycle
    VideoUpdate_Address_Set:
        PLA                             ; 2 cycle
        STA PPU_VRAM_ADDR               ; 4 cycle
        PLA                             ; 2 cycle
        STA PPU_VRAM_ADDR               ; 4 cycle
        PLA                             ; 2 cycle
        RTS                             ; 6 cycle

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc32_Address_Set:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    PLA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc1_Address_Set_Write:
    LDA #%10000000
    STA PPU_CTL1
VideoUpdate_Address_Set_Write:
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPUDATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc32_Address_Set_Write:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPUDATA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdate_Inc1_Write_Set
;
; Cycles: 18
; Cost: 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
    VideoUpdate_Inc1_Write_Set:
        LDA #%10000000                  ; 2 cycle
        STA PPU_CTL1                    ; 4 cycle
    VideoUpdate_Write_Set:
        STA PPUDATA                     ; 4 cycle
        PLA                             ; 2 cycle
        RTS                             ; 6 cycle

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc32_Write_Set:
    LDA #%10000100
    STA PPU_CTL1
    STA PPUDATA
    PLA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc1_Set:
    LDA #%10000000
    STA PPU_CTL1
VideoUpdate_Set:
    PLA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc32_Set:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdate_MassWrite
;
; Cycles: N * 4 + 6
; Cost: N * 2 + 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align 256
    ; TODO: Verify you can actually use this 85 times
    .REPEAT 85, i
        STA PPUDATA                 ; 4 cycles
    .ENDREPEAT
VideoUpdate_MassWrite:
    RTS                             ; 6 cycles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateWriteStackBytes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align 256
    .REPEAT 64, i
        PLA
        STA PPUDATA
    .ENDREPEAT
VideoUpdateWriteStackBytes:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateRepeatValueSetValueWriteValue
;
; Cycles: N * 4 + 12
; Cost: N * 2 + 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 64, i
            STA PPUDATA             ; 4 cycles
        .ENDREPEAT
    VideoUpdateRepeatValueSetValueWriteValue:
        PLA                         ; 2 cycles
        STA PPUDATA                 ; 4 cycles
        RTS                         ; 6 cycles

VideoUpdate_SetFillColor:
  LDA PPU_STAT
  LDA #$3F
  STA PPU_VRAM_ADDR
  LDA #$00
  STA PPU_VRAM_ADDR
  LDA fillColor
  STA PPU_VRAM_DATA
  RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette0:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$01
    STA PPU_VRAM_ADDR
    LDA palette0+0
    STA PPU_VRAM_DATA
    LDA palette0+1
    STA PPU_VRAM_DATA
    LDA palette0+2
    STA PPU_VRAM_DATA
    RTS

.res $4

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette1:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$05
    STA PPU_VRAM_ADDR
    LDA palette1+3
    STA PPU_VRAM_DATA
    LDA palette1+4
    STA PPU_VRAM_DATA
    LDA palette1+5
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette2:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$09
    STA PPU_VRAM_ADDR
    LDA palette2+6
    STA PPU_VRAM_DATA
    LDA palette2+7
    STA PPU_VRAM_DATA
    LDA palette2+8
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette3:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$0D
    STA PPU_VRAM_ADDR
    LDA palette3+9
    STA PPU_VRAM_DATA
    LDA palette3+10
    STA PPU_VRAM_DATA
    LDA palette3+11
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette4:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$11
    STA PPU_VRAM_ADDR
    LDA palette4+12
    STA PPU_VRAM_DATA
    LDA palette4+13
    STA PPU_VRAM_DATA
    LDA palette4+14
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette5:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$15
    STA PPU_VRAM_ADDR
    LDA palette5+15
    STA PPU_VRAM_DATA
    LDA palette5+16
    STA PPU_VRAM_DATA
    LDA palette5+17
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette6:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$19
    STA PPU_VRAM_ADDR
    LDA palette6+18
    STA PPU_VRAM_DATA
    LDA palette6+19
    STA PPU_VRAM_DATA
    LDA palette6+20
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_UploadPalette7:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPU_VRAM_ADDR
    LDA #$1D
    STA PPU_VRAM_ADDR
    LDA palette7+21
    STA PPU_VRAM_DATA
    LDA palette7+22
    STA PPU_VRAM_DATA
    LDA palette7+23
    STA PPU_VRAM_DATA
    RTS


VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Address_WriteAttribute:
    LDA #%10000000
    STA PPU_CTL1


;    LDA #$23
;    STA PPU_VRAM_ADDR
;    PLA
;    TAX
;    CLC
;    ADC #$C0
;    STA PPU_VRAM_ADDR
;    LDA attributeTable,X
;    STA PPUDATA

    PLA
    LDA #$23
    STA PPU_VRAM_ADDR
    LDA #$C0
    STA PPU_VRAM_ADDR

    .repeat 64, i
        LDA attributeTable+i
        STA PPUDATA
    .endrepeat

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdate_WriteAttributeRepeat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align 256
    .REPEAT 8, i
        ; TODO: remove this INX in favor of using +i
        INX
        LDA attributeTable,X
        STA PPUDATA
    .ENDREPEAT
VideoUpdate_WriteAttributeRepeat:
    RTS
