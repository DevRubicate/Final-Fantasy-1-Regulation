.segment "BANK_26"

.include "src/global-import.inc"

.import WaitForVBlank, SetSMScroll, SetOWScroll_PPUOn, WaitVBlank_NoSprites, LoadShopBGCHRPalettes, LoadBatSprCHRPalettes
.import LoadOWMapRow, PrepRowCol

.export LoadMapPalettes, BattleTransition, LoadShopCHRPal, StartMapMove, DrawMapAttributes

LUT_MapmanPalettes:
    .byte $16, $16, $12, $17, $27, $12, $16, $16, $30, $30, $27, $12, $16, $16, $16, $16
    .byte $27, $12, $16, $16, $16, $30, $27, $13, $00, $00, $00, $00, $00, $00, $00, $00

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





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Start Map Move    [$D023 :: 0x3D033]
;;
;;    This routine starts the player moving in the direction they're facing.
;;
;;    The routine does not check to see if a move is legal.  Once this
;;  routine is called, it's assumed it's a legal move and the player starts
;;  moving unconditionally.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

StartMapMove:
    LDA scroll_y         ; copy Y scroll to 
    STA mapdraw_nty      ;   nt draw Y

    LDA #$FF             ; put overworld mask ($FF -- ow is 256x256 tiles )
    STA tmp+8            ; in tmp+8 for later
    LDX ow_scroll_x      ; put scrollx in X
    LDY ow_scroll_y      ; and scrolly in Y

    LDA mapflags         ; get mapflags
    LSR A                ; shift SM bit into C
    BCC :+               ; if we're in a standard map...
        LDX sm_scroll_x    ; ... replace above OW data with SM versions
        LDY sm_scroll_y    ; scrollx in X, scrolly in Y
        LDA #$3F           ; and sm mask ($3F -- 64x64) in tmp+8
        STA tmp+8
    : 

    STX mapdraw_x        ; store desired scrollx in mapdraw_x
    STY mapdraw_y        ; and Y scroll

    TXA                  ; then put X scroll in A
    AND #$1F             ; mask out low bits (32 tiles in a 2-NT wide window)
    STA mapdraw_ntx      ; and that's our nt draw X

    LDA facing           ; check which direction we're facing
    LSR A                ; shift until we find the appropriate direction, and branch to it
    BCS @Right
    LSR A
    BCS @Left
    LSR A
    BCS @Down
    LSR A
    BCS @Up

    RTS                  ; if not facing any direction (doing initial map draw), just exit


  @Right:
    LDA sm_scroll_x      ; update player's SM coord to be the SM scroll
    CLC                  ;  +7 (to center him on screen), +1 (to move him right one)
    ADC #7+1
    AND #$3F             ; and wrap around edge of map
    STA sm_player_x

    LDA mapdraw_x        ; add 16 to the mapdraw_x (draw a column on the right side -- 16 tiles to right of screen)
    CLC
    ADC #16

  @Horizontal:
    AND tmp+8            ; mask column with map mask ($FF for OW, $3F for SM)
    STA mapdraw_x        ; set that as our new mapdraw_x

    AND #$1F             ; from that, calculate the NTX
    STA mapdraw_ntx

    LDA mapflags         ; set the 'draw column' map flag
    ORA #$02
    STA mapflags

    CALL PrepRowCol       ; and prep the column

  @Finalize:
    LDA #$02
    STA mapdraw_job      ; mark that drawjob #2 needs to be done (tiles need drawing)

    LDA #$01
    STA move_speed       ; set movement speed to move in desired direction

    LDA mapflags         ; check map flags
    LSR A                ; put SM flag in C
    BCS @Exit            ; if in a SM, just exit

    LDA vehicle          ; otherwise (OW), get current vehicle
    CMP #$02
    BCC @Exit            ; if vehicle is < 2 (on foot), exit (speed remains 1)

    LSR A                ; otherwise, replace speed with vehicle/2
    STA move_speed       ;  which works out to:  canoe=1   ship=2   airship=4

  @Exit:
    RTS

  @Left:
    LDA sm_scroll_x      ; exactly the same as @Right... except..
    CLC
    ADC #7-1             ; 7-1 to move him left, instead of right
    AND #$3F
    STA sm_player_x

    LDA mapdraw_x
    SEC
    SBC #1               ; and subtract 1 from the mapdraw column (one tile left of screen)

    JUMP @Horizontal


  @Down:
    LDA sm_scroll_y      ; calculate player SM Y position
    CLC                  ; based on SM scroll Y
    ADC #7+1             ; +7 to center him, +1 to move him down 1
    AND #$3F             ; mask to wrap around map boundaries
    STA sm_player_y

    LDA #15              ; want to add 15 rows to mapdraw_y.  For whatever reason
    STA tmp              ;   this addition is done in @Vertical.  So write the desired addivite to tmp

    LDA mapdraw_nty      ; add $F to the NT Y
    CLC                  ;   just so we can subtract it later
    ADC #$0F             ; Waste of time.  The row to draw to is the row that we're scrolled to
    CMP #$0F             ;   so we don't need to change mapdraw_nty at all when moving down
    BCC @Vertical        ; will never branch

    SEC                  ; subtract the $F we just added (dumb)
    SBC #$0F
    JUMP @Vertical

  @Up:
    LDA sm_scroll_y      ; same idea as @Down
    CLC
    ADC #7-1             ; only -1 to move up 1 tile
    AND #$3F
    STA sm_player_y

    LDA #-1              ; we want to subtract 1 from mapdraw_y
    STA tmp              ;  which is the same as adding -1  ($FF)

    LDA mapdraw_nty
    SEC
    SBC #$01             ; subtract 1 from mapdraw_nty.  Unlike for @Down -- this is actually important
    BCS @Vertical
    CLC
    ADC #$0F             ; but wrap from 0->E

  @Vertical:
    STA mapdraw_nty      ; record new NT Y

    LDA mapdraw_y        ; get mapdraw_y
    CLC
    ADC tmp              ; add our additive to it (down = 15,up = -1)
    AND tmp+8            ; mask with map size to keep within map bound
    STA mapdraw_y        ; write back

    LDA mapflags         ; turn off the 'draw column' map flag
    AND #~$02            ; to indicate we want to draw a row
    STA mapflags

    FORCEDFARCALL LoadOWMapRow     ; need to decompress a new row when moving vertically on the OW map
    CALL PrepRowCol       ; then prep the row
    JUMP @Finalize        ; and jump to @Finalize to do final stuff


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Attributes   [$D46F :: 0x3D47F]
;;
;;    This uses a little EOR magic to set the appropriate bits in the attribute table.
;;   The general idea is... each map tile has an attribute byte assigned to it.  This byte
;;   is always the same 2 bits repeated 4 times:  $00, $55, $AA, or $FF.  This byte is copied
;;   to the intermediate drawing buffer in full... along with a mask ($03, $0C, $30, or $C0)
;;   to indicate which bits of the attribute byte we are to replace (since each map tile only
;;   represents 2 bits of the attribute byte).
;;
;;    The EOR magic works on the following 2 rules about EOR:
;;      1)  a EOR b = c.  and c EOR b = a.  IE:  EORing with the same value twice gets you the original value
;;      2)  0 EOR b = b.  IE:  EOR works just as OR does if the original source is 0
;;
;;    The code applies this in 3 parts.  To illustrate, I'll use diagrams.  Each letter represents a
;;     bit in the attribute byte.  For this example, let's say the code is to replace bits 2-3 of the attribute byte:
;;
;;      [aaaa aaaa]    <---  'a' = original attribute bits
;;   Step 1 = EOR by the tile's attribute bits
;;      [iiii iiii]    <---  'i' = original attribute bits EOR'd with desired attribute bits
;;   Step 2 = Mask out desired attribute bits
;;      [0000 ii00]    <---  The mask isolates the bits we're interested in
;;   Step 3 = EOR by original attribute byte
;;      [aaaa ddaa]    <---  'a' = original attribute bits, 'd' = desired attribute bits
;;
;;   This works because 0 EOR a = a
;;                  and i EOR a = d  (because a EOR d = i, as per step 1)
;;
;;   This code is timing critical, as it's done every time the player takes a step on the map
;;
;;   The intermediate drawing buffer is used as follows:
;;    draw_buf_attr:    desired attribute byte for tile 'x'
;;    draw_buf_at_hi:   high byte of PPU address in attribute tables for tile 'x'
;;    draw_buf_at_lo:   low byte of PPU address
;;    draw_buf_at_msk:  mask indicating which attribute bits are to be changed in given byte.
;;
;;   TMP:  tmp and tmp+1 are used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapAttributes:
    LDA mapflags
    LDX #$10        ; set X to $10 (if row)
    AND #$02        ; check if we're drawing a row or column
    BEQ :+ 
      LDX #$0F      ; set X to $0F (if column)
    :
    STX tmp+1       ; dump X to tmp+1.  This is our upper-bound
    LDX #$00        ; clear X (source index)
    LDA PPUSTATUS       ; reset PPU toggle

    @Loop:
    LDA draw_buf_at_hi, X  ; set our PPU addr to desired value
    STA PPUADDR
    LDA draw_buf_at_lo, X
    STA PPUADDR
    LDA PPUDATA              ; dummy PPU read to fill read buffer
    LDA PPUDATA              ; read the attribute byte at the desired address
    STA tmp                ; back it up in temp ram
    EOR draw_buf_attr, X   ; EOR with attribute byte to make attribute bits inversed (so that the next EOR will correct them)
    AND draw_buf_at_msk, X ; mask out desired attribute bits
    EOR tmp                ; EOR again with original byte, correcting desired attribute bits, and restoring other bits
    LDY draw_buf_at_hi, X  ; reload desired PPU address with Y (so not to disrupt A)
    STY PPUADDR
    LDY draw_buf_at_lo, X
    STY PPUADDR
    STA PPUDATA              ; write new attribute byte back to attribute tables
    INX                    ; inc our source index
    CPX tmp+1              ; and loop until it reaches our upper-bound
    BCC @Loop
    RTS             ; exit once we've done them all
