.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $1A

.segment "BANK_1A"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

