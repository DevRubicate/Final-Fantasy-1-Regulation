.segment "PRG_104"

.include "src/global-import.inc"

.export VideoUpdate_Start, ClearVideoStack
.export VideoUpdate_Inc1_Address, VideoUpdate_Address, VideoUpdate_Inc32_Address, VideoUpdate_Inc1_Address_Set, VideoUpdate_Address_Set, VideoUpdate_Inc32_Address_Set, VideoUpdate_Inc1_Address_Set_Write, VideoUpdate_Address_Set_Write, VideoUpdate_Inc32_Address_Set_Write, VideoUpdate_Inc1_Write_Set, VideoUpdate_Write_Set, VideoUpdate_Inc32_Write_Set, VideoUpdate_Inc1_Set, VideoUpdate_Set, VideoUpdate_Inc32_Set, VideoUpdate_MassWrite
.export VideoUpdateWriteStackBytes, VideoUpdateRepeatValueSetValueWriteValue

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
    ; We have to restore the scroll as this is messed up by our writing to the PPU
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL
    RTS

VideoUpdate_Start:
    LDA PPU_STAT
    TSX
    STX StackPointerBackup
    LDX #$FF
    TXS
    RTS

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

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc1_Address_Set:
    LDA #%10000000
    STA PPU_CTL1
VideoUpdate_Address_Set:
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    PLA
    RTS

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

VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
VideoUpdate_Inc1_Write_Set:
    LDA #%10000000
    STA PPU_CTL1
VideoUpdate_Write_Set:
    STA PPUDATA
    PLA
    RTS

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

.align  256
    ; TODO: Verify you can actually use this 85 times
    .REPEAT 85, i
        STA PPUDATA
    .ENDREPEAT
VideoUpdate_MassWrite:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateWriteStackBytes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align  256
    .REPEAT 64, i
        PLA
        STA PPUDATA
    .ENDREPEAT
VideoUpdateWriteStackBytes:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateRepeatValueSetValueWriteValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align  256
    .REPEAT 64, i
        STA PPUDATA
    .ENDREPEAT
VideoUpdateRepeatValueSetValueWriteValue:
    PLA
    STA PPUDATA
    RTS


