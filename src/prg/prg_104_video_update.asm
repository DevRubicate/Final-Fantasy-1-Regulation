.segment "PRG_104"

.include "src/global-import.inc"

.export VideoUpdate_Start, ClearVideoStack, VideoUpdateWriteStackBytes, VideoUpdateSetAddress, VideoUpdateSetAddressSetValue, VideoUpdateSetValue, VideoUpdateWriteValueSetValue, VideoUpdateRepeatValue, VideoUpdateRepeatValueSetValueWriteValue

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ClearVideoStack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearVideoStack:
    LDA #>(VideoUpdate_Terminate-1)
    .REPEAT 200, i
        STA VideoUpdateStack + i
    .ENDREPEAT
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateSetAddress
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VideoUpdateSetAddress:
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    LDA #%10100000
    STA PPU_CTL1
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateSetAddress
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VideoUpdateSetAddressSetValue:
    PLA
    STA PPU_VRAM_ADDR
    PLA
    STA PPU_VRAM_ADDR
    LDA #%10100000
    STA PPU_CTL1
    PLA
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
; VideoUpdateSetValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VideoUpdateSetValue:
    PLA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateWriteAndSetValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VideoUpdateWriteValueSetValue:
    STA PPUDATA
    PLA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VideoUpdateRepeatValue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.align  256
    .REPEAT 64, i
        STA PPUDATA
    .ENDREPEAT
VideoUpdateRepeatValue:
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
