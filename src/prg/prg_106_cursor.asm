.segment "PRG_106"

.include "src/global-import.inc"

.export DrawCursorSprite, DrawBlinkingCursorSprite, ClearSprites, AllocateSprites

.import DrawSprite




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

    LDA spr_x
    STA drawX
    LDA spr_y
    STA drawY
    LDA #0
    STA drawFlip
    LDA #0
    STA drawCHR
    LDX #0
    LDY #METASPRITE_CURSOR
    FARCALL DrawSprite

    RTS



DrawBlinkingCursorSprite:
    LDA generalCounter
    AND #%00000010
    BEQ @RTS

    LDA spr_x
    STA drawX
    LDA spr_y
    STA drawY
    LDA #0
    STA drawFlip
    LDA #0
    STA drawCHR
    LDX #0
    LDY #METASPRITE_CURSOR
    FARCALL DrawSprite

    @RTS:
    RTS
