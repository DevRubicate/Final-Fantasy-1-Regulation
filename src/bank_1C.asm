.include "src/variables.inc"
.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $1C

.segment "BANK_1C"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

