.segment "BANK_26"

.include "src/global-import.inc"

.import WaitForVBlank, SetSMScroll, SetOWScroll_PPUOn, WaitVBlank_NoSprites, LoadShopBGCHRPalettes, LoadBatSprCHRPalettes
.import LoadOWMapRow, PrepAttributePos

.export LoadMapPalettes, BattleTransition, LoadShopCHRPal, StartMapMove, DrawMapAttributes, DoMapDrawJob, DrawFullMap
.export DrawMapRowCol, PrepSMRowCol, PrepRowCol

LUT_MapmanPalettes:
    .byte $16, $16, $12, $17, $27, $12, $16, $16, $30, $30, $27, $12, $16, $16, $16, $16
    .byte $27, $12, $16, $16, $16, $30, $27, $13, $00, $00, $00, $00, $00, $00, $00, $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$D5E2 :: 0x3D5F2]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row of map tiles
;;    Really, they just shortcut a multiplication by $40
;;
;;  "2x" because they're really 2 rows (each row is $20, these increment by $40).  This is because
;;  map tiles are 2 ppu tiles tall

lut_2xNTRowStartLo:    .byte  $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
lut_2xNTRowStartHi:    .byte  $20,$20,$20,$20,$21,$21,$21,$21,$22,$22,$22,$22,$23,$23,$23,$23


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

    FARJUMP WaitVBlank_NoSprites   ; then wait for another VBlank before exiting





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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Map Draw Job  [$D0E9 :: 0x3D0F9]
;;
;;     This performs the indicated map drawing job.
;;
;;  job=1  update map attributes to reflect the new row/col being scrolled in
;;  job=2  update map tiles to reflect the new row/col
;;  other  do nothing
;;
;;     The mapdraw_job is then decremented to indicate the previous
;;  job was complete (and move onto the next job)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoMapDrawJob:
    LDA PPUSTATUS           ; reset PPU toggle  (seems odd to do here...)

    LDA mapdraw_job     ; find which job we're to do
    SEC
    SBC #1              ; decrement the job (to mark this job as complete 
    STA mapdraw_job     ;   and to move to the next job)

    BEQ @Attributes     ; if original job was 1 (0 after decrement)... do attributes

    CMP #1              ; otherwise, if original job was 2 (1 after decrement)
    BEQ @Tiles          ;   ... do a row/column of tiles

    RTS                 ; if job was neither of those, do nothing and just exit

  @Tiles:
    CALL DrawMapRowCol       ; draw a row or column of tiles
    RTS                     ;  and exit

  @Attributes:
    CALL DrawMapAttributes   ; draw attributes
    RTS                     ;  and exit


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Full Map   [$CFE7 :: 0x3CFF7]
;;
;;    Draws 15 rows of tiles for the map, filling the entire screen.
;;  It accomplishes this by adding 15 to the map scroll, then faking
;;  upward movement to draw rows bottom first.
;;
;;    For Standard maps, this does no map decompression.  However for the overworld,
;;  each row is decompressed prior to drawing.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawFullMap:
    LDA #0
    STA scroll_y         ; zero y scroll

    LDA mapflags         ; see if we're on the overworld or not
    LSR A                ; put SM flag in C
    BCS @SM              ;  and jump ahead if in SM
  @OW:
     LDA ow_scroll_y     ; add 15 to OW scroll Y
     CLC
     ADC #15
     STA ow_scroll_y
     JUMP @StartLoop

  @SM:
     LDA sm_scroll_y     ; same, but add to sm scroll
     CLC
     ADC #15
     AND #$3F            ; and wrap around map boundary
     STA sm_scroll_y

  @StartLoop:
    LDA #$08
    STA facing           ; have the player face upwards (for purposes of following loop)

   @Loop:
      CALL StartMapMove       ; start a fake move upwards (to prep the next row for drawing)
      CALL DrawMapRowCol      ; then draw the row that just got prepped
      FARCALL PrepAttributePos   ; prep attributes for that row
      CALL DrawMapAttributes  ; and draw them
      CALL ScrollUpOneRow     ; then force a scroll upward one row

      LDA scroll_y           ; check scroll_y
      BNE @Loop              ; and loop until it reaches 0 again (15 iterations)

    LDA #0
    STA facing           ; clear facing
    STA mapdraw_job      ; clear the draw job (all drawing is done)
    STA move_speed       ; clear move speed (player isn't moving)

       ; those above 3 lines essentially "cancel" the fake moves that were only
       ;   performed to draw the map.

    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ScrollUpOneRow  [$D102 :: 0x3D112]
;;
;;    This is used by DrawFullMap to "scroll" up one row so that
;;  the next row can be drawn.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScrollUpOneRow:
    LDA mapflags        ; see if this is OW or SM by checking map flags
    LSR A
    BCC @OW             ; if OW, jump ahead to OW

  @SM:
    LDA sm_scroll_y     ; otherwise (SM), subtract 1 from the sm_scroll
    SEC
    SBC #$01
    AND #$3F            ; and wrap where needed
    STA sm_scroll_y

    JUMP @Finalize

  @OW:
    LDA ow_scroll_y     ; if OW, subtract 1 from ow_scroll
    SEC
    SBC #$01
    STA ow_scroll_y

  @Finalize:
    LDA scroll_y        ; then subtract 1 from scroll_y
    SEC
    SBC #$01
    BCS :+
      ADC #$0F          ; and wrap 0->E
    :   
    STA scroll_y
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Row or Column  [$D2E9 :: 0x3D2F9]
;;
;;   This will draw all the tiles in 1 row OR 1 column to the nametable
;;   This is done every time the player takes a step on the map to keep the nametables
;;    updated so that the map appears to be drawn correctly as the player scrolls around
;;
;;   Tiles' TSA have been pre-rendered to an intermediate buffer ($0780-07BF)
;;     draw_buf_ul = UL portion of the tiles
;;     draw_buf_ur = UR portion
;;     draw_buf_dl = DL portion
;;     draw_buf_dr = DR portion
;;
;;   This routine simply copies that pre-rendered data to the NT, so that it becomes
;;    visible on-screen
;;
;;   This routine does not update attributes (see DrawMapAttributes)
;;
;;   16 tiles are drawn if it is to draw a full row.  15 if it is to draw a full column.
;;
;;   Code seems verbose here, like it could've been coded to be smaller, however this is
;;    time critical drawing code (must all be completed in VBlank), so it being more verbose
;;    and lengthy probably keeps it faster than it would be otherwise.. which is very important
;;    for this kind of thing.
;;
;;   mapdraw_nty and mapdraw_ntx the Y,X coords on the NT to start drawing to.  Columns
;;    will draw downward from this point, and rows will draw rightward.
;;
;;  TMP:  tmp through tmp+2 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapRowCol:
    LDX mapdraw_nty           ; get target row draw to
    LDA lut_2xNTRowStartLo, X ; use it to index LUT to find NT address of that row
    STA tmp
    LDA lut_2xNTRowStartHi, X
    STA tmp+1                 ; (tmp) now dest address
    LDA mapdraw_ntx           ; get target column to draw to
    CMP #$10
    BCS @UseNT2400            ; if column >= $10, we need to switch to NT at $2400, otherwise, use NT at PPUCTRL

              ; if column < $10 (use NT PPUCTRL)
    TAX                 ; back up column to X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.  Dest pointer now points to NT start of desired tile
    STA tmp
    JUMP @DetermineRowOrCol

    @UseNT2400:     ; if column >= $10 (use NT $2400)

    AND #$0F            ; mask low bits
    TAX                 ; put column in X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.
    STA tmp
    LDA tmp+1           ; add 4 to high byte (changing NT from PPUCTRL to $2400)
    CLC
    ADC #$04            ; Dest pointer is now prepped
    STA tmp+1

       ; no matter which NT (PPUCTRL/$2400) is being drawn to, both forks reconnect here
    @DetermineRowOrCol:

    LDA mapflags          ; find out if we're moving drawing a row or column
    AND #$02
    BEQ @DoRow
    JUMP @DoColumn


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoRow:

    TXA              ; put column number in A
    EOR #$0F         ; invert it
    TAX              ; put it back in X, increment it, then create a back-up of it in tmp+2
    INX              ; This creates a down-counter:  it is '16 - column_number', indicating the number of
    STX tmp+2        ;   columns that must be drawn until we reach the NT boundary
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; reset PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest addr
    LDA tmp
    STA PPUADDR

    @RowLoop_U:

    LDA draw_buf_ul, Y ; load 2 tiles from drawing buffer and draw them
    STA PPUDATA          ;   first UL
    LDA draw_buf_ur, Y ;   then UR
    STA PPUDATA
    INY              ; inc source index (to look at next tile)
    DEX              ; dec down counter
    BNE :+           ; if it expired, we've reached NT boundary

      LDA tmp+1      ; at NT boundary... so load high byte
      EOR #$04       ;  toggle NT bit
      STA PPUADDR      ;  and write back as the new high byte
      LDA tmp        ; then get low byte
      AND #$E0       ;  snap it to start of the row
      STA PPUADDR      ;  and write back as the new low byte

    :   
    CPY #$10         ; see if we've drawn 16 tiles yet (one full row)
    BCC @RowLoop_U   ; if not, continue looping

    LDA tmp
    CLC              ; add #$20 to low byte of dest pointer so that
    ADC #$20         ;  it points it to the next row of NT tiles
    STA tmp
    LDA tmp+1
    STA PPUADDR        ; then re-copy the dest addr to set the PPU address
    LDA tmp
    STA PPUADDR
    LDY #$00         ; zero our source index again
    LDX tmp+2        ; restore X to our down counter

    @RowLoop_D:

    LDA draw_buf_dl, Y ; repeat same tile copying work done above,
    STA PPUDATA          ;   but this time we're drawing the bottom half of the tiles
    LDA draw_buf_dr, Y ;   first DL
    STA PPUDATA          ;   then DR
    INY                ; inc source index (next tile)
    DEX                ; dec down counter (for NT boundary)
    BNE :+
    
      LDA tmp+1      ; at NT boundary again.. same deal.  load high byte of dest
      EOR #$04       ;   toggle NT bit
      STA PPUADDR      ;   and write back
      LDA tmp        ; load low byte
      AND #$E0       ;   snap to start of row
      STA PPUADDR      ;   write back

    :   
    CPY #$10
    BCC @RowLoop_D   ; loop until all 16 tiles drawn
    RTS              ; and RTS out (full rown drawn)


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoColumn:

    LDA #$0F         ; prep down counter so that it
    SEC              ;  is 15 - target_row
    SBC mapdraw_nty  ;  This is the number of rows to draw until we reach NT boundary (to be used as down counter)
    TAX              ; put downcounter in X for immediate use
    STX tmp+2        ; and back it up in tmp+2 for future use
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; clear PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest address
    LDA tmp
    STA PPUADDR
    LDA #$04
    STA PPUCTRL        ; set PPU to "inc-by-32" mode -- for drawing columns of tiles at a time

    @ColLoop_L:

    LDA draw_buf_ul, Y ; draw the left two tiles that form this map tile
    STA PPUDATA          ;   first UL
    LDA draw_buf_dl, Y ;   then DL
    STA PPUDATA
    DEX              ; dec our down counter.
    BNE :+           ;   once it expires, we've reach the NT boundary

      LDA tmp+1      ; at NT boundary.. get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte
      AND #$1F       ;   snap to top, while retaining current column
      STA PPUADDR      ;   and write back

    :   
    INY              ; inc our source index
    CPY #$0F
    BCC @ColLoop_L   ; and loop until we've drawn 15 tiles (one full column)


                     ; now that the left-hand tiles are drawn, draw the right-hand tiles
    LDY #$00         ; clear our source index
    LDA tmp+1        ; restore dest address
    STA PPUADDR
    LDA tmp          ; but add 1 to the low byte (to move to right-hand column)
    CLC              ;   note:  the game does not write back to tmp -- why not?!!
    ADC #$01
    STA PPUADDR
    LDX tmp+2        ; restore down counter into X

    @ColLoop_R:

    LDA draw_buf_ur, Y ; load right-hand tiles and draw...
    STA PPUDATA          ;   first UR
    LDA draw_buf_dr, Y ;   then DR
    STA PPUDATA
    DEX                ; dec down counter
    BNE :+             ; if it expired, we're at the NT boundary

      LDA tmp+1      ; at NT boundary, get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte of dest
      CLC            ;   and add 1 (this could've been avoided if it wrote back to tmp above)
      ADC #$01       ;   anyway -- adding 1 move to right-hand column (again)
      AND #$1F       ;   snap to top of NT, while retaining current column
      STA PPUADDR      ;   and write to low byte of PPU address

    :   
    INY              ; inc our source index
    CPY #$0F         ; loop until we've drawn 15 tiles
    BCC @ColLoop_R   ;  once we have... 
    RTS              ;  RTS out!  (full column drawn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Standard Map Row or Column [$D1E4 :: 0x3D1F4]
;;
;;   Preps the TSA and Attribute bytes of the given row of a Standard map for drawing
;;    Standard maps mainly.  Overworld does not always use this routine.  See PrepRowCol
;;
;;   Data loaded is put in the intermediate drawing buffer to be later drawn
;;    via DrawMapAttributes and DrawMapRowCol
;;
;;   Note while this loads the attribute byte, it does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;  IN:  X     = Assumed to be set to 0.  This routine does not explicitly set it
;;       (tmp) = pointer to start of map data to prep
;;       tmp+2 = low byte of pointer to the start of the ROW indicated by (tmp).
;;                 basically is (tmp) minus column information
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepSMRowCol:
    LDA mapflags      ; see if we're drawing a row/column
    AND #$02
    BNE @ColumnLoop

  @RowLoop:
    LDY #$00          ; zero Y for following index
    LDA (tmp), Y      ; read a tile from source
    TAY               ; put the tile in Y for a source index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; increment source pointer by 1
    CLC
    ADC #1
    AND #$3F          ; but wrap from $3F->00 (standard maps are only 64 tiles wide)
    ORA tmp+2         ; ORA with original address to retain bits 6,7
    STA tmp           ; write incremented+wrapped address back to pointer
    INX               ; increment our dest index
    CPX #$10          ; and loop until it reaches 16 (full row)
    BCC @RowLoop
    RTS

  @ColumnLoop:
    LDY #$00          ; More of the same, as above.  Only we draw a column instead of a row
    LDA (tmp), Y      ; get the tile
    TAY               ; and put it in Y to index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; Add 64 ($40) to our source pointer (since maps are 64 tiles wide)
    CLC
    ADC #$40
    STA tmp
    LDA tmp+1
    ADC #$00          ; Add any carry from the low byte addition
    AND #$0F          ; wrap at $0F
    ORA #>mapdata     ; and ORA with high byte of map data to keep the pointer looking at map data at in RAM $7xxx
    STA tmp+1
    INX               ; increment dest pointer
    CPX #$10          ; and loop until it reaches 16 (more than a full column -- probably could only go to 15)
    BCC @ColumnLoop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Map Row or Column [$D258 :: 0x3D268]
;;
;;    Same job as PrepSMRowCol, (see that description for details)
;;   The difference is that PrepSMRowCol is specifically geared for Standard Maps,
;;   whereas this routine is built to cater to both Standard and overworld maps (this routine
;;   will jump to PrepSMRowCol where appropriate)
;;
;;   Again note that this does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepRowCol:
    LDX #$00          ; zero X (our dest index)
    LDA mapflags      ; see if we're on the overworld, or in a standard map
    LSR A
    BCC @DoOverworld  ; if we're on the overworld, jump ahead to overworld routine

       ; otherwise (we're in a standard map) -- do some pointer prepwork
       ; then call PrepSMRowCol

       LDA mapdraw_y     ; load the row number we're prepping
       LSR A             ; right shift by 2, rotating bits into tmp+2
       ROR tmp+2         ;  this is effectively the same as rotating left by 6 (multiply by 64)
       LSR A             ;  only much shorter in code
       ROR tmp+2         ; tmp+2 is now *almost* the low byte of the src pointer for the start of this row (still has garbage bits)
       ORA #>mapdata     ; after ORing, A is now the high byte of the src pointer
       STA tmp+1         ; write the src pointer to tmp
       LDA tmp+2         ; get low byte
       AND #$C0          ;  kill garbage bits
       STA tmp+2         ;  and write back
       ORA mapdraw_x     ; OR with current column number
       STA tmp           ; write low byte with column to
       JUMP PrepSMRowCol  ; tmp, tmp+1, and tmp+2 are all prepped to what PrepSMRowCol needs -- so call it

    @DoOverworld:

   LDA mapdraw_y ; get the row number
   AND #$0F      ; mask out the low 4 bits (only 16 rows of the OW map are loaded at a time)
   ORA #>mapdata
   STA tmp+1     ; tmp+1 is now the high byte of the src pointer
   LDA mapdraw_x
   STA tmp       ; and the low byte ($10) is just the column number
   LDA mapflags
   AND #$02      ; see if we are to load a row or a column
   BNE @DoColumn ; jump ahead to column routine if doing a column

  @DoRow:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get desired tile from the map
     TAY           ; put that tile in Y to act as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     INC tmp       ; increment low byte of src pointer.  no need to catch wrapping, as the map wraps at 256 tiles
     INX           ; increment our dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full row)
     BCC @DoRow
     RTS

  @DoColumn:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get tile from the map
     TAY           ; and use it as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     LDA tmp+1     ; load high byte of src pointer
     CLC
     ADC #$01      ;  increment it by 1 (next row in the column)
     AND #$0F      ;  but wrap as to not go outside of map data in RAM
     ORA #>mapdata
     STA tmp+1     ; write incremented and wrapped high byte back
     INX           ; increment dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full column)
     BCC @DoColumn
     RTS
