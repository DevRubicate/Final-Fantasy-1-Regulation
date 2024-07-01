.segment "PRG_108"

.include "src/global-import.inc"

.import UploadPalette0, FillAttributeTable, FillNametable, UploadFont, UploadNineSliceBorders, RestoreNineSliceBordersToDefault
.import DrawSprite, DrawNineSlice, TEXT_TITLE_CONTINUE, TEXT_TITLE_RESPOND_RATE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_COPYRIGHT_NINTENDO, UploadSpriteCHR2, UploadSpriteCHR3, UploadSpriteCHR4, UploadPalette4, ClearSprites
.import TEXT_TITLE_NEW_GAME, TEXT_TITLE_START

.import UploadMetaSprite, UploadCHRSolids, UploadBackgroundCHR1, UploadBackgroundCHR2, UploadBackgroundCHR4
.import METASPRITE_CURSOR_CHR
.import METASPRITE_BLACK_BELT_CHR, METASPRITE_BLACK_MAGE_CHR, METASPRITE_FIGHTER_CHR, METASPRITE_RED_MAGE_CHR, METASPRITE_THIEF_CHR, METASPRITE_WHITE_MAGE_CHR
.import WaitForVBlank, MusicPlay, Stringify

.export DrawTitleScreen, LoadResources, LoadHeroSprites
.export PartyGenerationScreen, PartyGenerationDrawBackground, PartyGenerationDrawSprites

LoadResources:
    LDA #0
    STA backgroundCHRBank0
    LDA #1
    STA backgroundCHRBank1
    LDA #2
    STA backgroundCHRBank2
    LDA #3
    STA backgroundCHRBank3
    LDA #4
    STA spriteCHRBank0
    LDA #5
    STA spriteCHRBank1
    LDA #6
    STA spriteCHRBank2
    LDA #7
    STA spriteCHRBank3
    LDA #8
    STA spriteCHRBank4
    LDA #9
    STA spriteCHRBank5
    LDA #10
    STA spriteCHRBank6
    LDA #11
    STA spriteCHRBank7

    LDA #0
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadCHRSolids

    LDA #<TILE_FONT_PART_0
    STA Var0
    LDA #>TILE_FONT_PART_0
    STA Var1
    LDA #4
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_1
    STA Var0
    LDA #>TILE_FONT_PART_1
    STA Var1
    LDA #8
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_2
    STA Var0
    LDA #>TILE_FONT_PART_2
    STA Var1
    LDA #12
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_3
    STA Var0
    LDA #>TILE_FONT_PART_3
    STA Var1
    LDA #16
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_4
    STA Var0
    LDA #>TILE_FONT_PART_4
    STA Var1
    LDA #20
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_5
    STA Var0
    LDA #>TILE_FONT_PART_5
    STA Var1
    LDA #24
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_6
    STA Var0
    LDA #>TILE_FONT_PART_6
    STA Var1
    LDA #28
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_7
    STA Var0
    LDA #>TILE_FONT_PART_7
    STA Var1
    LDA #32
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_8
    STA Var0
    LDA #>TILE_FONT_PART_8
    STA Var1
    LDA #36
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_9
    STA Var0
    LDA #>TILE_FONT_PART_9
    STA Var1
    LDA #40
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_10
    STA Var0
    LDA #>TILE_FONT_PART_10
    STA Var1
    LDA #44
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_11
    STA Var0
    LDA #>TILE_FONT_PART_11
    STA Var1
    LDA #48
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_12
    STA Var0
    LDA #>TILE_FONT_PART_12
    STA Var1
    LDA #52
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_13
    STA Var0
    LDA #>TILE_FONT_PART_13
    STA Var1
    LDA #56
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_14
    STA Var0
    LDA #>TILE_FONT_PART_14
    STA Var1
    LDA #60
    STA Var2
    LDA #0
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_15
    STA Var0
    LDA #>TILE_FONT_PART_15
    STA Var1
    LDA #0
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_16
    STA Var0
    LDA #>TILE_FONT_PART_16
    STA Var1
    LDA #4
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_FONT_PART_17
    STA Var0
    LDA #>TILE_FONT_PART_17
    STA Var1
    LDA #8
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_ICON_PART_0
    STA Var0
    LDA #>TILE_ICON_PART_0
    STA Var1
    LDA #12
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_ICON_PART_1
    STA Var0
    LDA #>TILE_ICON_PART_1
    STA Var1
    LDA #16
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_ICON_PART_2
    STA Var0
    LDA #>TILE_ICON_PART_2
    STA Var1
    LDA #20
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_ICON_PART_3
    STA Var0
    LDA #>TILE_ICON_PART_3
    STA Var1
    LDA #24
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR1

    LDA #<TILE_BORDER_EDGE
    STA Var0
    LDA #>TILE_BORDER_EDGE
    STA Var1
    LDA #25
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_BORDER_CORNER
    STA Var0
    LDA #>TILE_BORDER_CORNER
    STA Var1
    LDA #29
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_BORDER_EDGE
    STA Var0
    LDA #>TILE_BORDER_EDGE
    STA Var1
    LDA #33
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_BORDER_CONJUNCTION
    STA Var0
    LDA #>TILE_BORDER_CONJUNCTION
    STA Var1
    LDA #37
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<TILE_BORDER_SPLIT
    STA Var0
    LDA #>TILE_BORDER_SPLIT
    STA Var1
    LDA #41
    STA Var2
    LDA #1
    STA Var3
    FARCALL UploadBackgroundCHR2

    RTS

LoadHeroSprites:


    LDA #<METASPRITE_BLACK_BELT_CHR
    STA Var4
    LDA #>METASPRITE_BLACK_BELT_CHR
    STA Var5
    LDA #TextBank(METASPRITE_BLACK_BELT_CHR) 
    STA Var6
    LDA #8
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #<METASPRITE_BLACK_MAGE_CHR
    STA Var4
    LDA #>METASPRITE_BLACK_MAGE_CHR
    STA Var5
    LDA #TextBank(METASPRITE_BLACK_MAGE_CHR) 
    STA Var6
    LDA #9
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #<METASPRITE_FIGHTER_CHR
    STA Var4
    LDA #>METASPRITE_FIGHTER_CHR
    STA Var5
    LDA #TextBank(METASPRITE_FIGHTER_CHR) 
    STA Var6
    LDA #10
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #<METASPRITE_RED_MAGE_CHR
    STA Var4
    LDA #>METASPRITE_RED_MAGE_CHR
    STA Var5
    LDA #TextBank(METASPRITE_RED_MAGE_CHR) 
    STA Var6
    LDA #11
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #<METASPRITE_THIEF_CHR
    STA Var4
    LDA #>METASPRITE_THIEF_CHR
    STA Var5
    LDA #TextBank(METASPRITE_THIEF_CHR) 
    STA Var6
    LDA #12
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #<METASPRITE_WHITE_MAGE_CHR
    STA Var4
    LDA #>METASPRITE_WHITE_MAGE_CHR
    STA Var5
    LDA #TextBank(METASPRITE_WHITE_MAGE_CHR) 
    STA Var6
    LDA #13
    STA Var3
    LDA #0
    STA Var2
    FARCALL UploadMetaSprite

    RTS

DrawTitleScreen:

    LDA #0
    STA Var0
    FARCALL FillAttributeTable
 
    LDA #0
    STA Var0
    FARCALL FillNametable
    FARCALL ClearSprites

    FARCALL RestoreNineSliceBordersToDefault

    LDA #<METASPRITE_CURSOR_CHR
    STA Var4
    LDA #>METASPRITE_CURSOR_CHR
    STA Var5
    LDA #TextBank(METASPRITE_CURSOR_CHR) 
    STA Var6
    LDA #4 ; CHR bank 4
    STA Var3
    LDA #0 ; CHR offset 0
    STA Var2
    FARCALL UploadMetaSprite

    LDA #$0
    STA palette0+0
    LDA #$1
    STA palette0+1
    LDA #$30
    STA palette0+2
    FARCALL UploadPalette0

    LDA #$0F
    STA palette4+0
    LDA #$10
    STA palette4+1
    LDA #$20
    STA palette4+2
    FARCALL UploadPalette4

    LDA #11
    STA drawX
    LDA #11
    STA drawY
    LDA #10
    STA drawWidth
    LDA #3
    STA drawHeight
    FARCALL DrawNineSlice

    LDA #11
    STA drawX
    LDA #16
    STA drawY
    LDA #10
    STA drawWidth
    LDA #3
    STA drawHeight
    FARCALL DrawNineSlice

    LDA #8
    STA drawX
    LDA #21
    STA drawY
    LDA #16
    STA drawWidth
    LDA #3
    STA drawHeight
    FARCALL DrawNineSlice

    POS         12, 12 
    TEXT        TEXT_TITLE_CONTINUE

    POS         12, 17
    TEXT        TEXT_TITLE_NEW_GAME

    POS         9, 22
    TEXT        TEXT_TITLE_RESPOND_RATE

    POS         8, 25
    TEXT        TEXT_TITLE_COPYRIGHT_SQUARE

    POS         8, 26
    TEXT        TEXT_TITLE_COPYRIGHT_NINTENDO

    RTS

PartyGenerationScreen:
    LDA #1
    STA Var0
    FARCALL FillNametable
    CALL PartyGenerationDrawBackground
    @loop:

        CALL PartyGenerationDrawSprites


        FARCALL MusicPlay
        CALL WaitForVBlank

    JUMP @loop
    RTS

PartyGenerationDrawBackground:

    FARCALL RestoreNineSliceBordersToDefault

    ; Hero 1
    LDA #1
    STA drawX
    LDA #2
    STA drawY
    LDA #20
    STA drawWidth
    LDA #5
    STA drawHeight
    FARCALL DrawNineSlice

    ; Hero 2
    LDA #1
    STA drawX
    LDA #9
    STA drawY
    LDA #20
    STA drawWidth
    LDA #5
    STA drawHeight
    FARCALL DrawNineSlice

    ; Hero 3
    LDA #1
    STA drawX
    LDA #16
    STA drawY
    LDA #20
    STA drawWidth
    LDA #5
    STA drawHeight
    FARCALL DrawNineSlice

    ; Hero 4
    LDA #1
    STA drawX
    LDA #23
    STA drawY
    LDA #20
    STA drawWidth
    LDA #5
    STA drawHeight
    FARCALL DrawNineSlice

    ; Menu
    LDA #23
    STA drawX
    LDA #1
    STA drawY
    LDA #8
    STA drawWidth
    LDA #3
    STA drawHeight
    FARCALL DrawNineSlice


    ; Set the generic "print item name" string to be our active one
    LDA #23
    STA drawX
    LDA #1
    STA drawY
    LDA #<TEXT_TITLE_START
    STA Var0
    LDA #>TEXT_TITLE_START
    STA Var1
    LDA #TextBank(TEXT_TITLE_START)
    STA Var2

    ; Write the string
    FARCALL Stringify


    LDA #23
    STA drawX
    LDA #5
    STA drawY
    LDA #8
    STA drawWidth
    LDA #3
    STA drawHeight
    FARCALL DrawNineSlice

    RTS

PartyGenerationDrawSprites:

    LDA #20
    STA drawX
    LDA #20
    STA drawY

    ; hFlip and vFlip
    LDA #0
    STA drawVars+0

    ; CHR offset
    LDA #0
    STA drawVars+1

    LDX #0
    LDY #METASPRITE_BLACK_BELT
    FARCALL DrawSprite

    RTS