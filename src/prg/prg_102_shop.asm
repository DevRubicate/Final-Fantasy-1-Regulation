.segment "PRG_102"

.include "src/global-import.inc"

.import PlotBox, Stringify

.import TEXT_SHOP_WELCOME, TEXT_SHOP_WELCOMEWOULDYOUSTAY, TEXT_SHOP_WHATDOYOUWANT, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_WHOWILLTAKEIT, TEXT_SHOP_THANKYOUWHATELSE, TEXT_SHOP_YOUCANTCARRYANYMORE, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_SHOP_YOUCANTLEARNTHAT, TEXT_SHOP_THISSPELLFULL, TEXT_SHOP_ALREADYKNOWSPELL, TEXT_SHOP_WHOSEITEMSELL, TEXT_SHOP_YOUHAVENOTHING, TEXT_SHOP_TOOBAD, TEXT_SHOP_YOUHAVETOOMANY, TEXT_SHOP_DONTFORGET, TEXT_SHOP_HOLDRESET, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_WHOREVIVE, TEXT_SHOP_RETURNLIFE, TEXT_SHOP_ITEMCOSTOK, TEXT_SHOP_BUYSELLEXIT, TEXT_SHOP_BUYEXIT, TEXT_SHOP_YESNO, TEXT_HERO_0_NAME, TEXT_HERO_1_NAME, TEXT_HERO_2_NAME, TEXT_HERO_3_NAME, TEXT_HERO_0_NAME, TEXT_HERO_1_NAME, TEXT_HERO_2_NAME, TEXT_HERO_3_NAME, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM, TEXT_MENU_GOLD, TEXT_TEMPLATE_ITEM_LIST

.import SHOP_WEAPON_CONERIA, SHOP_ARMOR_CONERIA, SHOP_BLACKMAGIC_CONERIA, SHOP_WHITEMAGIC_CONERIA
.import MusicPlay, WaitForVBlank, FillNametable, FillAttributeTable
.import UploadFont, UploadNineSliceBorders, RestoreNineSliceBordersToDefault
.import UploadFillColor, UploadPalette0, UploadPalette1, UploadPalette2, UploadPalette3, UploadPalette4, UploadPalette5, UploadPalette6, UploadPalette7


.export DrawShopWelcome, DrawShopWhatDoYouWant, DrawShopWhoWillTakeIt, DrawShopThankYouWhatElse
.export DrawShopYouCantCarryAnymore, DrawShopYouCantAffordThat, DrawShopWhoseItemSell
.export DrawShopYouHaveNothing, DrawShopWhoWillLearnSpell, DrawShopTooBad, DrawShopYouHaveTooMany
.export DrawShopWelcomeWouldYouStay, DrawShopYouCantLearnThat, DrawShopDontForget, DrawShopHoldReset
.export DrawShopThisSpellFull, DrawShopAlreadyKnowSpell, DrawShopItemCostOK
.export DrawShopNobodyDead, DrawShopWhoRevive, DrawShopReturnLife, DrawShopDeadHeroList
.export DrawShopBuySellExit, DrawShopBuyExit, DrawShopYesNo, DrawShopHeroList
.export DrawShopTitle, DrawShopGoldBox, DrawShopItemList, LoadShopInventory, EnterShopMenu

DrawShopWelcome:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WELCOME
	RTS

DrawShopWelcomeWouldYouStay:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WELCOMEWOULDYOUSTAY
	RTS

DrawShopWhatDoYouWant:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WHATDOYOUWANT
	RTS

DrawShopWhoWillLearnSpell:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WHOWILLLEARNSPELL
	RTS

DrawShopWhoWillTakeIt:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WHOWILLTAKEIT
	RTS

DrawShopThankYouWhatElse:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_THANKYOUWHATELSE
	RTS

DrawShopYouCantCarryAnymore:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_YOUCANTCARRYANYMORE
	RTS

DrawShopYouCantAffordThat:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_YOUCANTAFFORDTHAT
	RTS

DrawShopYouCantLearnThat:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_YOUCANTLEARNTHAT
	RTS

DrawShopThisSpellFull:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_THISSPELLFULL
	RTS

DrawShopAlreadyKnowSpell:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_ALREADYKNOWSPELL
	RTS

DrawShopWhoseItemSell:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WHOSEITEMSELL
	RTS

DrawShopYouHaveNothing:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_YOUHAVENOTHING
	RTS

DrawShopTooBad:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_TOOBAD
	RTS

DrawShopYouHaveTooMany:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_YOUHAVETOOMANY
	RTS

DrawShopDontForget:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_DONTFORGET
	RTS

DrawShopHoldReset:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_HOLDRESET
	RTS

DrawShopNobodyDead:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_NOBODYDEAD
	RTS

DrawShopWhoRevive:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_WHOREVIVE
	RTS

DrawShopReturnLife:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_RETURNLIFE
	RTS

DrawShopItemCostOK:
	POS         1, 4
	NINESLICE   9, 12
	POS         2, 6
	TEXT        TEXT_SHOP_ITEMCOSTOK
	RTS

DrawShopBuySellExit:
	POS         6, 18
	NINESLICE   9, 10
	POS         7, 20
	TEXT        TEXT_SHOP_BUYSELLEXIT
	RTS

DrawShopBuyExit:
	POS         6, 18
	NINESLICE   9, 10
	POS         7, 20
	TEXT        TEXT_SHOP_BUYEXIT
	RTS

DrawShopYesNo:
	POS         6, 18
	NINESLICE   9, 10
	POS         7, 20
	TEXT        TEXT_SHOP_YESNO
	RTS

DrawShopHeroList:
	POS         6, 18
	NINESLICE   9, 10
	POS         7, 20
	TEXT        TEXT_HERO_0_NAME
	POS         7, 22
	TEXT        TEXT_HERO_1_NAME
	POS         7, 24
	TEXT        TEXT_HERO_2_NAME
	POS         7, 26
	TEXT        TEXT_HERO_3_NAME
	RTS

DrawShopDeadHeroList:
	POS         6, 18
	NINESLICE   9, 10
	POS         7, 20

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
	POS 12,     2
	NINESLICE 8,
	LDX shop_type
	LDA LUTShopTitleLo,X
	STA Var0
	LDA LUTShopTitleHi,X
	STA Var1
	LDA LUTShopTitleBank,X
	STA Var2
	LDA #13
	STA drawX
	LDA #4
	STA drawY
	FARCALL Stringify
	RTS

LUTShopTitleLo:
	.lobytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitleHi:
	.hibytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitleBank:
	.byte TextBank(TEXT_SHOP_TITLEWEAPON), TextBank(TEXT_SHOP_TITLEARMOR), TextBank(TEXT_SHOP_TITLEWHITEMAGIC), TextBank(TEXT_SHOP_TITLEBLACKMAGIC), TextBank(TEXT_SHOP_TITLECLINIC), TextBank(TEXT_SHOP_TITLEINN), TextBank(TEXT_SHOP_TITLEITEM)

DrawShopGoldBox:
	POS         18, 24
	NINESLICE   10, 4
	POS         19, 26
	TEXT        TEXT_MENU_GOLD
	RTS

DrawShopItemList:
	POS         22, 2
	NINESLICE   9, 22
	POS         23, 4
	TEXT        TEXT_TEMPLATE_ITEM_LIST
	RTS

LoadShopInventory:
	LDA shop_id          ; get the shop ID
	TAX                  ; put it in X for indexing

	LDA #0
	STA item_box+0
	STA item_box+1
	STA item_box+2
	STA item_box+3
	STA item_box+4

	LDA LUTShopInventoryBank, X
	STA MMC5_PRG_BANK2
	LDA LUTShopInventoryLo, X      ; load up the pointer to shop's inventory
	STA Var0
	LDA LUTShopInventoryHi, X
	STA Var1

	LDY #0
	@Loop:
	LDA (Var0),Y
	BEQ @Done
	STA item_box,Y
	INY
	JMP @Loop
	@Done:
	RTS

LUTShopInventoryLo:
	.lobytes 0
	.lobytes SHOP_WEAPON_CONERIA
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes SHOP_ARMOR_CONERIA
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes SHOP_WHITEMAGIC_CONERIA
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes SHOP_BLACKMAGIC_CONERIA
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0
	.lobytes 0

LUTShopInventoryHi:
	.hibytes 0
	.hibytes SHOP_WEAPON_CONERIA
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes SHOP_ARMOR_CONERIA
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes SHOP_WHITEMAGIC_CONERIA
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes SHOP_BLACKMAGIC_CONERIA
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0
	.hibytes 0

LUTShopInventoryBank:
	.byte 0
	.byte TextBank(SHOP_WEAPON_CONERIA)
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte TextBank(SHOP_ARMOR_CONERIA)
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte TextBank(SHOP_WHITEMAGIC_CONERIA)
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte TextBank(SHOP_BLACKMAGIC_CONERIA)
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
	.byte 0
































































































































EnterShopMenu:
	LDA #$1E
	STA PPU_MASK                ; enable BG and sprite rendering

	FARCALL RestoreNineSliceBordersToDefault

	CALL WaitForVBlank

	LDA #0
	STA Var0
	FARCALL FillNametable

	LDA #0
	STA Var0
	FARCALL FillAttributeTable

	LDA #$01
	STA palette0+0
	LDA #$16
	STA palette0+1
	LDA #$27
	STA palette0+2
	FARCALL UploadPalette0

	POS         1, 2
	NINESLICE   31, 9



;    POS         1, 25
;    NINESLICE   31, 5
;    POS         1, 2
;    NINESLICE   31, 9
;
;    POS         1, 25
;    NINESLICE   31, 5



	@loop:

	FARCALL MusicPlay
	CALL WaitForVBlank
	JUMP @loop


	RTS
