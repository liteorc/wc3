//***************************************************************************
//*
//*  Utilities
//*
//***************************************************************************
globals
    constant string ALPHABET    =   "0123456789.......ABCDEFGHIJKLMNOPQRSTUVWXYZ......abcdefghijklmnopqrstuvwxyz"
endglobals
//***************************************************************************
function CHAR takes integer n returns string
    if (n >= '0' and n <= 'z') then
        set n = n - '0'
        return SubString(ALPHABET, n, n + 1)
    endif
    return null
endfunction
function ASCII takes string a returns integer
    local integer i = 0
    local integer len = 'z' - '0'
    loop
        if (SubString(ALPHABET, i, i + 1) == a) then
            return '0' + i
        endif
        set i = i + 1
        exitwhen i > len
    endloop
    return 0
endfunction
function FourCC takes string a, string b, string c, string d returns integer
    return ASCII(a) * 0x1000000 + ASCII(b) * 0x10000 + ASCII(c) * 0x100 + ASCII(d)
endfunction
function S2C takes string str returns integer
    if (StringLength(str) == 4) then
        return FourCC(SubString(str,0,1), SubString(str,1,2), SubString(str,2,3), SubString(str,3,4))
    endif
    return 0
endfunction
function C2S takes integer value returns string
    return CHAR(value/0x1000000) + CHAR(ModuloInteger(value/0x10000,0x100)) + CHAR(ModuloInteger(value/0x100, 0x100)) + CHAR(ModuloInteger(value, 0x100))
endfunction
//===========================================================================
function StringContains takes string str, string substr returns boolean
    local integer i
    local integer len = StringLength(substr)
    local integer maxlen = StringLength(str)

    if (len < 1 or len > maxlen) then
        return false
    endif
    if (str == substr) then
        return true
    endif

    set i = 0
    loop
        if (SubString(str, i, i+len) == substr) then
            return true
        endif
        set i = i + 1
        exitwhen i+len > maxlen
    endloop

    return false
endfunction
//***************************************************************************
