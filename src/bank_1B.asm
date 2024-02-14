.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $1B

.segment "BANK_1B"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

