globals
    constant integer ABILITY_OBSOLETE = 'APai'
    constant integer ABILITY_SIMSKILL_BOOKA = 'SB00'
    constant integer ABILITY_SIMSKILL_SLOTA = 'SL00'
    constant integer ABILITY_WELLSPRING_MANA = 'awsM'
    constant integer ABILITY_WELLSPRING_RESTORE = 'awsR'
    constant integer ABILITY_PHOENIXFIRE_ICON = 'apxi'

    constant integer ITEM_OUT_OF_SKLIICOUNT = 'rful'
    constant integer ITEM_REPEAT_SKILL = 'rrpt'
    constant integer ITEM_RUNE_EFFECT = 'rrfx'

    constant integer HERO_ABILITY_LEVEL_SKIP = 2
    constant integer MAX_SKILLSLOT_COUNT = 8

    constant integer MAX_LANDMINE_COUNT = 5

    constant string  ABILITYLIST_CHANNEL = "aetf,agsp,auco"

    boolexpr           filterLivingPlayerUnitsOfTypeIdCounted      = null
endglobals
//===========================================================================
function SetUnitAbilityState takes unit u, integer abilcode, boolean disabled, boolean hidden returns nothing 
    local integer state = LoadInteger(g_hashtable, GetHandleId(u), abilcode)
    local integer flag = 0

    if (hidden) then
        set flag = 1
    endif
    if (disabled) then
        set flag = flag + 2
    endif
    if (state  == flag) then
        return//do nothing
    endif

    if (hidden) then
        call BlzUnitDisableAbility(u, abilcode, disabled, hidden)
    else//not hidden
        if (BlzBitAnd(state, 1) == 0) then
            call BlzUnitDisableAbility(u, abilcode, disabled, true)
        endif
        call BlzUnitDisableAbility(u, abilcode, disabled, hidden)
    endif
    call SaveInteger(g_hashtable, GetHandleId(u), abilcode, flag)
endfunction
//===========================================================================
function IsIdenticalAbility takes integer code1, integer code2 returns boolean
    if (code1 == code2) then
        return true
    elseif (ModuloInteger(code1, 0x1000000) == ModuloInteger(code2, 0x1000000)) then
        return true
    else //TODO

    endif
    return false
endfunction
//===========================================================================
function UnitAddPowerupItem takes unit u, integer itemid returns item
    local item whichItem = CreateItem(itemid, 0, 0)
    call SetItemVisible(whichItem, false)
    call UnitAddItem(u, whichItem)
    return whichItem
endfunction
//===========================================================================
function RuneId2AbilityId takes integer runeid returns integer
    return runeid - 'R000' + 'a000'
endfunction
function IsSimSkillRune takes integer itemid returns boolean
    return itemid /0x1000000  == 'R'
endfunction
function UnitId2EnginskillId takes integer unitid returns integer
    return ModuloInteger(unitid, 0x1000000) + 'e' * 0x1000000
endfunction
function LoadUnitSimedAbility takes unit u, integer slotNo returns integer
    if slotNo == 0 then
        return 'aamk'
    endif
    return LoadInteger(g_hashtable, GetHandleId(u), 0xab1 + slotNo)
endfunction
function SaveUnitSimedAbility takes unit u, integer slotNo, integer abilcode returns nothing
    call SaveInteger(g_hashtable, GetHandleId(u), 0xab1 + slotNo, abilcode)
endfunction
function GetSimslotCode takes unit u, integer slotNo returns integer
    local integer index = GetUnitUserData(u)
    return ABILITY_SIMSKILL_SLOTA + index * 0x100 + slotNo
endfunction
function ToSimslotNo takes integer slotcode returns integer
    if (slotcode == ABILITY_SIMSKILL_SLOTA) then
        return 0
    endif
    return ModuloInteger(slotcode, 0x100) - '0'
endfunction
function GetSimskillBookId takes unit u, integer slotNo returns integer
    local integer index = GetUnitUserData(u)
    return ABILITY_SIMSKILL_BOOKA + index * 0x100 + slotNo
endfunction
//===========================================================================
function UpdateSimslotsStatusEnum takes unit u, integer slotNo returns nothing
    local string ubertip
    local integer abilcode
    local integer simslot 
    local integer heroLevel = 0
    local integer abilLevel = 0
    local integer requireLevel = 0
    local boolean disable = false
    local ability simsobj
    
    if (slotNo < 1) then//attributemodskill
        call SetUnitAbilityState(u, ABILITY_SIMSKILL_SLOTA, GetHeroSkillPoints(u) < 1, false)
        return
    endif
    set simslot = GetSimslotCode(u, slotNo)
    set abilcode = LoadUnitSimedAbility(u, slotNo)
    if (abilcode < 1) then
        call SetUnitAbilityState(u, simslot, false, true)
        return
    endif
    set abilLevel = GetUnitAbilityLevel(u, abilcode)
    if (LoadAbilityMaxLevel(abilcode) <= abilLevel) then
        call SetUnitAbilityState(u, simslot, false, true)
        return
    endif
    ///-----------------------------------------------------
    set simsobj = BlzGetUnitAbility(u, simslot)
    set ubertip = BlzGetAbilityExtendedTooltip(abilcode, abilLevel)
    if (not disable) then
        set heroLevel = GetHeroLevel(u)
        set requireLevel = BlzGetAbilityIntegerField(simsobj, ABILITY_IF_REQUIRED_LEVEL)
        set disable = requireLevel > heroLevel//level require
    endif
    if (not disable) then
        set requireLevel = requireLevel + abilLevel * HERO_ABILITY_LEVEL_SKIP
        set disable = requireLevel > heroLevel//skip level require
    endif
    if (not disable) then
        set disable = GetHeroSkillPoints(u) < 1
    endif   
    if (disable and requireLevel > heroLevel) then
        set ubertip = "|cffffff00需要:|n - 英雄等级:  " + I2S(requireLevel) + "|r|n|n" + ubertip
    endif 
    call BlzSetAbilityStringLevelField(simsobj , ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, abilLevel, ubertip)  
    call SetUnitAbilityState(u, simslot, disable, false)
endfunction
function UpdateSimslotsStatus takes unit u returns nothing
    local integer i = 0
    loop
        call UpdateSimslotsStatusEnum(u,  i)
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT 
    endloop
    //simskill icon
    if (GetHeroSkillPoints(u) > 0) then
        set i = GetSimskillBookId(u, 0)
        call BlzSetAbilityIcon(i, BlzGetAbilityActivatedIcon(i))
    else
        call BlzSetAbilityIcon(GetSimskillBookId(u, 0), LoadUnitIcon(u))
    endif
endfunction
//===========================================================================
function SimulateEthereal takes unit u, integer abilcode returns nothing
    call SetUnitAbilityState(u, abilcode, false, true)
    set abilcode = 'acpf'
    call SetUnitAbilityState(u, abilcode, false, false)
    call BlzStartUnitAbilityCooldown(u, abilcode, 29.3)
    set abilcode = 'Aetl'
    call UnitAddAbility(u, abilcode)
    call BlzUnitHideAbility(u, abilcode, true)
    call UnitMakeAbilityPermanent(u, true, abilcode)
endfunction
function SimulateCorporeal takes unit u, integer abilcode returns nothing
    call UnitRemoveAbility(u, 'Aetl')
    call SetUnitAbilityState(u, 'acpf', false, true)
    call SetUnitAbilityState(u, 'aetf', false, false)
endfunction
function SimulateSummonGoblinSapper takes unit u, integer abilcode  returns nothing
    set u = CreateUnit(GetOwningPlayer(u), 'ngsp', GetSpellTargetX(), GetSpellTargetY(), GetUnitFacing(u))
    call UnitApplyTimedLife(u, 'BNcg', 30.0)
endfunction
function SimulateUnstableConcoction takes unit u, integer abilcode  returns nothing
    local unit locust
    call ShowUnit(u, false)
    set locust = CreateUnit(GetOwningPlayer(u), 'otbr', GetUnitX(u), GetUnitY(u), GetUnitFacing(u))
    call SetUnitUseFood(locust, false)
    call SetUnitVertexColor(locust, 64,64,64, 127)
    call UnitAddAbility(locust, 'Aloc')
    //call UnitAddAbility(locust, 'Aetl')
    call IssueTargetOrder(locust, "unstableconcoction", GetSpellTargetUnit())
    call KillUnit(u)
endfunction
//===========================================================================
function TriggerAction_CustomSpell takes nothing returns nothing
    local integer abilcode = GetSpellAbilityId()
    local unit u = GetTriggerUnit()
    if (abilcode == 'aetf') then
        call SimulateEthereal(u, abilcode)
    elseif (abilcode == 'acpf') then
        call SimulateCorporeal(u, abilcode)
    elseif (abilcode == 'agsp') then
        call SimulateSummonGoblinSapper(u, abilcode)
    elseif (abilcode == 'auco') then
        call SimulateUnstableConcoction(u, abilcode)
    endif
endfunction
function RegisterCustomChannelEvent takes unit u, integer abilcode returns nothing
    local trigger trig = null
    local string str = C2S(abilcode)
    if (StringContains(ABILITYLIST_CHANNEL, str)) then
        set trig = LoadTriggerHandle(g_hashtable, GetHandleId(u), StringHash("CustomChannel"))
        if (trig == null) then
            set trig = CreateTrigger()
            call TriggerRegisterUnitEvent(trig, u, EVENT_UNIT_SPELL_EFFECT)
            call TriggerAddAction(trig, function TriggerAction_CustomSpell)    
            call SaveTriggerHandle(g_hashtable, GetHandleId(u), StringHash("CustomChannel"), trig)
        endif
    endif
endfunction
//===========================================================================
function UnitAddSimedAbility takes unit u, integer abilcode returns nothing
    call UnitAddAbility(u, abilcode)
    call UnitMakeAbilityPermanent(u, true, abilcode)
    if (abilcode == 'aews') then
        call UnitAddAbility(u, ABILITY_WELLSPRING_MANA)
        call UnitMakeAbilityPermanent(u, true, ABILITY_WELLSPRING_MANA)
        call UnitAddAbility(u, ABILITY_WELLSPRING_RESTORE)
        call UnitMakeAbilityPermanent(u, true, ABILITY_WELLSPRING_RESTORE)
    elseif (abilcode == 'aetf') then
        set abilcode = 'acpf'
        call UnitAddAbility(u, abilcode)
        call UnitMakeAbilityPermanent(u, true, abilcode)
        call SetUnitAbilityState(u, abilcode, false, true)
    elseif (abilcode == 'apxf') then
        call UnitAddAbility(u, ABILITY_PHOENIXFIRE_ICON)
        call UnitMakeAbilityPermanent(u, true, ABILITY_PHOENIXFIRE_ICON)
    endif
endfunction
function UnitRemoveSimedAbility takes unit u, integer abilcode returns nothing
    call UnitRemoveAbility(u, abilcode)
    if (abilcode == 'aews') then
        call UnitRemoveAbility(u, ABILITY_WELLSPRING_MANA)
        call UnitRemoveAbility(u, ABILITY_WELLSPRING_RESTORE)
    elseif(abilcode == 'apxf') then
        call UnitRemoveAbility(u, ABILITY_PHOENIXFIRE_ICON)
    elseif(abilcode == 'aetf') then
        call SetUnitAbilityState(u, 'aetf', false, false)
        call SetUnitAbilityState(u, 'acpf', false, false)
        call UnitRemoveAbility(u, 'acpf')
        call UnitRemoveAbility(u, 'Aetl')
    endif
endfunction
//===========================================================================
function SetUnitSimedAbilityLevel takes unit u, integer abilcode, integer level returns nothing
    if (level > 1) then
        call SetUnitAbilityLevel(u, abilcode, level)
     else//add new ability
        call UnitAddSimedAbility(u, abilcode)
        call RegisterCustomChannelEvent(u, abilcode)
    endif
endfunction
function SelectHeroSimskill takes unit u, integer slotcode, boolean updateStatus returns nothing
    local integer abilcode
    local integer abillevel
    local integer slotnumber
    
    set slotnumber = ToSimslotNo(slotcode)
    set abilcode = LoadUnitSimedAbility(u, slotnumber)
    set abillevel = GetUnitAbilityLevel(u, abilcode) + 1
    call SetUnitSimedAbilityLevel(u, abilcode, abillevel)
    set abillevel = GetUnitAbilityLevel(u, slotcode) + 1
    call SetUnitAbilityLevel(u, slotcode, abillevel)
    if updateStatus then
        call UpdateSimslotsStatusEnum(u, slotnumber)
    endif
endfunction
//===========================================================================
function ModifyHeroSkillPointsEx takes unit whichHero, string modifyMethod, integer points returns nothing
    local integer hascode = StringHash("UsedSkillPoints")
    if (modifyMethod == "levelup") then
        set points = GetHeroLevel(whichHero) + GetHeroLevel(whichHero) / 3
        set points = points - LoadInteger(g_hashtable, GetHandleId(whichHero), hascode)
        call ModifyHeroSkillPoints(whichHero, bj_MODIFYMETHOD_SET, points)//recalc
    elseif (modifyMethod == "learn") then
        set points = LoadInteger(g_hashtable, GetHandleId(whichHero), hascode)
        call SaveInteger(g_hashtable, GetHandleId(whichHero), hascode, points + 1)
        call UnitModifySkillPoints(whichHero, -1)//sub
    elseif (modifyMethod == "retrain") then
        set points = LoadInteger(g_hashtable, GetHandleId(whichHero), hascode) - points//used points
        set points = IMaxBJ(0, points)
        call SaveInteger(g_hashtable, GetHandleId(whichHero), hascode, points)
        set points = GetHeroLevel(whichHero) + GetHeroLevel(whichHero) / 3 - points//remains points
        call ModifyHeroSkillPoints(whichHero, bj_MODIFYMETHOD_SET, points)//recalc
    endif
endfunction
//===========================================================================
function TriggerCondition_Simskill takes nothing returns boolean
    local integer value = GetSpellAbilityId()
    if (value == ABILITY_SIMSKILL_SLOTA) then
        return true//aamk
    endif
    set value = value - GetSimslotCode(GetTriggerUnit(), 0)//first slot
    return value > 0 and value <= MAX_SKILLSLOT_COUNT
endfunction
function TriggerAction_Simskill takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer book
    call SelectHeroSimskill(u, GetSpellAbilityId(), false)
    call ModifyHeroSkillPointsEx(u,"learn", -1)
    if (GetHeroSkillPoints(u) < 1) then
        set book = GetSimskillBookId(u, 0)
        call UnitRemoveAbility(u, book)
        call UnitAddAbility(u, book)      
        call UnitMakeAbilityPermanent(u, true, book)
    endif
    call UpdateSimslotsStatus(u)
endfunction
//===========================================================================
function InitUnitSimslot takes unit u, integer slotno, integer abilcode returns nothing
    local integer i
    local integer max
    local ability obj
    local integer slotcode

    set slotcode = GetSimslotCode(u, slotno)
    call SetUnitAbilityLevel(u, slotcode, 1)//init
    call BlzSetAbilityIcon(slotcode, LoadAbilityResearchIcon(abilcode))
    set obj = BlzGetUnitAbility(u, slotcode)
    set max = LoadAbilityMaxLevel(abilcode)
    set i = 0
    loop
        call BlzSetAbilityStringLevelField(obj, ABILITY_SLF_TOOLTIP_NORMAL, i, "学习" + BlzGetAbilityTooltip(abilcode, i))
        set i = i + 1
        exitwhen i >=  max
    endloop
    call BlzSetAbilityIntegerField(obj, ABILITY_IF_LEVELS, max)
    call BlzSetAbilityIntegerField(obj, ABILITY_IF_REQUIRED_LEVEL, LoadAbilityRequireLevel(abilcode))
endfunction
function InitDefaultSimslotList takes unit u returns nothing
    local integer abilcode
    local string str
    local integer i
    local integer len 
    local integer slot
    local string skillList

    set skillList = LoadUnitHeroAbilityList(GetUnitTypeId(u))
    set i = 0
    set slot = 1
    set len = StringLength(skillList)
    loop     
        exitwhen i > len
        set str = SubString(skillList, i, i + 4)
        set abilcode = S2C(str)
        call InitUnitSimslot(u, slot, abilcode)
        call SaveUnitSimedAbility(u, slot, abilcode)
        set i = i + 5
        set slot = slot + 1
    endloop

    call UnitAddAbility(u, ABILITY_SIMSKILL_BOOKA)
    call UnitMakeAbilityPermanent(u, true, ABILITY_SIMSKILL_BOOKA)
    call UnitMakeAbilityPermanent(u, true, ABILITY_SIMSKILL_SLOTA)
endfunction
//===========================================================================
function TriggerAction_HeroLevelup takes nothing returns nothing
    local unit u = GetLevelingUnit()
    call ModifyHeroSkillPointsEx(u, "levelup", 1)
    call UpdateSimslotsStatus(u)
endfunction
//===========================================================================
function CreateFloatText takes unit u, string s returns nothing
    local texttag tag = CreateTextTagUnitBJ(s, u, 0, 9.6, 0, 100, 0, 0)
    call SetTextTagLifespan(tag, 2.1)
    call SetTextTagPermanent(tag, false)
    call SetTextTagVelocityBJ(tag, 175, 90)
    call SetTextTagFadepoint(tag, 0.67)
    call TriggerSleepAction(1.67)
    call DestroyTextTag(tag)
endfunction
function TriggerAction_HeroUseItem takes nothing returns nothing
    local unit  u = GetManipulatingUnit()
    local integer itemid =  GetItemTypeId(GetManipulatedItem())
    local integer simscode
    local integer abilcode
    local integer bookid
    local integer points
    local integer i 
    if (IsSimSkillRune(itemid)) then
        if (LoadUnitSimedAbility(u, MAX_SKILLSLOT_COUNT)> 0) then
             call RemoveItem(UnitAddPowerupItem(u, ITEM_OUT_OF_SKLIICOUNT))
            return
        endif
        set i = 1
        set abilcode = RuneId2AbilityId(itemid)
        loop
            set simscode = LoadUnitSimedAbility(u, i)
            if (simscode < 1) then
                call RemoveItem(GetManipulatedItem())
                call SetUnitAbilityState(u, GetSimslotCode(u, i), false, false)
                call InitUnitSimslot(u, i, abilcode)
                call SaveUnitSimedAbility(u, i, abilcode)
                call UpdateSimslotsStatusEnum(u, i)
                call UnitAddPowerupItem(u, ITEM_RUNE_EFFECT)
                call CreateFloatText(u, "获得技能 - " + GetObjectName(abilcode))
                return
            endif
            if (IsIdenticalAbility(abilcode, simscode)) then
                call RemoveItem(UnitAddPowerupItem(u, ITEM_REPEAT_SKILL))
                return
            endif
            set i = i + 1
            exitwhen i > MAX_SKILLSLOT_COUNT
        endloop
    elseif (itemid == 'tret') then
        set i = 0
        set points = 0
        set bj_forLoopAIndexEnd = 4//TODO: Ntin
        loop
            set abilcode = LoadUnitSimedAbility(u, i)
            if (abilcode > 0) then
                if (BlzGetUnitAbilityCooldownRemaining(u, abilcode) <= 0) then
                    set points = points + GetUnitAbilityLevel(u, abilcode)
                    call UnitRemoveSimedAbility(u, abilcode)
                    if (i > bj_forLoopAIndexEnd) then//extra
                        call SaveUnitSimedAbility(u, i, 0)
                    else//default
                        call InitUnitSimslot(u, i, abilcode)
                    endif
                endif
            endif
            set i = i + 1
            exitwhen i > MAX_SKILLSLOT_COUNT
        endloop
        call ModifyHeroSkillPointsEx(u, "retrain", points)
        call UpdateSimslotsStatus(u)
    endif
endfunction
//===========================================================================
function GetPlayerHeroCount takes player p returns integer
    local group g = CreateGroup()
    local integer count = 0 
    call GroupEnumUnitsOfPlayer(g, p, filterMeleeTrainedUnitIsHeroBJ)
    set count = CountUnitsInGroup(g)
    call DestroyGroup(g)
    return count
endfunction
function UnitSetupSimSystem takes unit u returns nothing
    local integer unitid = GetUnitTypeId(u)
    local integer engineid = UnitId2EnginskillId(unitid)
    local trigger trg
    local integer i
    local integer bookId

    call SetUnitUserData(u, GetPlayerHeroCount(GetOwningPlayer(u)))
    //clear default abils
    call UnitAddAbility(u, engineid)
    call UnitRemoveAbility(u, engineid)

    //init book
    set i = 0
    loop
        set bookId = GetSimskillBookId(u, i)
        call UnitAddAbility(u, bookId)
        call UnitMakeAbilityPermanent(u, true, bookId)
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT
    endloop
    //set slot permanent
    set i = 1
    loop
        call UnitMakeAbilityPermanent(u, true, GetSimslotCode(u, i))
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT
    endloop
    call InitDefaultSimslotList(u)

    call UpdateSimslotsStatus(u)
    //===============================================

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_SPELL_CAST)
    call TriggerAddCondition(trg, Condition(function TriggerCondition_Simskill))
    call TriggerAddAction(trg, function TriggerAction_Simskill)

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_HERO_LEVEL)
    call TriggerAddAction(trg, function TriggerAction_HeroLevelup)

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_USE_ITEM)
    call TriggerAddAction(trg, function TriggerAction_HeroUseItem)
endfunction
//===========================================================================
function ReviseEngineeringUpgrade takes unit u returns nothing
    local integer abilcode = 'ANeg'
    local integer level = GetUnitAbilityLevel(u, abilcode)

    //1:Pocket Factory
    set abilcode = 'ANs0' + level
    call SaveUnitSimedAbility(u, 1, abilcode)

    //2:Cluster Rockets
    set abilcode = 'ANc0' + level
    call SaveUnitSimedAbility(u, 2, abilcode)

    //4:Robo-Goblin
    set abilcode = 'ANg0' + level
    call SaveUnitSimedAbility(u, 4, abilcode)    

    //5:Demolish
    set abilcode = 'ANd0' + level
    call SaveUnitSimedAbility(u, 5, abilcode)     

    ///fixed blizzard's bug
    // call UnitRemoveAbility(u, abilcode)
    // call UnitAddAbility(u, abilcode)
    // call SetUnitAbilityLevel(u, abilcode, level)
    // call UnitMakeAbilityPermanent(u, true, abilcode)
endfunction
//===========================================================================
function TriggerAction_TinkerCastSpell takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer abilcode = GetSpellAbilityId()
    if (abilcode  == GetSimslotCode(u, 3)) then//Engineering Upgrade:3
        call ReviseEngineeringUpgrade(u)
    endif
endfunction
function TriggerAction_TinkerLevelUp takes nothing returns nothing
    local unit u = GetLevelingUnit()
    if (GetHeroLevel(u) >= LoadAbilityRequireLevel('aNde')) then
        call SelectHeroSimskill(u, GetSimslotCode(u, 5), true)//Demolish:5
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction
//===========================================================================
function TriggerAction_SetupSimSystemToHiredHero takes nothing returns nothing
    local unit u  = GetSoldUnit()
    local trigger trg
    if (GetPlayerController(GetOwningPlayer(u)) == MAP_CONTROL_USER) then
        call UnitSetupSimSystem(u) 
        if (GetUnitTypeId(u)  == 'Ntin') then
            set trg = CreateTrigger()
            call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_HERO_LEVEL)
            call TriggerAddAction(trg, function TriggerAction_TinkerLevelUp)
            set trg = CreateTrigger()
            call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_SPELL_ENDCAST)
            call TriggerAddAction(trg, function TriggerAction_TinkerCastSpell)
        endif
    endif
endfunction
function TriggerAction_SetupSimSystemToTrainedHero takes nothing returns nothing
    call UnitSetupSimSystem(GetTrainedUnit())
endfunction
//===========================================================================
function TriggerAction_UnitSummon takes nothing returns nothing
    local unit u = GetSummonedUnit()
    local integer unitId = GetUnitTypeId(u)
    if (unitId == 'nglm') then
        set bj_lastCreatedGroup = CreateGroup()
        set bj_groupEnumTypeId = unitId
        set bj_groupCountUnits = 0
        set bj_groupRandomCurrentPick = null
        call GroupEnumUnitsOfPlayer(bj_lastCreatedGroup, GetOwningPlayer(u), filterLivingPlayerUnitsOfTypeIdCounted)
        if (bj_groupCountUnits > MAX_LANDMINE_COUNT) then
            call KillUnit(bj_groupRandomCurrentPick)
        endif
        call DestroyGroup(bj_lastCreatedGroup)
    endif
endfunction
//===========================================================================
function FilterLivingPlayerUnitsOfTypeIdAndCounted takes nothing returns boolean
    local unit filterUnit = GetFilterUnit()
    if (IsUnitAliveBJ(filterUnit) and GetUnitTypeId(filterUnit) == bj_groupEnumTypeId) then
        set bj_groupCountUnits = bj_groupCountUnits + 1
        set bj_groupRandomCurrentPick = filterUnit
        return true
    endif
    return false
endfunction
//===========================================================================
function InitRuneSystem takes nothing returns nothing
    local trigger trg
    local player p

    set filterLivingPlayerUnitsOfTypeIdCounted = Filter(function FilterLivingPlayerUnitsOfTypeIdAndCounted)

    set p = GetLocalPlayer()
    call SetPlayerAbilityAvailable(p, ABILITY_OBSOLETE, false)

    set  trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_SUMMON, null)
    call TriggerAddAction(trg, function TriggerAction_UnitSummon)

    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_TRAIN_FINISH, filterMeleeTrainedUnitIsHeroBJ)
    call TriggerAddAction(trg, function TriggerAction_SetupSimSystemToTrainedHero)

    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, Player(PLAYER_NEUTRAL_PASSIVE), EVENT_PLAYER_UNIT_SELL, filterMeleeTrainedUnitIsHeroBJ)
    call TriggerAddAction(trg, function TriggerAction_SetupSimSystemToHiredHero)
endfunction