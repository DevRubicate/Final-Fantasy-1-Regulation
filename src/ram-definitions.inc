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
    RESERVEZP ch_loopctr,         1   ; $0D remaining loop counter
    RESERVEZP ch_freq,            1   ; $0E output freq.  High bit set marks byte has been written (don't rewrite to reset duty)
    GAP                           1


    ;ch_scoreptr             = $00
    ;ch_envptr               = $02  ; ptr to start of env data
    ;ch_envpos               = $04  ; pos in env data (00-1F)
    ;ch_lenctr               = $05  ; counter for score data (note length)
    ;ch_frqtblptr            = $06  ; pointer to freq table (changes per octave)
    ;story_dropinput         = $07
    ;ch_lentblptr            = $08  ; pointer to length table (changes per tempo)
    ;ch_envrate              = $0A  ; rate/speed of env table traversal
    ;ch_envrem               = $0B  ; remaining "fraction" of env data (3 bits of fraction)
    ;ch_vol                  = $0C  ; output volume
    ;ch_loopctr              = $0D  ; remaining loop counter
    ;inroom                  = $0D ; bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
    ;ch_freq                 = $0E  ; output freq.  High bit set marks byte has been written (don't rewrite to reset duty)
    ;doorppuaddr             = $0E ; 2 bytes, PPU address of door drawing work









tmp                     = $10 ; 16 bytes
    mu_scoreptr         = tmp+8  ;2 bytes, shared tmp
    dlgbox_row          = tmp+$C  ; shared tmp
    palcyc_mode         = tmp+$C  ; shared tmp
joy                     = $20
joy_ignore              = $21
joy_select              = $22
joy_start               = $23
joy_a                   = $24
joy_b                   = $25
sprindex                = $26
ow_scroll_x             = $27  ; X scroll of OW in tiles
ow_scroll_y             = $28  ; Y scroll in tiles
sm_scroll_x             = $29  ; ditto, but for standard maps
sm_scroll_y             = $2A
mapdraw_x               = $2B
mapdraw_y               = $2C
mapflags                = $2D  ; bit 0 set when in standard map.  bit 1 set to indicate column drawing instead of row drawing
scroll_y                = $2F  ; Y scroll in tiles (16x16).  range=0-E
mapdraw_nty             = $30
mapdraw_ntx             = $31
mapdraw_job             = $32  ; 0=no job, 1=draw attribs, 2=draw tiles
mg_slidedir             = $33  ; shared
facing                  = $33  ; 1=R  2=L  4=D  8=U
move_speed              = $34  ; pixels to move per frame (map)
move_ctr_x              = $35  ; pixels between tiles (map movement -- 00-0F)
move_ctr_y              = $36  ; ditto but for Y axis
menustall               = $37       ; see MenuCondStall in bank F for explanation
box_x                   = $38
theend_x                = $38
box_y                   = $39
theend_y                = $39
dest_x                  = $3A
dest_y                  = $3B
dest_wd                 = $3C
dest_ht                 = $3D
box_wd                  = $3C ; shared
box_ht                  = $3D ; shared
image_ptr               = $3E ; shared
text_ptr                = $3E ; 2 bytes
spr_x                   = $40
spr_y                   = $41
mm_maprow               = $41 ; shared
vehicle                 = $42 ;1=walking, 2=canoe, 4=ship, 8=airship
inforest                = $43 ; nonzero if in forest
tileprop                = $44 ; 2 bytes
vehicle_next            = $46 ; vehicle we're walking onto
vehchgpause             = $47 ; forced pause when changing vehicles
cur_map                 = $48
cur_tileset             = $49
cur_mapobj              = $4A ; counter for updating which map object
music_track             = $4B
mu_chanprimer           = $4C
mu_chan                 = $4D
entering_shop           = $50 ; nonzero = about to enter shop
shop_id                 = $51
tileprop_now            = $52 ; special tile properties that we're on (tileprop isn't necessarily what we're standing on)
ow_tile                 = $53
ppu_dest                = $54  ; 2 bytes
dlgflg_reentermap       = $56  ; flag to indicate the map needs re-entering due to dialogue (Bahamut/class change)
cur_bank                = $57
ret_bank                = $58
format_buf              = $60  ; 7 bytes (5A-60) -- must not cross page bound
shutter_a               = $61  ; shared
lu_cursor               = $61  ; shared
mm_bplo                 = $61  ; shared
dlg_itemid              = $61  ; shared
equipmenu_tmp           = $61  ; shared
joy_prevdir             = $61
shutter_b               = $62  ; shared
lu_cursor2              = $62  ; shared
mm_bphi                 = $62  ; shared
intro_ataddr            = $62  ; shared
cursor                  = $62
theend_src              = $62
lu_mode                 = $63  ; shared
intro_atbyte            = $63  ; shared
cursor_max              = $63
cursor2                 = $63  ; shared (secondary cursor)
lu_joyprev              = $64  ; shared
intro_color             = $64  ; shared
mg_slidespr             = $64  ; shared, 3 bytes
namecurs_x              = $64
shopcurs_x              = $64  ; shared
eq_modecurs             = $64  ; shared
hp_recovery             = $64
minimap_ptr             = $64  ; shared, 2 bytes
mp_required             = $65
namecurs_y              = $65
shopcurs_y              = $65  ; shared
story_credits           = $65  ; shared
submenu_targ            = $66  ; shared with shop_type
shop_type               = $66
story_page              = $66  ; shared
equipoffset             = shop_type  ; MUST be shared with shop_type
story_timer             = $67  ; shared
draweq_stradd           = $67  ; shared
char_index              = $67
mm_pixrow               = $67  ; shared
talkobj                 = $67  ; shared -- object you're talking to on SM
sm_player_x             = $68  ; player X/Y position on standard map.  Only used for NPC collision detection
sm_player_y             = $69
btlformation            = $6A
enCHRpage               = $6B
altareffect             = $6C  ; flag to indicate altar effect is to occur (screen shaking, monochrome diagonal window thing)
dlgmusic_backup         = $7C  ; backup music track for restoring music after the dialogue box changes it
dlgsfx                  = $7D  ; flag to indicate to play a sound effect after opening dialogue box.  0=no sfx, 1=fanfare, else=treasure
sq2_sfx                 = $7E
descboxopen             = $7F
btlptr                  = $80  ; ??? don't know how big
btl_ib_charstat_ptr     = $80
lvlup_curexp            = $80       ; 2 byte pointer to character's current EXP
lvlup_exptoadv          = $82       ; 2 byte pointer to EXP needed to advance
btl_ob_charstat_ptr     = $82
lvlup_chmagic           = $84       ; 2 byte pointer to character's magic data
lvlup_chstats           = $86       ; 2 byte pointer to character's OB stats





.ifdef _DEFINE_MEMORY
    .segment "BSS"
.endif

    GAP                           12
    RESERVE inroom,               1   ; $0D bit 7 is the actual inroom flag.  $x1=entering room, $x2=entering locked room (different sprite vis), $x5=exiting room, $x6=exiting locked room
    RESERVE doorppuaddr,          1   ; $0E 2 bytes, PPU address of door drawing work


