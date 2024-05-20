.segment "PRG_104"

.include "src/global-import.inc"

.export Video_Start
.export Video_Inc1_Address_Set_Write_Set, Video_MassWrite_Address_Set, Video_Inc1_Address, Video_Address, Video_Inc32_Address, Video_Inc1_Address_Set, Video_Address_Set, Video_Inc32_Address_Set, Video_Inc1_Address_Set_Write, Video_Address_Set_Write, Video_Inc32_Address_Set_Write, Video_Inc1_Write_Set, Video_Write_Set, Video_Inc32_Write_Set, Video_Inc1_Set, Video_Set, Video_Inc32_Set, Video_MassWrite
.export VideoWriteStackBytes, Video_MassWrite_Value_Write, Video_MassWrite_Set_Write_Address_Set_Write_Set

.export Video_Address_WriteAttribute, Video_WriteAttributeRepeat, Video_SetFillColor, Video_UploadPalette0, Video_UploadPalette1, Video_UploadPalette2, Video_UploadPalette3, Video_UploadPalette4, Video_UploadPalette5, Video_UploadPalette6, Video_UploadPalette7
.export Video_Inc1_ClearNametable0to119, Video_ClearNametable120to239, Video_ClearNametable240to359, Video_ClearNametable360to479, Video_ClearNametable480to599, Video_ClearNametable600to719, Video_ClearNametable720to839, Video_ClearNametable840to959


.res $81

Video_Terminate:
    ;LDA #>(Video_Terminate-1)
    ;.REPEAT 129, i
    ;    STA VideoStack + i
    ;.ENDREPEAT
    LDA #0
    STA VideoCursor
    LDX StackPointerBackup
    TXS

    LDA #(256 - 96) ; Save 96 bytes for the normal stack
    STA VideoStackTally

    LDA #$B2
    STA VideoCost
    LDA #$FC
    STA VideoCost+1

    ; We have to restore the scroll as this is messed up by our writing to the PPU
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL
    RTS

; We have 2273 cycles of safe time, 50 spent before here, 20 spent here, so that leave 2203 cycles
; left. But we need 513 for OAM DAMA, so 1690.
Video_Start:
    LDA PPU_STAT            ; 4 cycle
    TSX                     ; 2 cycle
    STX StackPointerBackup  ; 4 cycle
    LDX #$FF                ; 2 cycle
    TXS                     ; 2 cycle
    RTS                     ; 6 cycle




VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc1_Address:
    LDA #%10000000
    STA PPU_CTL1
Video_Address:
    PLA
    STA PPUADDR      
    PLA
    STA PPUADDR      
    RTS


VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc32_Address:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    STA PPUADDR
    PLA
    STA PPUADDR
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address_Set
; Cycles:       20 or 26 (inc1)
; Cost:         10 or 13 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
    Video_Inc1_Address_Set:
        LDA #%10000000                  ; 2 cycle
        STA PPU_CTL1                    ; 4 cycle
    Video_Address_Set:
        PLA                             ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        PLA                             ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        PLA                             ; 2 cycle
        RTS                             ; 6 cycle

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc32_Address_Set:
    LDA #%10000100                  ; 2 cycle
    STA PPU_CTL1                    ; 4 cycle
    PLA                             ; 2 cycle
    STA PPUADDR                     ; 4 cycle   
    PLA                             ; 2 cycle
    STA PPUADDR                     ; 4 cycle
    PLA                             ; 2 cycle
    RTS                             ; 6 cycle

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc1_Address_Set_Write:
    LDA #%10000000
    STA PPU_CTL1
Video_Address_Set_Write:
    PLA
    STA PPUADDR      
    PLA
    STA PPUADDR      
    PLA
    STA PPUDATA
    RTS

.res 4

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc32_Address_Set_Write:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    STA PPUADDR      
    PLA
    STA PPUADDR      
    PLA
    STA PPUDATA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Write_Set
; Cycles: 18
; Cost: 9
;
; Video_Write_Set
; Cycles: 12
; Cost: 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
    Video_Inc1_Write_Set:
        LDA #%10000000                  ; 2 cycle
        STA PPU_CTL1                    ; 4 cycle
    Video_Write_Set:
        STA PPUDATA                     ; 4 cycle
        PLA                             ; 2 cycle
        RTS                             ; 6 cycle



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address_Set_Write_Set
; Cycles: 26 or 32
; Cost: 13 or 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc1_Address_Set_Write_Set:
    LDA #%10000000                  ; 2 cycle
    STA PPU_CTL1                    ; 4 cycle
    PLA                             ; 2 cycle
    STA PPUADDR                     ; 4 cycle
    PLA                             ; 2 cycle
    STA PPUADDR                     ; 4 cycle
    PLA                             ; 2 cycle
    STA PPUDATA                     ; 4 cycle
    PLA                             ; 2 cycle
    RTS                             ; 6 cycle











VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc32_Write_Set:
    LDA #%10000100
    STA PPU_CTL1
    STA PPUDATA
    PLA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc1_Set:
    LDA #%10000000
    STA PPU_CTL1
Video_Set:
    PLA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Inc32_Set:
    LDA #%10000100
    STA PPU_CTL1
    PLA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite
; Cycles: N * 4 + 6
; Cost: N * 2 + 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        ; TODO: Verify you can actually use this 85 times
        .REPEAT 85, i
            STA PPUDATA                 ; 4 cycles
        .ENDREPEAT
    Video_MassWrite:
        RTS                             ; 6 cycles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Address_Set
; Cycles: N * 4 + 20
; Cost: N * 2 + 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 85, i
            STA PPUDATA                 ; 4 cycles
        .ENDREPEAT
    Video_MassWrite_Address_Set:
        PLA                             ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        PLA                             ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        PLA                             ; 2 cycle
        RTS                             ; 6 cycles


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoWriteStackBytes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align 256
    .repeat 64, i
        PLA
        STA PPUDATA
    .endrepeat
VideoWriteStackBytes:
    RTS






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_ClearNametable0to119
; Cycles: 498 or 504 (inc1)
; Cost: 249 or 252 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_ClearNametable0to119:
        LDA #%10000000                  ; 2 cycle
        STA PPU_CTL1                    ; 4 cycle
        LDA #$20                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$00                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable120to239
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable120to239:
        LDA #$20                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$78                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable240to359
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable240to359:
        LDA #$20                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$F0                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable360to479
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable360to479:
        LDA #$21                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$68                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable480to599
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable480to599:
        LDA #$21                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$E0                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable600to719
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable600to719:
        LDA #$22                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$58                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable720to839
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable720to839:
        LDA #$22                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$D0                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_ClearNametable840to959
; Cycles: 500
; Cost: 250
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_ClearNametable840to959:
        LDA #$23                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #$48                        ; 2 cycle
        STA PPUADDR                     ; 4 cycle
        LDA #0                          ; 2 cycle
        .repeat 120, i
            STA PPUDATA                 ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Value_Write
; Cycles: N * 4 + 12
; Cost: N * 2 + 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 64, i
            STA PPUDATA             ; 4 cycles
        .ENDREPEAT
    Video_MassWrite_Value_Write:
        PLA                         ; 2 cycles
        STA PPUDATA                 ; 4 cycles
        RTS                         ; 6 cycles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Set_Write_Address_Set_Write_Set
; Cycles: N * 4 + 32
; Cost: N * 2 + 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 64, i
            STA PPUDATA             ; 4 cycles
        .ENDREPEAT
    Video_MassWrite_Set_Write_Address_Set_Write_Set:
        PLA                         ; 2 cycles
        STA PPUDATA                 ; 4 cycles
        PLA                         ; 2 cycle
        STA PPUADDR                 ; 4 cycle
        PLA                         ; 2 cycle
        STA PPUADDR                 ; 4 cycle
        PLA                         ; 2 cycles
        STA PPUDATA                 ; 4 cycles
        PLA                         ; 2 cycles
        RTS                         ; 6 cycles


Video_SetFillColor:
  LDA PPU_STAT
  LDA #$3F
  STA PPUADDR        
  LDA #$00
  STA PPUADDR        
  LDA fillColor
  STA PPU_VRAM_DATA
  RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette0:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$01
    STA PPUADDR      
    LDA palette0+0
    STA PPU_VRAM_DATA
    LDA palette0+1
    STA PPU_VRAM_DATA
    LDA palette0+2
    STA PPU_VRAM_DATA
    RTS

.res $4

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette1:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$05
    STA PPUADDR      
    LDA palette1+3
    STA PPU_VRAM_DATA
    LDA palette1+4
    STA PPU_VRAM_DATA
    LDA palette1+5
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette2:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$09
    STA PPUADDR      
    LDA palette2+6
    STA PPU_VRAM_DATA
    LDA palette2+7
    STA PPU_VRAM_DATA
    LDA palette2+8
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette3:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$0D
    STA PPUADDR      
    LDA palette3+9
    STA PPU_VRAM_DATA
    LDA palette3+10
    STA PPU_VRAM_DATA
    LDA palette3+11
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette4:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$11
    STA PPUADDR      
    LDA palette4+12
    STA PPU_VRAM_DATA
    LDA palette4+13
    STA PPU_VRAM_DATA
    LDA palette4+14
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette5:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$15
    STA PPUADDR      
    LDA palette5+15
    STA PPU_VRAM_DATA
    LDA palette5+16
    STA PPU_VRAM_DATA
    LDA palette5+17
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette6:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$19
    STA PPUADDR      
    LDA palette6+18
    STA PPU_VRAM_DATA
    LDA palette6+19
    STA PPU_VRAM_DATA
    LDA palette6+20
    STA PPU_VRAM_DATA
    RTS

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_UploadPalette7:
    LDA #%10000000
    STA PPU_CTL1

    LDA PPU_STAT
    LDA #$3F
    STA PPUADDR      
    LDA #$1D
    STA PPUADDR      
    LDA palette7+21
    STA PPU_VRAM_DATA
    LDA palette7+22
    STA PPU_VRAM_DATA
    LDA palette7+23
    STA PPU_VRAM_DATA
    RTS


VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
Video_Address_WriteAttribute:
    LDA #%10000000
    STA PPU_CTL1


;    LDA #$23
;    STA PPUADDR         
;    PLA
;    TAX
;    CLC
;    ADC #$C0
;    STA PPUADDR         
;    LDA attributeTable,X
;    STA PPUDATA

    PLA
    LDA #$23
    STA PPUADDR      
    LDA #$C0
    STA PPUADDR      

    .repeat 64, i
        LDA attributeTable+i
        STA PPUDATA
    .endrepeat

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_WriteAttributeRepeat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align 256
    .REPEAT 8, i
        ; TODO: remove this INX in favor of using +i
        INX
        LDA attributeTable,X
        STA PPUDATA
    .ENDREPEAT
Video_WriteAttributeRepeat:
    RTS
