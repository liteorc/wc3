------------------------------------------------------------------------------------------------------------------
local ABILITYLIST = "AOcr,AUts,AEev,AHbh,ANdb,ANca,Aabs,Aap1,ACdv,Aegr,Afbk,Assk,Amdf,Awar,Asal,Auco,AIpm,Apig,Aspo,Acn2,Aven,Aeat,ANba,AHfa,ANfa,AEim,Aadm,Aivs,AHbn,Aspl,Aam2,Adcn,Aroa,Asta,Ahwd,Apxf,Arpl,Arpm,Ahea,Ablo,Ainf,Acrs,Afae,Aslo,Apg2,Arej,Aroc,AUfu,AOwk,Alsh,Aply,AUsl,Acmg,ANpa,AHhb,Adis,Acyc,AHdr,AHbz,AUdc,ANhs,Asps,Apsh,AOsw,Advm,AEmb,AOhx,AOws,AHtc,ANdr,ACfb,ACtb,AEer,AEsh,Arai,ANrf,AOsh,ACcv,AUfn,AHtb,ACcb,AOhw,AUim,AOcl,ANms,AEbl,ANbf,ANmo,AUcs,ACbf,Acri,AHfs,ANfl,Aweb,ANso,ANht,ANab,Atau,ANfd,Aens,Ache,ANsi,Amfl,AEfn,AHwe,ANsq,Absk,Afzy,Amls,AOsf,AHds,ANdp"
------------------------------------------------------------------------------------------------------------------
function revise_research_art(path, onoff)
    if onoff then
        return string.gsub(path, "On.blp", ".blp", 1)
    end
    path = string.gsub(path, "\\PassiveButtons\\", "\\CommandButtons\\", 1)
    path = string.gsub(path, "\\PASBTN", "\\BTN", 1)
    return path
end
------------------------------------------------------------------------------------------------------------------
function generate_item(itemid, abilObj)
    local func = load(string.format("return (require 'slk').item.%s:new \'%s\'", 'rman', itemid))
    local obj = func()
    
    obj.Name = "符文 - "..abilObj.Name
    obj.Tip = obj.Name
    obj.Description = string.format("使用后将%s技能添加到英雄的学习技能列表中。",abilObj.Name)
    obj.Art = abilObj.ResearchArt
    obj.uses = 0
    obj.powerup = 0
    obj.drop = 1
    obj.abillist = 'NULL'
    obj.class = 'Campaign'
    if abilObj.levels > 1 then
        obj.Ubertip = abilObj.ResearchUbertip
    else
        obj.Ubertip = abilObj.Ubertip
    end
    --obj.permanent()
end
------------------------------------------------------------------------------------------------------------------
function clone_ability(abilcode)
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", abilcode, string.gsub(abilcode, 'A', 'a', 1)))
    local obj = func()

    obj.UnButtonpos = {0,1}
    obj.Buttonpos = {0,1}
    obj.EditorSuffix = "(clone)"
    obj.hero = 1
    obj.checkDep = 0
    obj.reqLevel = 3
    if (string.match(obj.Art, "Immolation")) then
        obj.ResearchArt = "ReplaceableTextures\\CommandButtons\\BTNImmolationOn.blp"
    else
        obj.ResearchArt = revise_research_art(obj.Art, string.len(obj.Unart) > 0)
    end

    generate_item(string.gsub(abilcode, 'A', 'R', 1), obj)
    return obj
end
------------------------------------------------------------------------------------------------------------------
function batch_generate(codelist, func, param)
    local i = 1
    local len = string.len(codelist)
    repeat
        local abilcode = string.sub(codelist, i, i + 3)
        func(abilcode, param)
        i = i + 5
    until i > len
end
------------------------------------------------------------------------------------------------------------------
function generate_enginskill(unitid, abillist)
    local slk = require 'slk'
    local enginskillid = 'e'..(string.sub(unitid, 2))
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", 'ANeg', enginskillid))
    local obj = func()
    local unitObj = slk.unit[unitid]
    
    obj.EditorSuffix = "(CLEAR)"
    obj.Name = unitObj.Name
    obj.race = unitObj.race
    obj.hero = 0
    obj.levels = 1
    obj.DataA = 0
    obj.DataB = 0
    local i = 1
    local j = 1
    local len = string.len(abillist)
    repeat
        local abilcode = string.sub(abillist, i, i + 3)
        obj['Data'..string.char(string.byte('B') + j)] = "APai,"..abilcode
        i = i + 5
        j = j + 1
    until i > len
    --obj.permanent()
end
------------------------------------------------------------------------------------------------------------------
function generate_simskillbook(bookid, abillist)
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", 'Aspb', bookid))
    local book = func()
    book.DataA = abillist
    book.DataB = 0
    book.DataC = 9
    book.DataD = 9
    book.DataE = "simskill"
    book.item = 0
    book.Buttonpos = {0,-11}
    return book
end
------------------------------------------------------------------------------------------------------------------
function clone_tinker_ability(template, list, callback)
    local slk = require 'slk'
    local abilcode = list[1]
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", template, string.gsub(abilcode, 'A', 'a', 1)))
    local obj = func()

    local src = slk.ability[abilcode]
    obj.Name = src.Name
    obj.EditorSuffix = "(clone)"
    obj.race = src.race
    obj.hero = src.hero
    obj.Art = src.Art
    obj.ResearchArt = revise_research_art(src.Art, false)

    local count = slk.ability['ANeg'].levels
    local level = 0
    for i, code in ipairs(list) do
        src = slk.ability[code]
        for j = 1, src.levels do
            level = level + 1
            obj['Tip'..level] = src['Tip'..j]
            obj['Ubertip'..level] =  src['Ubertip'..j]
            callback(obj, src, level, j)
        end
    end
    obj.levels = level
end
------------------------------------------------------------------------------------------------------------------
function batch_execute()
    local slk = require 'slk'
    
    local db = {	
        { unitid='Hamg', abillist="AHbz,AHab,AHwe,AHmt" },
        { unitid='Hblm', abillist="AHfs,AHbn,AHdr,AHpx" },
        { unitid='Hmkg', abillist="AHtc,AHtb,AHbh,AHav" },
        { unitid='Hpal', abillist="AHhb,AHds,AHad,AHre" },
        { unitid='Obla', abillist="AOwk,AOcr,AOmi,AOww" },
        { unitid='Ofar', abillist="AOfs,AOsf,AOcl,AOeq" },
        { unitid='Oshd', abillist="AOhw,AOhx,AOsw,AOvd" },
        { unitid='Otch', abillist="AOsh,AOae,AOws,AOre" },
        { unitid='Edem', abillist="AEmb,AEim,AEme,AEev" },
        { unitid='Ekee', abillist="AEer,AEfn,AEah,AEtq" },
        { unitid='Emoo', abillist="AHfa,AEst,AEar,AEsf" },
        { unitid='Ewar', abillist="AEbl,AEfk,AEsh,AEsv" },
        { unitid='Ucrl', abillist="AUim,AUts,AUcb,AUls" },
        { unitid='Udea', abillist="AUdc,AUdp,AUau,AUan" },
        { unitid='Udre', abillist="AUav,AUsl,AUcs,AUin" },
        { unitid='Ulic', abillist="AUfn,AUfu,AUdr,AUdd" },
        { unitid='Nbrn', abillist="ANsi,ANba,ANdr,ANch" },
        { unitid='Nbst', abillist="ANsg,ANsq,ANsw,ANst" },
        { unitid='Nngs', abillist="ANfl,ANfa,ANms,ANto" },
        { unitid='Npbm', abillist="ANbf,ANdh,ANdb,ANef" },
        { unitid='Nalc', abillist="ANhs,ANab,ANcr,ANtm" },
        { unitid='Ntin', abillist="ANsy,ANcs,ANeg,ANrg" },
        { unitid='Nplh', abillist="ANrf,ANht,ANca,ANdo" },
        { unitid='Nfir', abillist="ANia,ANso,ANlm,ANvc" }, }
    for i = 1, #db do
        generate_enginskill(db[i].unitid, db[i].abillist)
    end    
    -------------------------------------------------------------------------------------
    batch_generate(ABILITYLIST, clone_ability)
    --TODO: 需要同步更新database.j
    -------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------
function generate_simslot(index)
    local sb = generate_simskillbook('SB'..index..'0', '')
    sb.Name = "学习技能"
    sb.Tip = "学习技能"
    sb.Ubertip = "打开学习技能菜单，以便你分配未使用的英雄技能点。"
    sb.Art = "ReplaceableTextures\\CommandButtons\\BTNSkillz.blp"
    sb.Hotkey = "O"
    sb.Buttonpos = {0,0}
    sb.EditorSuffix = string.format("(hero %d)", index)
    local hotkeys = { 'Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F' }
    local str = ""
    for i = 1, 8 do
        local slotid = 'SL'..index..i
        book = generate_simskillbook('SB'..index..i, str..slotid)
        book.EditorSuffix = sb.EditorSuffix
        str = str.."APai,"

        local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", 'Absk', slotid))
        local obj = func()
        local levels = 3
        obj.Name = "模拟学习"..i
        obj.levels = levels
        obj.checkDep = 0
        obj.DataA = 0
        obj.DataB = 0
        obj.DataC = 0
        obj.Cool = 0
        obj.BuffID = ""
        obj.Art = ""
        obj.Hotkey = hotkeys[i]
        obj.race = book.race
        obj.EditorSuffix = sb.EditorSuffix
        for i = 1, levels do
            obj['Dur'..i] = 0.001
            obj['HeroDur'..i] = 0.001
            obj['Tip'..i] = tostring(i)
            obj['Ubertip'..i] = tostring(i)
        end
        --obj.permanent()
    end
end
function generate_attibutemodskill(levels)
    local slk = require 'slk'
    local aamk = slk.ability['Aamk']:new 'aamk'
    aamk.levels = levels
    aamk.EditorSuffix = "(clone)"

    local book = generate_simskillbook('SB00', 'APai,APai,APai,APai,APai,APai,APai,APai,SL00')
    book.Name = "属性加成"
    book.EditorSuffix = "(public)"

    local slot = slk.ability['Absk']:new 'SL00'
    slot.Name = "属性加成"
    slot.EditorSuffix = "(public)"
    slot.checkDep = 0
    slot.DataA = 0
    slot.DataB = 0
    slot.DataC = 0
    slot.Cool = 0
    slot.BuffID = ''
    slot.Hotkey = 'Z'
    slot.Art = aamk.ResearchArt
    slot.race = book.race
    slot.levels = levels

    for i = 1, levels do
        aamk['DataA'..i] = i * 3
        aamk['DataB'..i] = i * 3
        aamk['DataC'..i] = i * 3
        aamk['DataD'..i] = 1
        slot['Dur'..i] = 0.001
        slot['HeroDur'..i] = 0.001
        str = string.format("敏捷、智力、力量各增加<aamk,DataA%d>点属性点",i)
        slot['Ubertip'..i]  = str
        aamk['Ubertip'..i]  = str
        str = string.format("属性加成 - [|cffffcc00%d级|r]",i)
        slot['Tip'..i] = "学习"..str
        aamk['Tip'..i] = str
    end
end
------------------------------------------------------------------------------------------------------------------
function prev_proc()
    local slk = require 'slk'
    local heroCount = 3
    for i = 1,heroCount do
        generate_simslot(i)
    end    
    generate_attibutemodskill(15)

    -------------------------------------------------------------------------------------
    local obj = slk.item['rman'] : new 'rful'
    obj.abillist = 'Asb1'
    obj.Name = "技能栏已满。"

    obj = slk.ability['ANcl'] : new 'arpt'
    obj.Name = "(桥梁目标)"
    obj.DataB = 1
    obj.Art = ''
    obj.hero = 0
    obj.item = 1
    obj.levels = 1
    obj.race = 'other'
    obj.targs = 'bridge'
    obj =  slk.item['rman'] : new 'rrpt'
    obj.abillist = 'arpt'
    obj.Name = "技能已存在。"
    -------------------------------------------------------------------------------------
    obj = slk.ability['AIam'] : new 'NULL'
    obj.Name = "(无效果)"
    obj.TargetArt = ''
    obj.DataA1 = 0
    obj.Art = ''

    obj =  slk.ability['AIam'] : new 'arfx'
    obj.Name = "获得符文技能"
    obj.EditorSuffix = "(特效)"
    obj.DataA1 = 0
    obj.Art = ''
    obj.TargetArt = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl"

    obj =  slk.item['rman'] : new 'rrfx'
    obj.Name = "获得符文技能"
    obj.abillist = 'arfx'
end
----------------------------------------------------------------------------------------
function exec_proc()
    local slk = require 'slk'

    batch_execute()
    -------------------------------------------------------------------------------------
    --Engineering Upgrade
    clone_tinker_ability('Amgr', {'ANeg'}, 
    function(o, s, v, x) 
    end)
    --Pocket Factory
    clone_tinker_ability('ANsy', {'ANsy', 'ANs1', 'ANs2', 'ANs3'}, 
    function(o, s, v, x)
        o['DataA'..v] = s['DataA'..x]
    end)
    --Cluster Rockets
    clone_tinker_ability('ANcs', {'ANcs', 'ANc1', 'ANc2', 'ANc3'}, 
    function(o, s, v, x)
        o['Area'..v] = s['Area'..x]
    end)
    --Robo-Goblin
    clone_tinker_ability('ANrg', {'ANrg', 'ANg1', 'ANg2', 'ANg3'}, 
    function(o, s, v, x)
        o['DataE'..v] = s['DataE'..x]
        o['DataF'..v] = s['DataF'..x]
    end)
    --Demolish
    clone_tinker_ability('ANde', {'ANde', 'ANd1', 'ANd2', 'ANd3'}, 
    function(o, s, v, x)
        o['DataB'..v] = s['DataB'..x]
    end)
    -------------------------------------------------------------------------------------
    local tech = slk.upgrade['Rews']
    local obj = slk.ability['Amgr']:new 'aews'
    obj.Name = tech.Name
    obj.race = tech.race
    obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNWellSpring.blp"
    obj.ResearchArt = tech.Art
    obj.Buttonpos = {1,1}
    obj.EditorSuffix = "(clone)"
    obj.hero = 1
    obj.checkDep = 0
    obj.Tip = tech.Name
    obj.Ubertip = tech.Ubertip
    obj.UnButtonpos = {1,1}
    obj.reqLevel = 3

    generate_item('Rews', obj)

    obj = slk.ability['AImz']:new 'awsM'
    obj.Name = tech.Name
    obj.race = tech.race
    obj.EditorSuffix = "(法力值加成)"
    obj.DataA1 = tech.base1
    obj = slk.ability['AIrm']:new 'awsR'
    obj.Name = tech.Name
    obj.race = tech.race
    obj.EditorSuffix = "(法力恢复速度加快)"
    obj.DataA1 = tech.base2

    obj = slk.ability['AIar']:new 'Atwr'
    obj.Name = "哨塔结界-攻击力加成"
    obj.DataA = 1
    obj.targs = "friend,structure"
    obj.race = "other"
    obj.TargetArt = "Abilities\\Spells\\Orc\\WarDrums\\DrumsCasterHeal.mdl"

    obj = slk.ability['AIae']:new 'Atwe'
    obj.Name = "哨塔结界-攻速加成"
    obj.DataA = 0
    obj.DataB = 1
    obj.targs = "friend,structure"
    obj.race = "other"
    obj.Area = 600
    obj.TargetArt = ''

    obj = slk.unit['ohwd']:new 'ntow'
    obj.Name = "哨塔结界"
    obj.Art = "ReplaceableTextures\\CommandButtons\\BTNOrcBattleStandard.blp"
    obj.unitSound = "SentryWard"
    obj.file = "Objects\\InventoryItems\\BattleStandard\\BattleStandard.mdl"
    obj.abilList  = "Aeth,Avul,Atwr,Atwe"
    obj.race = "other"

    obj = slk.ability['Ahwd']:new 'Atwd'
    obj.Name = "哨塔结界"
    obj.UnitID = 'ntow'
    obj.UnitSkinID = 'ntow'
    obj.EditorSuffix = ""
    obj.Tip = "哨塔结界"
    obj.Ubertip = "提高范围内所有防御塔<Atwr,DataA1,%>%的攻击速度和<Atwe,DataB1,%>%的攻击力。|n持续<Atwd,Dur1>秒。"
    obj.Art = "ReplaceableTextures\\CommandButtons\\BTNOrcBattleStandard.blp"
    obj.Cost = 0
    obj.Cool = 135
    obj.Dur = 45
    obj.HeroDur = 45
    obj.BuffID = 'BOac'
    obj.race = "other"
    obj.checkDep = 0
    obj.EditorSuffix = "(defend)"
end
----------------------------------------------------------------------------------------
function post_proc()
    local slk = require 'slk'

    local obj = slk.ability['aeat']
    obj.Cool = 30.0
    obj.Specialattach = 'hand'
end
----------------------------------------------------------------------------------------

prev_proc()
exec_proc()
post_proc()
