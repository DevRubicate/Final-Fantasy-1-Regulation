.segment "PRG_102"

.include "src/global-import.inc"

.import PlotBox, Stringify

.export DrawShopWelcome, DrawShopWhatDoYouWant, DrawShopWhoWillTakeIt, DrawShopThankYouWhatElse
.export DrawShopYouCantCarryAnymore, DrawShopYouCantAffordThat, DrawShopWhoseItemSell
.export DrawShopYouHaveNothing, DrawShopWhoWillLearnSpell, DrawShopTooBad, DrawShopYouHaveTooMany
.export DrawShopWelcomeWouldYouStay, DrawShopYouCantLearnThat, DrawShopDontForget, DrawShopHoldReset
.export DrawShopThisSpellFull, DrawShopAlreadyKnowSpell, DrawShopItemCostOK
.export DrawShopNobodyDead, DrawShopWhoRevive, DrawShopReturnLife
.export DrawShopBuySellExit, DrawShopYesNo, DrawShopHeroList
.export DrawShopTitle, DrawShopGoldBox

DrawShopWelcome:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WELCOME, 2, 6
    RTS

DrawShopWelcomeWouldYouStay:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WELCOMEWOULDYOUSTAY, 2, 6
    RTS

DrawShopWhatDoYouWant:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WHATDOYOUWANT, 2, 6
    RTS

DrawShopWhoWillLearnSpell:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WHOWILLLEARNSPELL, 2, 6
    RTS

DrawShopWhoWillTakeIt:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WHOWILLTAKEIT, 2, 6
    RTS

DrawShopThankYouWhatElse:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_THANKYOUWHATELSE, 2, 6
    RTS

DrawShopYouCantCarryAnymore:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_YOUCANTCARRYANYMORE, 2, 6
    RTS

DrawShopYouCantAffordThat:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_YOUCANTAFFORDTHAT, 2, 6
    RTS

DrawShopYouCantLearnThat:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_YOUCANTLEARNTHAT, 2, 6
    RTS

DrawShopThisSpellFull:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_THISSPELLFULL, 2, 6
    RTS

DrawShopAlreadyKnowSpell:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_ALREADYKNOWSPELL, 2, 6
    RTS

DrawShopWhoseItemSell:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WHOSEITEMSELL, 2, 6
    RTS

DrawShopYouHaveNothing:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_YOUHAVENOTHING, 2, 6
    RTS

DrawShopTooBad:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_TOOBAD, 2, 6
    RTS

DrawShopYouHaveTooMany:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_YOUHAVETOOMANY, 2, 6
    RTS

DrawShopDontForget:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_DONTFORGET, 2, 6
    RTS

DrawShopHoldReset:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_HOLDRESET, 2, 6
    RTS

DrawShopNobodyDead:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_NOBODYDEAD, 2, 6
    RTS

DrawShopWhoRevive:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_WHOREVIVE, 2, 6
    RTS

DrawShopReturnLife:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_RETURNLIFE, 2, 6
    RTS

DrawShopItemCostOK:
    BOX 1, 4, 9, 12
    TEXT TEXT_SHOP_ITEMCOSTOK, 2, 6
    RTS

DrawShopBuySellExit:
    BOX 6, 18, 9, 10
    TEXT TEXT_SHOP_MENU, 7, 20
    RTS

DrawShopYesNo:
    BOX 6, 18, 9, 10
    TEXT TEXT_SHOP_YESNO, 7, 20
    RTS

DrawShopHeroList:
    BOX 6, 18, 9, 10
    TEXT HERO_0_NAME, 7, 20
    TEXT HERO_1_NAME, 7, 22
    TEXT HERO_2_NAME, 7, 24
    TEXT HERO_3_NAME, 7, 26
    RTS

DrawShopDeadHeroList:
    BOX 6, 18, 9, 10
    TEXT HERO_0_NAME, 7, 20
    TEXT HERO_1_NAME, 7, 22
    TEXT HERO_2_NAME, 7, 24
    TEXT HERO_3_NAME, 7, 26
    RTS

DrawShopTitle:
    BOX 12, 2, 8, 4
    LDX shop_type
    LDA LUTShopTitle_lo,X
    STA Var0
    LDA LUTShopTitle_hi,X
    STA Var1
    LDA LUTShopTitle_bank,X
    STA Var2
    LDA #13
    STA stringwriterDestX
    LDA #4
    STA stringwriterDestY
    FARCALL Stringify
    RTS

LUTShopTitle_lo:
    .lobytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitle_hi:
    .hibytes TEXT_SHOP_TITLEWEAPON, TEXT_SHOP_TITLEARMOR, TEXT_SHOP_TITLEWHITEMAGIC, TEXT_SHOP_TITLEBLACKMAGIC, TEXT_SHOP_TITLECLINIC, TEXT_SHOP_TITLEINN, TEXT_SHOP_TITLEITEM
LUTShopTitle_bank:
    .byte ((124+<((TEXT_SHOP_TITLEWEAPON-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLEARMOR-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLEWHITEMAGIC-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLEBLACKMAGIC-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLECLINIC-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLEINN-$C000)/$2000))|%10000000), ((124+<((TEXT_SHOP_TITLEITEM-$C000)/$2000))|%10000000)

DrawShopGoldBox:
    BOX     18, 24, 10, 4
    TEXT    MENU_GOLD, 19, 26
    RTS
