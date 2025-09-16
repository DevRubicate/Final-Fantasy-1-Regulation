.segment "PRG_054"

.include "src/global-import.inc"

.export EnterNewBattle

.import FillNametable, ClearSprites, MusicPlay, WaitForVBlank

EnterNewBattle:

    FARCALL ClearSprites

    LDA #0
    STA Var0
    FARCALL FillNametable                ; clear the nametable






@Loop:

    CALL WaitForVBlank
    FARCALL MusicPlay

JMP @Loop
