.segment "PRG_090"

.include "src/global-import.inc"
.include "src/lib/yxa2dec.asm"

.import WaitForVBlank, MenuCondStall, MusicPlay
.import VideoUpdate_Inc1_Address, VideoUpdate_Address, VideoUpdate_Inc32_Address, VideoUpdate_Inc1_Address_Set, VideoUpdate_Address_Set, VideoUpdate_Inc32_Address_Set, VideoUpdate_Inc1_Address_Set_Write, VideoUpdate_Address_Set_Write, VideoUpdate_Inc32_Address_Set_Write, VideoUpdate_Inc1_Write_Set, VideoUpdate_Write_Set, VideoUpdate_Inc32_Write_Set, VideoUpdate_Inc1_Set, VideoUpdate_Set, VideoUpdate_Inc32_Set
.import VideoUpdateWriteStackBytes, VideoUpdateRepeatValue, VideoUpdateRepeatValueSetValueWriteValue
.import VideoUpdate_Address_WriteAttribute, VideoUpdate_WriteAttributeRepeat, VideoUpdate_MassWrite, VideoUpdate_SetFillColor, VideoUpdate_UploadPalette0, VideoUpdate_UploadPalette1, VideoUpdate_UploadPalette2, VideoUpdate_UploadPalette3, VideoUpdate_UploadPalette4, VideoUpdate_UploadPalette5, VideoUpdate_UploadPalette6, VideoUpdate_UploadPalette7


.import TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_THIEF, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_MAGE, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_CLASS_NAME_BLACK_MAGE
.import LUT_ITEM_NAME, LUT_ITEM_NAME_SIBLING2
.import LUT_ITEM_PRICE, LUT_ITEM_PRICE_SIBLING2, LUT_ITEM_PRICE_SIBLING3
.import LUT_ITEM_DATA_FIRST, LUT_ITEM_DATA_FIRST_SIBLING2, LUT_ITEM_DATA_FIRST_SIBLING3
.import LUT_ITEM_DESCRIPTION, LUT_ITEM_DESCRIPTION_SIBLING2

.export DrawNineSlice, Stringify, SetTile, DrawRectangle
.export UploadFillColor, UploadPalette0, UploadPalette1, UploadPalette2, UploadPalette3, UploadPalette4, UploadPalette5, UploadPalette6, UploadPalette7


VideoUpdateApplySize:
    TAX
    CLC
    ADC VideoUpdateStackTally
    STA VideoUpdateStackTally
    BCC :+
        LDX VideoUpdateCursor
        LDA #$80
        STA VideoUpdateStack+0,X
        STA VideoUpdateStack+1,X
        CALL WaitForVBlank
    :
    RTS

VideoUpdateApplyCost:
    CLC
    ADC VideoUpdateCost
    STA VideoUpdateCost
    BCC :+
        INC VideoUpdateCost+1
        BNE :+
        LDX VideoUpdateCursor
        LDA #$80
        STA VideoUpdateStack+0,X
        STA VideoUpdateStack+1,X
        CALL WaitForVBlank
    :
    RTS


Stringify:
    LDA #0
    STA stringwriterLineWidth

    LDA drawX
    STA stringwriterNewlineOrigin

    CALL VideoUpdatePushAddress

    LDY #0
    STY stringifyCursor
    @Loop:

        ; Fetch one character and return it in register A. In a plain string this means simply grabbing
        ; one character and advancing the character pointer by one. However there might be control
        ; characters that change the behavior, such as SUBSTRING and DIGIT. In those cases the control
        ; character will move our character pointer to a new location, but make sure that the old location
        ; is saved on the stringify stack.
        CALL FetchCharacter
        ORA #0
        BMI @Void
        BEQ @Terminate
        CMP #127
        BEQ @Newline
        ; Add CHR offset so this becomes a valid character
        CLC
        ADC #$60
        CALL VideoUpdatePushData        ; Push this byte
        LDA drawX           ; Increment the dest address by 1
        CLC
        ADC #1
        AND #$3F                        ; Mask it with $3F so it wraps around both NTs appropriately
        STA drawX
        JUMP @Loop

        @Newline:
        CALL PadWhitespace
        CALL VideoUpdateSetWriteStackBytes
        LDA stringwriterNewlineOrigin
        STA drawX
        INC drawY
        STY stringifyCursor

        CALL VideoUpdatePushAddress

        LDY stringifyCursor
        JUMP @Loop

        @Void:
        JUMP @Loop

        @Terminate:
        CALL PadWhitespace
        CALL VideoUpdateSetWriteStackBytes

        LDA #0
        STA stringwriterWhitespaceWidth
        RTS

SaveStringifyStack:
    LDX stringwriterStackIndex
    INC stringwriterStackIndex
    TYA
    STA stringwriterStackCursor, X
    LDA Var0
    STA stringwriterStackLo, X
    LDA Var1
    STA stringwriterStackHi, X
    LDA Var2
    STA stringwriterStackBank, X
    RTS

PadWhitespace:
    LDA stringwriterWhitespaceWidth
    SEC
    SBC stringwriterLineWidth
    BMI @done
    BEQ @done
    TAY

    @loop:
    LDA #$C1
    CALL VideoUpdatePushData
    DEY
    BNE @loop


    @done:
    ; Since we starting a newline we reset the established width of the line
    LDA #0
    STA stringwriterLineWidth

    RTS

FetchCharacter:
    LDA Var2                        ; Load the bank this string is located in
    STA MMC5_PRG_BANK2              ; Switch to the bank

    LDA (Var0),Y
    BEQ @Terminator
    BMI @Control                    ; If the char is negative it means it's a control char

    ; This is a regular plain char, so all we do is advance our char pointer, and then return the char
    ; as-is.
    CALL IncrementStringifyAdvance
    LDX #0
    RTS

    @Control:
    ; We found a control char, which means that something special should happen. We keep a jump
    ; table to all the control routines and use that to effectively jump to the right one. However, we
    ; use a trick here that makes the code a little hard to follow.

    ; The trick is to deal with that the control chars are from byte value 128 to 255, while the jump
    ; table index is from 0 to 127. Rather than subtracting 128 from the control char to get them to
    ; align up, we refer to the jump table with an address that's off by 128, thus aligning them that
    ; way without the additional runtime cost.
    TAX
    LDA FetchCharacterJumpTableHi - 128, X
    PHA
    LDA FetchCharacterJumpTableLo - 128, X
    PHA
    @RTS:
    RTS ; TODO: Stop using reverse RTS

    @Terminator:
    ; We found a terminator char, which means this string has ended. However, if this string was merely
    ; a substring of another string, then the terminator char means that we should return to the
    ; original string and continue there.
    LDA stringwriterStackIndex          ; Load how deep we are in the substring stack
    BEQ @RTS                            ; If we are at the top, then just exit with A = 0

    ; This was indeed a substring, so instead of returning the terminator char we will jump back to the
    ; parent string, and then fetch a new character from there instead.
    TAX
    DEX
    LDY stringwriterStackCursor, X      ; Load the Y register
    STY stringifyCursor
    LDA stringwriterStackLo, X          ; Load lo address
    STA Var0
    LDA stringwriterStackHi, X          ; Load hi address
    STA Var1
    LDA stringwriterStackBank, X        ; Load bank
    STA Var2
    DEC stringwriterStackIndex          ; Decrement the substring stack
    JUMP FetchCharacter                 ; Fetch a character from the parent string instead

FetchCharacterJumpTableHi:
    .hibytes FetchCharacterSubstring - 1
    .hibytes FetchCharacterDigit1 - 1
    .hibytes FetchCharacterDigit2L - 1
    .hibytes FetchCharacterDigit2R - 1
    .hibytes FetchCharacterDigit3L - 1
    .hibytes FetchCharacterDigit3R - 1
    .hibytes FetchCharacterDigit4L - 1
    .hibytes FetchCharacterDigit4R - 1
    .hibytes FetchCharacterDigit5L - 1
    .hibytes FetchCharacterDigit5R - 1
    .hibytes FetchCharacterDigit6L - 1
    .hibytes FetchCharacterDigit6R - 1
    .hibytes FetchCharacterDigit7L - 1
    .hibytes FetchCharacterDigit7R - 1
    .hibytes FetchCharacterDigit8L - 1
    .hibytes FetchCharacterDigit8R - 1
    .hibytes FetchCharacterSetHero - 1
    .hibytes FetchCharacterHeroName - 1
    .hibytes FetchCharacterHeroClass - 1
    .hibytes FetchCharacterItemName - 1
    .hibytes FetchCharacterItemDescription - 1
FetchCharacterJumpTableLo:
    .lobytes FetchCharacterSubstring - 1
    .lobytes FetchCharacterDigit1 - 1
    .lobytes FetchCharacterDigit2L - 1
    .lobytes FetchCharacterDigit2R - 1
    .lobytes FetchCharacterDigit3L - 1
    .lobytes FetchCharacterDigit3R - 1
    .lobytes FetchCharacterDigit4L - 1
    .lobytes FetchCharacterDigit4R - 1
    .lobytes FetchCharacterDigit5L - 1
    .lobytes FetchCharacterDigit5R - 1
    .lobytes FetchCharacterDigit6L - 1
    .lobytes FetchCharacterDigit6R - 1
    .lobytes FetchCharacterDigit7L - 1
    .lobytes FetchCharacterDigit7R - 1
    .lobytes FetchCharacterDigit8L - 1
    .lobytes FetchCharacterDigit8R - 1
    .lobytes FetchCharacterSetHero - 1
    .lobytes FetchCharacterHeroName - 1
    .lobytes FetchCharacterHeroClass - 1
    .lobytes FetchCharacterItemName - 1
    .lobytes FetchCharacterItemDescription - 1

FetchCharacterSubstring:
    CALL FetchValue
    RTS
FetchCharacterDigit1:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CLC
    ADC #32
    LDY stringifyCursor
    RTS
FetchCharacterDigit2L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL a_to_2_digits
    LDA #128
    STA Var10
    CALL TrimDigit2
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+6)
    STA Var0
    LDA #>(yxa2decOutput+6)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit2R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL a_to_2_digits
    LDA #97
    STA Var10
    CALL TrimDigit2
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+6)
    STA Var0
    LDA #>(yxa2decOutput+6)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit3L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL xa_to_3_digits
    LDA #128
    STA Var10
    CALL TrimDigit3
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+5)
    STA Var0
    LDA #>(yxa2decOutput+5)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit3R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL xa_to_3_digits
    LDA #97
    STA Var10
    CALL TrimDigit3
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+5)
    STA Var0
    LDA #>(yxa2decOutput+5)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit4L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL xa_to_4_digits
    LDA #128
    STA Var10
    CALL TrimDigit3
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+4)
    STA Var0
    LDA #>(yxa2decOutput+4)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit4R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL xa_to_4_digits
    LDA #97
    STA Var10
    CALL TrimDigit4
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+4)
    STA Var0
    LDA #>(yxa2decOutput+4)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit5L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_5_digits
    LDA #128
    STA Var10
    CALL TrimDigit5
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+3)
    STA Var0
    LDA #>(yxa2decOutput+3)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit5R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_5_digits
    LDA #97
    STA Var10
    CALL TrimDigit5
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+3)
    STA Var0
    LDA #>(yxa2decOutput+3)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit6L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_6_digits
    LDA #128
    STA Var10
    CALL TrimDigit6
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+2)
    STA Var0
    LDA #>(yxa2decOutput+2)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit6R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_6_digits
    LDA #97
    STA Var10
    CALL TrimDigit6
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+2)
    STA Var0
    LDA #>(yxa2decOutput+2)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit7L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_7_digits
    LDA #128
    STA Var10
    CALL TrimDigit7
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+1)
    STA Var0
    LDA #>(yxa2decOutput+1)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit7R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_7_digits
    LDA #97
    STA Var10
    CALL TrimDigit7
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+1)
    STA Var0
    LDA #>(yxa2decOutput+1)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit8L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_8_digits
    LDA #128
    STA Var10
    CALL TrimDigit8
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+0)
    STA Var0
    LDA #>(yxa2decOutput+0)
    STA Var1
    JUMP FetchCharacter
FetchCharacterDigit8R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_8_digits
    LDA #97
    STA Var10
    CALL TrimDigit8
    LDY stringifyCursor
    CALL SaveStringifyStack
    LDY #0
    LDA #<(yxa2decOutput+0)
    STA Var0
    LDA #>(yxa2decOutput+0)
    STA Var1
    JUMP FetchCharacter
FetchCharacterSetHero:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    STA stringwriterSetHero
    LDY stringifyCursor
    LDA #128
    RTS
FetchCharacterHeroName:
    CALL IncrementStringifyAdvance
    CALL SaveStringifyStack
    LDA stringwriterSetHero
    STA MMC5_MULTI_1
    LDA #(heroName1 - heroName0)
    STA MMC5_MULTI_2
    LDA MMC5_MULTI_1
    CLC
    ADC #<heroName0
    STA Var0
    LDA #>heroName0
    ADC #0              ; OPTIMIZE: This could be removed if we ensure heroNames are on the same page
    STA Var1
    LDY #0
    JUMP FetchCharacter
FetchCharacterHeroClass:
    CALL IncrementStringifyAdvance
    CALL SaveStringifyStack
    LDX stringwriterSetHero
    LDA partyGenerationClass, X
    TAX
    LDA ClassStringPtrLo, X
    STA Var0
    LDA ClassStringPtrHi, X
    STA Var1
    LDA ClassStringPtrBank, X
    STA Var2
    LDY #0
    JUMP FetchCharacter
FetchCharacterItemName:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    PHA
    LDY stringifyCursor
    CALL SaveStringifyStack
    PLA
    TAX

    ; TODO: 16 bit item ids
    LDA #TextBank(LUT_ITEM_NAME)              ; Switch to the bank
    STA Var2
    STA MMC5_PRG_BANK2
    LDA LUT_ITEM_NAME, X
    STA Var0
    LDA LUT_ITEM_NAME_SIBLING2, X
    STA Var1
    LDY #0
    JUMP FetchCharacter
FetchCharacterItemDescription:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    PHA
    LDY stringifyCursor
    CALL SaveStringifyStack
    PLA
    TAX

    ; TODO: 16 bit item ids
    LDA #TextBank(LUT_ITEM_DESCRIPTION_SIBLING2)              ; Switch to the bank
    STA Var2
    STA MMC5_PRG_BANK2
    LDA LUT_ITEM_DESCRIPTION, X
    STA Var0
    LDA LUT_ITEM_DESCRIPTION_SIBLING2, X
    STA Var1
    LDY #0
    JUMP FetchCharacter

IncrementStringifyAdvance:
    INY
    RTS

ClearDigit:
    LDA #0
    STA yxa2decOutput+0
    STA yxa2decOutput+1
    STA yxa2decOutput+2
    STA yxa2decOutput+3
    STA yxa2decOutput+4
    STA yxa2decOutput+5
    STA yxa2decOutput+6
    STA yxa2decOutput+7
    RTS
TrimDigit8:
    LDA yxa2decOutput+0
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+0
TrimDigit7:
    LDA yxa2decOutput+1
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+1
TrimDigit6:
    LDA yxa2decOutput+2
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+2
TrimDigit5:
    LDA yxa2decOutput+3
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+3
TrimDigit4:
    LDA yxa2decOutput+4
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+4
TrimDigit3:
    LDA yxa2decOutput+5
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+5
TrimDigit2:
    LDA yxa2decOutput+6
    BEQ :+
        LDX #32
        STX Var10
    :
    CLC
    ADC Var10
    STA yxa2decOutput+6
TrimDigit1:
    LDA yxa2decOutput+7
    CLC
    ADC #32
    STA yxa2decOutput+7
    RTS

ClassStringPtrLo:
    .lobytes TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_THIEF, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_MAGE, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_CLASS_NAME_BLACK_MAGE
ClassStringPtrHi:
    .hibytes TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_THIEF, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_MAGE, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_CLASS_NAME_BLACK_MAGE
ClassStringPtrBank:
    .byte TextBank(TEXT_CLASS_NAME_FIGHTER), TextBank(TEXT_CLASS_NAME_THIEF), TextBank(TEXT_CLASS_NAME_BLACK_BELT), TextBank(TEXT_CLASS_NAME_RED_MAGE), TextBank(TEXT_CLASS_NAME_WHITE_MAGE), TextBank(TEXT_CLASS_NAME_BLACK_MAGE)

FetchValue:
    LDA Var2                        ; Load the bank this string is located in
    STA MMC5_PRG_BANK2              ; Switch to the bank
    STY stringifyCursor
    LDA (Var0),Y
    BMI @Control                            ; If the char is negative it means it's a control char
        LDX #0
        LDY #0
        RTS
    @Control:

    TAX
    LDA FetchValueJumpTableHi - 128, X
    PHA
    LDA FetchValueJumpTableLo - 128, X
    PHA
    RTS

FetchValueJumpTableHi:
    .hibytes FetchValueByte - 1
    .hibytes FetchValueWord - 1
    .hibytes FetchValueTribyte - 1
    .hibytes FetchValueRead8 - 1
    .hibytes FetchValueRead16 - 1
    .hibytes FetchValueRead24 - 1
    .hibytes FetchValueAdd - 1
    .hibytes FetchValueSub - 1
    .hibytes FetchValueMul - 1
    .hibytes FetchValueDiv - 1
    .hibytes FetchValueMax - 1
    .hibytes FetchValueMin - 1
    .hibytes FetchValueAnd - 1
    .hibytes FetchValueOr - 1
    .hibytes FetchValueXor - 1
    .hibytes FetchValueHeroLevel - 1
    .hibytes FetchValueHeroHP - 1
    .hibytes FetchValueHeroMaxHP - 1
    .hibytes FetchValueHeroSpellCharge1 - 1
    .hibytes FetchValueHeroSpellCharge2 - 1
    .hibytes FetchValueHeroSpellCharge3 - 1
    .hibytes FetchValueHeroSpellCharge4 - 1
    .hibytes FetchValueHeroSpellCharge5 - 1
    .hibytes FetchValueHeroSpellCharge6 - 1
    .hibytes FetchValueHeroSpellCharge7 - 1
    .hibytes FetchValueHeroSpellCharge8 - 1
    .hibytes FetchValueHeroMaxSpellCharge1 - 1
    .hibytes FetchValueHeroMaxSpellCharge2 - 1
    .hibytes FetchValueHeroMaxSpellCharge3 - 1
    .hibytes FetchValueHeroMaxSpellCharge4 - 1
    .hibytes FetchValueHeroMaxSpellCharge5 - 1
    .hibytes FetchValueHeroMaxSpellCharge6 - 1
    .hibytes FetchValueHeroMaxSpellCharge7 - 1
    .hibytes FetchValueHeroMaxSpellCharge8 - 1
    .hibytes FetchValueItemPrice - 1
    .hibytes FetchValueItemDataFirst - 1
    .hibytes FetchValueItemDataSecond - 1
    .hibytes FetchValueItemDataThird - 1
FetchValueJumpTableLo:
    .lobytes FetchValueByte - 1
    .lobytes FetchValueWord - 1
    .lobytes FetchValueTribyte - 1
    .lobytes FetchValueRead8 - 1
    .lobytes FetchValueRead16 - 1
    .lobytes FetchValueRead24 - 1
    .lobytes FetchValueAdd - 1
    .lobytes FetchValueSub - 1
    .lobytes FetchValueMul - 1
    .lobytes FetchValueDiv - 1
    .lobytes FetchValueMax - 1
    .lobytes FetchValueMin - 1
    .lobytes FetchValueAnd - 1
    .lobytes FetchValueOr - 1
    .lobytes FetchValueXor - 1
    .lobytes FetchValueHeroLevel - 1
    .lobytes FetchValueHeroHP - 1
    .lobytes FetchValueHeroMaxHP - 1
    .lobytes FetchValueHeroSpellCharge1 - 1
    .lobytes FetchValueHeroSpellCharge2 - 1
    .lobytes FetchValueHeroSpellCharge3 - 1
    .lobytes FetchValueHeroSpellCharge4 - 1
    .lobytes FetchValueHeroSpellCharge5 - 1
    .lobytes FetchValueHeroSpellCharge6 - 1
    .lobytes FetchValueHeroSpellCharge7 - 1
    .lobytes FetchValueHeroSpellCharge8 - 1
    .lobytes FetchValueHeroMaxSpellCharge1 - 1
    .lobytes FetchValueHeroMaxSpellCharge2 - 1
    .lobytes FetchValueHeroMaxSpellCharge3 - 1
    .lobytes FetchValueHeroMaxSpellCharge4 - 1
    .lobytes FetchValueHeroMaxSpellCharge5 - 1
    .lobytes FetchValueHeroMaxSpellCharge6 - 1
    .lobytes FetchValueHeroMaxSpellCharge7 - 1
    .lobytes FetchValueHeroMaxSpellCharge8 - 1
    .lobytes FetchValueItemPrice - 1
    .lobytes FetchValueItemDataFirst - 1
    .lobytes FetchValueItemDataSecond - 1
    .lobytes FetchValueItemDataThird - 1

FetchValueByte:
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    TAX
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    TXA
    LDX #0
    RTS
FetchValueWord:
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    TAX
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    PLA
    RTS
FetchValueTribyte:
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    PLA
    TAY
    PLA
    TAX
    PLA
    RTS
FetchValueRead8:
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDY #0
    LDA (Var3), Y           ; value
    LDX #0
    RTS
FetchValueRead16:
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDY #0
    LDA (Var3), Y           ; 0 - 7 bit
    PHA
    INY
    LDA (Var3), Y           ; 8 - 15 bit
    TAX
    PLA
    DEY
    RTS
FetchValueRead24:
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDY #0
    LDA (Var3), Y           ; 0 - 7 bit
    PHA
    INY
    LDA (Var3), Y           ; 8 - 15 bit
    TAX
    INY
    LDA (Var3), Y           ; 16 - 23 bit
    TAY
    PLA
    RTS
FetchValueAdd:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    STA Var11
    TYA
    PHA
    TXA
    PHA
    LDA Var11
    PHA

    LDY stringifyCursor
    CALL IncrementStringifyAdvance
    CALL FetchValue
    STA Var11
    STX Var12
    STY Var13

    LDY stringifyCursor
    CALL IncrementStringifyAdvance
    STY stringifyCursor

    PLA
    CLC
    ADC Var11
    STA Var11
    LDA #0
    ADC Var12
    STA Var12
    LDA #0
    ADC Var13
    STA Var13

    PLA
    CLC
    ADC Var12
    STA Var12
    LDA #0
    ADC Var13
    STA Var13

    PLA
    CLC
    ADC Var13
    BCS @overflow
    STA Var13

    LDA Var11
    LDX Var12
    LDY Var13
    RTS

    @overflow:
    LDA #255
    LDX #255
    LDY #255
    RTS
FetchValueSub:
    ERROR
    RTS
FetchValueMul:
    ERROR
    RTS
FetchValueDiv:
    ERROR
    RTS
FetchValueMax:
    ERROR
    RTS
FetchValueMin:
    ERROR
    RTS
FetchValueAnd:
    ERROR
    RTS
FetchValueOr:
    ERROR
    RTS
FetchValueXor:
    ERROR
    RTS
FetchValueHeroLevel:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDX stringwriterSetHero
    LDA heroLevel,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroHP:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    TAX
    LDA heroHP,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxHP:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    TAX
    LDA heroMaxHP,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge1:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+0,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge2:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+1,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge3:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+2,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge4:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+3,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge5:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+4,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge6:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+5,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge7:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+6,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroSpellCharge8:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+7,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge1:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+0,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge2:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+1,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge3:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+2,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge4:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+3,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge5:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+4,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge6:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+5,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge7:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+6,X
    LDX #0
    LDY #0
    RTS
FetchValueHeroMaxSpellCharge8:
    CALL IncrementStringifyAdvance
    STY stringifyCursor
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+7,X
    LDX #0
    LDY #0
    RTS
FetchValueItemPrice:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    TAX
    ; TODO: 16 bit item ids
    LDA #TextBank(LUT_ITEM_PRICE)              ; Switch to the bank
    STA MMC5_PRG_BANK2
    LDA LUT_ITEM_PRICE, X
    PHA
    LDA LUT_ITEM_PRICE_SIBLING2, X
    PHA
    LDY LUT_ITEM_PRICE_SIBLING3, X
    PLA
    TAX
    PLA
    RTS
FetchValueItemDataFirst:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    TAX
    ; TODO: 16 bit item ids
    LDA #TextBank(LUT_ITEM_PRICE)              ; Switch to the bank
    STA MMC5_PRG_BANK2
    LDA LUT_ITEM_DATA_FIRST, X
    PHA
    LDA LUT_ITEM_DATA_FIRST_SIBLING2, X
    PHA
    LDY LUT_ITEM_DATA_FIRST_SIBLING3, X
    PLA
    TAX
    PLA
    RTS
FetchValueItemDataSecond:
    RTS
FetchValueItemDataThird:
    RTS

VideoUpdatePushAddress:
    LDA VideoUpdateCursor
    BPL @noWait
    CALL WaitForVBlank
    @noWait:


    LDA #0
    STA stringifyLength
    LDX drawX         ; get dest_x in X
    LDY drawY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

    @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    PHA
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    PHA
    JUMP @Push

    @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    PHA                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    PHA                ;  for our low byte of PPU address

    @Push:
    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Inc1_Address-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Inc1_Address-1)
    STA VideoUpdateStack+1,X
    PLA
    STA VideoUpdateStack+3,X
    PLA
    STA VideoUpdateStack+2,X

    
    TXA
    CLC
    ADC #4
    STA VideoUpdateRetroactiveCursor
    ADC #2
    STA VideoUpdateCursor
    RTS
VideoUpdatePushData:
    LDX VideoUpdateCursor
    STA VideoUpdateStack,X
    INX
    STX VideoUpdateCursor
    INC stringifyLength
    INC stringwriterLineWidth
    RTS
VideoUpdateSetWriteStackBytes:
    LDX VideoUpdateRetroactiveCursor
    LDA #<(VideoUpdateWriteStackBytes-1)
    SEC
    SBC stringifyLength
    SBC stringifyLength
    SBC stringifyLength
    SBC stringifyLength
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdateWriteStackBytes-1)
    STA VideoUpdateStack+1,X

    LDX VideoUpdateCursor
    LDA #$80
    STA VideoUpdateStack+0,X
    STA VideoUpdateStack+1,X
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SetTile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SetTile:
    PHA
    LDA VideoUpdateCursor
    BPL @noWait
    CALL WaitForVBlank
    @noWait:

    LDX drawX         ; get dest_x in X
    LDY drawY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

    @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    PHA
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    PHA
    JUMP @Push

    @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    PHA                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    PHA                ;  for our low byte of PPU address

    @Push:
    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Address_Set_Write-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Address_Set_Write-1)
    STA VideoUpdateStack+1,X
    PLA
    STA VideoUpdateStack+3,X
    PLA
    STA VideoUpdateStack+2,X
    PLA
    STA VideoUpdateStack+4,X
    
    TXA
    CLC
    ADC #5
    STA VideoUpdateCursor

    LDA #$80
    STA VideoUpdateStack+5,X
    STA VideoUpdateStack+6,X
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DrawNineSlice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawNineSlice:
    LDA #7
    CALL VideoUpdateApplySize

    LDA drawWidth
    ASL A
    ASL A
    CLC
    ADC #32
    ; UPPER SECTION
    ; VideoUpdate_Inc1_Address_Set              ; 26
    ; VideoUpdate_Write_Set                     ; 18
    ; VideoUpdateRepeatValueSetValueWriteValue  ; N * 4 + 12
    ;
    ; MIDDLE SECTION
    ; VideoUpdate_Inc1_Address_Set              ; 26
    ; VideoUpdate_Write_Set                     ; 18
    ; VideoUpdateRepeatValueSetValueWriteValue  ; N * 4 + 12
    ;
    ; BOTTOM SECTINO
    ; VideoUpdate_Inc1_Address_Set              ; 26
    ; VideoUpdate_Write_Set                     ; 18
    ; VideoUpdateRepeatValueSetValueWriteValue  ; N * 4 + 12


    CALL VideoUpdateApplyCost


    LDA VideoUpdateCursor
    BPL :+
        LDX VideoUpdateCursor
        LDA #$80
        STA VideoUpdateStack+0,X
        STA VideoUpdateStack+1,X
        CALL WaitForVBlank
    :


    ; TOP SECTION
    LDX drawX         ; get dest_x in X
    LDY drawY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

    @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    PHA
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    PHA
    JUMP @Push

    @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    PHA                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    PHA                ;  for our low byte of PPU address

    @Push:
    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+1,X
    PLA
    STA VideoUpdateStack+3,X        ; Address
    PLA
    STA VideoUpdateStack+2,X        ; Address
    LDA drawVars+1
    STA VideoUpdateStack+4,X        ; NineSlice tile 1

    LDA #<(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+5,X
    LDA #>(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+6,X
    LDA drawVars+2
    STA VideoUpdateStack+7,X
    
    LDA #<(VideoUpdateRepeatValueSetValueWriteValue-1)
    SEC
    SBC box_wd
    SBC box_wd
    SBC box_wd
    STA VideoUpdateStack+8,X
    LDA #>(VideoUpdateRepeatValueSetValueWriteValue-1)
    STA VideoUpdateStack+9,X
    LDA drawVars+3
    STA VideoUpdateStack+10,X
    TXA
    CLC
    ADC #11
    STA VideoUpdateCursor

    ; Attribute
    LDA #%00000011
    STA Var24
    LDA drawX
    STA Var25
    LDA drawY
    STA Var26
    LDA box_wd
    CLC
    ADC #2
    STA Var27
    LDA box_ht
    CLC
    ADC #2
    STA Var28

    :
            LDA Var25                       ; load the x position
            LSR A
            LSR A                           ; rotate the second bit into the carry
            PHP                             ; save carry
            LDA Var26                       ; load the y position
            LSR A                           ; shift to the right
            PLP                             ; restore carry
            ROL A                           ; shift to the left while putting carry in bit 0
            ASL A                           ; shift all bits left
            ASL A                           ; shift all bits left
            ORA Var24                       ; OR with the actual 2 bit attribute
            AND #%00001111                  ; mask out the unrelevant bits
            TAX                             ; transfer A to X
            LDY Var26
            LDA Var25
            LSR A
            LSR A
            CLC
            ADC LUT_AttributeYPosition,Y
            TAY
            LDA attributeTable,Y
            AND LUT_AttributeMask,X
            ORA LUT_AttributeMagic,X
            STA attributeTable,Y
            INC Var25
            DEC Var27
        BNE :-
        LDA drawX
        STA Var25
        LDA box_wd
        CLC
        ADC #2
        STA Var27

        INC Var26
        DEC Var28
    BNE :-


    ; Order the PPU to update this attribute
    ;    LDX VideoUpdateCursor
    ;    LDA #<(VideoUpdate_Address_WriteAttribute-1)
    ;    STA VideoUpdateStack+0,X
    ;    LDA #>(VideoUpdate_Address_WriteAttribute-1)
    ;    STA VideoUpdateStack+1,X
    ;    ;LDY drawY
    ;    ;LDA drawX
    ;    ;LSR A
    ;    ;LSR A
    ;    ;CLC
    ;    ;ADC LUT_AttributeYPosition,Y
    ;    STA VideoUpdateStack+2,X
    ;    TXA
    ;    CLC
    ;    ADC #3
    ;    STA VideoUpdateCursor


    ; MIDDLE SECTION
    @LoopMiddleSection:
    LDA VideoUpdateCursor
    BPL :+
        LDX VideoUpdateCursor
        LDA #$80
        STA VideoUpdateStack+0,X
        STA VideoUpdateStack+1,X
        CALL WaitForVBlank
    :
    INC drawY

    LDX drawX         ; get dest_x in X
    LDY drawY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB2           ;  if it is, to NTB, otherwise, NTA

    @NTA2:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    PHA
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    PHA
    JUMP @Push2

    @NTB2:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    PHA                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    PHA                ;  for our low byte of PPU address

    @Push2:
    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+1,X
    PLA
    STA VideoUpdateStack+3,X
    PLA
    STA VideoUpdateStack+2,X
    LDA drawVars+4
    STA VideoUpdateStack+4,X

    LDA #<(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+5,X
    LDA #>(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+6,X
    LDA drawVars+5
    STA VideoUpdateStack+7,X
    
    LDA #<(VideoUpdateRepeatValueSetValueWriteValue-1)
    SEC
    SBC box_wd
    SBC box_wd
    SBC box_wd
    STA VideoUpdateStack+8,X
    LDA #>(VideoUpdateRepeatValueSetValueWriteValue-1)
    STA VideoUpdateStack+9,X
    LDA drawVars+6
    STA VideoUpdateStack+10,X

    TXA
    CLC
    ADC #11
    STA VideoUpdateCursor

    DEC box_ht
    BEQ :+
    JUMP @LoopMiddleSection
    :

    ; LOWER SECTION
    LDA VideoUpdateCursor
    BPL :+
        LDX VideoUpdateCursor
        LDA #$80
        STA VideoUpdateStack+0,X
        STA VideoUpdateStack+1,X
        CALL WaitForVBlank
    :
    INC drawY

    LDX drawX         ; get dest_x in X
    LDY drawY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB3           ;  if it is, to NTB, otherwise, NTA

    @NTA3:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    PHA
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    PHA
    JUMP @Push3

    @NTB3:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    PHA                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    PHA                ;  for our low byte of PPU address

    @Push3:
    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+1,X
    PLA
    STA VideoUpdateStack+3,X
    PLA
    STA VideoUpdateStack+2,X
    LDA drawVars+7
    STA VideoUpdateStack+4,X

    LDA #<(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+5,X
    LDA #>(VideoUpdate_Write_Set-1)
    STA VideoUpdateStack+6,X
    LDA drawVars+8
    STA VideoUpdateStack+7,X
    
    LDA #<(VideoUpdateRepeatValueSetValueWriteValue-1)
    SEC
    SBC box_wd
    SBC box_wd
    SBC box_wd
    STA VideoUpdateStack+8,X
    LDA #>(VideoUpdateRepeatValueSetValueWriteValue-1)
    STA VideoUpdateStack+9,X
    LDA drawVars+9
    STA VideoUpdateStack+10,X

    TXA
    CLC
    ADC #11
    STA VideoUpdateCursor

    ; All done
    LDX VideoUpdateCursor
    LDA #$80
    STA VideoUpdateStack+0,X
    STA VideoUpdateStack+1,X
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DrawRectangle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawRectangle:
    @loop:

    ; Add 7 to our video stack size
    LDA #7
    CALL VideoUpdateApplySize

    ; VideoUpdate_Inc1_Address_Set      13
    ; VideoUpdate_MassWrite             3 + 2 * width
    LDA drawWidth
    ASL A
    CLC
    ADC #(13+3)
    CALL VideoUpdateApplyCost

    LDX VideoUpdateCursor
    LDA #<(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_Inc1_Address_Set-1)
    STA VideoUpdateStack+1,X

    ; Now we translate our x,y into a nametable address, and store that address on the video stack so
    ; that when our video stack is executed it knows where to draw the rectangle.
    LDY drawY                ; Load y position into register Y
    LDA lut_NTRowStartHi, Y  ; Get high address offset into nametable for this y position
    STA VideoUpdateStack+2,X ; Save high address on the video stack
    LDA drawX                ; Load x position
    ORA lut_NTRowStartLo, Y  ; bitwise OR with low address for y position
    STA VideoUpdateStack+3,X ; Save low address on the video stack

    ; Put the tile index we wish to use when drawing our rectangle into the video stack
    LDA drawValue
    STA VideoUpdateStack+4,X

    LDA #<(VideoUpdate_MassWrite-1)
    SEC
    SBC drawWidth
    SBC drawWidth
    SBC drawWidth
    STA VideoUpdateStack+5,X
    LDA #>(VideoUpdate_MassWrite-1)
    STA VideoUpdateStack+6,X

    ; Advance our video cursor by 7
    TXA
    CLC
    ADC #7
    STA VideoUpdateCursor

    DEC drawHeight
    BEQ :+
        INC drawY
        JUMP @loop
    :
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadFillColor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadFillColor:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_SetFillColor-1)
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_SetFillColor-1)
    STA VideoUpdateStack+1,X
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette0:
    LDA VideoUpdateCursor
    BPL @noWait
    CALL WaitForVBlank
    @noWait:

    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette0-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette0-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette1:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette1-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette1-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette2:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette2-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette2-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette3:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette3-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette3-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette4:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette4-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette4-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette5:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette5-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette5-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette6:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette6-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette6-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadPalette7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadPalette7:
    LDA VideoUpdateCursor
    TAX
    CLC
    ADC #2
    BMI @End
    STA VideoUpdateCursor

    LDA #<(VideoUpdate_UploadPalette7-1)
    ; Carry is clear
    ADC VideoUpdateIncrementMode
    STA VideoUpdateStack+0,X
    LDA #>(VideoUpdate_UploadPalette7-1)
    STA VideoUpdateStack+1,X

    LDA #VIDEOUPDATE_INCREMENT1
    STA VideoUpdateIncrementMode
    @End:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Convert Coords to NT Addr   [$DCAB :: 0x3DCBB]
;;
;;   Converts a X,Y coord pair to a Nametable address
;;
;;   Y remains unchanged
;;
;;   IN:    dest_x
;;          dest_y
;;
;;   OUT:   ppu_dest, ppu_dest+1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CoordToNTAddr:
    LDY drawY                ; put the Y coord (row) in Y.  We'll use it to index the NT lut
    LDA drawX                ; put Y coord (col) in A
    AND #$1F                  ; wrap Y coord
    ORA lut_NTRowStartLo, Y   ; OR Y coord with low byte of row start
    STA ppu_dest              ;  this is the low byte of the addres -- record it
    LDA lut_NTRowStartHi, Y   ; fetch high byte based on row
    STA ppu_dest+1            ;  and record it
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$DCF4 :: 0x3DD04]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row
;;    Really, they just shortcut a multiplication by $20 ($20 tiles per row)
;;

lut_NTRowStartLo:
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0

lut_NTRowStartHi:
  .byte $20,$20,$20,$20,$20,$20,$20,$20
  .byte $21,$21,$21,$21,$21,$21,$21,$21
  .byte $22,$22,$22,$22,$22,$22,$22,$22
  .byte $23,$23,$23,$23,$23,$23,$23,$23

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Draw Box  [$E063 :: 0x3E073]
;;
;;    Draws a box of given size, to given coords.  NT changes only, no attribute changes
;;   The box CANNOT cross an NT boundary (ie:  this routine isn't used for the dialog box
;;   which often does cross NT boundaries)
;;
;;   Y remains unchanged
;;
;;   IN:   menustall = Nonzero if the box is to be drawn 1 row per frame (stall between rows)
;;                      or zero if box is to be drawn immediately with no stalling
;;         box_x,y   = Desired Coords of box
;;         box_wd,ht = Desired width/height of box (must be at least 3x3 tiles)
;;         cur_bank  = Bank number to swap to (only used if stalling between rows)
;;
;;   OUT:  dest_x,y  = X,Y coords of inner box body (ie:  where you start drawing text or whatever)
;;
;;   TMP:  tmp+10 and tmp+11 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBox:
    CALL CoordToNTAddr ; convert those coords to an NT address (placed in ppu_dest)
    LDA box_wd        ; Get width of box
    SEC
    SBC #$02          ; subtract 2 to get width of "innards" (minus left and right borders)
    STA tmp+10        ;  put this new width in temp ram
    LDA box_ht        ; Do same with box height
    SEC
    SBC #$02
    STA tmp+11        ;  put new height in temp ram

    CALL WaitForVBlank   ; wait for VBlank
    CALL PlotBoxRow_Top    ; Draw the top row of the box
    @Loop:                    ; Loop to draw all inner rows
      CALL PlotBoxRow_Mid  ;   draw inner row
      DEC tmp+11          ;   decrement our adjusted height
      BNE @Loop           ;   loop until expires
    CALL PlotBoxRow_Bot    ; Draw bottom row

    LDA soft2000          ; reset some PPU info
    STA PPUCTRL
    LDA #0
    STA PPUSCROLL             ; and scroll information
    STA PPUSCROLL


    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw middle row of a box (used by PlotBox)   [$E0A5 :: 0x3E0B5]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Mid:
    FARCALL MenuCondStall  ; do the conditional stall
    LDA PPUSTATUS          ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR          ; Load up desired PPU address
    LDA ppu_dest
    STA PPUADDR
    LDX tmp+10         ; Load adjusted width into X (for loop counter)
    LDA #$FA           ; FA = L border tile
    STA PPUDATA          ;   draw left border

    LDA #$FF           ; FF = inner box body tile
    @Loop:
      STA PPUDATA        ;  draw box body tile
      DEX              ;    until X expires
      BNE @Loop

    LDA #$FB           ; FB = R border tile
    STA PPUDATA          ;  draw right border

    LDA ppu_dest       ; Add #$20 to PPU address so that it points to the next row
    CLC
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0             ; Add 0 to catch carry
    STA ppu_dest+1

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw bottom row of a box (used by PlotBox)   [$E0D7 :: 0x3E0E7]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   ppu_dest is not adjusted for output like it is for other box row drawing routines
;;   since this is the bottom row, no rows will have to be drawn after this one, so it'd
;;   be pointless
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Bot:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; Reset PPU Toggle
    LDA ppu_dest+1      ;  and load up PPU Address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; put adjusted width in X (for loop counter)
    LDA #$FC            ;  FC = DL border tile
    STA PPUDATA

    LDA #$FD            ;  FD = bottom border tile
    @Loop:
      STA PPUDATA         ;  Draw it
      DEX               ;   until X expires
      BNE @Loop

    LDA #$FE            ;  FE = DR border tile
    STA PPUDATA

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw top row of a box (used by PlotBox)   [$E0FC :: 0x3E10C]
;;
;;   IN:  tmp+10   = width of innards (overall box width - 2)
;;        ppu_dest = the PPU address of the start of this row
;;
;;   OUT: ppu_dest = set to the PPU address of the start of the NEXT row
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PlotBoxRow_Top:
    FARCALL MenuCondStall   ; Do the conditional stall
    LDA PPUSTATUS           ; reset PPU toggle
    LDA ppu_dest+1
    STA PPUADDR           ; set PPU Address appropriately
    LDA ppu_dest
    STA PPUADDR

    LDX tmp+10          ; load the adjusted width into X (our loop counter)
    LDA #$F7            ; F7 = UL border tile
    STA PPUDATA           ;   draw UL border

    LDA #$F8            ; F8 = U border tile
    @Loop:
      STA PPUDATA         ;   draw U border
      DEX               ;     until X expires
      BNE @Loop

    LDA #$F9            ; F9 = UR border tile
    STA PPUDATA           ;   draw it

    LDA ppu_dest        ; Add #$20 to our input PPU address so that it
    CLC                 ;  points to the next row
    ADC #$20
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0              ; Add 0 to catch the carry
    STA ppu_dest+1

    RTS



SetAttribute:
    LDA Var25                       ; load the x position
    ROR A                           ; rotate the 1th bit into the carry
    LDA Var26                       ; load the y position
    ROL A                           ; rotate back the bit from the carry
    ASL A                           ; shift all bits left
    ASL A                           ; shift all bits left
    ORA Var24                       ; OR with the actual 2 bit attribute
    AND #%00001111                  ; mask out the unrelevant bits
    TAX                             ; transfer A to X
    LDY Var26
    LDA Var25
    LSR A
    CLC
    ADC LUT_AttributeYPosition,Y
    TAY
    LDA attributeTable,Y
    AND LUT_AttributeMask,X
    ORA LUT_AttributeMagic,X
    STA attributeTable,Y
    RTS



LUT_AttributeMagic:
    .byte %00000000
    .byte %00000001
    .byte %00000010
    .byte %00000011
    .byte %00000000
    .byte %00000100
    .byte %00001000
    .byte %00001100
    .byte %00000000
    .byte %00010000
    .byte %00100000
    .byte %00110000
    .byte %00000000
    .byte %01000000
    .byte %10000000
    .byte %11000000

LUT_AttributeMask:
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11111100
    .byte %11110011
    .byte %11110011
    .byte %11110011
    .byte %11110011
    .byte %11001111
    .byte %11001111
    .byte %11001111
    .byte %11001111
    .byte %00111111
    .byte %00111111
    .byte %00111111
    .byte %00111111


LUT_AttributeYPosition:
    .repeat 32, i
        .byte 8*(i>>2)
    .endrepeat
