.include "src/variables.inc"
.include "ram-definitions.inc"
.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $10

.segment "BANK_10"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

