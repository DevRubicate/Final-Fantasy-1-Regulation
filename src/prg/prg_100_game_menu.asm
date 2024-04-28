.segment "PRG_100"

.include "src/global-import.inc"

.import Stringify, WhitespaceWriter, PlotBox, WriteClassNameByIndex, WriteHeroNameByIndex

.export DrawGameMenu, DrawGameMenuGoldBox

DrawGameMenu:

    BOX     11, 1, 10, 14
    LDA #0
    STA stringwriterSetHero
    LDA #12
    STA stringwriterDestX
    LDA #3
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    BOX     21, 1, 10, 14
    LDA #1
    STA stringwriterSetHero
    LDA #22
    STA stringwriterDestX
    LDA #3
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    BOX     11, 15, 10, 14
    LDA #2
    STA stringwriterSetHero
    LDA #12
    STA stringwriterDestX
    LDA #17
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    BOX     21, 15, 10, 14
    LDA #3
    STA stringwriterSetHero
    LDA #22
    STA stringwriterDestX
    LDA #17
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    CALL DrawGameMenuGoldBox

    RTS

DrawMainMenuHeroData:
    LDA #<TEMPLATE_HERO_MENU
    STA Var0
    LDA #>TEMPLATE_HERO_MENU
    STA Var1
    LDA #<TextBank(TEMPLATE_HERO_MENU)
    STA Var2
    FARCALL Stringify
    RTS


DrawGameMenuGoldBox:
    BOX     1, 10, 10, 5
    TEXT    MENU_GOLD, 2, 12
    RTS
