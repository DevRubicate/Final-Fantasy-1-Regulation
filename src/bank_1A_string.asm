.segment "BANK_1A"

.include "src/global-import.inc"

.import ReadFarByte, CoordToNTAddr, MenuCondStall, PrintGold, PrintCharStat, PrintPrice, PrintNumber_2Digit, DrawBox

.export DrawComplexString_New, DrawItemBox, SeekItemStringPtr, SeekItemStringPtrForEquip, DrawEquipMenuStrings


DrawComplexString_Exit:
    LDA #$00       ; reset scroll to 0
    STA PPUSCROLL
    STA PPUSCROLL
    RTS


DrawComplexString_New:
    CALL CoordToNTAddr

    @StallAndDraw:

    FARCALL MenuCondStall ;   this isn't really necessary, since MenuCondStall checks menustall already

    @Draw_NoStall:

    LDY #0            ; zero Y -- we don't want to use it as an index.  Rather, the pointer is updated
    CALL ReadFarByte
    BEQ DrawComplexString_Exit   ; if the character is 0  (null terminator), exit the routine

    INC Var0      ; otherwise, inc source pointer
    BNE :+
        INC Var1  ;   inc high byte if low byte wrapped
    :

    CMP #$1A          ; values below $1A are control codes.  See if this is a control code
    BCC @ControlCode  ;   if it is, jump ahead

    LDX PPUSTATUS         ; reset PPU toggle
    LDX ppu_dest+1    ;  load and set desired PPU address
    STX PPUADDR         ;  do this with X, as to not disturb A, which is still our character
    LDX ppu_dest
    STX PPUADDR

    CMP #$7A          ; see if this is a DTE character
    BCS @noDTE        ;  if < #$7A, it is DTE  (even though it probably should be #$6A)

    SEC             ;  characters 1A-69 are valid DTE characters.  6A-79 are treated as DTE, but will draw crap
    SBC #$1A        ; subtract #$1A to get a zero-based index
    TAX             ; put the index in X
    LDA lut_DTE1, X ;  load and draw the first character in DTE
    STA PPUDATA
    LDA lut_DTE2, X ;  load the second DTE character to be drawn in a bit
    INC ppu_dest    ;  increment the destination PPU address

    @noDTE:

    STA PPUDATA         ; draw the character as-is
    INC ppu_dest      ; increment dest PPU address
    JUMP @Draw_NoStall ; and repeat the process until terminated

   ; Jumps here for control codes.  Start comparing to see which control code this actually is
    @ControlCode:

    CMP #$01           ; is it $01?
    BNE @Code_02to19   ; if not, jump ahead

    ;;; Control code $01 -- double line break
    LDX #$40

    @LineBreak:      ; Line break -- X=40 for a double line break (control code $01),

    STX tmp        ;  X=20 for a single line break (control code $05)
    LDA ppu_dest   ; store X in tmp for future use.
    AND #$E0       ; Load dest PPU Addr, mask off the low bits (move to start of the row)
    ORA dest_x     ;  OR with the destination X coord (moving back to original start column)
    CLC
    ADC tmp        ; add the line break value (number of rows to inc by) to PPU Addr
    STA ppu_dest
    LDA ppu_dest+1
    ADC #0         ; catch any carry for the high byte
    STA ppu_dest+1
    JUMP @StallAndDraw   ; continue processing text

    @Code_02to19:

    CMP #$02        ; is control code $02?
    BNE :+
    JUMP @Code_02  ; if it is, jump to its handler
    :

    CMP #$03        ; otherwise... is it $03?
    BNE :+
    JUMP @Code_03  ; if it is, jump to 03's handler
    :

    CMP #$04        ; otherwise... 04?
    BNE @Code05to19

    ;;; Control code $04 -- draws current gold
    CALL @Save               ; this is a substring we'll need to draw, so save PrintGold to temp buffer
    FARCALL PrintGold
    CALL @StallAndDraw       ; Recursively call this routine to draw temp buffer
    JUMP @Restore            ; then restore original string state and continue

    @Code05to19:

    CMP #$14         ; is control code < $14?
    BCC @Code05to13
                     ; codes $14 and up default to single line break
    @SingleLineBreak:    ; reached by control codes $05-0F and $14-19
    
    LDX #$20         ; these control codes all just do a single line break
    JUMP @LineBreak   ;  afaik, $05 is the only single line break used by the game.. the other
                     ;  control codes are probably invalid and just line break by default
    @Code05to13:

    CMP #$10              ; is control code < $10?
    BCC @SingleLineBreak  ; if yes... line break

    ;;;; Control Codes $10-13
    ;;;;   These control codes indicate to draw a stat of a specific character
    ;;;;   ($10 is character 0, $11 is character 1, etc)
    ;;;; Which stat to draw is determined by the next byte in the string

    ROR A          ; rotate low to 2 bits to the high 2 bits and mask them out
    ROR A          ;  effectively giving you character * $40
    ROR A          ;  this will be used to index character stats
    AND #$C0
    STA char_index ; store index

    CALL ReadFarByte
    INC Var0        ; inc our string pointer
    BNE :+
        INC Var1    ; inc high byte if low byte wrapped
    :

    CMP #0
    BNE @StatCode_Over00

    ;; Stat Code $00 -- the character's name
    LDX char_index      ; load character index
    LDA ch_name, X      ; copy name to format buffer
    STA format_buf+3
    LDA ch_name+1, X
    STA format_buf+4
    LDA ch_name+2, X
    STA format_buf+5
    LDA ch_name+3, X
    STA format_buf+6

    CALL @Save              ; need to draw a substring, so save current string
    LDA #<(format_buf+3)   ; set string source pointer to temp buffer
    STA Var0
    LDA #>(format_buf+3)
    STA Var1
    CALL @Draw_NoStall      ; recursively draw it
    JUMP @Restore           ; then restore original string and continue

    @StatCode_Over00:

    CMP #$01
    BNE @StatCode_Over01

    ;; Stat Code $01 -- the character's class name
    LDX char_index   ; get character index
    LDA ch_class, X  ; get character's class
    CLC              ; add #$F0 (start of class names)
    ADC #$F0         ; draw it (yes I know, class names are not items, but they're stored with items)
    JUMP @DrawItem

    @StatCode_Over01:

    CMP #$02
    BNE @StatCode_Over02

    ;; Stat Code $02 -- draw ailment blurb ("HP" if character is fine, nothing if dead, "ST" if stone, or "PO" if poisoned)
    LDX char_index        ; character index
    LDA ch_ailments, X    ; out-of-battle ailment ID
    CLC                   ; add #$FC (start of ailment names)
    ADC #$FC              ; draw it (not an item, but with item names)
    JUMP @DrawItem

    @StatCode_Over02:

    CMP #$0C
    BCC @DrawCharStat      ; if stat code is between $02-0B, relay this stat code to PrintCharStat

    CMP #$2C
    BCC @StatCode_0Cto2B   ; see if stat code is below #$2C.  If it isn't, we relay to PrintCharStat

    @DrawCharStat:           ; this paticular stat code is going to be handled in a routine in another bank

    TAX                    ;  temporarily put the code in X
    CALL @Save              ;  save string data (we'll be drawing a substring)
    TXA                    ;  put the stat code back in A
    FARCALL PrintCharStat      ;  print it to temp string buffer
    CALL @StallAndDraw      ; draw it to the screen
    JUMP @Restore           ; restore original string data and continue

    @StatCode_0Cto2B:

    CMP #$14
    BCS @StatCode_14to2B   ; see if code >= #$14

    CMP #$10
    BCS @StatCode_10to13   ; see if >= #$10

    ;;; Stat Codes $0C-0F -- weapons (BUGGED)
    AND #$03        ; isolate the weapons slot (each character has 4 weapons)
    CLC
    ADC char_index  ; add character index
    TAX
    LDA ch_weapons, X  ; get the weapon ID
    STA tmp            ; put unedited weapon ID in $10 (temporary)
    AND #$7F           ; mask out high bit (high bit indicates whether or not weapon is equipped)
    BEQ @WeaponArmor   ; if weapon ID == 0 (slot is empty), skip ahead and draw string 0 (blank string)

    CLC           ; if weapon ID is nonzero (slot has an actual weapon), add #$1B to ID
    ADC #$1B      ; $1C is the start of the weapon names in the item list (-1 because 0 is nothing)
    BNE @WeaponArmor ; jump ahead to draw it (always branches)

    @StatCode_10to13:   ;; Stat Codes $10-13 -- armor (BUGGED)

    AND #$03          ; isolate the armor slot (each character has 4 armor)
    CLC
    ADC char_index    ; add character index
    TAX
    LDA ch_armor, X   ; get armor ID
    STA tmp           ; store as-is in $10 (temp)
    AND #$7F          ; mask off the equip bit
    BEQ @WeaponArmor      ; if zero (empty slot), skip ahead and draw string 0 (blank string)

    CLC           ; if nonzero, add #$43 to armor ID
    ADC #$43      ; $44 is the start of armor names in the item list (-1 because 0 is nothing)

    @WeaponArmor:          ; above weapon and armor codes reach here with A containing

    STA tmp+1          ;  the string index to draw.  Write that index to tmp+1
    JUMP @DrawEquipment_BUGGED ;  and jump to equipment drawing (BUGGED)

    @StatCode_14to2B:     ;; Stat Codes $14-2B -- magic

    SEC
    SBC #$14          ; subtract #$14 to get it zero based
    TAX               ; use that as an index
    LDA @lutMagic, X  ;  in the magic conversion LUT.  This gets the index to the spell in RAM
    CLC
    ADC char_index    ; add character index
    TAX               ; and put it in X for indexing

    ASL A             ; then double A
    AND #$38          ;  and mask out bits 4-6.  This gives us the spell level * 8

    CLC               ; Add #$AF to the spell level*8 ($B0 is the start of the magic item text.  -1 because 0 is nothing)
    ADC #$AF          ;  we add the spell level here because spells are only 01-08 in RAM.  IE:  CURE and LAMP are both stored
                      ;  as $01 in the character's spell list.  The game tells them apart because LAMP is stored in the level 2 section
                      ;  and CURE is stored in the level 1 section.
    STA tmp           ; store this calculated index in tmp ram

    LDA ch0_spells, X  ; use X as index to get the spell
    BEQ :+            ; if 0, skip ahead and draw nothing (no spell)
        CLC             ; add our level+text index to the current spell
        ADC tmp         ;  previously stored in tmp
        JUMP @DrawItem   ; and jump to @DrawItem
    :

    JUMP @StallAndDraw ; jumps here when spell=0.  Simply do nothing and continue with string processing

    ;; Magic conversion LUT [$DF90 :: 0x3DFA0]
    ;;  each character has 24 spells (8 levels * 3 spells per level).  However these 24 spells
    ;;  span a 32 byte range in RAM because each level starts on its own 4-byte boundary
    ;; therefore the 3rd byte in every set of 4 goes unused (padding).  This table converts
    ;; a 24-index to the desired 32-index by simply skipping the 3rd byte in every set of 4

    @lutMagic:

    .byte $00,$01,$02,    $04,$05,$06,    $08,$09,$0A,    $0C,$0D,$0E
    .byte $10,$11,$12,    $14,$15,$16,    $18,$19,$1A,    $1C,$1D,$1E


    ; This is called to draw weapon/armor, along with the "E-" before it if the item is equipped
    ;  supposedly, anyway.  This routine is totally bugged.  Extra spaces are drawn where they shouldn't be
    ;  which would result in screwed up output.  Plus it draws the wrong item string!
    ;
    ;  Due to the bugs, I don't believe this routine is ever used.  Weapon/Armor subscreens and shops don't appear to use
    ;  these control codes -- and I don't think in-battle ever even calls DrawComplexString
    ;
    ;   tmp   = raw weap/armor ID.  High bit set if piece is equipped (draw the "E-") or clear if unequipped (draw spaces instead)
    ;   tmp+1 = ID of item text string to draw (name of weapon/armor) -- supposedly... but it isn't used!

    @DrawEquipment_BUGGED:

    LDA tmp              ; get weapon/armor ID
    BNE :+               ; if it's zero...
    JUMP @Draw_NoStall  ; draw nothing -- continue with normal text processing
    :

    BMI @isEquipped    ; if high bit set, we need to draw the "E-"
    LDX #$FF         ; otherwise... (not equipped), just draw spaces
    LDY #$FF         ;  set X and Y to $FF (blank space tile)
    BNE :+           ;  and jump ahead (always branches)

    @isEquipped:       ; code jumps here if item is equipped
    LDX #$C7         ; set X to the "E" tile
    LDY #$C2         ; and Y to the "-" tile
    :

    LDA PPUSTATUS       ; both equipped and nonequipped code meet up here
    LDA ppu_dest+1  ; reset PPU toggle
    STA PPUADDR       ; and set desired PPU address
    LDA ppu_dest
    STA PPUADDR

    LDA #$FF
    STA PPUDATA       ; draw a space (why??? -- screws up result!)
    STX PPUDATA       ; then the "E" (if equipped) or another space (if not)

    INC ppu_dest    ; inc dest address

    LDA PPUSTATUS       ; reset toggle again
    LDA ppu_dest+1  ; and set desired PPU address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDA #$FF        ; draw a space.  Again.. why?  This only makes sense if you're in inc-by-32 mode
    STA PPUDATA       ;  otherwise this space will overwrite the "E" we just drew.  But if you're in inc-by-32 mode...
    STY PPUDATA       ;  the "E-" will draw 1 line below the item name (makes no sense).
                    ; but anyway yeah.. after that space, draw the "-" or another space

    INC ppu_dest    ; inc dest PPU address
    LDA tmp         ;  get weapon/armor ID   (but this is wrong -- should be tmp+1)
    AND #$7F        ;  mask off the equip bit  (but this is wrong)
    JUMP @DrawItem   ;  and draw the string.  But that's wrong!  It probably meant to draw tmp+1 (the item string index)

    ;;; Control Code $02 -- draws an item name
    @Code_02:
    CALL ReadFarByte
    INC Var0          ; inc source pointer
    BNE @DrawItem
        INC Var1      ;   and inc high byte if low byte wrapped
    @DrawItem:
    CALL @Save             ; drawing an item requires a substring.  Save current string
    ASL A                 ; double it (for pointer table lookup)
    TAX                   ; put low byte in X for indexing

    BCS @itemHigh                 ; if doubling A caused a carry (item ID >= $80)... jump ahead
    LDA LUT_ItemNamePtrTbl, X   ;  if item ID was < $80... read pointer from first half of pointer table
    STA Var0                ;  low byte of pointer
    LDA LUT_ItemNamePtrTbl+1, X ;  high byte of pointer (will be written after jump)
    JUMP @itemGo
    @itemHigh:                         ; item high -- if item ID was >= $80
    LDA LUT_ItemNamePtrTbl+$100, X ;  load pointer from second half of pointer table
    STA Var0                   ;  write low byte of pointer
    LDA LUT_ItemNamePtrTbl+$101, X ;  high byte (written next inst)
    @itemGo:
    STA Var1        ; finally write high byte of pointer
    LDA #(BANK_ITEMS * 2) | %10000000
    STA Var2
    CALL @Draw_NoStall     ; recursively draw the substring
    JUMP @Restore          ; then restore original string and continue

    ;;;; Control Code $03 -- prints an item price
  @Code_03:
    CALL ReadFarByte
    INC Var0         ; inc string pointer
    BNE :+
        INC Var1     ; inc high byte if low byte wrapped
    :
    CALL @Save            ; Save string info (item price is a substring)
    FARCALL PrintPrice       ; print the price to temp string buffer
    CALL @StallAndDraw    ; recursivly draw it
    JUMP @Restore         ; then restore original string state and continue

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;
    ;;  Complex String save/restore [$E03E :: 0x3E04E]
    ;;
    ;;    Some format characters require a complex string to swap banks
    ;;  and start drawing a seperate string mid-job.  It calls this 'Save' routine
    ;;  before doing that, and then calls the 'restore' routine after it's done
    ;;
    ;;    Note that Restore does not RTS, but rather JMPs back to the text
    ;;  loop explicitly -- therefore you should JUMP to it.. not CALL to it.
    ;;
    ;;    Note I'm still using local labels here ... this is still part of DrawComplexString  x_x
    ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    @Save:

    LDY Var0    ; back up the text pointer
    STY tmp_hi      ;  and the data bank
    LDY Var1  ;  to temporary RAM space
    STY tmp_hi+1
    LDY Var2    ; use Y, so as not to dirty A
    STY tmp_hi+2
    RTS

    @Restore:

    LDA tmp_hi     ; restore text pointer and data bank
    STA Var0
    LDA tmp_hi+1
    STA Var1
    LDA tmp_hi+2
    STA Var2
    JUMP @Draw_NoStall  ;  and continue with text processing


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawItemBox  [$EF18 :: 0x3EF28]
;;
;;    Fills the item box buffer in RAM with items that the player currently
;;  has in their possesion.
;;
;;    Also draws the item box (and its contents) to the screen
;;
;;  OUT:  C is cleared if the player has at least 1 item, and is set if the player
;;         has no items.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawItemBox:
    LDA #$01         ; draw the box at coords $01,$03
    STA box_x        ; and with dims  $1E,$13
    LDA #$03
    STA box_y        ;  seems odd that the box is hardcoded here,
    LDA #$1E         ;  when these exact same positions/dims could be drawn
    STA box_wd       ;  with DrawMainItemBox
    LDA #$13
    STA box_ht
    FARCALL DrawBox

    INC dest_y       ; inc the dest row by 1 and the dest col by 2
    INC dest_x       ;  but this is utterly pointless because dest_x and dest_y
    INC dest_x       ;  are overwritten below

    LDX #0           ; X is our dest index -- start it at zero
    LDY #1           ; Y is our source index -- start it at 1 (first byte in the 'items' buffer is unused)

  @ItemFillLoop:
      LDA items, Y       ; check our item qty
      BEQ @IncSrc        ; if it's nonzero...
        TYA              ;  put this item ID in A
        STA item_box, X  ;  and write it to the item box buffer
        INX              ;  inc our dest index

    @IncSrc:
      INY                         ; inc our source index

      CPY #item_orb_start - items ; since orb names aren't included in the item box...
      BCC @ItemFillLoop           ;   this checks to see if the source index is currently on an orb name
      CPY #item_qty_start - items ;   if it is, it jumps back to @IncSrc.  If it isn't, it jumps back
      BCC @IncSrc                 ;   to @ItemFillLoop
                                  ; this effectively skips over the orbs

      CPY #item_stop-items        ; keep looping until we go through the entire item list
      BCC @ItemFillLoop

    CPX #0                 ; if the dest index is still zero, the player has no items
    BNE @StartDrawingItems ;   otherwise (nonzero), start drawing the items they have

    ; no items, so no further work to be done... just exit with C set
      SEC
      RTS


  @Exit:
    CLC    ; C clear on exit indicates there was at least 1 item in inventory
    RTS


  @StartDrawingItems:
    STX cursor_max     ; the number of items they have becomes the cursor maximum
    LDA #0
    STA item_box, X    ; put a null terminator at the end of the item box (needed for following loop)
    LDA #0
    STA cursor         ; also reset the cursor to 0 (which will be used as a loop counter below)

  @DrawItemLoop:
    LDX cursor         ; get current loop counter and put it in X
    LDA item_box, X    ; index the item box to see what item name we're to draw
    BEQ @Exit          ; if the item ID is zero, it's a null terminator, which means we're done

    ASL A              ; otherwise double the item ID
    TAX                ;  and put it in X to index (will be used to index the string pointer table)

    LDA LUT_ItemNamePtrTbl, X   ; get the pointer to this item name
    STA tmp                     ;  and put it in (tmp)
    LDA LUT_ItemNamePtrTbl+1, X
    STA tmp+1


    LDA tmp
    STA Var0
    LDA tmp+1
    STA Var1
    LDA #(BANK_ITEMS * 2) | %10000000
    STA Var2

                       ; copy 7 characters verbatim (do not look for null terminators!)
    LDY #$06           ;   this means that shorter item names must be padded with spaces to 7 characters.  DUMB
    @CopyLoop:
    CALL ReadFarByte
    STA str_buf+$20, Y   ; and put in str_buf+$20.  Cannot use str_buf as it is,
    DEY                  ;   because it shares RAM with item_box, which we can't overwrite
    BPL @CopyLoop        ; loop until Y wraps (copies 7 characters)

    LDA #0
    STA str_buf+$27    ; end the string buffer with a null terminator

    TXA                ; put X back in A and right-shift it
    LSR A              ;  this restores the unedited item ID number

    CMP #item_qty_start-items   ; see if this item ID falls within the range of IDs that you can have
    BCC @SkipQty                ;  multiple of (qty number needs to be drawn).  If not, Skip ahead

       TAX                     ; put item ID in X
       LDA items, X            ; use it to index inventory to see how many of this item we have
       STA tmp                 ;  put the qty in tmp
       FARCALL PrintNumber_2Digit  ; print the 2 digit number
       LDA format_buf+5        ; copy the printed 2 digit number from the format buffer
       STA str_buf+$25         ;  to the end of our string buffer (just before the null terminator)
       LDA format_buf+6
       STA str_buf+$26


  @SkipQty:
    LDA #<(str_buf+$20)    ; fill Var0 with the pointer to our item name in the string buffer
    STA Var0
    LDA #>(str_buf+$20)
    STA Var1
    LDA #(BANK_ITEMS * 2) | %10000000
    STA Var2

    LDA cursor             ; get current loop counter again
    ASL A                  ; double it, and stuff it in X
    TAX

    LDA lutItemBoxStrPos, X     ; load up the dest X,Y coords
    STA dest_x                  ;  and record them
    LDA lutItemBoxStrPos+1, X   ; these are the coords at which to draw this item name
    STA dest_y

    CALL DrawComplexString_New  ; finally actually call DrawComplexString to draw the item name
    INC cursor             ; increment our loop counter to draw the next item
    JUMP @DrawItemLoop      ; and continue looping

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Item Box String Positions [$EFCC :: 0x3EFDC]
;;
;;   LUT containing X,Y coords of where to draw the strings inside of
;;  the item box.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lutItemBoxStrPos:
  .byte $04,$06,   $0D,$06,   $16,$06
  .byte $04,$08,   $0D,$08,   $16,$08
  .byte $04,$0A,   $0D,$0A,   $16,$0A
  .byte $04,$0C,   $0D,$0C,   $16,$0C
  .byte $04,$0E,   $0D,$0E,   $16,$0E
  .byte $04,$10,   $0D,$10,   $16,$10
  .byte $04,$12,   $0D,$12,   $16,$12
  .byte $04,$14,   $0D,$14,   $16,$14

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DTE table   [$F050 :: 0x3F060]
;;
;;  first table is the 2nd character in a DTE pair
;;  second table is the 1st character in a DTE pair
;;
;;  don't ask me why it's reversed
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lut_DTE2:
    .byte $FF,$B7,$AB,$A8,  $FF,$B1,$A4,$FF,  $B1,$A8,$B6,$B5,  $B8,$FF,$B2,$FF
    .byte $AA,$A4,$B6,$AC,  $FF,$B5,$B6,$A5,  $A8,$BA,$A8,$B5,  $B2,$B7,$A6,$B7
    .byte $B1,$A7,$B1,$AC,  $A8,$B6,$A7,$A4,  $B0,$A9,$FF,$A8,  $BA,$FF,$A8,$B0
    .byte $92,$FF,$A9,$B2,  $AF,$B3,$BC,$A4,  $8A,$A8,$FF,$B5,  $B2,$AC,$FF,$AB
    .byte $A8,$B7,$AC,$A4,  $A6,$AF,$A8,$AF,  $A8,$B6,$FF,$AF,  $A8,$A7,$AC,$C3

lut_DTE1:
    .byte $A8,$FF,$B7,$AB,  $B6,$AC,$FF,$B7,  $A4,$B5,$FF,$A8,  $B2,$A7,$B7,$B1
    .byte $B1,$A8,$A8,$FF,  $B2,$A4,$AC,$FF,  $B9,$FF,$B0,$B2,  $FF,$B6,$FF,$A4
    .byte $A8,$B1,$B2,$AB,  $B6,$A4,$A8,$AB,  $FF,$FF,$B5,$AF,  $B2,$AA,$A6,$B2
    .byte $90,$BC,$B2,$B5,  $AF,$FF,$FF,$A6,  $96,$B7,$A9,$B8,  $BC,$B7,$AF,$FF
    .byte $B1,$AC,$B5,$BA,  $A4,$A4,$BA,$AC,  $A5,$B5,$B8,$FF,  $AA,$FF,$AF,$C3

LUT_ItemNamePtrTbl:
    .word $b900
    .word $b901
    .word $b909
    .word $b911
    .word $b919
    .word $b921
    .word $b929
    .word $b931
    .word $b939
    .word $b941
    .word $b949
    .word $b951
    .word $b959
    .word $b961
    .word $b969
    .word $b971
    .word $b979
    .word $b981
    .word $b989
    .word $b98b
    .word $b98d
    .word $b98f
    .word $b991
    .word $b999
    .word $b9a1
    .word $b9a9
    .word $b9af
    .word $b9b5
    .word $b9bd
    .word $b9c5
    .word $b9cd
    .word $b9d5
    .word $b9dd
    .word $b9e5
    .word $b9ed
    .word $b9f5
    .word $b9fd
    .word $ba05
    .word $ba0d
    .word $ba15
    .word $ba1d
    .word $ba25
    .word $ba2d
    .word $ba35
    .word $ba3d
    .word $ba45
    .word $ba4d
    .word $ba55
    .word $ba5d
    .word $ba65
    .word $ba6d
    .word $ba75
    .word $ba7d
    .word $ba85
    .word $ba8d
    .word $ba95
    .word $ba9d
    .word $baa5
    .word $baad
    .word $bab5
    .word $babd
    .word $bac5
    .word $bacd
    .word $bad5
    .word $badd
    .word $bae5
    .word $baed
    .word $baf5
    .word $bafd
    .word $bb05
    .word $bb0d
    .word $bb15
    .word $bb1d
    .word $bb25
    .word $bb2d
    .word $bb35
    .word $bb3d
    .word $bb45
    .word $bb4d
    .word $bb55
    .word $bb5d
    .word $bb65
    .word $bb6d
    .word $bb75
    .word $bb7d
    .word $bb85
    .word $bb8d
    .word $bb95
    .word $bb9d
    .word $bba5
    .word $bbad
    .word $bbb5
    .word $bbbd
    .word $bbc5
    .word $bbcd
    .word $bbd5
    .word $bbdd
    .word $bbe5
    .word $bbed
    .word $bbf5
    .word $bbfe
    .word $bc06
    .word $bc0e
    .word $bc16
    .word $bc1e
    .word $bc26
    .word $bc2e
    .word $bc36
    .word $bc3e
    .word $bc43
    .word $bc48
    .word $bc4d
    .word $bc52
    .word $bc57
    .word $bc5c
    .word $bc61
    .word $bc67
    .word $bc6d
    .word $bc73
    .word $bc79
    .word $bc7f
    .word $bc85
    .word $bc8b
    .word $bc91
    .word $bc97
    .word $bc9d
    .word $bca3
    .word $bca9
    .word $bcaf
    .word $bcb5
    .word $bcbb
    .word $bcc1
    .word $bcc7
    .word $bccd
    .word $bcd3
    .word $bcd9
    .word $bcdf
    .word $bce5
    .word $bceb
    .word $bcf1
    .word $bcf8
    .word $bcff
    .word $bd06
    .word $bd0d
    .word $bd14
    .word $bd1b
    .word $bd22
    .word $bd29
    .word $bd30
    .word $bd37
    .word $bd3e
    .word $bd45
    .word $bd4c
    .word $bd53
    .word $bd5a
    .word $bd61
    .word $bd68
    .word $bd6f
    .word $bd76
    .word $bd7d
    .word $bd84
    .word $bd8b
    .word $bd93
    .word $bd9b
    .word $bda3
    .word $bdab
    .word $bdb3
    .word $bdbb
    .word $bdc3
    .word $bdcb
    .word $bdd3
    .word $bddb
    .word $bde3
    .word $bdeb
    .word $bdf3
    .word $bdfb
    .word $be03
    .word $be08
    .word $be0d
    .word $be12
    .word $be17
    .word $be1c
    .word $be21
    .word $be26
    .word $be2b
    .word $be30
    .word $be35
    .word $be3a
    .word $be3f
    .word $be44
    .word $be49
    .word $be4e
    .word $be53
    .word $be58
    .word $be5d
    .word $be62
    .word $be67
    .word $be6c
    .word $be71
    .word $be76
    .word $be7b
    .word $be80
    .word $be85
    .word $be8a
    .word $be8f
    .word $be94
    .word $be99
    .word $be9e
    .word $bea3
    .word $bea8
    .word $bead
    .word $beb2
    .word $beb7
    .word $bebc
    .word $bec1
    .word $bec6
    .word $becb
    .word $bed0
    .word $bed5
    .word $beda
    .word $bedf
    .word $bee4
    .word $bee9
    .word $beee
    .word $bef3
    .word $bef8
    .word $befd
    .word $bf02
    .word $bf07
    .word $bf0c
    .word $bf11
    .word $bf16
    .word $bf1b
    .word $bf20
    .word $bf25
    .word $bf2a
    .word $bf2f
    .word $bf34
    .word $bf39
    .word $bf3e
    .word $bf43
    .word $bf4b
    .word $bf53
    .word $bf5b
    .word $bf63
    .word $bf6b
    .word $bf73
    .word $bf7b
    .word $bf83
    .word $bf8b
    .word $bf93
    .word $bf9b
    .word $bfa3
    .word $bfa7
    .word $bfab
    .word $bfaf
    .word $9500
    .word $9d9e
    .word $ff8e
    .word $ffff
    .word $8c00
    .word $989b
    .word $97a0
    .word $ffff
    .word $8c00
    .word $a29b
    .word $9d9c
    .word $958a
    .word $9100
    .word $9b8e
    .word $ff8b
    .word $ffff
    .word $9400
    .word $a28e
    .word $ffff
    .word $ffff
    .word $9d00
    .word $9d97
    .word $ffff
    .word $ffff
    .word $8a00
    .word $8a8d
    .word $8a96
    .word $9d97
    .word $9c00
    .word $8a95
    .word $ff8b
    .word $ffff
    .word $9b00
    .word $8b9e
    .word $ffa2
    .word $ffff
    .word $9b00
    .word $8d98
    .word $ffff
    .word $ffff
    .word $8f00
    .word $9895
    .word $9d8a
    .word $9b8e
    .word $8c00
    .word $9291
    .word $8e96
    .word $ffff
    .word $9d00
    .word $928a
    .word $ff95
    .word $ffff
    .word $8c00
    .word $8b9e
    .word $ff8e
    .word $ffff
    .word $8b00
    .word $9d98
    .word $959d
    .word $ff8e
    .word $9800
    .word $a2a1
    .word $958a
    .word $ff8e
    .word $8c00
    .word $978a
    .word $8e98
    .word $ffff
    .word $ff00
    .word $ff00
    .word $ff00
    .word $ff00
    .word $9d00
    .word $978e
    .word $ff9d
    .word $ffff
    .word $8c00
    .word $8b8a
    .word $9792
    .word $ffff
    .word $9100
    .word $9e98
    .word $8e9c
    .word $ffff
    .word $9100
    .word $8a8e
    .word $e195
    .word $9900
    .word $9b9e
    .word $e18e
    .word $9c00
    .word $8f98
    .word $e19d
    .word $ffff
    .word $a000
    .word $b2b2
    .word $a8a7
    .word $d9b1
    .word $9c00
    .word $a4b0
    .word $afaf
    .word $d6ff
    .word $a000
    .word $b2b2
    .word $a8a7
    .word $d8b1
    .word $9b00
    .word $b3a4
    .word $a8ac
    .word $ffb5
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $d5ff
    .word $9c00
    .word $b2ab
    .word $b7b5
    .word $d4ff
    .word $9100
    .word $b1a4
    .word $ffa7
    .word $d7ff
    .word $9c00
    .word $aca6
    .word $b7b0
    .word $b5a4
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $d9ff
    .word $9500
    .word $b5a4
    .word $a8aa
    .word $d6ff
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $d8ff
    .word $9c00
    .word $a5a4
    .word $a8b5
    .word $ffff
    .word $9500
    .word $b1b2
    .word $ffaa
    .word $d4ff
    .word $9000
    .word $a8b5
    .word $b7a4
    .word $d7ff
    .word $8f00
    .word $afa4
    .word $aba6
    .word $b1b2
    .word $9c00
    .word $afac
    .word $a8b9
    .word $d6b5
    .word $9c00
    .word $afac
    .word $a8b9
    .word $d4b5
    .word $9c00
    .word $afac
    .word $a8b9
    .word $d5b5
    .word $9c00
    .word $afac
    .word $a8b9
    .word $d7b5
    .word $8f00
    .word $a4af
    .word $a8b0
    .word $d4ff
    .word $9200
    .word $a8a6
    .word $ffff
    .word $d4ff
    .word $8d00
    .word $a4b5
    .word $b2aa
    .word $d4b1
    .word $9000
    .word $a4ac
    .word $b7b1
    .word $d4ff
    .word $9c00
    .word $b1b8
    .word $ffff
    .word $d4ff
    .word $8c00
    .word $b5b2
    .word $afa4
    .word $d4ff
    .word $a000
    .word $b5a8
    .word $ffa8
    .word $d4ff
    .word $9b00
    .word $b1b8
    .word $ffa8
    .word $d4ff
    .word $9900
    .word $bab2
    .word $b5a8
    .word $d8ff
    .word $9500
    .word $aaac
    .word $b7ab
    .word $d7ff
    .word $9100
    .word $a4a8
    .word $ffaf
    .word $d8ff
    .word $9600
    .word $aaa4
    .word $ffa8
    .word $d8ff
    .word $8d00
    .word $a9a8
    .word $b1a8
    .word $a8b6
    .word $a000
    .word $bdac
    .word $b5a4
    .word $d8a7
    .word $9f00
    .word $b5b2
    .word $a4b3
    .word $ffaf
    .word $8c00
    .word $b7a4
    .word $af8c
    .word $baa4
    .word $9d00
    .word $b2ab
    .word $ffb5
    .word $d5ff
    .word $8b00
    .word $b1a4
    .word $ffa8
    .word $d4ff
    .word $9400
    .word $b7a4
    .word $b1a4
    .word $ffa4
    .word $a100
    .word $a4a6
    .word $a5af
    .word $b5a8
    .word $9600
    .word $b6a4
    .word $b8b0
    .word $a8b1
    .word $8c00
    .word $b2af
    .word $abb7
    .word $ffff
    .word $a000
    .word $b2b2
    .word $a8a7
    .word $dab1
    .word $8c00
    .word $a4ab
    .word $b1ac
    .word $daff
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $daff
    .word $9c00
    .word $a8b7
    .word $afa8
    .word $daff
    .word $9c00
    .word $afac
    .word $a8b9
    .word $dab5
    .word $8f00
    .word $a4af
    .word $a8b0
    .word $daff
    .word $9200
    .word $a8a6
    .word $ffff
    .word $daff
    .word $9800
    .word $a4b3
    .word $ffaf
    .word $daff
    .word $8d00
    .word $a4b5
    .word $b2aa
    .word $dab1
    .word $8c00
    .word $b3b2
    .word $a8b3
    .word $deb5
    .word $9c00
    .word $afac
    .word $a8b9
    .word $deb5
    .word $9000
    .word $afb2
    .word $ffa7
    .word $deff
    .word $9800
    .word $a4b3
    .word $ffaf
    .word $deff
    .word $a000
    .word $acab
    .word $a8b7
    .word $dfff
    .word $8b00
    .word $a4af
    .word $aea6
    .word $dfff
    .word $a000
    .word $b2b2
    .word $a8a7
    .word $dbb1
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $dbff
    .word $9c00
    .word $afac
    .word $a8b9
    .word $dbb5
    .word $8f00
    .word $a4af
    .word $a8b0
    .word $dbff
    .word $9200
    .word $a8a6
    .word $ffff
    .word $dbff
    .word $9800
    .word $a4b3
    .word $ffaf
    .word $dbff
    .word $8a00
    .word $aaa8
    .word $b6ac
    .word $dbff
    .word $8b00
    .word $a6b8
    .word $afae
    .word $b5a8
    .word $9900
    .word $b2b5
    .word $a48c
    .word $a8b3
    .word $8c00
    .word $b3a4
    .word $ffff
    .word $ffff
    .word $a000
    .word $b2b2
    .word $a8a7
    .word $dcb1
    .word $9200
    .word $b2b5
    .word $ffb1
    .word $dcff
    .word $9c00
    .word $afac
    .word $a8b9
    .word $dcb5
    .word $9800
    .word $a4b3
    .word $ffaf
    .word $dcff
    .word $9100
    .word $a4a8
    .word $ffaf
    .word $dcff
    .word $9b00
    .word $a5ac
    .word $b2a5
    .word $ffb1
    .word $00ff
    .word $af90
    .word $b9b2
    .word $b6a8
    .word $00ff
    .word $b28c
    .word $b3b3
    .word $b5a8
    .word $00dd
    .word $b592
    .word $b1b2
    .word $ffff
    .word $00dd
    .word $ac9c
    .word $b9af
    .word $b5a8
    .word $00dd
    .word $a8a3
    .word $b6b8
    .word $ffff
    .word $00dd
    .word $b299
    .word $a8ba
    .word $ffb5
    .word $00dd
    .word $b398
    .word $afa4
    .word $ffff
    .word $00dd
    .word $b599
    .word $9bb2
    .word $b1ac
    .word $00aa
    .word $8081
    .word $90ff
    .word $8200
    .word $ff80
    .word $0090
    .word $8582
    .word $90ff
    .word $8300
    .word $ff80
    .word $0090
    .word $8585
    .word $90ff
    .word $8700
    .word $ff80
    .word $0090
    .word $8588
    .word $90ff
    .word $8100
    .word $8081
    .word $90ff
    .word $8100
    .word $8583
    .word $90ff
    .word $8100
    .word $8585
    .word $90ff
    .word $8100
    .word $8086
    .word $90ff
    .word $8100
    .word $8088
    .word $90ff
    .word $8200
    .word $8084
    .word $90ff
    .word $8200
    .word $8585
    .word $90ff
    .word $8200
    .word $8086
    .word $90ff
    .word $8200
    .word $8589
    .word $90ff
    .word $8300
    .word $8080
    .word $90ff
    .word $8300
    .word $8581
    .word $90ff
    .word $8300
    .word $8083
    .word $90ff
    .word $8300
    .word $8085
    .word $90ff
    .word $8300
    .word $8588
    .word $90ff
    .word $8400
    .word $8080
    .word $90ff
    .word $8400
    .word $8085
    .word $90ff
    .word $8500
    .word $8080
    .word $90ff
    .word $8500
    .word $8083
    .word $90ff
    .word $8500
    .word $8587
    .word $90ff
    .word $8600
    .word $8082
    .word $90ff
    .word $8600
    .word $8088
    .word $90ff
    .word $8700
    .word $8085
    .word $90ff
    .word $8700
    .word $8589
    .word $90ff
    .word $8800
    .word $8088
    .word $90ff
    .word $8100
    .word $8280
    .word $ff80
    .word $0090
    .word $8281
    .word $8085
    .word $90ff
    .word $8100
    .word $8584
    .word $ff85
    .word $0090
    .word $8581
    .word $8082
    .word $90ff
    .word $8100
    .word $8687
    .word $ff80
    .word $0090
    .word $8981
    .word $8587
    .word $90ff
    .word $8200
    .word $8080
    .word $ff80
    .word $0090
    .word $8782
    .word $8085
    .word $90ff
    .word $8300
    .word $8084
    .word $ff80
    .word $0090
    .word $8184
    .word $8085
    .word $90ff
    .word $8500
    .word $8080
    .word $ff80
    .word $0090
    .word $8485
    .word $8085
    .word $90ff
    .word $8600
    .word $8084
    .word $ff80
    .word $0090
    .word $8786
    .word $8082
    .word $90ff
    .word $8700
    .word $8483
    .word $ff80
    .word $0090
    .word $8687
    .word $8089
    .word $90ff
    .word $8700
    .word $8089
    .word $ff80
    .word $0090
    .word $8188
    .word $8583
    .word $90ff
    .word $8900
    .word $8080
    .word $ff80
    .word $0090
    .word $8389
    .word $8080
    .word $90ff
    .word $8900
    .word $8085
    .word $ff80
    .word $0090
    .word $8989
    .word $8080
    .word $90ff
    .word $8100
    .word $8080
    .word $8080
    .word $90ff
    .word $8100
    .word $8382
    .word $8085
    .word $90ff
    .word $8100
    .word $8083
    .word $8080
    .word $90ff
    .word $8100
    .word $8483
    .word $8085
    .word $90ff
    .word $8100
    .word $8084
    .word $8085
    .word $90ff
    .word $8100
    .word $8784
    .word $8082
    .word $90ff
    .word $8100
    .word $8085
    .word $8080
    .word $90ff
    .word $8100
    .word $8487
    .word $8089
    .word $90ff
    .word $8100
    .word $8088
    .word $8081
    .word $90ff
    .word $8100
    .word $8989
    .word $8089
    .word $90ff
    .word $8200
    .word $8080
    .word $8080
    .word $90ff
    .word $8200
    .word $8080
    .word $8081
    .word $90ff
    .word $8200
    .word $8086
    .word $8080
    .word $90ff
    .word $8400
    .word $8085
    .word $8080
    .word $90ff
    .word $8600
    .word $8085
    .word $8080
    .word $90ff
    .word $8c00
    .word $9b9e
    .word $008e
    .word $8a91
    .word $969b
    .word $8f00
    .word $9098
    .word $00ff
    .word $9e9b
    .word $8e9c
    .word $8f00
    .word $9b92
    .word $008e
    .word $959c
    .word $998e
    .word $9500
    .word $8c98
    .word $0094
    .word $9295
    .word $ff9d
    .word $9500
    .word $968a
    .word $0099
    .word $9e96
    .word $8e9d
    .word $8a00
    .word $9295
    .word $009d
    .word $9792
    .word $9c9f
    .word $9200
    .word $8e8c
    .word $00ff
    .word $8a8d
    .word $949b
    .word $9d00
    .word $9996
    .word $009b
    .word $959c
    .word $a098
    .word $8c00
    .word $9b9e
    .word $0082
    .word $9b91
    .word $8296
    .word $8a00
    .word $928f
    .word $009b
    .word $8e91
    .word $958a
    .word $8f00
    .word $9b92
    .word $0082
    .word $9891
    .word $8d95
    .word $9500
    .word $9d92
    .word $0082
    .word $9895
    .word $8294
    .word $9900
    .word $9b9e
    .word $008e
    .word $8e8f
    .word $9b8a
    .word $8a00
    .word $8c92
    .word $008e
    .word $968a
    .word $9d9e
    .word $9c00
    .word $9995
    .word $0082
    .word $8a8f
    .word $9d9c
    .word $8c00
    .word $9798
    .word $008f
    .word $8c92
    .word $828e
    .word $8c00
    .word $9b9e
    .word $0083
    .word $9295
    .word $8e8f
    .word $9100
    .word $969b
    .word $0083
    .word $8e91
    .word $8295
    .word $8f00
    .word $9b92
    .word $0083
    .word $8a8b
    .word $8e97
    .word $a000
    .word $9b8a
    .word $0099
    .word $959c
    .word $8298
    .word $9c00
    .word $8f98
    .word $009d
    .word $a18e
    .word $9d92
    .word $8f00
    .word $9098
    .word $0082
    .word $9792
    .word $829f
    .word $9500
    .word $9d92
    .word $0083
    .word $9e9b
    .word $ff8b
    .word $9a00
    .word $948a
    .word $008e
    .word $9d9c
    .word $979e
    .word $8c00
    .word $9b9e
    .word $0084
    .word $9b91
    .word $8496
    .word $8a00
    .word $9e9b
    .word $008b
    .word $8e91
    .word $8395
    .word $9200
    .word $8e8c
    .word $0083
    .word $9b8b
    .word $948a
    .word $9c00
    .word $8b8a
    .word $009b
    .word $958b
    .word $8d97
    .word $9500
    .word $8f92
    .word $0082
    .word $8a8f
    .word $8e8d
    .word $a000
    .word $958a
    .word $0095
    .word $8fa1
    .word $9b8e
    .word $9700
    .word $949e
    .word $008e
    .word $9d9c
    .word $9998
    .word $a300
    .word $998a
    .word $00c4
    .word $a1a1
    .word $a1a1
    .word $8f00
    .word $9092
    .word $9d91
    .word $9b8e
    .word $9d00
    .word $9291
    .word $8f8e
    .word $ffff
    .word $8b00
    .word $c0af
    .word $8e8b
    .word $9d95
    .word $9b00
    .word $a7a8
    .word $8a96
    .word $8e90
    .word $a000
    .word $c0ab
    .word $8a96
    .word $8e90
    .word $8b00
    .word $c0af
    .word $8a96
    .word $8e90
    .word $9400
    .word $9297
    .word $9190
    .word $ff9d
    .word $9700
    .word $9792
    .word $8a93
    .word $ffff
    .word $9600
    .word $9c8a
    .word $8e9d
    .word $ff9b
    .word $9b00
    .word $a7a8
    .word $aca0
    .word $ffbd
    .word $a000
    .word $c0ab
    .word $aca0
    .word $ffbd
    .word $8b00
    .word $c0af
    .word $aca0
    .word $ffbd
    .word $9100
    .word $ff99
    .word $ff00
    .word $ffff
    .word $9c00
    .word $ff9d
    .word $9900
    .word $ff98
    .word $9900
    .word $ff98
    .word $9700
    .word $8d8e
    .word $9900
    .word $9298
    .word $989c
    .word $0097
    .word $1b1a
    .word $1d1c
    .word $1f1e
    .word $2120
    .word $2322
    .word $2524
    .word $2726
    .word $2928
    .word $2b2a
    .word $2d2c
    .word $2f2e
    .word $3130
    .word $3332
    .word $3534
    .word $3736
    .word $3938
    .word $3b3a
    .word $3d3c
    .word $3f3e
    .word $4140
    .word $4342
    .word $4544
    .word $4746
    .word $4948
    .word $4b4a
    .word $4d4c
    .word $4f4e
    .word $5150
    .word $5352
    .word $5514
    .word $5756

SeekItemStringPtr:
    ASL A                ; double it (2 bytes per pointer)
    TAX                  ; and put in X for indexing
    BCS @ItemHiTbl       ; if the item ID was >= $80, use second half of pointer table

    @ItemLoTbl:
    LDA LUT_ItemNamePtrTbl, X    ; load pointer from first half if ID <= $7F
    STA Var0
    LDA LUT_ItemNamePtrTbl+1, X
    JUMP @ItemPtrLoaded

    @ItemHiTbl:
    LDA LUT_ItemNamePtrTbl+$100, X   ; or from 2nd half if ID >= $80
    STA Var0
    LDA LUT_ItemNamePtrTbl+$101, X

    @ItemPtrLoaded:
    RTS

SeekItemStringPtrForEquip:
    ASL A                ; double it (2 bytes per pointer)
    TAX                  ; and put in X for indexing
    LDA LUT_ItemNamePtrTbl, X    ; fetch the pointer and store it to (tmp)
    STA tmp
    LDA LUT_ItemNamePtrTbl+1, X
    STA tmp+1
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Equip Menu Strings  [$ECDA :: 0x3ECEA]
;;
;;    String is placed at str_buf+$10 because first 16 bytes are used for item_box
;;  (the equipment list)
;;
;;    This routine is called when the equip menus change.  If an item is equipped/unequipped
;;  or dropped, or traded.  As such, the entire string of changed items needs to be redrawn.
;;  therefore for drawing empty slots, multiple blank tiles (FF) must be drawn to erase the
;;  item name that was previously drawn.  Blank tiles must also extend past the end of
;;  shorter equipment names.  So that if you have "Wooden" and trade it with "Cap", you're
;;  not left with "Capden".
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEquipMenuStrings:
    LDA #0                       ; string will be placed at str_buf+$10, and will be 8 bytes long
    STA str_buf+$19              ; so put the null terminator at the end right-off

    LDA #1
    STA menustall                ; the PPU is currently on, so set menustall.

    LDA #$1C-1                   ; A=$1C-1  (1C = start of weapon names in the item list)
    LDX equipoffset
    CPX #ch_weapons - ch_stats   ; buf if we're not dealing with weapons....
    BEQ :+
        LDA #$44-1                 ; A=$44-1  (44 = start of armor names in the item list)
    :   
    STA draweq_stradd            ; this value will be later added to the weapon/armor ID to get
                                 ; the proper string ID.  For now, just stuff it in RAM
                                 ; minus 1 because 0 is an empty slot


    LDA #$00                     ; Set A to zero.  This is our loop counter
  @MainLoop:
    PHA                          ; push the loop counter to the stack
    TAX                          ; then move it to X
    ASL A
    TAY                          ; and move it*2 to Y

    LDA lut_EquipStringPositions, Y     ; use Y to index a positioning LUT
    STA dest_x                          ;  load up x,y coords for this string
    LDA lut_EquipStringPositions+1, Y
    STA dest_y

    LDA #$FF                     ; fill first 2 bytes of the string with blank spaces (tile FF)
    STA str_buf+$10              ; later, these spaces will be replaced with "E-" if the item
    STA str_buf+$11              ;  is currently equipped.

    LDA item_box, X              ; get the current item ID
    STA tmp+2                    ; and stick it in temp ram for later

    AND #$7F                     ; remove the equip bit (get just the item ID)
    BNE @LoadName                ; if nonzero, load up the other name...

    LDA #$FF                   ; otherwise (zero), slot is empty, just fill the string with spaces
    STA str_buf+$12
    STA str_buf+$13
    STA str_buf+$14
    STA str_buf+$15
    STA str_buf+$16
    STA str_buf+$17
    STA str_buf+$18
    BNE @NotEquipped           ; then skip ahead (always branches)

    @LoadName:                     ; if the slot is not empty....
    CLC                          ; add the weapon/armor offset to the equipment ID.
    ADC draweq_stradd            ;  now A is the proper item ID

    CALL SeekItemStringPtrForEquip

    LDA tmp
    STA Var0
    LDA tmp+1
    STA Var1
    LDA #(BANK_ITEMS * 2) | %10000000
    STA Var2
    LDY #$06                     ; copy 7 characters from the item name (doesn't look for null termination)
    @LoadNameLoop:
        CALL ReadFarByte          ; load a character in the string  
        STA str_buf+$12, Y         ; and write it to our string buffer.  +2 because the first 2 bytes are the equip state
        DEY                        ; (that "E-" if equipped).  Then decrement Y
        BPL @LoadNameLoop          ; and loop until it wraps (7 iterations)

    LDA tmp+2                    ; get the item ID (to see if it's equipped)
    BPL @NotEquipped             ; if not equipped... skip ahead.  Otherwise

    LDA #$C7                   ; draw special "E" tile
    STA str_buf+$10
    LDA #$C2                   ; and "-" tile.
    STA str_buf+$11            ; draw them to indicate item is equipped

    @NotEquipped:

    LDA #>(str_buf+$10)          ; set high byte of text pointer
    STA Var1               ; low byte is set later (why not here?)
    LDA #<(str_buf+$10)          ; finally load the low byte of our text pointer
    STA Var0                 ;  why this isn't done above with the high byte is beyond me

    CALL DrawComplexString_New; then draw the complex string

    PLA                          ; pull the main loop counter
    CLC
    ADC #$01                     ; increment it by one
    CMP #16                      ; and loop until it reaches 16 (16 equipment names to draw)
    BCC @MainLoop

    RTS                          ; and return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  lut for Equip string positions  [$ED72 :: 0x3ED82]
;;
;;   X,Y positions for equipment text to be printed in equip menus

lut_EquipStringPositions:
  .byte $0A, $07,       $14, $07        ; character 0
  .byte $0A, $09,       $14, $09
  
  .byte $0A, $0D,       $14, $0D        ; character 1
  .byte $0A, $0F,       $14, $0F
  
  .byte $0A, $13,       $14, $13        ; character 2
  .byte $0A, $15,       $14, $15
  
  .byte $0A, $19,       $14, $19        ; character 3
  .byte $0A, $1B,       $14, $1B
