.segment "PRG_074"

.include "src/global-import.inc"

.import WaitForVBlank, DrawMapPalette, LoadPlayerMapmanCHR, LoadTilesetAndMenuCHR, LoadMapObjCHR
.import ScreenWipe_Open, LoadMapObjects
.import StandardMapMovement, MusicPlay, PrepAttributePos, DoAltarEffect, DrawSMSprites, BattleTransition, LoadBattleCHRPal, LoadEpilogueSceneGFX, EnterEndingScene, ScreenWipe_Close, ScreenWipe_Close, DoOverworld
.import GetSMTargetCoords, CanTalkToMapObject, DrawMapObjectsNoUpdate, TalkToObject, ShowDialogueBox, EnterMainMenu, EnterLineupMenu, UpdateJoy
.import CanPlayerMoveSM, ClearSprites

 ;; the LUT containing the music tracks for each tileset

LUT_TilesetMusicTrack:
    .byte $47, $48, $49, $4A, $4B, $4C, $4D, $4E

LUT_BattleRates:
    .byte $0a, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $18, $08, $08, $08, $09, $0a, $0b, $0c, $01, $08, $08, $08

LUT_NormTele_X:
    .byte $0c, $14, $12, $22, $05, $0a, $1b, $3d, $19, $1e, $12, $03, $2e, $23, $20, $1e
    .byte $03, $37, $27, $06, $3b, $33, $0c, $16, $02, $17, $0e, $0c, $0c, $0a, $01, $06
    .byte $15, $2d, $0c, $3d, $2f, $36, $30, $2d, $32, $10, $08, $13, $13, $18, $03, $07
    .byte $08, $10, $01, $14, $28, $03, $0d, $01, $01, $0f, $04, $08, $0e, $17, $0c, $0c

LUT_NormTele_Y:
    .byte $12, $11, $10, $25, $06, $09, $2d, $21, $35, $20, $02, $17, $17, $06, $1f, $02
    .byte $02, $05, $06, $14, $21, $0b, $0c, $16, $02, $37, $0c, $09, $10, $0c, $14, $05
    .byte $2a, $08, $1a, $31, $27, $29, $0a, $14, $30, $1f, $01, $15, $04, $17, $03, $36
    .byte $1b, $0f, $01, $12, $01, $20, $15, $01, $04, $07, $04, $04, $14, $16, $12, $07

LUT_NormTele_Map:
    .byte $18, $34, $1b, $1b, $1c, $1d, $1e, $1f, $20, $21, $22, $23, $22, $23, $24, $25
    .byte $26, $25, $26, $0f, $26, $25, $19, $1a, $0b, $27, $19, $19, $19, $19, $19, $19
    .byte $2c, $2d, $2e, $2b, $2c, $2d, $2c, $2b, $2a, $28, $29, $2f, $30, $31, $32, $33
    .byte $37, $35, $36, $35, $34, $37, $38, $39, $3a, $3b, $19, $19, $19, $19, $08, $18

LUT_ExitTele_X:
    .byte $2a, $1e, $c5, $82, $99, $41, $bc, $3e, $c2, $00, $00, $00, $00, $00, $00, $00

LUT_ExitTele_Y:
    .byte $ae, $af, $b7, $2d, $9f, $bb, $cd, $38, $3b, $00, $00, $00, $00, $00, $00, $00

LUT_Tilesets:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $05, $02, $02, $03
    .byte $03, $03, $03, $03, $03, $03, $04, $04, $01, $01, $01, $04, $04, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $03, $03, $03, $04, $04, $05, $05, $05, $05, $05, $06
    .byte $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07, $02, $00, $00, $00


