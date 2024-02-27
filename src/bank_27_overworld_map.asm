.segment "BANK_27"

.include "src/global-import.inc"

.import LoadOWBGCHR, LoadPlayerMapmanCHR, LoadOWObjectCHR, WaitForVBlank, GetOWTile, OverworldMovement
.import MusicPlay, PrepAttributePos, DoOWTransitions, ProcessOWInput
.import ClearOAM, DrawOWSprites, VehicleSFX

.export LoadOWCHR, EnterOverworldLoop

LoadOWCHR:                     ; overworld map -- does not load any palettes
    FARCALL LoadOWBGCHR
    FARCALL LoadPlayerMapmanCHR
    FARJUMP LoadOWObjectCHR

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
