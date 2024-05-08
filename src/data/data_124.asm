.segment "DATA_124"

.export TEXT_ALPHABET, TEXT_ITEM_FROST, TEXT_ITEM_HEAT, TEXT_ITEM_GLANCE, TEXT_ITEM_GAZE, TEXT_ITEM_FLASH, TEXT_ITEM_SCORCH, TEXT_ITEM_CRACK, TEXT_ITEM_SQUINT, TEXT_ITEM_STARE, TEXT_ITEM_GLARE, TEXT_ITEM_BLIZZARD, TEXT_ITEM_BLAZE, TEXT_ITEM_INFERNO, TEXT_ITEM_CREMATE, TEXT_ITEM_POISON, TEXT_ITEM_TRANCE, TEXT_ITEM_THUNDER, TEXT_ITEM_TOXIC, TEXT_ITEM_SNORTING, TEXT_ITEM_NUCLEAR, TEXT_ITEM_INK, TEXT_ITEM_STINGER, TEXT_ITEM_DAZZLE, TEXT_ITEM_SWIRL, TEXT_ITEM_TORNADO, TEXT_ITEM_LUTE, TEXT_ITEM_CROWN, TEXT_ITEM_CRYSTAL, TEXT_ITEM_HERB, TEXT_ITEM_KEY, TEXT_ITEM_TNT, TEXT_ITEM_ADAMANT, TEXT_ITEM_SLAB, TEXT_ITEM_RUBY, TEXT_ITEM_ROD, TEXT_ITEM_FLOATER, TEXT_ITEM_CHIME, TEXT_ITEM_TAIL, TEXT_ITEM_CUBE, TEXT_ITEM_BOTTLE, TEXT_ITEM_OXYALE, TEXT_ITEM_CANOE, TEXT_ITEM_TENT, TEXT_ITEM_CABIN, TEXT_ITEM_HOUSE, TEXT_ITEM_HEAL, TEXT_ITEM_PURE, TEXT_ITEM_SOFT, TEXT_ITEM_WOODEN_NUNCHUCK, TEXT_ITEM_SMALL_KNIFE, TEXT_ITEM_WOODEN_STAFF, TEXT_ITEM_RAPIER, TEXT_ITEM_IRON_HAMMER, TEXT_ITEM_SHORT_SWORD, TEXT_ITEM_HAND_AXE, TEXT_ITEM_SCIMTAR, TEXT_ITEM_IRON_NUNCHUCK, TEXT_ITEM_LARGE_KNIFE, TEXT_ITEM_IRON_STAFF, TEXT_ITEM_SABRE, TEXT_ITEM_LONG_SWORD, TEXT_ITEM_GREAT_AXE, TEXT_ITEM_FALCHON, TEXT_ITEM_SILVER_KNIFE, TEXT_ITEM_SILVER_SWORD, TEXT_ITEM_SILVER_HAMMER, TEXT_ITEM_SILVER_AXE, TEXT_ITEM_FLAME_SWORD, TEXT_ITEM_ICE_SWORD, TEXT_ITEM_DRAGON_SWORD, TEXT_ITEM_GIANT_SWORD, TEXT_ITEM_SUN_SWORD, TEXT_ITEM_CORAL_SWORD, TEXT_ITEM_WERE_SWORD, TEXT_ITEM_RUNE_SWORD, TEXT_ITEM_POWER_STAFF, TEXT_ITEM_LIGHT_AXE, TEXT_ITEM_HEAL_STAFF, TEXT_ITEM_MAGE_STAFF, TEXT_ITEM_DEFENSE, TEXT_ITEM_WIZARD_STAFF, TEXT_ITEM_VORPAL, TEXT_ITEM_CATCLAW, TEXT_ITEM_THOR_HAMMER, TEXT_ITEM_BANE_SWORD, TEXT_ITEM_KATANA, TEXT_ITEM_XCALBER, TEXT_ITEM_MASMUNE, TEXT_ITEM_CLOTH, TEXT_ITEM_WOODEN_ARMOR, TEXT_ITEM_CHAIN_ARMOR, TEXT_ITEM_IRON_ARMOR, TEXT_ITEM_STEEL_ARMOR, TEXT_ITEM_SILVER_ARMOR, TEXT_ITEM_FLAME_ARMOR, TEXT_ITEM_ICE_ARMOR, TEXT_ITEM_OPAL_ARMOR, TEXT_ITEM_DRAGON_ARMOR, TEXT_ITEM_COPPER_BRACELET, TEXT_ITEM_SILVER_BRACELET, TEXT_ITEM_GOLD_BRACELET, TEXT_ITEM_OPAL_BRACELET, TEXT_ITEM_WHITE_CLOTH, TEXT_ITEM_BLACK_CLOTH, TEXT_ITEM_WOODEN_SHIELD, TEXT_ITEM_IRON_SHIELD, TEXT_ITEM_SILVER_SHIELD, TEXT_ITEM_FLAME_SHIELD, TEXT_ITEM_ICE_SHIELD, TEXT_ITEM_OPAL_SHIELD, TEXT_ITEM_AEGIS_SHIELD, TEXT_ITEM_BUCKLER, TEXT_ITEM_PROCAPE, TEXT_ITEM_CAP, TEXT_ITEM_WOODEN_HELMET, TEXT_ITEM_IRON_HELMET, TEXT_ITEM_SILVER_HELMET, TEXT_ITEM_OPAL_HELMET, TEXT_ITEM_HEAL_HELMET, TEXT_ITEM_RIBBON, TEXT_ITEM_GLOVES, TEXT_ITEM_COPPER_GAUNTLET, TEXT_ITEM_IRON_GAUNTLET, TEXT_ITEM_SILVER_GAUNTLET, TEXT_ITEM_ZEUS_GAUNTLET, TEXT_ITEM_POWER_GAUNTLET, TEXT_ITEM_OPAL_GAUNTLET, TEXT_ITEM_PRORING

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $2a, $61, $2b, $61, $2c, $61, $2d, $61, $2e, $61, $2f, $61, $30, $61, $31, $61, $32, $61, $33, $7f, $7f, $34, $61, $35, $61, $36, $61, $37, $61, $38, $61, $39, $61, $3a, $61, $3b, $61, $3c, $61, $3d, $7f, $7f, $3e, $61, $3f, $61, $40, $61, $41, $61, $42, $61, $43, $61, $5e, $61, $5f, $61, $60, $61, $61, $7f, $7f, $20, $61, $21, $61, $22, $61, $23, $61, $24, $61, $25, $61, $26, $61, $27, $61, $28, $61, $29, $7f, $7f, $44, $61, $45, $61, $46, $61, $47, $61, $48, $61, $49, $61, $4a, $61, $4b, $61, $4c, $61, $4d, $7f, $7f, $4e, $61, $4f, $61, $50, $61, $51, $61, $52, $61, $53, $61, $54, $61, $55, $61, $56, $61, $57, $7f, $7f, $58, $61, $59, $61, $5a, $61, $5b, $61, $5c, $61, $5d, $61, $62, $61, $63, $61, $64, $61, $65, $00

; address 146 - 152 (bytes 0 - 6)
TEXT_ITEM_FROST:
.byte $2f, $3b, $38, $3c, $3d, $00

; address 152 - 157 (bytes 0 - 5)
TEXT_ITEM_HEAT:
.byte $31, $2e, $2a, $3d, $00

; address 157 - 164 (bytes 0 - 7)
TEXT_ITEM_GLANCE:
.byte $30, $35, $2a, $37, $2c, $2e, $00

; address 164 - 169 (bytes 0 - 5)
TEXT_ITEM_GAZE:
.byte $30, $2a, $43, $2e, $00

; address 169 - 175 (bytes 0 - 6)
TEXT_ITEM_FLASH:
.byte $2f, $35, $2a, $3c, $31, $00

; address 175 - 182 (bytes 0 - 7)
TEXT_ITEM_SCORCH:
.byte $3c, $2c, $38, $3b, $2c, $31, $00

; address 182 - 188 (bytes 0 - 6)
TEXT_ITEM_CRACK:
.byte $2c, $3b, $2a, $2c, $34, $00

; address 188 - 195 (bytes 0 - 7)
TEXT_ITEM_SQUINT:
.byte $3c, $3a, $3e, $32, $37, $3d, $00

; address 195 - 201 (bytes 0 - 6)
TEXT_ITEM_STARE:
.byte $3c, $3d, $2a, $3b, $2e, $00

; address 201 - 207 (bytes 0 - 6)
TEXT_ITEM_GLARE:
.byte $30, $35, $2a, $3b, $2e, $00

; address 207 - 216 (bytes 0 - 9)
TEXT_ITEM_BLIZZARD:
.byte $2b, $35, $32, $43, $43, $2a, $3b, $2d, $00

; address 216 - 222 (bytes 0 - 6)
TEXT_ITEM_BLAZE:
.byte $2b, $35, $2a, $43, $2e, $00

; address 222 - 230 (bytes 0 - 8)
TEXT_ITEM_INFERNO:
.byte $32, $37, $2f, $2e, $3b, $37, $38, $00

; address 230 - 238 (bytes 0 - 8)
TEXT_ITEM_CREMATE:
.byte $2c, $3b, $2e, $36, $2a, $3d, $2e, $00

; address 238 - 245 (bytes 0 - 7)
TEXT_ITEM_POISON:
.byte $39, $38, $32, $3c, $38, $37, $00

; address 245 - 252 (bytes 0 - 7)
TEXT_ITEM_TRANCE:
.byte $3d, $3b, $2a, $37, $2c, $2e, $00

; address 252 - 260 (bytes 0 - 8)
TEXT_ITEM_THUNDER:
.byte $3d, $31, $3e, $37, $2d, $2e, $3b, $00

; address 260 - 266 (bytes 0 - 6)
TEXT_ITEM_TOXIC:
.byte $3d, $38, $41, $32, $2c, $00

; address 266 - 275 (bytes 0 - 9)
TEXT_ITEM_SNORTING:
.byte $3c, $37, $38, $3b, $3d, $32, $37, $30, $00

; address 275 - 283 (bytes 0 - 8)
TEXT_ITEM_NUCLEAR:
.byte $37, $3e, $2c, $35, $2e, $2a, $3b, $00

; address 283 - 287 (bytes 0 - 4)
TEXT_ITEM_INK:
.byte $32, $37, $34, $00

; address 287 - 295 (bytes 0 - 8)
TEXT_ITEM_STINGER:
.byte $3c, $3d, $32, $37, $30, $2e, $3b, $00

; address 295 - 302 (bytes 0 - 7)
TEXT_ITEM_DAZZLE:
.byte $2d, $2a, $43, $43, $35, $2e, $00

; address 302 - 308 (bytes 0 - 6)
TEXT_ITEM_SWIRL:
.byte $3c, $40, $32, $3b, $35, $00

; address 308 - 316 (bytes 0 - 8)
TEXT_ITEM_TORNADO:
.byte $3d, $38, $3b, $37, $2a, $2d, $38, $00

; address 316 - 321 (bytes 0 - 5)
TEXT_ITEM_LUTE:
.byte $35, $3e, $3d, $2e, $00

; address 321 - 327 (bytes 0 - 6)
TEXT_ITEM_CROWN:
.byte $2c, $3b, $38, $40, $37, $00

; address 327 - 335 (bytes 0 - 8)
TEXT_ITEM_CRYSTAL:
.byte $2c, $3b, $42, $3c, $3d, $2a, $35, $00

; address 335 - 340 (bytes 0 - 5)
TEXT_ITEM_HERB:
.byte $31, $2e, $3b, $2b, $00

; address 340 - 344 (bytes 0 - 4)
TEXT_ITEM_KEY:
.byte $34, $2e, $42, $00

; address 344 - 348 (bytes 0 - 4)
TEXT_ITEM_TNT:
.byte $3d, $37, $3d, $00

; address 348 - 356 (bytes 0 - 8)
TEXT_ITEM_ADAMANT:
.byte $2a, $2d, $2a, $36, $2a, $37, $3d, $00

; address 356 - 361 (bytes 0 - 5)
TEXT_ITEM_SLAB:
.byte $3c, $35, $2a, $2b, $00

; address 361 - 366 (bytes 0 - 5)
TEXT_ITEM_RUBY:
.byte $3b, $3e, $2b, $42, $00

; address 366 - 370 (bytes 0 - 4)
TEXT_ITEM_ROD:
.byte $3b, $38, $2d, $00

; address 370 - 378 (bytes 0 - 8)
TEXT_ITEM_FLOATER:
.byte $2f, $35, $38, $2a, $3d, $2e, $3b, $00

; address 378 - 384 (bytes 0 - 6)
TEXT_ITEM_CHIME:
.byte $2c, $31, $32, $36, $2e, $00

; address 384 - 389 (bytes 0 - 5)
TEXT_ITEM_TAIL:
.byte $3d, $2a, $32, $35, $00

; address 389 - 394 (bytes 0 - 5)
TEXT_ITEM_CUBE:
.byte $2c, $3e, $2b, $2e, $00

; address 394 - 401 (bytes 0 - 7)
TEXT_ITEM_BOTTLE:
.byte $2b, $38, $3d, $3d, $35, $2e, $00

; address 401 - 408 (bytes 0 - 7)
TEXT_ITEM_OXYALE:
.byte $38, $41, $42, $2a, $35, $2e, $00

; address 408 - 414 (bytes 0 - 6)
TEXT_ITEM_CANOE:
.byte $2c, $2a, $37, $38, $2e, $00

; address 414 - 419 (bytes 0 - 5)
TEXT_ITEM_TENT:
.byte $3d, $2e, $37, $3d, $00

; address 419 - 425 (bytes 0 - 6)
TEXT_ITEM_CABIN:
.byte $2c, $2a, $2b, $32, $37, $00

; address 425 - 431 (bytes 0 - 6)
TEXT_ITEM_HOUSE:
.byte $31, $38, $3e, $3c, $2e, $00

; address 431 - 436 (bytes 0 - 5)
TEXT_ITEM_HEAL:
.byte $31, $2e, $2a, $35, $00

; address 436 - 441 (bytes 0 - 5)
TEXT_ITEM_PURE:
.byte $39, $3e, $3b, $2e, $00

; address 441 - 446 (bytes 0 - 5)
TEXT_ITEM_SOFT:
.byte $3c, $38, $2f, $3d, $00

; address 446 - 453 (bytes 0 - 7)
TEXT_ITEM_WOODEN_NUNCHUCK:
.byte $40, $38, $38, $2d, $2e, $37, $00

; address 453 - 459 (bytes 0 - 6)
TEXT_ITEM_SMALL_KNIFE:
.byte $3c, $36, $2a, $35, $35, $00

; address 459 - 466 (bytes 0 - 7)
TEXT_ITEM_WOODEN_STAFF:
.byte $40, $38, $38, $2d, $2e, $37, $00

; address 466 - 473 (bytes 0 - 7)
TEXT_ITEM_RAPIER:
.byte $3b, $2a, $39, $32, $2e, $3b, $00

; address 473 - 478 (bytes 0 - 5)
TEXT_ITEM_IRON_HAMMER:
.byte $32, $3b, $38, $37, $00

; address 478 - 484 (bytes 0 - 6)
TEXT_ITEM_SHORT_SWORD:
.byte $3c, $31, $38, $3b, $3d, $00

; address 484 - 489 (bytes 0 - 5)
TEXT_ITEM_HAND_AXE:
.byte $31, $2a, $37, $2d, $00

; address 489 - 497 (bytes 0 - 8)
TEXT_ITEM_SCIMTAR:
.byte $3c, $2c, $32, $36, $3d, $2a, $3b, $00

; address 497 - 502 (bytes 0 - 5)
TEXT_ITEM_IRON_NUNCHUCK:
.byte $32, $3b, $38, $37, $00

; address 502 - 508 (bytes 0 - 6)
TEXT_ITEM_LARGE_KNIFE:
.byte $35, $2a, $3b, $30, $2e, $00

; address 508 - 513 (bytes 0 - 5)
TEXT_ITEM_IRON_STAFF:
.byte $32, $3b, $38, $37, $00

; address 513 - 519 (bytes 0 - 6)
TEXT_ITEM_SABRE:
.byte $3c, $2a, $2b, $3b, $2e, $00

; address 519 - 524 (bytes 0 - 5)
TEXT_ITEM_LONG_SWORD:
.byte $35, $38, $37, $30, $00

; address 524 - 530 (bytes 0 - 6)
TEXT_ITEM_GREAT_AXE:
.byte $30, $3b, $2e, $2a, $3d, $00

; address 530 - 538 (bytes 0 - 8)
TEXT_ITEM_FALCHON:
.byte $2f, $2a, $35, $2c, $31, $38, $37, $00

; address 538 - 545 (bytes 0 - 7)
TEXT_ITEM_SILVER_KNIFE:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 545 - 552 (bytes 0 - 7)
TEXT_ITEM_SILVER_SWORD:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 552 - 559 (bytes 0 - 7)
TEXT_ITEM_SILVER_HAMMER:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 559 - 566 (bytes 0 - 7)
TEXT_ITEM_SILVER_AXE:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 566 - 572 (bytes 0 - 6)
TEXT_ITEM_FLAME_SWORD:
.byte $2f, $35, $2a, $36, $2e, $00

; address 572 - 576 (bytes 0 - 4)
TEXT_ITEM_ICE_SWORD:
.byte $32, $2c, $2e, $00

; address 576 - 583 (bytes 0 - 7)
TEXT_ITEM_DRAGON_SWORD:
.byte $2d, $3b, $2a, $30, $38, $37, $00

; address 583 - 589 (bytes 0 - 6)
TEXT_ITEM_GIANT_SWORD:
.byte $30, $32, $2a, $37, $3d, $00

; address 589 - 593 (bytes 0 - 4)
TEXT_ITEM_SUN_SWORD:
.byte $3c, $3e, $37, $00

; address 593 - 599 (bytes 0 - 6)
TEXT_ITEM_CORAL_SWORD:
.byte $2c, $38, $3b, $2a, $35, $00

; address 599 - 604 (bytes 0 - 5)
TEXT_ITEM_WERE_SWORD:
.byte $40, $2e, $3b, $2e, $00

; address 604 - 609 (bytes 0 - 5)
TEXT_ITEM_RUNE_SWORD:
.byte $3b, $3e, $37, $2e, $00

; address 609 - 615 (bytes 0 - 6)
TEXT_ITEM_POWER_STAFF:
.byte $39, $38, $40, $2e, $3b, $00

; address 615 - 621 (bytes 0 - 6)
TEXT_ITEM_LIGHT_AXE:
.byte $35, $32, $30, $31, $3d, $00

; address 621 - 626 (bytes 0 - 5)
TEXT_ITEM_HEAL_STAFF:
.byte $31, $2e, $2a, $35, $00

; address 626 - 631 (bytes 0 - 5)
TEXT_ITEM_MAGE_STAFF:
.byte $36, $2a, $30, $2e, $00

; address 631 - 639 (bytes 0 - 8)
TEXT_ITEM_DEFENSE:
.byte $2d, $2e, $2f, $2e, $37, $3c, $2e, $00

; address 639 - 646 (bytes 0 - 7)
TEXT_ITEM_WIZARD_STAFF:
.byte $40, $32, $43, $2a, $3b, $2d, $00

; address 646 - 653 (bytes 0 - 7)
TEXT_ITEM_VORPAL:
.byte $3f, $38, $3b, $39, $2a, $35, $00

; address 653 - 661 (bytes 0 - 8)
TEXT_ITEM_CATCLAW:
.byte $2c, $2a, $3d, $2c, $35, $2a, $40, $00

; address 661 - 666 (bytes 0 - 5)
TEXT_ITEM_THOR_HAMMER:
.byte $3d, $31, $38, $3b, $00

; address 666 - 671 (bytes 0 - 5)
TEXT_ITEM_BANE_SWORD:
.byte $2b, $2a, $37, $2e, $00

; address 671 - 678 (bytes 0 - 7)
TEXT_ITEM_KATANA:
.byte $34, $2a, $3d, $2a, $37, $2a, $00

; address 678 - 686 (bytes 0 - 8)
TEXT_ITEM_XCALBER:
.byte $41, $2c, $2a, $35, $2b, $2e, $3b, $00

; address 686 - 694 (bytes 0 - 8)
TEXT_ITEM_MASMUNE:
.byte $36, $2a, $3c, $36, $3e, $37, $2e, $00

; address 694 - 700 (bytes 0 - 6)
TEXT_ITEM_CLOTH:
.byte $2c, $35, $38, $3d, $31, $00

; address 700 - 707 (bytes 0 - 7)
TEXT_ITEM_WOODEN_ARMOR:
.byte $40, $38, $38, $2d, $2e, $37, $00

; address 707 - 713 (bytes 0 - 6)
TEXT_ITEM_CHAIN_ARMOR:
.byte $2c, $31, $2a, $32, $37, $00

; address 713 - 718 (bytes 0 - 5)
TEXT_ITEM_IRON_ARMOR:
.byte $32, $3b, $38, $37, $00

; address 718 - 724 (bytes 0 - 6)
TEXT_ITEM_STEEL_ARMOR:
.byte $3c, $3d, $2e, $2e, $35, $00

; address 724 - 731 (bytes 0 - 7)
TEXT_ITEM_SILVER_ARMOR:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 731 - 737 (bytes 0 - 6)
TEXT_ITEM_FLAME_ARMOR:
.byte $2f, $35, $2a, $36, $2e, $00

; address 737 - 741 (bytes 0 - 4)
TEXT_ITEM_ICE_ARMOR:
.byte $32, $2c, $2e, $00

; address 741 - 746 (bytes 0 - 5)
TEXT_ITEM_OPAL_ARMOR:
.byte $38, $39, $2a, $35, $00

; address 746 - 753 (bytes 0 - 7)
TEXT_ITEM_DRAGON_ARMOR:
.byte $2d, $3b, $2a, $30, $38, $37, $00

; address 753 - 760 (bytes 0 - 7)
TEXT_ITEM_COPPER_BRACELET:
.byte $2c, $38, $39, $39, $2e, $3b, $00

; address 760 - 767 (bytes 0 - 7)
TEXT_ITEM_SILVER_BRACELET:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 767 - 772 (bytes 0 - 5)
TEXT_ITEM_GOLD_BRACELET:
.byte $30, $38, $35, $2d, $00

; address 772 - 777 (bytes 0 - 5)
TEXT_ITEM_OPAL_BRACELET:
.byte $38, $39, $2a, $35, $00

; address 777 - 783 (bytes 0 - 6)
TEXT_ITEM_WHITE_CLOTH:
.byte $40, $31, $32, $3d, $2e, $00

; address 783 - 789 (bytes 0 - 6)
TEXT_ITEM_BLACK_CLOTH:
.byte $2b, $35, $2a, $2c, $34, $00

; address 789 - 796 (bytes 0 - 7)
TEXT_ITEM_WOODEN_SHIELD:
.byte $40, $38, $38, $2d, $2e, $37, $00

; address 796 - 801 (bytes 0 - 5)
TEXT_ITEM_IRON_SHIELD:
.byte $32, $3b, $38, $37, $00

; address 801 - 808 (bytes 0 - 7)
TEXT_ITEM_SILVER_SHIELD:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 808 - 814 (bytes 0 - 6)
TEXT_ITEM_FLAME_SHIELD:
.byte $2f, $35, $2a, $36, $2e, $00

; address 814 - 818 (bytes 0 - 4)
TEXT_ITEM_ICE_SHIELD:
.byte $32, $2c, $2e, $00

; address 818 - 823 (bytes 0 - 5)
TEXT_ITEM_OPAL_SHIELD:
.byte $38, $39, $2a, $35, $00

; address 823 - 829 (bytes 0 - 6)
TEXT_ITEM_AEGIS_SHIELD:
.byte $2a, $2e, $30, $32, $3c, $00

; address 829 - 837 (bytes 0 - 8)
TEXT_ITEM_BUCKLER:
.byte $2b, $3e, $2c, $34, $35, $2e, $3b, $00

; address 837 - 845 (bytes 0 - 8)
TEXT_ITEM_PROCAPE:
.byte $39, $3b, $38, $2c, $2a, $39, $2e, $00

; address 845 - 849 (bytes 0 - 4)
TEXT_ITEM_CAP:
.byte $2c, $2a, $39, $00

; address 849 - 856 (bytes 0 - 7)
TEXT_ITEM_WOODEN_HELMET:
.byte $40, $38, $38, $2d, $2e, $37, $00

; address 856 - 861 (bytes 0 - 5)
TEXT_ITEM_IRON_HELMET:
.byte $32, $3b, $38, $37, $00

; address 861 - 868 (bytes 0 - 7)
TEXT_ITEM_SILVER_HELMET:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 868 - 873 (bytes 0 - 5)
TEXT_ITEM_OPAL_HELMET:
.byte $38, $39, $2a, $35, $00

; address 873 - 878 (bytes 0 - 5)
TEXT_ITEM_HEAL_HELMET:
.byte $31, $2e, $2a, $35, $00

; address 878 - 885 (bytes 0 - 7)
TEXT_ITEM_RIBBON:
.byte $3b, $32, $2b, $2b, $38, $37, $00

; address 885 - 892 (bytes 0 - 7)
TEXT_ITEM_GLOVES:
.byte $30, $35, $38, $3f, $2e, $3c, $00

; address 892 - 899 (bytes 0 - 7)
TEXT_ITEM_COPPER_GAUNTLET:
.byte $2c, $38, $39, $39, $2e, $3b, $00

; address 899 - 904 (bytes 0 - 5)
TEXT_ITEM_IRON_GAUNTLET:
.byte $32, $3b, $38, $37, $00

; address 904 - 911 (bytes 0 - 7)
TEXT_ITEM_SILVER_GAUNTLET:
.byte $3c, $32, $35, $3f, $2e, $3b, $00

; address 911 - 916 (bytes 0 - 5)
TEXT_ITEM_ZEUS_GAUNTLET:
.byte $43, $2e, $3e, $3c, $00

; address 916 - 922 (bytes 0 - 6)
TEXT_ITEM_POWER_GAUNTLET:
.byte $39, $38, $40, $2e, $3b, $00

; address 922 - 927 (bytes 0 - 5)
TEXT_ITEM_OPAL_GAUNTLET:
.byte $38, $39, $2a, $35, $00

; address 927 - 935 (bytes 0 - 8)
TEXT_ITEM_PRORING:
.byte $39, $3b, $38, $3b, $32, $37, $30, $00

; 935 - 8192
.res 7257

