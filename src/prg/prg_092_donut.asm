.segment "PRG_092"

.include "src/global-import.inc"

.import Video_Inc1_Address, Video_MassWriteStack, WaitForVBlank
.import LUT_TILE_CHR, LUT_TILE_CHR_SIBLING2



; donut-nes v2023-12-21 - public domain (details at end of file)
; ca65 6502 decompressor for use in a NES project
;
; By Johnathan Roatch - https://jroatch.nfshost.com/donut-nes/
;
; donut_decompress_block is the main decoder for Donut, it only uses
; CPU memory which are defined in the following ca65 segments
; detailed notes above the donut_decompress_block proc
;
; _donut_bulk_load is a helper routine for CC65 (The C compiler) that
; takes a char * pointer to a donut compressed file that has been .INCBIN
; , decompresses it, and uploads to the NES PPU via $2007.
; along with inporting the _donut_bulk_load symbol, include the
; following function prototype in a .c or .h file:
;   void __fastcall__ donut_bulk_load(const char * data);

.export donut_decompress_block, UploadCHR

; donut_stream_ptr could also be aliased to some generic "input data pointer"
; but keep in mind decompress_block won't automaticaly advance

;.segment "BSS"
;donut_output_buffer:     .res 64
;    ; can be 64, 128, or 192 bytes if doing multiple decompress_block calls.
;    ; can be the stack page if using a "popslide ppu upload" technique.
;    ; if located in zeropage for fast decoding, in donut_bulk_load
;    ; change `a:donut_output_buffer-64` to `z:donut_output_buffer-64`

;.segment "CODE"
;;
; donut_decompress_block
; Decompresses a single variable sized block to 64 output bytes.
; @param donut_stream_ptr: pointer to the start of the compressed stream
; @param Y accumulated input offset, bytes are read from `(donut_stream_ptr),y`
; @param X accumulated output offset, bytes are written to `donut_output_buffer,x`
; You *must* reset the X and Y registers to 0 before the first call.
;
; Carry flag set indicates that nothing happened due to
; the first input byte being >= 0xc0, to allow for future extensions.
; in this case, A will hold that first byte.
;
; otherwise:
; the number of input bytes read is added to Y and
; the number of output bytes written (64) added to X.
;
; *Do not* call more then 3 times in a row without dealing with
; the accumulated registers (for example by uploading the output buffer
; and adding Y to donut_stream_ptr).
; Undefine results will occur if X or Y would warp during decompression.
; (corrupted out of bounds read and writes, incomplete decoding, etc)
;
; Trashes A, temp 0 ~ temp 14.
; bytes: 238, average cycles: 3700, cycle range: 1272 ~ 7221.
; cycle usage may increase due to code and data page crossings


plane_buffer        = donut_temp+0 ; 8 bytes
pb8_ctrl            = donut_temp+8
temp_y              = pb8_ctrl
even_odd            = donut_temp+9
block_offset        = donut_temp+10
plane_def           = donut_temp+11
block_offset_end    = donut_temp+12
block_header        = donut_temp+13
is_rotated          = donut_temp+14

; Block header format:
; 76543210
; |||||||+-- Rotate plane bits (135° reflection)
; ||||000--- All planes: 0x00
; ||||010--- Odd planes: 0x00, Even planes:  pb8
; ||||100--- Odd planes:  pb8, Even planes: 0x00
; ||||110--- All planes: pb8
; ||||001--- In another header byte, For each bit starting from MSB
; ||||         0: 0x00 plane
; ||||         1: pb8 plane
; ||||011--- In another header byte, Decode only 1 pb8 plane and
; ||||       duplicate it for each bit starting from MSB
; ||||         0: 0x00 plane
; ||||         1: duplicated plane
; ||||       If extra header byte = 0x00, no pb8 plane is decoded.
; |||+------ Even planes predict from 0xff
; ||+------- Odd planes predict from 0xff
; |+-------- Even planes = Even planes XOR Odd planes
; +--------- Odd  planes = Even planes XOR Odd planes
; 00101010-- Uncompressed block of 64 bytes (bit pattern is ascii '*' )
; 11111111-- End of stream
;
; these 2 routines (do_raw_block and read_plane_def_from_stream)
; are placed above decompress_block due to branch distance


; ad-hoc alignment
.res 11

do_raw_block:
    raw_block_loop:
        lda (donut_stream_ptr), y
        iny
        sta donut_output_buffer, x
        inx
        cpx block_offset_end
    bcc raw_block_loop
    .assert >* = >raw_block_loop, ldwarning, "raw_block_loop in donut_decompress_block crosses page boundary - slow"
    clc  ; to indicate success
early_exit:
    rts

read_plane_def_from_stream:
    ror
    lda (donut_stream_ptr), y
    iny
    bne plane_def_ready  ;,; jmp plane_def_ready

donut_decompress_block:
    txa
    clc
    adc #64
    sta block_offset_end
    lda (donut_stream_ptr), y
    cmp #$c0
    bcs early_exit
        ; Return to caller to let it do the processing of headers >= 0xc0.
    iny  ; Y represents the number of successfully processed bytes.
    cmp #$2a
    beq do_raw_block
    ;,; bne do_normal_block
do_normal_block:
    sta block_header
    stx block_offset

    ;,; lda block_header
    and #%11011111
        ; The 0 are bits selected for the even ("lower") planes
        ; The 1 are bits selected for the odd planes
        ; bits 0~3 should be set to allow the mask after this to work.
    sta even_odd
        ; even_odd toggles between the 2 fields selected above for each plane.

    ;,; lda block_header
    lsr
    ror is_rotated
    lsr
    bcs read_plane_def_from_stream
    ;,; bcc unpack_shorthand_plane_def
    unpack_shorthand_plane_def:
        and #$03
        tax
        lda shorthand_plane_def_table, x
    plane_def_ready:
    ror is_rotated
    sta plane_def
    sty temp_y

    clc
    lda block_offset
    plane_loop:
        adc #8
        sta block_offset

        lda even_odd
        eor block_header
        sta even_odd

        ;,; lda even_odd
        and #$30
        beq not_predicted_from_ff
            lda #$ff
        not_predicted_from_ff:
            ; else A = 0x00

        asl plane_def
        bcc do_zero_plane
        ;,; bcs do_pb8_plane
    do_pb8_plane:
        ldy temp_y
        bit is_rotated
        bpl no_rewind_input_pointer
            ldy #$02
        no_rewind_input_pointer:
        tax
        lda (donut_stream_ptr), y
        iny
        sta pb8_ctrl
        txa

        ;,; bit is_rotated
    bvs do_rotated_pb8_plane
    ;,; bvc do_normal_pb8_plane
    do_normal_pb8_plane:
        ldx block_offset
        ;,; sec  ; C is set from 'asl plane_def' above
        rol pb8_ctrl
        pb8_loop:
            bcc pb8_use_prev
                lda (donut_stream_ptr), y
                iny
            pb8_use_prev:
            dex
            sta donut_output_buffer, x
            asl pb8_ctrl
        bne pb8_loop
        .assert >* = >pb8_loop, ldwarning, "pb8_loop in donut_decompress_block crosses page boundary - slow"
        sty temp_y
    ;,; beq end_plane  ;,; jmp end_plane
    end_plane:
        bit even_odd
        bpl not_xor_m_onto_l
        xor_m_onto_l:
            ldy #8
            xor_m_onto_l_loop:
                dex
                lda donut_output_buffer, x
                eor donut_output_buffer+8, x
                sta donut_output_buffer, x
                dey
            bne xor_m_onto_l_loop
            .assert >* = >xor_m_onto_l_loop, ldwarning, "xor_m_onto_l_loop in donut_decompress_block crosses page boundary - slow"
        not_xor_m_onto_l:

        bvc not_xor_l_onto_m
        xor_l_onto_m:
            ldy #8
            xor_l_onto_m_loop:
                dex
                lda donut_output_buffer, x
                eor donut_output_buffer+8, x
                sta donut_output_buffer+8, x
                dey
            bne xor_l_onto_m_loop
            .assert >* = >xor_l_onto_m_loop, ldwarning, "xor_l_onto_m_loop in donut_decompress_block crosses page boundary - slow"
        not_xor_l_onto_m:

        lda block_offset
        cmp block_offset_end
    bcc plane_loop
    ldy temp_y
    tax  ;,; ldx block_offset_end
    clc  ; to indicate success
    rts

do_zero_plane:
    ldx block_offset
    ldy #8
    fill_plane_loop:
        dex
        sta donut_output_buffer, x
        dey
    bne fill_plane_loop
    .assert >* = >fill_plane_loop, ldwarning, "fill_plane_loop in donut_decompress_block crosses page boundary - slow"
    beq end_plane  ;,; jmp end_plane

do_rotated_pb8_plane:
    ldx #8
    buffered_pb8_loop:
        asl pb8_ctrl
        bcc buffered_pb8_use_prev
            lda (donut_stream_ptr), y
            iny
        buffered_pb8_use_prev:
        dex
        sta plane_buffer, x
    bne buffered_pb8_loop
    .assert >* = >buffered_pb8_loop, ldwarning, "buffered_pb8_loop in donut_decompress_block crosses page boundary - slow"
    sty temp_y
    ldy #8
    ldx block_offset
    flip_bits_loop:
        asl plane_buffer+0
        ror
        asl plane_buffer+1
        ror
        asl plane_buffer+2
        ror
        asl plane_buffer+3
        ror
        asl plane_buffer+4
        ror
        asl plane_buffer+5
        ror
        asl plane_buffer+6
        ror
        asl plane_buffer+7
        ror
        dex
        sta donut_output_buffer, x
        dey
    bne flip_bits_loop
    .assert >* = >flip_bits_loop, ldwarning, "flip_bits_loop in donut_decompress_block crosses page boundary - slow"
    beq end_plane  ;,; jmp end_plane

shorthand_plane_def_table:
    .byte $00, $55, $aa, $ff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UploadCHR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UploadCHR:
    LDA VideoCursor
    BPL @noWait
    CALL WaitForVBlank
    @noWait:

    LDA #TextBank(LUT_TILE_CHR)
    CLC
    ADC Var1
    STA MMC5_PRG_BANK2
    LDX Var0
    LDA LUT_TILE_CHR,X
    STA donut_stream_ptr
    LDA LUT_TILE_CHR_SIBLING2,X
    STA donut_stream_ptr+1

    LDY #0
    LDX VideoCursor
    LDA #<(Video_Inc1_Address-1)
    STA VideoStack+0,X
    LDA #>(Video_Inc1_Address-1)
    STA VideoStack+1,X

    LDA Var2
    LSR A
    LSR A
    LSR A
    LSR A
    STA VideoStack+2,X

    LDA Var2
    ASL A
    ASL A
    ASL A
    ASL A
    STA VideoStack+3,X

    LDA #<(Video_MassWriteStack-1-(64*4))
    STA VideoStack+4,X
    LDA #>(Video_MassWriteStack-1-(64*4))
    STA VideoStack+5,X

    TXA
    CLC
    ADC #6
    TAX
    CLC
    ADC #64
    STA VideoCursor

    LDY #0
    CALL donut_decompress_block

    LDX VideoCursor
    LDA #$80
    STA VideoStack+0,X
    STA VideoStack+1,X
    RTS
