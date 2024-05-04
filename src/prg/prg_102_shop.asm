.segment "PRG_102"

.include "src/global-import.inc"

.import PlotBox, Stringify

.import TEXT_SHOP_WELCOME, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_WHATDOYOUWANT, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_WHOWILLTAKEIT, TEXT_SHOP_THANKYOUWHATELSE, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_TOOBAD, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_DONTFORGET, TEXT_SHOP_HOLDRESET, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_WHOREVIVE, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_ITEMCOSTOK, TEXT_SHOP_BUYSELLEXIT, TEXT_SHOP_BUYEXIT, TEXT_SHOP_YESNO, TEXT_HERO_0_NAME, TEXT_HERO_1_NAME, TEXT_HERO_2_NAME, TEXT_HERO_3_NAME, TEXT_HERO_0_NAME, TEXT_HERO_1_NAME, TEXT_HERO_2_NAME, TEXT_HERO_3_NAME, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_MENU_GOLD, TEXT_TEMPLATE_ITEM_LIST

.export DrawShopWelcome, DrawShopWhatDoYouWant, DrawShopWhoWillTakeIt, DrawShopThankYouWhatElse
.export DrawShopYouCantCarryAnymore, DrawShopYouCantAffordThat, DrawShopWhoseItemSell
.export DrawShopYouHaveNothing, DrawShopWhoWillLearnSpell, DrawShopTooBad, DrawShopYouHaveTooMany
.export DrawShopWelcomeWouldYouStay, DrawShopYouCantLearnThat, DrawShopDontForget, DrawShopHoldReset
.export DrawShopThisSpellFull, DrawShopAlreadyKnowSpell, DrawShopItemCostOK
.export DrawShopNobodyDead, DrawShopWhoRevive, DrawShopReturnLife, DrawShopDeadHeroList
.export DrawShopBuySellExit, DrawShopBuyExit, DrawShopYesNo, DrawShopHeroList
.export DrawShopTitle, DrawShopGoldBox, DrawShopItemList

DrawShopWelcome:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WELCOME
    RTS

DrawShopWelcomeWouldYouStay:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WELCOMEWOULDYOUSTAY
    RTS

DrawShopWhatDoYouWant:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WHATDOYOUWANT
    RTS

DrawShopWhoWillLearnSpell:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WHOWILLLEARNSPELL
    RTS

DrawShopWhoWillTakeIt:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WHOWILLTAKEIT
    RTS

DrawShopThankYouWhatElse:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_THANKYOUWHATELSE
    RTS

DrawShopYouCantCarryAnymore:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_YOUCANTCARRYANYMORE
    RTS

DrawShopYouCantAffordThat:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_YOUCANTAFFORDTHAT
    RTS

DrawShopYouCantLearnThat:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_YOUCANTLEARNTHAT
    RTS

DrawShopThisSpellFull:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_THISSPELLFULL
    RTS

DrawShopAlreadyKnowSpell:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_ALREADYKNOWSPELL
    RTS

DrawShopWhoseItemSell:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WHOSEITEMSELL
    RTS

DrawShopYouHaveNothing:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_YOUHAVENOTHING
    RTS

DrawShopTooBad:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_TOOBAD
    RTS

DrawShopYouHaveTooMany:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_YOUHAVETOOMANY
    RTS

DrawShopDontForget:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_DONTFORGET
    RTS

DrawShopHoldReset:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_HOLDRESET
    RTS

DrawShopNobodyDead:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_NOBODYDEAD
    RTS

DrawShopWhoRevive:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_WHOREVIVE
    RTS

DrawShopReturnLife:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_RETURNLIFE
    RTS

DrawShopItemCostOK:
    POS     1, 4
    BOX     9, 12
    POS     2, 6
    TEXT    TEXT_SHOP_ITEMCOSTOK
    RTS

DrawShopBuySellExit:
    POS     6, 18
    BOX     9, 10
    POS     7, 20
    TEXT    TEXT_SHOP_BUYSELLEXIT
    RTS

DrawShopBuyExit:
    POS     6, 18
    BOX     9, 10
    POS     7, 20
    TEXT    TEXT_SHOP_BUYEXIT
    RTS

DrawShopYesNo:
    POS     6, 18
    BOX     9, 10
    POS     7, 20
    TEXT    TEXT_SHOP_YESNO
    RTS

DrawShopHeroList:
    POS     6, 18
    BOX     9, 10
    POS     7, 20
    TEXT    TEXT_HERO_0_NAME
    POS     7, 22
    TEXT    TEXT_HERO_1_NAME
    POS     7, 24
    TEXT    TEXT_HERO_2_NAME
    POS     7, 26
    TEXT    TEXT_HERO_3_NAME
    RTS

DrawShopDeadHeroList:
    POS     6, 18
    BOX     9, 10
    POS     7, 20

    LDA ch_ailments        ; get this char's OB ailments
    CMP #1                  ; check to see if he's dead
    BNE :+                  ; if not... skip him.  Otherwise...
        TEXT    TEXT_HERO_0_NAME
        POSX    7
        MOVEY   2
    :
    LDA ch1_ailments        ; get this char's OB ailments
    CMP #1                  ; check to see if he's dead
    BNE :+                  ; if not... skip him.  Otherwise...
        TEXT    TEXT_HERO_1_NAME
        POSX    7
        MOVEY   2
    :
    LDA ch2_ailments        ; get this char's OB ailments
    CMP #1                  ; check to see if he's dead
    BNE :+                  ; if not... skip him.  Otherwise...
        TEXT    TEXT_HERO_2_NAME
        POSX    7
        MOVEY   2
    :
    LDA ch3_ailments        ; get this char's OB ailments
    CMP #1                  ; check to see if he's dead
    BNE :+                  ; if not... skip him.  Otherwise...
        TEXT    TEXT_HERO_3_NAME
    :
    RTS

DrawShopTitle:
    POS 12, 2
    BOX 8, 4
    LDX shop_type
    LDA LUTShopTitleLo,X
    STA Var0
    LDA LUTShopTitleHi,X
    STA Var1
    LDA LUTShopTitleBank,X
    STA Var2
    LDA #13
    STA stringwriterDestX
    LDA #4
    STA stringwriterDestY
    FARCALL Stringify
    RTS

LUTShopTitleLo:
    .lobytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitleHi:
    .hibytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitleBank:
    .byte TextBank(TEXT_SHOP_TITLEWEAPON), TextBank(TEXT_SHOP_TITLEARMOR), TextBank(TEXT_SHOP_TITLEWHITEMAGIC), TextBank(TEXT_SHOP_TITLEBLACKMAGIC), TextBank(TEXT_SHOP_TITLECLINIC), TextBank(TEXT_SHOP_TITLEINN), TextBank(TEXT_SHOP_TITLEITEM)

DrawShopGoldBox:
    POS     18, 24
    BOX     10, 4
    POS     19, 26
    TEXT    TEXT_MENU_GOLD
    RTS

DrawShopItemList:
    POS     22, 2
    BOX     9, 22
    POS     23, 4
    TEXT    TEXT_TEMPLATE_ITEM_LIST
    RTS

ITEM_FROST                  = 1
ITEM_HEAT                   = 2
ITEM_GLANCE                 = 3
ITEM_GAZE                   = 4
ITEM_FLASH                  = 5
ITEM_SCORCH                 = 6
ITEM_CRACK                  = 7
ITEM_SQUINT                 = 8
ITEM_STARE                  = 9
ITEM_GLARE                  = 10
ITEM_BLIZZARD               = 11
ITEM_BLAZE                  = 12
ITEM_INFERNO                = 13
ITEM_CREMATE                = 14
ITEM_POISON                 = 15
ITEM_TRANCE                 = 16
ITEM_THUNDER                = 17
ITEM_TOXIC                  = 18
ITEM_SNORTING               = 19
ITEM_NUCLEAR                = 20
ITEM_INK                    = 21
ITEM_STINGER                = 22
ITEM_DAZZLE                 = 23
ITEM_SWIRL                  = 24
ITEM_TORNADO                = 25
ITEM_LUTE                   = 26
ITEM_CROWN                  = 27
ITEM_CRYSTAL                = 28
ITEM_HERB                   = 29
ITEM_KEY                    = 30
ITEM_TNT                    = 31
ITEM_ADAMANT                = 32
ITEM_SLAB                   = 33
ITEM_RUBY                   = 34
ITEM_ROD                    = 35
ITEM_FLOATER                = 36
ITEM_CHIME                  = 37
ITEM_TAIL                   = 38
ITEM_CUBE                   = 39
ITEM_BOTTLE                 = 40
ITEM_OXYALE                 = 41
ITEM_CANOE                  = 42
ITEM_TENT                   = 43
ITEM_CABIN                  = 44
ITEM_HOUSE                  = 45
ITEM_HEAL                   = 46
ITEM_PURE                   = 47
ITEM_SOFT                   = 48
ITEM_WOODEN_NUNCHUCK        = 49
ITEM_SMALL_KNIFE            = 50
ITEM_WOODEN_STAFF           = 51
ITEM_RAPIER                 = 52
ITEM_IRON_HAMMER            = 53
ITEM_SHORT_SWORD            = 54
ITEM_HAND_AXE               = 55
ITEM_SCIMTAR                = 56
ITEM_IRON_NUNCHUCK          = 57
ITEM_LARGE_KNIFE            = 58
ITEM_IRON_STAFF             = 59
ITEM_SABRE                  = 60
ITEM_LONG_SWORD             = 61
ITEM_GREAT_AXE              = 62
ITEM_FALCHON                = 63
ITEM_SILVER_KNIFE           = 64
ITEM_SILVER_SWORD           = 65
ITEM_SILVER_HAMMER          = 66
ITEM_SILVER_AXE             = 67
ITEM_FLAME_SWORD            = 68
ITEM_ICE_SWORD              = 69
ITEM_DRAGON_SWORD           = 70
ITEM_GIANT_SWORD            = 71
ITEM_SUN_SWORD              = 72
ITEM_CORAL_SWORD            = 73
ITEM_WERE_SWORD             = 74
ITEM_RUNE_SWORD             = 75
ITEM_POWER_STAFF            = 76
ITEM_LIGHT_AXE              = 77
ITEM_HEAL_STAFF             = 78
ITEM_MAGE_STAFF             = 79
ITEM_DEFENSE                = 80
ITEM_WIZARD_STAFF           = 81
ITEM_VORPAL                 = 82
ITEM_CATCLAW                = 83
ITEM_THOR_HAMMER            = 84
ITEM_BANE_SWORD             = 85
ITEM_KATANA                 = 86
ITEM_XCALBER                = 87
ITEM_MASMUNE                = 88
ITEM_CLOTH                  = 89
ITEM_WOODEN_ARMOR           = 90
ITEM_CHAIN_ARMOR            = 91
ITEM_IRON_ARMOR             = 92
ITEM_STEEL_ARMOR            = 93
ITEM_SILVER_ARMOR           = 94
ITEM_FLAME_ARMOR            = 95
ITEM_ICE_ARMOR              = 96
ITEM_OPAL_ARMOR             = 97
ITEM_DRAGON_ARMOR           = 98
ITEM_COPPER_BRACELET        = 99
ITEM_SILVER_BRACELET        = 100
ITEM_GOLD_BRACELET          = 101
ITEM_OPAL_BRACELET          = 102
ITEM_WHITE_CLOTH            = 103
ITEM_BLACK_CLOTH            = 104
ITEM_WOODEN_SHIELD          = 105
ITEM_IRON_SHIELD            = 106
ITEM_SILVER_SHIELD          = 107
ITEM_FLAME_SHIELD           = 108
ITEM_ICE_SHIELD             = 109
ITEM_OPAL_SHIELD            = 110
ITEM_AEGIS_SHIELD           = 111
ITEM_BUCKLER                = 112
ITEM_PROCAPE                = 113
ITEM_CAP                    = 114
ITEM_WOODEN_HELMET          = 115
ITEM_IRON_HELMET            = 116
ITEM_SILVER_HELMET          = 117
ITEM_OPAL_HELMET            = 118
ITEM_HEAL_HELMET            = 119
ITEM_RIBBON                 = 120
ITEM_GLOVES                 = 121
ITEM_COPPER_GAUNTLET        = 122
ITEM_IRON_GAUNTLET          = 123
ITEM_SILVER_GAUNTLET        = 124
ITEM_ZEUS_GAUNTLET          = 125
ITEM_POWER_GAUNTLET         = 126
ITEM_OPAL_GAUNTLET          = 127
ITEM_PRORING                = 128


LUTShopInventoryLo:
    .lobytes LUTWeaponShopConeria, LUTArmorShopConeria
LUTShopInventoryHi:
    .hibytes LUTWeaponShopConeria, LUTArmorShopConeria
LUTShopInventoryBank:
    .byte LUTWeaponShopConeria, LUTArmorShopConeria

LUTWeaponShopConeria:
    .byte ITEM_WOODEN_STAFF
    .byte ITEM_SMALL_KNIFE
    .byte ITEM_WOODEN_NUNCHUCK
    .byte ITEM_RAPIER
    .byte ITEM_IRON_HAMMER
    .byte 0

LUTArmorShopConeria:
    .byte ITEM_WOODEN_STAFF
    .byte ITEM_SMALL_KNIFE
    .byte ITEM_WOODEN_NUNCHUCK
    .byte ITEM_RAPIER
    .byte ITEM_IRON_HAMMER
    .byte 0



























































































































