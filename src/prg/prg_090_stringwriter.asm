.segment "PRG_090"

.include "src/global-import.inc"

.import TestData

.export StringWriter

StringWriter:
    SWITCHDATA TestData
    LDY #0
    LDA TestData, Y
    ;DEBUG
    RTS
