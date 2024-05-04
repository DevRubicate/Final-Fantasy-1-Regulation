.segment "PRG_100"

.include "src/global-import.inc"

.import Stringify, WhitespaceWriter, PlotBox, WriteClassNameByIndex, WriteHeroNameByIndex

.import TEXT_TEMPLATE_HERO_MENU, TEXT_MENU_GOLD

.export DrawGameMenu, DrawGameMenuGoldBox

DrawGameMenu:

    POS     11, 1
    BOX     10, 14
    LDA #0
    STA stringwriterSetHero
    LDA #12
    STA stringwriterDestX
    LDA #3
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    POS     21, 1
    BOX     10, 14
    LDA #1
    STA stringwriterSetHero
    LDA #22
    STA stringwriterDestX
    LDA #3
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    POS     11, 15
    BOX     10, 14
    LDA #2
    STA stringwriterSetHero
    LDA #12
    STA stringwriterDestX
    LDA #17
    STA stringwriterDestY
    CALL DrawMainMenuHeroData

    POS     21, 15
    BOX     10, 14
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
    LDA #<TEXT_TEMPLATE_HERO_MENU
    STA Var0
    LDA #>TEXT_TEMPLATE_HERO_MENU
    STA Var1
    LDA #<TextBank(TEXT_TEMPLATE_HERO_MENU)
    STA Var2
    FARCALL Stringify
    RTS

DrawGameMenuGoldBox:
    POS     1, 10
    BOX     10, 5
    POS     2, 12
    TEXT    TEXT_MENU_GOLD
    RTS
