//===========================================================================
globals
    unit            ACTOR           =   null
    boolean     TRACE_ON     =   true
endglobals
//===========================================================================
function DEBUGMSG takes string text returns nothing
    if TRACE_ON then
        call DisplayTextToPlayer(GetLocalPlayer(), 0, 0, text)
    endif
endfunction
function ForEachItemInMap takes nothing returns nothing
    local item i = GetEnumItem()
    call DEBUGMSG("删除物品："+GetItemName(i)+I2S(GetHandleId(i)))
    call RemoveItem(i)
endfunction
function TiggerAction_Command takes nothing returns nothing
    local string str  = GetEventPlayerChatString()
    local integer id

    set str = SubString(str, 4, StringLength(str))
    call DEBUGMSG("执行命令：" + str)

    if (ACTOR == null) then
        call DEBUGMSG("请选择一个指令目标")
    elseif (StringContains(str, "trace.")) then
        if (str == "trace.on") then
            call DEBUGMSG("调试信息已开启")
            set TRACE_ON = true
        else
            call DEBUGMSG("调试信息已关闭")
            set TRACE_ON = false
        endif
    elseif (str == "item.clear") then
        call EnumItemsInRect(bj_mapInitialPlayableArea, null, function ForEachItemInMap)
    elseif (StringContains(str, "item.")) then
        set id = S2C(SubString(str, 5, 8))
        if (StringLength(GetObjectName(id)) < 1) then
            call DEBUGMSG("无效的物品ID：" + str)
        else
            set str = SubString(str, 9, StringLength(str))
            if (StringLength(str) > 0) then
                set bj_forLoopAIndexEnd = S2I(str)
            else
                set bj_forLoopAIndexEnd = 1
            endif
            set bj_forLoopAIndex = 0
            loop
                call CreateItem(id, GetUnitX(ACTOR), GetUnitY(ACTOR))
                set bj_forLoopAIndex = bj_forLoopAIndex + 1
                exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
            endloop
        endif
    elseif (str == "cls") then
        call ClearTextMessages()
    endif
endfunction
function TriggerAction_SelectUnit takes nothing returns nothing
    set ACTOR = GetTriggerUnit()
    call DEBUGMSG("当前指令目标：" + GetUnitName(ACTOR) + I2S(GetHandleId(ACTOR)))
endfunction

function Debug takes nothing returns nothing
    local string str
    local trigger trg
    local player p = GetLocalPlayer()

    call Cheat("greedisgood 99999")
    call Cheat("warpten")
    
    set trg = CreateTrigger()
    call TriggerRegisterPlayerUnitEvent(trg, p, EVENT_PLAYER_UNIT_SELECTED, null)
    call TriggerAddAction(trg, function TriggerAction_SelectUnit)

    set trg = CreateTrigger()
    call TriggerRegisterPlayerChatEvent(trg, p, "cmd:", false)
    call TriggerAddAction(trg, function TiggerAction_Command)

    set str = "|cffffff00DEBUG模式已开启，输入\"cmd:\"+\"指令代码\"进行调试|r|n|n"
    set str = str + "trace.on/off     启用/禁用调试输出|n"
    set str = str + "cls                    清空聊天信息|n"
    set str = str + "item.xxxx         创建物品|n"
    set str = str + "item.clear        清空物品|n"
    call DEBUGMSG(str)
endfunction