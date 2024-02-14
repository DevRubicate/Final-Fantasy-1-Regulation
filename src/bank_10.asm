.include "src/macros.inc"
.include "src/constants.inc"
.include "src/ram-definitions.inc"

.segment "BANK_10"
BANK_THIS = $10
;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

