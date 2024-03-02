.segment "BANK_12"

.include "src/global-import.inc"

.import CHRLoadToA

.export LoadMenuBGCHRAndPalettes, LoadMenuCHR, LoadShopBGCHRPalettes, LoadBackdropPalette, LoadShopBGCHRPalettes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Menu BG CHR and Palettes  [$EA9F :: 0x3EAAF]
;;
;;   Loads CHR and Palettes for menus
;;
;;   Does not load palettes or CHR for sprites
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadMenuBGCHRAndPalettes:
    CALL LoadMenuCHR
    CALL LoadOrbCHR
    JUMP LoadBorderPalette_Blue       ; Load up the blue border palette for menus

LoadMenuCHR:
    LDA #<LUT_MenuCHR
    STA tmp
    LDA #>LUT_MenuCHR
    STA tmp+1        ; source address = $8800
    LDX #8           ; 8 rows to load
    LDA #8           ; dest address = $0800
    JUMP CHRLoadToA

LoadOrbCHR:
    LDA #<LUT_OrbCHR                 ; from source address LUT_OrbCHR
    STA tmp
    LDA #>LUT_OrbCHR
    STA tmp+1
    LDX #$02                         ; we want 2 rows of tiles
    LDA #$06                         ; dest ppu address $0600
    JUMP CHRLoadToA                   ; load up desired CHR (this is the ORB graphics that appear in the upper-left corner of main menu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Shop CHR and Palettes  [$EA02 :: 0x3EA12]
;;
;;    Loads up ALL BG CHR and palettes relating to shops
;;    Does not load any sprite CHR or palettes
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadShopBGCHRPalettes:
    LDA #<LUT_ShopCHR
    STA tmp
    LDA #>LUT_ShopCHR  ; source pointer (tmp) = lut_ShopCHR
    STA tmp+1

    LDA #$00           ; dest PPU address = $0000
    LDX #$08           ; 8 rows to load
    CALL CHRLoadToA     ; load them up  (loads all shop related CHR
    CALL LoadMenuCHR    ;  then load up all menu related CHR (font/borders/etc)
    
    LDX shop_id          ; Get Shop ID, use it to index and get shop type
    LDA lut_ShopTypes, X
    AND #$07             ; Mask out low 3 bits (precautionary -- not really necessary unless you have an invalid shop ID)
    STA shop_type        ; save shop type
    ASL A
    ASL A
    ORA #$40             ; *4 and add $40 to get offset to required backdrop palette
    CALL LoadBackdropPalette     ; get the backdrop palette loaded
    CALL LoadBorderPalette_Blue  ; and the border palette loaded

       ; LoadShopTypeAndPalette doesn't load the palettes for the title
       ;  and money boxes -- so load those up here

    LDX #$07           ; start at X=7
  @Loop:
      LDA lut_ShopPalettes, X
      STA cur_pal+4, X   ; copy over the shop palettes
      DEX                ; and loop until X wraps (8 colors copied in total)
      BPL @Loop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Backdrop Palette  [$EB5A :: 0x3EB6A]
;;
;;   Fetches palette for desired backdrop (battle or shop).
;;
;;   Y is unchanged
;;
;;   IN:   A = backdrop ID * 4
;;         * = Required bank must be swapped in
;;
;;   OUT:  $03C0-03C4 = backdrop palette
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBackdropPalette:
    TAX                       ; backdrop ID * 4 in X for indexing
    LDA LUT_BackdropPalette, X    ; copy the palette over
    STA cur_pal
    LDA LUT_BackdropPalette+1, X
    STA cur_pal+1
    LDA LUT_BackdropPalette+2, X
    STA cur_pal+2
    LDA LUT_BackdropPalette+3, X
    STA cur_pal+3
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Border Palette  [$EB29 :: 0x3EB39]
;;
;;    Loads the greyscale palette used for the border in menus
;;   The routine has 2 entry points... one to load the BLACK bg (used in battle)
;;   and one to load the BLUE bg (used in menus/shops)
;;
;;   X,Y remain unchanged
;;
;;   OUT:  $03CC-03CF = border palette
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBorderPalette_Blue:
    LDA #$01
    STA cur_pal+$E   ; Blue goes to color 2
    LDA #$0F
    STA cur_pal+$C   ; Black always to color 0
    LDA #$00
    STA cur_pal+$D   ; Grey always to color 1
    LDA #$30
    STA cur_pal+$F   ; White always to color 3
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$EBB5 :: 0x3EBC5]
;;
;;   Shop Type LUT.  Shop ID number is used to index this table to figure out
;;  what type of shop it is.
;;
;;   There are 10 of each kind of shop (supposedly)
;;    0 = Weapon
;;    1 = Armor
;;    2 = White Magic
;;    3 = Black Magic
;;    4 = Clinic
;;    5 = Inn
;;    6 = Item        Only 9 of these (10th is the Caravan)
;;    7 = Caravan     Only 1 of these
;;
;;  As an additional quirk... shop IDs appear to be 1-based, not the expected 0-based
;;  As a result... this table is off by 1 (the first byte in it goes unused)
;;
;;  To "compensate", there's an extra Armor shop ID (so supposedly, there's only 9 weapon
;;   shops and 11 armor shops)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lut_ShopTypes:
   .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00      ; 10 weapon shops (but first is unused)
   .byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01  ; 11 armor shops (to correct the off-by-1 error)
   .byte $02,$02,$02,$02,$02,$02,$02,$02,$02,$02      ; 10 white magic
   .byte $03,$03,$03,$03,$03,$03,$03,$03,$03,$03      ; 10 black magic
   .byte $04,$04,$04,$04,$04,$04,$04,$04,$04,$04      ; 10 clinics
   .byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05      ; 10 inns
   .byte $06,$06,$06,$06,$06,$06,$06,$06,$06,$07      ; 9 item shops + 1 caravan

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUT for Shop Money and Title Boxes  [$EB74 :: 0x3EB84]
;;
;;   These are the purple and green box palettes used for the title and money
;;     boxes inside of shops
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lut_ShopPalettes:
    .byte $0F, $00, $04, $30, $0F, $00, $0A, $30

LUT_BackdropPalette:
    .byte $0f, $31, $29, $30, $0f, $0c, $17, $07, $0f, $1c, $2b, $1b, $0f, $30, $3c, $22
    .byte $0f, $18, $0a, $1c, $0f, $3c, $1c, $0c, $0f, $37, $31, $28, $0f, $27, $17, $1c
    .byte $0f, $1a, $17, $07, $0f, $30, $10, $00, $0f, $22, $1a, $10, $0f, $37, $10, $00
    .byte $0f, $21, $12, $03, $0f, $31, $22, $13, $0f, $26, $16, $06, $0f, $2b, $1c, $0c
    .byte $0f, $30, $00, $31, $0f, $10, $27, $17, $0f, $3c, $1c, $0c, $0f, $3b, $1b, $0b
    .byte $0f, $37, $16, $10, $0f, $36, $16, $07, $0f, $37, $17, $07, $0f, $30, $28, $16
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $09, $09, $04, $04, $04, $00, $03, $00, $ff, $ff, $ff, $ff, $ff, $08, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $03, $03, $03, $ff, $ff, $09, $09, $0b, $06, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $00, $03, $00, $09, $09, $0d, $ff, $ff, $ff, $02
    .byte $ff, $ff, $02, $ff, $02, $02, $06, $06, $09, $09, $02, $00, $ff, $ff, $ff, $00
    .byte $0a, $0a, $06, $06, $0a, $06, $0f, $ff, $ff, $00, $03, $ff, $00, $00, $00, $ff
    .byte $0a, $0a, $06, $06, $00, $07, $00, $05, $05, $00, $00, $ff, $ff, $0c, $ff, $ff
    .byte $00, $00, $07, $07, $0e, $0e, $02, $02, $02, $02, $02, $ff, $02, $00, $01, $ff
    .byte $00, $00, $07, $07, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

LUT_OrbCHR:
    .byte $03, $0f, $1f, $1f, $3f, $3f, $3b, $1f, $ff
    .byte $fc, $f0, $f0, $e0, $e0, $e0, $f0, $c0, $80, $e0, $f0, $f0, $f0, $b0, $f0, $ff
    .byte $0f, $07, $07, $03, $03, $03, $07, $1e, $2e, $73, $60, $67, $27, $0f, $20, $f0
    .byte $e8, $c0, $c0, $c8, $e8, $f0, $c0, $e0, $e0, $80, $20, $e8, $e8, $c0, $00, $07
    .byte $03, $01, $01, $01, $03, $0f, $03, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fd, $ff, $f8, $f1, $e3, $e7, $40, $c0, $fa, $f8, $fc, $fc, $fe, $fe, $bf
    .byte $bf, $15, $bf, $bf, $bf, $bf, $ff, $7f, $7f, $3f, $3f, $5f, $af, $73, $0c, $ef
    .byte $ff, $ff, $ff, $bf, $5f, $8f, $f3, $fe, $fe, $fc, $fc, $fa, $f5, $ce, $30, $ff
    .byte $ff, $ff, $ff, $fd, $fa, $f1, $cf, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fe, $f8, $f0, $e1, $e3, $c7, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $ff, $7f, $1f, $7f, $ff, $ff, $ff, $7f, $7f, $3f, $3f, $5f, $af, $73, $0c, $c7
    .byte $ef, $fc, $f8, $b8, $5c, $8f, $f3, $fe, $fe, $fc, $fc, $fa, $f5, $ce, $30, $ff
    .byte $ff, $3f, $1f, $1d, $3a, $f1, $cf, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $fc, $f3, $ef, $df, $df, $bf, $ba, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $3f, $cf, $f7, $fb, $fb, $fd, $ad, $7f, $7f, $3f, $bf, $5f, $2f, $d3, $3c, $a8
    .byte $90, $c0, $40, $a0, $f0, $3c, $cf, $fe, $fe, $fc, $fd, $fa, $f4, $cb, $3c, $15
    .byte $09, $03, $02, $05, $0f, $3c, $f3, $00, $03, $0f, $1f, $3f, $3f, $7f, $7f, $ff
    .byte $ff, $fe, $f8, $f0, $e0, $e1, $c3, $00, $c0, $f0, $f8, $fc, $fc, $fe, $fe, $ff
    .byte $ff, $3f, $0f, $3f, $ff, $ff, $ff, $7f, $7f, $3f, $bf, $5f, $af, $73, $0c, $c7
    .byte $ef, $ff, $7f, $bf, $5f, $8f, $f3, $fe, $fe, $fc, $fd, $fa, $f5, $ce, $30, $ff
    .byte $ff, $ff, $fe, $fd, $fa, $f1, $cf, $7f, $55, $41, $55, $22, $36, $1c, $08, $80
    .byte $80, $80, $94, $c1, $c1, $e3, $f7, $00, $08, $1c, $7f, $3e, $1c, $36, $22, $ff
    .byte $f7, $e3, $80, $c1, $e3, $c9, $dd, $00, $03, $0f, $1f, $1f, $3f, $3f, $3f, $ff
    .byte $fc, $f1, $e0, $e0, $c0, $c0, $c0, $00, $e0, $f8, $fc, $fc, $fe, $fe, $fe, $ff
    .byte $1f, $e7, $33, $1b, $09, $0d, $0d, $3f, $3f, $1f, $1f, $0f, $03, $00, $00, $c0
    .byte $c0, $e0, $e0, $f0, $fc, $ff, $ff, $fe, $fe, $fc, $fc, $f8, $e0, $00, $00, $01
    .byte $0d, $1f, $03, $07, $1f, $ff, $ff, $00, $01, $02, $04, $08, $10, $20, $40, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $08, $7c, $10, $3a, $4c, $24, $20, $1e, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $3c, $02, $02, $04, $18, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $28, $3e, $62, $14, $10, $08, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $08, $5c, $6a, $4a, $1c, $08, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $08, $0e, $08, $18, $2c, $12, $ff
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff

LUT_MenuCHR:
    .byte $00, $3e, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $18, $38, $18, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $06, $18, $30, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $0e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0e, $1e, $36, $26, $66, $7f, $06, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $7e, $03, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $7e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $63, $63, $06, $0c, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $3e, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $3f, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1c, $1c, $14, $36, $3e, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $7e, $63, $63, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $60, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7c, $66, $63, $63, $63, $66, $7c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $62, $7e, $62, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $62, $7e, $62, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $67, $61, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $63, $7f, $63, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1e, $0c, $0c, $0c, $0c, $0c, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $07, $03, $03, $03, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $66, $6c, $78, $6c, $66, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $60, $60, $60, $61, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $77, $7f, $6b, $63, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $73, $7b, $6f, $67, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $63, $7e, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $63, $63, $6d, $66, $3b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7e, $63, $63, $7e, $6c, $66, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3e, $63, $60, $3e, $03, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $ff, $99, $18, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $63, $63, $63, $63, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $22, $36, $36, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $63, $63, $6b, $6b, $7f, $77, $22, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $41, $63, $36, $1c, $1c, $36, $63, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c3, $66, $3c, $18, $18, $18, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $43, $06, $0c, $18, $31, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $06, $1e, $36, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $3c, $36, $36, $36, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $36, $30, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $06, $06, $1e, $36, $36, $36, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $32, $3e, $30, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0c, $1a, $18, $3c, $18, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $1e, $14, $1c, $36, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $30, $3c, $36, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $0c, $00, $0c, $0c, $0c, $0c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $0c, $00, $0c, $0c, $0c, $2c, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $30, $30, $33, $36, $3c, $36, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $18, $18, $18, $18, $18, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $7e, $6d, $6d, $6d, $6d, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $36, $36, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $36, $36, $36, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $36, $3c, $30, $30, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $36, $1e, $06, $06, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $36, $19, $19, $18, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $38, $1e, $07, $3e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $18, $3e, $18, $18, $18, $0c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $33, $33, $33, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $62, $62, $34, $3c, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $6d, $6d, $6d, $6d, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $1e, $0c, $1e, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $33, $1e, $0c, $18, $30, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $7e, $0c, $18, $30, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $20, $40, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $18, $18, $08, $10, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $60, $60, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $3e, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $66, $66, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $08, $08, $08, $08, $08, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $1c, $22, $22, $04, $08, $00, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $60, $60, $60, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7f, $60, $60, $7e, $60, $60, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $63, $94, $f7, $84, $73, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $3e, $12, $9e, $90, $10, $90, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3c, $66, $60, $3c, $06, $66, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $fd, $31, $33, $33, $33, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $cf, $c3, $63, $63, $e3, $33, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $d9, $19, $19, $19, $19, $19, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $9e, $b3, $b0, $9e, $83, $b3, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c6, $c6, $c6, $d6, $fe, $ee, $44, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f9, $c1, $c3, $f3, $c3, $c6, $f6, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c7, $c6, $66, $67, $e6, $36, $36, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c7, $6d, $6d, $cd, $0d, $0d, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $33, $b3, $bb, $b7, $b3, $b3, $33, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $c0, $e0, $70, $39, $1e, $0c, $0a, $11, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $08, $77, $7f, $7f, $00, $08, $08, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $02, $06, $0e, $5c, $38, $30, $48, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $44, $75, $75, $74, $44, $04, $04, $04, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $60, $90, $90, $48, $08, $04, $02, $01, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $28, $02, $40, $42, $42, $42, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $c3, $bd, $7e, $7e, $3c, $66, $5a, $ff, $ff, $db, $ff, $ff, $ff, $ff, $e7
    .byte $7f, $41, $49, $5d, $49, $49, $22, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $3e, $01, $3e, $7f, $0f, $0f, $3e, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $38, $3c, $3c, $1e, $05, $02, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $1c, $22, $41, $41, $41, $63, $3e, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7
    .byte $00, $e7, $ff, $7e, $7e, $7e, $7e, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $62, $64, $08, $10, $26, $46, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $1c, $08, $08, $1c, $3e, $3e, $1c, $1c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f0, $d8, $d9, $db, $f3, $c3, $c1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $0c, $c0, $2d, $2c, $2c, $cc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $f1, $83, $f3, $1b, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $ce, $2d, $2d, $2d, $cd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $3c, $66, $60, $3c, $06, $66, $3c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $60, $60, $f9, $63, $63, $63, $31, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $cf, $2c, $2c, $2c, $cc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1c, $b2, $be, $b0, $9e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $02, $02, $3a, $42, $7a, $0a, $72, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $88, $d8, $f9, $f9, $d9, $db, $db, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e1, $e3, $b3, $b3, $f3, $1b, $19, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e7, $33, $03, $73, $13, $33, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $9e, $33, $33, $30, $33, $33, $9e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $7d, $60, $60, $78, $60, $60, $61, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $e7, $cc, $cc, $cd, $cc, $cc, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $99, $d9, $19, $df, $59, $d9, $99, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $bf, $ad, $8c, $8c, $8c, $8c, $8c, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f1, $d9, $cd, $cd, $cd, $d9, $f1, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $f3, $99, $99, $f1, $e1, $b1, $9b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $d9, $99, $99, $9d, $9b, $99, $d9, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $b3, $b6, $bc, $b8, $bc, $b6, $b3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $1f, $3f, $7f, $7f, $78, $00, $00, $00, $00, $0f, $18, $30, $27
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $00, $ff
    .byte $00, $00, $00, $f8, $fc, $fe, $fe, $1e, $00, $00, $00, $00, $f0, $18, $0c, $e4
    .byte $78, $78, $78, $78, $78, $78, $78, $78, $27, $27, $27, $27, $27, $27, $27, $27
    .byte $1e, $1e, $1e, $1e, $1e, $1e, $1e, $1e, $e4, $e4, $e4, $e4, $e4, $e4, $e4, $e4
    .byte $78, $78, $7c, $7f, $7f, $3f, $1f, $00, $27, $27, $33, $18, $0f, $00, $00, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $ff, $ff, $00, $ff, $00, $00, $00
    .byte $1e, $1e, $3e, $fe, $fe, $fc, $f8, $00, $e4, $e4, $cc, $18, $f0, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

LUT_ShopCHR:
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $88, $88, $88, $08, $88, $88, $88, $80, $66, $66, $66, $06, $66, $66, $66, $60
    .byte $00, $88, $00, $00, $40, $5f, $40, $7f, $00, $66, $00, $7f, $3f, $20, $3f, $00
    .byte $00, $88, $00, $00, $04, $f4, $04, $fc, $00, $66, $00, $fc, $f8, $08, $f8, $00
    .byte $00, $00, $00, $00, $00, $00, $01, $03, $00, $00, $00, $00, $00, $00, $01, $03
    .byte $07, $0d, $1b, $36, $6c, $d8, $b0, $60, $07, $0f, $1f, $3e, $7c, $f8, $f0, $e0
    .byte $06, $4d, $6b, $3e, $18, $0c, $06, $00, $07, $0f, $0f, $06, $20, $70, $60, $80
    .byte $c0, $80, $00, $00, $00, $00, $00, $00, $c0, $80, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $06, $06, $07, $00, $1f, $3f, $3f, $3f, $39, $39, $18
    .byte $00, $00, $00, $10, $70, $80, $d8, $f8, $00, $f0, $f8, $e8, $80, $00, $00, $00
    .byte $03, $01, $1e, $3f, $3e, $3f, $1e, $1e, $1c, $0c, $02, $01, $00, $00, $01, $11
    .byte $c0, $82, $b6, $76, $80, $58, $2c, $48, $30, $70, $40, $00, $8e, $56, $82, $80
    .byte $04, $18, $1f, $0f, $0f, $00, $00, $00, $03, $18, $1f, $0f, $0f, $0f, $0f, $0f
    .byte $70, $00, $d0, $b0, $b0, $00, $00, $00, $80, $00, $d0, $b0, $b0, $b0, $b0, $d8
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $22, $22, $62, $22, $22, $22, $26, $22, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee
    .byte $00, $22, $00, $ff, $00, $00, $00, $00, $00, $ee, $00, $ff, $ff, $ff, $ff, $ff
    .byte $00, $22, $00, $fc, $08, $08, $08, $08, $00, $ee, $00, $fc, $f8, $f8, $f8, $f8
    .byte $00, $00, $00, $1e, $16, $10, $18, $18, $00, $7f, $40, $5e, $56, $50, $58, $58
    .byte $00, $fe, $fe, $86, $96, $f6, $e6, $e6, $00, $00, $fc, $fc, $fc, $fc, $fc, $fc
    .byte $0e, $0e, $0c, $06, $02, $00, $00, $00, $2e, $2e, $2c, $16, $0a, $04, $03, $00
    .byte $8c, $8c, $cc, $98, $b0, $e0, $c0, $00, $f8, $f8, $f8, $f0, $e0, $c0, $00, $00
    .byte $00, $0f, $1f, $3f, $3f, $64, $64, $76, $00, $0f, $1f, $3f, $3f, $7e, $7f, $7f
    .byte $00, $f0, $f8, $fc, $34, $00, $00, $00, $00, $f0, $f8, $fc, $f4, $20, $70, $f8
    .byte $ff, $ff, $c7, $83, $81, $81, $9b, $b9, $ff, $c7, $83, $39, $7c, $7c, $78, $7c
    .byte $30, $c0, $f0, $f8, $f8, $f8, $fc, $fc, $f0, $f0, $f2, $fc, $fe, $7c, $3c, $1c
    .byte $30, $73, $31, $1f, $1f, $1f, $1f, $1f, $7e, $3c, $0e, $00, $0f, $1f, $1f, $1f
    .byte $0c, $f4, $a4, $40, $40, $40, $a0, $a0, $0c, $04, $04, $00, $40, $40, $a0, $a0
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee
    .byte $00, $66, $00, $7f, $3f, $20, $3f, $00, $00, $ee, $00, $7f, $7f, $7f, $7f, $7f
    .byte $00, $66, $00, $fc, $f8, $08, $f8, $00, $00, $ee, $00, $fc, $fc, $fc, $fc, $fc
    .byte $00, $bf, $60, $3f, $00, $bf, $7e, $7f, $00, $80, $00, $00, $0f, $80, $01, $00
    .byte $00, $fc, $06, $fc, $00, $c1, $00, $f0, $00, $00, $00, $00, $f0, $3d, $fe, $0e
    .byte $7f, $7f, $7f, $7f, $7f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00
    .byte $00, $f8, $00, $f0, $00, $c0, $01, $0f, $fe, $06, $fe, $0e, $fe, $3c, $f1, $0f
    .byte $00, $00, $00, $00, $00, $03, $07, $0f, $30, $78, $7c, $de, $9f, $0c, $08, $03
    .byte $00, $00, $00, $00, $00, $80, $80, $00, $00, $00, $00, $00, $03, $0e, $f8, $f0
    .byte $0c, $19, $27, $0f, $0e, $08, $00, $0e, $07, $1f, $3f, $ef, $1e, $2f, $5d, $be
    .byte $70, $f8, $10, $b8, $fc, $70, $30, $01, $f0, $c8, $00, $00, $00, $00, $80, $c4
    .byte $1f, $2f, $27, $30, $20, $40, $70, $00, $d5, $38, $3c, $3d, $3d, $7d, $7f, $fe
    .byte $0e, $06, $06, $00, $00, $00, $00, $00, $b8, $42, $72, $6a, $6a, $6a, $6e, $f7
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $22, $22, $22, $22, $22, $22, $22, $22, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee
    .byte $00, $66, $00, $7f, $3f, $20, $3f, $00, $00, $ee, $00, $7f, $7f, $7f, $7f, $7f
    .byte $00, $66, $00, $fc, $f8, $08, $f8, $00, $00, $ee, $00, $fc, $fc, $fc, $fc, $fc
    .byte $00, $0f, $10, $0f, $00, $07, $07, $1f, $00, $00, $00, $00, $07, $00, $00, $00
    .byte $00, $f0, $08, $f0, $00, $c0, $00, $80, $00, $00, $00, $00, $e0, $20, $e0, $78
    .byte $1f, $3f, $3f, $3f, $3f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00
    .byte $c0, $e0, $e0, $e0, $c0, $80, $00, $00, $38, $1c, $1c, $1c, $3c, $78, $f0, $00
    .byte $00, $00, $00, $00, $00, $00, $60, $c0, $00, $00, $00, $00, $00, $0f, $7f, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $18, $00, $00, $00, $00, $00, $e0, $f8, $fc
    .byte $80, $80, $80, $c0, $c0, $60, $38, $2c, $ff, $ff, $ff, $fe, $fe, $7e, $3e, $2f
    .byte $04, $00, $00, $90, $90, $00, $00, $02, $c6, $82, $02, $02, $02, $04, $04, $08
    .byte $60, $43, $43, $00, $00, $00, $20, $11, $71, $7c, $7c, $5d, $5d, $5d, $6d, $f7
    .byte $06, $8e, $d0, $b0, $d0, $90, $b0, $f0, $88, $f8, $7a, $fa, $fa, $fa, $fa, $fc
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $0f, $1f, $1f, $1f, $0f, $00, $0b, $00, $00, $00, $00, $10, $0f, $00, $0a
    .byte $00, $f0, $f8, $f8, $f8, $f0, $00, $f0, $00, $00, $00, $00, $08, $f0, $00, $a0
    .byte $0b, $0b, $0b, $0b, $13, $19, $1f, $0f, $0a, $0a, $0a, $0a, $12, $11, $18, $0f
    .byte $f0, $f0, $f0, $f0, $f8, $f8, $f8, $f0, $a0, $a0, $a0, $a0, $b0, $e0, $08, $f0
    .byte $00, $00, $03, $0f, $1f, $1f, $1f, $3f, $00, $00, $00, $00, $00, $00, $00, $20
    .byte $00, $00, $e0, $f0, $f0, $f8, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $3c, $3e, $3f, $1f, $1f, $0f, $07, $00, $38, $30, $30, $19, $1e, $3f, $2f, $70
    .byte $4c, $dc, $fc, $f8, $fb, $fb, $f0, $30, $04, $04, $64, $98, $68, $fc, $fd, $3d
    .byte $00, $00, $00, $00, $00, $00, $00, $01, $7e, $7e, $7e, $7e, $7e, $7e, $7e, $fc
    .byte $d0, $d0, $30, $90, $90, $90, $90, $08, $1d, $0d, $0d, $6d, $6f, $6c, $6e, $f7
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $22, $22, $62, $22, $22, $22, $26, $22, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee
    .byte $00, $22, $00, $ff, $00, $00, $00, $00, $00, $ee, $00, $ff, $ff, $ff, $ff, $ff
    .byte $00, $22, $00, $fc, $08, $08, $08, $08, $00, $ee, $00, $fc, $f8, $f8, $f8, $f8
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $6c, $ff, $ff, $ff, $df, $df, $df, $00, $00, $87, $af, $ef, $df, $df, $df
    .byte $00, $00, $f0, $fc, $fe, $fe, $fc, $fc, $00, $00, $f0, $fc, $fe, $f6, $f4, $c4
    .byte $9f, $9f, $8f, $87, $01, $04, $03, $1d, $9f, $9c, $8c, $84, $00, $1c, $3e, $3f
    .byte $e8, $e8, $f8, $f8, $f0, $10, $f0, $ec, $80, $80, $80, $10, $00, $18, $1c, $fc
    .byte $38, $3e, $1e, $00, $00, $00, $00, $00, $21, $00, $00, $01, $0f, $1f, $1f, $3f
    .byte $0c, $ff, $07, $00, $00, $00, $00, $00, $f0, $f0, $f0, $f0, $f0, $f8, $f8, $fc
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $22, $22, $02, $22, $22, $20, $22, $22, $ee, $ee, $ee, $ee, $ee, $ee, $ee, $ee
    .byte $00, $ff, $00, $00, $00, $00, $00, $c0, $00, $ff, $ff, $ff, $ff, $f0, $c0, $c0
    .byte $00, $fe, $00, $00, $00, $00, $00, $06, $00, $fe, $fe, $fe, $fe, $1e, $06, $06
    .byte $00, $0f, $30, $1f, $12, $54, $3e, $24, $00, $0f, $30, $3f, $7f, $5f, $7e, $7f
    .byte $00, $f0, $0c, $f8, $48, $2a, $7c, $24, $00, $f0, $0c, $fc, $fe, $fa, $7e, $fe
    .byte $24, $24, $44, $3e, $14, $54, $32, $1f, $7f, $7f, $5f, $7e, $7f, $7f, $3f, $1f
    .byte $24, $24, $22, $7c, $28, $2a, $4c, $f8, $fe, $fe, $fa, $7e, $fe, $fe, $fc, $f8
    .byte $07, $0f, $1f, $1f, $3f, $3f, $3f, $3f, $07, $0f, $1f, $1f, $3f, $3f, $33, $31
    .byte $f0, $fc, $fe, $f2, $fe, $fc, $88, $dc, $f0, $fc, $fe, $f2, $e6, $84, $00, $00
    .byte $3f, $1f, $1d, $04, $00, $00, $0d, $1f, $31, $18, $1c, $04, $3c, $73, $62, $40
    .byte $fc, $fc, $fc, $fb, $03, $01, $c0, $c0, $00, $1c, $3c, $00, $00, $cc, $36, $2f
    .byte $1f, $0f, $00, $0f, $07, $00, $00, $03, $40, $20, $30, $30, $30, $00, $1f, $1c
    .byte $c0, $00, $fe, $fe, $fe, $00, $00, $dc, $36, $2e, $00, $00, $00, $00, $b8, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $bd, $bd, $de, $de, $bd, $bd, $de, $de, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $bd, $bd, $00, $00, $aa, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $aa, $aa, $aa
    .byte $bd, $bd, $00, $00, $aa, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $aa, $aa, $aa
    .byte $00, $0c, $10, $0c, $00, $07, $06, $07, $00, $0f, $10, $0f, $00, $07, $07, $07
    .byte $00, $00, $00, $00, $00, $c0, $00, $80, $00, $f0, $08, $f0, $00, $e0, $e0, $e0
    .byte $0c, $1e, $38, $3e, $30, $3f, $18, $07, $0f, $1f, $3f, $3f, $3f, $3f, $1f, $07
    .byte $00, $00, $00, $00, $00, $00, $00, $c0, $f0, $f8, $fc, $fc, $fc, $fc, $f8, $e0
    .byte $00, $07, $1f, $3f, $2f, $29, $29, $2b, $00, $00, $00, $00, $30, $3f, $0f, $00
    .byte $00, $c0, $f0, $e8, $e8, $3c, $78, $a0, $00, $00, $00, $18, $38, $e0, $80, $04
    .byte $5b, $7b, $f7, $ff, $ff, $00, $1f, $3f, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $80, $80, $98, $b0, $00, $ec, $fc, $fc, $1e, $3f, $38, $38, $12, $03, $03, $03
    .byte $3f, $3f, $37, $37, $3b, $7b, $7d, $fe, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $fc, $fc, $fc, $fc, $fc, $fc, $f8, $fe, $00, $00, $00, $00, $00, $00, $00, $1e
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $01, $02, $04, $08, $10, $20, $40, $80, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $08, $7c, $10, $3a, $4c, $24, $20, $1e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $3c, $02, $02, $04, $18, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $28, $3e, $62, $14, $10, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $08, $5c, $6a, $4a, $1c, $08, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $08, $0e, $08, $18, $2c, $12, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
