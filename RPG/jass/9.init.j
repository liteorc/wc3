//===========================================================================
function Filter_ConstructIsTower takes nothing returns boolean
    local integer typeid = GetUnitTypeId(GetFilterUnit())
    return (typeid == 'hgtw') or (typeid == 'hatw') or (typeid == 'owtw') or (typeid == 'uzg1') or (typeid == 'uzg2') or (typeid == 'etrp') 
endfunction
function TriggerAction_TowerConstructFinish takes nothing returns nothing
    local unit u = GetTriggerUnit()
    local integer abilcode = 'Aatp'
    call UnitAddAbility(u, abilcode)
    call UnitMakeAbilityPermanent(u, true,  abilcode)
endfunction
//===========================================================================
function InitUser takes nothing returns nothing
    local trigger trg
    local player p = GetLocalPlayer()

    call SetPlayerAbilityAvailable(p, 'Ashm', false)

    call SetPlayerState(p, PLAYER_STATE_FOOD_CAP_CEILING, 30)
    //call SetPlayerMaxHeroesAllowed(bj_MELEE_HERO_LIMIT + 1, p)
 
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, Filter(function Filter_ConstructIsTower))
    call TriggerAddAction(trg, function TriggerAction_TowerConstructFinish)
endfunction 
//===========================================================================
function Filter_IsUnitTypeOfGoldMine takes nothing returns boolean
    if( GetUnitTypeId(GetFilterUnit()) == 'ngol') then
        set bj_groupCountUnits = bj_groupCountUnits + 1
        return true
    endif
    return false
endfunction
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
            set filter = Filter(function Filter_IsUnitTypeOfGoldMine)
            call GroupEnumUnitsInRangeCounted(bj_lastCreatedGroup, GetUnitX(u), GetUnitY(u), 900.0, filter, 1)
            call DestroyFilter(filter)
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
        call MeleeDoDefeat(p)
    endif
endfunction
function TriggerCondition_DeathIsConstruct takes nothing returns boolean
    return IsUnitType(GetDyingUnit(), UNIT_TYPE_STRUCTURE)
endfunction
function InitAI takes nothing returns nothing
    local integer i
    local player  p
    local trigger trg

    set i = 0
    loop
        set p = Player(i)
        if ((GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING) and  (GetPlayerController(p) == MAP_CONTROL_COMPUTER)) then
            set trg = CreateTrigger()
            call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_DEATH, null)
            call TriggerAddCondition(trg, Condition(function TriggerCondition_DeathIsConstruct))
            call TriggerAddAction(trg, function TriggerAction_AISurrender)
        endif
        set i = i + 1
        exitwhen i == bj_MAX_PLAYERS
    endloop
endfunction
//===========================================================================
function BeginInit takes nothing  returns nothing
    call InitDatabase()
    call InitRuneSystem()
    //call InitCreepsSystem()
    //call InitCraftsSystem()    
endfunction
function EndInit takes nothing  returns nothing
   call InitUser()
   call InitAI()
endfunction