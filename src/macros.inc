;;
;;  macro for LDAing an immediate value, then always branching
;;
.macro LDABRA v, lbl
        LDA #v
    .if v = 0
        BEQ lbl
    .else
        BNE lbl
    .endif
.endmacro

.define TextBank(_address) (.bank(_address) | %10000000)

;;
;;  macro for quick page boundary assertions
;;

.MACRO VIDEO_UPDATE_SUBROUTINE_PAGE_CHECK
    .assert (<*) < $FB, error, "Video update subroutine is aligned on page boundary"
.ENDMACRO

 ; for critical page checks (absolutely should cross page boundary)
.macro CRITPAGECHECK lbl
    .assert >* = >lbl, error, "Critical timing loop crosses page boundary"
.endmacro

 ; for noncritical page checks (crossing page boundary *might* be a problem)
.macro PAGECHECK lbl
    .assert >* = >lbl, warning, "Noncritical timing loop crosses page boundary"
.endmacro

.macro DEBUG
    .byte $1A
.endmacro

.macro ERROR
    .byte $1A
.endmacro

.macro SWITCH _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF && .bank(*) = $FF, warning, "SWITCH: Invalid use of bank switch"
    PHA
    LDA #(<.bank(_address)) | %10000000
    STA current_bank1
    STA MMC5_PRG_BANK1
    PLA
.endmacro

.macro SWITCHDATA _address
    LDA #( (124 + <((_address - $C000) / $2000) ) | %10000000)
    STA MMC5_PRG_BANK2   ; Swap to the desired page
.endmacro

.macro POS _x, _y
    LDA #(_x)
    STA stringwriterDestX
    LDA #(_y)
    STA stringwriterDestY
.endmacro

.macro POSX _x
    LDA #(_x)
    STA stringwriterDestX
.endmacro

.macro POSY _y
    LDA #(_y)
    STA stringwriterDestY
.endmacro

.macro MOVEX _x
    LDA stringwriterDestX
    CLC
    ADC #(_x)
    STA stringwriterDestX
.endmacro

.macro MOVEY _y
    LDA stringwriterDestY
    CLC
    ADC #(_y)
    STA stringwriterDestY
.endmacro

.macro TEXT _address
    .import Stringify
    
    LDA #<_address
    STA Var0
    LDA #>_address
    STA Var1
    LDA #( .bank(_address) | %10000000)
    STA Var2
    FARCALL Stringify
.endmacro

.macro BOX _w, _h
    .import RenderBox

    LDA #(_w-2)
    STA box_wd
    LDA #(_h-2)
    STA box_ht
    FARCALL RenderBox
.endmacro

.macro CALL _address
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "CALL: Address on different bank, use FARCALL instead"
    JSR _address
.endmacro

.macro FARCALL _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF, warning, "FARCALL: Address reachable without a bankswitch, use CALL instead"
    JSR Impl_FARCALL
    .byte >(_address)
    .byte <(_address)
    .byte (<.bank(_address)) | %10000000
.endmacro

.macro FORCEDFARCALL _address
    JSR Impl_FARCALL
    .byte >(_address)
    .byte <(_address)
    .byte (<.bank(_address)) | %10000000
.endmacro

.macro JUMP _address
    .assert _address <> * + 3, warning, "JUMP: Address is right after jump, use NOJUMP instead"
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "JUMP: Address on different bank, use FARJUMP instead"
    JMP _address
.endmacro

.macro FARJUMP _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF, warning, "FARJUMP: Address reachable without a bankswitch, use JUMP instead"
    JSR Impl_FARCALL
    .byte >(_address)
    .byte <(_address)
    .byte (<.bank(_address)) | %10000000
    RTS
.endmacro

.macro NOJUMP _address
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "NOJUMP: Address on different bank, use FARJUMP instead"
    .assert _address = *, warning, "NOJUMP: Address is not right after jump, use JUMP instead"
.endmacro

.macro NAKEDJUMP _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF, warning, "NAKEDJUMP: Address reachable without a bankswitch, use JUMP instead"
    LDA #(<.bank(_address)) | %10000000
    LDX #>(_address)
    LDY #<(_address)
    JSR Impl_NAKEDJUMP
.endmacro


.macro FIXEDCALL _address, _bank
    .assert .bank(_address) = $FF, warning, "FIXEDCALL: Address must be in fixed bank"
    JSR Impl_FARCALL
    .byte >(_address)
    .byte <(_address)
    .byte _bank | %10000000
.endmacro

