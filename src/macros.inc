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


;;
;;  macro for quick page boundary assertions
;;

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

.macro CALL _address
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "CALL: Address on different bank, use FARCALL instead"
    JSR _address
.endmacro

.macro FARCALL _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF, warning, "FARCALL: Address reachable without a bankswitch, use CALL instead"
    JSR Impl_FARCALL
    .byte >(_address - 1)
    .byte <(_address - 1)
    .byte ((<.bank(_address)) * 2) | %10000000
.endmacro

.macro JUMP _address
    .assert _address <> * + 3, warning, "JUMP: Address is right after jump, use NOJUMP instead"
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "JUMP: Address on different bank, use FARJUMP instead"
    JMP _address
.endmacro

.macro FARJUMP _address
    .assert .bank(_address) <> .bank(*) && .bank(_address) <> $FF, warning, "FARJUMP: Address reachable without a bankswitch, use JUMP instead"
    JSR Impl_FARJUMP
    .byte >(_address - 1)
    .byte <(_address - 1)
    .byte ((<.bank(_address)) * 2) | %10000000
.endmacro

.macro NOJUMP _address
    .assert .bank(_address) = .bank(*) || .bank(_address) = $FF, warning, "NOJUMP: Address on different bank, use FARJUMP instead"
    .assert _address = *, warning, "NOJUMP: Address is not right after jump, use JUMP instead"
.endmacro

.macro FIXEDCALL _address, _bank
    .assert .bank(_address) = $FF, warning, "FIXEDCALL: Address must be in fixed bank"
    JSR Impl_FARCALL
    .byte >(_address - 1)
    .byte <(_address - 1)
    .byte (_bank * 2) | %10000000
.endmacro
