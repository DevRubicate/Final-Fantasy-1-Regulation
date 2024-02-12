.include "src/variables.inc"
.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $11

.segment "BANK_11"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

