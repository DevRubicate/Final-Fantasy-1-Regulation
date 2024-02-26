.segment "BANK_20"

.include "src/global-import.inc"

.import Impl_FARPPUCOPY, LUT_Battle_Backdrop_0, LUT_Battle_Backdrop_1

.export LoadBattleBackdropCHR








LUT_BtlBackdrops:
    .byte $00, $09, $09, $04, $04, $04, $00, $03, $00, $ff, $ff, $ff, $ff, $ff, $08, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $03, $03, $03, $ff, $ff, $09, $09, $0b, $06, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $00, $03, $00, $09, $09, $0d, $ff, $ff, $ff, $02
    .byte $ff, $ff, $02, $ff, $02, $02, $06, $06, $09, $09, $02, $00, $ff, $ff, $ff, $00
    .byte $0a, $0a, $06, $06, $0a, $06, $0f, $ff, $ff, $00, $03, $ff, $00, $00, $00, $ff
    .byte $0a, $0a, $06, $06, $00, $07, $00, $05, $05, $00, $00, $ff, $ff, $0c, $ff, $ff
    .byte $00, $00, $07, $07, $0e, $0e, $02, $02, $02, $02, $02, $ff, $02, $00, $01, $ff
    .byte $00, $00, $07, $07, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


LoadBattleBackdropCHR:

    LDX ow_tile                   ; Get last OW tile we stepped on
    LDA LUT_BtlBackdrops, X       ; Use it as an index to get the backdrop ID
    AND #$0F     ; mask with $0F (there are only 16 battle BGs)

    CMP #8
    BCS @alternative

    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2

    LDA #<(LUT_Battle_Backdrop_0 - $E0)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_0 - $E0)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1

    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPUADDR   ; write high byte of dest address
    STA PPUADDR   ; write low byte:  0

    LDA #(.bank(LUT_Battle_Backdrop_0) * 2) | %10000000
    LDY #$E0
    LDX #2                  ; normally 1 row but we are starting under
    JUMP Impl_FARPPUCOPY

    @alternative:

    AND #%00000111
    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2

    LDA #<(LUT_Battle_Backdrop_1 - $E0)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_1 - $E0)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1

    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPUADDR   ; write high byte of dest address
    STA PPUADDR   ; write low byte:  0

    LDA #(.bank(LUT_Battle_Backdrop_1) * 2) | %10000000
    LDY #$E0
    LDX #2                  ; normally 1 row but we are starting under
    JUMP Impl_FARPPUCOPY
