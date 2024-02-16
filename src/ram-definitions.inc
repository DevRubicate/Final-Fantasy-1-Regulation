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





SECTIONZP "ZEROPAGE"
    GAP                                     7
    RESZP story_dropinput,                  1 ; 1 bytes   ; $07
    GAP                                     5
    RESZP inroom,                           1 ; 1 bytes   ; $0D bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
    RESZP doorppuaddr,                      2 ; 2 bytes   ; $0E 2 bytes, PPU address of door drawing work
    RESZP tmp,                              0 ; 16 bytes  ; $10
    GAP                                     8
    RESZP mu_scoreptr,                      2 ; 2 bytes   ; $18
    GAP                                     1
    RESZP dlgbox_row,                       0 ; 1 bytes   ; $1B
    RESZP palcyc_mode,                      1 ; 1 bytes   ; $1B
    GAP                                     4
    RESZP joy,                              1 ; 1 bytes      ; $20
    RESZP joy_ignore,                       1 ; 1 bytes      ; $21
    RESZP joy_select,                       1 ; 1 bytes      ; $22
    RESZP joy_start,                        1 ; 1 bytes      ; $23
    RESZP joy_a,                            1 ; 1 bytes      ; $24
    RESZP joy_b,                            1 ; 1 bytes      ; $25
    RESZP sprindex,                         1 ; 1 bytes      ; $26
    RESZP ow_scroll_x,                      1 ; 1 bytes      ; $27  ; X scroll of OW in tiles
    RESZP ow_scroll_y,                      1 ; 1 bytes      ; $28  ; Y scroll in tiles
    RESZP sm_scroll_x,                      1 ; 1 bytes      ; $29  ; ditto, but for standard maps
    RESZP sm_scroll_y,                      1 ; 1 bytes      ; $2A
    RESZP mapdraw_x,                        1 ; 1 bytes      ; $2B
    RESZP mapdraw_y,                        1 ; 1 bytes      ; $2C
    RESZP mapflags,                         1 ; 1 bytes      ; $2D  ; bit 0 set when in standard map.  bit 1 set to indicate column drawing instead of row drawing
    GAP                                     1
    RESZP scroll_y,                         1 ; 1 bytes      ; $2F  ; Y scroll in tiles (16x16).  range=0-E
    RESZP mapdraw_nty,                      1 ; 1 bytes      ; $30
    RESZP mapdraw_ntx,                      1 ; 1 bytes      ; $31
    RESZP mapdraw_job,                      1 ; 1 bytes      ; $32  ; 0=no job, 1=draw attribs, 2=draw tiles
    RESZP mg_slidedir,                      0 ; 1 bytes      ; $33  ; shared
    RESZP facing,                           1 ; 1 bytes      ; $33  ; 1=R  2=L  4=D  8=U
    RESZP move_speed,                       1 ; 1 bytes      ; $34  ; pixels to move per frame (map)
    RESZP move_ctr_x,                       1 ; 1 bytes      ; $35  ; pixels between tiles (map movement -- 00-0F)
    RESZP move_ctr_y,                       1 ; 1 bytes      ; $36  ; ditto but for Y axis
    RESZP menustall,                        1 ; 1 bytes      ; $37       ; see MenuCondStall in bank F for explanation
    RESZP box_x,                            0 ; 1 bytes      ; $38
    RESZP theend_x,                         1 ; 1 bytes      ; $38
    RESZP box_y,                            0 ; 1 bytes      ; $39
    RESZP theend_y,                         1 ; 1 bytes      ; $39
    RESZP dest_x,                           1 ; 1 bytes      ; $3A
    RESZP dest_y,                           1 ; 1 bytes      ; $3B
    RESZP box_wd,                           0 ; 1 bytes      ; $3C ; shared
    RESZP dest_wd,                          1 ; 1 bytes      ; $3C
    RESZP box_ht,                           0 ; 1 bytes      ; $3D ; shared
    RESZP dest_ht,                          1 ; 1 bytes      ; $3D
    RESZP image_ptr,                        0 ; 1 bytes      ; $3E ; shared
    RESZP text_ptr,                         2 ; 2 bytes      ; $3E ; 2 bytes
    RESZP spr_x,                            1 ; 1 bytes      ; $40
    RESZP mm_maprow,                        0 ; 1 bytes      ; $41 ; shared
    RESZP spr_y,                            1 ; 1 bytes      ; $41
    RESZP vehicle,                          1 ; 1 bytes      ; $42 ;1=walking, 2=canoe, 4=ship, 8=airship
    RESZP inforest,                         1 ; 1 bytes      ; $43 ; nonzero if in forest
    RESZP tileprop,                         2 ; 2 bytes      ; $44 ; 2 bytes
    RESZP vehicle_next,                     1 ; 1 bytes      ; $46 ; vehicle we're walking onto
    RESZP vehchgpause,                      1 ; 1 bytes      ; $47 ; forced pause when changing vehicles
    RESZP cur_map,                          1 ; 1 bytes      ; $48
    RESZP cur_tileset,                      1 ; 1 bytes      ; $49
    RESZP cur_mapobj,                       1 ; 1 bytes      ; $4A ; counter for updating which map object
    RESZP music_track,                      1 ; 1 bytes      ; $4B
    RESZP mu_chanprimer,                    1 ; 1 bytes      ; $4C
    RESZP mu_chan,                          1 ; 1 bytes      ; $4D
    GAP                                     2
    RESZP entering_shop,                    1 ; 1 bytes      ; $50 ; nonzero = about to enter shop
    RESZP shop_id,                          1 ; 1 bytes      ; $51
    RESZP tileprop_now,                     1 ; 1 bytes      ; $52 ; special tile properties that we're on (tileprop isn't necessarily what we're standing on)
    RESZP ow_tile,                          1 ; 1 bytes      ; $53
    RESZP ppu_dest,                         2 ; 2 bytes      ; $54  ; 2 bytes
    RESZP dlgflg_reentermap,                1 ; 1 bytes      ; $56  ; flag to indicate the map needs re-entering due to dialogue (Bahamut/class change)
    RESZP cur_bank,                         1 ; 1 bytes      ; $57
    RESZP ret_bank,                         1 ; 1 bytes      ; $58
    GAP                                     3
    RESZP name_input_draw_buf,              1 ; 1 bytes      ; $5C
    GAP                                     3
    RESZP format_buf,                       1 ; 7 bytes     ; $60  ; 7 bytes (5A-60) -- must not cross page bound
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
    RESZP lu_mode,                          0 ; 1 bytes     ; $63  ; shared
    RESZP intro_atbyte,                     0 ; 1 bytes     ; $63  ; shared
    RESZP cursor_max,                       0 ; 1 bytes     ; $63
    RESZP cursor2,                          1 ; 1 bytes     ; $63  ; shared (secondary cursor)
    RESZP lu_joyprev,                       0 ; 1 bytes     ; $64  ; shared
    RESZP intro_color,                      0 ; 1 bytes     ; $64  ; shared
    RESZP mg_slidespr,                      0 ; 3 bytes     ; $64  ; shared, 3 bytes
    RESZP namecurs_x,                       0 ; 1 bytes     ; $64
    RESZP shopcurs_x,                       0 ; 1 bytes     ; $64  ; shared
    RESZP eq_modecurs,                      0 ; 1 bytes     ; $64  ; shared
    RESZP hp_recovery,                      0 ; 1 bytes     ; $64
    RESZP minimap_ptr,                      1 ; 2 bytes     ; $64  ; shared, 2 bytes
    RESZP mp_required,                      0 ; 1 bytes     ; $65
    RESZP namecurs_y,                       0 ; 1 bytes     ; $65
    RESZP shopcurs_y,                       0 ; 1 bytes     ; $65  ; shared
    RESZP story_credits,                    1 ; 1 bytes     ; $65  ; shared
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
    GAP                                     1
    RESZP enCHRpage,                        1 ; 1 bytes     ; $6B
    RESZP altareffect,                      1 ; 1 bytes     ; $6C  ; flag to indicate altar effect is to occur (screen shaking, monochrome diagonal window thing)
    GAP                                     15
    RESZP dlgmusic_backup,                  1 ; 1 bytes      ; $7C  ; backup music track for restoring music after the dialogue box changes it
    RESZP dlgsfx,                           1 ; 1 bytes      ; $7D  ; flag to indicate to play a sound effect after opening dialogue box.  0=no sfx, 1=fanfare, else=treasure
    RESZP sq2_sfx,                          1 ; 1 bytes      ; $7E
    RESZP descboxopen,                      1 ; 1 bytes      ; $7F
    RESZP lvlup_curexp,                     2 ; 2 bytes      ; $80       ; 2 byte pointer to character's current EXP
    RESZP levelup_lvlupptr,                 0 ; 2 bytes      ; $82       ; local, pointer to level up data
    RESZP lvlup_exptoadv,                   2 ; 2 bytes      ; $82       ; 2 byte pointer to EXP needed to advance
    RESZP lvlup_chmagic,                    2 ; 2 bytes      ; $84       ; 2 byte pointer to character's magic data
    RESZP lvlup_chstats,                    2 ; 2 bytes      ; $86       ; 2 byte pointer to character's OB stats
    RESZP battlereward,                     0 ; 3 bytes      ; $88       ; 3 bytes.  Note that while this var is 3 bytes, this stop behaving properly if rewards ever exceed the 2-byte boundary, since the game assumes you will never receive more than 65535 XP/GP in any one battle.
    GAP                                     2
    RESZP outerloopctr_alignmentsor,        1 ; 1 bytes      ; $8A
    RESZP loopctr_alignmentsort,            1 ; 1 bytes      ; $8B
    GAP                                     21
    RESZP actual_bank,                      1 ; 1 bytes      ; $A1
    GAP                                     78
    RESZP framecounter,                     2 ; 2 bytes      ; $F0
    GAP                                     2
    RESZP npcdir_seed,                      1 ; 1 bytes      ; $F4  ; RNG seed for determining direction for NPCs to walk
    RESZP battlestep,                       1 ; 1 bytes      ; $F5
    RESZP battlestep_sign,                  1 ; 1 bytes      ; $F6
    RESZP battlecounter,                    1 ; 1 bytes      ; $F7
    RESZP battlerate,                       1 ; 1 bytes      ; $F8  ; X/256 chance of a random encounter occuring (SM only apparently)
    RESZP startintrocheck,                  1 ; 1 bytes      ; $F9
    RESZP respondrate,                      1 ; 1 bytes      ; $FA
    GAP                                     2
    RESZP NTsoft2000,                       1 ; 1 bytes      ; $FD  ; same as soft2000, but used to track coarse NT scroll
    RESZP unk_FE,                           1 ; 1 bytes      ; $FE
    RESZP soft2000,                         0 ; 1 bytes      ; $FF

SECTIONZP "SOUND"
    ; for sound channels (between Bx-Dx) see constants.inc
    RESZP ch_scoreptr,                      2 ; 2 bytes   ; $00
    RESZP ch_envptr,                        2 ; 2 bytes   ; $02 ptr to start of env data
    RESZP ch_envpos,                        1 ; 1 bytes   ; $04 pos in env data (00-1F)
    RESZP ch_lenctr,                        1 ; 1 bytes   ; $05 counter for score data (note length)
    RESZP ch_frqtblptr,                     2 ; 2 bytes   ; $06 pointer to freq table (changes per octave)
    RESZP ch_lentblptr,                     2 ; 1 bytes   ; $08 pointer to length table (changes per tempo)
    RESZP ch_envrate,                       1 ; 1 bytes   ; $0A rate/speed of env table traversal
    RESZP ch_envrem,                        1 ; 1 bytes   ; $0B remaining "fraction" of env data (3 bits of fraction)
    RESZP ch_vol,                           1 ; 1 bytes   ; $0C output volume
    RESZP ch_loopctr,                       1 ; 1 bytes   ; $0D remaining loop counter
    RESZP ch_freq,                          1 ; 1 bytes   ; $0E output freq.  High bit set marks byte has been written (don't rewrite to reset duty)

SECTIONZP "BATTLEZP"
    GAP                                     106
    RESZP btlformation,                     1 ; 1 bytes     ; $6A
    GAP                                     21
    RESZP btl_ib_charstat_ptr,              0 ; 1 bytes      ; $80
    RESZP btlptr,                           2 ; 2 bytes      ; $80
    RESZP btl_ob_charstat_ptr,              2 ; 2 bytes      ; $82
    GAP                                     4
    RESZP btl_jumptableptr,                 0 ; 2 bytes      ; $88
    GAP                                     4
    RESZP btldraw_blockptrstart,            2 ; 2 bytes      ; $8C
    RESZP btldraw_blockptrend,              2 ; 2 bytes      ; $8E
    RESZP btl_entityptr_ibram,              0 ; 2 bytes      ; $90
    RESZP btldraw_src,                      0 ; 2 bytes      ; $90   ; source data
    RESZP btlsfx_frontseat,                 0 ; 1 bytes      ; $90   ; where battle sfx data is stored in zero page
    RESZP btltmp,                           2 ; 16 bytes     ; $90  ; 16 bytes ?
    RESZP btl_entityptr_obrom,              0 ; 1 bytes      ; $92
    RESZP btldraw_dst,                      2 ; 2 bytes      ; $92   ; destination pointer
    RESZP btlsfx_framectr,                  0 ; 1 bytes      ; $94   ; The total frame counter for the entire sound effect
    RESZP btldraw_subsrc,                   2 ; 2 bytes      ; $94   ; source pointer of substring
    GAP                                     2
    RESZP btlsfxsq2_len,                    0 ; 1 bytes      ; $98
    RESZP btl_magdataptr,                   1 ; 2 bytes      ; $98
    RESZP btlsfxnse_len,                    1 ; 1 bytes      ; $99
    RESZP btlsfxsq2_framectr,               1 ; 1 bytes      ; $9A
    RESZP btlsfxnse_framectr,               1 ; 1 bytes      ; $9B
    RESZP btlsfxsq2_ptr,                    2 ; 2 bytes      ; $9C
    RESZP btlsfxnse_ptr,                    1 ; 2 bytes      ; $9E
    RESZP btldraw_max,                      1 ; 1 bytes      ; $9F   ; maximum characters to draw

SECTION "STACK"
    tmp_hi          = $0110  ; 3? bytes

SECTION "OAM"
    oam             = $0200  ; 256 bytes -- must be on page bound
    oam_y           = oam
    oam_t           = oam+1
    oam_a           = oam+2
    oam_x           = oam+3

SECTION "BSS"
    RES             item_box,                           0 ; 32 bytes        ; $0300 $20? bytes -- shares space with str_buf
    RES             str_buf,                            0 ; 57 bytes        ; $0300 $39 bytes at least -- buffer must not cross page
    GAP                                                 10
    RES             shop_charindex,                     1 ; 1 bytes         ; $030A
    RES             shop_spell,                         1 ; 1 bytes         ; $030B
    RES             shop_curitem,                       1 ; 1 bytes         ; $030C
    GAP                                                 1 ; 1 bytes         ; $030D
    RES             shop_curprice,                      2 ; 2 bytes         ; $030E
    GAP                                                 176
    RES             cur_pal,                            32  ; 32 bytes      ; $03C0  ; 32 bytes
    RES             inroom_pal,                         16  ; 16 bytes      ; $03E0  ; cur_pal+$20 ; 16 bytes
    RES             tmp_pal,                            16  ; 16 bytes      ; $03F0  ; 16 bytes
    GAP                                                 896
    RES             draw_buf_ul,                        16  ; $0780
    RES             draw_buf_ur,                        16  ; $0790
    RES             draw_buf_dl,                        16  ; $07A0
    RES             draw_buf_dr,                        16  ; $07B0
    RES             draw_buf_attr,                      16  ; $07C0
    RES             draw_buf_at_hi,                     16  ; $07D0
    RES             draw_buf_at_lo,                     16  ; $07E0
    RES             draw_buf_at_msk,                    16  ; $07F0

SECTION "PARTYGEN"
    RES             ptygen,                             0 ; 64 bytes        ; $0300 ; $40 bytes, shared
    RES             ptygen_class,                       2 ; $0300
    RES             ptygen_name,                        4 ; $0302
    RES             ptygen_name_x,                      1 ; $0306
    RES             ptygen_name_y,                      1 ; $0307
    RES             ptygen_class_x,                     1 ; $0308
    RES             ptygen_class_y,                     1 ; $0309
    RES             ptygen_spr_x,                       1 ; $030A
    RES             ptygen_spr_y,                       1 ; $030B
    RES             ptygen_box_x,                       1 ; $030C
    RES             ptygen_box_y,                       1 ; $030D
    RES             ptygen_curs_x,                      1 ; $030E
    RES             ptygen_curs_y,                      1 ; $030F
    ; 16 bytes per character, 4 characters

SECTION "TILESET"
    GAP                                                 256
    RES_PAGE        tileset_data,                       0   ; $0400 - 1024 bytes -- must be on page bound
    RES             tileset_prop,                       256 ; $0400 - 2 bytes per tile
    RES             tsa_ul,                             128 ; $0500
    RES             tsa_ur,                             128 ; $0580
    RES             tsa_dl,                             128 ; $0600
    RES             tsa_dr,                             128 ; $0680
    RES             tsa_attr,                           128 ; $0700
    RES             load_map_pal,                       48  ; $0780 (shared with draw_buf -- hence only for loading)

SECTION "MINIMAP"
    GAP                                                 512
    RES_PAGE        mm_drawbuf,                         256 ; 256 bytes     ; $0500  ; 256 bytes, shared, should be on page bound, but don't think it's absolutely required
    RES             mm_mapbuf,                          256 ; 256 bytes     ; $0600  ; 256 bytes, same
    RES             mm_mapbuf2,                         256 ; 256 bytes     ; $0700  ; 256 bytes, same

SECTION "PUZZLE"
    RES             puzzle,                             16 ; $0300



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
    RES             items,                              0 ; $6020
    RES             item_lute,                          1 ; $6020
    RES             item_crown,                         1 ; $6021
    RES             item_crystal,                       1 ; $6022
    RES             item_herb,                          1 ; $6023
    RES             item_mystickey,                     1 ; $6024
    RES             item_tnt,                           1 ; $6025
    RES             item_adamant,                       1 ; $6026
    RES             item_slab,                          1 ; $6027
    RES             item_ruby,                          1 ; $6028
    RES             item_rod,                           1 ; $6029
    RES             item_floater,                       1 ; $602A
    RES             item_chime,                         1 ; $602B
    RES             item_tail,                          1 ; $602C
    RES             item_cube,                          1 ; $602D
    RES             item_bottle,                        1 ; $602E
    RES             item_oxyale,                        1 ; $602F
    RES             item_canoe,                         1 ; $6030
    RES             item_orb_start,                     0 ; $6031
    RES             orb_fire,                           1 ; $6032
    RES             orb_water,                          1 ; $6032
    RES             orb_air,                            1 ; $6033
    RES             orb_earth,                          1 ; $6034
    RES             item_qty_start,                     0 ; $6035
    RES             item_tent,                          1 ; $6036
    RES             item_cabin,                         1 ; $6036
    RES             item_house,                         1 ; $6037
    RES             item_heal,                          1 ; $6038
    RES             item_pure,                          1 ; $6039
    RES             item_soft,                          1 ; $603A
    RES             item_stop,                          1 ; $603B
    GAP                                                 196
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
    RES             sram,                               1023 ; $6400
    RES             sram_checksum,                      1   ; $67FF
    GAP                                                 1024
    RES             bigstr_buf,                         0 ; $6C00   ; $81 bytes?
    RES             lutmp_ch_stats,                     256 ; $6C00 ; temporary space used by the lineup menu
    RES             lutmp_ch_magic,                     1 ; $6D00

SECTION "BATTLE" ; $6800 - 6DB0
    GAP                                                 2048
    RES             btl_chstats,                        72 ; $6800  ; $12 bytes per character
    RES             btl_turnorder,                      13 ; $6848  ; $D entries (9 enemies + 4 characters)
    RES             btl_hp_text_buf,                    0 ; $6855   ; 8 bytes?
    GAP                                                 1
    RES             btl_drink_selection,                0 ; $6856
    RES             btl_mathbuf,                        0 ; $6856     ; $14 bytes?, 2 byte pairs, used as buffers for mathematical routines
    RES             levelup_loop,                       0 ; $6856
    RES             math_hitchance,                     2 ; $6856
    RES             levelup_statsindex,                 0 ; $6858
    RES             math_basedamage,                    2 ; $6858
    RES             math_numhits,                       0 ; $685A
    RES             math_magrandhit,                    2 ; $685A
    RES             btlmag_spellconnected,              0 ; $685C ; 1 byte
    RES             math_category,                      2 ; $685C ; not really math... but whatever
    RES             math_element,                       0 ; $685E ; not really math... but whatever
    RES             math_randhit,                       2 ; $685E
    RES             math_dmgcalc,                       2 ; $6860
    RES             math_critchance,                    2 ; $6862
    RES             math_ailmentchance,                 2 ; $6864
    RES             battle_ailmentrandchance,           1 ; $6866
    ;btl_defender_hp             = btl_mathbuf + (MATHBUF_DEFENDERHP*2)  ; $687C -- treated as part of math buffer by some code
    ;battle_totaldamage          = btl_mathbuf + (MATHBUF_TOTALDAMAGE*2)  ; $6882 -- treated as part of math buffer by some code
    ;btlmag_defender_hp                      = btl_mathbuf + (MATHBUF_MAGDEFENDERHP*2)  ; $687A
    ;btlmag_defender_hpmax                   = btl_mathbuf + (MATHBUF_MAGDEFENDERMAXHP*2)  ; $6880
    GAP                                                 3
    RES             battle_hitsconnected,               1 ; $686A     ; number of hits actually connected
    RES             battle_critsconnected,              1 ; $686B
    RES             btlmag_attacker_unk686C,            0 ; $686C ; Enemy:  ailments              Player:  ailments
    RES             btl_attacker_strength,              1 ; $686C
    RES             btlmag_defender_ailments,           0 ; $686D
    RES             btl_attacker_category,              1 ; $686D
    RES             btlmag_effect,                      0 ; $686E
    RES             btl_attacker_element,               1 ; $686E
    RES             btl_attacker_hitrate,               1 ; $686F
    RES             btlmag_hitrate,                     0 ; $6870
    RES             btl_attacker_numhitsmult,           1 ; $6870
    RES             btl_attacker_numhits,               1 ; $6871
    RES             btlmag_defender_magdef,             0 ; $6872
    RES             btl_attacker_critrate,              1 ; $6872
    RES             btlmag_defender_unknownRawInit0,    0 ; $6873
    RES             btl_attacker_attackailment,         1 ; $6873
    RES             btlmag_effectivity,                 1 ; $6874
    RES             btlmag_attacker_unk6875,            1 ; $6875 ; Enemy:  ai                    Player:  damage
    RES             eob_gp_reward,                      0 ; $6876
    RES             btlmag_defender_elemweakness,       0 ; $6876
    RES             btl_defender_category,              1 ; $6876
    RES             btlmag_defender_elemresist,         0 ; $6877
    RES             btl_defender_elemweakness,          1 ; $6877
    RES             btlmag_element,                     0 ; $6878
    RES             btl_defender_evade,                 0 ; $6878
    RES             eob_exp_reward,                     1 ; $6878
    RES             btlmag_attacker_unk6879,            0 ; $6879 ; Enemy:  high byte of GP       Player:  class
    RES             btl_defender_absorb,                1 ; $6879
    RES             btlmag_defender_hp,                 0 ; $687A
    RES             btl_defender_magdef,                1 ; $687A
    RES             btl_defender_elemresist,            1 ; $687B
    RES             btl_defender_hp,                    1 ; $687C
    RES             btlmag_defender_numhitsmult,        1 ; $687D
    RES             btlmag_defender_morale,             1 ; $687E
    RES             btlmag_defender_absorb,             1 ; $687F
    RES             btlmag_defender_hpmax,              0 ; $6880
    RES             btl_attacker_graphic,               1 ; $6880     ; the graphic used for an attack
    RES             btl_attacker_varplt,                1 ; $6881     ; The variable palette color used for an attack
    RES             battle_totaldamage,                 0 ; $6882
    RES             btlmag_defender_strength,           1 ; $6882
    RES             btlmag_attacker_unk6883,            1 ; $6883 ; Enemy:  0                     Player:  level
    RES             battle_attacker_index,              0 ; $6884 ; ?? redundant??  why not just use btl_attacker?
    RES             btlmag_attacker_unk6884,            1 ; $6884 ; Enemy:  damage                Player:  hit rate
    RES             battle_defender_index,              0 ; $6885 ; same... but this is necessary for output!  See Battle_DoTurn in bank C!!
    RES             btlmag_defender_evade,              1 ; $6885  ; shared with battle_defender_index?  Is that not used for btlmag ?
    RES             btlmag_defender_category,           1 ; $6886
    RES             battle_defenderisplayer,            1 ; $6887 ; nonzero if player is defending, zero if enemy is defending 
    RES             btl_attacker_ailments,              1 ; $6888 ;   important for output!  See Battle_DoTurn in bank C
    RES             btl_defender_ailments,              1 ; $6889 ; important for output!
    RES             btl_rngstate,                       1 ; $688A    ; State of RNG used for in-battle
    RES             btltmp_divLo,                       1 ; $688B
    RES             btltmp_divHi,                       1 ; $688C
    RES             btltmp_divV,                        1 ; $688D
    RES             levelup_classid,                    0 ; $688E ; local, stores class ID
    RES             btl_curturn,                        1 ; $688E         ; current turn (index for btl_turnorder)
    RES             btl_charcmdbuf,                     16 ; $688F
    RES             btl_charcmditem,                    0 ; $689F
    RES             char_order_buf,                     4 ; $689F
    RES             btl_charcmdconsumetype,             1 ; $68A3
    GAP                                                 3
    RES             btl_charcmdconsumeid,               1 ; $68A7
    GAP                                                 7
    RES             btl8x8spr_x,                        2 ; $68AF ; X coord ;  +1 used in drawing code as original position ; These next 5 vars are all in temp memory, and are mostly just used for passing into BattleDraw8x8Sprite
    RES             btl8x8spr_y,                        2 ; $68B1 ; Y coord ;  +1 used in drawing code as original position
    RES             btl_tmpindex,                       0 ; $68B3 ; temporary holder for a current index
    RES             btltmp_multA,                       0 ; $68B3 ; shared
    RES             btltmp_boxleft,                     0 ; $68B3
    RES             btl_input,                          0 ; $68B3
    RES             btl8x8spr_a,                        1 ; $68B3 ; attribute
    RES             btltmp_multB,                       0 ; $68B4    ; shared
    RES             btl_tmpchar,                        0 ; $68B4 ; temporary holder for a 0-based character index
    RES             btltmp_boxcenter,                   0 ; $68B4
    RES             btl8x8spr_t,                        1 ; $68B4 ; tile ID
    RES             btl8x8spr_i,                        0 ; $68B5 ; slot to draw to (00-3F)
    RES             btltmp_boxright,                    0 ; $68B5
    RES             btltmp_multC,                       1 ; $68B5
    GAP                                                 1
    RES             btl_soft2000,                       1 ; $68B7    ; soft copy of PPUCTRL used in battles
    RES             btl_soft2001,                       1 ; $68B8    ; soft copy of PPUMASK used in battles
    GAP                                                 1
    RES             btlbox_blockdata,                   1 ; $68BA
    GAP                                                 99
    RES             btl_msgbuffer,                      384 ; $691E   ; $180 bytes  ($0C rows * $20 bytes per row); this buffer contains on-screen tiles to be drawn to ppu$2240; (note only $19 bytes are actually drawn, the remaining 7 bytes are padding)
    RES             btl_msgdraw_hdr,                    1 ; $6A9E
    RES             btl_msgdraw_x,                      1 ; $6A9F
    RES             btl_msgdraw_y,                      1 ; $6AA0
    RES             btl_msgdraw_srcptr,                 0 ; $6AA1  ; shared ; 2 bytes
    RES             btl_msgdraw_width,                  1 ; $6AA1
    RES             btl_msgdraw_height,                 1 ; $6AA2
    RES             btl_msgdraw_blockcount,             1 ; $6AA3      ; the number of blocks drawn
    GAP                                                 2
    RES             btlinput_prevstate,                 0 ; $6AA6 ; prev state for input
    RES             eobbox_slotid,                      1 ; $6AA6
    RES             inputdelaycounter,                  0 ; $6AA7     ; counter to delay multiple-input processing when holding a direction
    RES             eobbox_textid,                      1 ; $6AA7
    GAP                                                 1
    RES             btl_animatingchar,                  1 ; $6AA9     ; the character currently being animated (0-3)
    RES             btlcurs,                            0 ; $6AAA
    RES             btlcurs_x,                          1 ; $6AAA     ; battle cursor X position (menu position, not pixel position)
    RES             btlcurs_max,                        0 ; $6AAB     ; highest value for the cursor
    RES             btlcurs_y,                          1 ; $6AAB     ; battle cursor Y position (menu position, not pixel position)
    RES             levelup_statupbuffer,               0 ; $6AAC     ; 5 bytes indicating which stats have been increased
    RES             btlcurs_positions,                  1 ; $6AAC     ; ?? bytes, 2 bytes per entry, each entry is the pixel coord of where the cursor should be drawn when its item is selected.
    GAP                                                 36
    RES             btl_drawflagsA,                     1 ; $6AD1  ; bits 0-3 = set to indicate character should be drawn as dead ; bit    4 = set to draw battle cursor ; bit    5 = set to draw weapon attack graphic ; bit    6 = set to draw magic graphic & flash BG.
    RES             btl_drawflagsB,                     1 ; $6AD2  ; bits 0-4 = set to indicate character should be drawn as stone
    RES             btl_chardrawinfo,                   0 ; $6AD3        ;$10 bytes, 4 bytes for each character
    RES             btl_chardraw_x,                     1 ; $6AD3
    RES             btl_chardraw_y,                     1 ; $6AD4
    RES             btl_chardraw_gfxset,                1 ; $6AD5
    RES             btl_chardraw_pose,                  1 ; $6AD6
    GAP                                                 12
    RES             btlcursspr_x,                       1 ; $6AE3
    RES             btlcursspr_y,                       1 ; $6AE4
    RES             btlattackspr_x,                     1 ; $6AE5
    RES             btlattackspr_y,                     1 ; $6AE6
    RES             btlattackspr_t,                     1 ; $6AE7     ; indicate which tile to draw for the weapon graphic
    RES             btlattackspr_pose,                  1 ; $6AE8     ; for weapons, 0 or 8 to indicate whether or not to flip it for magic, 0 or ?4? to indicate which frame to draw
    RES             btlattackspr_gfx,                   1 ; $6AE9     ; copied to 't' prior to drawing.  Indicates which graphic to use
    RES             btlattackspr_wepmag,                1 ; $6AEA     ; 0 for drawing the weapon, 1 for drawing the magic
    GAP                                                 2
    RES             btlattackspr_hidell,                1 ; $6AED     ; nonzero to hide the lower-left tile of the attack graphic, this is done for the "behind the back" frame of weapon swing animation.
    RES             btlattackspr_nodraw,                1 ; $6AEE     ; nonzero to hide the weapon/magic sprite entirely. This is used when a non-BB player attacks without any weapon equipped Also used when using ITEMs to supress the magic flashing effect.
    RES             btltmp_targetlist,                  9 ; $6AEF     ; temporary buffer (9 entries) containing possible targets
    RES             btl_combatboxcount,                 1 ; $6AF8     ; the number of combat boxes that have been drawn
    GAP                                                 1
    RES             btl_unfmtcbtbox_buffer,             128 ; $6AFA  ; $80 bytes total, $10 bytes for each combat box. houses the unformatted text for each combat box. Additional bytes are used for other areas
    RES             btlcmd_curchar,                     1 ; $6B7A     ; the current character inputting battle commands (0-3)
    RES             btlcmd_target,                      1 ; $6B7B     ; the current enemy slot that is being targetted
    GAP                                                 2
    RES             btlcmd_magicgfx,                    8 ; $6B7E     ; 2 bytes per character.  [0] = graphic to draw, [1] = palette to use
    RES             btl_result,                         1 ; $6B86 ;   0 = keep battling ;   1 = party defeated ;   2 = all enemies defeated ;   3 = party ran ; $FF = wait for 2 seconds after fadeout before exiting (chaos defeated?)
    RES             btl_usepalette,                     32; $6B87 ; $20 bytes - the palette that is actually displayed (after fade effects)
    RES             btl_followupmusic,                  1 ; $6BA7 ; song to play in battle after current song finishes.  Moved to music_track once music_track has its high bit set  (does this ever happen?)
    RES             btl_charattrib,                     4 ; $6BA8 ; attributes to use when drawing charcters in battle  (4 bytes, 1 for each)
    RES             btl_responddelay,                   1 ; $6BAC
    RES             levelup_levindex,                   1 ; $6BAD ; local, stores the index to level up stats
    RES             btl_strikingfirst,                  1 ; $6BAE ; nonzero if players are striking first.  Zero otherwise
    RES             btl_potion_heal,                    1 ; $6BAF ; battle containers for Heal/Pure potions.  Stored separately because
    RES             btl_potion_pure,                    1 ; $6BB0 ;  it can fall out of sync with the ACTUAL items (if a character trying to use one dies, for example)
    RES             battle_bank,                        1 ; $6BB1  ; The bank to jump back to for setting up battles
    RES             btl_smallslots,                     1 ; $6BB2             ; Number of small enemy slots available
    RES             btl_largeslots,                     1 ; $6BB3  ; Number of large slots available.  Must immediately follow smallslots
    GAP                                                 2
    RES             btl_enemyeffect,                    1 ; $6BB6     ; 0 to draw expolosion graphics as the effect nonzero to erase the enemy as the effect
    RES             btl_enemyIDs,                       9 ; $6BB7  ; 9 entries of enemy IDs
    RES             btl_enemygfxplt,                    9 ; $6BC0  ; 9 entries of enemy graphic and palette assignment (graphic in high 2 bits, plt in low bit)
    RES             btl_enemyroster,                    4 ; $6BC9  ; 4 bytes of enemy IDs printed in the main battle menu, showing enemies in the fight
    RES             btl_attacker_alt,                   1 ; $6BCD ; An EXTREMELY redundant and stupid copy of btl_attacker
    GAP                                                 1
    RES             btl_randomplayer,                   1 ; $6BCF ; set by GetRandomPlayerTarget  (0-3)
    GAP                                                 3
    RES             btl_enemystats,                     180 ; $6BD3  ; $14 bytes per enemy - data does NOT match how it is stored in ROM
    RES             btl_tmppltassign,                   1 ; $6C88    ; temporary value to assign palette to enemies in a formation
    RES             btl_attacker,                       1 ; $6C89
    RES             btl_defender,                       1 ; $6C8A
    RES             btl_combatboxcount_alt,             1 ; $6C8B ; ANOTHER combatbox counter... this is totally redundant
    RES             btl_attackid,                       1 ; $6C8C ; >= $42 for enemy attacks
    GAP                                                 2
    RES             btlmag_magicsource,                 1 ; $6C8F ; 0=magic, 1=drink, 2=item
    RES             btlmag_ailment_orig,                1 ; $6C90 ; A backup of 
    GAP                                                 1
    RES             btl_battletype,                     1 ; $6C92     ; 0=9 small, 1=4 large, 2=mix, 3=fiend, 4=chaos
    RES             btl_enemycount,                     1 ; $6C93     ; count of the number of enemies being generated for a battle
    RES             btltmp_attr,                        64 ; $6C94     ; $40 bytes of attribute data for the battle setup
    RES             btl_stringoutputbuf,                1 ; $6CD4 ; output buffer where decoded strings are printed
    GAP                                                 63
    RES             loop_counter,                       0 ; $6D14; action buffer?  $20 bytes?  contents for combat boxes are placed here?
    RES             explode_min_x,                      1 ; $6D14
    RES             explode_min_y,                      1 ; $6D15
    RES             explode_max_x,                      1 ; $6D16
    RES             explode_max_y,                      1 ; $6D17
    RES             explode_count,                      1 ; $6D18
    RES             btltmp_altmsgbuffer,                1 ; $6D19
    GAP                                                 18
    RES             btltmp_attackerbuffer,              1 ; $6D2C
    GAP                                                 7
    RES             btl_palettes,                       32 ; $6D34   ; $20 bytes
    RES             btl_stringbuf,                      32 ; $6D54   ; $20 byte buffer to contain string data for printing
    RES             btltmp_backseat,                    16 ; $6D74   ; $10 byte buffer -- backup of btltmp
    RES             btlform_type,                       0 ; $6D84   ; battle type (high 4 bits) -- low 4 bits are pattern table
    RES             btl_formdata,                       1 ; $6D84   ; $10 bytes (formation data as appears in ROM)
    RES             btlform_engfx,                      1 ; $6D85   ; graphic assignment (2 bits per enemy)
    RES             btlform_enids,                      4 ; $6D86   ; enemy IDs (4 bytes)
    RES             btlform_enqty,                      4 ; $6D8A   ; enemy quantities (4 bytes)
    RES             btlform_plts,                       2 ; $6D8E   ; palettes for this battle (2 bytes)
    RES             btlform_surprise,                   1 ; $6D90   ; surprise rate
    RES             btlform_enplt,                      0 ; $6D91   ; enemy palette assign (in high 4 bits)
    RES             btlform_norun,                      1 ; $6D91   ; no run flag (in low bit)
    RES             btlform_enqtyB,                     2 ; $6D92   ; enemy quantities for B formation (2 bytes)
    RES             btlmag_fakeout_ailments,            1 ; $6D94 ;   what these 'fakeout' vars are and how/why they're used
    RES             btlmag_fakeout_defindex,            1 ; $6D95 ; See Battle_DoTurn in bank C for a description of
    RES             btlmag_fakeout_defplayer,           1 ; $6D96
    RES             btlsfx_backseat,                    1 ; $6D97 ; where it is stored when not in zero page (it swaps between the two)
    GAP                                                 15
    RES             btlmag_playerhitsfx,                1 ; $6DA7     ; sound effect to play when magic hits player
    GAP                                                 8
    RES             btltmp_smallslotpos,                1 ; $6DB0

SECTION "MAPOBJ" ; $6F00 - $6F0E
    GAP                                                 3840
    RES_PAGE        mapobj,                             0 ; $6F00   ; $100 bytes -- page
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

SECTION "MAPDATA" ; $7000 - $7FFF
    GAP                                                 4096
    RES_ADDRESS     mapdata,                            0, $7000 ; $7000   ; must be on $1000 byte bound (ie:  pretty much unmovable)

SECTION "MINIMAP2" ; $7000 - $7580
    GAP                                                 4096
    RES             mm_decorchr,                        768 ; $7000   ; $300 bytes -- should be on page bound, shared
    RES_PAGE        mm_titlechr,                        640 ; $7300   ; $280 bytes -- should be on page bound, shared

    ;  Buffers to hold character commands for battle.  These must be contiguious in memory
    ;  due to the way memory is cleared.  These buffers also contain a bit of redundant data.
    ;
    ;  btl_charcmdbuf contains 3 bytes (padded to 4) per character:
    ;    byte 0 = command
    ;    byte 1 = spell effect ID  (used for DRINK/MAGIC/ITEM).  FF if no effect
    ;    byte 2 = target.  8x are player targets 0x are enemy targets.  FF=target all enemies, FE=target all players.
    ;
    ;  Commands can be the following:
    ;    00 = no command -- if surprised/asleep/stunned
    ;    01 = no command -- if dead
    ;    02 = no command -- if stone
    ;    04 = attack
    ;    08 = drink potion
    ;    10 = use item
    ;    20 = run   ('target' would be the actual character running)
    ;    40 = magic
    ;    
    ;
    ;  btl_charcmditem contains 1 byte per character:  the ID of the item they're using.
    ;    This is only used when the command is '10'
    ;
    ;  btl_charcmdconsumetype contains 1 byte per character.  It will be 01 for magic and 02 for DRINK.
    ;       unused for other commands.
    ;
    ;  btl_charcmdconsumeid contains 1 byte per character.  If will be the potion index
    ;       for drink, or the spell level for magic

    ;btl_charcmdbuf          = $688F
    ;btl_charcmditem         = btl_charcmdbuf+$10        ; $689F
    ;btl_charcmdconsumetype  = btl_charcmditem+4         ; $68A3
    ;btl_charcmdconsumeid    = btl_charcmdconsumetype+4  ; $68A7




SECTION "THEEND" ; $6800 - $6F00
    GAP                                                 2048
    RES             theend_drawbuf,                     1792 ; $6800    ; $700 bytes!
