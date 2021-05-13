//===========================================================================
function BeginInit takes nothing  returns nothing
    call InitDatabase()
    call InitRuneSystem()
    //call InitCreepsSystem()
    //call InitCraftsSystem()    
endfunction
function EndInit takes nothing  returns nothing
    call BJDebugMsg("2021/5/13 18:57")
endfunction