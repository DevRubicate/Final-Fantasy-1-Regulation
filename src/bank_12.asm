.include "src/variables.inc"
.include "src/macros.inc"
.include "src/constants.inc"
.include "ram-definitions.inc"
.segment "BANK_12"
BANK_THIS = $12
;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

