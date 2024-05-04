.segment "PRG_090"

.include "src/global-import.inc"
.include "src/lib/yxa2dec.asm"

.import WaitForVBlank, MenuCondStall, MusicPlay

.import TEXT_CLASS_NAME_FIGHTER, TEXT_CLASS_NAME_THIEF, TEXT_CLASS_NAME_BLACK_BELT, TEXT_CLASS_NAME_RED_MAGE, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_CLASS_NAME_BLACK_MAGE
.import TEXT_ITEM_FROST, TEXT_ITEM_HEAT, TEXT_ITEM_GLANCE, TEXT_ITEM_GAZE, TEXT_ITEM_FLASH, TEXT_ITEM_SCORCH, TEXT_ITEM_CRACK, TEXT_ITEM_SQUINT, TEXT_ITEM_STARE, TEXT_ITEM_GLARE, TEXT_ITEM_BLIZZARD, TEXT_ITEM_BLAZE, TEXT_ITEM_INFERNO, TEXT_ITEM_CREMATE, TEXT_ITEM_POISON, TEXT_ITEM_TRANCE, TEXT_ITEM_THUNDER, TEXT_ITEM_TOXIC, TEXT_ITEM_SNORTING, TEXT_ITEM_NUCLEAR, TEXT_ITEM_INK, TEXT_ITEM_STINGER, TEXT_ITEM_DAZZLE, TEXT_ITEM_SWIRL, TEXT_ITEM_TORNADO, TEXT_ITEM_LUTE, TEXT_ITEM_CROWN, TEXT_ITEM_CRYSTAL, TEXT_ITEM_HERB, TEXT_ITEM_KEY, TEXT_ITEM_TNT, TEXT_ITEM_ADAMANT, TEXT_ITEM_SLAB, TEXT_ITEM_RUBY, TEXT_ITEM_ROD, TEXT_ITEM_FLOATER, TEXT_ITEM_CHIME, TEXT_ITEM_TAIL, TEXT_ITEM_CUBE, TEXT_ITEM_BOTTLE, TEXT_ITEM_OXYALE, TEXT_ITEM_CANOE, TEXT_ITEM_TENT, TEXT_ITEM_CABIN, TEXT_ITEM_HOUSE, TEXT_ITEM_HEAL, TEXT_ITEM_PURE, TEXT_ITEM_SOFT, TEXT_ITEM_WOODEN_NUNCHUCK, TEXT_ITEM_SMALL_KNIFE, TEXT_ITEM_WOODEN_STAFF, TEXT_ITEM_RAPIER, TEXT_ITEM_IRON_HAMMER, TEXT_ITEM_SHORT_SWORD, TEXT_ITEM_HAND_AXE, TEXT_ITEM_SCIMTAR, TEXT_ITEM_IRON_NUNCHUCK, TEXT_ITEM_LARGE_KNIFE, TEXT_ITEM_IRON_STAFF, TEXT_ITEM_SABRE, TEXT_ITEM_LONG_SWORD, TEXT_ITEM_GREAT_AXE, TEXT_ITEM_FALCHON, TEXT_ITEM_SILVER_KNIFE, TEXT_ITEM_SILVER_SWORD, TEXT_ITEM_SILVER_HAMMER, TEXT_ITEM_SILVER_AXE, TEXT_ITEM_FLAME_SWORD, TEXT_ITEM_ICE_SWORD, TEXT_ITEM_DRAGON_SWORD, TEXT_ITEM_GIANT_SWORD, TEXT_ITEM_SUN_SWORD, TEXT_ITEM_CORAL_SWORD, TEXT_ITEM_WERE_SWORD, TEXT_ITEM_RUNE_SWORD, TEXT_ITEM_POWER_STAFF, TEXT_ITEM_LIGHT_AXE, TEXT_ITEM_HEAL_STAFF, TEXT_ITEM_MAGE_STAFF, TEXT_ITEM_DEFENSE, TEXT_ITEM_WIZARD_STAFF, TEXT_ITEM_VORPAL, TEXT_ITEM_CATCLAW, TEXT_ITEM_THOR_HAMMER, TEXT_ITEM_BANE_SWORD, TEXT_ITEM_KATANA, TEXT_ITEM_XCALBER, TEXT_ITEM_MASMUNE, TEXT_ITEM_CLOTH, TEXT_ITEM_WOODEN_ARMOR, TEXT_ITEM_CHAIN_ARMOR, TEXT_ITEM_IRON_ARMOR, TEXT_ITEM_STEEL_ARMOR, TEXT_ITEM_SILVER_ARMOR, TEXT_ITEM_FLAME_ARMOR, TEXT_ITEM_ICE_ARMOR, TEXT_ITEM_OPAL_ARMOR, TEXT_ITEM_DRAGON_ARMOR, TEXT_ITEM_COPPER_BRACELET, TEXT_ITEM_SILVER_BRACELET, TEXT_ITEM_GOLD_BRACELET, TEXT_ITEM_OPAL_BRACELET, TEXT_ITEM_WHITE_CLOTH, TEXT_ITEM_BLACK_CLOTH, TEXT_ITEM_WOODEN_SHIELD, TEXT_ITEM_IRON_SHIELD, TEXT_ITEM_SILVER_SHIELD, TEXT_ITEM_FLAME_SHIELD, TEXT_ITEM_ICE_SHIELD, TEXT_ITEM_OPAL_SHIELD, TEXT_ITEM_AEGIS_SHIELD, TEXT_ITEM_BUCKLER, TEXT_ITEM_PROCAPE, TEXT_ITEM_CAP, TEXT_ITEM_WOODEN_HELMET, TEXT_ITEM_IRON_HELMET, TEXT_ITEM_SILVER_HELMET, TEXT_ITEM_OPAL_HELMET, TEXT_ITEM_HEAL_HELMET, TEXT_ITEM_RIBBON, TEXT_ITEM_GLOVES, TEXT_ITEM_COPPER_GAUNTLET, TEXT_ITEM_IRON_GAUNTLET, TEXT_ITEM_SILVER_GAUNTLET, TEXT_ITEM_ZEUS_GAUNTLET, TEXT_ITEM_POWER_GAUNTLET, TEXT_ITEM_OPAL_GAUNTLET, TEXT_ITEM_PRORING


.export PlotBox, Stringify



Stringify:
    LDA #0
    STA stringifyCounter

    FARCALL MusicPlay    ; keep the music playing
    CALL WaitForVBlank   ; wait for VBlank

    LDA stringwriterDestX
    STA stringwriterNewlineOrigin

    CALL SetStringifyPPUAddress
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
        PHA
        CALL StringifyLimiter
        PLA
        STA PPUDATA                     ; Draw it
        LDA stringwriterDestX           ; Increment the dest address by 1
        CLC
        ADC #1
        AND #$3F                        ; Mask it with $3F so it wraps around both NTs appropriately
        STA stringwriterDestX
        JUMP @Loop

        @Newline:
        LDA stringwriterNewlineOrigin
        STA stringwriterDestX
        INC stringwriterDestY
        CALL StringifyLimiter
        CALL SetStringifyPPUAddress  ; then set the PPU address appropriately
        JUMP @Loop

        @Void:
        JUMP @Loop

        @Terminate:
        ; We have to restore the scroll as this is messed up by our writing to the PPU
        LDA scrollX
        STA PPUSCROLL
        LDA scrollY
        STA PPUSCROLL

        RTS

SaveStringifyStack:
    LDX stringwriterStackIndex
    INC stringwriterStackIndex
    LDA Var0
    STA stringwriterStackLo, X
    LDA Var1
    STA stringwriterStackHi, X
    LDA Var2
    STA stringwriterStackBank, X
    RTS

StringifyLimiter:
    LDA stringifyCounter
    CLC
    ADC #1
    CMP #10
    BCC @noWait
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL
    FARCALL MusicPlay    ; keep the music playing
    CALL WaitForVBlank   ; wait for VBlank
    CALL SetStringifyPPUAddress
    LDA #0
    @noWait:
    STA stringifyCounter
    RTS
StringifyDelay:
    LDA scrollX
    STA PPUSCROLL
    LDA scrollY
    STA PPUSCROLL
    FARCALL MusicPlay    ; keep the music playing
    CALL WaitForVBlank   ; wait for VBlank
    CALL SetStringifyPPUAddress
    RTS



FetchCharacter:
    LDA Var2                        ; Load the bank this string is located in
    STA MMC5_PRG_BANK2              ; Switch to the bank

    LDY #0
    LDA (Var0),Y
    BEQ @Terminator
    BMI @Control                    ; If the char is negative it means it's a control char

    ; This is a regular plain char, so all we do is advance our char pointer, and then return the char
    ; as-is.
    CALL IncrementStringifyAdvance
    LDY #0
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

FetchCharacterSubstring:
    CALL FetchValue
    RTS
FetchCharacterDigit1:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CLC
    ADC #32
    RTS
FetchCharacterDigit2L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL a_to_2_digits
    LDA #128
    STA Var10
    CALL TrimDigit2
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
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
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+3)
    STA Var0
    LDA #>(yxa2decOutput+3)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit5R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_5_digits
    LDA #97
    STA Var10
    CALL TrimDigit5
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+3)
    STA Var0
    LDA #>(yxa2decOutput+3)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit6L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_6_digits
    LDA #128
    STA Var10
    CALL TrimDigit6
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+2)
    STA Var0
    LDA #>(yxa2decOutput+2)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit6R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_6_digits
    LDA #97
    STA Var10
    CALL TrimDigit6
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+2)
    STA Var0
    LDA #>(yxa2decOutput+2)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit7L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_7_digits
    LDA #128
    STA Var10
    CALL TrimDigit7
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+1)
    STA Var0
    LDA #>(yxa2decOutput+1)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit7R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_7_digits
    LDA #97
    STA Var10
    CALL TrimDigit7
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+1)
    STA Var0
    LDA #>(yxa2decOutput+1)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit8L:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_8_digits
    LDA #128
    STA Var10
    CALL TrimDigit8
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+0)
    STA Var0
    LDA #>(yxa2decOutput+0)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterDigit8R:
    CALL ClearDigit
    CALL IncrementStringifyAdvance
    CALL FetchValue
    CALL yxa_to_8_digits
    LDA #97
    STA Var10
    CALL TrimDigit8
    CALL SaveStringifyStack
    LDA #<(yxa2decOutput+0)
    STA Var0
    LDA #>(yxa2decOutput+0)
    STA Var1
    CALL StringifyDelay
    JUMP FetchCharacter
FetchCharacterSetHero:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    STA stringwriterSetHero
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
    JUMP FetchCharacter
FetchCharacterItemName:
    CALL IncrementStringifyAdvance
    CALL FetchValue
    PHA
    CALL SaveStringifyStack
    PLA
    TAX
    LDA LUTItemNamesLo, X
    STA Var0
    LDA LUTItemNamesHi, X
    STA Var1
    LDA LUTItemNamesBank, X
    STA Var2
    JUMP FetchCharacter

IncrementStringifyAdvance:
    INC Var0
    BNE :+
    INC Var1
    :
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

    LDY #0
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

FetchValueByte:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    TAX
    CALL IncrementStringifyAdvance
    TXA
    LDX #0
    RTS
FetchValueWord:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    TAX
    CALL IncrementStringifyAdvance
    PLA
    RTS
FetchValueTribyte:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    PHA
    CALL IncrementStringifyAdvance
    LDA (Var0),Y
    TAY
    CALL IncrementStringifyAdvance
    PLA
    TAX
    PLA
    RTS
FetchValueRead8:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
    LDA (Var3), Y           ; value
    LDX #0
    RTS
FetchValueRead16:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
    LDA (Var3), Y           ; 0 - 7 bit
    PHA
    INY
    LDA (Var3), Y           ; 8 - 15 bit
    TAX
    PLA
    DEY
    RTS
FetchValueRead24:
    LDY #0
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; hi
    STA Var4
    CALL IncrementStringifyAdvance
    LDA (Var0), Y           ; lo
    STA Var3
    CALL IncrementStringifyAdvance
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

    CALL IncrementStringifyAdvance
    CALL FetchValue
    STA Var11
    STX Var12
    STY Var13

    CALL IncrementStringifyAdvance

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
    LDX stringwriterSetHero
    LDA heroLevel,X
    LDX #0
    RTS
FetchValueHeroHP:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    TAX
    LDA heroHP,X
    LDX #0
    RTS
FetchValueHeroMaxHP:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    TAX
    LDA heroMaxHP,X
    LDX #0
    RTS
FetchValueHeroSpellCharge1:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+0,X
    LDX #0
    RTS
FetchValueHeroSpellCharge2:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+1,X
    LDX #0
    RTS
FetchValueHeroSpellCharge3:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+2,X
    LDX #0
    RTS
FetchValueHeroSpellCharge4:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+3,X
    LDX #0
    RTS
FetchValueHeroSpellCharge5:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+4,X
    LDX #0
    RTS
FetchValueHeroSpellCharge6:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+5,X
    LDX #0
    RTS
FetchValueHeroSpellCharge7:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+6,X
    LDX #0
    RTS
FetchValueHeroSpellCharge8:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroSpellCharges+7,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge1:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+0,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge2:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+1,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge3:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+2,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge4:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+3,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge5:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+4,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge6:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+5,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge7:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+6,X
    LDX #0
    RTS
FetchValueHeroMaxSpellCharge8:
    CALL IncrementStringifyAdvance
    LDA stringwriterSetHero
    ASL A
    ASL A
    ASL A
    TAX
    LDA heroMaxSpellCharges+7,X
    LDX #0
    RTS
FetchValueItemPrice:
    LDA #50
    LDX #1
    LDY #0
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetStringifyPPUAddress
;;
;;    Sets the PPU address to have it start drawing at the coords
;;  given by dest_x, dest_y.  The difference between this and the below
;;  CoordToNTAddr routine is that this one actually sets the PPU address
;;  (whereas the below simply does the conversion without setting PPU
;;  address) -- AND this one works when dest_x is between 00-3F (both nametables)
;;  whereas CoordToNTAddr only works when dest_x is between 00-1F (one nametable)
;;
;;  IN:  dest_x, dest_y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetStringifyPPUAddress:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX stringwriterDestX         ; get dest_x in X
    LDY stringwriterDestY         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

    @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    STA PPUADDR                ; write it
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    STA PPUADDR                ; and write as low byte
    RTS

    @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    STA PPUADDR                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    STA PPUADDR                ;  for our low byte of PPU address
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Item name lookup table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LUTItemNamesLo:
    .lobytes TEXT_ITEM_FROST
    .lobytes TEXT_ITEM_HEAT
    .lobytes TEXT_ITEM_GLANCE
    .lobytes TEXT_ITEM_GAZE
    .lobytes TEXT_ITEM_FLASH
    .lobytes TEXT_ITEM_SCORCH
    .lobytes TEXT_ITEM_CRACK
    .lobytes TEXT_ITEM_SQUINT
    .lobytes TEXT_ITEM_STARE
    .lobytes TEXT_ITEM_GLARE
    .lobytes TEXT_ITEM_BLIZZARD
    .lobytes TEXT_ITEM_BLAZE
    .lobytes TEXT_ITEM_INFERNO
    .lobytes TEXT_ITEM_CREMATE
    .lobytes TEXT_ITEM_POISON
    .lobytes TEXT_ITEM_TRANCE
    .lobytes TEXT_ITEM_THUNDER
    .lobytes TEXT_ITEM_TOXIC
    .lobytes TEXT_ITEM_SNORTING
    .lobytes TEXT_ITEM_NUCLEAR
    .lobytes TEXT_ITEM_INK
    .lobytes TEXT_ITEM_STINGER
    .lobytes TEXT_ITEM_DAZZLE
    .lobytes TEXT_ITEM_SWIRL
    .lobytes TEXT_ITEM_TORNADO
    .lobytes TEXT_ITEM_LUTE
    .lobytes TEXT_ITEM_CROWN
    .lobytes TEXT_ITEM_CRYSTAL
    .lobytes TEXT_ITEM_HERB
    .lobytes TEXT_ITEM_KEY
    .lobytes TEXT_ITEM_TNT
    .lobytes TEXT_ITEM_ADAMANT
    .lobytes TEXT_ITEM_SLAB
    .lobytes TEXT_ITEM_RUBY
    .lobytes TEXT_ITEM_ROD
    .lobytes TEXT_ITEM_FLOATER
    .lobytes TEXT_ITEM_CHIME
    .lobytes TEXT_ITEM_TAIL
    .lobytes TEXT_ITEM_CUBE
    .lobytes TEXT_ITEM_BOTTLE
    .lobytes TEXT_ITEM_OXYALE
    .lobytes TEXT_ITEM_CANOE
    .lobytes TEXT_ITEM_TENT
    .lobytes TEXT_ITEM_CABIN
    .lobytes TEXT_ITEM_HOUSE
    .lobytes TEXT_ITEM_HEAL
    .lobytes TEXT_ITEM_PURE
    .lobytes TEXT_ITEM_SOFT
    .lobytes TEXT_ITEM_WOODEN_NUNCHUCK
    .lobytes TEXT_ITEM_SMALL_KNIFE
    .lobytes TEXT_ITEM_WOODEN_STAFF
    .lobytes TEXT_ITEM_RAPIER
    .lobytes TEXT_ITEM_IRON_HAMMER
    .lobytes TEXT_ITEM_SHORT_SWORD
    .lobytes TEXT_ITEM_HAND_AXE
    .lobytes TEXT_ITEM_SCIMTAR
    .lobytes TEXT_ITEM_IRON_NUNCHUCK
    .lobytes TEXT_ITEM_LARGE_KNIFE
    .lobytes TEXT_ITEM_IRON_STAFF
    .lobytes TEXT_ITEM_SABRE
    .lobytes TEXT_ITEM_LONG_SWORD
    .lobytes TEXT_ITEM_GREAT_AXE
    .lobytes TEXT_ITEM_FALCHON
    .lobytes TEXT_ITEM_SILVER_KNIFE
    .lobytes TEXT_ITEM_SILVER_SWORD
    .lobytes TEXT_ITEM_SILVER_HAMMER
    .lobytes TEXT_ITEM_SILVER_AXE
    .lobytes TEXT_ITEM_FLAME_SWORD
    .lobytes TEXT_ITEM_ICE_SWORD
    .lobytes TEXT_ITEM_DRAGON_SWORD
    .lobytes TEXT_ITEM_GIANT_SWORD
    .lobytes TEXT_ITEM_SUN_SWORD
    .lobytes TEXT_ITEM_CORAL_SWORD
    .lobytes TEXT_ITEM_WERE_SWORD
    .lobytes TEXT_ITEM_RUNE_SWORD
    .lobytes TEXT_ITEM_POWER_STAFF
    .lobytes TEXT_ITEM_LIGHT_AXE
    .lobytes TEXT_ITEM_HEAL_STAFF
    .lobytes TEXT_ITEM_MAGE_STAFF
    .lobytes TEXT_ITEM_DEFENSE
    .lobytes TEXT_ITEM_WIZARD_STAFF
    .lobytes TEXT_ITEM_VORPAL
    .lobytes TEXT_ITEM_CATCLAW
    .lobytes TEXT_ITEM_THOR_HAMMER
    .lobytes TEXT_ITEM_BANE_SWORD
    .lobytes TEXT_ITEM_KATANA
    .lobytes TEXT_ITEM_XCALBER
    .lobytes TEXT_ITEM_MASMUNE
    .lobytes TEXT_ITEM_CLOTH
    .lobytes TEXT_ITEM_WOODEN_ARMOR
    .lobytes TEXT_ITEM_CHAIN_ARMOR
    .lobytes TEXT_ITEM_IRON_ARMOR
    .lobytes TEXT_ITEM_STEEL_ARMOR
    .lobytes TEXT_ITEM_SILVER_ARMOR
    .lobytes TEXT_ITEM_FLAME_ARMOR
    .lobytes TEXT_ITEM_ICE_ARMOR
    .lobytes TEXT_ITEM_OPAL_ARMOR
    .lobytes TEXT_ITEM_DRAGON_ARMOR
    .lobytes TEXT_ITEM_COPPER_BRACELET
    .lobytes TEXT_ITEM_SILVER_BRACELET
    .lobytes TEXT_ITEM_GOLD_BRACELET
    .lobytes TEXT_ITEM_OPAL_BRACELET
    .lobytes TEXT_ITEM_WHITE_CLOTH
    .lobytes TEXT_ITEM_BLACK_CLOTH
    .lobytes TEXT_ITEM_WOODEN_SHIELD
    .lobytes TEXT_ITEM_IRON_SHIELD
    .lobytes TEXT_ITEM_SILVER_SHIELD
    .lobytes TEXT_ITEM_FLAME_SHIELD
    .lobytes TEXT_ITEM_ICE_SHIELD
    .lobytes TEXT_ITEM_OPAL_SHIELD
    .lobytes TEXT_ITEM_AEGIS_SHIELD
    .lobytes TEXT_ITEM_BUCKLER
    .lobytes TEXT_ITEM_PROCAPE
    .lobytes TEXT_ITEM_CAP
    .lobytes TEXT_ITEM_WOODEN_HELMET
    .lobytes TEXT_ITEM_IRON_HELMET
    .lobytes TEXT_ITEM_SILVER_HELMET
    .lobytes TEXT_ITEM_OPAL_HELMET
    .lobytes TEXT_ITEM_HEAL_HELMET
    .lobytes TEXT_ITEM_RIBBON
    .lobytes TEXT_ITEM_GLOVES
    .lobytes TEXT_ITEM_COPPER_GAUNTLET
    .lobytes TEXT_ITEM_IRON_GAUNTLET
    .lobytes TEXT_ITEM_SILVER_GAUNTLET
    .lobytes TEXT_ITEM_ZEUS_GAUNTLET
    .lobytes TEXT_ITEM_POWER_GAUNTLET
    .lobytes TEXT_ITEM_OPAL_GAUNTLET
    .lobytes TEXT_ITEM_PRORING
LUTItemNamesHi:
    .hibytes TEXT_ITEM_FROST
    .hibytes TEXT_ITEM_HEAT
    .hibytes TEXT_ITEM_GLANCE
    .hibytes TEXT_ITEM_GAZE
    .hibytes TEXT_ITEM_FLASH
    .hibytes TEXT_ITEM_SCORCH
    .hibytes TEXT_ITEM_CRACK
    .hibytes TEXT_ITEM_SQUINT
    .hibytes TEXT_ITEM_STARE
    .hibytes TEXT_ITEM_GLARE
    .hibytes TEXT_ITEM_BLIZZARD
    .hibytes TEXT_ITEM_BLAZE
    .hibytes TEXT_ITEM_INFERNO
    .hibytes TEXT_ITEM_CREMATE
    .hibytes TEXT_ITEM_POISON
    .hibytes TEXT_ITEM_TRANCE
    .hibytes TEXT_ITEM_THUNDER
    .hibytes TEXT_ITEM_TOXIC
    .hibytes TEXT_ITEM_SNORTING
    .hibytes TEXT_ITEM_NUCLEAR
    .hibytes TEXT_ITEM_INK
    .hibytes TEXT_ITEM_STINGER
    .hibytes TEXT_ITEM_DAZZLE
    .hibytes TEXT_ITEM_SWIRL
    .hibytes TEXT_ITEM_TORNADO
    .hibytes TEXT_ITEM_LUTE
    .hibytes TEXT_ITEM_CROWN
    .hibytes TEXT_ITEM_CRYSTAL
    .hibytes TEXT_ITEM_HERB
    .hibytes TEXT_ITEM_KEY
    .hibytes TEXT_ITEM_TNT
    .hibytes TEXT_ITEM_ADAMANT
    .hibytes TEXT_ITEM_SLAB
    .hibytes TEXT_ITEM_RUBY
    .hibytes TEXT_ITEM_ROD
    .hibytes TEXT_ITEM_FLOATER
    .hibytes TEXT_ITEM_CHIME
    .hibytes TEXT_ITEM_TAIL
    .hibytes TEXT_ITEM_CUBE
    .hibytes TEXT_ITEM_BOTTLE
    .hibytes TEXT_ITEM_OXYALE
    .hibytes TEXT_ITEM_CANOE
    .hibytes TEXT_ITEM_TENT
    .hibytes TEXT_ITEM_CABIN
    .hibytes TEXT_ITEM_HOUSE
    .hibytes TEXT_ITEM_HEAL
    .hibytes TEXT_ITEM_PURE
    .hibytes TEXT_ITEM_SOFT
    .hibytes TEXT_ITEM_WOODEN_NUNCHUCK
    .hibytes TEXT_ITEM_SMALL_KNIFE
    .hibytes TEXT_ITEM_WOODEN_STAFF
    .hibytes TEXT_ITEM_RAPIER
    .hibytes TEXT_ITEM_IRON_HAMMER
    .hibytes TEXT_ITEM_SHORT_SWORD
    .hibytes TEXT_ITEM_HAND_AXE
    .hibytes TEXT_ITEM_SCIMTAR
    .hibytes TEXT_ITEM_IRON_NUNCHUCK
    .hibytes TEXT_ITEM_LARGE_KNIFE
    .hibytes TEXT_ITEM_IRON_STAFF
    .hibytes TEXT_ITEM_SABRE
    .hibytes TEXT_ITEM_LONG_SWORD
    .hibytes TEXT_ITEM_GREAT_AXE
    .hibytes TEXT_ITEM_FALCHON
    .hibytes TEXT_ITEM_SILVER_KNIFE
    .hibytes TEXT_ITEM_SILVER_SWORD
    .hibytes TEXT_ITEM_SILVER_HAMMER
    .hibytes TEXT_ITEM_SILVER_AXE
    .hibytes TEXT_ITEM_FLAME_SWORD
    .hibytes TEXT_ITEM_ICE_SWORD
    .hibytes TEXT_ITEM_DRAGON_SWORD
    .hibytes TEXT_ITEM_GIANT_SWORD
    .hibytes TEXT_ITEM_SUN_SWORD
    .hibytes TEXT_ITEM_CORAL_SWORD
    .hibytes TEXT_ITEM_WERE_SWORD
    .hibytes TEXT_ITEM_RUNE_SWORD
    .hibytes TEXT_ITEM_POWER_STAFF
    .hibytes TEXT_ITEM_LIGHT_AXE
    .hibytes TEXT_ITEM_HEAL_STAFF
    .hibytes TEXT_ITEM_MAGE_STAFF
    .hibytes TEXT_ITEM_DEFENSE
    .hibytes TEXT_ITEM_WIZARD_STAFF
    .hibytes TEXT_ITEM_VORPAL
    .hibytes TEXT_ITEM_CATCLAW
    .hibytes TEXT_ITEM_THOR_HAMMER
    .hibytes TEXT_ITEM_BANE_SWORD
    .hibytes TEXT_ITEM_KATANA
    .hibytes TEXT_ITEM_XCALBER
    .hibytes TEXT_ITEM_MASMUNE
    .hibytes TEXT_ITEM_CLOTH
    .hibytes TEXT_ITEM_WOODEN_ARMOR
    .hibytes TEXT_ITEM_CHAIN_ARMOR
    .hibytes TEXT_ITEM_IRON_ARMOR
    .hibytes TEXT_ITEM_STEEL_ARMOR
    .hibytes TEXT_ITEM_SILVER_ARMOR
    .hibytes TEXT_ITEM_FLAME_ARMOR
    .hibytes TEXT_ITEM_ICE_ARMOR
    .hibytes TEXT_ITEM_OPAL_ARMOR
    .hibytes TEXT_ITEM_DRAGON_ARMOR
    .hibytes TEXT_ITEM_COPPER_BRACELET
    .hibytes TEXT_ITEM_SILVER_BRACELET
    .hibytes TEXT_ITEM_GOLD_BRACELET
    .hibytes TEXT_ITEM_OPAL_BRACELET
    .hibytes TEXT_ITEM_WHITE_CLOTH
    .hibytes TEXT_ITEM_BLACK_CLOTH
    .hibytes TEXT_ITEM_WOODEN_SHIELD
    .hibytes TEXT_ITEM_IRON_SHIELD
    .hibytes TEXT_ITEM_SILVER_SHIELD
    .hibytes TEXT_ITEM_FLAME_SHIELD
    .hibytes TEXT_ITEM_ICE_SHIELD
    .hibytes TEXT_ITEM_OPAL_SHIELD
    .hibytes TEXT_ITEM_AEGIS_SHIELD
    .hibytes TEXT_ITEM_BUCKLER
    .hibytes TEXT_ITEM_PROCAPE
    .hibytes TEXT_ITEM_CAP
    .hibytes TEXT_ITEM_WOODEN_HELMET
    .hibytes TEXT_ITEM_IRON_HELMET
    .hibytes TEXT_ITEM_SILVER_HELMET
    .hibytes TEXT_ITEM_OPAL_HELMET
    .hibytes TEXT_ITEM_HEAL_HELMET
    .hibytes TEXT_ITEM_RIBBON
    .hibytes TEXT_ITEM_GLOVES
    .hibytes TEXT_ITEM_COPPER_GAUNTLET
    .hibytes TEXT_ITEM_IRON_GAUNTLET
    .hibytes TEXT_ITEM_SILVER_GAUNTLET
    .hibytes TEXT_ITEM_ZEUS_GAUNTLET
    .hibytes TEXT_ITEM_POWER_GAUNTLET
    .hibytes TEXT_ITEM_OPAL_GAUNTLET
    .hibytes TEXT_ITEM_PRORING
LUTItemNamesBank:
    .byte TextBank(TEXT_ITEM_FROST)
    .byte TextBank(TEXT_ITEM_HEAT)
    .byte TextBank(TEXT_ITEM_GLANCE)
    .byte TextBank(TEXT_ITEM_GAZE)
    .byte TextBank(TEXT_ITEM_FLASH)
    .byte TextBank(TEXT_ITEM_SCORCH)
    .byte TextBank(TEXT_ITEM_CRACK)
    .byte TextBank(TEXT_ITEM_SQUINT)
    .byte TextBank(TEXT_ITEM_STARE)
    .byte TextBank(TEXT_ITEM_GLARE)
    .byte TextBank(TEXT_ITEM_BLIZZARD)
    .byte TextBank(TEXT_ITEM_BLAZE)
    .byte TextBank(TEXT_ITEM_INFERNO)
    .byte TextBank(TEXT_ITEM_CREMATE)
    .byte TextBank(TEXT_ITEM_POISON)
    .byte TextBank(TEXT_ITEM_TRANCE)
    .byte TextBank(TEXT_ITEM_THUNDER)
    .byte TextBank(TEXT_ITEM_TOXIC)
    .byte TextBank(TEXT_ITEM_SNORTING)
    .byte TextBank(TEXT_ITEM_NUCLEAR)
    .byte TextBank(TEXT_ITEM_INK)
    .byte TextBank(TEXT_ITEM_STINGER)
    .byte TextBank(TEXT_ITEM_DAZZLE)
    .byte TextBank(TEXT_ITEM_SWIRL)
    .byte TextBank(TEXT_ITEM_TORNADO)
    .byte TextBank(TEXT_ITEM_LUTE)
    .byte TextBank(TEXT_ITEM_CROWN)
    .byte TextBank(TEXT_ITEM_CRYSTAL)
    .byte TextBank(TEXT_ITEM_HERB)
    .byte TextBank(TEXT_ITEM_KEY)
    .byte TextBank(TEXT_ITEM_TNT)
    .byte TextBank(TEXT_ITEM_ADAMANT)
    .byte TextBank(TEXT_ITEM_SLAB)
    .byte TextBank(TEXT_ITEM_RUBY)
    .byte TextBank(TEXT_ITEM_ROD)
    .byte TextBank(TEXT_ITEM_FLOATER)
    .byte TextBank(TEXT_ITEM_CHIME)
    .byte TextBank(TEXT_ITEM_TAIL)
    .byte TextBank(TEXT_ITEM_CUBE)
    .byte TextBank(TEXT_ITEM_BOTTLE)
    .byte TextBank(TEXT_ITEM_OXYALE)
    .byte TextBank(TEXT_ITEM_CANOE)
    .byte TextBank(TEXT_ITEM_TENT)
    .byte TextBank(TEXT_ITEM_CABIN)
    .byte TextBank(TEXT_ITEM_HOUSE)
    .byte TextBank(TEXT_ITEM_HEAL)
    .byte TextBank(TEXT_ITEM_PURE)
    .byte TextBank(TEXT_ITEM_SOFT)
    .byte TextBank(TEXT_ITEM_WOODEN_NUNCHUCK)
    .byte TextBank(TEXT_ITEM_SMALL_KNIFE)
    .byte TextBank(TEXT_ITEM_WOODEN_STAFF)
    .byte TextBank(TEXT_ITEM_RAPIER)
    .byte TextBank(TEXT_ITEM_IRON_HAMMER)
    .byte TextBank(TEXT_ITEM_SHORT_SWORD)
    .byte TextBank(TEXT_ITEM_HAND_AXE)
    .byte TextBank(TEXT_ITEM_SCIMTAR)
    .byte TextBank(TEXT_ITEM_IRON_NUNCHUCK)
    .byte TextBank(TEXT_ITEM_LARGE_KNIFE)
    .byte TextBank(TEXT_ITEM_IRON_STAFF)
    .byte TextBank(TEXT_ITEM_SABRE)
    .byte TextBank(TEXT_ITEM_LONG_SWORD)
    .byte TextBank(TEXT_ITEM_GREAT_AXE)
    .byte TextBank(TEXT_ITEM_FALCHON)
    .byte TextBank(TEXT_ITEM_SILVER_KNIFE)
    .byte TextBank(TEXT_ITEM_SILVER_SWORD)
    .byte TextBank(TEXT_ITEM_SILVER_HAMMER)
    .byte TextBank(TEXT_ITEM_SILVER_AXE)
    .byte TextBank(TEXT_ITEM_FLAME_SWORD)
    .byte TextBank(TEXT_ITEM_ICE_SWORD)
    .byte TextBank(TEXT_ITEM_DRAGON_SWORD)
    .byte TextBank(TEXT_ITEM_GIANT_SWORD)
    .byte TextBank(TEXT_ITEM_SUN_SWORD)
    .byte TextBank(TEXT_ITEM_CORAL_SWORD)
    .byte TextBank(TEXT_ITEM_WERE_SWORD)
    .byte TextBank(TEXT_ITEM_RUNE_SWORD)
    .byte TextBank(TEXT_ITEM_POWER_STAFF)
    .byte TextBank(TEXT_ITEM_LIGHT_AXE)
    .byte TextBank(TEXT_ITEM_HEAL_STAFF)
    .byte TextBank(TEXT_ITEM_MAGE_STAFF)
    .byte TextBank(TEXT_ITEM_DEFENSE)
    .byte TextBank(TEXT_ITEM_WIZARD_STAFF)
    .byte TextBank(TEXT_ITEM_VORPAL)
    .byte TextBank(TEXT_ITEM_CATCLAW)
    .byte TextBank(TEXT_ITEM_THOR_HAMMER)
    .byte TextBank(TEXT_ITEM_BANE_SWORD)
    .byte TextBank(TEXT_ITEM_KATANA)
    .byte TextBank(TEXT_ITEM_XCALBER)
    .byte TextBank(TEXT_ITEM_MASMUNE)
    .byte TextBank(TEXT_ITEM_CLOTH)
    .byte TextBank(TEXT_ITEM_WOODEN_ARMOR)
    .byte TextBank(TEXT_ITEM_CHAIN_ARMOR)
    .byte TextBank(TEXT_ITEM_IRON_ARMOR)
    .byte TextBank(TEXT_ITEM_STEEL_ARMOR)
    .byte TextBank(TEXT_ITEM_SILVER_ARMOR)
    .byte TextBank(TEXT_ITEM_FLAME_ARMOR)
    .byte TextBank(TEXT_ITEM_ICE_ARMOR)
    .byte TextBank(TEXT_ITEM_OPAL_ARMOR)
    .byte TextBank(TEXT_ITEM_DRAGON_ARMOR)
    .byte TextBank(TEXT_ITEM_COPPER_BRACELET)
    .byte TextBank(TEXT_ITEM_SILVER_BRACELET)
    .byte TextBank(TEXT_ITEM_GOLD_BRACELET)
    .byte TextBank(TEXT_ITEM_OPAL_BRACELET)
    .byte TextBank(TEXT_ITEM_WHITE_CLOTH)
    .byte TextBank(TEXT_ITEM_BLACK_CLOTH)
    .byte TextBank(TEXT_ITEM_WOODEN_SHIELD)
    .byte TextBank(TEXT_ITEM_IRON_SHIELD)
    .byte TextBank(TEXT_ITEM_SILVER_SHIELD)
    .byte TextBank(TEXT_ITEM_FLAME_SHIELD)
    .byte TextBank(TEXT_ITEM_ICE_SHIELD)
    .byte TextBank(TEXT_ITEM_OPAL_SHIELD)
    .byte TextBank(TEXT_ITEM_AEGIS_SHIELD)
    .byte TextBank(TEXT_ITEM_BUCKLER)
    .byte TextBank(TEXT_ITEM_PROCAPE)
    .byte TextBank(TEXT_ITEM_CAP)
    .byte TextBank(TEXT_ITEM_WOODEN_HELMET)
    .byte TextBank(TEXT_ITEM_IRON_HELMET)
    .byte TextBank(TEXT_ITEM_SILVER_HELMET)
    .byte TextBank(TEXT_ITEM_OPAL_HELMET)
    .byte TextBank(TEXT_ITEM_HEAL_HELMET)
    .byte TextBank(TEXT_ITEM_RIBBON)
    .byte TextBank(TEXT_ITEM_GLOVES)
    .byte TextBank(TEXT_ITEM_COPPER_GAUNTLET)
    .byte TextBank(TEXT_ITEM_IRON_GAUNTLET)
    .byte TextBank(TEXT_ITEM_SILVER_GAUNTLET)
    .byte TextBank(TEXT_ITEM_ZEUS_GAUNTLET)
    .byte TextBank(TEXT_ITEM_POWER_GAUNTLET)
    .byte TextBank(TEXT_ITEM_OPAL_GAUNTLET)
    .byte TextBank(TEXT_ITEM_PRORING)

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
    LDY stringwriterDestY                ; put the Y coord (row) in Y.  We'll use it to index the NT lut
    LDA stringwriterDestX                ; put Y coord (col) in A
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



