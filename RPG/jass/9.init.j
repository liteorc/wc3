//===========================================================================
function InitPlayerStates takes nothing returns nothing
    local player p = GetLocalPlayer()

    call SetPlayerState(p, PLAYER_STATE_FOOD_CAP_CEILING, 30)
    //call SetPlayerMaxHeroesAllowed(bj_MELEE_HERO_LIMIT + 1, p)
endfunction 
//===========================================================================
function BeginInit takes nothing  returns nothing
    call InitDatabase()
    call InitRuneSystem()
    //call InitCreepsSystem()
    //call InitCraftsSystem()    
endfunction
function EndInit takes nothing  returns nothing
   call InitPlayerStates()
endfunction