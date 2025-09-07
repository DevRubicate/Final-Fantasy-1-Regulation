;Copyright (c) 2006 by Shay Green. Permission is hereby granted, free of charge,
;to any person obtaining a copy of this software and associated documentation
;files (the "Software"), to deal in the Software without restriction, including
;without limitation the rights to use, copy, modify, merge, publish, distribute,
;sublicense, and/or sell copies of the Software, and to permit persons to whom
;the Software is furnished to do so, subject to the following conditions: The
;above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS
;IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
;LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
;AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
;CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


char_offset = 4 ;32

yxa_to_8_digits:
    cpy #152
    bcc lt10000000
    bne gt10000000
    cpx #150
    bcc lt10000000
    bne gt10000000
    cmp #128
    bcc lt10000000
gt10000000:
    sbc #128
    sta yxa2decOutput + 4
    txa
    sbc #150
    tax
    tya
    sbc #152
    tay
    lda #char_offset + 1
    bne gt10000000x ; always branches
lt10000000:
    sta yxa2decOutput + 4
    lda #char_offset
gt10000000x:
    sta yxa2decOutput
    lda yxa2decOutput + 4
    
yxa_to_7_digits:
    cpy #$6A
    bcc lt7000000
    bne gt7000000
    cpx #$CF
    bcc lt7000000
    bne gt7000000
    cmp #$C0
    bcc lt7000000
gt7000000:
    sbc #$C0
    sta yxa2decOutput + 4
    txa
    sbc #$CF
    tax
    tya
    sbc #$6A
    tay
    lda #char_offset + 7
    bne lt4000000   ; always branches
    
lt7000000:
    sta yxa2decOutput + 4
    lda #char_offset
    cpy #$3D
    bcc lt4000000
    bne gt4000000
    cpx #$09
    bcc lt4000000
    ; 4000000 conveniently has 0 as the low 8 bits!
gt4000000:
    txa
    sbc #$09
    tax
    tya
    sbc #$3D
    tay
    lda #char_offset + 4
lt4000000:
    sta yxa2decOutput + 1
    lda yxa2decOutput + 4
    cpy #30
    bcc lt2000000
    bne gt2000000
    cpx #132
    bcc lt2000000
    bne gt2000000
    cmp #128
    bcc lt2000000
gt2000000:
    sbc #128
    sta yxa2decOutput + 4
    txa
    sbc #132
    tax
    tya
    sbc #30
    tay
    lda yxa2decOutput + 1
    adc #1          ; + carry that is always set
    sta yxa2decOutput + 1
    lda yxa2decOutput + 4
lt2000000:
    cpy #15
    bcc lt1000000
    bne gt1000000
    cpx #66
    bcc lt1000000
    bne gt1000000
    cmp #64
    bcc lt1000000
gt1000000:
    sbc #64
    sta yxa2decOutput + 4
    txa
    sbc #66
    tax
    tya
    sbc #15
    tay
    inc yxa2decOutput + 1
    lda yxa2decOutput + 4
lt1000000:
    
yxa_to_6_digits:
    cpy #$0A
    bcc lt700000
    bne gt700000
    cpx #$AE
    bcc lt700000
    bne gt700000
    cmp #$60
    bcc lt700000
gt700000:
    sbc #$60
    sta yxa2decOutput + 4
    txa
    sbc #$AE
    tax
    tya
    sbc #$0A
    tay
    lda #char_offset + 7
    bne do200000    ; always branches
    
lt700000:
    cpy #$06
    bcc lt400000
    bne gt400000
    cpx #$1A
    bcc lt400000
    bne gt400000
    cmp #$80
    bcc lt400000
gt400000:
    sbc #$80
    sta yxa2decOutput + 4
    txa
    sbc #$1A
    tax
    tya
    sbc #$06
    tay
    lda #char_offset + 4
    bne do200000
lt400000:
    sta yxa2decOutput + 4
    lda #char_offset
do200000:
    sta yxa2decOutput + 2
    lda yxa2decOutput + 4
    cpy #3
    bcc lt200000
    bne gt200000
    cpx #13
    bcc lt200000
    bne gt200000
    cmp #64
    bcc lt200000
gt200000:
    sbc #64
    sta yxa2decOutput + 4
    txa
    sbc #13
    tax
    tya
    sbc #3
    tay
    lda yxa2decOutput + 2
    adc #1          ; + carry that is always set
    sta yxa2decOutput + 2
    lda yxa2decOutput + 4
lt200000:
    cpy #1
    bcc lt100000
    bne gt100000
    cpx #134
    bcc lt100000
    bne gt100000
    cmp #160
    bcc lt100000
gt100000:
    sbc #160
    sta yxa2decOutput + 4
    txa
    sbc #134
    tax
    bcs nb100000
    dey
nb100000:
    dey
    inc yxa2decOutput + 2
    lda yxa2decOutput + 4
lt100000:
    

yxa_to_5_digits:
    dey
    bmi lt70000
    ldy #char_offset
    cpx #17
    bcc gt40000
    bne gt70000
    cmp #112
    bcc gt40000
gt70000:
    sbc #112
    tay
    txa
    sbc #17
    tax
    tya
    ldy #char_offset + 7
    bne lt40000             ; always branches
lt70000:
    
xa_to_5_digits:
    ldy #char_offset
    cpx #156
    bcc lt40000
    bne gt40000
    cmp #64
    bcc lt40000
gt40000:
    sec             ; needed by yxa_to_5_digits
    sbc #64
    tay
    txa
    sbc #156
    tax
    tya
    ldy #char_offset + 4
lt40000:
    cpx #78
    bcc lt20000
    bne gt20000
    cmp #32
    bcc lt20000
gt20000:
    sbc #32
    sta yxa2decOutput + 4
    txa
    sbc #78
    tax
    lda yxa2decOutput + 4
    iny
    iny
lt20000:
    cpx #39
    bcc lt10000
    bne gt10000
    cmp #16
    bcc lt10000
gt10000:
    sbc #16
    sta yxa2decOutput + 4
    txa
    sbc #39
    tax
    lda yxa2decOutput + 4
    iny
lt10000:
    sty yxa2decOutput + 3

xa_to_4_digits:
    cpx #$1B
    bcc lt7000
    bne gt7000
    cmp #$58
    bcc lt7000
gt7000: sbc #$58
    tay
    txa
    sbc #$1B
    tax
    tya
    ldy #char_offset + 7
    bne lt4000
    
lt7000:
    ldy #char_offset
    cpx #$0F
    bcc lt4000
    bne gt4000
    cmp #$A0
    bcc lt4000
gt4000: sbc #$A0
    tay
    txa
    sbc #$0F
    tax
    tya
    ldy #char_offset + 4
lt4000:
    cpx #7
    bcc lt2000
    bne gt2000
    cmp #208
    bcc lt2000
gt2000:
    sbc #208
    sta yxa2decOutput + 4
    txa
    sbc #7
    tax
    lda yxa2decOutput + 4
    iny
    iny
lt2000: cpx #3
    bcc lt1000
    bne gt1000
    cmp #232
    bcc lt1000
gt1000: sbc #232
    bcs nb1000
    dex
nb1000:
    dex
    dex
    dex
    iny
lt1000:
    sty yxa2decOutput + 4

xa_to_3_digits:
    cpx #2
    bcc lt700
    bne gt700
    cmp #$BC
    bcc lt700
gt700:
    sbc #$BC
    bcs nb700
    dex
nb700:  dex
    dex
    ldy #char_offset + 7
    bne lt400
lt700:
    ldy #char_offset
    cpx #1
    bcc lt400
    bne gt400
    cmp #$90
    bcc lt400
gt400:
    sbc #$90
    bcs nb400
    dex
nb400:  dex
    ldy #char_offset + 4
lt400:  cpx #0
    bne gt200
a_to_3_digits_:
    cmp #200
    bcc lt200
gt200:  sbc #200
    iny
    iny
lt200:  cmp #100
    bcc lt100
    sbc #100
    iny
lt100:  

a_to_2_digits:
    cmp #70
    bcc lt70
    sbc #70
    ldx #char_offset + 7
    bne lt40
lt70:
    ldx #char_offset
    cmp #40
    bcc lt40
    sbc #40
    ldx #char_offset + 4
lt40:
    cmp #20
    bcc lt20
    sbc #20
    inx
    inx
lt20:
    cmp #10
    bcc lt10
    sbc #10
    inx
lt10:
    CLC
    ADC #char_offset
    STA yxa2decOutput+7
    STX yxa2decOutput+6
    STY yxa2decOutput+5
    rts
    
a_to_3_digits:
    ldy #char_offset
    jmp a_to_3_digits_

