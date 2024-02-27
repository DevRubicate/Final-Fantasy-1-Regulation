.segment "BANK_27"

.include "src/global-import.inc"

.import LoadOWBGCHR, LoadPlayerMapmanCHR, LoadOWObjectCHR, WaitForVBlank, GetOWTile, OverworldMovement
.import MusicPlay, PrepAttributePos, DoOWTransitions, ProcessOWInput
.import ClearOAM, DrawOWSprites, VehicleSFX, ScreenWipe_Open
.import LoadOWTilesetData, LoadMapPalettes, DrawFullMap, DrawMapPalette, SetOWScroll_PPUOn


.export LoadOWCHR, EnterOverworldLoop, PrepOverworld, DoOverworld

LoadOWCHR:                     ; overworld map -- does not load any palettes
    FARCALL LoadOWBGCHR
    FARCALL LoadPlayerMapmanCHR
    FARJUMP LoadOWObjectCHR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Do Overworld  [$C0CB :: 0x3C0DB]
;;
;;    Called when you enter (or exit to) the overworld.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DoOverworld:
    CALL PrepOverworld          ; do all overworld preparation
    FARCALL ScreenWipe_Open        ; then do the screen wipe effect
    NOJUMP EnterOverworldLoop   ; then enter the overworld loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Main Overworld Game Logic Loop  [$C0D1 :: 0x3C0E1]
;;
;;   This is where everything spawns from on the overworld.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterOverworldLoop:

    FARCALL GetOWTile       ; get the current overworld tile information

   ;;
   ;; THE overworld loop
   ;;

  @Loop:  
    CALL WaitForVBlank        ; wait for VBlank
    LDA #>oam                  ; and do sprite DMA
    STA OAMDMA

    FARCALL OverworldMovement      ; do any pending movement animations and whatnot
                               ;   also does any required map drawing and updates
                               ;   the scroll appropriately

    LDA framecounter           ; increment the *two byte* frame counter
    CLC                        ;   what does this game have against the INC instruction?
    ADC #1
    STA framecounter
    LDA framecounter+1
    ADC #0
    STA framecounter+1

    FARCALL MusicPlay   ; Keep the music playing

    LDA mapdraw_job            ; check to see if drawjob number 1 is pending
    CMP #1
    BNE :+
        FARCALL PrepAttributePos     ; if it is, do necessary prepwork so it can be drawn next frame
    :
    LDA move_speed             ; check to see if the player is currently moving
    BNE :+                     ; if not....
        LDA vehicle_next         ;   replace current vehicle with 'next' vehicle
        STA vehicle
        CALL DoOWTransitions      ; check for any transitions that need to be done
        FARCALL ProcessOWInput       ; process overworld input
    :
    FARCALL ClearOAM           ; clear OAM
    FARCALL DrawOWSprites      ; and draw all overworld sprites
    FARCALL VehicleSFX

    JUMP @Loop         ; then jump back to loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Overworld  [$C6FD :: 0x3C70D]
;;
;;    Sets up everything for entering (or re-entering) the world map.
;;  INCLUDING map decompression.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepOverworld:
    LDA #0
    STA PPUCTRL           ; disable NMIs
    STA PPUMASK           ; turn off PPU
    STA PAPU_EN           ; silence APU

    STA scroll_y        ; zero a whole bunch of other things:
    STA tileprop
    STA tileprop+1
    STA inroom
    STA entering_shop
    STA facing
    STA joy_a
    STA joy_b
    STA joy_start
    STA joy_select
    STA mapflags        ; zeroing map flags indicates we're on the overworld map

    CALL LoadOWCHR           ; load up necessary CHR
    FARCALL LoadOWTilesetData   ; the tileset
    FARCALL LoadMapPalettes     ; palettes
    FORCEDFARCALL DrawFullMap         ; then draw the map

    LDA ow_scroll_x      ; get ow scroll X
    AND #$10             ; isolate the '16' bit (nametable bit)
    CMP #$10             ; move it to C (C set if we're to use NT @ $2400)
    ROL A                ; roll that bit into bit 0
    AND #$01             ; isolate it
    ORA #$08             ; OR with 8 (sprites use right-hand pattern table)
    STA NTsoft2000       ; record this as our soft2000
    STA soft2000

    CALL WaitForVBlank       ; wait for a VBlank
    CALL DrawMapPalette        ; before drawing the palette
    FARCALL SetOWScroll_PPUOn     ; the setting the scroll and turning PPU on
    LDA #0                    ;  .. but then immediately turn PPU off!
    STA PPUMASK                 ;     (stupid -- why doesn't it just call the other SetOWScroll that doesn't turn PPU on)

    LDX vehicle
    LDA @lut_VehicleMusic, X  ; use the current vehicle as an index
    STA music_track           ;   to get the proper music track -- and play it

    RTS                   ; then exit!

  ;;  The lut for knowing which track to play based on the current vehicle

  @lut_VehicleMusic:
  .byte $44               ; unused
  .byte $44               ; on foot
  .byte $44,$44           ; canoe (2nd byte unused)
  .byte $45,$45,$45,$45   ; ship (last 3 bytes unused)
  .byte $46               ; airship
