.segment "PRG_108"

.include "src/global-import.inc"

.import UploadPalette0, FillAttributeTable, FillNametable, UploadFont, UploadNineSliceBorders, RestoreNineSliceBordersToDefault
.import DrawNineSlice, TEXT_TITLE_CONTINUE, TEXT_TITLE_RESPOND_RATE, TEXT_TITLE_COPYRIGHT_SQUARE, TEXT_TITLE_COPYRIGHT_NINTENDO, UploadSpriteCHR3, UploadSpriteCHR3, UploadPalette4, ClearSprites
.import TEXT_TITLE_NEW_GAME

.import UploadCHRSolids, UploadBackgroundCHR1, UploadBackgroundCHR2, UploadBackgroundCHR4


.export DrawTitleScreen, LoadResources


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

DrawTitleScreen:

    LDA #0
    STA Var0
    FARCALL FillAttributeTable
 
    LDA #0
    STA Var0
    FARCALL FillNametable
    FARCALL ClearSprites

    FARCALL RestoreNineSliceBordersToDefault

    LDA #<TILE_CURSOR_0
    STA Var0
    LDA #>TILE_CURSOR_0
    STA Var1
    LDA #$0
    STA Var2
    LDA #8
    STA Var3
    FARCALL UploadSpriteCHR3

    LDA #<TILE_CURSOR_1
    STA Var0
    LDA #>TILE_CURSOR_1
    STA Var1
    LDA #$3
    STA Var2
    LDA #8
    STA Var3
    FARCALL UploadSpriteCHR3

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
