.segment "BANK_25"

.include "src/global-import.inc"

.import LoadSMTilesetData, LoadMapPalettes, DrawFullMap, WaitForVBlank, DrawMapPalette, SetSMScroll, GetSMTilePropNow, LoadPlayerMapmanCHR, LoadTilesetAndMenuCHR, LoadMapObjCHR
.import ScreenWipe_Open, CyclePalettes, LoadStandardMap, LoadMapObjects


.export PrepStandardMap, RedrawDoor
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
;;  LoadStandardMapAndObjects  [$CF42 :: 0x3CF52]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadStandardMapAndObjects:
    LDA #$01
    STA mapflags          ; set the standard map flag

    LDA #0
    STA PPUCTRL             ; disable NMIs
    STA PPUMASK             ; turn off PPU

    CALL LoadStandardMap   ; decompress the map
    CALL LoadMapObjects    ; load up the objects for this map (townspeople/bats/etc)
    RTS                   ; exit
