.segment "BANK_15"

.include "src/global-import.inc"

.import DisableAPU, SetRandomSeed, EnterIntroStory, EnterTitleScreen, VerifyChecksum, NewGamePartyGeneration, ClearZeroPage, DoOverworld

.export GameStart

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Game Start [$C012 :: 0x3C022]
;;
;;    The game code starts here.  This is jumped to after the reset vector
;;  preps all the necessary hardware stuff.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GameStart:
    LDA #0                      ; Turn off the PPU
    STA PPUCTRL
    STA PPUMASK
    
    LDA #$08                    ; Sprites use pattern table at $1xxx
    STA soft2000
    STA NTsoft2000
    
    LDX #$FF                    ; reset stack pointer
    TXS
    
    FARCALL DisableAPU              ; Silence/disable all audio
    
    ;; Load some startup info
    
    FARCALL SetRandomSeed
    
    LDX #$00                        ; Loop $100 times to fill each page of unsram
    : LDA LUT_InitGameFlags, X      ; game flags page loaded from this table
      STA game_flags, X
      
      LDA #0                        ; character stats are set after party generation
      STA ch_stats, X
      STA ch_magicdata, X
      STA unsram, X


      INX                           ; loop for the full page
      BNE :-
      
    LDX #$1D                        ; Loop $3B times to fill each page of unsram
    : LDA LUT_InitUnsramFirstPage, X; Page 0 of unsram is loaded from this table
      STA unsram, X
      DEX                           ; loop for the full page
      BPL :-
      
    LDA #40
    STA ch_exptonext                ; initialize exptonext.  40 XP to get to level 2
    STA ch_exptonext + (1<<6)
    STA ch_exptonext + (2<<6)
    STA ch_exptonext + (3<<6)
    
    LDA #$01                        ; start on foot
    STA unsram_vehicle
    
    LDA startintrocheck             ; check a random spot in memory.  This value is not inialized as powerup,
    CMP #$4D                        ;    and will be semi-random.
    BEQ :+                          ; if it is any value other than $4D, we can assume we just powered on...
      LDA #$4D                      ; ... so initilize it to $4D.  From this point forward, it will always be initlialized.
      STA startintrocheck           ; This is how the game makes the distinction between cold boot and warm reset
      FARCALL EnterIntroStory       ; And do the intro story!
    : 

    FARCALL EnterTitleScreen
    
    BCS @NewGame                    ; Do a new game, if the user selected the New Game option
    
    ; Otherwise, they selected "Continue"...
    BCS @NewGame                    ;  if it failed, do a new game
    
    ; Continue saved game
    LDX #$00
    : LDA   sram, X                 ; Copy all of SRAM to unsram
      STA unsram, X
      LDA   sram+$100, X
      STA unsram+$100, X
      LDA   sram+$200, X
      STA unsram+$200, X
      LDA   sram+$300, X
      STA unsram+$300, X
      INX
      BNE :-
    JUMP @Begin                      ; Then begin the game
    
    
  @NewGame:
    FARCALL NewGamePartyGeneration      ; create a new party
    CALL NewGame_LoadStartingStats   ;   and set their starting stats

    ; New Game and Continue meet here -- actually start up the game
  @Begin:
    FARCALL ClearZeroPage               ; clear Zero Page for good measure
    
    LDA unsram_ow_scroll_x          ; fetch OW scroll from unsram
    STA ow_scroll_x
    LDA unsram_ow_scroll_y
    STA ow_scroll_y
    
    LDA unsram_vehicle              ; fetch vehicle from unsram (wouldn't
    STA vehicle_next                ;   this always be 'on-foot'?)
    STA vehicle
    
    JUMP DoOverworld


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  NewGame_LoadStartingStats  [$C76D :: 0x3C77D]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

NewGame_LoadStartingStats:
    LDX #$00                ; load up the starting stats for each character
    CALL @LoadStats
    LDX #$40
    CALL @LoadStats
    LDX #$80
    CALL @LoadStats
    LDX #$C0
    NOJUMP @LoadStats
    

  @LoadStats:
    LDA ch_class, X         ; get the class
    ASL A                   ; $10 bytes of starting data for each class
    ASL A
    ASL A
    ASL A
    TAY                     ; source index in Y
    
    ;; LUT_ClassStartingStats table contains $B bytes of data, padded to $10
    ;;   byte 0 is a redundant and unused class ID byte.
    ;;   The rest is as outlined below
    
    LDA LUT_ClassStartingStats+1, Y ; starting HP
    STA ch_curhp, X
    STA ch_maxhp, X
    
    LDA LUT_ClassStartingStats+2, Y ; base stats
    STA ch_str, X
    LDA LUT_ClassStartingStats+3, Y
    STA ch_agil, X
    LDA LUT_ClassStartingStats+4, Y
    STA ch_int, X
    LDA LUT_ClassStartingStats+5, Y
    STA ch_vit, X
    LDA LUT_ClassStartingStats+6, Y
    STA ch_luck, X
    
    LDA LUT_ClassStartingStats+7, Y ; sub stats
    STA ch_dmg, X
    LDA LUT_ClassStartingStats+8, Y
    STA ch_hitrate, X
    LDA LUT_ClassStartingStats+9, Y
    STA ch_evade, X
    LDA LUT_ClassStartingStats+$A, Y
    STA ch_magdef, X
    
    ; Award starting MP if the class ID is >= RM, but < KN
    LDA ch_class, X
    CMP #CLS_RM
    BCC :+
      CMP #CLS_KN
      BCS :+
        LDA #$02                ; start with 2 MP
        STA ch0_curmp, X
        STA ch0_maxmp, X
    :
    RTS



LUT_InitGameFlags:
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $00, $00, $01, $01, $01, $01, $01, $00, $00, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00
    .byte $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

LUT_InitUnsramFirstPage:
    .byte $00, $d2, $99, $00, $00, $dd, $ed, $00, $00, $98, $98, $0e, $01, $66, $a4, $0e
    .byte $92, $9e, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $90, $01, $00, $00

LUT_ClassStartingStats:
    .byte $00, $23, $14, $05, $01, $0a, $05, $0a, $0a, $35, $0f, $00, $00, $00, $00, $00
    .byte $01, $1e, $05, $0a, $05, $05, $0f, $02, $05, $3a, $0f, $00, $00, $00, $00, $00
    .byte $02, $21, $05, $05, $05, $14, $05, $02, $05, $35, $0a, $00, $00, $00, $00, $00
    .byte $03, $1e, $0a, $0a, $0a, $05, $05, $05, $07, $3a, $14, $00, $00, $00, $00, $00
    .byte $04, $1c, $05, $05, $0f, $0a, $05, $02, $05, $35, $14, $00, $00, $00, $00, $00
    .byte $05, $19, $01, $0a, $14, $01, $0a, $01, $05, $3a, $14, $00, $00, $00, $00, $00
