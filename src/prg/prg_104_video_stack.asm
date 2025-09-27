.segment "PRG_104"

.include "src/global-import.inc"

.export Video_Start
.export Video_Set, Video_Inc1_Address_Set_Write_Set, Video_MassWrite_Address_Set, Video_Inc1_Address, Video_Address, Video_Inc32_Address, Video_Inc1_Address_Set, Video_Address_Set, Video_Inc32_Address_Set, Video_Inc1_Address_Set_Write, Video_Address_Set_Write, Video_Inc32_Address_Set_Write, Video_Inc1_Write_Set, Video_Write_Set, Video_Inc1_Set, Video_Set, Video_MassWrite
.export Video_MassWriteStack, Video_MassWrite_Value_Write, Video_MassWrite_Set_Write_Address_Set_Write_Set
.export Video_Inc1_CHRBank_Address_Set, Video_SetFillColor, Video_Inc1_UploadPalette0, Video_Inc1_UploadPalette1, Video_Inc1_UploadPalette2, Video_Inc1_UploadPalette3, Video_Inc1_UploadPalette4, Video_Inc1_UploadPalette5, Video_Inc1_UploadPalette6, Video_Inc1_UploadPalette7
.export Video_Inc1_Set_FillNametable0to119, Video_Set_FillNametable120to239, Video_Set_FillNametable240to359, Video_Set_FillNametable360to479, Video_Set_FillNametable480to599, Video_Set_FillNametable600to719, Video_Set_FillNametable720to839, Video_Set_FillNametable840to959
.export Video_Inc1_Set_FillAttributeTable, Video_Inc1_CHRBank_Address, Video_WriteMassiveImagePattern_128, Video_WriteMassiveImageNametable

; We have 1684 (842) cost to spend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Terminate
; Address: $8080
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .res $81
    Video_Terminate:
        LDA #0
        STA VideoCursor
        LDX StackPointerBackup
        TXS

        ; Reset VideoIncrementAddressOffset to start as Inc1 mode
        LDA #VIDEO_INCREMENT_ADDRESS_OFFSET_1
        STA VideoIncrementAddressOffset

        LDA spriteCHRBank0
        STA MMC5_SPRITE_CHR_BANK0
        LDA spriteCHRBank1
        STA MMC5_SPRITE_CHR_BANK1
        LDA spriteCHRBank2
        STA MMC5_SPRITE_CHR_BANK2
        LDA spriteCHRBank3
        STA MMC5_SPRITE_CHR_BANK3
        LDA spriteCHRBank4
        STA MMC5_SPRITE_CHR_BANK4
        LDA spriteCHRBank5
        STA MMC5_SPRITE_CHR_BANK5
        LDA spriteCHRBank6
        STA MMC5_SPRITE_CHR_BANK6
        LDA spriteCHRBank7
        STA MMC5_SPRITE_CHR_BANK7

        LDA backgroundCHRBank0
        STA MMC5_BACKGROUND_CHR_BANK0
        LDA backgroundCHRBank1
        STA MMC5_BACKGROUND_CHR_BANK1
        LDA backgroundCHRBank2
        STA MMC5_BACKGROUND_CHR_BANK2
        LDA backgroundCHRBank3
        STA MMC5_BACKGROUND_CHR_BANK3

        ; We have to restore the scroll as this is messed up by our writing to the PPU
        LDA scrollX
        STA PPU_SCROLL
        LDA scrollY
        STA PPU_SCROLL
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Start:
        ; Vblank time is 20 lines or 2273 cycles. I mentally subtract 73 cycles when quoting how much time is available for transfers. The first 13 of those 73 cycles are up to 6 cycles for the previous instruction to finish and the 7 cycles of the interrupt sequence. (The other 60 are an estimate for setup and teardown of the transfer routine.) 
        ; We have 2273 cycle of safe time, 50 spent before here, 26 spent here, so that leave 2197 cycle
        ; left. But we need 513 for OAM DAMA, so 1684.
        ; Always start in Inc1 mode
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle

        TSX                     ; 2 cycle
        STX StackPointerBackup  ; 4 cycle
        LDX #$FF                ; 2 cycle
        TXS                     ; 2 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address
; Cost: 11 or 14 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Address:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Address
; Cost: 11
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Address:
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle    
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle   
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Set
; Cost: 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .res 1
    Video_Inc1_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
            LDA #%10100100                      ; 2 cycle
            STA PPU_CTRL                        ; 4 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set
; Cost: 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set:
        PLA                                     ; 4 cycle
        RTS                                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc32_Address
; Cost: 11 or 14 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc32_Address:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100100                          ; 2 cycle
        STA PPU_CTRL                            ; 4 cycle
        PLA                                     ; 4 cycle
        STA PPU_ADDR                            ; 4 cycle
        PLA                                     ; 4 cycle
        STA PPU_ADDR                            ; 4 cycle
        RTS                                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address_Set
; Cost: 13 or 16 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Address_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Address_Set
; Cost: 13
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Address_Set:
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_CHRBank_Address
; Cost: 15 or 18 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_CHRBank_Address:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        PLA                             ; 4 cycle
        STA MMC5_BACKGROUND_CHR_BANK0   ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_CHRBank_Address_Set
; Cost: 17 or 20 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_CHRBank_Address_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        PLA                             ; 4 cycle
        STA MMC5_BACKGROUND_CHR_BANK0   ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc32_Address_Set
; Cost: 13 or 16 (inc32)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc32_Address_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100100                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle   
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address_Set_Write
; Cost: 16 or 19 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Address_Set_Write:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Address_Set_Write
; Cost: 16
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Address_Set_Write:
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_DATA                    ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc32_Address_Set_Write
; Cost: 16 or 19 (inc32)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc32_Address_Set_Write:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100100                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_DATA                    ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Write_Set
; Cost: 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Write_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Write_Set
; Cost: 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Write_Set:
        STA PPU_DATA                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Address_Set_Write_Set
; Cost: 17 or 20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Address_Set_Write_Set:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_DATA                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite
; Cost: N * 2 + 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        ; TODO: Verify you can actually use this 85 times
        .REPEAT 85, i
            STA PPU_DATA                ; 4 cycle
        .ENDREPEAT
    Video_MassWrite:
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Address_Set
; Cost: N * 2 + 13
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 85, i
            STA PPU_DATA                ; 4 cycle
        .ENDREPEAT
    Video_MassWrite_Address_Set:
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWriteStack
; Cost: N * 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .repeat 64, i
            PLA             ; 4 cycle
            STA PPU_DATA    ; 4 cycle
        .endrepeat
    Video_MassWriteStack:
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_Set_FillNametable0to119
; Cost: 251 or 254 (inc1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Set_FillNametable0to119:
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        LDA #$20                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$00                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable120to239
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable120to239:
        LDA #$20                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$78                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable240to359
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable240to359:
        LDA #$20                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$F0                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable360to479
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable360to479:
        LDA #$21                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$68                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable480to599
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable480to599:
        LDA #$21                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$E0                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable600to719
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable600to719:
        LDA #$22                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$58                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable720to839
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable720to839:
        LDA #$22                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$D0                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Set_FillNametable840to959
; Cost: 251
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Set_FillNametable840to959:
        LDA #$23                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$48                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 120, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_FillAttributeTable
; Cost: 139 or 142
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_Set_FillAttributeTable:
        ; Increment mode start
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        ; Non-increment mode start
        LDA #$23                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$C0                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        .repeat 64, i
            STA PPU_DATA                ; 4 cycle
        .endrepeat
        RTS                             ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Value_Write
; Cost: N * 2 + 7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 64, i
            STA PPU_DATA            ; 4 cycle
        .ENDREPEAT
    Video_MassWrite_Value_Write:
        PLA                         ; 4 cycle
        STA PPU_DATA                ; 4 cycle
        RTS                         ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_MassWrite_Set_Write_Address_Set_Write_Set
; Cost: N * 2 + 21
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .REPEAT 64, i
            STA PPU_DATA            ; 4 cycle
        .ENDREPEAT
    Video_MassWrite_Set_Write_Address_Set_Write_Set:
        PLA                         ; 4 cycle
        STA PPU_DATA                ; 4 cycle
        PLA                         ; 4 cycle
        STA PPU_ADDR                ; 4 cycle
        PLA                         ; 4 cycle
        STA PPU_ADDR                ; 4 cycle
        PLA                         ; 4 cycle
        STA PPU_DATA                ; 4 cycle
        PLA                         ; 4 cycle
        RTS                         ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_SetFillColor
; Cost: 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_SetFillColor:
      LDA #$3F                  ; 2 cycle
      STA PPU_ADDR              ; 4 cycle
      LDA #$00                  ; 2 cycle
      STA PPU_ADDR              ; 4 cycle
      LDA fillColor             ; 4 cycle
      STA PPU_DATA              ; 4 cycle  
      RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette0
; Cost: 21 or 24
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette0:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$01                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette0+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette0+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette0+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette1
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette1:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$05                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette1+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette1+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette1+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette2
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette2:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$09                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette2+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette2+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette2+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette3
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette3:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$0D                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette3+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette3+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette3+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette4
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette4:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$11                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette4+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette4+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette4+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette5
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette5:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$15                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette5+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette5+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette5+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette6
; Cost: 23 or 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette6:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$19                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette6+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette6+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette6+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_Inc1_UploadPalette7
; Cost: 26
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_Inc1_UploadPalette7:
        VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
        LDA #%10100000          ; 2 cycle
        STA PPU_CTRL            ; 4 cycle
        LDA PPU_STATUS          ; 4 cycle
        LDA #$3F                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA #$1D                ; 2 cycle
        STA PPU_ADDR            ; 4 cycle
        LDA palette7+0          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette7+1          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        LDA palette7+2          ; 4 cycle
        STA PPU_DATA            ; 4 cycle
        RTS                     ; 6 cycle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_WriteAttributeRepeat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .align 256
        .repeat 8, i
            ; TODO: remove this INX in favor of using +i
            INX
            LDA attributeTable,X
            STA PPU_DATA
        .endrepeat
    Video_WriteAttributeRepeat:
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_WriteMassiveImagePattern
; Cost: 463 or 466
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_WriteMassiveImagePattern_128:
        ; Increment mode start
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        ; Non-increment mode start
        PLA                             ; 4 cycle
        STA MMC5_BACKGROUND_CHR_BANK0   ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle

        .repeat 128, i
            LDA MassiveImageBuffer + i  ; 3 cycle * 128
            STA PPU_DATA                ; 4 cycle * 128
        .endrepeat
        RTS                             ; 6 cycle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Video_WriteMassiveImageNametable
; Cost: 778 or 781
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    Video_WriteMassiveImageNametable:
        ; Increment mode start
        LDA #%10100000                  ; 2 cycle
        STA PPU_CTRL                    ; 4 cycle
        ; Non-increment mode start
        PLA                             ; 4 cycle
        STA PPU_ADDR                    ; 4 cycle
        LDA #$00                        ; 2 cycle
        STA PPU_ADDR                    ; 4 cycle

        LDY #0                          ; 2 cycle
        .repeat 256, i
            .if i > 0
                INY                     ; 2 cycle * 255
            .endif
            STY PPU_DATA                ; 4 cycle * 256
        .endrepeat
        RTS                             ; 6 cycle
