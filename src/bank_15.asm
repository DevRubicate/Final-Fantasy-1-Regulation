.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $15

.segment "BANK_15"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

