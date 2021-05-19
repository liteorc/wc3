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
//===========================================================================
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
    call SaveUnitHeroAbilityList('Ntin', "aNsy,aNcs,aNeg,aNrg,aNde")
    call SaveUnitHeroAbilityList('Nplh', "ANrf,ANht,ANca,ANdo")
    call SaveUnitHeroAbilityList('Nfir', "ANso,ANlm,ANia,ANvc")
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
    call InitDefaultHeroAbilList()
    //hero ability list
    set abillist = "AHbz,AHwe,AHab,AHmt,AHfs,AHbn,AHdr,AHpx,AHtb,AHtc,AHbh,AHav,AHhb,AHds,AHad,AHre,AOwk,AOmi,AOcr,AOww,AOcl,AOfs,AOsf,AOeq,AOhw,AOhx,AOsw,AOvd,AOsh,AOws,AOae,AOre,AEmb,AEim,AEev,AEme,AEer,AEfn,AEah,AEtq,AEst,AHfa,AEar,AEsf,AEfk,AEbl,AEsh,AEsv,AUim,AUts,AUcb,AUls,AUdc,AUdp,AUau,AUan,AUcs,AUsl,AUav,AUin,AUfn,AUfu,AUdr,AUdd,ANsi,ANba,ANdr,ANch,ANsg,ANsq,ANsw,ANst,ANfl,ANfa,ANms,ANto,ANbf,ANdh,ANdb,ANef,ANhs,ANcr,ANab,ANtm,aNsy,aNcs,aNeg,aNrg,aNde,ANrf,ANht,ANca,ANdo,ANso,ANlm,ANia,ANvc,"
    //extra hero abilities
    set abillist = abillist+"aews,"
    set abillist = abillist+"aOcr,aUts,aEev,aHbh,aNdb,aNca,aabs,aap1,aCdv,aegr,afbk,assk,amdf,awar,asal,auco,aIpm,apig,aspo,acn2,aven,aeat,aNba,aHfa,aNfa,aEim,aadm,aivs,aHbn,aspl,aam2,adcn,aroa,asta,ahwd,apxf,arpl,arpm,ahea,ablo,ainf,acrs,afae,aslo,apg2,arej,aroc,aUfu,aOwk,alsh,aply,aUsl,acmg,aNpa,aHhb,adis,acyc,aHdr,aHbz,aUdc,aNhs,asps,apsh,aOsw,advm,aEmb,aOhx,aOws,aHtc,aNdr,aCfb,aCtb,aEer,aEsh,arai,aNrf,aOsh,aCcv,aUfn,aHtb,aCcb,aOhw,aUim,aOcl,aNms,aEbl,aNbf,aNmo,aUcs,aCbf,acri,aHfs,aNfl,aweb,aNso,aNht,aNab,atau,aNfd,aens,ache,aNsi,amfl,aEfn,aHwe,aNsq,absk,afzy,amls,aOsf,aHds,aNdp"
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
