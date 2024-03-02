.segment "PRG_023"

.include "src/global-import.inc"

.export ReadjustEquipStats, UnadjustEquipStats

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Unadjust Equipment stats  [$ED92 :: 0x3EDA2]
;;
;;    This is called when you enter the weapon or armor menu.  It edits all the characters
;;  stats to reflect what they would be if they removed all their equipment.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UnadjustEquipStats:
    ;LDA #BANK_EQUIPSTATS    ; Swap to bank containing equipment stats
    ;CALL SwapPRG

    LDA equipoffset         ; get the equipment offset (weapon or armor offset)
    STA equipmenu_tmp       ;  and back it up in equipmenu_tmp.  This is our editable source index

  @Loop:
    LDX equipmenu_tmp       ; get current source index in X  (it's also in A at this point)
    AND #$C0                ; mask to get the char index in A
    STA tmp+7               ; and put char index in tmp+7 for future use

    LDA ch_stats, X         ; get 1st piece of equipment
    BPL :+                  ; high bit set = equipped.  If equipped... 
      CALL @Adjust           ;   adjust stats for it

    :   
    LDA ch_stats+1, X       ; then do same for 2nd piece
    BPL :+
      CALL @Adjust

    :   
    LDA ch_stats+2, X       ; and 3rd
    BPL :+
      CALL @Adjust

    :   
    LDA ch_stats+3, X       ; and 4th
    BPL :+
      CALL @Adjust

    :   
    CALL UnadjustBBEquipStats  ; do a few adjustments for BB/MAs... or zero absorb

    LDA equipmenu_tmp         ; add $40 to the source index (look at next character)
    CLC
    ADC #$40
    STA equipmenu_tmp
    BCC @Loop                 ; keep looping until source index wraps (wraps after 4 characters)

    RTS

    ;LDA #BANK_MENUS           ; then restore the menu bank, and exit
    ;JUMP SwapPRG

  ;; local subroutine
  ;;   subtracts a weapon's hit and dmg bonus from the character's stats
  ;;   or removes an armor's evade penalty from the char's stats
  ;;   X remains unchanged by the routine (coming in and going out, X=equipmenu_tmp)

  @Adjust:
    SEC
    SBC #$01              ; subtract 1 from the equipment ID (they're 1-based, not 0-based... 0 is empty slot)

    ASL A
    ASL A                 ; then multiply by 4 (A = equip_id*4) -- high bit (equipped) is lost here, no need to mask it out

    LDY equipoffset              ; see if we're dealing with weapons or armor (use Y so not to disrupt A)
    CPY #ch_weapons - ch_stats
    BNE @AdjustArmor

    @AdjustWeapons:
      ASL A               ; multiply by another 2  (A= weapon_id*8) -- there are 8 bytes of stats per weapon
      STA tmp             ; this is the low byte of our source pointer
      LDA #0
      ADC #>LUT_WeaponData; include carry into high byte of source pointer
      STA tmp+1           ; (tmp) is now a pointer to stats for this weapon

      LDA tmp
      CLC
      ADC #<LUT_WeaponData
      STA tmp
  
      LDA tmp+1
      ADC #0
      STA tmp+1



      LDX tmp+7           ; load char index into X
      LDY #0              ; zero source index Y

      LDA ch_hitrate, X   ; get character's hit rate
      SEC
      SBC (tmp), Y        ; subtract the weapon's hit rate bonus
      STA ch_hitrate, X   ; and write back to character's hit rate
      INY                 ; inc source index

      LDA ch_dmg, X       ; get char's dmg
      SEC
      SBC (tmp), Y        ; subtract weapon's damage bonus
      STA ch_dmg, X       ; and write back

      LDX equipmenu_tmp   ; restore X to the equipment source index
      RTS                 ;  before returning

    @AdjustArmor:
      CLC                 ; (A= armor_id*8)
      ADC #<LUT_ArmorData     ; add A to desired pointer
      STA tmp             ;  and store pointer to (tmp)
      LDA #0
      ADC #>LUT_ArmorData
      STA tmp+1           ; (tmp) is now a pointer to stats for this armor

      LDX tmp+7           ; get char index in X
      LDY #0              ; zero our source index Y

      LDA ch_evade, X     ; get character's evade
      CLC
      ADC (tmp), Y        ; add the armor's evade penalty rate (removing the penalty)
      STA ch_evade, X     ; and write back

      LDX equipmenu_tmp   ; then restore X to equipment source index
      RTS                 ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Readjust Equipment stats  [$ED92 :: 0x3EDA2]
;;
;;    This is called when you EXIT the weapon or armor menu.  It edits all the characters
;;  stats to reflect the changes made by their equipment.
;;
;;    This is very similar in format to above UnadjustEquipmentStats routine
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReadjustEquipStats:
    ;LDA #BANK_EQUIPSTATS     ; swap to bank containing equipment stats
    ;CALL SwapPRG

    LDA equipoffset          ; get the equipment offset
    STA equipmenu_tmp        ; and put it in equipmenu_tmp -- this is our runtime source index

  @Loop:
    LDX equipmenu_tmp        ; get source index (source index also in A at this point)
    AND #$C0                 ; mask out high bits so A just contains char index
    STA tmp+7                ; store char index in tmp+7 for future use

    LDA ch_stats, X          ; get first piece of equipment
    BPL :+                   ; if equipped....
      CALL @Adjust            ;   adjust for its stats

    :   
    LDA ch_stats+1, X        ; do the same for all 4 pieces of equipment
    BPL :+
      CALL @Adjust

    :   
    LDA ch_stats+2, X
    BPL :+
      CALL @Adjust

    :   
    LDA ch_stats+3, X
    BPL :+
      CALL @Adjust

    :
       
    CALL ReadjustBBEquipStats ; adjust for special BB/MA properties

    LDA equipmenu_tmp        ; add $40 to our source index (move to next char)
    CLC
    ADC #$40
    STA equipmenu_tmp

    BCC @Loop                ; and keep looping until it wraps (4 iterations -- all 4 chars)

    RTS

    ;LDA #BANK_MENUS          ; then swap back to MENUS bank
    ;JUMP SwapPRG            ;   and exit

  ;; local subroutine
  ;;   adds a weapon's hit and dmg bonus to the character's stats
  ;;   or adds armor stats to char stats
  ;;   X remains unchanged by the routine (coming in and going out, X=equipmenu_tmp)

  @Adjust:
    SEC
    SBC #$01               ; subtract 1 from the equip ID (equipment is 1 based -- 0 is an empty slot)
    ASL A
    ASL A                  ; multiply by 4 (this drops the high bit -- no need to mask it out)

    LDY equipoffset             ; see if this is weapon or armor
    CPY #ch_weapons - ch_stats
    BNE @AdjustArmor

  @AdjustWeapon:
    ASL A                  ; multiply by another 2 (A now = weapon_id * 8)
    STA tmp                ; put in tmp as low byte of our pointer
    LDA #0
    ADC #>LUT_WeaponData   ; add high byte of our pointer (including any appropriate carry)
    STA tmp+1              ; fill tmp+1 to complete our pointer

    LDA tmp
    CLC
    ADC #<LUT_WeaponData
    STA tmp

    LDA tmp+1
    ADC #0
    STA tmp+1



    LDX tmp+7              ; get the character index
    LDY #0                 ; zero Y (our source index)

    LDA ch_hitrate, X      ; get char's hit rate
    CLC
    ADC (tmp), Y           ; add to it the weapon's hit bonus
    STA ch_hitrate, X      ; and write it back
    INY                    ;   inc source index

    LDA ch_dmg, X          ; get char's damage
    CLC
    ADC (tmp), Y           ; add weapon's damage bonus
    STA ch_dmg, X          ; and write back

    LDX equipmenu_tmp      ; restore X to its original state
    RTS

  @AdjustArmor:            ; A = armor_id * 4
    CLC
    ADC #<LUT_ArmorData        ; add low byte of pointer to our A
    STA tmp                ; and store it in tmp
    LDA #0
    ADC #>LUT_ArmorData        ; then get high byte of pointer (ADC to catch appropriate carry)
    STA tmp+1              ; (tmp) is now a pointer to this armor's stats

    LDX tmp+7              ; get char index
    LDY #0                 ; zero source pointer

    LDA ch_evade, X        ; get char's evade
    SEC
    SBC (tmp), Y           ; subtract armor evade penalty
    STA ch_evade, X        ; and write it back
    INY                    ; inc source index

    LDA ch_absorb, X       ; get absorb
    CLC
    ADC (tmp), Y           ; add absorb bonus
    STA ch_absorb, X       ; and write back

    LDA ch_resist, X       ; get elemental resistence
    INY                    ;   inc source index
    ORA (tmp), Y           ; combine this armor's elemental resistence
    STA ch_resist, X       ; and write back

    LDX equipmenu_tmp      ; restore X to original state
    RTS                    ; and exit

;;;;;;;;;;;;;;;;;;;
;;
;;  UnadjustBBEquipStats  [$EEB7 :: 0x3EEC7]
;;
;;    This is sort of a continuation of above 'UnadjustEquipStats' routine
;;
;;    Here, the dmg stat for BB/MAs is zerod.. or the absorb and elemental resistence
;;  for all classes is zerod.
;;
;;;;;;;;;;;;;;;;;;;

UnadjustBBEquipStats:
    LDA equipoffset             ; check to see if we're dealing with weapons or armor
    CMP #ch_weapons - ch_stats  ; if armor, jump ahead
    BNE @Armor

  @Weapons:             ; for weapons....
    LDX tmp+7           ; get char index into X
    LDA ch_class, X     ; get the char's class

    CMP #CLS_BB         ; check if he's a black belt or master
    BEQ @BlackBelt      ;  if he isn't, just exit
    CMP #CLS_MA         ; if he is...
    BNE @Exit

  @BlackBelt:
    LDA #0              ; zero his damage stat
    STA ch_dmg, X

  @Exit:
    RTS

  @Armor:               ; for armor...
    LDA #0
    LDX tmp+7           ; get char index
    STA ch_absorb, X    ; zero absorb
    STA ch_resist, X    ; and elemental resistence
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;
;;
;;  ReadjustBBEquipStats  [$EEDB :: 0x3EEEB]
;;
;;    This is sort of a continuation of above 'ReadjustEquipStats' routine
;;  This checks BlackBelts to see if they have equipment equipped, and adjusts their
;;  stats appropriately (since they have special bonuses for being unequipped).
;;
;;;;;;;;;;;;;;;;;;;

ReadjustBBEquipStats:
    LDX tmp+7          ; load up char index into X
    LDA ch_class, X    ; get this char's class

    CMP #CLS_BB        ; see if he's a black belt or master... if yes, jump ahead
    BEQ @BlackBelt     ; otherwise, exit
    CMP #CLS_MA
    BNE @Exit

  @BlackBelt:
    LDA equipoffset
    CMP #ch_weapons - ch_stats   ; see if we're dealing with weapons or armor
    BNE @Armor

  @Weapons:
    LDA ch_dmg, X             ; check this BB's damage stat
    BEQ @NoWeaponEquipped     ; if zero, we know this BB has no weapon equipped
                              ; we know this because UnadjustBBEquipStats zeros damage for blackbelts.
                              ; thus the only way it could be nonzero is if it had a weapon bonus added.

  @WeaponEquipped:
    LDA ch_str, X             ; if a weapon is equipped... get strength stat
    LSR A                     ;  /2
    ADC ch_dmg, X             ; and add to damage
    STA ch_dmg, X
    RTS                       ; equipped BB's dmg = (str/2 + weapon)

  @NoWeaponEquipped:
    LDA ch_level, X           ; if unequipped, get current experience level
    CLC
    ADC #$01                  ; add 1 (levels are stored 0 based in RAM -- ie '0' is really level 1)
    ASL A                     ; multiply by 2
    STA ch_dmg, X             ; and set dmg.  Unequipped BB's dmg = (level*2)
  @Exit:
    RTS

  @Armor:                     ; for armor....
    LDA ch_absorb, X          ; get absorb
    BNE @Exit                 ; if nonzero he has something equipped (absorb would be 0 otherwise), so just exit

    LDA ch_level, X           ; otherwise, get level + 1
    CLC
    ADC #$01
    STA ch_absorb, X          ; Unequipped BB's absorb=level
    RTS                       ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Weapon data!  [$8000 :: 0x30010]
;;
;;  8 bytes per weapon, 40 weapons ($140 bytes total)
;;
;;  byte 0:  Hit rate
;;  byte 1:  Damage
;;  byte 2:  Critial rate (BUGGED - not used .. see LoadOneCharacterIBStats for offending code)
;;  byte 3:  Spell cast
;;  byte 4:  Element
;;  byte 5:  Category effectiveness (Giant/Undead/etc)
;;  byte 6:  graphic
;;  byte 7:  palette

LUT_WeaponData:
    .incbin "bin/0C_8000_weapondata.bin"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Armor data!  [$8140 :: 0x30150]
;;
;;  4 bytes per weapon, 40 weapons ($A0 bytes total)
;;
;;  byte 0:  Evade penality
;;  byte 1:  Absorb boost
;;  byte 2:  Elemental defense
;;  byte 3:  Spell cast

LUT_ArmorData:
    .incbin "bin/0C_8140_armordata.bin"
