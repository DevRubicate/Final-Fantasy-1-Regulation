.include "src/variables.inc"
.include "src/macros.inc"
.include "src/constants.inc"
.include "ram-definitions.inc"
.segment "BANK_0F"
BANK_THIS = $0F
;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

