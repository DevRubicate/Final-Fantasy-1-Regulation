.segment "PRG_100"

.include "src/global-import.inc"

.import Stringify, WhitespaceWriter, PlotBox, WriteClassNameByIndex, WriteHeroNameByIndex, MusicPlay
.import WaitForVBlank, ClearOAM

.import TEXT_EQUIP_OPTIMIZE_REMOVE_ALL, TEXT_TEMPLATE_HERO_MENU, TEXT_MENU_GOLD, TEXT_MENU_SELECTION, TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_EXAMPLE_ITEM_LIST, TEXT_EXAMPLE_EQUIP_LIST, TEXT_ITEM_NAME

.import Stringify, DrawCursor, UpdateJoy

.export DrawGameMenu, DrawGameMenuGoldBox, EnterItemsMenu

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
    CALL DrawGameMenuSelection



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

DrawGameMenuSelection:
    POS     2, 16
    BOX     8, 13
    POS     3, 18
    TEXT    TEXT_MENU_SELECTION
    RTS

EnterItemsMenu:


    LDA #1
    STA inventory+0
    LDA #6
    STA inventory+1
    STA inventory+2
    STA inventory+3
    STA inventory+4
    LDA #2
    STA inventory+5
    STA inventory+6
    STA inventory+7
    STA inventory+8
    STA inventory+9
    STA inventory+10
    LDA #3
    STA inventory+11
    STA inventory+12
    STA inventory+13
    STA inventory+14
    STA inventory+15
    STA inventory+16
    LDA #4
    STA inventory+17
    STA inventory+18
    STA inventory+19
    STA inventory+20
    STA inventory+21
    STA inventory+22
    LDA #5
    STA inventory+23
    STA inventory+24
    STA inventory+25
    STA inventory+26
    STA inventory+27
    STA inventory+28


    POS     0, 0
    BOX     32, 3

    POS     0, 3
    BOX     32, 11

    POS     0, 14
    BOX     17, 16




    POS     1, 1
    TEXT TEXT_EQUIP_OPTIMIZE_REMOVE_ALL

    POS     1, 4
    TEXT TEXT_TEMPLATE_HERO_EQUIP_STATUS



    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    LDA #0
    STA interactiveMenuCursor


    @Menu:


    POS     17, 14
    BOX     15, 16

    LDA #18
    STA interactiveMenuXCoordinate
    LDA #15
    STA interactiveMenuYCoordinate
    LDA #13
    STA interactiveMenuSize
    CALL InteractiveMenuDraw

    LDA #10
    STA interactiveMenuLength



    CALL InteractiveMenuAct
    LDA interactiveMenuOutcome
    CMP #255
    BNE :++
        INC Var20
        BNE :+
            INC Var21
        :
        JUMP @Menu
    :
    CMP #253
    BNE :+
        LDA Var20
        CMP #<inventory
        BEQ @atTop
        SEC
        SBC #1
        STA Var20
        LDA Var21
        SBC #0
        STA Var21
        @atTop:
        JUMP @Menu
    :



    JUMP @Menu
    @Done:
    RTS



InteractiveMenuDraw:
    LDY #0
    STY interactiveMenuLoop
    @Loop:
    LDA interactiveMenuXCoordinate
    STA stringwriterDestX
    TYA
    CLC
    ADC interactiveMenuYCoordinate
    STA stringwriterDestY

    LDA (Var20),Y
    BEQ @RTS
    STA activeItem

    LDA #<TEXT_ITEM_NAME
    STA Var0
    LDA #>TEXT_ITEM_NAME
    STA Var1
    LDA #( .bank(TEXT_ITEM_NAME) | %10000000)
    STA Var2
    FARCALL Stringify
    LDA interactiveMenuLoop
    CMP interactiveMenuSize
    BEQ @RTS
    CLC
    ADC #1
    STA interactiveMenuLoop
    TAY
    JUMP @Loop
    @RTS:
    RTS


InteractiveMenuAct:

    LDA #0
    STA interactiveMenuOutcome

    @Loop:
    FARCALL UpdateJoy

    LDA joypadState
    EOR joypadStateIgnore
    AND joypadState
    CMP #4
    BNE :+
        LDA interactiveMenuCursor
        CMP interactiveMenuSize
        BEQ @ExitInteractiveMenuDownwards
        CLC
        ADC #1
        STA interactiveMenuCursor
        JUMP @doneCursorMove
        @ExitInteractiveMenuDownwards:
        LDA #255
        STA interactiveMenuOutcome
        RTS
    :
    CMP #8
    BNE :+
        LDA interactiveMenuCursor
        BEQ @ExitInteractiveMenuUpwards
        SEC
        SBC #1
        STA interactiveMenuCursor
        JUMP @doneCursorMove
        @ExitInteractiveMenuUpwards:
        LDA #253
        STA interactiveMenuOutcome
        RTS
    :


    @doneCursorMove:







    LDA interactiveMenuXCoordinate
    SEC
    SBC #2
    ASL A
    ASL A
    ASL A
    STA spr_x
    LDA interactiveMenuYCoordinate
    CLC
    ADC interactiveMenuCursor
    ASL A
    ASL A
    ASL A
    STA spr_y
    FARCALL DrawCursor



    LDA #>oam
    STA OAMDMA                   ; Do OAM DMA


    FARCALL MusicPlay
    CALL WaitForVBlank
    JUMP @Loop
    

    RTS

