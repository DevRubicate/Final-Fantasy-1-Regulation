.macro RESERVE label, size
    .ifndef _DEFINE_MEMORY
        .global .ident(.string(label))
    .else
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro RESERVEZP label, size
    .ifndef _DEFINE_MEMORY
        .globalzp .ident(.string(label))
    .else
        .ident(.string(label)): .res size
    .endif
.endmacro


.segment "ZEROPAGE": zeropage
; for sound channels (between Bx-Dx)
;  see constants.inc
ch_scoreptr             = $00
unused_0                = $01
ch_envptr               = $02  ; ptr to start of env data
unused_1                = $03
ch_envpos               = $04  ; pos in env data (00-1F)
ch_lenctr               = $05  ; counter for score data (note length)
ch_frqtblptr            = $06  ; pointer to freq table (changes per octave)
story_dropinput         = $07
ch_lentblptr            = $08  ; pointer to length table (changes per tempo)
unused_3                = $09
ch_envrate              = $0A  ; rate/speed of env table traversal
ch_envrem               = $0B  ; remaining "fraction" of env data (3 bits of fraction)
ch_vol                  = $0C  ; output volume
ch_loopctr              = $0D  ; remaining loop counter
inroom                  = $0D ; bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
ch_freq                 = $0E  ; output freq.  High bit set marks byte has been written (don't rewrite to reset duty)
doorppuaddr             = $0E ; 2 bytes, PPU address of door drawing work
unused_4                = $0F

.segment "STACK"
    RESERVE stack, 255
.global stack
