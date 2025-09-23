.segment "PRG_110"

.include "src/global-import.inc"

.export UnpackImage

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UnpackImage
;
; Var0 = low byte source address
; Var1 = high byte source address
; Var2 = bank source address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UnpackImage:
    ; Change the RAM bank to page 1 where we will put the data as we unpack it.
    LDA #1
    STA MMC5_RAM_BANK

    ; Set the PRG bank to the bank where the source image is stored
    LDA Var2
    STA MMC5_PRG_BANK2

    ; Start by loading out the "command bit width" which is in the 5th and 6th bits of the first byte
    LDY #0
    LDA (Var0),Y
    AND #%00110000
    LSR A
    LSR A
    LSR A
    LSR A
    STA decompressCommandBitWidth

    ; Load the address to the appropriate bit reading routine and save it in Var38+Var39. This is so that we
    ; can call this routine without needing to constantly check if we were using 1, 2, 3 or 4 bits per command.
    TAX
    LDA ReadBitTableLow,X
    STA Var38
    LDA ReadBitTableHigh,X
    STA Var39

    ; Next we will load out the command table. It is stored as a series of bytes in the header, each one
    ; an index into CommandTableLo+CommandTableHi. To make the loop easier we loop backwards while using Y
    ; as the loop counter, starting Y at the value of the command bit width since that is how many bytes we
    ; need to read.
    
    LDA (Var0),Y
    AND #%00001111
    TAY                             ; Transfer the command bit width to Y
    INY                             ; Increment Y by one (since we DEY early in the loop)

    ; Y will now have the offset to the very last command index byte in the header, and we will now use
    ; that to load out all command index bytes in reverse order.
    .REPEAT 16, i
        DEY                                 ; Decrement Y by one
        BNE :+                              ; If Y is still nonzero, continue ahead
            JMP @CommandTableBuilt
        :
        LDA (Var0),Y                        ; Load the command index byte
        TAX                                 ; Transfer it to X
        LDA CommandTableLo,X                ; Load the low address of the command routine (-1 because we use 1-based indexing)
        STA decompressCommandRoutinesLo + i ; Store the low address in the Var40, Var42, Var44, etc, all the way to Var70
        LDA CommandTableHi,X                ; Load the high address of the command routine (-1 because we use 1-based indexing)
        STA decompressCommandRoutinesHi + i ; Store the high address in the Var41, Var43, Var45, etc, all the way to Var71
    .ENDREPEAT
    @CommandTableBuilt:

    ; We now have potentially 16 command addresses in the Var40, Var42, Var44, etc, all the way to Var70, Var71
    ; it's time to start unpacking the image. First we move our Var0+Var1 beyond the header to the body of the image.

    LDY #0
    LDA (Var0),Y
    AND #%00001111                  ; Mask out all but the header command list size
    CLC
    ADC #(1+13+32)                  ; Add 46 to advance past the palette + nametable + command bit width byte
    BCC :+                          ; Check if the addition caused an overflow
        INC Var1                    ; If so increment the high byte of the source address
    :
    CLC
    ADC Var0                        ; Add the low byte of the source address
    STA Var0
    BCC :+                          ; If the addition didn't overflow, continue ahead
        INC Var1                    ; Otherwise, increment the high byte of the source address
    :

    ; Now it's finally time to start reading the image's body data. This data is in the format of a series of commands
    ; followed by parameter data. The header has decided which commands are used, and how many bits are used per command.
    ; Normally reading data would be easy in a normal loop, but because things aren't aligned by whole bytes, we need to
    ; have a more crafty way of reading bits.

    LDY #0
    STY Var73   ; The byte index, 0 to 255
    LDX #0
    STX Var72   ; The bit index, 0 to 7

    LDA #<imageBuffer
    STA Var73           ; The output address
    LDA #>imageBuffer
    STA Var74
    

    CALL ReadCommandBits
    CALL ExecuteCommand

    RTS

ReadBitTableLow:
    .byte <ReadOneBit, <ReadTwoBits, <ReadThreeBits, <ReadFourBits

ReadBitTableHigh:
    .byte >ReadOneBit, >ReadTwoBits, >ReadThreeBits, >ReadFourBits

ReadCommandBits:
    JMP (Var38)
ReadOneBit:
    LDA (Var0),Y        ; Load a byte from the source address
    ; The bit want could be anywhere in the byte, so we need to rotate it right in a loop until it's in the first bit.
    @Loop:
        DEX
        BMI @Done       ; If that took X negative, we're done
        ROR             ; Rotate right
        JMP @Loop
    @Done:
    AND #%00000001      ; Mask out all except the first bit
    LDX Var72           ; Restore the bit index
    INX                 ; Increment the bit index
    STX Var72           ; Update the bit index
    CPX #8              ; Check if the bit index is now 8 (beyond the byte)
    BNE @Return         ; If it's not yet 8, return
    LDX #0              ; Otherwise, reset the bit index to zero
    STX Var72           ; Update the bit index
    INY                 ; Increment the byte index
    STY Var73           ; Update the byte index
    BNE @Return         ; Check if the byte index has wrapped around (beyond the page), if not return
    LDY #0              ; Otherwise, reset the byte index to zero
    STY Var73           ; Update the byte index
    STA Var10           ; Backup the result bit in Var10
    LDA Var2            ; Load the current page index
    CLC
    ADC #1              ; Increment the page index by 1
    STA Var2            ; Save the new page index
    STA MMC5_PRG_BANK2  ; Switch the bank to the new page
    LDA Var10           ; Restore the result bit
    @Return:
    RTS

ReadTwoBits:
    CALL ReadOneBit
    STA Var3
    CALL ReadOneBit
    ROL
    ORA Var3
    RTS

ReadThreeBits:
    CALL ReadOneBit
    STA Var3
    CALL ReadOneBit
    ROL
    ORA Var3
    STA Var3
    CALL ReadOneBit 
    ROL
    ORA Var3
    RTS

ReadFourBits:
    CALL ReadOneBit
    STA Var3
    CALL ReadOneBit
    ROL
    ORA Var3
    CALL ReadOneBit
    ROL
    ORA Var3
    CALL ReadOneBit
    ROL
    ORA Var3
    RTS


ExecuteCommand:
    TAX
    LDA decompressCommandRoutinesHi,X
    PHA
    LDA decompressCommandRoutinesLo,X
    PHA
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;
; Command Table
;;;;;;;;;;;;;;;;;;;;;;;;

CommandTableLo:
    .byte <(Command0_RepeatBit-1), <(Command1-1), <(Command2-1), <(Command3-1)
CommandTableHi:
    .byte >(Command0_RepeatBit-1), >(Command1-1), >(Command2-1), >(Command3-1)

; Repeats bits
Command0_RepeatBit:
    CALL ReadTwoBits
    DEBUG
    RTS

Command1:
    DEBUG
    RTS

Command2:
    DEBUG
    RTS

Command3:
    DEBUG
    RTS