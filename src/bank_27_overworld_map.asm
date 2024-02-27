.segment "BANK_27"

.include "src/global-import.inc"

.import LoadOWBGCHR, LoadPlayerMapmanCHR, LoadOWObjectCHR

.export LoadOWCHR

LoadOWCHR:                     ; overworld map -- does not load any palettes
    FARCALL LoadOWBGCHR
    FARCALL LoadPlayerMapmanCHR
    FARJUMP LoadOWObjectCHR
