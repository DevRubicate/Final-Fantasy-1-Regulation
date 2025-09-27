.segment "PRG_054"

.include "src/global-import.inc"

.export EnterNewBattle

.import FillNametable, ClearSprites, MusicPlay, WaitForVBlank
.import UnpackImage, MASSIVE_CRAB_IMAGE

EnterNewBattle:

    FARCALL ClearSprites

    LDA #0
    STA Var0
    FARCALL FillNametable                ; clear the nametable

    LDA #0
    STA Var0
    LDA #<MASSIVE_CRAB_IMAGE
    STA Var1
    LDA #>MASSIVE_CRAB_IMAGE
    STA Var2
    LDA #TextBank(MASSIVE_CRAB_IMAGE)
    STA Var3
    FARCALL UnpackImage


@Loop:

    CALL WaitForVBlank
    FARCALL MusicPlay

JMP @Loop
