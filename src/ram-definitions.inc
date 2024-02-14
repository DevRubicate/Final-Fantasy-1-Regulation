.macro RESERVE label, size
    .global .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro RESERVEZP label, size
    .globalzp .ident(.string(label))
    .ifdef _DEFINE_MEMORY
        .ident(.string(label)): .res size
    .endif
.endmacro

.macro GAP size
    .ifdef _DEFINE_MEMORY
        .res size
    .endif
.endmacro

.ifdef _DEFINE_MEMORY
    .segment "ZEROPAGE": zeropage
.endif
    ; for sound channels (between Bx-Dx)
    ;  see constants.inc
    RESERVEZP ch_scoreptr,        2   ; $00
    RESERVEZP ch_envptr,          2   ; $02 ptr to start of env data
    RESERVEZP ch_envpos,          1   ; $04 pos in env data (00-1F)
    RESERVEZP ch_lenctr,          1   ; $05 counter for score data (note length)
    RESERVEZP ch_frqtblptr,       1   ; $06 pointer to freq table (changes per octave)
    RESERVEZP story_dropinput,    1   ; $07
    RESERVEZP ch_lentblptr,       2   ; $08 pointer to length table (changes per tempo)
    RESERVEZP ch_envrate,         1   ; $0A rate/speed of env table traversal
    RESERVEZP ch_envrem,          1   ; $0B remaining "fraction" of env data (3 bits of fraction)
    RESERVEZP ch_vol,             1   ; $0C output volume
    RESERVEZP inroom,             0   ; $0D bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
    RESERVEZP ch_loopctr,         1   ; $0D remaining loop counter
    RESERVEZP doorppuaddr,        0   ; $0E 2 bytes, PPU address of door drawing work
    RESERVEZP ch_freq,            1   ; $0E output freq.  High bit set marks byte has been written (don't rewrite to reset duty)
    GAP                           1
    RESERVEZP tmp,                     16 ; 16 bytes
    mu_scoreptr := tmp+8  ;2 bytes, shared tmp
    dlgbox_row :=  tmp+$C  ; shared tmp
    palcyc_mode := tmp+$C  ; shared tmp
    RESERVEZP joy,                     1 ; $20
    RESERVEZP joy_ignore,              1 ; $21
    RESERVEZP joy_select,              1 ; $22
    RESERVEZP joy_start,               1 ; $23
    RESERVEZP joy_a,                   1 ; $24
    RESERVEZP joy_b,                   1 ; $25
    RESERVEZP sprindex,                1 ; $26

    RESERVEZP ow_scroll_x,             1 ; $27  ; X scroll of OW in tiles
    RESERVEZP ow_scroll_y,             1 ; $28  ; Y scroll in tiles
    RESERVEZP sm_scroll_x,             1 ; $29  ; ditto, but for standard maps
    RESERVEZP sm_scroll_y,             1 ; $2A
    RESERVEZP mapdraw_x,               1 ; $2B
    RESERVEZP mapdraw_y,               1 ; $2C
    RESERVEZP mapflags,                1 ; $2D  ; bit 0 set when in standard map.  bit 1 set to indicate column drawing instead of row drawing
    GAP                                1
    RESERVEZP scroll_y,                1 ; $2F  ; Y scroll in tiles (16x16).  range=0-E
    RESERVEZP mapdraw_nty,             1 ; $30
    RESERVEZP mapdraw_ntx,             1 ; $31
    RESERVEZP mapdraw_job,             1 ; $32  ; 0=no job, 1=draw attribs, 2=draw tiles
    RESERVEZP mg_slidedir,             0 ; $33  ; shared
    RESERVEZP facing,                  1 ; $33  ; 1=R  2=L  4=D  8=U
    RESERVEZP move_speed,              1 ; $34  ; pixels to move per frame (map)
    RESERVEZP move_ctr_x,              1 ; $35  ; pixels between tiles (map movement -- 00-0F)
    RESERVEZP move_ctr_y,              1 ; $36  ; ditto but for Y axis
    RESERVEZP menustall,               1 ; $37       ; see MenuCondStall in bank F for explanation
    RESERVEZP box_x,                   0 ; $38
    RESERVEZP theend_x,                1 ; $38
    RESERVEZP box_y,                   0 ; $39
    RESERVEZP theend_y,                1 ; $39
    RESERVEZP dest_x,                  1 ; $3A
    RESERVEZP dest_y,                  1 ; $3B
    RESERVEZP box_wd,                  0 ; $3C ; shared
    RESERVEZP dest_wd,                 1 ; $3C
    RESERVEZP box_ht,                  0 ; $3D ; shared
    RESERVEZP dest_ht,                 1 ; $3D
    RESERVEZP image_ptr,               0 ; $3E ; shared
    RESERVEZP text_ptr,                2 ; $3E ; 2 bytes
    RESERVEZP spr_x,                   1 ; $40
    RESERVEZP mm_maprow,               0 ; $41 ; shared
    RESERVEZP spr_y,                   1 ; $41
    RESERVEZP vehicle,                 1 ; $42 ;1=walking, 2=canoe, 4=ship, 8=airship
    RESERVEZP inforest,                1 ; $43 ; nonzero if in forest
    RESERVEZP tileprop,                2 ; $44 ; 2 bytes
    RESERVEZP vehicle_next,            1 ; $46 ; vehicle we're walking onto
    RESERVEZP vehchgpause,             1 ; $47 ; forced pause when changing vehicles
    RESERVEZP cur_map,                 1 ; $48
    RESERVEZP cur_tileset,             1 ; $49
    RESERVEZP cur_mapobj,              1 ; $4A ; counter for updating which map object
    RESERVEZP music_track,             1 ; $4B
    RESERVEZP mu_chanprimer,           1 ; $4C
    RESERVEZP mu_chan,                 1 ; $4D
    GAP                                2
    RESERVEZP entering_shop,           1 ; $50 ; nonzero = about to enter shop
    RESERVEZP shop_id,                 1 ; $51
    RESERVEZP tileprop_now,            1 ; $52 ; special tile properties that we're on (tileprop isn't necessarily what we're standing on)
    RESERVEZP ow_tile,                 1 ; $53
    RESERVEZP ppu_dest,                2 ; $54  ; 2 bytes
    RESERVEZP dlgflg_reentermap,       1 ; $56  ; flag to indicate the map needs re-entering due to dialogue (Bahamut/class change)
    RESERVEZP cur_bank,                1 ; $57
    RESERVEZP ret_bank,                1 ; $58
    GAP                                3
    RESERVEZP name_input_draw_buf,     1 ; $5C
    GAP                                3
    RESERVEZP format_buf,              1 ; $60  ; 7 bytes (5A-60) -- must not cross page bound
    RESERVEZP shutter_a,               0 ; $61  ; shared
    RESERVEZP lu_cursor,               0 ; $61  ; shared
    RESERVEZP mm_bplo,                 0 ; $61  ; shared
    RESERVEZP dlg_itemid,              0 ; $61  ; shared
    RESERVEZP equipmenu_tmp,           0 ; $61  ; shared
    RESERVEZP joy_prevdir,             1 ; $61
    RESERVEZP shutter_b,               0 ; $62  ; shared
    RESERVEZP lu_cursor2,              0 ; $62  ; shared
    RESERVEZP mm_bphi,                 0 ; $62  ; shared
    RESERVEZP intro_ataddr,            0 ; $62  ; shared
    RESERVEZP cursor,                  0 ; $62
    RESERVEZP theend_src,              1 ; $62
    RESERVEZP lu_mode,                 0 ; $63  ; shared
    RESERVEZP intro_atbyte,            0 ; $63  ; shared
    RESERVEZP cursor_max,              0 ; $63
    RESERVEZP cursor2,                 1 ; $63  ; shared (secondary cursor)
    RESERVEZP lu_joyprev,              0 ; $64  ; shared
    RESERVEZP intro_color,             0 ; $64  ; shared
    RESERVEZP mg_slidespr,             0 ; $64  ; shared, 3 bytes
    RESERVEZP namecurs_x,              0 ; $64
    RESERVEZP shopcurs_x,              0 ; $64  ; shared
    RESERVEZP eq_modecurs,             0 ; $64  ; shared
    RESERVEZP hp_recovery,             0 ; $64
    RESERVEZP minimap_ptr,             1 ; $64  ; shared, 2 bytes
    RESERVEZP mp_required,             0 ; $65
    RESERVEZP namecurs_y,              0 ; $65
    RESERVEZP shopcurs_y,              0 ; $65  ; shared
    RESERVEZP story_credits,           1 ; $65  ; shared
    RESERVEZP submenu_targ,            0 ; $66  ; shared with shop_type
    RESERVEZP shop_type,               0 ; $66
    RESERVEZP story_page,              0 ; $66  ; shared
    RESERVEZP equipoffset,             1 ; $66  ; MUST be shared with shop_type
    RESERVEZP story_timer,             0 ; $67  ; shared
    RESERVEZP draweq_stradd,           0 ; $67  ; shared
    RESERVEZP char_index,              0 ; $67
    RESERVEZP mm_pixrow,               0 ; $67  ; shared
    RESERVEZP talkobj,                 1 ; $67  ; shared -- object you're talking to on SM
    RESERVEZP sm_player_x,             1 ; $68  ; player X/Y position on standard map.  Only used for NPC collision detection
    RESERVEZP sm_player_y,             1 ; $69
    RESERVEZP btlformation,            1 ; $6A
    RESERVEZP enCHRpage,               1 ; $6B
    RESERVEZP altareffect,             1 ; $6C  ; flag to indicate altar effect is to occur (screen shaking, monochrome diagonal window thing)
    GAP                                15
    RESERVEZP dlgmusic_backup,         1 ; $7C  ; backup music track for restoring music after the dialogue box changes it
    RESERVEZP dlgsfx,                  1 ; $7D  ; flag to indicate to play a sound effect after opening dialogue box.  0=no sfx, 1=fanfare, else=treasure
    RESERVEZP sq2_sfx,                 1 ; $7E
    RESERVEZP descboxopen,             1 ; $7F
    RESERVEZP btl_ib_charstat_ptr,     0 ; $80
    RESERVEZP lvlup_curexp,            0 ; $80       ; 2 byte pointer to character's current EXP
    RESERVEZP btlptr,                  2 ; $80
    RESERVEZP lvlup_exptoadv,          0 ; $82       ; 2 byte pointer to EXP needed to advance
    RESERVEZP btl_ob_charstat_ptr,     2 ; $82
    RESERVEZP lvlup_chmagic,           2 ; $84       ; 2 byte pointer to character's magic data
    RESERVEZP lvlup_chstats,           2 ; $86       ; 2 byte pointer to character's OB stats
    RESERVEZP battlereward,            3 ; $88       ; 3 bytes.  Note that while this var is 3 bytes, this stop behaving properly
                                    ;  if rewards ever exceed the 2-byte boundary, since the game assumes you
                                    ;  will never receive more than 65535 XP/GP in any one battle.
    GAP                                1
    RESERVEZP btldraw_blockptrstart,   2 ;  $8C
    RESERVEZP btldraw_blockptrend,     2 ;  $8E

    RESERVEZP btl_entityptr_ibram,     0 ;  $90
    RESERVEZP btldraw_src,             0 ;  $90   ; source data
    RESERVEZP btlsfx_frontseat,        0 ;  $90   ; where battle sfx data is stored in zero page
    RESERVEZP btltmp,                  2 ;  $90  ; 16 bytes ?
    RESERVEZP btl_entityptr_obrom,     0 ;  $92
    RESERVEZP btldraw_dst,             2 ;  $92   ; destination pointer
    RESERVEZP btlsfx_framectr,         0 ;  $94   ; The total frame counter for the entire sound effect
    RESERVEZP btldraw_subsrc,          2 ;  $94   ; source pointer of substring
    GAP                                2
    RESERVEZP btlsfxsq2_len,           0 ;  $98
    RESERVEZP btl_magdataptr,          1 ;  $98
    RESERVEZP btlsfxnse_len,           1 ;  $99
    RESERVEZP btlsfxsq2_framectr,      1 ;  $9A
    RESERVEZP btlsfxnse_framectr,      1 ;  $9B
    RESERVEZP btlsfxsq2_ptr,           2 ;  $9C
    RESERVEZP btlsfxnse_ptr,           1 ;  $9E
    RESERVEZP btldraw_max,             1 ;  $9F   ; maximum characters to draw
    GAP                                1
    RESERVEZP actual_bank,             1 ;  $A1
    GAP                                78
    RESERVEZP framecounter,            2 ;  $F0  ; 2 bytes!
    GAP                                2
    RESERVEZP npcdir_seed,             1 ;  $F4  ; RNG seed for determining direction for NPCs to walk
    RESERVEZP battlestep,              1 ;  $F5
    RESERVEZP battlestep_sign,         1 ;  $F6
    RESERVEZP battlecounter,           1 ;  $F7
    RESERVEZP battlerate,              1 ;  $F8  ; X/256 chance of a random encounter occuring (SM only apparently)
    RESERVEZP startintrocheck,         1 ;  $F9
    RESERVEZP respondrate,             1 ;  $FA
    GAP                                2
    RESERVEZP NTsoft2000,              1 ;  $FD  ; same as soft2000, but used to track coarse NT scroll
    RESERVEZP unk_FE,                  1 ;  $FE
    RESERVEZP soft2000,                0 ;  $FF

.ifdef _DEFINE_MEMORY
    .segment "STACK"
.endif
    tmp_hi          = $0110  ; 3? bytes

.ifdef _DEFINE_MEMORY
    .segment "OAM"
.endif
    oam             = $0200  ; 256 bytes -- must be on page bound
    oam_y           = oam
    oam_t           = oam+1
    oam_a           = oam+2
    oam_x           = oam+3

.ifdef _DEFINE_MEMORY
    .segment "BSS"
.endif


    RESERVE puzzle,          0 ; $0300
    RESERVE item_box,        0 ; $0300 $20? bytes -- shares space with str_buf
    RESERVE str_buf,         0 ; $0300 $39 bytes at least -- buffer must not cross page
    RESERVE ptygen,          40  ; $40 bytes, shared
    ptygen_class   := ptygen
    ptygen_name    := ptygen+2
    ptygen_name_x  := ptygen+6
    ptygen_name_y  := ptygen+7
    ptygen_class_x := ptygen+8
    ptygen_class_y := ptygen+9
    ptygen_spr_x   := ptygen+$A
    ptygen_spr_y   := ptygen+$B
    ptygen_box_x   := ptygen+$C
    ptygen_box_y   := ptygen+$D
    ptygen_curs_x  := ptygen+$E
    ptygen_curs_y  := ptygen+$F


    shop_charindex  = $030A  ; shared
    shop_spell      = $030B  ; shared
    shop_curitem    = $030C  ; shared
    shop_curprice   = $030E  ; 2 shared bytes

    GAP                     152
    RESERVE cur_pal,        32 ; $03C0       ; 32 bytes
    inroom_pal      = cur_pal+$20 ; 16 bytes
    tmp_pal         = $03F0       ; 16 bytes
    GAP                     32
    RESERVE tileset_data,   400 ; $0400 $400 bytes -- must be on page bound
    GAP                     496
    mm_drawbuf      = $0500  ;$100 bytes, shared, should be on page bound, but don't think it's absolutely required
    mm_mapbuf       = $0600  ; same
    mm_mapbuf2      = $0700  ; same

    tileset_prop    = tileset_data  ; 256 bytes, 2 bytes per tile
    tsa_ul          = tileset_data+$100  ; 128 bytes
    tsa_ur          = tileset_data+$180  ; 128
    tsa_dl          = tileset_data+$200  ; 128
    tsa_dr          = tileset_data+$280  ; 128
    tsa_attr        = tileset_data+$300  ; 128
    load_map_pal    = tileset_data+$380  ; $30  (shared with draw_buf -- hence only for loading)


    RESERVE draw_buf,        128    ; $0780  ; 128
    draw_buf_ul     = draw_buf
    draw_buf_ur     = draw_buf + $10
    draw_buf_dl     = draw_buf + $20
    draw_buf_dr     = draw_buf + $30
    draw_buf_attr   = draw_buf + $40
    draw_buf_at_hi  = draw_buf + $50
    draw_buf_at_lo  = draw_buf + $60
    draw_buf_at_msk = draw_buf + $70



.ifdef _DEFINE_MEMORY
    .segment "PRG_RAM"
.endif

    unsram          = $6000  ; $400 bytes
    sram            = $6400  ; $400 bytes
    sram_checksum   = sram + $FD
    sram_assert_55  = sram + $FE
    sram_assert_AA  = sram + $FF

    RESERVE ship_vis,           1 ; $6000
    RESERVE ship_x,             1 ; $6001
    RESERVE ship_y,             1 ; $6002
    GAP                         1
    RESERVE airship_vis,        1 ; $6004
    RESERVE airship_x,          1 ; $6005
    RESERVE airship_y,          1 ; $6006
    GAP                         1
    RESERVE bridge_vis,         1 ; $6008
    RESERVE bridge_x,           1 ; $6009
    RESERVE bridge_y,           1 ; $600A
    GAP                         1
    RESERVE canal_vis,          1 ; $600C
    RESERVE canal_x,            1 ; $600D
    RESERVE canal_y,            1 ; $600E
    GAP                         1
    RESERVE unsram_ow_scroll_x, 1 ; $6010
    RESERVE unsram_ow_scroll_y, 1 ; $6011
    RESERVE has_canoe,          1 ; $6012 ; (not to be confused with item_canoe)
    GAP                         1
    RESERVE unsram_vehicle,     1 ; $6014
    GAP                         1
    RESERVE bridgescene,        1 ; $6016  ; 00=hasn't happened yet. 01=happens when move is complete, 80=already has happened
    GAP                         5
    RESERVE gold,               3 ; $601C   ; 3 bytes
    GAP                         1
    RESERVE items,              0 ; $6020
    RESERVE item_lute,          1 ; $6020
    RESERVE item_crown,         1 ; $6021
    RESERVE item_crystal,       1 ; $6022
    RESERVE item_herb,          1 ; $6023
    RESERVE item_mystickey,     1 ; $6024
    RESERVE item_tnt,           1 ; $6025
    RESERVE item_adamant,       1 ; $6026
    RESERVE item_slab,          1 ; $6027
    RESERVE item_ruby,          1 ; $6028
    RESERVE item_rod,           1 ; $6029
    RESERVE item_floater,       1 ; $602A
    RESERVE item_chime,         1 ; $602B
    RESERVE item_tail,          1 ; $602C
    RESERVE item_cube,          1 ; $602D
    RESERVE item_bottle,        1 ; $602E
    RESERVE item_oxyale,        1 ; $602F
    RESERVE item_canoe,         1 ; $6030
    RESERVE item_orb_start,     0 ; $6031
    RESERVE orb_fire,           1 ; $6032
    RESERVE orb_water,          1 ; $6032
    RESERVE orb_air,            1 ; $6033
    RESERVE orb_earth,          1 ; $6034
    RESERVE item_qty_start,     0 ; $6035
    RESERVE item_tent,          1 ; $6036
    RESERVE item_cabin,         1 ; $6036
    RESERVE item_house,         1 ; $6037
    RESERVE item_heal,          1 ; $6038
    RESERVE item_pure,          1 ; $6039
    RESERVE item_soft,          1 ; $603A
    RESERVE item_stop,          1 ; $603B

    ch_stats        = unsram + $0100  ; MUST be on page bound.  Each character allowed $40 bytes, so use 00,40,80,C0 to index ch_stats

    ch_class        = ch_stats + $00
    ch_ailments     = ch_stats + $01
    ch_name         = ch_stats + $02  ; 4 bytes

    ch_exp          = ch_stats + $07  ; 3 bytes
    ch_curhp        = ch_stats + $0A  ; 2 bytes
    ch_maxhp        = ch_stats + $0C  ; 2 bytes

    ch_str          = ch_stats + $10
    ch_agil         = ch_stats + $11
    ch_int          = ch_stats + $12
    ch_vit          = ch_stats + $13
    ch_luck         = ch_stats + $14

    ch_exptonext    = ch_stats + $16  ; 2 bytes -- only for user display, not actually used.
    ch_weapons      = ch_stats + $18  ; 4
    ch_armor        = ch_weapons + 4  ; 4

    ch_substats     = ch_stats + $20
    ch_dmg          = ch_substats + $00
    ch_hitrate      = ch_substats + $01
    ch_absorb       = ch_substats + $02
    ch_evade        = ch_substats + $03
    ch_resist       = ch_substats + $04
    ch_magdef       = ch_substats + $05

    ch_level        = ch_stats + $26        ; OB this is 0 based, IB this is 1 based

    game_flags      = unsram + $0200  ; must be on page bound

    ; Out of battle, spell data is stored stupidly so valid values are only 00-08, where 01 to 08 are actual spells
    ;   and 00 is 'empty'.  Each spell is conceptually in a "slot" that belongs to each spell level.  Therefore,
    ;   both CURE and LAMP are stored as '01' because they're both the first spell in their level, but because
    ;   they're in a different level slot, the game distinguishes them.
    ; In battle, fortunately, that is thrown out the window (why does it do it at all?) and the spells are stored
    ;   in a logical 1-based index where the level simply doesn't matter.

    ch_magicdata    = unsram + $0300  ; must be on page bound
      ch_spells       = ch_magicdata
      ch_mp           = ch_magicdata + $20
      ch_curmp        = ch_mp + $00
      ch_maxmp        = ch_mp + $08
      
      
    btl_chstats         = $6800  ; $12 bytes per character
      btlch_slotindex   = $00
      btlch_class       = $01
      btlch_ailments    = $02       ; appears not to be used?  OB always seems to be used
      btlch_hp          = $03       ; appears not to be used?  OB always seems to be used
      btlch_hitrate     = $05
      btlch_magdef      = $06
      btlch_evade       = $07
      btlch_absorb      = $08
      btlch_dmg         = $09
      btlch_elemresist  = $0A
      btlch_numhitsmult = $0B
      btlch_numhits     = $0C
      btlch_category    = $0D           ; always 0 since players have no category assigned
      btlch_elemweak    = $0E           ; always 0 (players can't have weaknesses)
      btlch_critrate    = $0F
      btlch_wepgfx      = $10
      btlch_wepplt      = $11

      
    btl_turnorder       = $6848         ; $D entries (9 enemies + 4 characters)
      
    ;; Battle stuff
        MATHBUF_HITCHANCE           = 0
        MATHBUF_BASEDAMAGE          = 1
        MATHBUF_NUMHITS             = 2
        MATHBUF_MAGRANDHIT          = 2
        MATHBUF_CATEGORY            = 3
        MATHBUF_ELEMENT             = 4
        MATHBUF_RANDHIT             = 4
        MATHBUF_DMGCALC             = 5
        MATHBUF_CRITCHANCE          = 6
        MATHBUF_AILMENTCHANCE       = 7
        MATHBUF_MAGDEFENDERHP       = $12
        MATHBUF_DEFENDERHP          = $13
        MATHBUF_MAGDEFENDERMAXHP    = $15
        MATHBUF_TOTALDAMAGE         = $16
        
    btl_mathbuf = $6856     ; $14 bytes?, 2 byte pairs, used as buffers for mathematical routines
        math_hitchance      = btl_mathbuf + (MATHBUF_HITCHANCE*2)   ; $6856
        math_basedamage     = btl_mathbuf + (MATHBUF_BASEDAMAGE*2)  ; $6858
        math_numhits        = btl_mathbuf + (MATHBUF_NUMHITS*2)     ; $685A
        math_magrandhit     = btl_mathbuf + (MATHBUF_MAGRANDHIT*2)  ; $685A
        math_category       = btl_mathbuf + (MATHBUF_CATEGORY*2)    ; $685C not really math... but whatever
        math_element        = btl_mathbuf + (MATHBUF_ELEMENT*2)     ; $685E not really math... but whatever
        math_randhit        = btl_mathbuf + (MATHBUF_RANDHIT*2)     ; $685E
        math_dmgcalc        = btl_mathbuf + (MATHBUF_DMGCALC*2)     ; $6860
        math_critchance     = btl_mathbuf + (MATHBUF_CRITCHANCE*2)  ; $6862
        math_ailmentchance  = btl_mathbuf + (MATHBUF_AILMENTCHANCE*2);$6864
        ;btl_defender_hp             = btl_mathbuf + (MATHBUF_DEFENDERHP*2)  ; $687C -- treated as part of math buffer by some code
        ;battle_totaldamage          = btl_mathbuf + (MATHBUF_TOTALDAMAGE*2)  ; $6882 -- treated as part of math buffer by some code
        ;btlmag_defender_hp                      = btl_mathbuf + (MATHBUF_MAGDEFENDERHP*2)  ; $687A
        ;btlmag_defender_hpmax                   = btl_mathbuf + (MATHBUF_MAGDEFENDERMAXHP*2)  ; $6880

    theend_drawbuf  = $6800     ; $700 bytes!
        
    GAP                                     2080
    RESERVE btlmag_spellconnected,          1 ; $685C
    GAP                                     9
    RESERVE battle_ailmentrandchance,       1 ; $6866
    GAP                                     3
    RESERVE battle_hitsconnected,           1 ; $686A     ; number of hits actually connected
    RESERVE battle_critsconnected,          1 ; $686B
    RESERVE btlmag_attacker_unk686C,        0 ; $686C ; Enemy:  ailments              Player:  ailments
    RESERVE btl_attacker_strength,          1 ; $686C
    RESERVE btlmag_defender_ailments,       0 ; $686D
    RESERVE btl_attacker_category,          1 ; $686D
    RESERVE btlmag_effect,                  0 ; $686E
    RESERVE btl_attacker_element,           1 ; $686E
    RESERVE btl_attacker_hitrate,           1 ; $686F
    RESERVE btlmag_hitrate,                 0 ; $6870
    RESERVE btl_attacker_numhitsmult,       1 ; $6870
    RESERVE btl_attacker_numhits,           1 ; $6871
    RESERVE btlmag_defender_magdef,         0 ; $6872
    RESERVE btl_attacker_critrate,          1 ; $6872
    RESERVE btlmag_defender_unknownRawInit0,0 ; $6873
    RESERVE btl_attacker_attackailment,     1 ; $6873
    RESERVE btlmag_effectivity,             1 ; $6874
    RESERVE btlmag_attacker_unk6875,        1 ; $6875 ; Enemy:  ai                    Player:  damage
    RESERVE btlmag_defender_elemweakness,   0 ; $6876
    RESERVE eob_gp_reward,                  0 ; $6876
    RESERVE btl_defender_category,          1 ; $6876
    RESERVE btlmag_defender_elemresist,     0 ; $6877
    RESERVE btl_defender_elemweakness,      1 ; $6877
    RESERVE btlmag_element,                 0 ; $6878
    RESERVE btl_defender_evade,             0 ; $6878
    RESERVE eob_exp_reward,                 1 ; $6878
    RESERVE btlmag_attacker_unk6879,        0 ; $6879 ; Enemy:  high byte of GP       Player:  class
    RESERVE btl_defender_absorb,            1 ; $6879
    RESERVE btlmag_defender_hp,             0 ; $687A
    RESERVE btl_defender_magdef,            1 ; $687A
    RESERVE btl_defender_elemresist,        1 ; $687B
    RESERVE btl_defender_hp,                1 ; $687C
    RESERVE btlmag_defender_numhitsmult,    1 ; $687D
    RESERVE btlmag_defender_morale,         1 ; $687E
    RESERVE btlmag_defender_absorb,         1 ; $687F
    RESERVE btlmag_defender_hpmax,          0 ; $6880
    RESERVE btl_attacker_graphic,           1 ; $6880     ; the graphic used for an attack
    RESERVE btl_attacker_varplt,            1 ; $6881     ; The variable palette color used for an attack
    RESERVE battle_totaldamage,             0 ; $6882
    RESERVE btlmag_defender_strength,       1 ; $6882
    RESERVE btlmag_attacker_unk6883,        1 ; $6883 ; Enemy:  0                     Player:  level
    RESERVE battle_attacker_index,          0 ; $6884 ; ?? redundant??  why not just use btl_attacker?
    RESERVE btlmag_attacker_unk6884,        1 ; $6884 ; Enemy:  damage                Player:  hit rate
    RESERVE battle_defender_index,          0 ; $6885 ; same... but this is necessary for output!  See Battle_DoTurn in bank C!!
    RESERVE btlmag_defender_evade,          1 ; $6885  ; shared with battle_defender_index?  Is that not used for btlmag ?
    RESERVE btlmag_defender_category,       1 ; $6886
    RESERVE battle_defenderisplayer,        1 ; $6887 ; nonzero if player is defending, zero if enemy is defending 
    RESERVE btl_attacker_ailments,          1 ; $6888 ;   important for output!  See Battle_DoTurn in bank C
    RESERVE btl_defender_ailments,          1 ; $6889 ; important for output!
    RESERVE btl_rngstate,                   1 ; $688A    ; State of RNG used for in-battle
    RESERVE btltmp_divLo,                   1 ; $688B
    RESERVE btltmp_divHi,                   1 ; $688C
    RESERVE btltmp_divV,                    1 ; $688D
    RESERVE btl_curturn,                    1 ; $688E         ; current turn (index for btl_turnorder)
    RESERVE btl_charcmdbuf,                 16 ; $688F
    RESERVE char_order_buf,                 0 ; $689F
    RESERVE btl_charcmditem,                1 ; $689F
    GAP                                     3
    RESERVE btl_charcmdconsumetype,         1 ; $68A3
    GAP                                     3
    RESERVE btl_charcmdconsumeid,           1 ; $68A7
    GAP                                     7
    RESERVE btl8x8spr_x,                    2 ; $68AF ; X coord ;  +1 used in drawing code as original position ; These next 5 vars are all in temp memory, and are mostly just used for passing into BattleDraw8x8Sprite
    RESERVE btl8x8spr_y,                    2 ; $68B1 ; Y coord ;  +1 used in drawing code as original position
    RESERVE btl_tmpindex,                   0 ; $68B3 ; temporary holder for a current index
    RESERVE btltmp_multA,                   0 ; $68B3 ; shared
    RESERVE btltmp_boxleft,                 0 ; $68B3
    RESERVE btl_input,                      0 ; $68B3
    RESERVE btl8x8spr_a,                    1 ; $68B3 ; attribute
    RESERVE btltmp_multB,                   0 ; $68B4    ; shared
    RESERVE btl_tmpchar,                    0 ; $68B4 ; temporary holder for a 0-based character index
    RESERVE btltmp_boxcenter,               0 ; $68B4
    RESERVE btl8x8spr_t,                    1 ; $68B4 ; tile ID
    RESERVE btl8x8spr_i,                    0 ; $68B5 ; slot to draw to (00-3F)
    RESERVE btltmp_boxright,                0 ; $68B5
    RESERVE btltmp_multC,                   1 ; $68B5
    GAP                                     1
    RESERVE btl_soft2000,                   1 ; $68B7    ; soft copy of $2000 used in battles
    RESERVE btl_soft2001,                   1 ; $68B8    ; soft copy of $2001 used in battles
    GAP                                     1
    RESERVE btlbox_blockdata,               1 ; $68BA
    GAP                                     99
    RESERVE btl_msgbuffer,                  384 ; $691E   ; $180 bytes  ($0C rows * $20 bytes per row); this buffer contains on-screen tiles to be drawn to ppu$2240; (note only $19 bytes are actually drawn, the remaining 7 bytes are padding)
    RESERVE btl_msgdraw_hdr,                1 ; $6A9E
    RESERVE btl_msgdraw_x,                  1 ; $6A9F
    RESERVE btl_msgdraw_y,                  1 ; $6AA0
    RESERVE btl_msgdraw_srcptr,             0 ; $6AA1  ; shared ; 2 bytes
    RESERVE btl_msgdraw_width,              1 ; $6AA1
    RESERVE btl_msgdraw_height,             1 ; $6AA2
    RESERVE btl_msgdraw_blockcount,         1 ; $6AA3      ; the number of blocks drawn
    GAP                                     2
    RESERVE btlinput_prevstate,             0 ; $6AA6 ; prev state for input
    RESERVE eobbox_slotid,                  1 ; $6AA6
    RESERVE inputdelaycounter,              0 ; $6AA7     ; counter to delay multiple-input processing when holding a direction
    RESERVE eobbox_textid,                  1 ; $6AA7
    GAP                                     1
    RESERVE btl_animatingchar,              1 ; $6AA9     ; the character currently being animated (0-3)
    RESERVE btlcurs,                        0 ; $6AAA
    RESERVE btlcurs_x,                      1 ; $6AAA     ; battle cursor X position (menu position, not pixel position)
    RESERVE btlcurs_max,                    0 ; $6AAB     ; highest value for the cursor
    RESERVE btlcurs_y,                      1 ; $6AAB     ; battle cursor Y position (menu position, not pixel position)
    RESERVE btlcurs_positions,              1 ; $6AAC     ; ?? bytes, 2 bytes per entry, each entry is the pixel coord of where the cursor should be drawn when its item is selected.
    GAP                                     36
    RESERVE btl_drawflagsA,                 1 ; $6AD1  ; bits 0-3 = set to indicate character should be drawn as dead ; bit    4 = set to draw battle cursor ; bit    5 = set to draw weapon attack graphic ; bit    6 = set to draw magic graphic & flash BG.
    RESERVE btl_drawflagsB,                 1 ; $6AD2  ; bits 0-4 = set to indicate character should be drawn as stone
    RESERVE btl_chardrawinfo,               0 ; $6AD3        ;$10 bytes, 4 bytes for each character
    RESERVE btl_chardraw_x,                 1 ; $6AD3
    RESERVE btl_chardraw_y,                 1 ; $6AD4
    RESERVE btl_chardraw_gfxset,            1 ; $6AD5
    RESERVE btl_chardraw_pose,              1 ; $6AD6
    GAP                                     12
    RESERVE btlcursspr_x,                   1 ; $6AE3
    RESERVE btlcursspr_y,                   1 ; $6AE4
    RESERVE btlattackspr_x,                 1 ; $6AE5
    RESERVE btlattackspr_y,                 1 ; $6AE6
    RESERVE btlattackspr_t,                 1 ; $6AE7     ; indicate which tile to draw for the weapon graphic
    RESERVE btlattackspr_pose,              1 ; $6AE8     ; for weapons, 0 or 8 to indicate whether or not to flip it for magic, 0 or ?4? to indicate which frame to draw
    RESERVE btlattackspr_gfx,               1 ; $6AE9     ; copied to 't' prior to drawing.  Indicates which graphic to use
    RESERVE btlattackspr_wepmag,            1 ; $6AEA     ; 0 for drawing the weapon, 1 for drawing the magic
    GAP                                     2
    RESERVE btlattackspr_hidell,            1 ; $6AED     ; nonzero to hide the lower-left tile of the attack graphic, this is done for the "behind the back" frame of weapon swing animation.
    RESERVE btlattackspr_nodraw,            1 ; $6AEE     ; nonzero to hide the weapon/magic sprite entirely. This is used when a non-BB player attacks without any weapon equipped Also used when using ITEMs to supress the magic flashing effect.
    RESERVE btltmp_targetlist,              9 ; $6AEF     ; temporary buffer (9 entries) containing possible targets
    RESERVE btl_combatboxcount,             1 ; $6AF8     ; the number of combat boxes that have been drawn
    GAP                                     1
    RESERVE btl_unfmtcbtbox_buffer,         128 ; $6AFA  ; $80 bytes total, $10 bytes for each combat box. houses the unformatted text for each combat box. Additional bytes are used for other areas
    RESERVE btlcmd_curchar,                 1 ; $6B7A     ; the current character inputting battle commands (0-3)
    RESERVE btlcmd_target,                  1 ; $6B7B     ; the current enemy slot that is being targetted
    GAP                                     2
    RESERVE btlcmd_magicgfx,                8 ; $6B7E     ; 2 bytes per character.  [0] = graphic to draw, [1] = palette to use
    RESERVE btl_result,                     1 ; $6B86 ;   0 = keep battling ;   1 = party defeated ;   2 = all enemies defeated ;   3 = party ran ; $FF = wait for 2 seconds after fadeout before exiting (chaos defeated?)
    RESERVE btl_usepalette,                 32; $6B87 ; $20 bytes - the palette that is actually displayed (after fade effects)
    RESERVE btl_followupmusic,              1 ; $6BA7 ; song to play in battle after current song finishes.  Moved to music_track once music_track has its high bit set  (does this ever happen?)
    RESERVE btl_charattrib,                 4 ; $6BA8 ; attributes to use when drawing charcters in battle  (4 bytes, 1 for each)
    RESERVE btl_responddelay,               1 ; $6BAC
    GAP                                     1
    RESERVE btl_strikingfirst,              1 ; $6BAE ; nonzero if players are striking first.  Zero otherwise
    RESERVE btl_potion_heal,                1 ; $6BAF ; battle containers for Heal/Pure potions.  Stored separately because
    RESERVE btl_potion_pure,                1 ; $6BB0 ;  it can fall out of sync with the ACTUAL items (if a character trying to use one dies, for example)
    RESERVE battle_bank,                    1 ; $6BB1  ; The bank to jump back to for setting up battles
    RESERVE btl_smallslots,                 1 ; $6BB2             ; Number of small enemy slots available
    RESERVE btl_largeslots,                 1 ; $6BB3  ; Number of large slots available.  Must immediately follow smallslots
    GAP                                     2
    RESERVE btl_enemyeffect,                1 ; $6BB6     ; 0 to draw expolosion graphics as the effect nonzero to erase the enemy as the effect
    RESERVE btl_enemyIDs,                   9 ; $6BB7  ; 9 entries of enemy IDs
    RESERVE btl_enemygfxplt,                9 ; $6BC0  ; 9 entries of enemy graphic and palette assignment (graphic in high 2 bits, plt in low bit)
    RESERVE btl_enemyroster,                4 ; $6BC9  ; 4 bytes of enemy IDs printed in the main battle menu, showing enemies in the fight
    RESERVE btl_attacker_alt,               1 ; $6BCD ; An EXTREMELY redundant and stupid copy of btl_attacker
    GAP                                     1
    RESERVE btl_randomplayer,               1 ; $6BCF ; set by GetRandomPlayerTarget  (0-3)
    GAP                                     3
    RESERVE btl_enemystats,                 1 ; $6BD3  ; $14 bytes per enemy - data does NOT match how it is stored in ROM
    GAP                                     44
    RESERVE bigstr_buf,                     0 ; $6C00   ; $81 bytes?
    RESERVE lutmp_ch_stats,                 1 ; $6C00 ; temporary space used by the lineup menu
    GAP                                     135
    RESERVE btl_tmppltassign,               1 ; $6C88    ; temporary value to assign palette to enemies in a formation
    RESERVE btl_attacker,                   1 ; $6C89
    RESERVE btl_defender,                   1 ; $6C8A
    RESERVE btl_combatboxcount_alt,         1 ; $6C8B ; ANOTHER combatbox counter... this is totally redundant
    RESERVE btl_attackid,                   1 ; $6C8C ; >= $42 for enemy attacks
    GAP                                     2
    RESERVE btlmag_magicsource,             1 ; $6C8F ; 0=magic, 1=drink, 2=item
    RESERVE btlmag_ailment_orig,            1 ; $6C90 ; A backup of 
    GAP                                     1
    RESERVE btl_battletype,                 1 ; $6C92     ; 0=9 small, 1=4 large, 2=mix, 3=fiend, 4=chaos
    RESERVE btl_enemycount,                 1 ; $6C93     ; count of the number of enemies being generated for a battle
    RESERVE btltmp_attr,                    40 ; $6C94     ; $40 bytes of attribute data for the battle setup
    GAP                                     24
    RESERVE btl_stringoutputbuf,            1 ; $6CD4 ; output buffer where decoded strings are printed
    GAP                                     43
    RESERVE lutmp_ch_magic,                 1 ; $6D00
    GAP                                     19
    RESERVE loop_counter,                   0 ; $6D14; action buffer?  $20 bytes?  contents for combat boxes are placed here?
    RESERVE explode_min_x,                  1 ; $6D14
    RESERVE explode_min_y,                  1 ; $6D15
    RESERVE explode_max_x,                  1 ; $6D16
    RESERVE explode_max_y,                  1 ; $6D17
    RESERVE explode_count,                  1 ; $6D18
    RESERVE btltmp_altmsgbuffer,            1 ; $6D19
    GAP                                     18
    RESERVE btltmp_attackerbuffer,          1 ; $6D2C
    GAP                                     7
    RESERVE btl_palettes,                   1 ; $6D34   ; $20 bytes
    GAP                                     31
    RESERVE btl_stringbuf,                  1 ; $6D54   ; $20 byte buffer to contain string data for printing
    GAP                                     31
    RESERVE btltmp_backseat,                1 ; $6D74   ; $10 byte buffer -- backup of btltmp
    GAP                                     15
    RESERVE btlform_type,                   0 ; $6D84   ; battle type (high 4 bits) -- low 4 bits are pattern table
    RESERVE btl_formdata,                   1 ; $6D84   ; $10 bytes (formation data as appears in ROM)
    RESERVE btlform_engfx,                  1 ; $6D85   ; graphic assignment (2 bits per enemy)
    RESERVE btlform_enids,                  4 ; $6D86   ; enemy IDs (4 bytes)
    RESERVE btlform_enqty,                  4 ; $6D8A   ; enemy quantities (4 bytes)
    RESERVE btlform_plts,                   2 ; $6D8E   ; palettes for this battle (2 bytes)
    RESERVE btlform_surprise,               1 ; $6D90   ; surprise rate
    RESERVE btlform_enplt,                  0 ; $6D91   ; enemy palette assign (in high 4 bits)
    RESERVE btlform_norun,                  1 ; $6D91   ; no run flag (in low bit)
    RESERVE btlform_enqtyB,                 2 ; $6D92   ; enemy quantities for B formation (2 bytes)
    RESERVE btlmag_fakeout_ailments,        1 ; $6D94 ;   what these 'fakeout' vars are and how/why they're used
    RESERVE btlmag_fakeout_defindex,        1 ; $6D95 ; See Battle_DoTurn in bank C for a description of
    RESERVE btlmag_fakeout_defplayer,       1 ; $6D96
    RESERVE btlsfx_backseat,                1 ; $6D97 ; where it is stored when not in zero page (it swaps between the two)
    GAP                                     15
    RESERVE btlmag_playerhitsfx,            1 ; $6DA7     ; sound effect to play when magic hits player
    GAP                                     8
    RESERVE btltmp_smallslotpos,            1 ; $6DB0
    GAP                                     334
    RESERVE mapobj,                         1 ; $6F00   ; $100 bytes -- page
    RESERVE mapobj_id,                      1 ; $6F00  ; rearranging these is ill advised
    RESERVE mapobj_flgs,                    1 ; $6F01  ;  because the loader is pretty rigid
    RESERVE mapobj_physX,                   1 ; $6F02  ;  flags:  $80=inroom $40=don't move
    RESERVE mapobj_physY,                   1 ; $6F03
    RESERVE mapobj_gfxX,                    1 ; $6F04
    RESERVE mapobj_gfxY,                    1 ; $6F05
    RESERVE mapobj_ctrX,                    1 ; $6F06
    RESERVE mapobj_ctrY,                    1 ; $6F07
    RESERVE mapobj_spdX,                    1 ; $6F08
    RESERVE mapobj_spdY,                    1 ; $6F09
    RESERVE mapobj_rawid,                   1 ; $6F0A
    RESERVE mapobj_movectr,                 1 ; $6F0B
    RESERVE mapobj_face,                    1 ; $6F0C
    RESERVE mapobj_pl,                      1 ; $6F0D   ; bit 7 = talking to player (changes facing), other bits = being shoved by player
    RESERVE mapobj_tsaptr,                  1 ; $6F0E
    GAP                                     241
    RESERVE mapdata,                        1 ; $7000   ; must be on $1000 byte bound (ie:  pretty much unmovable)
    RESERVE mm_decorchr,                    1 ; $7000   ; $300 bytes -- should be on page bound, shared
    GAP                                     766
    RESERVE mm_titlechr,                    1 ; $7300   ; $280 bytes -- should be on page bound, shared




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


