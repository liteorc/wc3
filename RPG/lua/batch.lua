------------------------------------------------------------------------------------------------------------------
local ABILITYLIST = "AOcr,AUts,AEev,AHbh,ANdb,ANca,Aabs,Aap1,Adef,Adtn,ACdv,Aegr,Afbk,Assk,Amdf,Awar,Asal,AIpm,Aobs,Aotr,Augf,Aemk,Aews,Apig,Ahr3,Aliq,Afrz,Afra,Aspo,Aexh,Acn2,Aven,Aeat,ANmr,ANba,AHfa,ANfa,AEim,Aadm,Aivs,Aeye,AHbn,Aspl,Aam2,Adcn,Aroa,Asta,Ahwd,Aps2,Apxf,Arpl,Arpm,Ahea,Ablo,Ainf,Acrs,Afae,Aslo,Apg2,Arej,Aroc,AUfu,AOwk,Alsh,Aply,AUsl,Acmg,ACpa,AHhb,Adis,Acyc,AHdr,AHbz,AUdc,ANhs,Asps,Apsh,AOsw,Advm,AEmb,AOhx,AOws,AHtc,ANdr,ACfb,ACtb,AEer,AEsh,Arai,ANrf,AOsh,ACcv,AUfn,AHtb,ACcb,AOhw,AUim,AOcl,ANms,AEbl,ANbf,ANmo,AUcs,Abof,ACbf,Acri,AHfs,ANfl,Aweb,ANso,ANht,ANab,Atau,ANfd,Aens,Ache,ANsi,Amfl,ANwm,AEfn,AHwe,ANsq,Absk,Afzy,Amls,AOsf,ACwe,Aast,AHds,Aesr,ANdp,Afla"
------------------------------------------------------------------------------------------------------------------
local BUTTONPOS = {0,1}
local REQLEVEL = 3
--ANcl.DataB
local CHANNELTYPE_INSTANT = 0
local CHANNELTYPE_UNIT = 1
local CHANNELTYPE_POINT = 2
local CHANNELTYPE_UNITPOINT = 3
--ANcl.DataC
local CHANNELFLAGS_VISIBLE = 1
local CHANNELFLAGS_TARGIMAGE = 2
local CHANNELFLAGS_PHYSICAL = 4
local CHANNELFLAGS_UNIVERSAL = 8
local CHANNELFLAGS_UNIQUE = 16
------------------------------------------------------------------------------------------------------------------
local slk = require 'slk'
------------------------------------------------------------------------------------------------------------------
function coerce_research_art(path, onoff)
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
    
    obj.Name = "?????? - "..abilObj.Name
    obj.Tip = obj.Name
    obj.Description = string.format("????????????%s????????????????????????????????????????????????",abilObj.Name)
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
function postproc_ability(obj, abilcode)
    if (string.match(obj.Art, "Immolation")) then
        obj.ResearchArt = slk.ability['AEim'].Art
        return
    end
    if (abilcode == 'aEbl') then
        obj.Art = slk.ability['ANbl'].Art
        obj.ResearchArt = obj.Art
        return
    end
    if (abilcode == 'aOws') then
        obj.Art = slk.ability['Awrg'].Art
        obj.ResearchArt = obj.Art
        return
    end
    if (abilcode == 'aHtb') then
        obj.Art = slk.ability['Asth'].Art
        obj.ResearchArt = obj.Art
        return
    end
    if (abilcode == 'aHtc') then
        obj.Art = slk.ability['ACtc'].Art
        obj.ResearchArt = obj.Art
        return
    end
    if (abilcode == 'aNbf') then
        obj.Art = slk.ability['ACbc'].Art
        obj.ResearchArt = obj.Art
        return
    end
    if (abilcode == 'aNmr') then
        obj.Art ="ReplaceableTextures\\CommandButtons\\btnlament.blp"
        obj.ResearchArt = obj.Art
        obj.Cost = 25
        obj.Cool = 6
        return
    end
    if (abilcode == 'aIpm') then
        obj.Name = "????????????"
        obj.Tip = "????????????"
        obj.Ubertip = "??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????|n??????????????????<Amnx,DataA1>???|n??????????????????<Amnx,DataB1>???|n?????????????????????<Amnx,DataC1>???|n?????????????????????<Amnx,DataD1>???|n|n|cffffcc00???????????????5????????????|r"
        obj.Effectsound = 'GoblinLandMineDeath'
        obj.Hotkey = 'M'
        obj.item = 0
        obj.ResearchArt = obj.Art
        obj.reqLevel = REQLEVEL
        obj.Cost = 100
        obj.Cool = 25
        return
    end
    if(abilcode == 'aNwm') then
        obj.Tip1 = string.format("%s  - [|cffffcc001???|r]", obj.Name)
        obj.Tip2 = string.format("%s  - [|cffffcc002???|r]", obj.Name)
        obj.Tip3 = string.format("%s  - [|cffffcc003???|r]", obj.Name)
        obj.UberTip1 = "??????<ANwm,DataA1>??????????????????????????????????????????????????????<ncfs,realHP>???????????????<ncfs,mindmg1>-<ncfs,maxdmg1>???????????????|n??????<ANwm,Dur1>??????|n|n|cffffcc00????????????????????????|r"
        obj.UberTip2 = "??????<ANwm,DataA2>??????????????????????????????????????????????????????<ntws,realHP>???????????????<ntws,mindmg1>-<ntws,maxdmg1>???????????????|n??????<ANwm,Dur2>??????|n|n|cffffcc00????????????????????????|r"
        obj.UberTip3 = "??????<ANwm,DataA3>??????????????????????????????????????????????????????<nsns,realHP>???????????????<nsns,mindmg1>-<nsns,maxdmg1>?????????????????????????????????????????????????????????|n??????<ANwm,Dur3>??????|n|n|cffffcc00?????????????????????????????????|r"
        obj.Researchubertip = "??????<ANwm,DataA1>????????????????????????????????????|n??????<ANwm,Dur1>??????|n|n|cffffcc001???|r - <ncfs,realHP>???????????????<ncfs,mindmg1>-<ncfs,maxdmg1>???????????????|n|cffffcc002???|r - <ntws,realHP>???????????????<ntws,mindmg1>-<ntws,maxdmg1>???????????????|n|cffffcc003???|r - <nsns,realHP>???????????????<nsns,mindmg1>-<nsns,maxdmg1>?????????????????????????????????????????????????????????"
    end
    ---------YDWE UPGRADE--------
    if (abilcode == 'apxf') then
        obj.Ubertip = "??????????????????????????????????????????????????????<Apxf,DataA1>??????????????????????????????<Apxf,DataB1>???????????????????????????<Apxf,Dur1>??????"
    elseif (abilcode == 'augf') then
        obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNGhoulFrenzy.blp"
    elseif (abilcode == 'aobs') then
        obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNBerserk.blp"
    elseif (abilcode == 'aotr') then
        obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNRegenerate.blp"
    elseif (abilcode == 'aemk') then
        obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNMarksmanship.blp"
    elseif (abilcode == 'aews') then
        obj.Art = "ReplaceableTextures\\PassiveButtons\\PASBTNWellSpring.blp"
    end
    ------------------------------------
    --default
    obj.ResearchArt = coerce_research_art(obj.Art, string.len(obj.Unart) > 0)
end
function clone_ability(abilcode)
    local id = string.gsub(abilcode, 'A', 'a', 1)
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", abilcode, id))
    local obj = func()

    obj.Buttonpos = BUTTONPOS
    obj.UnButtonpos = BUTTONPOS
    obj.EditorSuffix = "(clone)"
    obj.hero = 1
    obj.checkDep = 0
    obj.reqLevel = REQLEVEL
    postproc_ability(obj, id)

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
    local abilcode = list[1]
    local func = load(string.format("return (require 'slk').ability.%s:new \'%s\'", template, string.gsub(abilcode, 'A', 'a', 1)))
    local obj = func()

    local src = slk.ability[abilcode]
    obj.Name = src.Name
    obj.EditorSuffix = "(clone)"
    obj.race = src.race
    obj.hero = src.hero
    obj.Art = src.Art
    obj.ResearchArt = coerce_research_art(src.Art, false)

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
    --TODO: ??????????????????database.j
    -------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------
function generate_simslot(index)
    local sb = generate_simskillbook('SB'..index..'0', '')
    sb.Name = "????????????"
    sb.Tip = "????????????"
    sb.Ubertip = "????????????????????????????????????????????????????????????????????????"
    sb.Art = "ReplaceableTextures\\CommandButtons\\BTNSkillz.blp"
    sb.Unart = sb.Art 
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
        obj.Name = "????????????"..i
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
    local aamk = slk.ability['Aamk']:new 'aamk'
    aamk.levels = levels
    aamk.EditorSuffix = "(clone)"

    local book = generate_simskillbook('SB00', 'APai,APai,APai,APai,APai,APai,APai,APai,SL00')
    book.Name = "????????????"
    book.EditorSuffix = "(public)"

    local slot = slk.ability['Absk']:new 'SL00'
    slot.Name = "????????????"
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
        str = string.format("?????????????????????????????????<aamk,DataA%d>????????????",i)
        slot['Ubertip'..i]  = str
        aamk['Ubertip'..i]  = str
        str = string.format("???????????? - [|cffffcc00%d???|r]",i)
        slot['Tip'..i] = "??????"..str
        aamk['Tip'..i] = str
    end
end
------------------------------------------------------------------------------------------------------------------
function prev_proc()
    local heroCount = 3
    for i = 1,heroCount do
        generate_simslot(i)
    end    
    generate_attibutemodskill(15)

    -------------------------------------------------------------------------------------
    local obj = slk.item['rman'] : new 'rful'
    obj.abillist = 'Asb1'
    obj.Name = "??????????????????"

    obj = slk.ability['ANcl'] : new 'arpt'
    obj.Name = "(????????????)"
    obj.DataB = CHANNELTYPE_UNIT
    obj.Art = ''
    obj.hero = 0
    obj.item = 1
    obj.levels = 1
    obj.race = 'other'
    obj.targs = 'bridge'
    obj =  slk.item['rman'] : new 'rrpt'
    obj.abillist = 'arpt'
    obj.Name = "??????????????????"
    -------------------------------------------------------------------------------------
    obj = slk.ability['AIam'] : new 'NULL'
    obj.Name = "(?????????)"
    obj.DataA1 = 0
    obj.Art = ''
    obj.TargetArt = ''

    obj =  slk.ability['AIam'] : new 'arfx'
    obj.Name = "??????????????????"
    obj.EditorSuffix = "(??????)"
    obj.DataA1 = 0
    obj.Art = ''
    obj.TargetArt = ''
    obj.CasterArt = "Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl"

    obj =  slk.item['rman'] : new 'rrfx'
    obj.Name = "??????????????????"
    obj.abillist = 'arfx'
end
----------------------------------------------------------------------------------------
--[[
function tower_defend()
    obj = slk.ability['AIar']:new 'Atwr'
    obj.Name = "????????????-???????????????"
    obj.DataA = 1
    obj.targs = "friend,structure"
    obj.race = "other"
    obj.TargetArt = slk.ability['AIwd'].Targetart

    obj = slk.ability['AIae']:new 'Atwe'
    obj.Name = "????????????-????????????"
    obj.DataA = 0
    obj.DataB = 1
    obj.targs = "friend,structure"
    obj.race = "other"
    obj.Area = 600
    obj.TargetArt = ''

    obj = slk.unit['ohwd']:new 'ntow'
    obj.Name = "????????????"
    obj.Art = slk.ability['AIfx'].Art--orcish battle standard
    obj.unitSound = "SentryWard"
    obj.file = slk.ability['AIfx'].Targetart
    obj.abilList  = "Aeth,Avul,Atwr,Atwe"
    obj.race = "other"

    obj = slk.ability['Ahwd']:new 'Atwd'
    obj.Name = "????????????"
    obj.UnitID = 'ntow'
    obj.UnitSkinID = 'ntow'
    obj.EditorSuffix = ""
    obj.Tip = "????????????"
    obj.Ubertip = "??????????????????????????????<Atwr,DataA1,%>%??????????????????<Atwe,DataB1,%>%???????????????|n??????<Atwd,Dur1>??????"
    obj.Art = slk.ability['AIfx'].Art--orcish battle standard
    obj.Cost = 0
    obj.Cool = 135
    obj.Dur = 45
    obj.HeroDur = 45
    obj.BuffID = 'BOac'
    obj.race = "other"
    obj.checkDep = 0
    obj.EditorSuffix = "(defend)"
end
--]]
----------------------------------------------------------------------------------------
function exec_proc()
    batch_execute()
    -------------------------------------------------------------------------------------
    --Engineering Upgrade
    clone_tinker_ability('APai', {'ANeg'}, 
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
    --Ethereal
    local Aetf = slk.ability['Aetf']
    obj = slk.ability['ANcl']:new 'aetf'
    obj.Effectsound = Aetf.Effectsound
    obj.DataE = 0
    obj.DataD = 0.7
    obj.DataF = 'etherealform'
    obj.Order = 'etherealform'
    obj.DataA= 0.7
    obj.DataB= CHANNELTYPE_INSTANT
    obj.DataC= CHANNELFLAGS_VISIBLE + CHANNELFLAGS_UNIVERSAL
    obj.Name = Aetf.Name
    obj.Tip = Aetf.Name
    obj.UberTip = Aetf.UberTip
    obj.Hotkey = Aetf.Hotkey
    obj.Rng = 0
    obj.race = Aetf.race
    obj.levels = 1
    obj.reqLevel = REQLEVEL
    obj.Art = Aetf.Art
    obj.ResearchArt = Aetf.Art
    obj.ButtonPos = BUTTONPOS
    obj.Animnames = 'channel'
    obj.CasterArt = Aetf.CasterArt
    obj.Casterattach = 'chest'
    obj.TargetArt = ''
    obj.EffectArt = ''
    obj.Targetattach = ''
    obj.EditorSuffix = "(channel)"
    generate_item('Retf', obj)

    local Acpf = slk.ability['Acpf']
    obj = slk.ability['ANcl']:new 'acpf'
    obj.Effectsound = Acpf.Effectsound
    obj.DataE = 0
    obj.DataD = 0.7
    obj.DataF = 'corporealform'
    obj.Order = 'corporealform'
    obj.DataA= 0.7
    obj.DataB= CHANNELTYPE_INSTANT
    obj.DataC= CHANNELFLAGS_VISIBLE + CHANNELFLAGS_UNIVERSAL
    obj.Name = Acpf.Name
    obj.Tip = Acpf.Name
    obj.UberTip = Acpf.UberTip
    obj.Hotkey = Acpf.Hotkey
    obj.Rng = 0
    obj.race = Acpf.race
    obj.levels = 1
    obj.reqLevel = REQLEVEL
    obj.Art = Acpf.Art
    obj.ResearchArt = Acpf.Art
    obj.ButtonPos = BUTTONPOS
    obj.Animnames = 'channel'
    obj.CasterArt = Acpf.CasterArt
    obj.Casterattach = 'chest'
    obj.TargetArt = ''
    obj.EffectArt = ''
    obj.Targetattach = ''
    obj.EditorSuffix = "(channel)"
    -------------------------------------------------------------------------------------
    --Well Spring
    local tech = slk.upgrade['Rews']
    obj = slk.ability['AImz']:new 'awsM'
    obj.Name = tech.Name
    obj.race = tech.race
    obj.EditorSuffix = "(???????????????)"
    obj.DataA1 = tech.base1
    obj = slk.ability['AIrm']:new 'awsR'
    obj.Name = tech.Name
    obj.race = tech.race
    obj.EditorSuffix = "(????????????????????????)"
    obj.DataA1 = tech.base2
    -------------------------------------------------------------------------------------
    --GoblinSapper
    obj = slk.ability['ANcl']:new 'agsp'
    obj.Name = "????????????"
    obj.Tip = obj.Name
    obj.Ubertip = "??????????????????????????????????????????????????????????????????|n|cffffcc00????????????????????????????????????????????????????????????<Asds,DataB1>????????????"
    obj.Art = slk.unit['ngsp'].Art
    obj.ResearchArt = obj.Art
    obj.ButtonPos = BUTTONPOS
    obj.levels = 1
    obj.reqLevel = REQLEVEL
    obj.Hotkey = 'P'
    obj.CasterArt = ''
    obj.TargetArt = ''
    obj.EffectArt = slk.ability['ANsg'].TargetArt
    obj.Animnames = 'spell,slam'
    obj.Cost = 100
    obj.Cool = 30
    obj.Dur = 30
    obj.HeroDur = 30
    obj.DataA= 0.01
    obj.DataB= CHANNELTYPE_POINT
    obj.DataC= CHANNELFLAGS_VISIBLE + CHANNELFLAGS_UNIVERSAL
    obj.DataD = 0.5
    obj.DataE = 0
    obj.DataF = 'snapper'
    obj.Order = 'snapper'
    obj.EditorSuffix = "(channel)"
    generate_item('Rgsp', obj)
    -------------------------------------------------------------------------------------
    --Unstable Concoction
    local Auco =  slk.ability['Auco']
    obj = slk.ability['ANcl']:new 'auco'
    obj.Name = Auco.Name
    obj.Tip = Auco.Name
    obj.Ubertip = Auco.Ubertip
    obj.Art = Auco.Art
    obj.ResearchArt = Auco.Art
    obj.ButtonPos = BUTTONPOS
    obj.levels = Auco.levels
    obj.reqLevel = REQLEVEL
    obj.Hotkey = Auco.Hotkey
    obj.targs = Auco.targs
    obj.race = Auco.race
    obj.rng = Auco.rng
    obj.CasterArt = slk.ability['Apsh'].SpecialArt
    obj.TargetArt = ''
    obj.EffectArt = ''
    obj.Animnames = 'alternate,attack'
    obj.Cost = Auco.Cost
    obj.Cool = Auco.Cool
    obj.DataA= 0.01
    obj.DataB= CHANNELTYPE_UNIT
    obj.DataC= CHANNELFLAGS_VISIBLE + CHANNELFLAGS_PHYSICAL
    obj.DataD = 0.01
    obj.DataE = 0
    obj.DataF = Auco.Order
    obj.Order = Auco.Order
    obj.EditorSuffix = "(channel)"
    generate_item('Ruco', obj)
    -------------------------------------------------------------------------------------
    --Phoenix Fire
    obj = slk.ability['Ahpe'] : new 'apxi'
    obj.ButtonPos = BUTTONPOS
    obj.Tip =  slk.ability['apxf'].Tip
    obj.Ubertip =  slk.ability['apxf'].Ubertip
    -------------------------------------------------------------------------------------
    --tower_defend()--Tower
end
----------------------------------------------------------------------------------------
function post_proc()
    -----------------------------------------------------
    obj = slk.ability['aeat']
    obj.Cool = 30.0
    -----------------------------------------------------
    obj = slk.ability['ahr3']
    obj.reqlevel = 0
    -----------------------------------------------------
    buf = slk.buff['BUts']:new 'bUts'
    buf.TargetArt = "Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestMountRight.mdl,Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestMountLeft.mdl,Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestLeft.mdl,Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestRight.mdl,Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestLeft.mdl,Abilities\\Spells\\Undead\\ThornyShield\\ThornyShieldTargetChestRight.mdl"
    buf.Targetattachcount = 6
    buf.Targetattach = 'chest'
    buf.Targetattach1 = 'chest'
    buf.Targetattach2 = 'foot,left'
    buf.Targetattach3 = 'foot,right'
    buf.Targetattach4 = 'hand,left'
    buf.Targetattach5 = 'hand,right'
    obj = slk.ability['aUts']
    obj.BuffID1 = 'bUts'
    obj.BuffID2 = 'bUts'
    obj.BuffID3 = 'bUts'
    -----------------------------------------------------
    buf = slk.buff['Bbsk']:new 'bbsk'
    buf.TargetArt = "Abilities\\Spells\\Orc\\TrollBerserk\\HeadhunterWEAPONSLeft.mdl,Abilities\\Spells\\Orc\\TrollBerserk\\HeadhunterWEAPONSRight.mdl,Abilities\\Spells\\Orc\\TrollBerserk\\HeadhunterWEAPONSLeft.mdl,Abilities\\Spells\\Orc\\TrollBerserk\\HeadhunterWEAPONSRight.mdl"
    buf.Targetattachcount = 4
    buf.Targetattach = 'foot,left'
    buf.Targetattach1 = 'foot,right'
    buf.Targetattach2 = 'hand,left'
    buf.Targetattach3 = 'hand,right'
    obj = slk.ability['absk']
    obj.BuffID = 'bbsk'
end
----------------------------------------------------------------------------------------

prev_proc()
exec_proc()
post_proc()
