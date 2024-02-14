.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $17

.segment "BANK_17"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

