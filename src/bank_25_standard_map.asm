.segment "BANK_25"

.include "src/global-import.inc"

.import LoadSMCHR, LoadSMTilesetData, LoadMapPalettes, DrawFullMap, WaitForVBlank, DrawMapPalette, SetSMScroll, GetSMTilePropNow

.export PrepStandardMap

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
    LDA @lut_TilesetMusicTrack, X ; use it to get the music track tied to this tileset
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

    ;LDA #BANK_BTLDATA           ; swap to page containging battle rates
    ;CALL SwapPRG
    LDX cur_map                 ; use current map to index the rate LUT
    LDA LUT_BattleRates+1, X    ; get this map's rate (+1 because first entry is for overworld [unused])
    STA battlerate              ; and record it

    FARJUMP GetSMTilePropNow        ; then get the properties of the current tile, and exit

 ;; the LUT containing the music tracks for each tileset

  @lut_TilesetMusicTrack:
    .byte $47, $48, $49, $4A, $4B, $4C, $4D, $4E


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUT for battle encounter rates per map  [$8C00 :: 0x2CC10]
.ALIGN $100            ; must be on page bound
LUT_BattleRates:
  .incbin "bin/0B_8C00_mapencounterrates.bin"
