.include "src/variables.inc"
.include "src/macros.inc"
.include "src/constants.inc"
.include "ram-definitions.inc"
.segment "BANK_13"
BANK_THIS = $13
;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

