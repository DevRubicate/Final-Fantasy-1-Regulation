.segment "PRG_112"

.include "src/global-import.inc"

.import UploadBackgroundCHR4, UploadBackgroundCHR2, UploadBackgroundCHR1, UploadCHRSolids, UploadPalette0, UploadPalette1, UploadPalette2, UploadPalette3

    LDA #16
    STA backgroundCHRBank0
    LDA #17
    STA backgroundCHRBank1
    LDA #18
    STA backgroundCHRBank2
    LDA #19
    STA backgroundCHRBank3

    LDA #0
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadCHRSolids

    LDA #<MAP_TILE_GRASS_0
    STA Var0
    LDA #>MAP_TILE_GRASS_0
    STA Var1
    LDA #4
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_GRASS_1
    STA Var0
    LDA #>MAP_TILE_GRASS_1
    STA Var1
    LDA #8
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_GRASS_2
    STA Var0
    LDA #>MAP_TILE_GRASS_2
    STA Var1
    LDA #12
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_GRASS_3
    STA Var0
    LDA #>MAP_TILE_GRASS_3
    STA Var1
    LDA #16
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_4
    STA Var0
    LDA #>MAP_TILE_4
    STA Var1
    LDA #20
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_5
    STA Var0
    LDA #>MAP_TILE_5
    STA Var1
    LDA #24
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_6
    STA Var0
    LDA #>MAP_TILE_6
    STA Var1
    LDA #28
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_7
    STA Var0
    LDA #>MAP_TILE_7
    STA Var1
    LDA #32
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_8
    STA Var0
    LDA #>MAP_TILE_8
    STA Var1
    LDA #36
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_9
    STA Var0
    LDA #>MAP_TILE_9
    STA Var1
    LDA #40
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_10
    STA Var0
    LDA #>MAP_TILE_10
    STA Var1
    LDA #44
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_11
    STA Var0
    LDA #>MAP_TILE_11
    STA Var1
    LDA #48
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_12
    STA Var0
    LDA #>MAP_TILE_12
    STA Var1
    LDA #52
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_13
    STA Var0
    LDA #>MAP_TILE_13
    STA Var1
    LDA #56
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_14
    STA Var0
    LDA #>MAP_TILE_14
    STA Var1
    LDA #60
    STA Var2
    LDA #16
    STA Var3
    FARCALL UploadBackgroundCHR4






    LDA #<MAP_TILE_15
    STA Var0
    LDA #>MAP_TILE_15
    STA Var1
    LDA #0
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_16
    STA Var0
    LDA #>MAP_TILE_16
    STA Var1
    LDA #4
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_17
    STA Var0
    LDA #>MAP_TILE_17
    STA Var1
    LDA #8
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_18
    STA Var0
    LDA #>MAP_TILE_18
    STA Var1
    LDA #12
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_19
    STA Var0
    LDA #>MAP_TILE_19
    STA Var1
    LDA #16
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_20
    STA Var0
    LDA #>MAP_TILE_20
    STA Var1
    LDA #20
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_21
    STA Var0
    LDA #>MAP_TILE_21
    STA Var1
    LDA #24
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_22
    STA Var0
    LDA #>MAP_TILE_22
    STA Var1
    LDA #28
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_23
    STA Var0
    LDA #>MAP_TILE_23
    STA Var1
    LDA #32
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_24
    STA Var0
    LDA #>MAP_TILE_24
    STA Var1
    LDA #36
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_25
    STA Var0
    LDA #>MAP_TILE_25
    STA Var1
    LDA #40
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_26
    STA Var0
    LDA #>MAP_TILE_26
    STA Var1
    LDA #44
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_27
    STA Var0
    LDA #>MAP_TILE_27
    STA Var1
    LDA #48
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_28
    STA Var0
    LDA #>MAP_TILE_28
    STA Var1
    LDA #52
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4

    LDA #<MAP_TILE_29
    STA Var0
    LDA #>MAP_TILE_29
    STA Var1
    LDA #56
    STA Var2
    LDA #17
    STA Var3
    FARCALL UploadBackgroundCHR4


    RTS
