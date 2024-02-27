.segment "BANK_26"

.include "src/global-import.inc"

.import WaitForVBlank, SetSMScroll, SetOWScroll_PPUOn, WaitVBlank_NoSprites, LoadShopBGCHRPalettes, LoadBatSprCHRPalettes

.export LoadMapPalettes, BattleTransition, LoadShopCHRPal


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Map Palettes  [$D8AB :: 0x3D8BB]
;;
;;    Note palettes are not loaded from ROM, but rather they're loaded from
;;  the load_map_pal temporary buffer (temporary because it gets overwritten
;;  due to it sharing space with draw_buf).  So this must be called pretty much
;;  immediately after the tileset is loaded.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadMapPalettes:
    LDX #$2F                ; X is loop counter
    @Loop:
        LDA load_map_pal, X   ; copy colors from temp palette buffer
        STA cur_pal, X        ; to our actual palette
        DEX
        BPL @Loop             ; loop until X wraps ($30 iterations)

    LDA ch_class            ; get lead party member's class
    ASL A                   ; double it, and put it in X
    TAX

    LDA LUT_MapmanPalettes, X   ; use that as an index to get that class's mapman palette
    STA cur_pal+$12
    LDA LUT_MapmanPalettes+1, X
    STA cur_pal+$16

    RTS                     ; then exit


LoadShopCHRPal:
    FARCALL LoadShopBGCHRPalettes
    FARJUMP LoadBatSprCHRPalettes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle Transition [$D8CD :: 0x3D8DD]
;;
;;    Does the flashy effect for when you begin a battle.  The effect
;;  does not alter the palettes like you might think... instead it uses the
;;  seldom used 'color emphasis' feature of the NES.  It basically cycles
;;  through all the emphasis modes, which makes the screen appear to flash.
;;
;;    This is also coupled with the FF trademarked and ever popular
;;  "shhhheeewww  shhhhheeewww" sound effect on the noise.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleTransition:
    LDA #$08
    STA PAPU_EN             ; silence all audio except for noise
    LDA #0
    STA tmp+12            ; zero our loop counter (tmp+12)

  ;; loop from $00 - $41

  @Loop:
    CALL WaitForVBlank   ; wait for VBlank
    LDA mapflags          ; get map flags to see if this is OW or SM
    LSR A
    BCC @OW               ; fork appropriately

  @SM:
      CALL SetSMScroll         ; set SM scroll if SM
      JUMP @Continue
  @OW:
      FARCALL SetOWScroll_PPUOn   ; or OW scroll if OW

  @Continue:
    LDA tmp+12       ; get loop counter
    ASL A
    ASL A
    ASL A            ; left shift 3 to make bits 2-4 the high bits
    AND #$E0         ; mask them out -- these are our emphasis bits
                     ; this will switch to a new emphasis mode every 4 frames
                     ; and will cycle through all 8 emphasis modes a total of 4 times

    ORA #$0A         ; OR emphasis bits with other info for PPUMASK (enable BG rendering, disable sprites)
    STA PPUMASK        ; write set emphasis

    LDA #$0F         ; enable volume decay for the noise channel
    STA PAPU_NCTL1        ;   and set it to decay at slowest speed -- but since the decay gets restarted every
                     ;   frame in this routine -- this effectively just holds the noise at maximum volume

    LDA tmp+12       ; set noise freq to (loopcounter/2)OR3
    LSR A            ;  this results in the following frequency pattern:
    ORA #$03         ; 3,3,3,3,3,3,3,3, 7,7,7,7,7,7,7,7, B,B,B,B,B,B,B,B, F,F,F,F,F,F,F,F,
    STA PAPU_NFREQ1        ;    (repeated again)

    LDA #0
    STA PAPU_NFREQ2        ; reload length counter

    INC tmp+12       ; inc our loop counter
    LDA tmp+12
    CMP #$41

    BCC @Loop        ; and keep looping until it reaches $41

    LDA #$00         ; at which point
    STA PPUMASK        ; turn off the PPU
    STA PAPU_EN        ;  and APU

    JUMP WaitVBlank_NoSprites   ; then wait for another VBlank before exiting


LUT_MapmanPalettes:
    .byte $16, $16, $12, $17, $27, $12, $16, $16, $30, $30, $27, $12, $16, $16, $16, $16
    .byte $27, $12, $16, $16, $16, $30, $27, $13, $00, $00, $00, $00, $00, $00, $00, $00
