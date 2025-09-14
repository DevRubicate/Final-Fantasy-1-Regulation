.segment "PRG_100"

.include "src/global-import.inc"

.import Stringify, WhitespaceWriter, PlotBox, WriteClassNameByIndex, WriteHeroNameByIndex, MusicPlay
.import WaitForVBlank
.import TEXT_ITEM_DESCRIPTION, TEXT_DASH, TEXT_HERO_0_NAME, TEXT_INVENTORY, TEXT_EQUIP_OPTIMIZE_REMOVE, TEXT_TEMPLATE_HERO_MENU, TEXT_MENU_GOLD, TEXT_MENU_SELECTION, TEXT_TEMPLATE_HERO_EQUIP_STATUS, TEXT_EXAMPLE_ITEM_LIST, TEXT_EXAMPLE_EQUIP_LIST, TEXT_ITEM_NAME
.import DrawCursorSprite, DrawBlinkingCursorSprite, UpdateJoy, ClearSprites, SetTile, DrawRectangle

.import UploadCHRSolids, UploadBackgroundCHR1, UploadBackgroundCHR2, UploadBackgroundCHR3, UploadBackgroundCHR4, FillAttributeTable, FillNametable, UploadPalette0
.import LoadResources



.export DrawGameMenu, DrawGameMenuGoldBox, EnterItemsMenu, RestoreNineSliceBordersToDefault

DrawGameMenu:

    FARCALL LoadResources

    LDA #$0
    STA palette0+0
    LDA #$1
    STA palette0+1
    LDA #$30
    STA palette0+2
    FARCALL UploadPalette0

    LDA #0
    STA Var0
    FARCALL FillAttributeTable

    LDA #0
    STA Var0
    FARCALL FillNametable                ; clear the nametable

    CALL RestoreNineSliceBordersToDefault

    POS         11, 1
    NINESLICE   10, 14

    POS         21, 1
    NINESLICE   10, 14

    POS         11, 15
    NINESLICE   10, 14

    POS         21, 15
    NINESLICE   10, 14

    LDA #0
    STA stringwriterSetHero
    LDA #12
    STA drawX
    LDA #3
    STA drawY
    CALL DrawMainMenuHeroData

    LDA #1
    STA stringwriterSetHero
    LDA #22
    STA drawX
    LDA #3
    STA drawY
    CALL DrawMainMenuHeroData


    LDA #2
    STA stringwriterSetHero
    LDA #12
    STA drawX
    LDA #17
    STA drawY
    CALL DrawMainMenuHeroData


    LDA #3
    STA stringwriterSetHero
    LDA #22
    STA drawX
    LDA #17
    STA drawY
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
    POS         1, 11
    NINESLICE   10, 3
    POS         2, 12
    TEXT        TEXT_MENU_GOLD
    RTS

DrawGameMenuSelection:
    POS         2, 16
    NINESLICE   8, 13
    POS         3, 18
    TEXT    TEXT_MENU_SELECTION
    RTS

EnterItemsMenu:
    FARCALL ClearSprites

    LDA #$0
    STA palette0+0
    LDA #$1
    STA palette0+1
    LDA #$30
    STA palette0+2
    FARCALL UploadPalette0

    LDA #0
    STA Var0
    FARCALL FillAttributeTable
    
    LDA #0
    STA Var0
    FARCALL FillNametable                ; clear the nametable

    ; Todo: Make sure these PPU affecting subroutines respects the new rules
    ;CALL UploadNineSliceBorders
    CALL RestoreNineSliceBordersToDefault


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

    LDA #1
    STA hero0Inventory+0
    STA hero0Inventory+1
    LDA #2
    STA hero0Inventory+2

    LDA #0
    STA interactiveMenuActiveHero

    LDA #5
    STA hero0InventorySize

    POS         1, 0
    NINESLICE   31, 3

    LDA #$68
    STA drawVars+1
    LDA #$6A
    STA drawVars+2
    LDA #$66
    STA drawVars+3



    POS         1, 2
    NINESLICE   31, 9

    POS         1, 25
    NINESLICE   31, 5


    LDA #$68
    STA drawVars+7
    LDA #$6A
    STA drawVars+8
    LDA #$66
    STA drawVars+9

    POS         1, 10
    NINESLICE   16, 16



    LDA #$65
    STA drawVars+1

    LDA #$69
    STA drawVars+4

    LDA #$67
    STA drawVars+7

    POS         16, 10
    NINESLICE   16, 16

    POS     2, 1
    TEXT TEXT_EQUIP_OPTIMIZE_REMOVE

    POS     2, 3
    TEXT TEXT_TEMPLATE_HERO_EQUIP_STATUS

    POS     6, 11
    TEXT TEXT_HERO_0_NAME

    POS     19, 11
    TEXT TEXT_INVENTORY




    CALL DrawHeroInventory
    CALL DrawInventory



    CALL EnterEquipMenu



    RTS

EnterEquipMenu:
    LDA #0
    STA interactiveMenuCursor

    @Loop:
    CALL ActEquipMenu

    LDA interactiveMenuOutcome
    CMP #254
    BNE :++
        LDA interactiveMenuCursor
        CMP #2
        BEQ :+
            INC interactiveMenuCursor
        :
        JUMP @Loop
    :
    CMP #252
    BNE :++
        LDA interactiveMenuCursor
        BEQ :+
            DEC interactiveMenuCursor
        :
        JUMP @Loop
    :
    CMP #253
    BNE :+
        LDA #0
        STA interactiveMenuCursor
        JUMP EnterHeroInventory
    :
    CMP #251
    BNE :+++
        LDA interactiveMenuCursor
        BNE :+
            STA interactiveMenuCursor
            JUMP EnterHeroInventory
        :
        CMP #1
        BNE :+
            ; Optimize
        :
        JUMP @Loop
    :
    CMP #250
    BNE :+
        RTS
    :

    JUMP @Loop
ActEquipMenu:
    @Loop:
    FARCALL UpdateJoy

    ; Read the joypad
    LDA joypadState
    EOR joypadStateIgnore
    AND joypadState

    ; If the right button is pressed
    CMP #$1
    BNE :+
        LDA #254
        STA interactiveMenuOutcome
        RTS
    :

    ; If the down button is pressed
    CMP #$4
    BNE :+
        LDA #253
        STA interactiveMenuOutcome
        RTS
    :

    ; If the left button is pressed
    CMP #$2
    BNE :+
        LDA #252
        STA interactiveMenuOutcome
        RTS
    :

    ; If the A button is pressed
    CMP #$80
    BNE :+
        LDA #251
        STA interactiveMenuOutcome
        RTS
    :

    ; If the B button is pressed
    CMP #$40
    BNE :+
        LDA #250
        STA interactiveMenuOutcome
        RTS
    :

    @doneControls:


    ; y position
    LDA #1
    ASL A
    ASL A
    ASL A
    STA spr_y

    ; x position
    LDX interactiveMenuCursor
    LDA LUTEquipMenuXOffset,X
    ASL A
    ASL A
    ASL A
    STA spr_x

    FARCALL DrawCursorSprite

    @DoneDraw:

    FARCALL MusicPlay
    CALL WaitForVBlank
    JUMP @Loop



    RTS
LUTEquipMenuXOffset:
    .byte 2, 10, 21

EnterInventory:
    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    CALL DrawItemDescription

    LDA #10
    STA interactiveMenuLength

    @Loop:
    CALL DrawInventory
    CALL ActInventory
    LDA interactiveMenuOutcome

    CMP #255
    BNE :++
        LDA interactiveMenuListOffset
        BNE :+
            LDA interactiveMenuMode
            BNE @Loop
            JUMP EnterEquipMenu
        :
        DEC interactiveMenuListOffset
        JUMP @Loop
    :
    CMP #253
    BNE :++
        LDY interactiveMenuCursor
        LDA (Var20),Y
        BNE :+
            ; Undo
            DEC interactiveMenuCursor
            JUMP @Loop
        :
        INC interactiveMenuListOffset
        JUMP @Loop
    :
    CMP #252
    BNE :+
        LDA interactiveMenuCursor
        SEC
        SBC interactiveMenuListOffset
        STA interactiveMenuCursor
        JUMP EnterHeroInventory
    :
    CMP #251
    BNE :++
        LDA interactiveMenuMode
        BNE :+
            JUMP EnterEquipMenu
        :
        LDA #0
        STA interactiveMenuMode
        JUMP @Loop
    :





    LDA interactiveMenuMode
    BNE :+
        LDA interactiveMenuCursor
        STA interactiveMenuCursorSelected
        LDA #1
        STA interactiveMenuMode
        JUMP @Loop
    :
    CMP #1
    BNE :+
        ; Swap items in the inventory
        CALL SwapItemsInInventory
        LDA #0
        STA interactiveMenuMode
        JUMP @Loop
    :
    CALL SwapItemFromHeroToInventory
    CALL DrawHeroInventory
    LDA #0
    STA interactiveMenuMode
    JUMP @Loop
ActInventory:
    LDA #0
    STA interactiveMenuOutcome

    @Loop:
    FARCALL UpdateJoy

    ; Read the joypad
    LDA joypadState
    EOR joypadStateIgnore
    AND joypadState

    ; If the up button is pressed
    CMP #$8
    BNE :+
        LDA interactiveMenuCursor
        SEC
        SBC interactiveMenuListOffset
        BEQ @ExitInteractiveMenuUpwards
        DEC interactiveMenuCursor
        CALL DrawItemDescription
        JUMP @doneControls
        @ExitInteractiveMenuUpwards:
        LDA #255
        STA interactiveMenuOutcome
        RTS
    :

    ; If the down button is pressed
    CMP #$4
    BNE :+
        LDA interactiveMenuCursor
        SEC
        SBC interactiveMenuListOffset
        CMP #12
        BEQ @ExitInteractiveMenuDownwards
        LDA interactiveMenuCursor
        CLC
        ADC #1
        STA interactiveMenuCursor
        CALL DrawItemDescription
        JUMP @doneControls
        @ExitInteractiveMenuDownwards:
        LDA interactiveMenuCursor
        CLC
        ADC #1
        STA interactiveMenuCursor
        LDA #253
        STA interactiveMenuOutcome
        RTS
    :

    ; If the B button is pressed
    CMP #$40
    BNE :+
        LDA #251
        STA interactiveMenuOutcome
        RTS
    :

    ; If the A button is pressed
    CMP #$80
    BNE :+
        LDA interactiveMenuCursor
        STA interactiveMenuOutcome
        RTS
    :

    ; If the left button is pressed
    CMP #$2
    BNE :+
        LDA #252
        STA interactiveMenuOutcome
        RTS
    :


    @doneControls:

    ; None of the button presses took us out of the equipment menu, so that means we are still in
    ; it, and should draw the cursor to indicate our position

    ; Check our current interaction mode
    LDA interactiveMenuMode
    BEQ @noBlinkingCursor
    CMP #1
    BEQ :+
        CALL DrawBlinkingCursorHeroInventory
        JUMP @noBlinkingCursor
    :

    CALL DrawBlinkingCursorInventory

    ; If the normal cursor is in the same position as the blinking cursor, then we skip drawing
    ; the normal cursor
    LDA interactiveMenuCursor
    CMP interactiveMenuCursorSelected
    BEQ @DoneDraw

    @noBlinkingCursor:

    ; y position
    LDA #12
    CLC
    ADC interactiveMenuCursor
    SEC
    SBC interactiveMenuListOffset
    ASL A
    ASL A
    ASL A
    STA spr_y

    ; x position
    LDA #15
    ASL A
    ASL A
    ASL A
    STA spr_x

    FARCALL DrawCursorSprite

    @DoneDraw:

    ; TODO: Hack to make sure rendering of sprites works
    LDA #$EF
    STA spr_y
    LDA #$EF
    STA spr_x
    FARCALL DrawCursorSprite

    FARCALL MusicPlay
    CALL WaitForVBlank
    JUMP @Loop

    RTS
DrawInventory:
    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    LDA #0
    STA interactiveMenuLoop

    ; Register Y will hold our item scrolling offset so that we draw the correct item name
    ; appropriate the amount of items we have scrolled past in the list
    LDY interactiveMenuListOffset

    ; This loop will draw each item in the list, one by one
    @Loop:

    ; If this item slot is empty then stop the loop
    LDA (Var20),Y
    BEQ @RTS
    STA stringifyActiveItem

    ; Set the position of this item
    LDA #17
    STA drawX
    LDA #12
    CLC
    ADC interactiveMenuLoop
    STA drawY

    ; Set the hardcoded whitespace width of this item name to be 14, that way it will always completely
    ; overwrite the item text that used to be here
    LDA #14
    STA stringwriterWhitespaceWidth

    ; Set the generic "print item name" string to be our active one
    LDA #<TEXT_ITEM_NAME
    STA Var0
    LDA #>TEXT_ITEM_NAME
    STA Var1
    LDA #( .bank(TEXT_ITEM_NAME) | %10000000)
    STA Var2

    ; Write the string
    FARCALL Stringify

    ; Compare our loop iteration with the max entries we want to show, and end the loop if we are there
    LDA interactiveMenuLoop
    CMP #12
    BEQ @RTS

    ; Otherwise, add 1 to our loop iteration
    CLC
    ADC #1
    STA interactiveMenuLoop

    ; We also want to make sure our Y register is updated to the next item in the list for the next
    ; iteration
    CLC
    ADC interactiveMenuListOffset
    TAY

    ; Loop to the next iteration
    JUMP @Loop

    @RTS:
    RTS

EnterHeroInventory:
    LDA #<hero0Inventory
    STA Var20
    LDA #>hero0Inventory
    STA Var21

    LDA #10
    STA interactiveMenuLength
    CMP interactiveMenuCursor
    BCS :+
    STA interactiveMenuCursor
    :

    @LoopCursorRewind:
    LDY interactiveMenuCursor
    BEQ :+
    LDA (Var20),Y
    BNE :+
    DEC interactiveMenuCursor
    BNE @LoopCursorRewind
    :

    @Loop:
    CALL DrawHeroInventory
    CALL ActHeroInventory

    LDA interactiveMenuOutcome
    CMP #255
    BNE :+
        LDA interactiveMenuMode
        BNE @Loop
        JUMP EnterEquipMenu
    :
    CMP #253
    BNE :+
        JUMP @Loop
    :
    CMP #254
    BNE :+
        LDA interactiveMenuCursor
        CLC
        ADC interactiveMenuListOffset
        STA interactiveMenuCursor
        JUMP EnterInventory
    :
    CMP #251 ; B button
    BNE :+++
        LDA interactiveMenuMode
        BNE :++
            LDY interactiveMenuCursor

            LDA #<hero0Inventory
            STA Var22
            LDA #>hero0Inventory
            STA Var23
            LDA (Var22),Y
            BEQ :++

            LDA #<hero0InventoryStatus
            STA Var22
            LDA #>hero0InventoryStatus
            STA Var23
            LDA (Var22),Y
            AND #%00000001 ; equip bit
            BEQ :+
                EOR #%00000001
                STA (Var22),Y
                JUMP @Loop
            :
            CALL DumpItemFromHeroToInventory
            JUMP @Loop
        :
        LDA #0
        STA interactiveMenuMode
        JUMP @Loop
    :
    CMP #252 ; A button
    BNE :++
        LDA interactiveMenuMode
        BNE :+
            LDY interactiveMenuCursor

            LDA #<hero0Inventory
            STA Var22
            LDA #>hero0Inventory
            STA Var23

            LDA (Var22),Y
            BEQ :++

            LDA #<hero0InventoryStatus
            STA Var22
            LDA #>hero0InventoryStatus
            STA Var23


            LDA (Var22),Y
            EOR #%00000001
            STA (Var22),Y

            JUMP @Loop
        :
        CALL SwapItemFromInventoryToHero
        CALL DrawInventory
        LDA #0
        STA interactiveMenuMode
    :
    JUMP @Loop

ActHeroInventory:
    LDA #0
    STA interactiveMenuOutcome

    @Loop:
    FARCALL UpdateJoy

    ; Read the joypad
    LDA joypadState
    EOR joypadStateIgnore
    AND joypadState

    ; If the down button is pressed
    CMP #$4
    BNE :+++
        LDY interactiveMenuCursor
        INY
        LDA (Var20),Y
        BEQ :+
            INC interactiveMenuCursor
            JUMP @doneControls
        :
        LDA interactiveMenuMode
        CMP #1
        BNE :+
            LDA interactiveMenuCursor
            CMP hero0InventorySize
            BCS :+

            DEY
            LDA (Var20),Y
            BEQ :+
            INC interactiveMenuCursor
            JUMP @doneControls
        :
        LDA #253
        STA interactiveMenuOutcome
        RTS
    :

    ; If the up button is pressed
    CMP #$8
    BNE :+
        LDA interactiveMenuCursor
        BEQ @ExitInteractiveMenuUpwards
        DEC interactiveMenuCursor
        JUMP @doneControls
        @ExitInteractiveMenuUpwards:
        LDA #255
        STA interactiveMenuOutcome
        RTS
    :

    ; If the right button is pressed
    CMP #$1
    BNE :+
        LDA #254
        STA interactiveMenuOutcome
        RTS
    :

    ; If the A button is pressed
    CMP #$80
    BNE :+
        LDA #252
        STA interactiveMenuOutcome
        RTS
    :

    ; If the B button is pressed
    CMP #$40
    BNE :+
        LDA #251
        STA interactiveMenuOutcome
        RTS
    :



    @doneControls:

    ; None of the button presses took us out of the equipment menu, so that means we are still in
    ; it, and should draw the cursor to indicate our position

    ; Check our current interaction mode
    LDA interactiveMenuMode
    BEQ @noBlinkingCursor
    CMP #1
    BNE :+
        CALL DrawBlinkingCursorInventory
        JUMP @noBlinkingCursor
    :
    CMP #2
        CALL DrawBlinkingCursorHeroInventory

        ; If the normal cursor is in the same position as the blinking cursor, then we skip drawing
        ; the normal cursor
        LDA interactiveMenuCursor
        CMP interactiveMenuCursorSelected
        BEQ @DoneDraw

    @noBlinkingCursor:

    ; y position
    LDA #12
    CLC
    ADC interactiveMenuCursor
    ASL A
    ASL A
    ASL A
    STA spr_y

    ; x position
    LDA #0
    ASL A
    ASL A
    ASL A
    STA spr_x

    FARCALL DrawCursorSprite

    @DoneDraw:

    ; TODO: Hack to make sure rendering of sprites works
    LDA #$EF
    STA spr_y
    LDA #$EF
    STA spr_x
    FARCALL DrawCursorSprite

    FARCALL MusicPlay
    CALL WaitForVBlank
    JUMP @Loop

    RTS
DrawHeroInventory:


    ; Set the position of this item
    LDA #1
    STA drawValue
    LDA #2
    STA drawX
    LDA #12
    STA drawY
    LDA #(1)
    STA drawWidth
    LDA #(6)    ; TODO: height of hero inventory
    STA drawHeight
    FARCALL DrawRectangle

    LDA #<hero0Inventory
    STA Var20
    LDA #>hero0Inventory
    STA Var21

    LDA #<hero0InventoryStatus
    STA Var22
    LDA #>hero0InventoryStatus
    STA Var23

    LDA #0
    STA interactiveMenuLoop

    ; This loop will draw each item in the list, one by one
    LDY #0
    @loop:

    ; If this item slot is empty then move onto writing dashes instead
    LDA (Var20),Y
    BEQ @emptySlots
    STA stringifyActiveItem

    ; Set the position of this item
    LDX #2
    STX drawX

    LDA #12
    CLC
    ADC interactiveMenuLoop
    STA drawY

    ; Load this item's status byte
    LDX #1
    LDA (Var22),Y
    AND #%00000001  ; Look at the equip bit
    BEQ :+ ; Skip drawing the E if the item is not equipped
        LDX #18
    :
    TXA
    FARCALL SetTile
    
    ; Set the position of this item
    LDX #3
    STX drawX

    ; Set the hardcoded whitespace width of this item name to be 13, that way it will always completely
    ; overwrite the item text that used to be here
    LDA #13
    STA stringwriterWhitespaceWidth

    ; Set the generic "print item name" string to be our active one
    LDA #<TEXT_ITEM_NAME
    STA Var0
    LDA #>TEXT_ITEM_NAME
    STA Var1
    LDA #( .bank(TEXT_ITEM_NAME) | %10000000)
    STA Var2

    ; Write the string
    FARCALL Stringify

    ; Compare our loop iteration with the max entries we want to show, and end the loop if we are there
    LDA interactiveMenuLoop
    CMP hero0InventorySize
    BEQ @RTS

    ; Otherwise, add 1 to our loop iteration
    CLC
    ADC #1
    STA interactiveMenuLoop

    ; We also want to make sure our Y register is updated to the next item in the list for the next
    ; iteration
    TAY

    ; Loop to the next iteration
    JUMP @loop

    @emptySlots:

    ; Set the position of this item
    LDA #3
    STA drawX
    LDA #12
    CLC
    ADC interactiveMenuLoop
    STA drawY

    ; Set the hardcoded whitespace width of this item name to be 14, that way it will always completely
    ; overwrite the item text that used to be here
    LDA #13
    STA stringwriterWhitespaceWidth

    ; Set the generic "dash" string to be our active one
    LDA #<TEXT_DASH
    STA Var0
    LDA #>TEXT_DASH
    STA Var1
    LDA #( .bank(TEXT_DASH) | %10000000)
    STA Var2

    ; Write the string
    FARCALL Stringify

    ; Compare our loop iteration with the max entries we want to show, and end the loop if we are there
    LDA interactiveMenuLoop
    CMP hero0InventorySize
    BEQ @RTS

    ; Otherwise, add 1 to our loop iteration
    CLC
    ADC #1
    STA interactiveMenuLoop

    JUMP @emptySlots




    @RTS:
    RTS

DrawBlinkingCursorInventory:
    ; Our current interaction mode is "selected", that means one item is selected and we need
    ; to draw a blinking cursor to indicate this

    ; y position
    LDA #12
    CLC
    ADC interactiveMenuCursorSelected
    SEC
    ; Check if the blinking cursor has been scrolled outside of the visible part of the list,
    ; and if so don't draw it.
    SBC interactiveMenuListOffset
    CMP #11
    BCC @RTS
    CMP #25
    BCS @RTS
    ASL A
    ASL A
    ASL A
    STA spr_y

    ; x position
    LDA #15
    ASL A
    ASL A
    ASL A
    STA spr_x

    ; Draw the blinking cursor
    FARCALL DrawBlinkingCursorSprite

    @RTS:
    RTS
DrawBlinkingCursorHeroInventory:
    ; Our current interaction mode is "selected", that means one item is selected and we need
    ; to draw a blinking cursor to indicate this

    ; y position
    LDA #12
    CLC
    ADC interactiveMenuCursorSelected
    ; Check if the blinking cursor has been scrolled outside of the visible part of the list,
    ; and if so don't draw it.
    CMP #11
    BCC @RTS
    CMP #25
    BCS @RTS
    ASL A
    ASL A
    ASL A
    STA spr_y

    ; x position
    LDA #0
    ASL A
    ASL A
    ASL A
    STA spr_x

    ; Draw the blinking cursor
    FARCALL DrawBlinkingCursorSprite

    @RTS:
    RTS

SwapItemsInInventory:
    LDY interactiveMenuCursor
    LDA (Var20),Y
    PHA

    LDY interactiveMenuCursorSelected
    LDA (Var20),Y

    LDY interactiveMenuCursor
    STA (Var20),Y

    LDY interactiveMenuCursorSelected
    PLA
    STA (Var20),Y
    RTS
SwapItemsInHero:
    RTS
SwapItemFromInventoryToHero:
    ; Currently the hero is loaded in Var20+Var21

    ; Load the item in the hero
    LDY interactiveMenuCursor
    LDA (Var20),Y
    PHA

    ; Switch to the inventory
    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    ; Load the item in the inventory
    LDY interactiveMenuCursorSelected
    LDA (Var20),Y
    TAX

    ; Save the hero item into the inventory
    PLA
    STA (Var20),Y
    ; If an empty item was saved into the inventory from the hero, then we will have to fill that gap
    ; by moving all items one slot up, from the point the item was inserted.
    BNE :+++
        ; Fill the hole
        TYA
        PHA
        INY
        :
            LDA (Var20),Y
            BEQ :+
            DEY
            STA (Var20),Y
            INY
            INY
            JUMP :-
        :
        DEY
        STA (Var20),Y
        PLA
        TAY

        ; If we are scrolled to the very bottom when the last hole is filled, we scroll up one step to
        ; avoid leaving a gap.
        SEC
        SBC #12
        CMP interactiveMenuListOffset
        BNE :+
        DEC interactiveMenuListOffset
    :

    ; Switch to the hero
    LDA #<hero0Inventory
    STA Var20
    LDA #>hero0Inventory
    STA Var21

    ; Save the inventory item into the hero
    TXA
    LDY interactiveMenuCursor
    STA (Var20),Y

    ; Make sure it's not equipped
    LDA #<hero0InventoryStatus
    STA Var20
    LDA #>hero0InventoryStatus
    STA Var21
    LDA #0
    STA (Var20),Y

    RTS
SwapItemFromHeroToInventory:
    ; Currently the inventory is loaded in Var20+Var21

    ; Load the item in the inventory
    LDY interactiveMenuCursor
    LDA (Var20),Y
    PHA

    ; Switch to the hero
    LDA #<hero0Inventory
    STA Var20
    LDA #>hero0Inventory
    STA Var21

    ; Load the item in the hero
    LDY interactiveMenuCursorSelected
    LDA (Var20),Y
    TAX

    ; Save the inventory item into the hero
    PLA
    STA (Var20),Y

    ; Switch to the inventory
    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    ; Save the hero item into the inventory
    TXA
    LDY interactiveMenuCursor
    STA (Var20),Y

    RTS
DumpItemFromHeroToInventory:
    ; Currently the hero is loaded in Var20+Var21

    ; Load the item in the hero
    LDY interactiveMenuCursor
    LDA (Var20),Y
    PHA

    ; Remove the item from the hero
    LDA #0
    STA (Var20),Y

    ; Switch to the inventory
    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    ; Loop until we find an empty spot
    LDY #$FF
    :
    INY
    LDA (Var20),Y
    BNE :-
    DEY

    ; Now loop backwards while moving all items one slot down
    :
    LDA (Var20),Y
    INY
    STA (Var20),Y
    DEY
    BEQ :+
    DEY
    JUMP :-
    :



    ; Save the hero item into the inventory slot 0
    PLA
    STA (Var20),Y


    ; Switch to the hero
    LDA #<hero0Inventory
    STA Var20
    LDA #>hero0Inventory
    STA Var21

    ; Set the hero equip flags in Var22+Var23
    LDA #<hero0InventoryStatus
    STA Var22
    LDA #>hero0InventoryStatus
    STA Var23

    LDY interactiveMenuCursor
    INY

    ; Fill the hole that was created
    :
        LDA (Var22),Y
        TAX
        LDA (Var20),Y
        BEQ :+
        DEY
        STA (Var20),Y
        TXA
        STA (Var22),Y
        INY
        INY
        JUMP :-
    :
    DEY
    STA (Var22),Y
    STA (Var20),Y





    CALL DrawInventory

    RTS

DrawItemDescription:
    LDA #1
    STA drawValue
    LDA #2
    STA drawX
    LDA #26
    STA drawY
    LDA #(29)
    STA drawWidth
    LDA #(3)
    STA drawHeight
    FARCALL DrawRectangle

    LDA #<inventory
    STA Var20
    LDA #>inventory
    STA Var21

    LDY interactiveMenuCursor
    LDA (Var20),Y
    BEQ @RTS
    STA stringifyActiveItem

    ; Set the position of this item
    LDA #2
    STA drawX
    LDA #26
    STA drawY

    ; Set the generic "print item name" string to be our active one
    LDA #<TEXT_ITEM_DESCRIPTION
    STA Var0
    LDA #>TEXT_ITEM_DESCRIPTION
    STA Var1
    LDA #( .bank(TEXT_ITEM_DESCRIPTION) | %10000000)
    STA Var2

    ; Write the string
    FARCALL Stringify
    @RTS:
    RTS


RestoreNineSliceBordersToDefault:
    LDA #$60
    STA drawVars+1
    LDA #$61
    STA drawVars+2
    LDA #$5D
    STA drawVars+3
    LDA #$64
    STA drawVars+4
    LDA #$01
    STA drawVars+5
    LDA #$62
    STA drawVars+6
    LDA #$5F
    STA drawVars+7
    LDA #$63
    STA drawVars+8
    LDA #$5E
    STA drawVars+9
    RTS
