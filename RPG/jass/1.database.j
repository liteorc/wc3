//===========================================================================
globals
    hashtable g_hashtable
endglobals
//===========================================================================
function LoadAbilityResearchIcon takes integer abilCode returns string
    return LoadStr(g_hashtable, abilCode, 'arar')
endfunction
function SaveAbilityResearchIcon takes integer abilCode, string iconPath returns nothing
    call SaveStr(g_hashtable, abilCode, 'arar', iconPath)
endfunction
function LoadAbilityMaxLevel takes integer abilCode returns integer
    return LoadInteger(g_hashtable, abilCode, 'alev')
endfunction
function SaveAbilityMaxLevel takes integer abilCode, integer maxLevel returns nothing
    call SaveInteger(g_hashtable, abilCode, 'alev', maxLevel)
endfunction
function LoadAbilityRequireLevel takes integer abilCode returns integer
    return LoadInteger(g_hashtable, abilCode, 'arlv')
endfunction
function SaveAbilityRequireLevel takes integer abilCode, integer reqLevel  returns nothing
    call SaveInteger(g_hashtable, abilCode, 'arlv', reqLevel)
endfunction
function LoadUnitHeroAbilityList takes integer unitid returns string
    return LoadStr(g_hashtable, unitid, 'uhab')
endfunction
function SaveUnitHeroAbilityList takes integer unitid , string abillist returns nothing
    call SaveStr(g_hashtable, unitid, 'uhab', abillist)
endfunction
function LoadUnitIcon takes unit u returns string
    return LoadStr(g_hashtable, GetUnitTypeId(u), 'uico')
endfunction
//===========================================================================
function VersionSupportedHD takes nothing  returns boolean
    local string path = BlzGetAbilityIcon('Arsg')
    return StringContains(path, "BTNMisha.blp")
endfunction
function ReviseStorageData takes nothing  returns nothing
    call SaveAbilityMaxLevel ('aNsy', 3)
    call SaveAbilityMaxLevel ('aNcs', 3)
    call SaveAbilityMaxLevel ('aNrg', 1)
    call SaveAbilityMaxLevel ('aNde', 1)

    call SaveAbilityRequireLevel('aNde', 6)
endfunction
function InitDefaultHeroAbilList takes nothing returns nothing
    call SaveUnitHeroAbilityList('Hamg', "AHbz,AHwe,AHab,AHmt")
    call SaveUnitHeroAbilityList('Hblm', "AHfs,AHbn,AHdr,AHpx")
    call SaveUnitHeroAbilityList('Hmkg', "AHtb,AHtc,AHbh,AHav")
    call SaveUnitHeroAbilityList('Hpal', "AHhb,AHds,AHad,AHre")
    call SaveUnitHeroAbilityList('Obla', "AOwk,AOmi,AOcr,AOww")
    call SaveUnitHeroAbilityList('Ofar', "AOcl,AOfs,AOsf,AOeq")
    call SaveUnitHeroAbilityList('Oshd', "AOhw,AOhx,AOsw,AOvd")
    call SaveUnitHeroAbilityList('Otch', "AOsh,AOws,AOae,AOre")
    call SaveUnitHeroAbilityList('Edem', "AEmb,AEim,AEev,AEme")
    call SaveUnitHeroAbilityList('Ekee', "AEer,AEfn,AEah,AEtq")
    call SaveUnitHeroAbilityList('Emoo', "AEst,AHfa,AEar,AEsf")
    call SaveUnitHeroAbilityList('Ewar', "AEfk,AEbl,AEsh,AEsv")
    call SaveUnitHeroAbilityList('Ucrl', "AUim,AUts,AUcb,AUls")
    call SaveUnitHeroAbilityList('Udea', "AUdc,AUdp,AUau,AUan")
    call SaveUnitHeroAbilityList('Udre', "AUcs,AUsl,AUav,AUin")
    call SaveUnitHeroAbilityList('Ulic', "AUfn,AUfu,AUdr,AUdd")
    call SaveUnitHeroAbilityList('Nbrn', "ANsi,ANba,ANdr,ANch")
    call SaveUnitHeroAbilityList('Nbst', "ANsg,ANsq,ANsw,ANst")
    call SaveUnitHeroAbilityList('Nngs', "ANfl,ANfa,ANms,ANto")
    call SaveUnitHeroAbilityList('Npbm', "ANbf,ANdh,ANdb,ANef")
    call SaveUnitHeroAbilityList('Nalc', "ANhs,ANcr,ANab,ANtm")
    call SaveUnitHeroAbilityList('Nplh', "ANrf,ANht,ANca,ANdo")
    call SaveUnitHeroAbilityList('Nfir', "ANso,ANlm,ANia,ANvc")
    call SaveUnitHeroAbilityList('Ntin', "aNsy,aNcs,aNeg,aNrg,aNde")//special
endfunction
function InitDefaultHeroIcon takes nothing returns nothing
    call SaveStr(g_hashtable, 'Hamg', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroArchMage.blp")
    call SaveStr(g_hashtable, 'Hblm', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroBloodElfPrince.blp")
    call SaveStr(g_hashtable, 'Hmkg', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroMountainKing.blp")
    call SaveStr(g_hashtable, 'Hpal', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp")
    call SaveStr(g_hashtable, 'Obla', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp")
    call SaveStr(g_hashtable, 'Ofar', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroFarseer.blp")
    call SaveStr(g_hashtable, 'Oshd', 'uico', "ReplaceableTextures\\CommandButtons\\BTNShadowHunter.blp")
    call SaveStr(g_hashtable, 'Otch', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroTaurenChieftain.blp")
    call SaveStr(g_hashtable, 'Edem', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroDemonHunter.blp")
    call SaveStr(g_hashtable, 'Edmm', 'uico', "ReplaceableTextures\\CommandButtons\\BTNMetamorphosis.blp")
    call SaveStr(g_hashtable, 'Ekee', 'uico', "ReplaceableTextures\\CommandButtons\\BTNKeeperOfTheGrove.blp")
    call SaveStr(g_hashtable, 'Emoo', 'uico', "ReplaceableTextures\\CommandButtons\\BTNPriestessOfTheMoon.blp")
    call SaveStr(g_hashtable, 'Ewar', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroWarden.blp")
    call SaveStr(g_hashtable, 'Ucrl', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroCryptLord.blp")
    call SaveStr(g_hashtable, 'Udea', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp")
    call SaveStr(g_hashtable, 'Udre', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroDreadLord.blp")
    call SaveStr(g_hashtable, 'Ulic', 'uico', "ReplaceableTextures\\CommandButtons\\BTNLichVersion2.blp")
    call SaveStr(g_hashtable, 'Nbrn', 'uico', "ReplaceableTextures\\CommandButtons\\BTNBansheeRanger.blp")
    call SaveStr(g_hashtable, 'Nbst', 'uico', "ReplaceableTextures\\CommandButtons\\BTNBeastMaster.blp")
    call SaveStr(g_hashtable, 'Nngs', 'uico', "ReplaceableTextures\\CommandButtons\\BTNNagaSeaWitch.blp")
    call SaveStr(g_hashtable, 'Npbm', 'uico', "ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
    call SaveStr(g_hashtable, 'Nplh', 'uico', "ReplaceableTextures\\CommandButtons\\BTNPitLord.blp")
    call SaveStr(g_hashtable, 'Nfir', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAvatarOfFlame.blp")
    call SaveStr(g_hashtable, 'Ntin', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroTinker.blp")
    call SaveStr(g_hashtable, 'Nrob', 'uico', "ReplaceableTextures\\CommandButtons\\BTNROBOGOBLIN.blp")
    call SaveStr(g_hashtable, 'Nalc', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp")
    if (VersionSupportedHD()) then
        call SaveStr(g_hashtable, 'Nalm', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemistLV1.blp")
        call SaveStr(g_hashtable, 'Nal2', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemistLV2.blp")
        call SaveStr(g_hashtable, 'Nal3', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemistLV3.blp")
    else
        call SaveStr(g_hashtable, 'Nalm', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp")
        call SaveStr(g_hashtable, 'Nal2', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp")
        call SaveStr(g_hashtable, 'Nal3', 'uico', "ReplaceableTextures\\CommandButtons\\BTNHeroAlchemist.blp")
    endif
endfunction
//===========================================================================
function InitDatabase takes nothing returns nothing
    local string abillist
    local unit toy
    local integer i
    local integer len
    local integer abilcode
    local ability abilobj
    local string str

    set g_hashtable = InitHashtable()
    call InitDefaultHeroIcon()
    call InitDefaultHeroAbilList()
    //hero ability list
    set abillist = "AHbz,AHwe,AHab,AHmt,AHfs,AHbn,AHdr,AHpx,AHtb,AHtc,AHbh,AHav,AHhb,AHds,AHad,AHre,AOwk,AOmi,AOcr,AOww,AOcl,AOfs,AOsf,AOeq,AOhw,AOhx,AOsw,AOvd,AOsh,AOws,AOae,AOre,AEmb,AEim,AEev,AEme,AEer,AEfn,AEah,AEtq,AEst,AHfa,AEar,AEsf,AEfk,AEbl,AEsh,AEsv,AUim,AUts,AUcb,AUls,AUdc,AUdp,AUau,AUan,AUcs,AUsl,AUav,AUin,AUfn,AUfu,AUdr,AUdd,ANsi,ANba,ANdr,ANch,ANsg,ANsq,ANsw,ANst,ANfl,ANfa,ANms,ANto,ANbf,ANdh,ANdb,ANef,ANhs,ANcr,ANab,ANtm,aNsy,aNcs,aNeg,aNrg,aNde,ANrf,ANht,ANca,ANdo,ANso,ANlm,ANia,ANvc,"
    //extra hero abilities
    set abillist = abillist+"aews,"
    set abillist = abillist+"aOcr,aUts,aEev,aHbh,aNdb,aNca,aabs,aap1,aCdv,aegr,afbk,assk,amdf,awar,asal,auco,aIpm,apig,aspo,acn2,aven,aeat,aNba,aHfa,aNfa,aEim,aadm,aivs,aHbn,aspl,aam2,adcn,aroa,asta,ahwd,apxf,arpl,arpm,ahea,ablo,ainf,acrs,afae,aslo,apg2,arej,aroc,aUfu,aOwk,alsh,aply,aUsl,acmg,aNpa,aHhb,adis,acyc,aHdr,aHbz,aUdc,aNhs,asps,apsh,aOsw,advm,aEmb,aOhx,aOws,aHtc,aNdr,aCfb,aCtb,aEer,aEsh,arai,aNrf,aOsh,aCcv,aUfn,aHtb,aCcb,aOhw,aUim,aOcl,aNms,aEbl,aNbf,aNmo,aUcs,aCbf,acri,aHfs,aNfl,aweb,aNso,aNht,aNab,atau,aNfd,aens,ache,aNsi,amfl,aEfn,aHwe,aNsq,absk,afzy,amls,aOsf,aHds,aNdp,"
    set abillist = abillist+"aetf,acpf"
    set toy = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'nsno', 0, 0, 0)
    call ShowUnit(toy, false)
    set i = 0
    set len = StringLength(abillist)
    loop
        set str = SubString(abillist, i, i + 4)
        set abilcode = S2C(str)
        call UnitAddAbility(toy, abilcode)
        set abilobj = BlzGetUnitAbility(toy, abilcode)
        if (abilobj != null) then
            call SaveAbilityMaxLevel(abilcode, BlzGetAbilityIntegerField (abilobj, ABILITY_IF_LEVELS))
            call SaveAbilityRequireLevel(abilcode, BlzGetAbilityIntegerField(abilobj, ABILITY_IF_REQUIRED_LEVEL))
            call SaveAbilityResearchIcon( abilcode, BlzGetAbilityStringField(abilobj, ABILITY_SF_ICON_RESEARCH))
            call UnitRemoveAbility(toy, abilcode)
        endif
        set i = i + 5
        exitwhen i > len
    endloop
    call RemoveUnit(toy)
    ///end init
    call ReviseStorageData()
endfunction
//===========================================================================
