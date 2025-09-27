.segment "PRG_110"

.include "src/global-import.inc"

.export UnpackImage

.import UploadMassiveImage

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UnpackImage
;
; Var0 = source address bit offset
; Var1 = source address low byte
; Var2 = source address high byte
; Var3 = source address bank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UnpackImage:
    ; Change the RAM bank to page 1 where we will put the data as we unpack it.
    LDA #1
    STA MMC5_RAM_BANK

    ; Clear the imageBuffer memory
    LDA #0
    .REPEAT 32, i
        LDY #0
        :
            STA imageBuffer + i*256,Y
            INY
            BNE :-
    .ENDREPEAT

    ; Set the PRG bank to the bank where the source image is stored
    LDA Var3
    STA MMC5_PRG_BANK2

    ; Start by loading out the "command bit width" which is in the 5th and 6th bits of the first byte
    LDY #0
    LDA (Var1),Y
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

    ; Read the left clipping value (bottom 4 bits)
    INY
    LDA (Var1),Y
    AND #%00001111
    ASL                 ; multiply by 16
    ASL 
    ASL 
    ASL 
    STA Var4            ; Save how many bytes worth of output clipping from the left skips

    ; Read the right clipping value (upper 4 bits)
    LDA (Var1),Y
    AND #%11110000
    ; No need to multiply by 16, it's already inherently done
    STA Var5            ; Save how many bytes worth of output clipping from the right skips

    ; Read the top clipping value (bottom 4 bits)
    INY
    LDA (Var1),Y
    AND #%00001111
    ASL                 ; multiply by 2 (to make calculations easier later)
    STA Var6

    ; Read the bottom clipping value (upper 4 bits)
    LDA (Var1),Y
    AND #%11110000
    LSR                  ; divide by 16 but then multiply by 2 (to make calculations easier later)
    LSR
    LSR
    ;LSR
    ;ASL
    STA Var7

    ; Next we will load out the command table. It is stored as a series of bytes in the header, each one
    ; an index into CommandTableLo+CommandTableHi. To make the loop easier we loop backwards while using Y
    ; as the loop counter, starting Y at the last command index byte.
    
    ; Read how many command index bytes there are
    LDY #0
    LDA (Var1),Y
    AND #%00001111
    TAY

    ; Then we advance past part of the header so we can look at the command index bytes more easily
    LDA Var1
    CLC
    ADC #(3 - 1)             ; advance past control byte, H clipping, V clipping, but due to how our loop works below we do -1
    STA Var1
    BCC :+
        INC Var2
    :

    ; Y will now have the offset to the very last command index byte in the header, and we will now use
    ; that to load out all command index bytes in reverse order.
    .REPEAT 16, i
        ; Skip the check for the first loop
        .IF i > 0
            DEY                                 ; Decrement Y by one
            BNE :+                              ; If Y is still nonzero, continue ahead
                JMP @CommandTableBuilt
            :
        .ENDIF
        LDA (Var1),Y                        ; Load the command index byte
        TAX                                 ; Transfer it to X
        LDA CommandTableLo,X                ; Load the low address of the command routine (-1 because we use 1-based indexing)
        STA decompressCommandRoutinesLo + i ; Store the low address in decompressCommandRoutinesLo
        LDA CommandTableHi,X                ; Load the high address of the command routine (-1 because we use 1-based indexing)
        STA decompressCommandRoutinesHi + i ; Store the high address in decompressCommandRoutinesHi
    .ENDREPEAT
    @CommandTableBuilt:

    ; We now have potentially 16 command addresses in decompressCommandRoutinesLo+decompressCommandRoutinesHi
    ; it's time to start unpacking the image. First we move our Var0+Var1 to point to where the actual bit stream starts.

    LDY #0
    LDA (Var1),Y
    AND #%00001111                  ; Mask out all but the header command list size
    CLC
    ADC #(46)                       ; Add 48 to advance past the header + palette + nametable
    CLC
    BCC :+                          ; Check if the addition caused an overflow
        INC Var2                    ; If so increment the high byte of the source address
    :
    CLC
    ADC Var1                        ; Add the low byte of the source address
    STA Var1
    BCC :+                          ; If the addition didn't overflow, continue ahead
        INC Var2                    ; Otherwise, increment the high byte of the source address
    :

    ; Now it's finally time to start reading the image's body data. This data is in the format of a series of commands
    ; followed by parameter data. The header has decided which commands are used, and how many bits are used per command.
    ; Normally reading data would be easy in a normal loop, but because things aren't aligned by whole bytes, we need to
    ; have a more crafty way of reading bits.

    LDA #0
    STA Var74           ; Output address bit offset
    LDA #<imageBuffer
    STA Var75           ; Output address low byte
    LDA #>imageBuffer
    STA Var76           ; Output address high byte

    ; The top clipping boundary can be treated as a starting offset for the output buffer, and afterwards we can just
    ; forget about it. Each row of 8x8 tiles is 512 bytes across, which is exactly 2 increments of the output address
    ; high byte. We have pre-multiplied the top clipping boundary by 2 beforehand to make this easier.
    LDA Var76
    CLC
    ADC Var6
    STA Var76   ; Save the new high address byte, overflow should be impossible

    ; The left clipping boundary has to be re-applied for each row. We are starting at row 0 now so we need to add the
    ; correct offset. Each tile is 16 bytes of data, so we use our pre-multiplied left clipping boundary value to add
    ; this offset to our starting position.
    LDA Var75           ; Load output address low byte
    ; Carry is clear
    ADC Var4            ; Add the precalculated left clipping boundary
    STA Var75           ; Save the new low address byte, overflow should be impossible  

    @ContinueDecompressing:

    CALL ReadCommandBits
    CALL ExecuteCommand

    ; Each row of 8x8 tiles is 512 bytes across. This creates a tricky situation for detecting when we are touching the
    ; right clipping boundary. The buffer begins at $6000, and our address is split into two address bytes (Var75+Var76).
    ; If it had been only 256 bytes across for each row, we could have just used a normal CMP Var5 to find out when we
    ; are touching the right clipping boundary. Since that's not the case, we have to be a little more clever. One nice
    ; observation is that since 512 bytes is twice as much as 256, it means every alternating high address byte can tell
    ; us if we are in the 0 - 255 range or the 256 - 511 range. So in short, we only check for the right clipping boundary
    ; if the high address byte is odd, not if it's even.

    LDA Var76           ; Load high address byte
    LSR A               ; Shift bit 0 into carry
    BCC @NoRightClip    ; If carry is set, it means we had an odd high address byte, so we are in the 256-511 range
        ; It's an odd high address byte, so now we can check if the low address byte is extending into the right clipping
        ; boundary. Var5 holds how many bytes from the right makes up the right clipping boundary, so we can simply add
        ; the two together and check for an overflow to see if we have gone too far.
        LDA Var75           ; Load low address byte
        CLC
        ADC Var5            ; Add the right clipping boundary
        BCC @NoRightClip    ; If the addition didn't overflow, we are in the right clipping boundary
            ; We are in the right clipping boundary, so we have a very difficult job ahead of us. It's very likely that
            ; pixel data has already been written to the right clipping boundary in the output buffer. We need to move
            ; this data to the next row, while respecting where the left clipping boundary ends.

            ; Register A currently holds how many bytes we have spilled over into the right clipping boundary. We need
            ; to rewind a bit, subtracting A from our output address low byte. But the SBC opcode works in the opposite
            ; direction, so we need to do a reverse subtraction, so that instead of A - Var75 we get Var75 - A.

            TAY                 ; Save how many bytes we have spilled in Y
            STY Var80           ; Back it up in Var80

            EOR #$FF
            SEC
            ADC Var75           ; Reverse subtraction

            STA Var78           ; Save the rewinded low address byte
            LDA Var76           ; Load output high address byte
            STA Var79           ; Save the rewinded high address byte

            ; However, we also need to move the output address to the next row. Since we are moving to a new row, we have to
            ; add our left clipping boundary again. However, since each row start at $xx00, it means we start at 0 + left
            ; boundary, so instead we can just use the precalculated left clipping boundary value as-is.
            LDA Var4            ; Load left clipping boundary
            STA Var75           ; Save the new low address byte
            INC Var76           ; Increment output high address byte to target the next row

            ; Now that we have a rolled back address and a new row to work with, we can start a loop that moves all the data
            ; from the right clipping boundary to the next row.
            INY
            @Loop:
                DEY                       ; Decrement the overspill counter
                BMI @LoopDone             ; If we've reached the end of the overspill, we're done
                LDA (Var78),Y             ; Load an overspill byte in the right clipping boundary area
                STA (Var75),Y             ; Store it in the output address pointing at the new row
                LDA #0
                STA (Var78),Y             ; Zero the overspill byte
                JMP @Loop
            @LoopDone:

            ; Lastly we move our output address to be just after the last byte we copied.
            LDA Var75           ; Load the low address byte
            CLC
            ADC Var80           ; Add the number of bytes we spilled
            STA Var75           ; Save the new low address byte
            
    @NoRightClip:

    ; Next we have to deal with the bottom clipping boundary. If we hit this boundary, it means we are done.
    ; The entire buffer is 32x16 tiles big, or 8192 bytes. The buffer starst at $6000 and ends at $7FFF.
    ; So if we take the high byte output address and add the premultiplied bottom clipping boundary, we can
    ; see if it exceeds $7F. If it does, we're done.

    LDA Var76           ; load high byte of output address
    CLC
    ADC Var7            ; subtract bottom clipping boundary
    CMP #$80            ; compare A >= $80
    BCS @Done           ; if A was equal or greater, we're done
    JMP @ContinueDecompressing
    @Done:

    ; We are finally done with decompression. Next we have to upload the data to to the PPU.
    FARCALL UploadMassiveImage


    RTS

ReadBitTableLow:
    .byte <ReadOneBit, <ReadTwoBits, <ReadThreeBits, <ReadFourBits

ReadBitTableHigh:
    .byte >ReadOneBit, >ReadTwoBits, >ReadThreeBits, >ReadFourBits

ReadCommandBits:
    JMP (Var38)

ReadOneBit:
    LDY #0
    LDA (Var1),Y        ; Load a byte from the source address
    LDY Var0            ; Load the source address bit offset
    ; The bit want could be anywhere in the byte, so we need to shift it right in a loop until it's in the first bit.
    @Loop:
        DEY
        BMI @Done       ; If that took X negative (from underflowing), we're done
        LSR             ; shift our byte rightwards
        JMP @Loop
    @Done:
    AND #%00000001      ; Mask out all except the first bit
    LDY Var0            ; Load the source address bit offset
    INY                 ; Increment the source address bit offset
    STY Var0            ; Save the source address bit offset
    CPY #8              ; Check if the source address bit offset is now 8 (beyond the byte)
    BNE @Return         ; If it's not yet 8, return
        LDY #0              ; Otherwise, reset the source address bit offset to zero
        STY Var0            ; Save the source address bit offset
        INC Var1            ; Increment the source address low byte
        BNE @Return         ; Check if the source address low byte has overflown, if not return
            ; At this point you might assume that we should increment the source address high byte
            ; but this is not the case. Our data bank organizes things in a 2d depth manner, meaning
            ; That rather than moving onto the next high byte, we instead move onto the next bank page.
            LDY Var3            ; Load the source address bank page
            INY                 ; Increment the bank page
            STY Var3            ; Save the source address bank page
            STY MMC5_PRG_BANK2  ; Switch the bank to the new page
    @Return:
    RTS

ReadTwoBits:
    CALL ReadOneBit
    STA Var8
    CALL ReadOneBit
    ASL
    ORA Var8
    RTS

ReadThreeBits:
    CALL ReadOneBit
    ASL
    STA Var8
    CALL ReadOneBit
    ORA Var8
    ASL
    STA Var8
    CALL ReadOneBit 
    ORA Var8
    RTS

ReadFourBits:
    CALL ReadOneBit
    STA Var3
    CALL ReadOneBit
    ASL
    ORA Var3
    CALL ReadOneBit
    ASL
    ORA Var3
    CALL ReadOneBit
    ASL
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
    .byte <(Command_REPEAT_BITS-1), <(Command_PLOT_BITS_4-1), <(Command_PLOT_BITS_8-1), <(Command_PLOT_BITS_12-1), >(Command_REPEAT_COMMAND-1)
CommandTableHi:
    .byte >(Command_REPEAT_BITS-1), >(Command_PLOT_BITS_4-1), >(Command_PLOT_BITS_8-1), >(Command_PLOT_BITS_12-1), >(Command_REPEAT_COMMAND-1)

; Repeats bits
Command_REPEAT_BITS:
    CALL ReadOneBit     ; The bit to repeat (0 or 1)
    STA Var77           ; Save the output bit
    CALL ReadThreeBits  ; How many repetitions (0 to 7)
    CLC
    ADC #2              ; Add 2 to the repetitions (2 to 9)
    STA Var78           ; Save the number of repetitions

    ; So, our goal is to write bits to the output buffer, N times. This is a bit tricky because we are writing
    ; bits, not bytes. This means that it's harder to put the bit in the right position, we can't just use the
    ; Y register to index into the output buffer alone. Instead, we will use a rotation trick to slowly tease
    ; the bits into place, one rotation at a time. Then we repeat that process once for each repetition.

    ; Var74+Var75 is the output address
    ; Var73 is the output bit offset

    ; This means that we increment Var73 by 1 for every bit we output, and when it reaches 8, we increment
    ; Var74 by 1 and set Var73 back to 0. When Var74 overflows, we increment Var75. That way we can address
    ; and target any specific bit.

    LDY #0

    @Loop:

        LDA Var77               ; Load the output bit
        LSR                     ; Rotate the output bit right into the carry

        ; Next we will now rotate the bit into the output buffer byte. It ends up in position 0 of the byte
        ; no matter what, but we keep rotating the output buffer byte 8 times in total before moving on to
        ; the next byte, so everything is rotated into the correct position.

        LDA (Var75),Y       ; Load the existing output byte
        ROL                 ; Rotate the byte to the left with our carry taking bit 0
        STA (Var75),Y       ; Store the rotated byte back to the output buffer

        ; Next advance the output address to the next bit

        LDA Var74               ; Load the bit offset
        CLC
        ADC #1                  ; Add 1 to the bit offset
        CMP #8                  ; Compare to 8 (the number of bits in a byte)
        BNE @SameLowByte        ; If it's not 8, it means we are still in the same byte
            INC Var75           ; Otherwise, increment the byte offset
            BNE @SameHighByte   ; If the byte offset didn't wrap around, continue ahead
                INC Var76       ; Otherwise, increment the output high byte address
            @SameHighByte:
            LDA #0              ; Reset the bit offset
        @SameLowByte:
        STA Var74               ; Save our new bit position

        DEC Var78           ; Decrement the repetition counter
        BNE @Loop           ; If it's not zero, loop and do the entire process again
    RTS

Command_PLOT_BITS_4:
    LDA #4
    STA Var78
    JUMP Command_PLOT_BITS_N

Command_PLOT_BITS_8:
    LDA #8
    STA Var78
    JUMP Command_PLOT_BITS_N

Command_PLOT_BITS_12:
    LDA #12
    STA Var78
    NOJUMP Command_PLOT_BITS_N

Command_PLOT_BITS_N:
    @Loop:
        CALL ReadOneBit         ; The bit to plot
        LSR                     ; Rotate the output bit right into the carry

        ; Next we will now rotate the bit into the output buffer byte. It ends up in position 0 of the byte
        ; no matter what, but we keep rotating the output buffer byte 8 times in total before moving on to
        ; the next byte, so everything is rotated into the correct position.
        LDY #0
        LDA (Var75),Y       ; Load the existing output byte
        ROL                 ; Rotate the byte to the left with our carry taking bit 0
        STA (Var75),Y       ; Store the rotated byte back to the output buffer

        LDA Var74               ; Load the output bit offset
        CLC
        ADC #1                  ; Add 1 to the output bit offset
        CMP #8                  ; Compare to 8 (the number of bits in a byte)
        BNE @SameLowByte        ; If it's not 8, it means we are still in the same byte
            INC Var75           ; Otherwise, increment the byte offset
            BNE @SameHighByte   ; If the byte offset didn't wrap around, continue ahead
                INC Var76       ; Otherwise, increment the output high byte address
            @SameHighByte:
            LDA #0              ; Reset the output bit offset
        @SameLowByte:
        STA Var74               ; Save our new bit position

        DEC Var78           ; Decrement the repetition counter
        BNE @Loop           ; If it's not zero, loop and do the entire process again
    RTS

Command_REPEAT_COMMAND:
    ERROR
    RTS

