.segment "PRG_094"

.include "src/global-import.inc"

.import AllocateSprites

.export DrawSprite

DrawSprite:
    LDA drawVars+0
    ASL A
    ASL A
    ORA drawHeight
    ASL A
    ASL A
    ORA drawWidth
    TAX

    LDA LUT_FullDrawJumpTableLo,X
    STA Var0
    LDA LUT_FullDrawJumpTableHi,X
    STA Var1
    JMP (Var0)

LUT_FullDrawJumpTableLo:
    .lobytes FullDraw_1x1
    .lobytes FullDraw_2x1
    .lobytes FullDraw_3x1
    .lobytes FullDraw_4x1
    .lobytes FullDraw_1x2
    .lobytes FullDraw_2x2
    .lobytes FullDraw_3x2
    .lobytes FullDraw_4x2
    .lobytes FullDraw_1x3
    .lobytes FullDraw_2x3
    .lobytes FullDraw_3x3
    .lobytes FullDraw_4x3
    .lobytes FullDraw_1x4
    .lobytes FullDraw_2x4
    .lobytes FullDraw_3x4
    .lobytes FullDraw_4x4
    .lobytes FullDraw_2x1_hFlip
    .lobytes FullDraw_3x1_hFlip
    .lobytes FullDraw_4x1_hFlip
    .lobytes FullDraw_2x2_hFlip
    .lobytes FullDraw_3x2_hFlip
    .lobytes FullDraw_4x2_hFlip
    .lobytes FullDraw_2x3_hFlip
    .lobytes FullDraw_3x3_hFlip
    .lobytes FullDraw_4x3_hFlip
    .lobytes FullDraw_2x4_hFlip
    .lobytes FullDraw_3x4_hFlip
    .lobytes FullDraw_4x4_hFlip
    .lobytes FullDraw_1x2_vFlip
    .lobytes FullDraw_2x2_vFlip
    .lobytes FullDraw_3x2_vFlip
    .lobytes FullDraw_4x2_vFlip
    .lobytes FullDraw_1x3_vFlip
    .lobytes FullDraw_2x3_vFlip
    .lobytes FullDraw_3x3_vFlip
    .lobytes FullDraw_4x3_vFlip
    .lobytes FullDraw_1x4_vFlip
    .lobytes FullDraw_2x4_vFlip
    .lobytes FullDraw_3x4_vFlip
    .lobytes FullDraw_4x4_vFlip
    .lobytes FullDraw_2x1_hFlip_vFlip
    .lobytes FullDraw_3x1_hFlip_vFlip
    .lobytes FullDraw_4x1_hFlip_vFlip
    .lobytes FullDraw_1x2_hFlip_vFlip
    .lobytes FullDraw_2x2_hFlip_vFlip
    .lobytes FullDraw_3x2_hFlip_vFlip
    .lobytes FullDraw_4x2_hFlip_vFlip
    .lobytes FullDraw_1x3_hFlip_vFlip
    .lobytes FullDraw_2x3_hFlip_vFlip
    .lobytes FullDraw_3x3_hFlip_vFlip
    .lobytes FullDraw_4x3_hFlip_vFlip
    .lobytes FullDraw_1x4_hFlip_vFlip
    .lobytes FullDraw_2x4_hFlip_vFlip
    .lobytes FullDraw_3x4_hFlip_vFlip
    .lobytes FullDraw_4x4_hFlip_vFlip

LUT_FullDrawJumpTableHi:
    .hibytes FullDraw_1x1
    .hibytes FullDraw_2x1
    .hibytes FullDraw_3x1
    .hibytes FullDraw_4x1
    .hibytes FullDraw_1x2
    .hibytes FullDraw_2x2
    .hibytes FullDraw_3x2
    .hibytes FullDraw_4x2
    .hibytes FullDraw_1x3
    .hibytes FullDraw_2x3
    .hibytes FullDraw_3x3
    .hibytes FullDraw_4x3
    .hibytes FullDraw_1x4
    .hibytes FullDraw_2x4
    .hibytes FullDraw_3x4
    .hibytes FullDraw_4x4
    .hibytes FullDraw_2x1_hFlip
    .hibytes FullDraw_3x1_hFlip
    .hibytes FullDraw_4x1_hFlip
    .hibytes FullDraw_2x2_hFlip
    .hibytes FullDraw_3x2_hFlip
    .hibytes FullDraw_4x2_hFlip
    .hibytes FullDraw_2x3_hFlip
    .hibytes FullDraw_3x3_hFlip
    .hibytes FullDraw_4x3_hFlip
    .hibytes FullDraw_2x4_hFlip
    .hibytes FullDraw_3x4_hFlip
    .hibytes FullDraw_4x4_hFlip
    .hibytes FullDraw_1x2_vFlip
    .hibytes FullDraw_2x2_vFlip
    .hibytes FullDraw_3x2_vFlip
    .hibytes FullDraw_4x2_vFlip
    .hibytes FullDraw_1x3_vFlip
    .hibytes FullDraw_2x3_vFlip
    .hibytes FullDraw_3x3_vFlip
    .hibytes FullDraw_4x3_vFlip
    .hibytes FullDraw_1x4_vFlip
    .hibytes FullDraw_2x4_vFlip
    .hibytes FullDraw_3x4_vFlip
    .hibytes FullDraw_4x4_vFlip
    .hibytes FullDraw_2x1_hFlip_vFlip
    .hibytes FullDraw_3x1_hFlip_vFlip
    .hibytes FullDraw_4x1_hFlip_vFlip
    .hibytes FullDraw_1x2_hFlip_vFlip
    .hibytes FullDraw_2x2_hFlip_vFlip
    .hibytes FullDraw_3x2_hFlip_vFlip
    .hibytes FullDraw_4x2_hFlip_vFlip
    .hibytes FullDraw_1x3_hFlip_vFlip
    .hibytes FullDraw_2x3_hFlip_vFlip
    .hibytes FullDraw_3x3_hFlip_vFlip
    .hibytes FullDraw_4x3_hFlip_vFlip
    .hibytes FullDraw_1x4_hFlip_vFlip
    .hibytes FullDraw_2x4_hFlip_vFlip
    .hibytes FullDraw_3x4_hFlip_vFlip
    .hibytes FullDraw_4x4_hFlip_vFlip

.macro MACRO_FULLDRAW _width, _height, _hFlip, _vFlip
    LDA #(_width * _height)
    FARCALL AllocateSprites



    ; y position
    LDA drawY
    .repeat _height, h
        .if h <> 0; && h .mod _width = 0
            CLC
            ADC #8
        .endif
        .repeat _width, w
            .if _vFlip = 1
                STA a:spriteRAM + (_height * _width - (h * (_height - 1) + w)) * 4,X
            .else
                STA spriteRAM + (h * _width + w) * 4,X
            .endif
        .endrepeat
    .endrepeat

    ; x position
    LDA drawX
    .repeat _width, w
        ; For each sprite we want the next one to be 8 pixels to the right. The exception
        ; to this is the very first sprite.
        .if w <> 0
            CLC
            ADC #8
        .endif

        ; If an object has multiple sprites in height, it means we should set then x position
        ; of all sprites that belong on that y-axis.
        .repeat _height, h
            .if _hFlip
                STA a:spriteRAM + (_height * _width - (h * (_height - 1) + w)) * 4 + 3,X
            .else
                STA a:spriteRAM + (h * _width + w) * 4 + 3,X
            .endif
        .endrepeat
    .endrepeat

    LDA drawVars+1
    .repeat _height, h
        .repeat _width, w
            .if w <> 0 || h <> 0
                CLC
                ADC #$01
            .endif
            STA a:spriteRAM + (h * _width + w) * 4 + 1,X
        .endrepeat
    .endrepeat

    LDA #0
    .repeat _width, w
        .repeat _height, h
            STA a:spriteRAM + (h * _width + w) * 4 + 2,X
        .endrepeat
    .endrepeat

    RTS
.endmacro

FullDraw_1x1:
    MACRO_FULLDRAW 1, 1, 0, 0
FullDraw_2x1:
    MACRO_FULLDRAW 2, 1, 0, 0
FullDraw_3x1:
    MACRO_FULLDRAW 3, 1, 0, 0
FullDraw_4x1:
    MACRO_FULLDRAW 4, 1, 0, 0
FullDraw_1x2:
    MACRO_FULLDRAW 1, 2, 0, 0
FullDraw_2x2:
    MACRO_FULLDRAW 2, 2, 0, 0
FullDraw_3x2:
    MACRO_FULLDRAW 3, 2, 0, 0
FullDraw_4x2:
    MACRO_FULLDRAW 4, 2, 0, 0
FullDraw_1x3:
    MACRO_FULLDRAW 1, 3, 0, 0
FullDraw_2x3:
    MACRO_FULLDRAW 2, 3, 0, 0
FullDraw_3x3:
    MACRO_FULLDRAW 3, 3, 0, 0
FullDraw_4x3:
    MACRO_FULLDRAW 4, 3, 0, 0
FullDraw_1x4:
    MACRO_FULLDRAW 1, 4, 0, 0
FullDraw_2x4:
    MACRO_FULLDRAW 2, 4, 0, 0
FullDraw_3x4:
    MACRO_FULLDRAW 3, 4, 0, 0
FullDraw_4x4:
    MACRO_FULLDRAW 4, 4, 0, 0
FullDraw_2x1_hFlip:
    MACRO_FULLDRAW 2, 1, 1, 0
FullDraw_3x1_hFlip:
    MACRO_FULLDRAW 3, 1, 1, 0
FullDraw_4x1_hFlip:
    MACRO_FULLDRAW 4, 1, 1, 0
FullDraw_2x2_hFlip:
    MACRO_FULLDRAW 2, 2, 1, 0
FullDraw_3x2_hFlip:
    MACRO_FULLDRAW 3, 2, 1, 0
FullDraw_4x2_hFlip:
    MACRO_FULLDRAW 4, 2, 1, 0
FullDraw_2x3_hFlip:
    MACRO_FULLDRAW 2, 3, 1, 0
FullDraw_3x3_hFlip:
    MACRO_FULLDRAW 3, 3, 1, 0
FullDraw_4x3_hFlip:
    MACRO_FULLDRAW 4, 3, 1, 0
FullDraw_2x4_hFlip:
    MACRO_FULLDRAW 2, 4, 1, 0
FullDraw_3x4_hFlip:
    MACRO_FULLDRAW 3, 4, 1, 0
FullDraw_4x4_hFlip:
    MACRO_FULLDRAW 4, 4, 1, 0
FullDraw_1x2_vFlip:
    MACRO_FULLDRAW 1, 2, 0, 1
FullDraw_2x2_vFlip:
    MACRO_FULLDRAW 2, 2, 0, 1
FullDraw_3x2_vFlip:
    MACRO_FULLDRAW 3, 2, 0, 1
FullDraw_4x2_vFlip:
    MACRO_FULLDRAW 4, 2, 0, 1
FullDraw_1x3_vFlip:
    MACRO_FULLDRAW 1, 3, 0, 1
FullDraw_2x3_vFlip:
    MACRO_FULLDRAW 2, 3, 0, 1
FullDraw_3x3_vFlip:
    MACRO_FULLDRAW 3, 3, 0, 1
FullDraw_4x3_vFlip:
    MACRO_FULLDRAW 4, 3, 0, 1
FullDraw_1x4_vFlip:
    MACRO_FULLDRAW 1, 4, 0, 1
FullDraw_2x4_vFlip:
    MACRO_FULLDRAW 2, 4, 0, 1
FullDraw_3x4_vFlip:
    MACRO_FULLDRAW 3, 4, 0, 1
FullDraw_4x4_vFlip:
    MACRO_FULLDRAW 4, 4, 0, 1
FullDraw_2x1_hFlip_vFlip:
    MACRO_FULLDRAW 2, 1, 1, 1
FullDraw_3x1_hFlip_vFlip:
    MACRO_FULLDRAW 3, 1, 1, 1
FullDraw_4x1_hFlip_vFlip:
    MACRO_FULLDRAW 4, 1, 1, 1
FullDraw_1x2_hFlip_vFlip:
    MACRO_FULLDRAW 1, 2, 1, 1
FullDraw_2x2_hFlip_vFlip:
    MACRO_FULLDRAW 2, 2, 1, 1
FullDraw_3x2_hFlip_vFlip:
    MACRO_FULLDRAW 3, 2, 1, 1
FullDraw_4x2_hFlip_vFlip:
    MACRO_FULLDRAW 4, 2, 1, 1
FullDraw_1x3_hFlip_vFlip:
    MACRO_FULLDRAW 1, 3, 1, 1
FullDraw_2x3_hFlip_vFlip:
    MACRO_FULLDRAW 2, 3, 1, 1
FullDraw_3x3_hFlip_vFlip:
    MACRO_FULLDRAW 3, 3, 1, 1
FullDraw_4x3_hFlip_vFlip:
    MACRO_FULLDRAW 4, 3, 1, 1
FullDraw_1x4_hFlip_vFlip:
    MACRO_FULLDRAW 1, 4, 1, 1
FullDraw_2x4_hFlip_vFlip:
    MACRO_FULLDRAW 2, 4, 1, 1
FullDraw_3x4_hFlip_vFlip:
    MACRO_FULLDRAW 3, 4, 1, 1
FullDraw_4x4_hFlip_vFlip:
    MACRO_FULLDRAW 4, 4, 1, 1
