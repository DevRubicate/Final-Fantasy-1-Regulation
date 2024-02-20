.segment "BANK_13"

.include "src/global-import.inc"

.import CHRLoadToA, LoadMenuCHR

.export LoadTilesetAndMenuCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Standard Map Tileset and Menu CHR Loading   [$E975 :: 0x3E985]
;;
;;   Loads CHR for the tileset of the current map (Standard maps -- not OW)
;;   Also loads menu CHR
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadTilesetAndMenuCHR:
    LDA #0
    STA tmp           ; set low byte of src pointer to $00
    LDA cur_tileset   ; get current tileset
    ASL A
    ASL A
    ASL A             ; * 8 (8 rows of tiles per tileset)
    ORA #$80          ; set high byte of src pointer to $80+(tileset * 8)
    STA tmp+1
    LDA #0            ; dest address = $0000
    LDX #8            ; 8 rows to load
    FIXEDCALL CHRLoadToA, $14
    FARJUMP LoadMenuCHR

