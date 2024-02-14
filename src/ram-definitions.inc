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
    GAP                                7
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
    .segment "BSS"
.endif



