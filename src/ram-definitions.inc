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
    RESERVEZP ch_scoreptr,        1   ; $00
    GAP                           1   ;
    RESERVEZP ch_envptr,          1   ; $02 ptr to start of env data
    GAP                           1
    RESERVEZP ch_envpos,          1   ; $04 pos in env data (00-1F)
    RESERVEZP ch_lenctr,          1   ; $05 counter for score data (note length)
    RESERVEZP ch_frqtblptr,       1   ; $06 pointer to freq table (changes per octave)
    RESERVEZP story_dropinput,    1   ; $07
    RESERVEZP ch_lentblptr,       1   ; $08 pointer to length table (changes per tempo)
    GAP                           1
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

    RESERVE ship_vis,           1 ; $00
    RESERVE ship_x,             1 ; $01
    RESERVE ship_y,             1 ; $02
    GAP                         1
    RESERVE airship_vis,        1 ; $04
    RESERVE airship_x,          1 ; $05
    RESERVE airship_y,          1 ; $06
    GAP                         1
    RESERVE bridge_vis,         1 ; $08
    RESERVE bridge_x,           1 ; $09
    RESERVE bridge_y,           1 ; $0A
    GAP                         1
    RESERVE canal_vis,          1 ; $0C
    RESERVE canal_x,            1 ; $0D
    RESERVE canal_y,            1 ; $0E
    GAP                         1
    RESERVE unsram_ow_scroll_x, 1 ; $10
    RESERVE unsram_ow_scroll_y, 1 ; $11
    RESERVE has_canoe,          1 ; $12 ; (not to be confused with item_canoe)
    RESERVE unsram_vehicle,     1 ; $14
    GAP                         1
    RESERVE bridgescene,        1 ; $16  ; 00=hasn't happened yet. 01=happens when move is complete, 80=already has happened
    GAP                         5
    RESERVE gold,               3 ; $1C   ; 3 bytes
    items           = unsram + $20

    item_lute       = items + $01
    item_crown      = items + $02
    item_crystal    = items + $03
    item_herb       = items + $04
    item_mystickey  = items + $05
    item_tnt        = items + $06
    item_adamant    = items + $07
    item_slab       = items + $08
    item_ruby       = items + $09
    item_rod        = items + $0A
    item_floater    = items + $0B
    item_chime      = items + $0C
    item_tail       = items + $0D
    item_cube       = items + $0E
    item_bottle     = items + $0F
    item_oxyale     = items + $10
    item_canoe      = items + $11
    item_orb_start  = items + $12
      orb_fire        = item_orb_start + 0
      orb_water       = item_orb_start + 1
      orb_air         = item_orb_start + 2
      orb_earth       = item_orb_start + 3
    item_qty_start  = item_orb_start + 4
      item_tent       = item_qty_start + 0
      item_cabin      = item_qty_start + 1
      item_house      = item_qty_start + 2
      item_heal       = item_qty_start + 3
      item_pure       = item_qty_start + 4
      item_soft       = item_qty_start + 5
    item_stop       = item_qty_start + 6

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
        
    eob_gp_reward               = $6876
    eob_exp_reward              = $6878
        

    battle_ailmentrandchance    = $6866

    battle_hitsconnected        = $686A     ; number of hits actually connected
    battle_critsconnected       = $686B
    btl_attacker_strength       = $686C
    btl_attacker_category       = $686D
    btl_attacker_element        = $686E
    btl_attacker_hitrate        = $686F
    btl_attacker_numhitsmult    = $6870
    btl_attacker_numhits        = $6871
    btl_attacker_critrate       = $6872
    btl_attacker_attackailment  = $6873

    btl_defender_category       = $6876
    btl_defender_elemweakness   = $6877
    btl_defender_evade          = $6878
    btl_defender_absorb         = $6879
    btl_defender_magdef         = $687A
    btl_defender_elemresist     = $687B
    btl_defender_hp             = btl_mathbuf + (MATHBUF_DEFENDERHP*2)  ; $687C -- treated as part of math buffer by some code

    btl_attacker_graphic        = $6880     ; the graphic used for an attack
    btl_attacker_varplt         = $6881     ; The variable palette color used for an attack

    battle_totaldamage          = btl_mathbuf + (MATHBUF_TOTALDAMAGE*2)  ; $6882 -- treated as part of math buffer by some code

    ;; Battle stuff for magical attacks

    btlmag_spellconnected       = $685C
    btlmag_defender_ailments    = $686D
    btlmag_effect               = $686E
    btlmag_hitrate              = $6870
    btlmag_defender_magdef               = $6872
    btlmag_defender_unknownRawInit0      = $6873
    btlmag_effectivity          = $6874
    btlmag_defender_elemweakness         = $6876
    btlmag_defender_elemresist           = $6877
    btlmag_element              = $6878

    btlmag_attacker_unk686C     = $686C ; Enemy:  ailments              Player:  ailments
    btlmag_attacker_unk6875     = $6875 ; Enemy:  ai                    Player:  damage
    btlmag_attacker_unk6879     = $6879 ; Enemy:  high byte of GP       Player:  class
    btlmag_attacker_unk6883     = $6883 ; Enemy:  0                     Player:  level
    btlmag_attacker_unk6884     = $6884 ; Enemy:  damage                Player:  hit rate

    btlmag_defender_hp          = btl_mathbuf + (MATHBUF_MAGDEFENDERHP*2)  ; $687A
    btlmag_defender_numhitsmult = $687D
    btlmag_defender_morale      = $687E
    btlmag_defender_absorb      = $687F
    btlmag_defender_hpmax       = btl_mathbuf + (MATHBUF_MAGDEFENDERMAXHP*2)  ; $6880
    btlmag_defender_strength    = $6882

    btlmag_defender_evade       = $6885  ; shared with battle_defender_index?  Is that not used for btlmag ?
    btlmag_defender_category    = $6886

    btlmag_fakeout_defindex     = $6D95 ; See Battle_DoTurn in bank C for a description of
    btlmag_fakeout_ailments     = $6D94 ;   what these 'fakeout' vars are and how/why they're used
    btlmag_fakeout_defplayer    = $6D96
                                
                                        ; These two are kind of redundant
    battle_attacker_index       = $6884 ; ?? redundant??  why not just use btl_attacker?
    battle_defender_index       = $6885 ; same... but this is necessary for output!  See Battle_DoTurn in bank C!!

    battle_defenderisplayer     = $6887 ; nonzero if player is defending, zero if enemy is defending 
                                        ;   important for output!  See Battle_DoTurn in bank C

    btl_attacker_ailments       = $6888
    btl_defender_ailments       = $6889 ; important for output!

    btl_rngstate = $688A    ; State of RNG used for in-battle

    btltmp_divLo = $688B
    btltmp_divHi = $688C
    btltmp_divV  = $688D

    btl_curturn         = $688E         ; current turn (index for btl_turnorder)

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

    btl_charcmdbuf          = $688F
    btl_charcmditem         = btl_charcmdbuf+$10        ; $689F
    btl_charcmdconsumetype  = btl_charcmditem+4         ; $68A3
    btl_charcmdconsumeid    = btl_charcmdconsumetype+4  ; $68A7

    char_order_buf          = $689F

    ; These next 5 vars are all in temp memory, and are mostly just used for 
    ;  passing into BattleDraw8x8Sprite
    btl8x8spr_x = $68AF ; X coord
                        ;  +1 used in drawing code as original position
    btl8x8spr_y = $68B1 ; Y coord
                        ;  +1 used in drawing code as original position
    btl8x8spr_a = $68B3 ; attribute
    btl8x8spr_t = $68B4 ; tile ID
    btl8x8spr_i = $68B5 ; slot to draw to (00-3F)
      
    btl_tmpindex = $68B3    ; temporary holder for a current index
    btl_tmpchar =  $68B4    ; temporary holder for a 0-based character index

    btltmp_multA = $68B3    ; shared
    btltmp_multB = $68B4    ; shared
    btltmp_multC = $68B5


    btltmp_boxleft   = $68B3
    btltmp_boxcenter = $68B4
    btltmp_boxright  = $68B5

    btl_input        = $68B3

    btl_soft2000 = $68B7    ; soft copy of $2000 used in battles
    btl_soft2001 = $68B8    ; soft copy of $2001 used in battles

    btlbox_blockdata    = $68BA
                        ; $68CF   ???

    btl_msgbuffer = $691E   ; $180 bytes  ($0C rows * $20 bytes per row)
                            ; this buffer contains on-screen tiles to be drawn to ppu$2240
                            ; (note only $19 bytes are actually drawn, the remaining 7 bytes are padding)

    btl_msgdraw_hdr     = $6A9E
    btl_msgdraw_x       = $6A9F
    btl_msgdraw_y       = $6AA0
    btl_msgdraw_width   = $6AA1
    btl_msgdraw_height  = $6AA2
    btl_msgdraw_srcptr  = $6AA1  ; shared
                        ; $6AA2    above +1

    btl_msgdraw_blockcount = $6AA3      ; the number of blocks drawn

    eobbox_slotid       = $6AA6
    eobbox_textid       = $6AA7

    btlinput_prevstate  = $6AA6     ; prev state for input
    inputdelaycounter   = $6AA7     ; counter to delay multiple-input processing when holding a direction

    btl_animatingchar   = $6AA9     ; the character currently being animated (0-3)

    btlcurs_x           = $6AAA     ; battle cursor X position (menu position, not pixel position)
    btlcurs_y           = $6AAB     ; battle cursor Y position (menu position, not pixel position)
    btlcurs             = $6AAA
    btlcurs_max         = $6AAB     ; highest value for the cursor
    btlcurs_positions   = $6AAC     ; ?? bytes, 2 bytes per entry, each entry is the pixel coord of where the
                                    ;   cursor should be drawn when its item is selected.

    btl_drawflagsA = $6AD1  ; bits 0-3 = set to indicate character should be drawn as dead
                            ; bit    4 = set to draw battle cursor
                            ; bit    5 = set to draw weapon attack graphic
                            ; bit    6 = set to draw magic graphic & flash BG.

    btl_drawflagsB = $6AD2  ; bits 0-4 = set to indicate character should be drawn as stone

    btl_chardrawinfo = $6AD3        ;$10 bytes, 4 bytes for each character
        btl_chardraw_x      = btl_chardrawinfo+0
        btl_chardraw_y      = btl_chardrawinfo+1
        btl_chardraw_gfxset = btl_chardrawinfo+2
        btl_chardraw_pose   = btl_chardrawinfo+3
        
    btlcursspr_x        = $6AE3
    btlcursspr_y        = $6AE4
    btlattackspr_x      = $6AE5
    btlattackspr_y      = $6AE6

    btlattackspr_t      = $6AE7     ; indicate which tile to draw for the weapon graphic
    btlattackspr_pose   = $6AE8     ; for weapons, 0 or 8 to indicate whether or not to flip it
                                    ; for magic, 0 or ?4? to indicate which frame to draw
    btlattackspr_gfx    = $6AE9     ; copied to 't' prior to drawing.  Indicates which graphic to use
    btlattackspr_wepmag = $6AEA     ; 0 for drawing the weapon, 1 for drawing the magic

    btlattackspr_hidell = $6AED     ; nonzero to hide the lower-left tile of the attack graphic
                                    ;   This is done for the "behind the back" frame of weapon swing animation.
    btlattackspr_nodraw = $6AEE     ; nonzero to hide the weapon/magic sprite entirely.  This is
                                    ;   Used when a non-BB player attacks without any weapon equipped
                                    ;   Also used when using ITEMs to supress the magic flashing effect.

    btltmp_targetlist   = $6AEF     ; temporary buffer (9 entries) containing possible targets

    btl_combatboxcount  = $6AF8     ; the number of combat boxes that have been drawn

    btl_unfmtcbtbox_buffer = $6AFA  ; $80 bytes total, $10 bytes for each combat box.
                                    ; houses the unformatted text for each combat box.
                                    ; Additional bytes are used for other areas
                                    
    btlcmd_curchar      = $6B7A     ; the current character inputting battle commands (0-3)
    btlcmd_target       = $6B7B     ; the current enemy slot that is being targetted

    btlcmd_magicgfx     = $6B7E     ; 2 bytes per character.  [0] = graphic to draw, [1] = palette to use

    btl_result          = $6B86 ;   0 = keep battling
                                ;   1 = party defeated
                                ;   2 = all enemies defeated
                                ;   3 = party ran
                                ; $FF = wait for 2 seconds after fadeout before exiting (chaos defeated?)

    btl_usepalette      = $6B87 ; $20 bytes - the palette that is actually displayed (after fade effects)

    btl_followupmusic   = $6BA7 ; song to play in battle after current song finishes.  Moved to music_track
                                ;    once music_track has its high bit set  (does this ever happen?)

    btl_charattrib      = $6BA8 ; attributes to use when drawing charcters in battle  (4 bytes, 1 for each)

    btl_responddelay    = $6BAC

    btl_strikingfirst   = $6BAE ; nonzero if players are striking first.  Zero otherwise

    btl_potion_heal     = $6BAF ; battle containers for Heal/Pure potions.  Stored separately because
    btl_potion_pure     = $6BB0 ;  it can fall out of sync with the ACTUAL items (if a character trying
                                ;  to use one dies, for example)

    battle_bank     = $6BB1  ; The bank to jump back to for setting up battles
    btl_smallslots  = $6BB2             ; Number of small enemy slots available
    btl_largeslots  = btl_smallslots+1  ; Number of large slots available.  Must immediately follow smallslots

    btl_enemyeffect = $6BB6     ; 0 to draw expolosion graphics as the effect
                                ;   nonzero to erase the enemy as the effect

    btl_enemyIDs =    $6BB7  ; 9 entries of enemy IDs
    btl_enemygfxplt = $6BC0  ; 9 entries of enemy graphic and palette assignment (graphic in high 2 bits, plt in low bit)

    btl_enemyroster = $6BC9  ; 4 bytes of enemy IDs printed in the main battle menu, showing enemies in the fight

    btl_attacker_alt    = $6BCD ; An EXTREMELY redundant and stupid copy of btl_attacker

    btl_randomplayer    = $6BCF ; set by GetRandomPlayerTarget  (0-3)

    btl_enemystats =  $6BD3  ; $14 bytes per enemy - data does NOT match how it is stored in ROM
        en_romptr       = $00  ; 2 bytes - pointer to enemy stats in ROM
        en_hp           = $02  ; 2 bytes
        en_defense      = $04
        en_numhitsmult  = $05
        en_ailments     = $06
        en_aimagpos     = $07
        en_aiatkpos     = $08
        en_morale       = $09
        en_evade        = $0A
        en_strength     = $0B
        en_ai           = $0C
        en_exp          = $0D  ; 2 bytes
        en_gp           = $0F  ; 2 bytes
        en_enemyid      = $11
        en_unknown12    = $12  ; low byte of HP max
        en_unknown13    = $13  ; not initialized?  probably suppoed to be high byte of HP max

    btl_tmppltassign = $6C88    ; temporary value to assign palette to enemies in a formation

    btl_attacker            = $6C89
    btl_defender            = $6C8A
    btl_combatboxcount_alt  = $6C8B ; ANOTHER combatbox counter... this is totally redundant
    btl_attackid            = $6C8C ; >= $42 for enemy attacks

    btlmag_magicsource      = $6C8F ; 0=magic, 1=drink, 2=item
    btlmag_ailment_orig     = $6C90 ; A backup of 
    btl_battletype  = $6C92     ; 0=9 small, 1=4 large, 2=mix, 3=fiend, 4=chaos
    btl_enemycount  = $6C93     ; count of the number of enemies being generated for a battle
    btltmp_attr     = $6C94     ; $40 bytes of attribute data for the battle setup

    ; temporary space used by the lineup menu
    lutmp_ch_stats  = $6C00
    lutmp_ch_magic  = $6D00


    bigstr_buf      = $6C00   ; $81 bytes?

    btl_stringoutputbuf = $6CD4 ; output buffer where decoded strings are printed

    explode_min_x   = $6D14
    explode_min_y   = $6D15
    explode_max_x   = $6D16
    explode_max_y   = $6D17
    explode_count   = $6D18

    btltmp_altmsgbuffer     = $6D19
    btltmp_attackerbuffer   = $6D2C

    ; ????          = $6D14   ; action buffer?  $20 bytes?  contents for combat boxes are placed here?

    btl_palettes    = $6D34   ; $20 bytes

    btl_stringbuf   = $6D54   ; $20 byte buffer to contain string data for printing

    btltmp_backseat = $6D74   ; $10 byte buffer -- backup of btltmp


    btl_formdata    = $6D84   ; $10 bytes (formation data as appears in ROM)
        btlform_type    = btl_formdata+$0   ; battle type (high 4 bits) -- low 4 bits are pattern table
        btlform_engfx   = btl_formdata+$1   ; graphic assignment (2 bits per enemy)
        btlform_enids   = btl_formdata+$2   ; enemy IDs (4 bytes)
        btlform_enqty   = btl_formdata+$6   ; enemy quantities (4 bytes)
        btlform_plts    = btl_formdata+$A   ; palettes for this battle (2 bytes)
        btlform_surprise= btl_formdata+$C   ; surprise rate
        btlform_enplt   = btl_formdata+$D   ; enemy palette assign (in high 4 bits)
        btlform_norun   = btlform_enplt     ; no run flag (in low bit)
        btlform_enqtyB  = btl_formdata+$E   ; enemy quantities for B formation (2 bytes)


    ; btlsfx_backseat   = $6D97

    btlmag_playerhitsfx = $6DA7     ; sound effect to play when magic hits player
    btltmp_smallslotpos = $6DB0

    mapobj          = $6F00   ; $100 bytes -- page
     mapobj_id      = mapobj + $00  ; rearranging these is ill advised
     mapobj_flgs    = mapobj + $01  ;  because the loader is pretty rigid
     mapobj_physX   = mapobj + $02  ;  flags:  $80=inroom $40=don't move
     mapobj_physY   = mapobj + $03
     mapobj_gfxX    = mapobj + $04
     mapobj_gfxY    = mapobj + $05
     mapobj_ctrX    = mapobj + $06
     mapobj_ctrY    = mapobj + $07
     mapobj_spdX    = mapobj + $08
     mapobj_spdY    = mapobj + $09
     mapobj_rawid   = mapobj + $0A
     mapobj_movectr = mapobj + $0B
     mapobj_face    = mapobj + $0C
     mapobj_pl      = mapobj + $0D   ; bit 7 = talking to player (changes facing), other bits = being shoved by player
     mapobj_tsaptr  = mapobj + $0E

    mapdata         = $7000   ; must be on $1000 byte bound (ie:  pretty much unmovable)

    mm_decorchr     = $7000   ; $300 bytes -- should be on page bound, shared
    mm_titlechr     = $7300   ; $280 bytes -- should be on page bound, shared




    theend_drawbuf  = $6800     ; $700 bytes!

    btlsfx_backseat     = $6D97 ; where it is stored when not in zero page (it swaps between the two)


