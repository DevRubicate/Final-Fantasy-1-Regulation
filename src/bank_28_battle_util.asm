.segment "BANK_28"

.include "src/global-import.inc"

.import BattleRNG, WaitForVBlank, MusicPlay

.export BattleScreenShake, BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleScreenShake  [$F440 :: 0x3F450]
;;
;;  Shakes the screen for a few frames (when an enemy attacks)
;;
;;  This routine takes 13 frames, and during that time, the sound effects
;;  are NOT updated.  This results in the sound effect the game makes when
;;  an enemy attacks to hang on the low-pitch 'BOOM' noise longer than
;;  its sound effect data indicates it should.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleScreenShake:
    LDA #$06
    STA loop_counter           ; loop down counter.  6*2 = 12 frames  (2 frames per loop)
  @Loop:
      CALL @Stall2Frames ; wait 2 frames
      
      FARCALL BattleRNG
      AND #$03          ; get a random number betwee 0-3
      STA PPUSCROLL         ; use as X scroll
      FARCALL BattleRNG
      AND #$03          ; another random number
      STA PPUSCROLL         ; for Y scroll
      
      DEC loop_counter
      BNE @Loop
    
    JUMP Battle_UpdatePPU_UpdateAudio_FixedBank  ; 1 more frame (with reset scroll)
    
    
  @Stall2Frames:
    CALL @Frame          ; do 1 frame
    LDX #$00            ; wait around -- presumably so we don't try
    : NOP               ;   to wait during VBlank (even though that wouldn't
      NOP               ;   be a problem anyway)
      NOP
      DEX
      BNE :-            ; flow into doing another frame
    
  @Frame:
    CALL WaitForVBlank
    JUMP BattleUpdateAudio_FixedBank


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_UpdatePPU_UpdateAudio_FixedBank  [$F485 :: 0x3F495]
;;
;;  Resets scroll and PPUMASK, then updates audio.
;;
;;  Used by only a few routines in the fixed bank.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_UpdatePPU_UpdateAudio_FixedBank:
    LDA btl_soft2001
    STA PPUMASK
    LDA #$00            ; reset scroll
    STA PPUSCROLL
    STA PPUSCROLL
    NOJUMP BattleUpdateAudio_FixedBank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleUpdateAudio_FixedBank  [$F493 :: 0x3F4A3]
;;
;;  Same idea as BattleUpdateAudio from bank $C... just in the fixed bank.
;;
;;  Note that this routine does NOT update battle sound effects.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
BattleUpdateAudio_FixedBank:
    LDA a:music_track
    BPL :+
      LDA btl_followupmusic
      STA a:music_track
    :   
    FARJUMP MusicPlay
