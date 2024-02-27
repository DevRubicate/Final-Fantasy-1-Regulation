.segment "BANK_26"

.include "src/global-import.inc"

.export LoadMapPalettes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Map Palettes  [$D8AB :: 0x3D8BB]
;;
;;    Note palettes are not loaded from ROM, but rather they're loaded from
;;  the load_map_pal temporary buffer (temporary because it gets overwritten
;;  due to it sharing space with draw_buf).  So this must be called pretty much
;;  immediately after the tileset is loaded.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadMapPalettes:
    LDX #$2F                ; X is loop counter
    @Loop:
        LDA load_map_pal, X   ; copy colors from temp palette buffer
        STA cur_pal, X        ; to our actual palette
        DEX
        BPL @Loop             ; loop until X wraps ($30 iterations)

    LDA ch_class            ; get lead party member's class
    ASL A                   ; double it, and put it in X
    TAX

    LDA LUT_MapmanPalettes, X   ; use that as an index to get that class's mapman palette
    STA cur_pal+$12
    LDA LUT_MapmanPalettes+1, X
    STA cur_pal+$16

    RTS                     ; then exit

LUT_MapmanPalettes:
    .byte $16, $16, $12, $17, $27, $12, $16, $16, $30, $30, $27, $12, $16, $16, $16, $16
    .byte $27, $12, $16, $16, $16, $30, $27, $13, $00, $00, $00, $00, $00, $00, $00, $00
