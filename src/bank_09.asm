.segment "BANK_09"

.include "src/global-import.inc"

.export EnterMinimap
.import MinimapDecompress, UpdateJoy, MusicPlay, DrawPalette, WaitForVBlank

.incbin "bin/bank_09_data.bin"


BANK_THIS = $09

  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $0E
  .byte $01
  .byte $2B
  .byte $2E
  .byte $07
  .byte $1F
  .byte $1F
  .byte $17
  .byte $0E
  .byte $00
  .byte $20
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A0
  .byte $00
  .byte $84
  .byte $3A
  .byte $80
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $74
  .byte $7A
  .byte $6D
  .byte $73
  .byte $37
  .byte $DB
  .byte $CB
  .byte $0F
  .byte $07
  .byte $07
  .byte $20
  .byte $10
  .byte $D0
  .byte $39
  .byte $29
  .byte $0F
  .byte $07
  .byte $07
  .byte $FE
  .byte $FE
  .byte $FC
  .byte $EB
  .byte $F7
  .byte $E2
  .byte $F0
  .byte $F0
  .byte $72
  .byte $60
  .byte $E3
  .byte $C4
  .byte $F0
  .byte $EC
  .byte $CC
  .byte $C8
  .byte $07
  .byte $03
  .byte $03
  .byte $00
  .byte $01
  .byte $01
  .byte $03
  .byte $07
  .byte $07
  .byte $03
  .byte $03
  .byte $01
  .byte $01
  .byte $01
  .byte $03
  .byte $07
  .byte $C0
  .byte $C0
  .byte $E0
  .byte $20
  .byte $C0
  .byte $E0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $C0
  .byte $C0
  .byte $07
  .byte $0F
  .byte $02
  .byte $1C
  .byte $3C
  .byte $FC
  .byte $78
  .byte $18
  .byte $07
  .byte $0F
  .byte $1E
  .byte $1E
  .byte $3C
  .byte $FC
  .byte $78
  .byte $18
  .byte $F0
  .byte $78
  .byte $34
  .byte $0E
  .byte $0F
  .byte $0F
  .byte $0E
  .byte $1C
  .byte $F0
  .byte $7C
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $0F
  .byte $0E
  .byte $1C
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $0E
  .byte $01
  .byte $2B
  .byte $2E
  .byte $07
  .byte $1F
  .byte $1F
  .byte $17
  .byte $0E
  .byte $00
  .byte $20
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A0
  .byte $00
  .byte $84
  .byte $3A
  .byte $80
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $74
  .byte $7A
  .byte $6D
  .byte $73
  .byte $37
  .byte $DB
  .byte $CB
  .byte $0F
  .byte $07
  .byte $07
  .byte $20
  .byte $10
  .byte $D0
  .byte $39
  .byte $29
  .byte $0F
  .byte $07
  .byte $07
  .byte $FE
  .byte $FE
  .byte $FC
  .byte $EB
  .byte $F7
  .byte $E2
  .byte $F0
  .byte $F0
  .byte $72
  .byte $60
  .byte $E3
  .byte $C4
  .byte $F0
  .byte $EC
  .byte $CC
  .byte $C8
  .byte $07
  .byte $0F
  .byte $02
  .byte $1C
  .byte $3C
  .byte $FC
  .byte $78
  .byte $18
  .byte $07
  .byte $0F
  .byte $1E
  .byte $1E
  .byte $3C
  .byte $FC
  .byte $78
  .byte $18
  .byte $F0
  .byte $78
  .byte $34
  .byte $0E
  .byte $0F
  .byte $0F
  .byte $0E
  .byte $1C
  .byte $F0
  .byte $7C
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $0F
  .byte $0E
  .byte $1C
  .byte $00
  .byte $C0
  .byte $C0
  .byte $08
  .byte $0E
  .byte $C1
  .byte $EB
  .byte $EE
  .byte $07
  .byte $1F
  .byte $1F
  .byte $97
  .byte $CE
  .byte $00
  .byte $20
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A0
  .byte $00
  .byte $84
  .byte $3A
  .byte $80
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $E0
  .byte $74
  .byte $7A
  .byte $ED
  .byte $73
  .byte $37
  .byte $1B
  .byte $1B
  .byte $0F
  .byte $07
  .byte $07
  .byte $20
  .byte $30
  .byte $30
  .byte $19
  .byte $19
  .byte $0F
  .byte $07
  .byte $07
  .byte $FE
  .byte $FE
  .byte $FC
  .byte $EB
  .byte $F7
  .byte $E2
  .byte $F0
  .byte $F0
  .byte $72
  .byte $60
  .byte $E3
  .byte $C4
  .byte $F0
  .byte $EC
  .byte $CC
  .byte $C8
  .byte $0E
  .byte $0E
  .byte $1E
  .byte $04
  .byte $38
  .byte $38
  .byte $78
  .byte $F0
  .byte $0E
  .byte $0E
  .byte $1E
  .byte $1C
  .byte $3C
  .byte $38
  .byte $78
  .byte $F0
  .byte $E0
  .byte $F0
  .byte $70
  .byte $60
  .byte $18
  .byte $1C
  .byte $1E
  .byte $0F
  .byte $E0
  .byte $F0
  .byte $70
  .byte $78
  .byte $38
  .byte $1C
  .byte $1E
  .byte $0F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $0F
  .byte $1F
  .byte $1F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $F0
  .byte $0E
  .byte $8F
  .byte $F2
  .byte $BB
  .byte $77
  .byte $6B
  .byte $FC
  .byte $FF
  .byte $19
  .byte $97
  .byte $F0
  .byte $B0
  .byte $30
  .byte $28
  .byte $1C
  .byte $1F
  .byte $41
  .byte $CE
  .byte $2D
  .byte $5E
  .byte $D7
  .byte $83
  .byte $63
  .byte $E0
  .byte $F9
  .byte $BE
  .byte $0D
  .byte $1C
  .byte $18
  .byte $3C
  .byte $1C
  .byte $80
  .byte $F0
  .byte $FF
  .byte $47
  .byte $00
  .byte $80
  .byte $88
  .byte $DC
  .byte $7C
  .byte $00
  .byte $0F
  .byte $37
  .byte $78
  .byte $B8
  .byte $B0
  .byte $C0
  .byte $60
  .byte $5C
  .byte $E0
  .byte $DC
  .byte $3C
  .byte $38
  .byte $78
  .byte $78
  .byte $FC
  .byte $1C
  .byte $FE
  .byte $FC
  .byte $3C
  .byte $38
  .byte $78
  .byte $78
  .byte $FC
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7E
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7E
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $1F
  .byte $26
  .byte $1C
  .byte $3C
  .byte $04
  .byte $E0
  .byte $E0
  .byte $03
  .byte $1F
  .byte $23
  .byte $03
  .byte $03
  .byte $7B
  .byte $13
  .byte $01
  .byte $81
  .byte $00
  .byte $F0
  .byte $08
  .byte $04
  .byte $01
  .byte $03
  .byte $03
  .byte $A5
  .byte $7D
  .byte $FE
  .byte $FF
  .byte $FE
  .byte $FC
  .byte $F8
  .byte $F8
  .byte $CC
  .byte $F7
  .byte $FB
  .byte $C6
  .byte $B8
  .byte $98
  .byte $88
  .byte $88
  .byte $CC
  .byte $F7
  .byte $FB
  .byte $C6
  .byte $88
  .byte $20
  .byte $70
  .byte $70
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $0F
  .byte $F8
  .byte $05
  .byte $17
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $05
  .byte $07
  .byte $00
  .byte $C0
  .byte $81
  .byte $6E
  .byte $F8
  .byte $80
  .byte $80
  .byte $00
  .byte $00
  .byte $1C
  .byte $70
  .byte $80
  .byte $00
  .byte $E0
  .byte $F0
  .byte $7C
  .byte $36
  .byte $79
  .byte $99
  .byte $6B
  .byte $70
  .byte $E7
  .byte $C3
  .byte $C3
  .byte $06
  .byte $00
  .byte $04
  .byte $20
  .byte $10
  .byte $00
  .byte $C0
  .byte $C0
  .byte $AA
  .byte $A9
  .byte $B5
  .byte $E0
  .byte $1F
  .byte $9F
  .byte $FF
  .byte $F7
  .byte $54
  .byte $56
  .byte $4A
  .byte $05
  .byte $08
  .byte $00
  .byte $30
  .byte $30
  .byte $41
  .byte $41
  .byte $40
  .byte $40
  .byte $40
  .byte $40
  .byte $7D
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E7
  .byte $E7
  .byte $07
  .byte $E7
  .byte $F7
  .byte $E7
  .byte $E7
  .byte $E6
  .byte $00
  .byte $00
  .byte $E0
  .byte $10
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $47
  .byte $4F
  .byte $42
  .byte $5C
  .byte $3C
  .byte $FC
  .byte $7B
  .byte $18
  .byte $00
  .byte $00
  .byte $1C
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $F3
  .byte $7B
  .byte $33
  .byte $0B
  .byte $0B
  .byte $0B
  .byte $EB
  .byte $1A
  .byte $00
  .byte $00
  .byte $08
  .byte $10
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $0F
  .byte $F8
  .byte $05
  .byte $27
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0D
  .byte $17
  .byte $00
  .byte $C0
  .byte $81
  .byte $6E
  .byte $F8
  .byte $80
  .byte $80
  .byte $00
  .byte $00
  .byte $1C
  .byte $70
  .byte $80
  .byte $00
  .byte $E0
  .byte $FE
  .byte $79
  .byte $46
  .byte $39
  .byte $58
  .byte $4E
  .byte $40
  .byte $47
  .byte $23
  .byte $23
  .byte $36
  .byte $40
  .byte $85
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A2
  .byte $2D
  .byte $B5
  .byte $CA
  .byte $1F
  .byte $9F
  .byte $FF
  .byte $F3
  .byte $5C
  .byte $D2
  .byte $4A
  .byte $25
  .byte $08
  .byte $04
  .byte $30
  .byte $30
  .byte $27
  .byte $2F
  .byte $02
  .byte $1C
  .byte $3C
  .byte $FC
  .byte $7B
  .byte $18
  .byte $00
  .byte $00
  .byte $1C
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $F3
  .byte $7B
  .byte $33
  .byte $0B
  .byte $0B
  .byte $0B
  .byte $EB
  .byte $1A
  .byte $00
  .byte $00
  .byte $08
  .byte $10
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $0F
  .byte $F8
  .byte $85
  .byte $D7
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $85
  .byte $C7
  .byte $00
  .byte $C0
  .byte $81
  .byte $6E
  .byte $F8
  .byte $80
  .byte $80
  .byte $00
  .byte $00
  .byte $1C
  .byte $70
  .byte $80
  .byte $00
  .byte $E1
  .byte $FE
  .byte $F8
  .byte $FE
  .byte $78
  .byte $C6
  .byte $39
  .byte $C0
  .byte $F9
  .byte $FF
  .byte $FF
  .byte $C1
  .byte $07
  .byte $39
  .byte $06
  .byte $01
  .byte $06
  .byte $00
  .byte $00
  .byte $2A
  .byte $A9
  .byte $B5
  .byte $58
  .byte $07
  .byte $DB
  .byte $FB
  .byte $97
  .byte $D4
  .byte $56
  .byte $4A
  .byte $A5
  .byte $20
  .byte $20
  .byte $00
  .byte $00
  .byte $FC
  .byte $FF
  .byte $FF
  .byte $F8
  .byte $FF
  .byte $7F
  .byte $0F
  .byte $73
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $77
  .byte $EF
  .byte $9F
  .byte $7F
  .byte $FF
  .byte $FF
  .byte $FE
  .byte $FB
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $DF
  .byte $00
  .byte $00
  .byte $08
  .byte $08
  .byte $18
  .byte $10
  .byte $10
  .byte $20
  .byte $3F
  .byte $07
  .byte $21
  .byte $55
  .byte $D7
  .byte $F3
  .byte $34
  .byte $C7
  .byte $00
  .byte $18
  .byte $19
  .byte $2D
  .byte $2F
  .byte $0B
  .byte $08
  .byte $08
  .byte $F8
  .byte $E4
  .byte $0F
  .byte $A3
  .byte $DC
  .byte $BF
  .byte $7F
  .byte $E1
  .byte $00
  .byte $18
  .byte $10
  .byte $B0
  .byte $CC
  .byte $86
  .byte $66
  .byte $E0
  .byte $F8
  .byte $F7
  .byte $FB
  .byte $FA
  .byte $B8
  .byte $B8
  .byte $9F
  .byte $DC
  .byte $00
  .byte $10
  .byte $30
  .byte $20
  .byte $00
  .byte $00
  .byte $0C
  .byte $1C
  .byte $DD
  .byte $E1
  .byte $DD
  .byte $3D
  .byte $39
  .byte $79
  .byte $7B
  .byte $FD
  .byte $C0
  .byte $9E
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $06
  .byte $1E
  .byte $BE
  .byte $FE
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0F
  .byte $0F
  .byte $07
  .byte $0E
  .byte $37
  .byte $6F
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $09
  .byte $00
  .byte $40
  .byte $C0
  .byte $00
  .byte $1E
  .byte $7C
  .byte $3C
  .byte $78
  .byte $F0
  .byte $CA
  .byte $3D
  .byte $7F
  .byte $E1
  .byte $83
  .byte $C3
  .byte $87
  .byte $0F
  .byte $0D
  .byte $26
  .byte $76
  .byte $00
  .byte $00
  .byte $78
  .byte $BC
  .byte $DE
  .byte $DF
  .byte $5F
  .byte $7E
  .byte $00
  .byte $C0
  .byte $80
  .byte $40
  .byte $20
  .byte $20
  .byte $A0
  .byte $80
  .byte $00
  .byte $07
  .byte $0F
  .byte $17
  .byte $17
  .byte $08
  .byte $05
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $06
  .byte $00
  .byte $05
  .byte $07
  .byte $00
  .byte $E0
  .byte $F0
  .byte $F0
  .byte $F8
  .byte $F8
  .byte $FC
  .byte $72
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $0C
  .byte $0E
  .byte $08
  .byte $08
  .byte $08
  .byte $00
  .byte $00
  .byte $C4
  .byte $C3
  .byte $36
  .byte $50
  .byte $37
  .byte $D7
  .byte $EE
  .byte $33
  .byte $D3
  .byte $D4
  .byte $50
  .byte $50
  .byte $50
  .byte $40
  .byte $40
  .byte $40
  .byte $30
  .byte $F0
  .byte $26
  .byte $AF
  .byte $8B
  .byte $37
  .byte $B3
  .byte $8D
  .byte $F7
  .byte $37
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $37
  .byte $B7
  .byte $B7
  .byte $6D
  .byte $0E
  .byte $0B
  .byte $0C
  .byte $1F
  .byte $C0
  .byte $80
  .byte $A0
  .byte $A0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $57
  .byte $56
  .byte $4C
  .byte $30
  .byte $F8
  .byte $98
  .byte $FC
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1C
  .byte $37
  .byte $B7
  .byte $B7
  .byte $6E
  .byte $0B
  .byte $0E
  .byte $13
  .byte $01
  .byte $C0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $17
  .byte $56
  .byte $4C
  .byte $30
  .byte $F8
  .byte $18
  .byte $FC
  .byte $00
  .byte $0F
  .byte $1F
  .byte $2F
  .byte $2F
  .byte $11
  .byte $2B
  .byte $6E
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $0C
  .byte $00
  .byte $6B
  .byte $EE
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $F0
  .byte $FE
  .byte $F9
  .byte $D4
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $28
  .byte $0C
  .byte $10
  .byte $10
  .byte $10
  .byte $00
  .byte $00
  .byte $04
  .byte $03
  .byte $AC
  .byte $A1
  .byte $AF
  .byte $EE
  .byte $F3
  .byte $6F
  .byte $0B
  .byte $04
  .byte $D0
  .byte $50
  .byte $50
  .byte $40
  .byte $40
  .byte $40
  .byte $00
  .byte $F0
  .byte $2E
  .byte $8F
  .byte $2B
  .byte $B7
  .byte $B3
  .byte $AD
  .byte $CF
  .byte $37
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1C
  .byte $07
  .byte $07
  .byte $0F
  .byte $0E
  .byte $0B
  .byte $0E
  .byte $13
  .byte $01
  .byte $F0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $37
  .byte $07
  .byte $5E
  .byte $40
  .byte $30
  .byte $F8
  .byte $18
  .byte $FC
  .byte $00
  .byte $47
  .byte $8F
  .byte $D7
  .byte $97
  .byte $C8
  .byte $C5
  .byte $C7
  .byte $00
  .byte $40
  .byte $80
  .byte $C4
  .byte $86
  .byte $00
  .byte $85
  .byte $E7
  .byte $00
  .byte $E0
  .byte $F0
  .byte $F0
  .byte $F8
  .byte $FC
  .byte $FA
  .byte $71
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $0C
  .byte $CE
  .byte $48
  .byte $08
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $03
  .byte $F6
  .byte $70
  .byte $B7
  .byte $B6
  .byte $BB
  .byte $EF
  .byte $F3
  .byte $64
  .byte $51
  .byte $50
  .byte $50
  .byte $40
  .byte $40
  .byte $00
  .byte $30
  .byte $F0
  .byte $26
  .byte $AF
  .byte $8B
  .byte $37
  .byte $B3
  .byte $CD
  .byte $F7
  .byte $37
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $07
  .byte $07
  .byte $0D
  .byte $0E
  .byte $0B
  .byte $0C
  .byte $1F
  .byte $C0
  .byte $80
  .byte $A0
  .byte $A0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $57
  .byte $56
  .byte $4C
  .byte $30
  .byte $F8
  .byte $98
  .byte $FC
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $07
  .byte $0F
  .byte $1F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $40
  .byte $1F
  .byte $3F
  .byte $71
  .byte $B5
  .byte $17
  .byte $13
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $45
  .byte $E7
  .byte $E3
  .byte $DC
  .byte $FE
  .byte $EE
  .byte $E9
  .byte $10
  .byte $A8
  .byte $C0
  .byte $80
  .byte $60
  .byte $60
  .byte $E0
  .byte $E6
  .byte $07
  .byte $A3
  .byte $DD
  .byte $BF
  .byte $7F
  .byte $67
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $7F
  .byte $7F
  .byte $BF
  .byte $BF
  .byte $DE
  .byte $E5
  .byte $7F
  .byte $40
  .byte $00
  .byte $60
  .byte $60
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $5B
  .byte $9B
  .byte $6B
  .byte $6B
  .byte $1A
  .byte $FC
  .byte $FE
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1C
  .byte $E0
  .byte $9E
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $32
  .byte $61
  .byte $3F
  .byte $7F
  .byte $FF
  .byte $FE
  .byte $C5
  .byte $82
  .byte $81
  .byte $E0
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $3A
  .byte $7D
  .byte $5E
  .byte $EF
  .byte $F8
  .byte $E0
  .byte $E0
  .byte $30
  .byte $80
  .byte $40
  .byte $80
  .byte $00
  .byte $01
  .byte $07
  .byte $1F
  .byte $C7
  .byte $7F
  .byte $AF
  .byte $77
  .byte $F7
  .byte $0C
  .byte $03
  .byte $03
  .byte $1C
  .byte $1A
  .byte $07
  .byte $07
  .byte $00
  .byte $C2
  .byte $84
  .byte $80
  .byte $81
  .byte $84
  .byte $C8
  .byte $E0
  .byte $F8
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $07
  .byte $00
  .byte $05
  .byte $1F
  .byte $07
  .byte $3F
  .byte $0F
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $02
  .byte $12
  .byte $A2
  .byte $56
  .byte $EE
  .byte $DC
  .byte $C0
  .byte $F4
  .byte $FA
  .byte $EA
  .byte $5A
  .byte $26
  .byte $0E
  .byte $1C
  .byte $17
  .byte $06
  .byte $0F
  .byte $80
  .byte $6F
  .byte $EF
  .byte $EF
  .byte $EF
  .byte $10
  .byte $F0
  .byte $7F
  .byte $90
  .byte $6F
  .byte $EF
  .byte $2F
  .byte $2F
  .byte $7C
  .byte $E0
  .byte $85
  .byte $4B
  .byte $C7
  .byte $BF
  .byte $77
  .byte $77
  .byte $7C
  .byte $FF
  .byte $BD
  .byte $7B
  .byte $C7
  .byte $BF
  .byte $07
  .byte $07
  .byte $2F
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $5F
  .byte $2F
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $5F
  .byte $37
  .byte $4F
  .byte $4E
  .byte $4E
  .byte $4E
  .byte $4C
  .byte $4A
  .byte $B7
  .byte $07
  .byte $4F
  .byte $4E
  .byte $4E
  .byte $4E
  .byte $4C
  .byte $4A
  .byte $B7
  .byte $2F
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $BF
  .byte $47
  .byte $B8
  .byte $2F
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $AF
  .byte $BF
  .byte $47
  .byte $80
  .byte $37
  .byte $4F
  .byte $4E
  .byte $4E
  .byte $4E
  .byte $4C
  .byte $4A
  .byte $B7
  .byte $07
  .byte $4F
  .byte $4E
  .byte $4E
  .byte $4E
  .byte $4C
  .byte $4A
  .byte $B7
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $17
  .byte $10
  .byte $35
  .byte $1F
  .byte $07
  .byte $3F
  .byte $0F
  .byte $06
  .byte $10
  .byte $10
  .byte $38
  .byte $00
  .byte $04
  .byte $02
  .byte $12
  .byte $A2
  .byte $56
  .byte $EE
  .byte $DC
  .byte $C0
  .byte $F4
  .byte $FA
  .byte $EA
  .byte $5A
  .byte $26
  .byte $0E
  .byte $1C
  .byte $27
  .byte $66
  .byte $6F
  .byte $60
  .byte $6F
  .byte $6F
  .byte $6F
  .byte $6F
  .byte $30
  .byte $70
  .byte $6F
  .byte $60
  .byte $6F
  .byte $6F
  .byte $6F
  .byte $6F
  .byte $7C
  .byte $E0
  .byte $85
  .byte $4B
  .byte $E3
  .byte $DF
  .byte $BF
  .byte $BF
  .byte $7C
  .byte $FF
  .byte $BD
  .byte $7B
  .byte $E3
  .byte $DF
  .byte $87
  .byte $87
  .byte $2F
  .byte $2F
  .byte $2F
  .byte $2F
  .byte $0F
  .byte $0F
  .byte $0F
  .byte $1F
  .byte $2F
  .byte $2F
  .byte $2F
  .byte $2F
  .byte $0F
  .byte $0F
  .byte $0F
  .byte $1F
  .byte $BF
  .byte $A7
  .byte $A7
  .byte $A6
  .byte $A6
  .byte $A6
  .byte $A6
  .byte $D9
  .byte $A7
  .byte $A7
  .byte $A7
  .byte $A6
  .byte $A6
  .byte $A6
  .byte $A6
  .byte $D9
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $07
  .byte $80
  .byte $B5
  .byte $1F
  .byte $07
  .byte $3F
  .byte $0F
  .byte $06
  .byte $00
  .byte $00
  .byte $30
  .byte $00
  .byte $04
  .byte $02
  .byte $12
  .byte $A2
  .byte $56
  .byte $EE
  .byte $C2
  .byte $C0
  .byte $F4
  .byte $FA
  .byte $EA
  .byte $5A
  .byte $26
  .byte $0E
  .byte $1E
  .byte $B7
  .byte $00
  .byte $DF
  .byte $DF
  .byte $9F
  .byte $9F
  .byte $1F
  .byte $1F
  .byte $30
  .byte $00
  .byte $1F
  .byte $1F
  .byte $1F
  .byte $1F
  .byte $1F
  .byte $1F
  .byte $00
  .byte $78
  .byte $FC
  .byte $FE
  .byte $FE
  .byte $F6
  .byte $F6
  .byte $EE
  .byte $7C
  .byte $7E
  .byte $FE
  .byte $FE
  .byte $FE
  .byte $F6
  .byte $F6
  .byte $EE
  .byte $1F
  .byte $1F
  .byte $0F
  .byte $0F
  .byte $06
  .byte $09
  .byte $0F
  .byte $1F
  .byte $1F
  .byte $1F
  .byte $0F
  .byte $0F
  .byte $06
  .byte $09
  .byte $0F
  .byte $1F
  .byte $EE
  .byte $DE
  .byte $BC
  .byte $7C
  .byte $FE
  .byte $FE
  .byte $FE
  .byte $FF
  .byte $EE
  .byte $DE
  .byte $BC
  .byte $7C
  .byte $FE
  .byte $FE
  .byte $FE
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1F
  .byte $07
  .byte $3F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $38
  .byte $04
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $F8
  .byte $F4
  .byte $FA
  .byte $00
  .byte $10
  .byte $05
  .byte $67
  .byte $41
  .byte $FD
  .byte $FB
  .byte $F9
  .byte $1F
  .byte $1F
  .byte $32
  .byte $78
  .byte $50
  .byte $F8
  .byte $E0
  .byte $C0
  .byte $02
  .byte $22
  .byte $F2
  .byte $E2
  .byte $14
  .byte $A4
  .byte $DB
  .byte $B3
  .byte $FA
  .byte $DA
  .byte $0A
  .byte $0B
  .byte $07
  .byte $07
  .byte $1F
  .byte $37
  .byte $DE
  .byte $BF
  .byte $BF
  .byte $BE
  .byte $BE
  .byte $7F
  .byte $3F
  .byte $FF
  .byte $DE
  .byte $BF
  .byte $BF
  .byte $BE
  .byte $BE
  .byte $7F
  .byte $3F
  .byte $FF
  .byte $77
  .byte $2F
  .byte $EF
  .byte $EF
  .byte $EF
  .byte $5F
  .byte $1F
  .byte $9D
  .byte $77
  .byte $2F
  .byte $EF
  .byte $EF
  .byte $EF
  .byte $5F
  .byte $1F
  .byte $81
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $9F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $32
  .byte $E1
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $32
  .byte $ED
  .byte $07
  .byte $0E
  .byte $09
  .byte $07
  .byte $1F
  .byte $3F
  .byte $5F
  .byte $6F
  .byte $BF
  .byte $FE
  .byte $79
  .byte $F7
  .byte $7F
  .byte $3F
  .byte $5F
  .byte $0F
  .byte $C3
  .byte $7F
  .byte $FF
  .byte $FF
  .byte $9F
  .byte $E7
  .byte $F9
  .byte $FE
  .byte $C3
  .byte $7F
  .byte $FF
  .byte $FF
  .byte $9F
  .byte $E7
  .byte $F9
  .byte $FE
  .byte $C4
  .byte $C0
  .byte $80
  .byte $81
  .byte $84
  .byte $C8
  .byte $E0
  .byte $F8
  .byte $CA
  .byte $C7
  .byte $83
  .byte $9D
  .byte $9B
  .byte $D7
  .byte $E7
  .byte $F8
  .byte $00
  .byte $70
  .byte $78
  .byte $7C
  .byte $3E
  .byte $1F
  .byte $0D
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $60
  .byte $B0
  .byte $D9
  .byte $69
  .byte $33
  .byte $02
  .byte $0D
  .byte $3B
  .byte $80
  .byte $40
  .byte $21
  .byte $11
  .byte $0F
  .byte $0E
  .byte $0F
  .byte $3B
  .byte $00
  .byte $10
  .byte $10
  .byte $18
  .byte $08
  .byte $0C
  .byte $06
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $06
  .byte $07
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $04
  .byte $0E
  .byte $17
  .byte $02
  .byte $20
  .byte $30
  .byte $38
  .byte $38
  .byte $3A
  .byte $1E
  .byte $0F
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E2
  .byte $72
  .byte $3B
  .byte $1D
  .byte $0A
  .byte $76
  .byte $19
  .byte $80
  .byte $42
  .byte $22
  .byte $13
  .byte $09
  .byte $06
  .byte $76
  .byte $19
  .byte $60
  .byte $70
  .byte $78
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $05
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $60
  .byte $B2
  .byte $59
  .byte $2D
  .byte $16
  .byte $0A
  .byte $4D
  .byte $32
  .byte $80
  .byte $42
  .byte $21
  .byte $11
  .byte $0A
  .byte $06
  .byte $4D
  .byte $32
  .byte $00
  .byte $00
  .byte $18
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $10
  .byte $08
  .byte $04
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $72
  .byte $39
  .byte $1D
  .byte $0D
  .byte $02
  .byte $05
  .byte $18
  .byte $00
  .byte $82
  .byte $41
  .byte $21
  .byte $13
  .byte $0E
  .byte $05
  .byte $18
  .byte $00
  .byte $00
  .byte $00
  .byte $19
  .byte $0A
  .byte $00
  .byte $01
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $13
  .byte $07
  .byte $1F
  .byte $3F
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $B0
  .byte $60
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $E0
  .byte $04
  .byte $00
  .byte $01
  .byte $02
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $7F
  .byte $3F
  .byte $1E
  .byte $0C
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $A0
  .byte $30
  .byte $18
  .byte $0C
  .byte $02
  .byte $01
  .byte $00
  .byte $C0
  .byte $80
  .byte $40
  .byte $20
  .byte $10
  .byte $0E
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $03
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $0A
  .byte $07
  .byte $03
  .byte $00
  .byte $80
  .byte $40
  .byte $20
  .byte $1C
  .byte $0A
  .byte $07
  .byte $03
  .byte $00
  .byte $0C
  .byte $08
  .byte $06
  .byte $83
  .byte $E1
  .byte $40
  .byte $38
  .byte $18
  .byte $1D
  .byte $0D
  .byte $05
  .byte $0E
  .byte $1F
  .byte $BF
  .byte $46
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $20
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $E0
  .byte $00
  .byte $80
  .byte $40
  .byte $30
  .byte $0E
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $4E
  .byte $30
  .byte $0C
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $10
  .byte $08
  .byte $04
  .byte $06
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $20
  .byte $10
  .byte $08
  .byte $06
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $1E
  .byte $31
  .byte $21
  .byte $22
  .byte $12
  .byte $01
  .byte $1C
  .byte $7F
  .byte $7F
  .byte $F1
  .byte $E1
  .byte $E3
  .byte $73
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $40
  .byte $20
  .byte $14
  .byte $0A
  .byte $05
  .byte $02
  .byte $01
  .byte $E0
  .byte $70
  .byte $38
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $01
  .byte $60
  .byte $C0
  .byte $14
  .byte $38
  .byte $58
  .byte $0C
  .byte $06
  .byte $03
  .byte $60
  .byte $E4
  .byte $F0
  .byte $20
  .byte $9C
  .byte $0E
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $03
  .byte $C0
  .byte $E0
  .byte $70
  .byte $38
  .byte $1C
  .byte $0E
  .byte $07
  .byte $03
  .byte $80
  .byte $80
  .byte $C0
  .byte $60
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $C0
  .byte $E0
  .byte $F0
  .byte $78
  .byte $3C
  .byte $1E
  .byte $0E
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $A0
  .byte $30
  .byte $18
  .byte $0C
  .byte $06
  .byte $03
  .byte $00
  .byte $00
  .byte $F8
  .byte $3C
  .byte $1E
  .byte $0F
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $73
  .byte $53
  .byte $23
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $2C
  .byte $4C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $00
  .byte $00
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $80
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $00
  .byte $80
  .byte $40
  .byte $C0
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $01
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $02
  .byte $02
  .byte $00
  .byte $00
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $C0
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0A
  .byte $04
  .byte $0A
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $11
  .byte $00
  .byte $04
  .byte $00
  .byte $11
  .byte $00
  .byte $00
  .byte $00
  .byte $50
  .byte $20
  .byte $50
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $88
  .byte $00
  .byte $20
  .byte $00
  .byte $88
  .byte $00
  .byte $00
  .byte $00
  .byte $14
  .byte $08
  .byte $14
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $22
  .byte $00
  .byte $08
  .byte $00
  .byte $22
  .byte $00
  .byte $00
  .byte $00
  .byte $50
  .byte $20
  .byte $50
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $88
  .byte $00
  .byte $20
  .byte $00
  .byte $88
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $0E
  .byte $1E
  .byte $0E
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $05
  .byte $2F
  .byte $04
  .byte $04
  .byte $00
  .byte $00
  .byte $20
  .byte $70
  .byte $F8
  .byte $70
  .byte $20
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $20
  .byte $74
  .byte $20
  .byte $00
  .byte $60
  .byte $00
  .byte $08
  .byte $1C
  .byte $3E
  .byte $1C
  .byte $08
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $09
  .byte $5D
  .byte $08
  .byte $00
  .byte $08
  .byte $00
  .byte $20
  .byte $70
  .byte $F8
  .byte $70
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $74
  .byte $A0
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $04
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $70
  .byte $74
  .byte $00
  .byte $00
  .byte $0E
  .byte $20
  .byte $00
  .byte $20
  .byte $A8
  .byte $20
  .byte $50
  .byte $04
  .byte $54
  .byte $04
  .byte $38
  .byte $3A
  .byte $00
  .byte $00
  .byte $07
  .byte $27
  .byte $00
  .byte $00
  .byte $54
  .byte $10
  .byte $28
  .byte $02
  .byte $2A
  .byte $52
  .byte $25
  .byte $00
  .byte $00
  .byte $00
  .byte $44
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $38
  .byte $3A
  .byte $00
  .byte $00
  .byte $07
  .byte $07
  .byte $00
  .byte $10
  .byte $54
  .byte $10
  .byte $28
  .byte $02
  .byte $4A
  .byte $12
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $08
  .byte $00
  .byte $00
  .byte $04
  .byte $40
  .byte $00
  .byte $00
  .byte $10
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $02
  .byte $00
  .byte $00
  .byte $42
  .byte $00
  .byte $00
  .byte $71
  .byte $74
  .byte $00
  .byte $00
  .byte $0E
  .byte $4E
  .byte $00
  .byte $20
  .byte $A8
  .byte $20
  .byte $50
  .byte $04
  .byte $55
  .byte $A4
  .byte $4A
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $33
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $33
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $0C
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $FF
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $CC
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $CC
  .byte $FF
  .byte $FF
  .byte $30
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0C
  .byte $FF
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $63
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $63
  .byte $9C
  .byte $B1
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $FE
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $3C
  .byte $E1
  .byte $FF
  .byte $FF
  .byte $FF
  .byte $43
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $BF
  .byte $63
  .byte $BC
  .byte $73
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FE
  .byte $FC
  .byte $F8
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $FE
  .byte $FF
  .byte $E2
  .byte $87
  .byte $D0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0E
  .byte $3F
  .byte $7F
  .byte $00
  .byte $00
  .byte $00
  .byte $67
  .byte $19
  .byte $91
  .byte $CE
  .byte $9F
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $30
  .byte $F9
  .byte $FF
  .byte $00
  .byte $00
  .byte $00
  .byte $80
  .byte $EC
  .byte $CF
  .byte $36
  .byte $F9
  .byte $FF
  .byte $FF
  .byte $7F
  .byte $7F
  .byte $3C
  .byte $00
  .byte $00
  .byte $00
  .byte $7F
  .byte $7F
  .byte $BF
  .byte $1C
  .byte $C3
  .byte $1D
  .byte $63
  .byte $00
  .byte $FF
  .byte $FF
  .byte $FF
  .byte $FE
  .byte $38
  .byte $00
  .byte $00
  .byte $00
  .byte $FF
  .byte $FF
  .byte $7E
  .byte $19
  .byte $C7
  .byte $FE
  .byte $2C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $07
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $04
  .byte $0B
  .byte $0B
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $20
  .byte $D0
  .byte $D0
  .byte $07
  .byte $07
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $0B
  .byte $0B
  .byte $04
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $E0
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $D0
  .byte $D0
  .byte $20
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $03
  .byte $0F
  .byte $1F
  .byte $3F
  .byte $3F
  .byte $7F
  .byte $7F
  .byte $03
  .byte $0C
  .byte $13
  .byte $2F
  .byte $5F
  .byte $5F
  .byte $BF
  .byte $BF
  .byte $00
  .byte $C0
  .byte $F0
  .byte $F8
  .byte $FC
  .byte $FC
  .byte $FE
  .byte $FE
  .byte $C0
  .byte $30
  .byte $C8
  .byte $F4
  .byte $FA
  .byte $FA
  .byte $FD
  .byte $FD
  .byte $7F
  .byte $7F
  .byte $3F
  .byte $3F
  .byte $1F
  .byte $0F
  .byte $03
  .byte $00
  .byte $BF
  .byte $BF
  .byte $5F
  .byte $5F
  .byte $2F
  .byte $13
  .byte $0C
  .byte $03
  .byte $FE
  .byte $FE
  .byte $FC
  .byte $FC
  .byte $F8
  .byte $F0
  .byte $C0
  .byte $00
  .byte $FD
  .byte $FD
  .byte $FA
  .byte $FA
  .byte $F4
  .byte $C8
  .byte $30
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $03
  .byte $03
  .byte $00
  .byte $02
  .byte $00
  .byte $08
  .byte $02
  .byte $24
  .byte $00
  .byte $15
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $C0
  .byte $E0
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $88
  .byte $00
  .byte $90
  .byte $C8
  .byte $03
  .byte $05
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $06
  .byte $03
  .byte $2A
  .byte $00
  .byte $01
  .byte $08
  .byte $01
  .byte $00
  .byte $C0
  .byte $60
  .byte $80
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $B0
  .byte $C4
  .byte $00
  .byte $20
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $04
  .byte $01
  .byte $00
  .byte $40
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $44
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $00
  .byte $00
  .byte $40
  .byte $00
  .byte $10
  .byte $00
  .byte $40
  .byte $00
  .byte $00
  .byte $00
  .byte $40
  .byte $02
  .byte $10
  .byte $00
  .byte $24
  .byte $00
  .byte $08
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $20
  .byte $02
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $20
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $06
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $3E
  .byte $3E
  .byte $7F
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $38
  .byte $CC
  .byte $16
  .byte $BF
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $0B
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $7E
  .byte $FF
  .byte $3E
  .byte $0C
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $9C
  .byte $3E
  .byte $DC
  .byte $30
  .byte $42
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $01
  .byte $07
  .byte $00
  .byte $00
  .byte $00
  .byte $13
  .byte $00
  .byte $3E
  .byte $02
  .byte $38
  .byte $00
  .byte $00
  .byte $00
  .byte $40
  .byte $3E
  .byte $FF
  .byte $FF
  .byte $FE
  .byte $00
  .byte $00
  .byte $00
  .byte $9C
  .byte $D8
  .byte $3C
  .byte $FE
  .byte $7C
  .byte $0F
  .byte $03
  .byte $0F
  .byte $03
  .byte $00
  .byte $04
  .byte $00
  .byte $00
  .byte $F1
  .byte $3C
  .byte $93
  .byte $7C
  .byte $03
  .byte $28
  .byte $00
  .byte $00
  .byte $FF
  .byte $FE
  .byte $FE
  .byte $FF
  .byte $FC
  .byte $C0
  .byte $00
  .byte $00
  .byte $FF
  .byte $FC
  .byte $FE
  .byte $5C
  .byte $0A
  .byte $36
  .byte $08
  .byte $00
  .byte $07
  .byte $1F
  .byte $3E
  .byte $7F
  .byte $DF
  .byte $FF
  .byte $DF
  .byte $DF
  .byte $07
  .byte $18
  .byte $21
  .byte $60
  .byte $A0
  .byte $80
  .byte $A0
  .byte $A0
  .byte $80
  .byte $C0
  .byte $1E
  .byte $FF
  .byte $FE
  .byte $E1
  .byte $DE
  .byte $D0
  .byte $80
  .byte $40
  .byte $FE
  .byte $01
  .byte $01
  .byte $1F
  .byte $3E
  .byte $30
  .byte $DF
  .byte $CF
  .byte $A7
  .byte $70
  .byte $1F
  .byte $FF
  .byte $FF
  .byte $3F
  .byte $A0
  .byte $B0
  .byte $F8
  .byte $7F
  .byte $1F
  .byte $FF
  .byte $FF
  .byte $3F
  .byte $90
  .byte $A0
  .byte $20
  .byte $40
  .byte $FC
  .byte $FF
  .byte $FE
  .byte $80
  .byte $70
  .byte $60
  .byte $E0
  .byte $C0
  .byte $FC
  .byte $FF
  .byte $FE
  .byte $80
  .byte $00
  .byte $22
  .byte $72
  .byte $38
  .byte $0A
  .byte $00
  .byte $30
  .byte $02
  .byte $62
  .byte $D5
  .byte $A8
  .byte $50
  .byte $28
  .byte $40
  .byte $D0
  .byte $42
  .byte $00
  .byte $20
  .byte $68
  .byte $70
  .byte $E0
  .byte $40
  .byte $8E
  .byte $20
  .byte $30
  .byte $5C
  .byte $94
  .byte $CC
  .byte $B8
  .byte $42
  .byte $09
  .byte $02
  .byte $08
  .byte $09
  .byte $00
  .byte $01
  .byte $71
  .byte $61
  .byte $08
  .byte $00
  .byte $10
  .byte $35
  .byte $98
  .byte $60
  .byte $AB
  .byte $92
  .byte $63
  .byte $09
  .byte $40
  .byte $10
  .byte $8E
  .byte $86
  .byte $C0
  .byte $88
  .byte $04
  .byte $00
  .byte $09
  .byte $16
  .byte $05
  .byte $C9
  .byte $27
  .byte $68
  .byte $C2
  .byte $96
  .byte $80
  .byte $40
  .byte $20
  .byte $18
  .byte $1E
  .byte $0F
  .byte $0F
  .byte $07
  .byte $80
  .byte $40
  .byte $20
  .byte $10
  .byte $08
  .byte $06
  .byte $07
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $30
  .byte $F0
  .byte $E0
  .byte $F9
  .byte $01
  .byte $00
  .byte $00
  .byte $08
  .byte $10
  .byte $20
  .byte $C0
  .byte $E0
  .byte $BF
  .byte $07
  .byte $0F
  .byte $0C
  .byte $10
  .byte $20
  .byte $00
  .byte $80
  .byte $87
  .byte $03
  .byte $04
  .byte $08
  .byte $00
  .byte $20
  .byte $00
  .byte $80
  .byte $E0
  .byte $F0
  .byte $F0
  .byte $78
  .byte $18
  .byte $04
  .byte $02
  .byte $01
  .byte $C0
  .byte $E0
  .byte $60
  .byte $10
  .byte $08
  .byte $04
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $03
  .byte $03
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $01
  .byte $02
  .byte $05
  .byte $05
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $E0
  .byte $E0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $C0
  .byte $20
  .byte $D0
  .byte $D0
  .byte $03
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $05
  .byte $02
  .byte $01
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $E0
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $D0
  .byte $20
  .byte $C0
  .byte $00
  .byte $00
  .byte $00
  .byte $00
  .byte $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap NT LUT  [$B000 :: 0x27010]
;;
;;    This LUT contains the full name and attribute table for the minimap
;;  It is copied in full to the nametables when the minimap is drawn.

lut_MinimapNT:
  .incbin "bin/minimap_nt.nam"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap BG CHR  [$B400 :: 0x27410]
;;
;;    This is the CHR for the non-map BG graphics for the minimap
;;  Due to the way it's loaded, each of these blocks must be aligned
;;  on a $100 byte page


  .ALIGN $100
chr_MinimapDecor:
  .incbin "bin/minimap_decor.chr"


  .ALIGN $100
chr_MinimapTitle:
  .incbin "bin/minimap_title.chr"




;; B980  ????  can't be unused... can it?   Sure isn't used by minimap

 .byte $00,$21,$11,$11,$02,$02,$04,$18,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$1F,$11,$11,$2D,$02,$04,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$02,$1C,$04,$7F,$04,$04,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$01,$29,$29,$02,$02,$04,$18,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$3F,$00,$3F,$04,$04,$04,$08,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$10,$10,$10,$18,$16,$10,$10,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$04,$7F,$04,$04,$04,$08,$30,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$00,$1E,$00,$00,$00,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
 .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Draw Title CHR  [$BB00 :: 0x27B10]
;;
;;    Progressively draws the title CHR for the minimap
;;  This drawing is done progressively while the PPU is on so that
;;  tiles appear to gradually fill the screen.
;;
;;    Because it's done when PPU is on, it must be done in VBlank.  Which
;;  means it needs to be reasonably fast... and you can't do too much at once.
;;  The game spreads the job out over 16 frames, drawing 1 byte of each tile's
;;  CHR each frame.  ($28 bytes drawn per frame).
;;
;;    CHR must have already been preloaded and prearranged so that this
;;  routine can simply load and draw it without having to do heavy computations.
;;  See Minimap_PrepTitleCHR for how that's accomplished.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Minimap_DrawTitleCHR:
    LDA #<mm_titlechr
    STA minimap_ptr
    LDA #>mm_titlechr
    STA minimap_ptr+1        ; load up the pointer to our pre-loaded CHR

    LDX #0                   ; X will be our frame counter.  We will spread this drawing
                             ;  out over 16 frames

  @FrameLoop:
    CALL WaitForVBlank      ; wait for VBlank
    LDY #0                   ; Y will be loop counter/index

    @SmallLoop:
      LDA lut_MinimapTitleCHRDest_hi, Y  ; load up the destination PPU address for this
      STA PPUADDR                          ;  tile of the title graphic
      LDA lut_MinimapTitleCHRDest_lo, Y  ; get low byte as well
      CLC
      ADC lut_MinimapBitplane, X         ; and add bitplane/row info to low byte
      STA PPUADDR                          ;  before writing it

      LDA (minimap_ptr), Y   ; get the preloaded CHR data
      STA PPUDATA              ; and draw it

      INY                    ; inc loop counter/index
      CPY #$28
      BCC @SmallLoop         ; and keep looping until a single bitplane row has been drawn for $28 tiles

    LDA minimap_ptr          ; add $28 to our source pointer
    CLC                      ;   so that we load the next chunk of graphic data
    ADC #$28
    STA minimap_ptr
    LDA minimap_ptr+1
    ADC #0
    STA minimap_ptr+1

    LDA soft2000             ; reset the scroll
    STA PPUCTRL
    LDA #$00
    STA PPUSCROLL
    LDA #$E8
    STA PPUSCROLL

    CALL Minimap_DrawSFX       ; play ugly drawing sound effect
    INX
    CPX #16                   ; increment the frame loop counter
    BCC @FrameLoop            ; and loop until we do 16 frames (8 rows, 2 bitplanes per row = full tile)

    RTS                       ; then exit





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap - Prep Title CHR  [$BB4E :: 0x27B5E]
;;
;;    Exact same idea as Minimap_PrepDecorCHR (see that routine for details)
;;
;;    The loop in this routine is constructed a bit differently because it needs
;;  to copy only $280 bytes instead of $300.  Other than that (and using a different
;;  src/dest buffers), the routines are identical
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Minimap_PrepTitleCHR:
    LDA #<mm_titlechr
    STA tmp+2
    LDA #>mm_titlechr
    STA tmp+3            ; set (tmp+2) to point to our dest buffer

    LDX #0               ; X will be outer loop counter
    LDY #0               ; Y must stay at zero for indexing
  @OuterLoop:
    LDA lut_MinimapBitplane, X
    STA tmp                  ; set (tmp) to point to our source buffer
    LDA #>chr_MinimapTitle   ; and offset it by current row/bitplane
    STA tmp+1

    @InnerLoop:
      LDA (tmp), Y       ; copy a byte from source to dest
      STA (tmp+2), Y

      INC tmp+2          ; inc dest pointer
      BNE :+
        INC tmp+3

  :   LDA tmp            ; add $10 to low byte of source pointer
      CLC                ;  to have it look at the next tile
      ADC #$10
      STA tmp
      BCS @IncHigh       ; if it had carry, inc high byte of pointer

      BPL @InnerLoop     ; if result of low byte is positive ($00-$70) keep looping

      LDA tmp+1
      CMP #>(chr_MinimapTitle + $280)  ; otherwise (low byte is >= $80), check to see if high byte
                                       ; is at the end of our source buffer
      BCC @InnerLoop        ;  if not.. keep looping
      BCS @ExitInnerLoop    ;  if yes... break out of inner loop (always branches)

    @IncHigh:
      INC tmp+1          ; inc high byte of source pointer
      BNE @InnerLoop     ; and keep looping (always branches)

  @ExitInnerLoop:
    INX                  ; increment row/bitplane counter
    CPX #$10             ; and keep looping until we do all $10 of them
    BCC @OuterLoop

    RTS                  ; then exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Title CHR Dest LUT  [$BB8A :: 0x27B9A]
;;
;;    There are $28 tiles that make up the "Final Fantasy" title that is displayed
;;  in the minimap.  These tiles (along with those for the dragon graphic thing)
;;  are scattered around in the pattern table so as to not interefere with the map's CHR.
;;
;;    These LUTs tell where the game is supposed to put each of those $28 tiles in
;;  the pattern tables.  Each entry is the desired tile ID of each graphic left
;;  shift 4 (to make it a CHR address).  One table has the low byte and the other
;;  has the high byte.

lut_MinimapTitleCHRDest_lo:
  .byte <$0160,<$0260,<$02F0,<$0400, <$0450,<$0480,<$0490,<$0500
  .byte <$0540,<$0550,<$0560,<$0570, <$0580,<$0590,<$0600,<$0610
  .byte <$0640,<$0650,<$0660,<$0670, <$0680,<$0690,<$06A0,<$07B0
  .byte <$07C0,<$07F0,<$08F0,<$0900, <$0910,<$0A00,<$0A70,<$0AA0
  .byte <$0B00,<$0B80,<$0B90,<$0BA0, <$0C00,<$0C20,<$0C90,<$0EF0

lut_MinimapTitleCHRDest_hi:
  .byte >$0160,>$0260,>$02F0,>$0400, >$0450,>$0480,>$0490,>$0500
  .byte >$0540,>$0550,>$0560,>$0570, >$0580,>$0590,>$0600,>$0610
  .byte >$0640,>$0650,>$0660,>$0670, >$0680,>$0690,>$06A0,>$07B0
  .byte >$07C0,>$07F0,>$08F0,>$0900, >$0910,>$0A00,>$0A70,>$0AA0
  .byte >$0B00,>$0B80,>$0B90,>$0BA0, >$0C00,>$0C20,>$0C90,>$0EF0



;; unused

  .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  .byte $FF,$FF,$FF,$FF,$6D,$76


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Minimap  [$BC00 :: 0x27C10]
;;
;;    Ahhh... the minimap!  On one hand I think it's very clever... on the other hand
;;  the way it draws is CRIMINALLY inefficient.
;;
;;    Usually when you think of NES drawing, you think of a (more or less) fixed pattern
;;  table that contains your tiles, and you arrange those tiles on the screen with
;;  the name table.  However... the minimap is done somewhat differently.
;;
;;    The world map is 256x256 tiles, but it draws it as a 128x128 pixel image (so each
;;  pixel represents 4 tiles in a 2x2 arrangement).  Somewhat coincidentally... the BG pattern
;;  tables (16x16 tiles) also measure 128x128 pixels!  So the game simply uses the BG
;;  pattern tables as a canvas on which to draw the minimap... and has a fixed nametable
;;  placing the tiles on the screen.
;;
;;    Tiles on the pattern table that are nothing but water get drawn over with other
;;  supporting graphics (title and decoration graphics) after map drawing is complete.
;;
;;
;;    So yeah... that much is pretty slick.  But what is incredibly dumb about the
;;  minimap is that it wastes a LOT of ROM space and CPU time.
;;
;;    Since the drawing is done with the PPU on (so you can see the map progressively being
;;  drawn onscreen as sort of a neat visual effect), all PPU writes must be performed during
;;  VBlank.  This means that the number of writes you can do is very limited... and you have
;;  to end up wasting most of your CPU time waiting for VBlank to happen.  Now most people
;;  would use that down time to decompress map tiles and get them ready to be drawn next frame
;;  but for whatever reason the game doesn't!  Instead of the simple and expected 
;;  "load, draw, load, draw" pattern which uses the rendering time to pre-load graphics
;;  for next VBlank -- this routine will actually load EIGHT rows all at once, then draw
;;  one row a frame for 8 frames ("load, load, load, load...  draw, draw, draw, draw....").
;;
;;    Now...you have to wait for a frame between draws anyway (it's required since writes have
;;  to fall in VBlank) -- but the loading can be done any time.  So it makes more sense to spread
;;  it out between draws when you're doing nothing but waiting.  But NO!  The game crams a bunch
;;  of its loading in a SINGLE frame rather than spreading it out across 8 frames.
;;
;;    This results in an EXTRA and unnecessary pause every 8 rows while the CPU is busy wasting time
;;  loading tiles.
;;
;;
;;    As for wasting space... the game doesn't use the existing map decompression routine!
;;  I still don't know why.  Instead the game has ****TWO**** of its own routines for decompressing
;;  map tiles.  TWO.  I kid you not.  This makes a total of 3 versions of the exact same routine.
;;  But I rant about that in that routine (see MinimapDecompress).
;;
;;
;;
;;    Anyway... the drawing methods here will be confusing unless you're familiar with how NES
;;  2bpp graphics are layed out.  I won't get into it here... but basically each 8x8 tile is 16 bytes...
;;  the first 8 bytes ($x0-$x7) are the low bitplane, and the next 8 ($x8-$xF) are the high bitplane.
;;  each byte in the bitplane is a row of 8 pixels (each bit of the byte is a pixel)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



EnterMinimap:
    LDA #BANK_THIS
    STA cur_bank           ; set cur bank (required for music routine)

    LDA #$00
    STA PPUMASK
    STA PAPU_EN              ; turn off PPU and APU

    LDA #$41               ; switch to music track $41 (crystal theme)
    STA music_track        ;   but it's not heard until after all drawing is complete (music routine isn't called)

    CALL Minimap_PrepDecorCHR   ; Load decoration CHR to RAM (those dragon graphic things)
    CALL Minimap_PrepTitleCHR   ; And the "Final Fantasy" title text
    CALL Minimap_YouAreHere     ; Load the "You are here" graphic -- clear OAM, and draw the "you are here" sprite
    CALL Minimap_FillNTPal      ; Fill the nametable and palettes

    LDA #0
    STA mm_maprow          ; start decompression tiles from row 0 (top row)

    LDA #>$0000            ; set high byte of dest PPU addr.
    STA minimap_ptr+1

  @MainLoop:
    LDA #0                 ; reset low byte of PPU addr to 0
    STA minimap_ptr

    @InnerLoop:            ;   Inner loop is run 8 times -- each time loads a single row of pixels
      CALL Minimap_PrepRow  ; Load a single row of 128 pixels from 2 rows of map data

      INC mm_maprow        ; increment map row counter by 2
      INC mm_maprow

      LDA minimap_ptr      ; increment dest PPU address by 1 (next row of pixels)
      CLC
      ADC #1
      AND #$07             ; and mask with 7 (0-7)
      STA minimap_ptr
      BNE @InnerLoop       ; once it wraps from 7->0, we've filled 256 bytes of graphic data (8 rows of pixels)

    CALL Minimap_DrawRows       ; draw those 8 rows of pixels
    INC minimap_ptr+1          ; increment high byte of PPU dest

    LDA minimap_ptr+1
    CMP #>$1000
    BNE @MainLoop              ; loop until PPU dest=$1000 (filling entire left pattern table)

      ;  now map drawing is done

    CALL Minimap_DrawDecorCHR   ; draw the dragon decorations (previously loaded)
    CALL Minimap_DrawTitleCHR   ; and the "Final Fantasy" title graphics (also previously loaded)


  @ExitLoop:
    CALL MinimapFrame      ; do a frame... animating sprite palettes and whatnot

    LDA joy_a
    ORA joy_b
    BEQ @ExitLoop         ; and simply loop until the user presses A or B

    RTS                   ; at which point... exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Draw Decorative CHR  [$BC55 :: 0x27C65]
;;
;;    EXACTLY the same as Minimap_DrawTitleCHR (see that routine for
;;  details).  Only difference here is we're drawing the CHR for the 
;;  dragon decoration graphic, and so we use different LUTs.  Also, this
;;  graphic consists of $30 tiles instead of $28, so a bit more is drawn
;;  each frame.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Minimap_DrawDecorCHR:
    LDA #<mm_decorchr
    STA minimap_ptr
    LDA #>mm_decorchr
    STA minimap_ptr+1        ; load up the pointer to our pre-loaded CHR

    LDX #0                   ; X will be our frame counter.  We will spread this drawing
                             ;  out over 16 frames

  @FrameLoop:
    CALL WaitForVBlank      ; wait for VBlank
    LDY #0                   ; Y will be loop counter/index

    @SmallLoop:
      LDA lut_MinimapDecorCHRDest_hi, Y  ; load up the destination PPU address for this
      STA PPUADDR                          ;  tile of the title graphic
      LDA lut_MinimapDecorCHRDest_lo, Y  ; get low byte as well
      CLC
      ADC lut_MinimapBitplane, X         ; and add bitplane/row info to low byte
      STA PPUADDR                          ;  before writing it

      LDA (minimap_ptr), Y   ; get the preloaded CHR data
      STA PPUDATA              ; and draw it

      INY                    ; inc loop counter/index
      CPY #$30
      BCC @SmallLoop         ; and keep looping until a single bitplane row has been drawn for $30 tiles

    LDA minimap_ptr          ; add $30 to our source pointer
    CLC                      ;   so that we load the next chunk of graphic data
    ADC #$30
    STA minimap_ptr
    LDA minimap_ptr+1
    ADC #0
    STA minimap_ptr+1

    LDA soft2000             ; reset the scroll
    STA PPUCTRL
    LDA #$00
    STA PPUSCROLL
    LDA #$E8
    STA PPUSCROLL

    CALL Minimap_DrawSFX       ; play ugly drawing sound effect
    INX
    CPX #16                   ; increment the frame loop counter
    BCC @FrameLoop            ; and loop until we do 16 frames (8 rows, 2 bitplanes per row = full tile)

    RTS                       ; then exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap - Prep Decorative CHR  [$BCA3 :: 0x27CB3]
;;
;;    Preps the decorative CHR (the little dragon graphic thing that goes
;;  in the corners of the minimap) by re-arranging it to its necessary
;;  format, then dumping to a temporary RAM buffer, so it can be quickly copied to
;;  the pattern tables later.
;;
;;    Since each tile is drawn bitplane and row at a time, there is some necessary
;;  interleaving to perform here.  To speed up the routine that actually draws
;;  this data to the pattern tables, we want to do all the calculations here, and store the
;;  data in the temp buffer so that bytes can just be read and output in the order they're
;;  given.  We'll only be drawing one byte per tile at a time (rather than 16 bytes
;;  in a row for each tile -- which is how the pattern tables work).
;;
;;    Too hard to explain how this works in words... so here's an example:
;;
;;  CHR data as it needs to appear in the PPU pattern tables:
;;  00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F    (all 16 bytes of tile 0's graphic)
;;  10 11 12 13 14 15 16 17 18 19 1A 1B 1C 1D 1E 1F    (followed by all 16 bytes of tile 1's graphic)
;;  20 21 22 23 24 25 26 27 28 29 2A 2B 2C 2D 2E 2F    (followed by tile 2, etc)
;;
;;   But to draw this one bitplane row at a time, we need to have it stored
;;  in our RAM buffer as the following:
;;  00 10 20 08 18 28 01 11 21 09 19 29 03 13 23 ...   (all top row low bitplanes
;;                                                      followed by top row high bitplanes
;;                                                      followed by row 1 low bitplanes... etc)
;;
;;    That is the interleaving this routine is performing -- and why it isn't just a straight
;;  copy.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

Minimap_PrepDecorCHR:
    LDA #<mm_decorchr
    STA tmp+2
    LDA #>mm_decorchr
    STA tmp+3              ; set (tmp+2) to our dest pointer (RAM to receive interleaved graphics)

    LDX #0          ; X is the outer loop counter, and indicates which row/bitplane to output next
    LDY #0          ; Y needs to always be zero for indexing

  @OuterLoop:
    LDA lut_MinimapBitplane, X
    STA tmp                  ; Load source pointer (tmp) to point to chr_MinimapDecor
    LDA #>chr_MinimapDecor   ;   offset by the row/bitplane we're to be decoded
    STA tmp+1                ;   from lut_MinimapBitplane)

    @InnerLoop:
      LDA (tmp), Y       ; copy a single byte from source
      STA (tmp+2), Y     ;  to dest

      INC tmp+2          ; increment dest pointer by 1
      BNE :+
        INC tmp+3

  :   LDA tmp            ; increment source pointer by $10 (to look at the same
      CLC                ;  row/bitplane on the next tile)
      ADC #$10
      STA tmp
      BCC @InnerLoop     ; if there was no wrap -- continue looping.  Otherwise...

      INC tmp+1            ; include the carry in the high byte of src pointer
      LDA tmp+1            ; check it to see if we copied data for $30 tiles
      CMP #>(chr_MinimapDecor + $300)
      BCC @InnerLoop       ; if not, keep looping  ($30 iterations)

    INX                 ; once the inner loop exits, we finished a single row/bitplane
    CPX #$10            ;  INX to start the next row/bitplane.
    BCC @OuterLoop      ; and continue outer loop until we do all $10 bytes of each tile
                        ; (outer loop = $10 iterations ... * $30 inner iterations =
                        ;     total $300 bytes copied)

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap CHR bitplane LUT  [$BCD9 :: 0x27CE9]
;;
;;    CHR for the minimap support graphics (title and decorations) is drawn progressively.
;;  CHR for each tile is drawn one row at a time -- or more specificlaly, one row of
;;  one bitplane at a time.
;;
;;    This progressive drawing is performed in a loop with an upcounter.  That counter
;;  is run through this LUT to know which bitplane of which row to draw during which
;;  loop iteration
;;
;;    You can scramble this table up in any order to change how the title and decorations
;;  get drawn without changing the final result.  As long as every value between 00-0F
;;  exists in this table.

lut_MinimapBitplane:

;      bitplane
;        lo  hi
  .byte $00,$08   ; top row
  .byte $01,$09
  .byte $02,$0A
  .byte $03,$0B
  .byte $04,$0C
  .byte $05,$0D
  .byte $06,$0E
  .byte $07,$0F   ; bottom row


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Decoration CHR Dest LUT  [$BCE9 :: 0x27CF9]
;;
;;    Exactly the same as lut_MinimapDecorCHRDest (see that LUT description for
;;  details).  Except this is for the 'dragon' decoration that appears on the map.
;;  It consists of $30 tiles



lut_MinimapDecorCHRDest_lo:
  .byte <$0010,<$0020,<$0030,<$0040, <$0050,<$0060,<$0070,<$0080
  .byte <$00B0,<$00C0,<$00D0,<$00E0, <$00F0,<$0700,<$0710,<$0720
  .byte <$0730,<$0740,<$0750,<$0760, <$0800,<$0810,<$0820,<$0830
  .byte <$0840,<$0D00,<$0D10,<$0D20, <$0D30,<$0D40,<$0E00,<$0E10
  .byte <$0E20,<$0E30,<$0E40,<$0F00, <$0F10,<$0F20,<$0F30,<$0F40
  .byte <$0F50,<$0F60,<$0F70,<$0F80, <$0F90,<$0FA0,<$0FB0,<$0FC0

lut_MinimapDecorCHRDest_hi:
  .byte >$0010,>$0020,>$0030,>$0040, >$0050,>$0060,>$0070,>$0080
  .byte >$00B0,>$00C0,>$00D0,>$00E0, >$00F0,>$0700,>$0710,>$0720
  .byte >$0730,>$0740,>$0750,>$0760, >$0800,>$0810,>$0820,>$0830
  .byte >$0840,>$0D00,>$0D10,>$0D20, >$0D30,>$0D40,>$0E00,>$0E10
  .byte >$0E20,>$0E30,>$0E40,>$0F00, >$0F10,>$0F20,>$0F30,>$0F40
  .byte >$0F50,>$0F60,>$0F70,>$0F80, >$0F90,>$0FA0,>$0FB0,>$0FC0



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Frame  [$BD49 :: 0x27D59]
;;
;;     Does a frame for the minimap!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MinimapFrame:
    CALL WaitForVBlank    ; wait for VBlank
    LDA #>oam              ; Sprite DMA
    STA OAMDMA

    CALL DrawPalette      ; draw the palette
    LDA #$1E               ; turn PPU on
    STA PPUMASK

    LDA soft2000           ; reset scroll to $00,$E8
    STA PPUCTRL
    LDA #$00
    STA PPUSCROLL
    LDA #$E8
    STA PPUSCROLL

    FARCALL MusicPlay    ; keep the music playing

    LDA #0
    STA joy_a              ; clear A and B button catchers
    STA joy_b
    FARCALL UpdateJoy        ; then update joypad data

    INC framecounter       ; inc the frame counter

    LDA framecounter
    AND #$08               ; use bit 3 of frame counter to toggle between
    BNE :+
      LDA #$30             ; $37 (tan color)
:   EOR #$07               ; and $0F (black)  every 8 frames
    STA cur_pal+$11        ; this is the color for the "you are here" sprite

    LDA framecounter       ; use bits 4,5 of frame counter
    AND #$30               ; to cycle between $00,$10,$20,$0F
    CMP #$30               ;  changing color every 16 frames
    BNE :+
      LDA #$0F
:   STA cur_pal+$12        ; this is the color for the town/dungeon marker sprites

    RTS                    ; and exit!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Draw Rows  [$BD91 :: 0x27DA1]
;;
;;    Draws 8 preloaded rows of pixels to the PPU pattern tables.
;;  Each row is drawn in its own VBlank, so the drawing happens progressively.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Minimap_DrawRows:
    LDA #0
    STA mm_pixrow            ; start drawing pixel row 0, increment by 1 row each loop

    @MainLoop:
      LDX mm_pixrow          ; put row in X -- X will be the loop up counter and source index
      CALL WaitForVBlank    ; wait for VBlank

      @RowLoop:
        LDA minimap_ptr+1    ; set PPU address
        STA PPUADDR
        STX PPUADDR

        LDA mm_drawbuf, X    ; get graphic from drawing buffer
        STA PPUDATA            ; and draw it

        TXA
        CLC
        ADC #$08             ; add 8 to the index (moves to high bitplane if we're on the low bitplane
        TAX                  ;  (or to low plane of next tile if on high plane.  Does not change rows)

        BCC @RowLoop         ; keep looping until X wraps ($20 interations -- $10 tiles)

      LDA soft2000          ; drawing for this row is done -- reset the scroll
      STA PPUCTRL
      LDA #$00
      STA PPUSCROLL
      LDA #$E8
      STA PPUSCROLL

      CALL Minimap_DrawSFX   ; play the ugly drawing sound effect

      LDA mm_pixrow         ; add 1 to our row counter
      CLC                   ; and mask low bits (0-7)
      ADC #1
      AND #$07
      STA mm_pixrow

      BNE @MainLoop         ; once it wraps 7->0, we've drawn all 8 rows, so exit

    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap - Drawing Sound effect [$BDCD :: 0x27DDD]
;;
;;    Plays that ugly sound effect you hear when the map is drawing.  Just
;;  plays a steady tone, but when called every frame, the phase resets each
;;  frame, which is why it sounds almost like it's buzzing.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Minimap_DrawSFX:
    LDA #$02
    STA PAPU_EN            ; silence all channels except for square 2

    LDA #%00110110
    STA PAPU_CTL2            ; 12.5% duty (harshest), volume=6
    LDA #$7F
    STA PAPU_RAMP2            ; disable sweep
    LDA #$60
    STA PAPU_FT2            ; play tone at F=$060
    LDA #$00
    STA PAPU_CT2

    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Prep Row  [$BDE7 :: 0x27DF7]
;;
;;    Decompresses two rows of map data, and 'merges' them into 1 row of
;;  pixels.  The pixels are dumped into the intermediate buffer 'mm_drawbuf'.
;;  Also, dungeon marker sprites are generated for tiles which require them
;;  in this routine.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Minimap_PrepRow:
    FARCALL MinimapDecompress    ; decompress 2 rows of map data
    LDY #0                       ; Y will be the x coord (column) counter

  @MainLoop:
    LDA #8            ; tmp+7 is a counter to keep track of the number of bits
    STA tmp+7         ;  that have yet to be shifted into the output CHR bytes
                      ; since each byte is actually 8 pixels on a bitplane... multiple pixels
                      ; must be rotated into the same byte to be output as graphics.

    @RotateLoop:
      LDX mm_mapbuf, Y            ; here we get the minimap tileset data for 4 seperate
      LDA lut_MinimapTileset, X   ; map tiles (in a 2x2 square) and OR them together to combine
      LDX mm_mapbuf+1, Y          ; them to a single pixel.
      ORA lut_MinimapTileset, X   ;  This scales the map down from 256x256 tiles
      LDX mm_mapbuf2, Y           ;  to 128x128 pixels
      ORA lut_MinimapTileset, X
      LDX mm_mapbuf2+1, Y         ; after all this, A contains the output pixel (low 2 bits)
      ORA lut_MinimapTileset, X   ;  and bit 2 indicates whether or not a marker sprite needs to be placed here

      LSR A           ; shift out low bit
      ROL mm_bplo     ; rotate it into the low bitplane

      LSR A           ; shift out the high bit
      ROL mm_bphi     ; rotate into high bitplane

      LSR A                   ; shift out marker sprite flag
      BCC :+                  ; if set....
        CALL DrawDungeonSprite ; ... generate a dungeon marker sprite

  :   INY             ; increment our X coord by 2
      INY
      DEC tmp+7       ; decrement our bit counter
      BNE @RotateLoop ; if more bits needed to fill our bitplanes... keep going

      ; @RotateLoop exits when 8 pixels have been shifted into both high and low
      ; bitplanes.

    LDX minimap_ptr      ; use low byte of dest pointer as index for draw buffer

    LDA mm_bplo          ; copy both bitplanes to the appropriate areas of the buffer
    STA mm_drawbuf, X
    LDA mm_bphi
    STA mm_drawbuf+8, X

    LDA minimap_ptr      ; add $10 to low byte of pointer (look at next tile graphic)
    CLC
    ADC #$10
    STA minimap_ptr

    BCC @MainLoop        ; if there was no carry, keep looping
                         ;  otherwise, if there was carry, we have completed a single row
                         ;  from 16 tiles (128 pixels).  So this routine has completed its task
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Dungeon Sprite  [$BE30 :: 0x27E40]
;;
;;    Draws a town/dungeon marker sprite at given coords
;;
;;  IN:  mm_maprow = y coord on world map
;;               Y = x coord on world map
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawDungeonSprite:
    LDA sprindex     ; Add 4 to the sprite index (drawing a single sprite -- 4 bytes)
    CLC              ;  do this before drawing the sprite to leave sprite 0 alone
    ADC #$04         ;  since that is the party position sprite
    STA sprindex
    TAX              ; put sprite index in X for indexing

    LDA mm_maprow    ; get Y coord
    LSR A            ; divide by 2 (minimap display is 128x128 -- world map is 256x256)
    CLC
    ADC #$34         ; add $34 to offset the sprite to the start of the map on the screen
    STA oam, X       ; write this as Y coord of sprite

    LDA #$81
    STA oam+1, X     ; use tile $81

    LDA #$00
    STA oam+2, X     ; attributes (palette 0, no flipping, foreground priority)

    TYA              ; get the X coord
    LSR A            ; divide by 2 for same reason
    CLC
    ADC #$3D         ; add $3D to offset it to start of the map
    STA oam+3, X     ; write as X coord

    RTS              ; done!




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap - Fill NT and Palette [$BE54 :: 0x27E64]
;;
;;    Fills the nametable for the minimap.
;;  Also clears all of CHR-RAM for the BG, loads and draws the palette,
;;  and loads CHR for the sprites.

Minimap_FillNTPal:
    LDA #$08           ; write to soft2000 to clear NT scroll
    STA soft2000

   ; 
   ; draw the NT data at lut_MinimapNT
   ;

    LDA PPUSTATUS          ; reset PPU toggle
    LDA #>PPUCTRL        ; set PPU address to PPUCTRL  (start of nametables)
    STA PPUADDR
    LDA #<PPUCTRL
    STA PPUADDR

    LDA #<lut_MinimapNT
    STA tmp
    LDA #>lut_MinimapNT ; load up the pointer to the LUT containing the minimap NT
    STA tmp+1           ;  data.  Store the pointer in (tmp)

    LDX #$04            ; X is high byte of loop counter
    LDY #$00            ; Y is low byte of counter and index
   @NTLoop:
       LDA (tmp), Y     ; get byte from LUT
       STA PPUDATA        ; draw it
       INY              ; inc source index
       BNE @NTLoop      ; if it wrapped....
      INC tmp+1         ; inc high byte of source pointer
      DEX               ; dec high byte of loop counter
      BNE @NTLoop       ; and keep looping until expires ($400 iterations)

   ;
   ; clear the BG pattern table
   ;

    LDA PPUSTATUS           ; reset PPU toggle
    LDA #>$0000         ; set PPU address to $0000 (start of BG pattern table)
    STA PPUADDR
    LDA #<$0000
    STA PPUADDR

                        ; A=0
    LDY #$10            ; Y is high byte of loop counter
    LDX #$00            ; X is low byte
   @ClearCHRLoop:
       STA PPUDATA           ; zero out the pattern tables
       INX
       BNE @ClearCHRLoop
      DEY
      BNE @ClearCHRLoop    ; $1000 iterations (full BG pattern table)

   ;
   ; load CHR for sprites ("you are here" mark, and town/dungeon points)
   ;

    LDA PPUSTATUS          ; reset PPU toggle
    LDA #>$1800        ; PPU address = $1800  (start of CHR for sprite tile $80)
    STA PPUADDR
    LDA #<$1800
    STA PPUADDR

    LDX #$00
   @SpriteCHRLoop:
      LDA lut_MinimapSprCHR, X
      STA PPUDATA                      ; copy the CHR to the PPU
      INX                            ; inc loop counter
      CPX #$20
      BCC @SpriteCHRLoop             ; loop until $20 bytes copied (2 tiles)

   ;
   ; load BG palettes for this screen
   ;

    LDX #$0F
   @BGPalLoop:
      LDA lut_MinimapBGPal, X   ; copy color from LUT
      STA cur_pal, X            ;  to palette
      DEX
      BPL @BGPalLoop            ; loop until X wraps ($10 iterations)

    LDA cur_pal           ; copy the background color to the mirrored copy in the sprite palette
    STA cur_pal+$10       ;  this ensures the BG color will be what's desired when the palette is drawn

    LDA #$0F
    STA cur_pal+$11       ; start the "you are here" sprite
    STA cur_pal+$12       ;  and the town/dungeon marker sprite at $0F black

   ;
   ;  Do last minute PPU stuff before exiting
   ;

    CALL WaitForVBlank   ; wait for VBlank
    LDA #>oam             ; then do sprite DMA
    STA OAMDMA

    CALL DrawPalette     ; draw the palette

    LDA soft2000
    STA PPUCTRL             ; set NT scroll and pattern page assignments
    LDA #$0A
    STA PPUMASK             ; turn on BG rendering, but leave sprites invisible for now

    LDA #$00              ; set scroll to $00,$E8  (8 pixels up from bottom of the NT)
    STA PPUSCROLL             ;   since there's vertical mirroring, this scrolls up 8 pixels,
    LDA #$E8              ;   which makes the screen appear to be 8 pixels lower than
    STA PPUSCROLL             ;   what you might expect.  This centers the image on the screen a bit better
                          ; The NT could've just been drawn 1 tile down.. but that would mess with
                          ; attribute alignment

    RTS                   ; then exit!


;;  unused space
  .byte 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
  .byte 0,0,0,0, 0



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Sprite CHR  [$BF00 :: 0x27F10]
;;    CHR for sprites on the minimap

lut_MinimapSprCHR:
  .incbin "bin/minimap_sprite.chr"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BG palette for minimap  [$BF20 :: 0x27F30]

lut_MinimapBGPal:
  .byte $02,$1B,$38,$2B, $02,$04,$37,$0F, $02,$28,$18,$0F, $02,$24,$1A,$30



;; unused
  .byte 0,0,0,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap - Draw "You Are Here" sprite [$BF34 :: 0x27F44]
;;
;;     Clears OAM and draws the "you are here" marker sprite
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Minimap_YouAreHere:
    LDX #0
    STX sprindex      ; clear the sprite index

    LDA #$F8          ; flood OAM with $F8 (to clear it -- moves all sprites offscreen, making them invisible)
   @Loop:
      STA oam, X
      INX
      BNE @Loop       ; $100 iterations (all of OAM)

    LDA #$08
    STA soft2000      ; clear NT scroll (seems inapporpriate to do it here, but I guess it doesn't hurt)

    LDA #$80
    STA oam+1         ; "you are here" sprite uses tile $80

    LDA ow_scroll_x   ; get scroll X
    CLC
    ADC #$07          ; add 7 to get player position
    LSR A             ; divide that by 2 to scale to minimap (world map is 256x256 -- minimap is 128x128)
    CLC
    ADC #$3D          ; add $3D to offset it so it starts at the start of the map
    STA oam+3, X      ; record as X coord

    LDA ow_scroll_y   ; do the same to get Y coord
    CLC
    ADC #$07
    LSR A
    CLC
    ADC #$34          ; but add a little less ($34 instead of $3D)
    STA oam+0         ; record as Y coord

    LDA #$00
    STA oam+2         ; set sprite attributes (palette 0, no flipping, foreground priority)

    RTS               ; and exit!


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Minimap Tileset color assignment LUT  [$BF80 :: 0x27F90]
;;
;;    Each entry in this table coresponds to an overworld tile.
;;  This table specifies what color (of the 4 colors available
;;  colors) this tile will be represented by in the minimap.
;;
;;    The low 2 bits specify the color... bit 2 ($4), is set if
;;  the tile represents a town/dungeon and indicates that a sprite
;;  should be drawn on that tile.
;;

lut_MinimapTileset:
  .byte 1,5,5,1,1,1,1,1,1,1,1,1,1,1,6,0
  .byte 1,1,1,1,1,1,0,0,0,1,1,5,5,6,2,3
  .byte 1,3,1,1,1,1,1,0,1,5,5,5,1,1,1,5
  .byte 1,1,5,1,5,5,2,2,5,5,5,1,3,3,3,1
  .byte 0,0,2,2,0,2,4,1,1,5,5,1,5,5,5,1
  .byte 0,0,2,2,1,1,1,5,5,1,5,1,1,5,1,1
  .byte 1,1,1,1,5,5,5,5,5,5,5,3,5,5,5,3
  .byte 1,1,1,1,1,1,1,1,1,2,0,3,3,3,3,3




