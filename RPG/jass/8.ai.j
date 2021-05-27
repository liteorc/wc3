globals
    boolexpr filterEnumStuctureIsTownhall
    boolexpr filterEnumStuctureIsGoldmine

    force g_neutralHeroAI
endglobals

//===========================================================================
function Filter_IsUnitTypeOfGoldmine takes nothing returns boolean
    if( GetUnitTypeId(GetFilterUnit()) == 'ngol') then
        set bj_groupCountUnits = bj_groupCountUnits + 1
        return true
    endif
    return false
endfunction
function Filter_IsUnitTypeOfTownhall takes nothing returns boolean
    return IsUnitType(GetFilterUnit(), UNIT_TYPE_TOWNHALL)
endfunction
//===========================================================================
function Filter_AISurrender takes nothing returns boolean
    local unit u = GetFilterUnit()
    local filterfunc filter
    if (IsUnitDeadBJ(u))then
        return false
    endif
    if (IsUnitType(u, UNIT_TYPE_PEON)) then
        set bj_forLoopAIndex = bj_forLoopAIndex + 1
        return false
    endif
    if (bj_groupCountUnits < 1) then
        if (GetUnitTypeId(u) == 'egol' or GetUnitTypeId(u) == 'ugol') then
            set bj_groupCountUnits = bj_groupCountUnits + 1
            return false
        endif
    endif
    if (bj_forLoopBIndex < 1 and IsUnitType(u, UNIT_TYPE_TOWNHALL)) then
        set bj_forLoopBIndex = bj_forLoopBIndex + 1
        if (bj_groupCountUnits < 1) then
            set bj_lastCreatedGroup = CreateGroup()
            call GroupEnumUnitsInRangeCounted(bj_lastCreatedGroup, GetUnitX(u), GetUnitY(u), 900.0, filterEnumStuctureIsGoldmine, 1)
            call DestroyGroup(bj_lastCreatedGroup)
        endif
        return false
    endif
    return false
endfunction
function TriggerAction_AISurrender takes nothing returns nothing
    local player p = GetTriggerPlayer()
    local group g
    local filterfunc filter 
    local boolean defeated = false
    if (GetPlayerTechCount(p, 'HERO', false) > 0) then
        return
    endif

    set bj_forLoopAIndex = 0//peon
    set bj_forLoopBIndex = 0//town
    set bj_groupCountUnits = 0//goldmine
    set g = CreateGroup()
    set filter = Filter(function Filter_AISurrender)
    call GroupEnumUnitsOfPlayer(g, p, filter)
    call DestroyGroup(g)
    call DestroyFilter(filter)
    if (bj_forLoopAIndex > 0) then//has peon
        set defeated = bj_groupCountUnits < 1 and GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) < 500
    else//no peon
        if (bj_forLoopBIndex > 0) then//has town
            set bj_forLoopBIndexEnd = GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)
            set defeated = bj_forLoopBIndexEnd < 40 and bj_forLoopBIndexEnd > GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_CAP)
        else//no town
            set defeated = true
        endif
    endif
    if defeated then
        call BlzDisplayChatMessage(p, 0, "gg")
        call CachePlayerHeroData(p)
        call MeleeDoLeave(p)
        call MakeUnitsPassiveForPlayer(p)
        call MeleeCheckForLosersAndVictors()
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction
function TriggerCondition_DeathIsConstruct takes nothing returns boolean
    return IsUnitType(GetDyingUnit(), UNIT_TYPE_STRUCTURE)
endfunction
function ChooseRandomName takes string str returns string 
    local string name
    local integer i = GetRandomInt(0,100)
    call SetRandomSeed(i * R2I(GetTimeOfDay()))
    if (i > 66) then
        set i = GetRandomInt(1, 10)
        set i = ChooseRandomCreep(i)
        set name = GetObjectName(i)
    else
        set i = GetRandomInt(1, 10)
        set i = ChooseRandomItem(i)
        set name = GetObjectName(i)
    endif
    if (StringContains(str, name)) then
        return ChooseRandomName(str)
    endif
    return name
endfunction
//===========================================================================
function TriggerAction_AIHeroRevive takes nothing returns nothing
    local unit u = GetTriggerUnit()
    call SetUnitPathing(u, false)
    call TriggerSleepAction(2.0)
    call SetUnitPathing(u, true)
endfunction
function TriggerAction_AIHeroTrained takes nothing returns nothing
    local unit u = GetTriggerUnit()
    call SetUnitUseFood(u, false)
endfunction
function TriggerAction_AIStuctureUpgraded takes nothing returns nothing
    local integer unitid = GetUnitTypeId(GetTriggerUnit())
    if (unitid == 'hcas' or unitid == 'ofrt' or unitid == 'unp2' or unitid == 'etoe') then
        call ForceAddPlayer(g_neutralHeroAI, GetTriggerPlayer())
        call DestroyTrigger(GetTriggeringTrigger())
    endif
endfunction
//===========================================================================
function TriggerAction_AINeutralHeroLevelup takes nothing returns nothing
    local unit u = GetLevelingUnit()
    local string abillist
    local integer i
    local integer len
    local string str

    set abillist = LoadUnitHeroAbilityList(GetUnitTypeId(u))
    set len = StringLength(abillist) 
    set str = SubString(abillist, len - 4, len)
    set abillist = str + "," + abillist
    set i = 0
    loop
        exitwhen GetHeroSkillPoints(u) < 1
        set str = SubString(abillist, i, i + 4)
        call SelectHeroSkill(u, S2C(str))
        set i = i + 5
        exitwhen i > len 
    endloop
endfunction
function TriggerRegister_AINeutralHeroHeroLevelup takes unit u returns nothing
    local trigger trg

    set trg = CreateTrigger()
    call TriggerRegisterUnitEvent(trg, u, EVENT_UNIT_HERO_LEVEL)
    call TriggerAddAction(trg, function TriggerAction_AINeutralHeroLevelup)   
endfunction
//===========================================================================
function PlaceRandomNeutralHero takes nothing returns integer 
    call RandomDistReset()
    call RandomDistAddItem('Nbrn', 100)
    call RandomDistAddItem('Nbst', 100)
    call RandomDistAddItem('Nngs', 100)
    call RandomDistAddItem('Npbm', 100)
    call RandomDistAddItem('Nalc', 100)
    call RandomDistAddItem('Nplh', 100)
    call RandomDistAddItem('Nfir', 100)
    call RandomDistAddItem('Ntin', 100)
    return RandomDistChoose()
endfunction
//===========================================================================
function EnumAIReplenishHero takes nothing returns nothing
    local player p = GetEnumPlayer()
    local integer heroCount = GetPlayerHeroCount(p)
    if (heroCount < bj_MELEE_HERO_LIMIT) then    
        set bj_lastCreatedUnit = CreateUnit(p, PlaceRandomNeutralHero(), GetPlayerStartLocationX(p), GetPlayerStartLocationY(p), 0)
        call SetUnitUseFood(bj_lastCreatedUnit, false)
        call TriggerRegister_AINeutralHeroHeroLevelup(bj_lastCreatedUnit)
        if (heroCount + 1 >= bj_MELEE_HERO_LIMIT) then
            call ForceRemovePlayer(g_neutralHeroAI, p)
        endif
    endif
endfunction
function TriggerAction_AITimerOfLongPeriod takes nothing returns nothing
    call ForForce(g_neutralHeroAI, function EnumAIReplenishHero)
endfunction
//===========================================================================
function InitAI takes nothing returns nothing
    local integer i
    local player  p
    local trigger trg
    local unitpool pool
    local string str
    local string name

    set filterEnumStuctureIsTownhall = Filter(function Filter_IsUnitTypeOfTownhall)
    set filterEnumStuctureIsGoldmine = Filter(function Filter_IsUnitTypeOfGoldmine)
    set g_neutralHeroAI = CreateForce()

    set str = ""
    set i = 0
    loop
        set p = Player(i)
        if ((GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING) and  (GetPlayerController(p) == MAP_CONTROL_COMPUTER)) then
            set name = ChooseRandomName(str)
            call SetPlayerName(p, name)
            set str = name + "#" + str
            call BlzDisplayChatMessage(p, 0, "gl")

            set trg = CreateTrigger()
            call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_DEATH, null)
            call TriggerAddCondition(trg, Condition(function TriggerCondition_DeathIsConstruct))
            call TriggerAddAction(trg, function TriggerAction_AISurrender)

            set trg = CreateTrigger()
            call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_HERO_REVIVE_FINISH, null)
            call TriggerAddAction(trg, function TriggerAction_AIHeroRevive)

            set trg = CreateTrigger()
            call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_TRAIN_FINISH, filterMeleeTrainedUnitIsHeroBJ)
            call TriggerAddAction(trg, function TriggerAction_AIHeroRevive)
            call TriggerAddAction(trg, function TriggerAction_AIHeroTrained)

            set trg = CreateTrigger()
            call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_UPGRADE_FINISH, filterEnumStuctureIsTownhall)
            call TriggerAddAction(trg, function TriggerAction_AIStuctureUpgraded)

            set trg = CreateTrigger()
            call TriggerRegisterTimerEvent(trg, 360.0, true)
            call TriggerAddAction(trg, function TriggerAction_AITimerOfLongPeriod)
        endif
        set i = i + 1
        exitwhen i == bj_MAX_PLAYERS
    endloop
endfunction
//===========================================================================