.segment "PRG_106"

.include "src/global-import.inc"

.export DrawCursorSprite, DrawBlinkingCursorSprite, ClearSprites, AllocateSprites




ClearSprites:
    LDA #0
    STA spriteRAMCursor
    LDA #255
    .REPEAT 64, i
        STA spriteRAM+(i*4)
    .ENDREPEAT
    RTS

AllocateSprites:
    LDX spriteRAMCursor
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    ADC spriteRAMCursor
    STA spriteRAMCursor
    RTS


DrawCursorSprite:
    LDA #4
    CALL AllocateSprites

    LDA spr_y
    STA spriteRAM+0,X
    LDA spr_x
    STA spriteRAM+3,X
    LDA #$F0
    STA spriteRAM+1,X
    LDA #%00000010
    STA spriteRAM+2,X


    LDA spr_y
    STA spriteRAM+0+4,X
    LDA spr_x
    CLC
    ADC #8
    STA spriteRAM+3+4,X
    LDA #$F1
    STA spriteRAM+1+4,X
    LDA #%00000010
    STA spriteRAM+2+4,X

    LDA spr_y
    CLC
    ADC #8
    STA spriteRAM+0+8,X
    LDA spr_x
    STA spriteRAM+3+8,X
    LDA #$F2
    STA spriteRAM+1+8,X
    LDA #%00000010
    STA spriteRAM+2+8,X


    LDA spr_y
    CLC
    ADC #8
    STA spriteRAM+0+12,X
    LDA spr_x
    CLC
    ADC #8
    STA spriteRAM+3+12,X
    LDA #$F3
    STA spriteRAM+1+12,X
    LDA #%00000010
    STA spriteRAM+2+12,X

    RTS



DrawBlinkingCursorSprite:
    LDA generalCounter
    AND #%00000010
    BEQ @RTS

    LDA #4
    CALL AllocateSprites

    LDA spr_y
    STA spriteRAM+0,X
    LDA spr_x
    STA spriteRAM+3,X
    LDA #$F0
    STA spriteRAM+1,X
    LDA #%00000010
    STA spriteRAM+2,X

    LDA spr_y
    STA spriteRAM+0+4,X
    LDA spr_x
    CLC
    ADC #8
    STA spriteRAM+3+4,X
    LDA #$F1
    STA spriteRAM+1+4,X
    LDA #%00000010
    STA spriteRAM+2+4,X

    LDA spr_y
    CLC
    ADC #8
    STA spriteRAM+0+8,X
    LDA spr_x
    STA spriteRAM+3+8,X
    LDA #$F2
    STA spriteRAM+1+8,X
    LDA #%00000010
    STA spriteRAM+2+8,X

    LDA spr_y
    CLC
    ADC #8
    STA spriteRAM+0+12,X
    LDA spr_x
    CLC
    ADC #8
    STA spriteRAM+3+12,X
    LDA #$F3
    STA spriteRAM+1+12,X
    LDA #%00000010
    STA spriteRAM+2+12,X

    @RTS:
    RTS
