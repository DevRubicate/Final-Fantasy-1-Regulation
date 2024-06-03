.segment "DATA_126"

.include "src/global-import.inc"

.export TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_HOLDRESET, TEXT_INTRO_STORY_4, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_INTRO_STORY_10, TEXT_INTRO_STORY_3, TEXT_SHOP_BUYEXIT, TEXT_SHOP_WELCOME, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_HERO_2_NAME, TEXT_SHOP_TITLEINN

; address 0 - 43 (bytes 0 - 43)
TEXT_SHOP_YOUHAVENOTHING:
.byte $23, $33, $39, $7f, $2c, $25, $3a, $29, $7f, $32, $33, $38, $2c, $2d, $32, $2b, $7f, $38, $33, $7e, $37, $29, $30, $30, $7f, $7f, $0b, $32, $3d, $41, $7f, $38, $2c, $2d, $32, $2b, $7f, $29, $30, $37, $29, $42, $00

; address 43 - 81 (bytes 0 - 38)
TEXT_SHOP_HOLDRESET:
.byte $12, $33, $30, $28, $7f, $1c, $0f, $1d, $0f, $1e, $7f, $3b, $2c, $2d, $30, $29, $7f, $3d, $33, $39, $7f, $38, $39, $36, $32, $7f, $1a, $19, $21, $0f, $1c, $7f, $33, $2a, $2a, $43, $43, $00

; address 81 - 109 (bytes 0 - 28)
TEXT_INTRO_STORY_4:
.byte $25, $32, $28, $7e, $38, $2c, $29, $7e, $29, $25, $36, $38, $2c, $7e, $26, $29, $2b, $2d, $32, $37, $7e, $38, $33, $7e, $36, $33, $38, $00

; address 109 - 135 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $30, $29, $25, $36, $32, $7f, $38, $2c, $29, $7f, $37, $34, $29, $30, $30, $42, $00

; address 135 - 157 (bytes 0 - 22)
TEXT_INTRO_STORY_10:
.byte $3d, $33, $39, $32, $2b, $7e, $3b, $25, $36, $36, $2d, $33, $36, $37, $7e, $25, $36, $36, $2d, $3a, $29, $00

; address 157 - 173 (bytes 0 - 16)
TEXT_INTRO_STORY_3:
.byte $38, $2c, $29, $7e, $37, $29, $25, $7e, $2d, $37, $7e, $3b, $2d, $30, $28, $00

; address 173 - 183 (bytes 0 - 10)
TEXT_SHOP_BUYEXIT:
.byte $0c, $39, $3d, $7f, $7f, $0f, $3c, $2d, $38, $00

; address 183 - 191 (bytes 0 - 8)
TEXT_SHOP_WELCOME:
.byte $21, $29, $30, $27, $33, $31, $29, $00

; address 191 - 198 (bytes 0 - 7)
TEXT_SHOP_TITLEBLACKMAGIC:
.byte $0c, $17, $0b, $11, $13, $0d, $00

; address 198 - 203 (bytes 0 - 5)
TEXT_HERO_2_NAME:
.byte $90, $80, $02, $91, $00

; address 203 - 207 (bytes 0 - 4)
TEXT_SHOP_TITLEINN:
.byte $13, $18, $18, $00

; 207 - 8192
.res 7985

