.segment "BANK_0F"

.include "src/registers.inc"
.include "src/constants.inc"
.include "src/macros.inc"
.include "src/ram-definitions.inc"

.export Test

BANK_THIS = $0F

NOP
NOP
NOP


Test:


    RTS
