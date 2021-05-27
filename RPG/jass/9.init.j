
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
    call SetPlayerAbilityAvailable(p, 'AIhm', false)

    //call SetPlayerState(p, PLAYER_STATE_FOOD_CAP_CEILING, 30)
    //call SetPlayerMaxHeroesAllowed(bj_MELEE_HERO_LIMIT + 1, p)
 
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_UPGRADE_FINISH, Filter(function Filter_ConstructIsTower))
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH, Filter(function Filter_ConstructIsTower))
    call TriggerAddAction(trg, function TriggerAction_TowerConstructFinish)   
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