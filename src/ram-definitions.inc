.macro SECTION label
    .ifdef _DEFINE_MEMORY
        .segment label
    .endif
.endmacro

.macro SECTIONZP label
    .ifdef _DEFINE_MEMORY
        .segment label:zeropage
    .endif
.endmacro

.macro GAP size
    .ifdef _DEFINE_MEMORY
        .res size
    .endif
.endmacro

.macro RESZP label, size
    .globalzp .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro RES label, size
    .global .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro RES_ADDRESS label, size, requiredAddress
    .global .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .assert * = requiredAddress, warn, .concat("RES_ADDRESS '", .string(label) ,"' not reserving at specified address: ", .sprintf("$%04x", requiredAddress))
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro RES_PAGE label, size
    .global .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .assert <* = 0, warn, .concat("RES_PAGE '", .string(label) ,"' not aligned with page")
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro _ESZP label, size
    .ifdef _DEFINE_MEMORY
        .res size
    .endif
.endmacro

.macro _ES label, size
    .ifdef _DEFINE_MEMORY
        .res size
    .endif
.endmacro

.macro _ES_ADDRESS label, size, requiredAddress
    .ifdef _DEFINE_MEMORY
        .res size
    .endif
.endmacro

.macro _ES_PAGE label, size
    .ifdef _DEFINE_MEMORY
        .assert <* = 0, warn, .concat("RES_PAGE '", .string(label) ,"' not aligned with page")
        .res size
    .endif
.endmacro

SECTIONZP "ZEROPAGE" ; $00 - $FF
    RESZP story_dropinput,                  1 ; 1 bytes     ; $07
    RESZP inroom,                           1 ; 1 bytes     ; $0D bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
    RESZP doorppuaddr,                      2 ; 2 bytes     ; $0E 2 bytes, PPU address of door drawing work
    RESZP theend_selectedtile,              0 ; 1 bytes     ; $10
    RESZP tmp,                              0 ; 16 bytes    ; $10
    RESZP mu_scoreptr,                      2 ; 2 bytes     ; $18
    RESZP dlgbox_row,                       0 ; 1 bytes     ; $1B
    RESZP palcyc_mode,                      1 ; 1 bytes     ; $1B
    RESZP sprindex,                         1 ; 1 bytes     ; $26
    RESZP donut_temp,                       15  ; can be aliased to some shared temp memory
    RESZP donut_block_count,                1   ; temp memory only used in donut_bulk_load()
    RESZP donut_stream_ptr,                 2   ; persist between calls to donut_decompress_block
    RESZP scroll_y,                         1 ; 1 bytes     ; $2F  ; Y scroll in tiles (16x16).  range=0-E
    RESZP mapdraw_nty,                      1 ; 1 bytes     ; $30
    RESZP mapdraw_ntx,                      1 ; 1 bytes     ; $31
    RESZP mapdraw_job,                      1 ; 1 bytes     ; $32  ; 0=no job, 1=draw attribs, 2=draw tiles
    RESZP mg_slidedir,                      0 ; 1 bytes     ; $33  ; shared
    RESZP facing,                           1 ; 1 bytes     ; $33  ; 1=R  2=L  4=D  8=U
    RESZP move_speed,                       1 ; 1 bytes     ; $34  ; pixels to move per frame (map)
    RESZP move_ctr_x,                       1 ; 1 bytes     ; $35  ; pixels between tiles (map movement -- 00-0F)
    RESZP move_ctr_y,                       1 ; 1 bytes     ; $36  ; ditto but for Y axis
    RESZP menustall,                        1 ; 1 bytes     ; $37       ; see MenuCondStall in bank F for explanation
    RESZP box_x,                            0 ; 1 bytes     ; $38
    RESZP theend_x,                         1 ; 1 bytes     ; $38
    RESZP box_y,                            0 ; 1 bytes     ; $39
    RESZP theend_y,                         1 ; 1 bytes     ; $39
    RESZP dest_x,                           1 ; 1 bytes     ; $3A
    RESZP dest_y,                           1 ; 1 bytes     ; $3B
    RESZP box_wd,                           0 ; 1 bytes     ; $3C ; shared
    RESZP dest_wd,                          1 ; 1 bytes     ; $3C
    RESZP box_ht,                           0 ; 1 bytes     ; $3D ; shared
    RESZP dest_ht,                          1 ; 1 bytes     ; $3D
    RESZP theend_fillppu,                   0 ; 2 bytes     ; $3E ; ppu addr for filling
    RESZP image_ptr,                        0 ; 1 bytes     ; $3E ; shared
    GAP                                     2 ; 2 bytes     ; $3E ; 2 bytes
    RESZP spr_x,                            1 ; 1 bytes     ; $40
    RESZP mm_maprow,                        0 ; 1 bytes     ; $41 ; shared
    RESZP spr_y,                            1 ; 1 bytes     ; $41
    RESZP vehicle,                          1 ; 1 bytes     ; $42 ; 1=walking, 2=canoe, 4=ship, 8=airship
    RESZP inforest,                         1 ; 1 bytes     ; $43 ; nonzero if in forest
    RESZP tileprop,                         2 ; 2 bytes     ; $44 ; 2 bytes
    RESZP vehicle_next,                     1 ; 1 bytes     ; $46 ; vehicle we're walking onto
    RESZP vehchgpause,                      1 ; 1 bytes     ; $47 ; forced pause when changing vehicles
    RESZP cur_map,                          1 ; 1 bytes     ; $48
    RESZP cur_tileset,                      1 ; 1 bytes     ; $49
    RESZP cur_mapobj,                       1 ; 1 bytes     ; $4A ; counter for updating which map object
    RESZP music_track,                      1 ; 1 bytes     ; $4B
    RESZP mu_chanprimer,                    1 ; 1 bytes     ; $4C
    RESZP mu_chan,                          1 ; 1 bytes     ; $4D
    GAP                                     2
    RESZP entering_shop,                    1 ; 1 bytes     ; $50 ; nonzero = about to enter shop
    RESZP shop_id,                          1 ; 1 bytes     ; $51
    RESZP tileprop_now,                     1 ; 1 bytes     ; $52 ; special tile properties that we're on (tileprop isn't necessarily what we're standing on)
    RESZP ow_tile,                          1 ; 1 bytes     ; $53
    RESZP ppu_dest,                         2 ; 2 bytes     ; $54  ; 2 bytes
    RESZP dlgflg_reentermap,                1 ; 1 bytes     ; $56  ; flag to indicate the map needs re-entering due to dialogue (Bahamut/class change)
    RESZP cur_bank,                         1 ; 1 bytes     ; $57
    RESZP ret_bank,                         1 ; 1 bytes     ; $58
    RESZP format_buf,                       0 ; 7 bytes     ; $49  ; 7 bytes (5A-60) -- must not cross page bound
    RESZP name_input_draw_buf,              1 ; 1 bytes     ; $5C
    RESZP theend_ppuaddr,                   0 ; 2 bytes     ; $61
    RESZP shutter_a,                        0 ; 1 bytes     ; $61  ; shared
    RESZP lu_cursor,                        0 ; 1 bytes     ; $61  ; shared
    RESZP mm_bplo,                          0 ; 1 bytes     ; $61  ; shared
    RESZP dlg_itemid,                       0 ; 1 bytes     ; $61  ; shared
    RESZP equipmenu_tmp,                    0 ; 1 bytes     ; $61  ; shared
    RESZP joy_prevdir,                      1 ; 1 bytes     ; $61
    RESZP shutter_b,                        0 ; 1 bytes     ; $62  ; shared
    RESZP lu_cursor2,                       0 ; 1 bytes     ; $62  ; shared
    RESZP mm_bphi,                          0 ; 1 bytes     ; $62  ; shared
    RESZP intro_ataddr,                     0 ; 1 bytes     ; $62  ; shared
    RESZP cursor,                           0 ; 1 bytes     ; $62
    RESZP theend_src,                       1 ; 1 bytes     ; $62
    RESZP nameinput_cursoradd,              0 ; 1 bytes
    RESZP theend_drawtile,                  0 ; 1 bytes     ; $63  ; shared
    RESZP lu_mode,                          0 ; 1 bytes     ; $63  ; shared
    RESZP intro_atbyte,                     0 ; 1 bytes     ; $63  ; shared
    RESZP cursor_max,                       0 ; 1 bytes     ; $63
    RESZP cursor2,                          1 ; 1 bytes     ; $63  ; shared (secondary cursor)
    RESZP theend_fillx,                     0 ; 1 bytes     ; $64
    RESZP theend_loopctr,                   0 ; 1 bytes     ; $64  ; shared
    RESZP lu_joyprev,                       0 ; 1 bytes     ; $64  ; shared
    RESZP intro_color,                      0 ; 1 bytes     ; $64  ; shared
    RESZP mg_slidespr,                      0 ; 3 bytes     ; $64  ; shared, 3 bytes
    RESZP namecurs_x,                       0 ; 1 bytes     ; $64
    RESZP shopcurs_x,                       0 ; 1 bytes     ; $64  ; shared
    RESZP eq_modecurs,                      0 ; 1 bytes     ; $64  ; shared
    RESZP hp_recovery,                      0 ; 1 bytes     ; $64
    RESZP minimap_ptr,                      1 ; 2 bytes     ; $64  ; shared, 2 bytes
    RESZP theend_filly,                     0 ; 1 bytes     ; $65
    RESZP mp_required,                      0 ; 1 bytes     ; $65
    RESZP namecurs_y,                       0 ; 1 bytes     ; $65
    RESZP shopcurs_y,                       0 ; 1 bytes     ; $65  ; shared
    RESZP story_credits,                    1 ; 1 bytes     ; $65  ; shared
    RESZP theend_ramaddr,                   0 ; 2 bytes     ; $66
    RESZP theend_bufaddr,                   0 ; 2 bytes     ; $66
    RESZP submenu_targ,                     0 ; 1 bytes     ; $66  ; shared with shop_type
    RESZP shop_type,                        0 ; 1 bytes     ; $66
    RESZP story_page,                       0 ; 1 bytes     ; $66  ; shared
    RESZP equipoffset,                      1 ; 1 bytes     ; $66  ; MUST be shared with shop_type
    RESZP story_timer,                      0 ; 1 bytes     ; $67  ; shared
    RESZP draweq_stradd,                    0 ; 1 bytes     ; $67  ; shared
    RESZP char_index,                       0 ; 1 bytes     ; $67
    RESZP mm_pixrow,                        0 ; 1 bytes     ; $67  ; shared
    RESZP talkobj,                          1 ; 1 bytes     ; $67  ; shared -- object you're talking to on SM
    RESZP sm_player_x,                      1 ; 1 bytes     ; $68  ; player X/Y position on standard map.  Only used for NPC collision detection
    RESZP sm_player_y,                      1 ; 1 bytes     ; $69
    RESZP enCHRpage,                        1 ; 1 bytes     ; $6B
    RESZP trampoline_low,                   1
    RESZP trampoline_high,                  1
    RESZP current_bank1,                    1
    RESZP dlgmusic_backup,                  1 ; 1 bytes     ; $7C  ; backup music track for restoring music after the dialogue box changes it
    RESZP dlgsfx,                           1 ; 1 bytes     ; $7D  ; flag to indicate to play a sound effect after opening dialogue box.  0=no sfx, 1=fanfare, else=treasure
    RESZP sq2_sfx,                          1 ; 1 bytes     ; $7E
    RESZP descboxopen,                      1 ; 1 bytes     ; $7F
    RESZP levelup_lvlupptr,                 0 ; 2 bytes     ; $82       ; local, pointer to level up data
    RESZP lvlup_exptoadv,                   0 ; 2 bytes     ; $82       ; 2 byte pointer to EXP needed to advance
    RESZP lvlup_chmagic,                    0 ; 2 bytes     ; $84       ; 2 byte pointer to character's magic data
    RESZP divisor,                          1 ; 1 bytes     ; $84
    RESZP remainder,                        1 ; 1 bytes     ; $85
    RESZP lvlup_chstats,                    0 ; 2 bytes     ; $86       ; 2 byte pointer to character's OB stats
    RESZP temporary_3,                      0 ; 1 bytes     ; $88
    RESZP battleturn_playerid,              0 ; 1 bytes     ; $88
    RESZP regen_ramstats,                   0 ; 2 bytes     ; $88   ; 2 bytes
    RESZP battlereward,                     0 ; 3 bytes     ; $88       ; 3 bytes.  Note that while this var is 3 bytes, this stop behaving properly if rewards ever exceed the 2-byte boundary, since the game assumes you will never receive more than 65535 XP/GP in any one battle.
    
    RESZP Var0,                             1
    RESZP Var1,                             1
    RESZP Var2,                             1
    RESZP Var3,                             1
    RESZP Var4,                             1
    RESZP Var5,                             1
    RESZP Var6,                             1
    RESZP Var7,                             1
    RESZP Var8,                             1
    RESZP Var9,                             1
    RESZP Var10,                            1
    RESZP Var11,                            1
    RESZP Var12,                            1
    RESZP Var13,                            1
    RESZP Var14,                            1
    RESZP Var15,                            1
    RESZP Var16,                            1
    RESZP Var17,                            1
    RESZP Var18,                            1
    RESZP Var19,                            1
    RESZP Var20,                            1
    RESZP Var21,                            1
    RESZP Var22,                            1
    RESZP Var23,                            1
    RESZP Var24,                            1
    RESZP Var25,                            1
    RESZP Var26,                            1
    RESZP Var27,                            1
    RESZP Var28,                            1
    RESZP Var29,                            1
    RESZP Var38,                            1
    RESZP Var39,                            1
    RESZP Var73,                            1
    RESZP Var74,                            1
    RESZP Var75,                            1
    RESZP Var76,                            1
    RESZP Var77,                            1
    RESZP Var78,                            1
    RESZP Var79,                            1
    RESZP Var80,                            1
    RESZP MassiveImageBuffer,               126

SECTION "STACK"
    RES             VideoStack,                   200

SECTION "OAM"
    ; Sprite memory is laid out in four bytes:
    ; Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
    ; Byte 1 - Index number of the sprite in the pattern tables.
    ; Byte 2 - Stores the attributes of the sprite.
    ; * Bits 0-1 - Most significant two bits of the colour.
    ; * Bit 5 - Indicates whether this sprite has priority over the background.
    ; * Bit 6 - Indicates whether to flip the sprite horizontally.
    ; * Bit 7 - Indicates whether to flip the sprite vertically.
    ; Byte 3 - X coordinate
    RES             spriteRAM,                          256

    oam             = $0200  ; 256 bytes -- must be on page bound
    oam_y           = oam
    oam_t           = oam+1
    oam_a           = oam+2
    oam_x           = oam+3

SECTION "BSS" ; $0300 - $0800
    RES             item_box,                           0 ; 32 bytes        ; $0300 $20? bytes -- shares space with str_buf
    RES             str_buf,                            0 ; 57 bytes        ; $0300 $39 bytes at least -- buffer must not cross page
    RES             shop_charindex,                     1 ; 1 bytes         ; $030A
    RES             shop_spell,                         1 ; 1 bytes         ; $030B
    RES             shop_curitem,                       1 ; 1 bytes         ; $030C
    RES             shop_curprice,                      2 ; 2 bytes         ; $030E
    RES             decompressCommandBitWidth,          1
    RES             decompressCommandRoutinesLo,        16
    RES             decompressCommandRoutinesHi,        16
    RES             cur_pal,                            32  ; 32 bytes      ; $03C0  ; 32 bytes
    RES             inroom_pal,                         16  ; 16 bytes      ; $03E0  ; cur_pal+$20 ; 16 bytes
    RES             tmp_pal,                            16  ; 16 bytes      ; $03F0  ; 16 bytes
    RES             draw_buf_ul,                        16  ; $0780
    RES             draw_buf_ur,                        16  ; $0790
    RES             draw_buf_dl,                        16  ; $07A0
    RES             draw_buf_dr,                        16  ; $07B0
    RES             draw_buf_attr,                      16  ; $07C0
    RES             draw_buf_at_hi,                     16  ; $07D0
    RES             draw_buf_at_lo,                     16  ; $07E0
    RES             draw_buf_at_msk,                    16  ; $07F0

    RES             vBlankCounter,                  1
    RES             VideoCursor,                    1
    RES             VideoStackTally,                1
    RES             VideoIncrementAddressOffset,    1
    RES             VideoIncrementCost,             1
    RES             VideoCost,                      2
    RES             StackPointerBackup,             1
    RES             VideoRetroactiveCursor,         1
    RES             vBlankAnticipated,              1
    RES             stringwriterWhitespaceWidth,    1
    RES             stringwriterLineWidth,          1
    RES             stringifyCursor,                1
    RES             stringifyLength,                1
    RES             stringifyActiveItem,            2
    RES             stringwriterAddressReady,       1
    RES             stringwriterNewlineOrigin,      1
    RES             stringwriterSetHero,            1
    RES             stringwriterTargetSize,         1
    RES             stringwriterDigitLength,        2
    RES             stringwriterDigitSize,          2
    RES             stringwriterBinary,             3
    RES             stringwriterDecimal,            6
    RES             stringwriterStackIndex,         1
    RES             stringwriterStackCursor,        16
    RES             stringwriterStackLo,            16
    RES             stringwriterStackHi,            16
    RES             stringwriterStackBank,          16
    RES             yxa2decOutput,                  9

    RES             backgroundCHRBank0,             1
    RES             backgroundCHRBank1,             1
    RES             backgroundCHRBank2,             1
    RES             backgroundCHRBank3,             1
    RES             spriteCHRBank0,                 1
    RES             spriteCHRBank1,                 1
    RES             spriteCHRBank2,                 1
    RES             spriteCHRBank3,                 1
    RES             spriteCHRBank4,                 1
    RES             spriteCHRBank5,                 1
    RES             spriteCHRBank6,                 1
    RES             spriteCHRBank7,                 1

SECTION "PRG_RAM" ; $6000 - $6D00
    RES             unsram,                             0 ; $6000   ; $400 bytes
    RES             ship_vis,                           1 ; $6000
    RES             ship_x,                             1 ; $6001
    RES             ship_y,                             1 ; $6002
    GAP                                                 1
    RES             airship_vis,                        1 ; $6004
    RES             airship_x,                          1 ; $6005
    RES             airship_y,                          1 ; $6006
    GAP                                                 1
    RES             bridge_vis,                         1 ; $6008
    RES             bridge_x,                           1 ; $6009
    RES             bridge_y,                           1 ; $600A
    GAP                                                 1
    RES             canal_vis,                          1 ; $600C
    RES             canal_x,                            1 ; $600D
    RES             canal_y,                            1 ; $600E
    GAP                                                 1
    RES             unsram_ow_scroll_x,                 1 ; $6010
    RES             unsram_ow_scroll_y,                 1 ; $6011
    RES             has_canoe,                          1 ; $6012   ; (not to be confused with item_canoe)
    GAP                                                 1
    RES             unsram_vehicle,                     1 ; $6014
    GAP                                                 1
    RES             bridgescene,                        1 ; $6016   ; 00=hasn't happened yet. 01=happens when move is complete, 80=already has happened
    GAP                                                 5
    RES             gold,                               3 ; $601C   ; 3 bytes
    GAP                                                 1
    RES             items,                              1 ;
    RES             item_lute,                          1 ; $6020
    RES             item_crown,                         1 ; $6020
    RES             item_crystal,                       1 ; $6021
    RES             item_herb,                          1 ; $6022
    RES             item_mystickey,                     1 ; $6023
    RES             item_tnt,                           1 ; $6024
    RES             item_adamant,                       1 ; $6025
    RES             item_slab,                          1 ; $6026
    RES             item_ruby,                          1 ; $6027
    RES             item_rod,                           1 ; $6028
    RES             item_floater,                       1 ; $6029
    RES             item_chime,                         1 ; $602A
    RES             item_tail,                          1 ; $602B
    RES             item_cube,                          1 ; $602C
    RES             item_bottle,                        1 ; $602D
    RES             item_oxyale,                        1 ; $602E
    RES             item_canoe,                         1 ; $602F
    RES             item_orb_start,                     0 ; $6030
    RES             orb_fire,                           1 ; $6031
    RES             orb_water,                          1 ; $6032
    RES             orb_air,                            1 ; $6032
    RES             orb_earth,                          1 ; $6033
    RES             item_qty_start,                     0 ; $6034
    RES             item_tent,                          1 ; $6035
    RES             item_cabin,                         1 ; $6036
    RES             item_house,                         1 ; $6036
    RES             item_heal,                          1 ; $6037
    RES             item_pure,                          1 ; $6038
    RES             item_soft,                          1 ; $6039
    RES             item_stop,                          1 ; $603A
    GAP                                                 195
    RES_PAGE        ch_stats,                           0 ; $6100  ; MUST be on page bound.  Each character allowed $40 bytes, so use 00,40,80,C0 to index ch_stats
    RES             ch_class,                           1 ; ch_stats + $00
    RES             ch_ailments,                        1 ; ch_stats + $01
    RES             ch_name,                            4 ; ch_stats + $02  ; 4 bytes
    RES             ch_exp,                             3 ; ch_stats + $07  ; 3 bytes
    RES             ch_curhp,                           2 ; ch_stats + $0A  ; 2 bytes
    RES             ch_maxhp,                           2 ; ch_stats + $0C  ; 2 bytes
    GAP                                                 3
    RES             ch_str,                             1 ; ch_stats + $10
    RES             ch_agil,                            1 ; ch_stats + $11
    RES             ch_int,                             1 ; ch_stats + $12
    RES             ch_vit,                             1 ; ch_stats + $13
    RES             ch_luck,                            1 ; ch_stats + $14
    GAP                                                 1
    RES             ch_exptonext,                       2 ; ch_stats + $16  ; 2 bytes -- only for user display, not actually used.
    RES             ch_weapons,                         4 ; ch_stats + $18
    RES             ch_armor,                           4 ; ch_weapons + 4
    RES             ch_substats,                        0 ; ch_stats + $20
    RES             ch_dmg,                             1 ; ch_substats + $00
    RES             ch_hitrate,                         1 ; ch_substats + $01
    RES             ch_absorb,                          1 ; ch_substats + $02
    RES             ch_evade,                           1 ; ch_substats + $03
    RES             ch_resist,                          1 ; ch_substats + $04
    RES             ch_magdef,                          1 ; ch_substats + $05
    RES             ch_level,                           1 ; ch_stats + $26        ; OB this is 0 based, IB this is 1 based
    GAP                                                 25
    RES             ch1_class,                          1
    RES             ch1_ailments,                       1
    RES             ch1_name,                           4
    RES             ch1_exp,                            3
    RES             ch1_curhp,                          2
    RES             ch1_maxhp,                          2
    GAP                                                 3
    RES             ch1_str,                            1
    RES             ch1_agil,                           1
    RES             ch1_int,                            1
    RES             ch1_vit,                            1
    RES             ch1_luck,                           1
    GAP                                                 1
    RES             ch1_exptonext,                      2
    RES             ch1_weapons,                        4
    RES             ch1_armor,                          4
    RES             ch1_substats,                       0
    RES             ch1_dmg,                            1
    RES             ch1_hitrate,                        1
    RES             ch1_absorb,                         1
    RES             ch1_evade,                          1
    RES             ch1_resist,                         1
    RES             ch1_magdef,                         1
    RES             ch1_level,                          1
    GAP                                                 25
    RES             ch2_class,                          1
    RES             ch2_ailments,                       1
    RES             ch2_name,                           4
    RES             ch2_exp,                            3
    RES             ch2_curhp,                          2
    RES             ch2_maxhp,                          2
    GAP                                                 3
    RES             ch2_str,                            1
    RES             ch2_agil,                           1
    RES             ch2_int,                            1
    RES             ch2_vit,                            1
    RES             ch2_luck,                           1
    GAP                                                 1
    RES             ch2_exptonext,                      2
    RES             ch2_weapons,                        4
    RES             ch2_armor,                          4
    RES             ch2_substats,                       0
    RES             ch2_dmg,                            1
    RES             ch2_hitrate,                        1
    RES             ch2_absorb,                         1
    RES             ch2_evade,                          1
    RES             ch2_resist,                         1
    RES             ch2_magdef,                         1
    RES             ch2_level,                          1
    GAP                                                 25
    RES             ch3_class,                          1
    RES             ch3_ailments,                       1
    RES             ch3_name,                           4
    RES             ch3_exp,                            3
    RES             ch3_curhp,                          2
    RES             ch3_maxhp,                          2
    GAP                                                 3
    RES             ch3_str,                            1
    RES             ch3_agil,                           1
    RES             ch3_int,                            1
    RES             ch3_vit,                            1
    RES             ch3_luck,                           1
    GAP                                                 1
    RES             ch3_exptonext,                      2
    RES             ch3_weapons,                        4
    RES             ch3_armor,                          4
    RES             ch3_substats,                       0
    RES             ch3_dmg,                            1
    RES             ch3_hitrate,                        1
    RES             ch3_absorb,                         1
    RES             ch3_evade,                          1
    RES             ch3_resist,                         1
    RES             ch3_magdef,                         1
    RES             ch3_level,                          1
    GAP                                                 25
    RES_PAGE        game_flags,                         256 ; $6200  ; must be on page bound
    ; Out of battle, spell data is stored stupidly so valid values are only 00-08, where 01 to 08 are actual spells
    ;   and 00 is 'empty'.  Each spell is conceptually in a "slot" that belongs to each spell level.  Therefore,
    ;   both CURE and LAMP are stored as '01' because they're both the first spell in their level, but because
    ;   they're in a different level slot, the game distinguishes them.
    ; In battle, fortunately, that is thrown out the window (why does it do it at all?) and the spells are stored
    ;   in a logical 1-based index where the level simply doesn't matter.
    RES_PAGE        ch_magicdata,                       0 ; $6300  ; must be on page bound
    RES             ch0_spells,                         32
    RES             ch0_mp,                             0
    RES             ch0_curmp,                          8
    RES             ch0_maxmp,                          8
    GAP                                                 16
    RES             ch1_spells,                         32
    RES             ch1_mp,                             0
    RES             ch1_curmp,                          8
    RES             ch1_maxmp,                          8
    GAP                                                 16
    RES             ch2_spells,                         32
    RES             ch2_mp,                             0
    RES             ch2_curmp,                          8
    RES             ch2_maxmp,                          8
    GAP                                                 16
    RES             ch3_spells,                         32
    RES             ch3_mp,                             0
    RES             ch3_curmp,                          8
    RES             ch3_maxmp,                          8
    GAP                                                 16
    RES             sram,                               1024 ; $6400
    GAP                                                 1024
    RES             bigstr_buf,                         0 ; $6C00   ; $81 bytes?
    RES             lutmp_ch_stats,                     256 ; $6C00 ; temporary space used by the lineup menu
    RES             lutmp_ch_magic,                     1 ; $6D00
    RES             attributeTable,                     64
    RES             inventory,                          100
    RES             donut_output_buffer,                64
    RES             heroLevel,                          1*4
    RES             heroHP,                             2*4
    RES             heroMaxHP,                          2*4
    RES             heroName0,                          5
    RES             heroName1,                          5
    RES             heroName2,                          5
    RES             heroName3,                          5
    RES             heroSpellCharges,                   8*4
    RES             heroMaxSpellCharges,                8*4
    RES             hero0Inventory,                     10
    RES             hero1Inventory,                     10
    RES             hero2Inventory,                     10
    RES             hero3Inventory,                     10
    RES             hero0InventorySize,                 1
    RES             hero1InventorySize,                 1
    RES             hero2InventorySize,                 1
    RES             hero3InventorySize,                 1
    RES             hero0InventoryStatus,               10
    RES             hero1InventoryStatus,               10
    RES             hero2InventoryStatus,               10
    RES             hero3InventoryStatus,               10
    RES             mapobj,                             0 ; $6F00   ; $100 bytes -- page
    RES             mapobj_id,                          1 ; $6F00  ; rearranging these is ill advised
    RES             mapobj_flgs,                        1 ; $6F01  ;  because the loader is pretty rigid
    RES             mapobj_physX,                       1 ; $6F02  ;  flags:  $80=inroom $40=don't move
    RES             mapobj_physY,                       1 ; $6F03
    RES             mapobj_gfxX,                        1 ; $6F04
    RES             mapobj_gfxY,                        1 ; $6F05
    RES             mapobj_ctrX,                        1 ; $6F06
    RES             mapobj_ctrY,                        1 ; $6F07
    RES             mapobj_spdX,                        1 ; $6F08
    RES             mapobj_spdY,                        1 ; $6F09
    RES             mapobj_rawid,                       1 ; $6F0A
    RES             mapobj_movectr,                     1 ; $6F0B
    RES             mapobj_face,                        1 ; $6F0C
    RES             mapobj_pl,                          1 ; $6F0D   ; bit 7 = talking to player (changes facing), other bits = being shoved by player
    RES             mapobj_tsaptr,                      1 ; $6F0E
    RES             scrollX,                        1
    RES             scrollY,                        1
    RES             far_depth,                      1
    RES             safecall_reg_a,                 1
    RES             safecall_reg_y,                 1
    RES             safecall_reg_flags,             1
    RES             rng_seed,                       2
    RES             framecounter,                   2
    RES             npcdir_seed,                    1 ; RNG seed for determining direction for NPCs to walk
    RES             battlestep,                     1
    RES             battlestep_sign,                1
    RES             battlecounter,                  1
    RES             battlerate,                     1 ; X/256 chance of a random encounter occuring (SM only apparently)
    RES             startintrocheck,                1
    RES             respondrate,                    1
    RES             NTsoft2000,                     1 ; same as soft2000, but used to track coarse NT scroll
    RES             soft2000,                       1

    RES             joy,                            1
    RES             joy_ignore,                     1
    RES             joy_select,                     1
    RES             joy_start,                      1
    RES             joy_a,                          1
    RES             joy_b,                          1
    RES             ow_scroll_x,                    1
    RES             ow_scroll_y,                    1
    RES             sm_scroll_x,                    1
    RES             sm_scroll_y,                    1
    RES             mapdraw_x,                      1
    RES             mapdraw_y,                      1
    RES             mapflags,                       1
    RES             joypadState,                    1
    RES             joypadStateIgnore,              1
    RES             spriteRAMCursor,                1
    RES             generalCounter,                 1
    RES             joypadPreviousFrame,            1
    RES             joypadPreviousState,            1
    RES             joypadBuildup,                  1
    RES             donut_stream_bank,              1
    RES             tmp_hi,                         3  ; 3? bytes
    RES             fillColor,                      1
    RES             palette0,                       3
    RES             palette1,                       3
    RES             palette2,                       3
    RES             palette3,                       3
    RES             palette4,                       3
    RES             palette5,                       3
    RES             palette6,                       3
    RES             palette7,                       3
    RES             btl_msgdraw_srcptr_bank,        1
    RES             btlformation,                   1
    RES             actual_bank,                    1
    RES             slotIndex,                      1
    RES             partyGenerationClass,           4


    RES             interactiveMenuXCoordinate,     1
    RES             interactiveMenuYCoordinate,     1
    RES             interactiveMenuCursor,          1

    RES             interactiveMenuLength,          1
    RES             interactiveMenuMode,            1
    RES             interactiveMenuCursorSelected,  1
    RES             interactiveMenuListOffset,      1
    RES             interactiveMenuLoop,            1
    RES             interactiveMenuOutcome,         1
    RES             interactiveMenuActiveHero,      1

    RES             gridMenuXPosition,              1
    RES             gridMenuYPosition,              1
    RES             gridMenuItemWidth,              1
    RES             gridMenuItemHeight,             1
    RES             gridMenuXCursor,                1
    RES             gridMenuYCursor,                1
    RES             gridMenuXLength,                1
    RES             gridMenuYLength,                1
    RES             gridMenuOutcome,                1
    
    RES             drawValue,                      1
    ; drawX and drawY are used to determine the position to draw the sprite
    RES             drawX,                          1
    RES             drawY,                          1
    ; drawWidth and drawHeight are used to determine how many sprites to draw W * H
    RES             drawWidth,                      1
    RES             drawHeight,                     1
    ; drawVars is used to store the values to draw the sprite
    RES             drawVars,                       0
    RES             drawFlip,                       1
    RES             drawCHR,                        1
    RES             drawVars3,                      1
    RES             drawVars4,                      1
    RES             drawVars5,                      1
    RES             drawVars6,                      1
    RES             drawVars7,                      1
    RES             drawVars8,                      1
    RES             drawVars9,                      1
    RES             drawVars10,                     1
    RES             drawVars11,                     1
    RES             drawVars12,                     1
    RES             drawVars13,                     1
    RES             drawVars14,                     1
    RES             drawVars15,                     1
    RES             drawVars16,                     1

SECTION "DECOMPRESS" ; $6000 - $7FFF
    RES imageBuffer,   8192