globals
    constant integer ABILITY_OBSOLETE = 'APai'
    constant integer ABILITY_SIMSKILL_BOOK = 'Smb0'
    //constant integer ABILITY_SIMSKILL_SLOT = 'SLO0'
    constant integer ABILITY_SHADOWMELD_BONUS = 'asmb'
    constant integer ITEM_OUT_OF_SKLIICOUNT = 'Rful'
    constant integer ITEM_REPEAT_SKILL = 'Rrpt'
    constant integer ITEM_CLOAK_OF_SHADOWS = 'clsd'
    constant integer ITEM_RUNE_EFFECT = 'rrfx'

    constant integer HERO_ABILITY_LEVEL_SKIP = 2
    constant integer MAX_SKILLSLOT_COUNT = 8
    ///=======================
    group g_groupShadowmeld
endglobals
//===========================================================================
function UnitDisableAbilitySafely takes unit u, integer abilcode, boolean disable returns nothing
    local integer flag = LoadInteger(g_hashtable, GetHandleId(u), abilcode)
    if (flag > 0 and disable) or (flag < 0 and not disable) then
        return//do nothing
    endif
    if disable then
        set flag = 1
    else
        set flag = -1
    endif
    call SaveInteger(g_hashtable, GetHandleId(u), abilcode, flag)
    call BlzUnitDisableAbility(u, abilcode, disable, true)
    call BlzUnitDisableAbility(u, abilcode, disable, false)
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
function RuneId2AbilityId takes integer runeid returns integer
    return runeid - 'R000' + 'a000'
endfunction
function IsSimSkillRune takes integer itemid returns boolean
    return itemid /0x1000000  == 'R'
endfunction
function UnitId2EnginskillId takes integer unitid returns integer
    return ModuloInteger(unitid, 0x1000000) + 'e' * 0x1000000
endfunction
function UnitGetSimedAbility takes unit u, integer slotNo returns integer
    return LoadInteger(g_hashtable, GetHandleId(u), 0xab1 + slotNo)
endfunction
function UnitSetSimedAbility takes unit u, integer slotNo, integer abilcode returns nothing
    call SaveInteger(g_hashtable, GetHandleId(u), 0xab1 + slotNo, abilcode)
endfunction
function ToSimslotCode takes integer slotNo returns integer
    return 'SLO0' + slotNo
endfunction
function ToSimslotNo takes integer slotcode returns integer
    return slotcode - 'SLO0'
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
    
    set simslot = ToSimslotCode(slotNo)
    set abilcode = UnitGetSimedAbility(u, slotNo)
    if (abilcode < 1) then
        call BlzUnitHideAbility(u, simslot, true)
        return
    elseif (abilcode == 'aamk') then
        call UnitDisableAbilitySafely(u, simslot, GetHeroSkillPoints(u) < 1)
        return
    endif
    set abilLevel = GetUnitAbilityLevel(u, abilcode)
    if (LoadAbilityMaxLevel(abilcode) <= abilLevel) then
        call BlzUnitHideAbility(u, simslot, true)
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
        set requireLevel = abilLevel * HERO_ABILITY_LEVEL_SKIP + 1
        set disable = requireLevel > heroLevel//skip level require
    endif
    if (not disable) then
        set disable = GetHeroSkillPoints(u) < 1
    endif   
    if (disable and requireLevel > heroLevel) then
        set ubertip = "|cffffff00需要:|n - 英雄等级:  " + I2S(requireLevel) + "|r|n|n" + ubertip
    endif 
    call BlzSetAbilityStringLevelField(simsobj , ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED, abilLevel, ubertip)  
    call UnitDisableAbilitySafely(u, simslot, disable)
endfunction
function UpdateSimslotsStatus takes unit u returns nothing
    local integer i = 1
    loop
        call UpdateSimslotsStatusEnum(u,  i)
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT 
    endloop
endfunction
//===========================================================================
function UpdateShowdowMeldBonus takes unit u returns nothing
    local boolean disabled = true
    if (GetUnitAbilityLevel(u, 'ashm') > 1) then
        if (LoadBoolean(g_hashtable, GetHandleId(u), ITEM_CLOAK_OF_SHADOWS)) then
            set disabled = false
        else
            set disabled = GetTimeOfDay() >= bj_TOD_DAWN and GetTimeOfDay() < bj_TOD_DUSK
        endif
    endif
    if disabled then
        call UnitRemoveAbility(u, ABILITY_SHADOWMELD_BONUS)
    else
        call UnitAddAbility(u, ABILITY_SHADOWMELD_BONUS)
        call BlzUnitHideAbility(u, ABILITY_SHADOWMELD_BONUS, true)
        call UnitMakeAbilityPermanent(u, true, ABILITY_SHADOWMELD_BONUS)
    endif
endfunction
//===========================================================================
function SelectHeroSimskill takes unit u, integer slotcode, boolean updateStatus returns nothing
    local integer abilcode
    local integer abillevel
    local integer slotnumber
    
    set slotnumber = ToSimslotNo(slotcode)
    set abilcode = UnitGetSimedAbility(u, slotnumber)
    set abillevel = GetUnitAbilityLevel(u, abilcode)
    if (abillevel > 0) then
        call SetUnitAbilityLevel(u, abilcode, abillevel + 1)

        if (abilcode == 'ashm') then
            call GroupAddUnit(g_groupShadowmeld, u)
            call UpdateShowdowMeldBonus(u)
        endif

    else
        call UnitAddAbility(u, abilcode)
        call UnitMakeAbilityPermanent(u, true, abilcode)
    endif
    set abillevel = GetUnitAbilityLevel(u, slotcode)
    call SetUnitAbilityLevel(u, slotcode, abillevel + 1)
    if updateStatus then
        call UpdateSimslotsStatusEnum(u, slotnumber)
    endif
endfunction
//===========================================================================
function TriggerCondition_Simskill takes nothing returns boolean
    local integer value = GetSpellAbilityId() - ToSimslotCode(1)//first slot
    return value > -1 and value < MAX_SKILLSLOT_COUNT
endfunction
function TriggerAction_Simskill takes nothing returns nothing
    local unit u = GetTriggerUnit()
    call SelectHeroSimskill(u, GetSpellAbilityId(), false)
    call UnitModifySkillPoints(u, -1)
    if (GetHeroSkillPoints(u) < 1) then
        call UnitRemoveAbility(u, ABILITY_SIMSKILL_BOOK)
        call UnitAddAbility(u, ABILITY_SIMSKILL_BOOK)      
        call UnitMakeAbilityPermanent(u, true, ABILITY_SIMSKILL_BOOK)
    endif
    call UpdateSimslotsStatus(u)
endfunction
//===========================================================================
function UnitInitSimslotData takes unit u, integer slotno, integer abilcode returns nothing
    local integer i
    local integer max
    local ability obj
    
    set obj = BlzGetUnitAbility(u, ToSimslotCode(slotno))
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
function InitDefaultSimslotData takes unit u returns nothing
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
        if (abilcode != 'aamk') then//attributemodskill
            call UnitInitSimslotData(u, slot, abilcode)
        endif
        call UnitSetSimedAbility(u, slot, abilcode)

        if (abilcode == 'ashm') then
            if (GetUnitAbilityLevel(u, 'Ashm') > 0) then
                call UnitRemoveAbility(u, 'Ashm')
                call SelectHeroSimskill(u, ToSimslotCode(slot), false)
            endif
        endif

        set i = i + 5
        set slot = slot + 1
    endloop
endfunction
function UpdateSimslotIcon takes unit u, integer slotNo returns boolean
    local integer abilcode = UnitGetSimedAbility(u, slotNo)
    if (abilcode > 0) then
        call BlzSetAbilityIcon(ToSimslotCode(slotNo), LoadAbilityResearchIcon(abilcode))
        return true
    endif
    return false
endfunction
function TriggerAction_UpdateSimSlotIcon takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer i

    set i = 1
    loop
        exitwhen not UpdateSimslotIcon(u, i)
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT
    endloop
endfunction
//===========================================================================
function TriggerAction_HeroLevelup takes nothing returns nothing
    local unit u = GetLevelingUnit()
    if (ModuloInteger(GetHeroLevel(u), 3) == 0) then
        call UnitModifySkillPoints(u, 1)
    endif
    call UpdateSimslotsStatus(u)
endfunction
//===========================================================================
function TriggerCondition_ManipulateShadowCloak takes nothing returns boolean
    return GetItemTypeId(GetManipulatedItem()) == ITEM_CLOAK_OF_SHADOWS
endfunction
function TriggerAction_LoseShadowCloak takes nothing returns nothing
    local unit u = GetTriggerUnit()
    call SaveBoolean(g_hashtable, GetHandleId(u), ITEM_CLOAK_OF_SHADOWS, false)
    if IsUnitInGroup(u, g_groupShadowmeld) then
        call UpdateShowdowMeldBonus(u)
    endif
endfunction
function TriggerAction_GetShadowCloak takes nothing returns nothing
    local unit u = GetTriggerUnit()
    call SaveBoolean(g_hashtable, GetHandleId(u), ITEM_CLOAK_OF_SHADOWS, true)
    if IsUnitInGroup(u, g_groupShadowmeld) then
        call UpdateShowdowMeldBonus(u)
    endif
endfunction
function CreateFloatText takes unit u, string text returns nothing

endfunction
function TriggerAction_HeroUseItem takes nothing returns nothing
    local unit  u = GetManipulatingUnit()
    local integer itemid =  GetItemTypeId(GetManipulatedItem())
    local integer i 
    local integer simscode
    local integer abilcode
    if (IsSimSkillRune(itemid)) then
        if (UnitGetSimedAbility(u, MAX_SKILLSLOT_COUNT)> 0) then
             call RemoveItem(UnitAddItemById(u, ITEM_OUT_OF_SKLIICOUNT))
            return
        endif
        set i = 1
        set abilcode = RuneId2AbilityId(itemid)
        loop
            set simscode = UnitGetSimedAbility(u, i)
            if (simscode < 1) then
                call RemoveItem(GetManipulatedItem())
                call UnitInitSimslotData(u, i, abilcode)
                call UnitSetSimedAbility(u, i, abilcode)
                call UpdateSimslotsStatusEnum(u, i)
                call UpdateSimslotIcon(u, i)
                call UnitAddItemById(u, ITEM_RUNE_EFFECT)
                //call CreateFloatText(u, GetObjectName(itemid))//TODO
                return
            endif
            if (IsIdenticalAbility(abilcode, simscode)) then
                call RemoveItem(UnitAddItemById(u, ITEM_REPEAT_SKILL))
                return
            endif
            set i = i + 1
            exitwhen i > MAX_SKILLSLOT_COUNT
        endloop
    elseif (itemid == 'retr') then
        set i = 1
        loop
            set abilcode = UnitGetSimedAbility(u, i)
            exitwhen abilcode < 1
            call UnitRemoveAbility(u, abilcode)
            call UnitSetSimedAbility(u, i, 0)
            set i = i + 1
            exitwhen i > MAX_SKILLSLOT_COUNT
        endloop
        call InitDefaultSimslotData(u)  
        set i = GetHeroLevel(u) + GetHeroLevel(u) / 3 - GetHeroSkillPoints(u)
        set itemid = GetUnitTypeId(u)
        if (itemid == 'Emoo' or itemid == 'Ewar' or itemid == 'Ntin') then
            set i = i + 1
        endif
        call UnitModifySkillPoints(u, i)
    endif
endfunction
//===========================================================================
function UnitSetupSimSystem takes unit u returns nothing
    local integer unitid = GetUnitTypeId(u)
    local integer engineid = UnitId2EnginskillId(unitid)
    local trigger trg
    local integer i
    local integer bookId

    call UnitAddAbility(u, engineid)
    call UnitRemoveAbility(u, engineid)
    set i = 0
    loop
        set bookId = ABILITY_SIMSKILL_BOOK + i
        call UnitAddAbility(u, bookId)
        call BlzUnitHideAbility(u, bookId, true)
        call UnitMakeAbilityPermanent(u, true, bookId)
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT
    endloop
    set i = 1
    loop
        call UnitMakeAbilityPermanent(u, true, ToSimslotCode(i))
        set i = i + 1
        exitwhen i > MAX_SKILLSLOT_COUNT
    endloop
    call BlzUnitHideAbility(u, ABILITY_SIMSKILL_BOOK, false)

    call InitDefaultSimslotData(u)
    call UpdateSimslotsStatus(u)
    //===============================================

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_SPELL_CAST)
    call TriggerAddCondition(trg, Condition(function TriggerCondition_Simskill))
    call TriggerAddAction(trg, function TriggerAction_Simskill)

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_SELECTED)
    call TriggerAddAction(trg, function TriggerAction_UpdateSimSlotIcon)

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_HERO_LEVEL)
    call TriggerAddAction(trg, function TriggerAction_HeroLevelup)

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_DROP_ITEM)
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_PAWN_ITEM)
    call TriggerAddCondition(trg, Condition(function TriggerCondition_ManipulateShadowCloak))
    call TriggerAddAction(trg, function TriggerAction_LoseShadowCloak)
    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_PICKUP_ITEM)
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_SELL_ITEM)
    call TriggerAddCondition(trg, Condition(function TriggerCondition_ManipulateShadowCloak))
    call TriggerAddAction(trg, function TriggerAction_GetShadowCloak)

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
    call UnitSetSimedAbility(u, 1, abilcode)

    //2:Cluster Rockets
    set abilcode = 'ANc0' + level
    call UnitSetSimedAbility(u, 2, abilcode)

    //4:Robo-Goblin
    set abilcode = 'ANg0' + level
    call UnitSetSimedAbility(u, 4, abilcode)    

    //6:Demolish
    set abilcode = 'ANd0' + level
    call UnitSetSimedAbility(u, 6, abilcode)     

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
    if (abilcode  == ToSimslotCode(3)) then//Engineering Upgrade:3
        call ReviseEngineeringUpgrade(u)
    endif
endfunction
function TriggerAction_TinkerLevelUp takes nothing returns nothing
    local unit u = GetLevelingUnit()
    if (GetHeroLevel(u) >= LoadAbilityRequireLevel('aNde')) then
        call SelectHeroSimskill(u, ToSimslotCode(6), true)//Demolish:6
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction
//===========================================================================
function TriggerAction_NeutralHeroSummoned takes nothing returns nothing
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
//===========================================================================
function TriggerAction_HeroTrainFinished takes nothing returns nothing
    call UnitSetupSimSystem(GetTrainedUnit())
endfunction
//===========================================================================
function TriggerAction_ShadowmeldEnum takes nothing returns nothing
    call UpdateShowdowMeldBonus(GetEnumUnit())
endfunction
function TriggerAction_DawnAndDusk takes nothing  returns nothing
    call ForGroup(g_groupShadowmeld, function TriggerAction_ShadowmeldEnum)
endfunction
//===========================================================================
function InitRuneSystem takes nothing returns nothing
    local trigger trg
    local player p

    set p = GetLocalPlayer()
    call SetPlayerAbilityAvailable(p, ABILITY_OBSOLETE, false)

    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_TRAIN_FINISH, filterMeleeTrainedUnitIsHeroBJ)
    call TriggerAddAction(trg, function TriggerAction_HeroTrainFinished)

    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, Player(PLAYER_NEUTRAL_PASSIVE), EVENT_PLAYER_UNIT_SELL, filterMeleeTrainedUnitIsHeroBJ)
    call TriggerAddAction(trg, function TriggerAction_NeutralHeroSummoned)

    set trg = CreateTrigger()
    call TriggerRegisterGameStateEvent(trg, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DAWN)
    call TriggerRegisterGameStateEvent(trg, GAME_STATE_TIME_OF_DAY, EQUAL, bj_TOD_DUSK)
    call TriggerAddAction(trg, function TriggerAction_DawnAndDusk)
endfunction