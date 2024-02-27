.segment "BANK_25"

.include "src/global-import.inc"

.import LoadSMTilesetData, LoadMapPalettes, DrawFullMap, WaitForVBlank, DrawMapPalette, SetSMScroll, GetSMTilePropNow, LoadPlayerMapmanCHR, LoadTilesetAndMenuCHR, LoadMapObjCHR
.import ScreenWipe_Open, CyclePalettes, LoadStandardMap, LoadMapObjects


.export PrepStandardMap, RedrawDoor, LoadEntranceTeleportData
.export EnterStandardMap, ReenterStandardMap, LoadStandardMapAndObjects

 ;; the LUT containing the music tracks for each tileset

LUT_TilesetMusicTrack:
    .byte $47, $48, $49, $4A, $4B, $4C, $4D, $4E

LUT_BattleRates:
    .byte $0a, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
    .byte $08, $08, $08, $08, $18, $08, $08, $08, $09, $0a, $0b, $0c, $01, $08, $08, $08


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Standard Map  [$CF55 :: 0x3DF65]
;;
;;    Sets up everything for entering (or re-entering) a standard map except for
;;  map decompression and object loading.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepStandardMap:
    LDA #0
    STA PPUCTRL               ; disable NMIs
    STA PPUMASK               ; turn off the PPU
    STA PAPU_NCTL1               ; ??  tries to silence noise?  This doesn't really accomplish that.

    STA joy_select          ; zero a bunch of other map and input related stuff
    STA joy_start
    STA joy_a
    STA joy_b
    STA altareffect
    STA tileprop
    STA tileprop+1
    STA entering_shop

    CALL LoadSMCHR           ; load all the necessary CHR
    FARCALL LoadSMTilesetData   ; load tileset and TSA data
    FARCALL LoadMapPalettes     ; load palettes
    CALL DrawFullMap         ; draw the map onto the screen

    LDA sm_scroll_x         ; get the map x scroll
    AND #$10                ; isolate the odd NT bit
    CMP #$10                ; move it into C
    ROL A                   ; then rotate it into bit 0
    AND #$01                ; and isolate it again (low bit this time)
    ORA #$08                ; combine with Spr-pattern-page bit
    STA NTsoft2000          ; and record as soft2000
    STA soft2000

    CALL WaitForVBlank     ; wait for vblank
    CALL DrawMapPalette      ; so we can draw the palette
    CALL SetSMScroll         ; set the scroll

    LDA #0                  ; turn PPU off (but it's already off!)
    STA PPUMASK

    LDX cur_tileset               ; get the tileset
    LDA LUT_TilesetMusicTrack, X ; use it to get the music track tied to this tileset
    STA music_track               ; play it
    STA dlgmusic_backup           ; and record it so it can be restarted later by the dialogue box

    LDA #DOWN
    STA facing              ; start the player facing downward

    LDA sm_scroll_x         ; get the scroll coords and add 7 to them to get the player position
    CLC                     ; and record that position
    ADC #7
    STA sm_player_x
    LDA sm_scroll_y
    CLC
    ADC #7
    STA sm_player_y

    LDX cur_map                 ; use current map to index the rate LUT
    LDA LUT_BattleRates+1, X    ; get this map's rate (+1 because first entry is for overworld [unused])
    STA battlerate              ; and record it

    FARJUMP GetSMTilePropNow        ; then get the properties of the current tile, and exit


LoadSMCHR:                     ; standard map -- does not any palettes
    FARCALL LoadPlayerMapmanCHR
    FARCALL LoadTilesetAndMenuCHR
    FARJUMP LoadMapObjCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Redraw Door  [$CEBA :: 0x3CECA]
;;
;;    Redraws the necessary door tile when you enter/exit rooms.
;;  It must be called during VBlank.  Note it only makes NT changes, not attribute changes.
;;  Therefore open and closed door tiles must share the same palette.
;;
;;  IN:  inroom = current state of room transition
;;       doorppuaddr = PPU address at which to redraw door graphic
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RedrawDoor_Exit:
    RTS

RedrawDoor:
    LDA inroom                 ; check inroom status
    BEQ RedrawDoor_Exit        ; if not inroom, no redrawing required
    BMI RedrawDoor_Exit        ; if already inroom, no redrawing required (redraw only needed for the transition)

    AND #$07                   ; mask out the low bits
    CMP #$01
    BEQ @NormalOpen            ; if $01 -> opening a normal door
    CMP #$02
    BEQ @LockedOpen            ; $02 -> opening a locked door
    CMP #$05
    BEQ @NormalClose           ; $05 -> closing a normal door
                               ; else ($06) -> closing a locked door

  @LockedClose:
    LDA #$00                   ; new inroom status ($00 because we're leaving rooms)
    LDX #MAPTILE_LOCKEDDOOR    ; tile we're to draw
    JUMP @Redraw                ; redraw it

  @NormalClose:
    LDA #$00                   ; same...
    LDX #MAPTILE_CLOSEDDOOR    ; but use normal closed door tile instead of the locked door tile
    JUMP @Redraw

  @LockedOpen:
    LDA #$82                   ; $82 indicates inroom, but shows outroom sprites (locked rooms)
    LDX #MAPTILE_OPENDOOR
    JUMP @Redraw

  @NormalOpen:
    LDA #$81                   ; $81 indicates inroom and shows inroom sprites (normal rooms)
    LDX #MAPTILE_OPENDOOR

  @Redraw:
    STA inroom             ; record new inroom status (previously stuffed in A)
    LDA PPUSTATUS              ; reset PPU toggle

    LDA doorppuaddr+1      ; load the target PPU address
    STA PPUADDR
    LDA doorppuaddr
    STA PPUADDR
    LDA tsa_ul, X          ; and redraw upper two TSA tiles using the current tileset tsa data in RAM
    STA PPUDATA
    LDA tsa_ur, X
    STA PPUDATA

    LDA doorppuaddr+1      ; reload target PPU address
    STA PPUADDR
    LDA doorppuaddr
    ORA #$20               ; but add $20 to it to put it on the second row of the tile (bottom half)
    STA PPUADDR
    LDA tsa_dl, X          ; and redraw lower two TSA tiles
    STA PPUDATA
    LDA tsa_dr, X
    STA PPUDATA

    JUMP DrawMapPalette     ; then redraw the map palette (since inroom changed, so did the palette)
                           ;  and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Standard Map  [$CF2E :: 0x3CF3E]
;;
;;    Called when entering a standard map for the first time, or when
;;  changing standard maps.  Map needs to be decompressed and all objects
;;  reloaded.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterStandardMap:
    CALL LoadStandardMapAndObjects   ; decompress the map, load objects
    CALL PrepStandardMap             ; draw it, do other prepwork
    FARJUMP ScreenWipe_Open             ; do the screen wipe effect and exit once map is visible

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Reenter Standard Map  [$CF3A :: 0x3CF4A]
;;
;;    Called to reenter (but not reload) a standard map.  Like when you exit
;;  a shop or menu... the map and objects haven't changed, but the map
;;  needs to be redrawn and such.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReenterStandardMap:
    CALL PrepStandardMap   ; do map preparation stuff (redraw, etc)
    LDA #$03              ; then do palette cycling effect code 3 (standard map -- cycling in)
    JUMP CyclePalettes     ;  and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LoadStandardMapAndObjects
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadStandardMapAndObjects:
    LDA #$01
    STA mapflags          ; set the standard map flag

    LDA #0
    STA PPUCTRL             ; disable NMIs
    STA PPUMASK             ; turn off PPU

    FORCEDFARCALL LoadStandardMap   ; decompress the map
    FORCEDFARCALL LoadMapObjects    ; load up the objects for this map (townspeople/bats/etc)

    RTS                   ; exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LoadTeleportData
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadEntranceTeleportData:
    LDX tileprop+1          ; get the teleport ID in X for indexing teleport data

    LDA LUT_NormTele_X, X   ; get the X coord to teleport to
    SEC                     ;  subtract 7 from desired player coord
    SBC #7                  ;  and wrap to get scroll pos
    AND #$3F
    STA sm_scroll_x

    LDA LUT_NormTele_Y, X   ; do same with Y coord
    SEC
    SBC #7
    AND #$3F
    STA sm_scroll_y

    LDA LUT_NormTele_Map, X ; get the map and record it
    STA cur_map

    TAX                     ; then throw the map in X, and use it to get
    LDA LUT_Tilesets, X     ; the tileset for this map
    STA cur_tileset
    RTS

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
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

LUT_EntrTele_X:
    .byte $00, $0f, $12, $00, $13, $18, $1a, $0f, $0c, $0c, $05, $08, $1d, $0b, $17, $14
    .byte $01, $15, $00, $14, $1c, $0b, $1b, $1b, $12, $12, $12, $04, $04, $04, $04, $00

LUT_EntrTele_Y:
    .byte $07, $07, $01, $08, $0b, $07, $01, $07, $08, $00, $00, $07, $0b, $07, $0b, $07
    .byte $07, $07, $07, $09, $0b, $03, $01, $02, $01, $0a, $11, $11, $11, $11, $11, $0a

LUT_EntrTele_Map:
    .byte $0b, $01, $09, $0a, $19, $19, $19, $19, $18, $19, $19, $19, $19, $19, $19, $19
    .byte $19, $19, $19, $18, $18, $19, $19, $11, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c

LUT_ExitTele_X:
    .byte $0c, $0c, $0c, $0c, $10, $10, $10, $10, $0a, $0a, $0a, $0b, $0a, $0a, $0b, $0a

LUT_ExitTele_Y:
    .byte $0a, $0a, $01, $01, $0c, $07, $13, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b, $0b

LUT_Tilesets:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $05, $02, $02, $03
    .byte $03, $03, $03, $03, $03, $03, $04, $04, $01, $01, $01, $04, $04, $02, $02, $02
    .byte $02, $02, $02, $02, $02, $03, $03, $03, $04, $04, $05, $05, $05, $05, $05, $06
    .byte $06, $06, $06, $06, $07, $07, $07, $07, $07, $07, $07, $07, $02, $00, $00, $00
