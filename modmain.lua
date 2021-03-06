--- debug only
-- GLOBAL.CHEATS_ENABLED = true
-- GLOBAL.require( 'debugkeys' )
---

local _G = GLOBAL
local STRINGS = _G.STRINGS 
local CreateEntity = _G.CreateEntity
local TheNet = _G.TheNet
if not (TheNet and TheNet:GetIsServer()) then
    return
end

function _if(cond, a, b)
    if cond then
        return a
    else
        return b
    end
end

local MOD_NAME = "Better revival"

STRINGS.NAMES.BR_SUICIDE = "[" .. MOD_NAME .. ": suicide]"
STRINGS.NAMES.BR_RESURRECT = "[" .. MOD_NAME .. ": resurrect]"
local DONT_DROP = _if(GetModConfigData('MOD_DONT_DROP') == 'on', true, false)

local wtipsduration = GetModConfigData('MOD_WELCOME_TIPS_DURATION')

local wtips = "What you need to know:\n"
if DONT_DROP then
    wtips = wtips .. "You enabled don't drop anything feature!\n"
end
wtips = wtips .. [[send #R to revive and recover
send #RR to revive only
send #RS to reselect charactor
send #GG to commit suicide
ALL COMMANDS ABOVE IS CASE INSENSITIVE]]
do
    --- HOOKS
    --- Player just enter in game
    AddComponentPostInit(
        'playerspawner',
        function(OnPlayerSpawn, inst)
            inst:ListenForEvent(
                'ms_playerjoined',
                function(inst, player)
                    if not player then
                        return
                    end
                    player:DoTaskInTime(
                        3,
                        function(player)
                            if player.components and player.components.talker then
                                player.components.talker:Say(
                                    player:GetDisplayName() .. ', Hello! Welcome to use this mod!\n' .. wtips,
                                    wtipsduration
                                )
                            end
                        end
                    )
                end
            )
        end
    )
    --- inventory hook
    AddComponentPostInit("inventory", function(Inventory, inst)
        local realDropEverything = Inventory.DropEverything
        local function DoDrop(ondeath, keepequip)
            realDropEverything(Inventory, ondeath, keepequip)
        end
        local function CGDoDrop(ondeath)
            local item = Inventory.itemslots[1]
            if item ~= nil then
                print((item.name .." droped."))
                Inventory:DropItem(item, true, true)
            end
        end

        function Inventory:DropEverything(ondeath, keepequip) 
            if ondeath and DONT_DROP then
                print("CG: Don't drop anything enabled!")
                if not inst:HasTag("player") then
                    return DoDrop(ondeath, keepequip)
                else
                    return CGDoDrop(ondeath)
                end
            end
            print("CG: Don't drop anything disabled!")
            return DoDrop(ondeath, keepequip)
        end
    end)
end

do
    local MSG_TABLE = {
        ['#r'] = 1,
        ['#rr'] = 2,
        ['#rs'] = 3,
        ['#gg'] = 4
    }

    local function GetPlayerById(playerid)
        for k, v in ipairs(_G.AllPlayers) do
            if v ~= nil and v.userid and v.userid == playerid then
                return v
            end
        end
        return nil
    end

    local function IsDied(player)
        if player and player:HasTag('player') and player:HasTag('playerghost') then
            return true
        end
    end

    -- Reselect charactor
    local function Despawn(player)
        if player ~= nil and player:IsValid() then
            if _G.TheWorld.ismastersim then
                _G.TheWorld:PushEvent('ms_playerdespawnanddelete', player)
            end
        end
    end

    -- suicide
    local function KillSpawn(player)
        if player ~= nil and player:IsValid() and not IsDied(player) then
            if _G.TheWorld.ismastersim then
                player:PushEvent('death', {cause="br_suicide"})
            end
        end
    end

    -- revive
    local function ResurrectSpawn(player)
        if player ~= nil and player:IsValid() and IsDied(player) then
            if _G.TheWorld.ismastersim then
                local inst = CreateEntity()
                inst.name = STRINGS.NAMES.BR_RESURRECT
                player:PushEvent('respawnfromghost', {source=inst})
            end
        end
    end

    local function RecoverToFullStatus(player)
        player:DoTaskInTime(
            0.5,
            function()
                if player ~= nil and player:IsValid() and player.components and not IsDied(player) then
                    local components = player.components
                    if components.health then
                        components.health:SetPercent(1)
                        components.health:SetPenalty(0)
                    end
                    if components.sanity then
                        components.sanity:SetPercent(1)
                    end
                    if components.hunger then
                        components.hunger:SetPercent(1)
                    end
                end
            end
        )
    end

    local function Say(player, msg)
        player:DoTaskInTime(
            0.5,
            function()
                if player.components.talker then
                    player.components.talker:Say(player:GetDisplayName() .. ', ' .. msg, wtipsduration)
                end
            end
        )
    end

    local function stringstarts(String, Start)
        return string.sub(String, 1, string.len(Start)) == Start
    end

    local function ParsingCMD(message)
        local msg = string.lower(message)
        if MSG_TABLE[msg] ~= nil then
            return MSG_TABLE[msg]
        end
        if msg and stringstarts(msg, '#') then
            return -1
        end
        return 0
    end

    local network_say_d = _G.Networking_Say
    _G.Networking_Say = function(guid, userid, name, prefab, message, ...)
        local result = network_say_d(guid, userid, name, prefab, message, ...)
        local cmd = ParsingCMD(message)
        local player = GetPlayerById(userid)
        if not player then
            return result
        end

        if cmd == 1 then
            ResurrectSpawn(player)
            RecoverToFullStatus(player)
        elseif cmd == 2 then
            ResurrectSpawn(player)
        elseif cmd == 3 then
            Despawn(player)
        elseif cmd == 4 then
            KillSpawn(player)
        elseif cmd == -1 then
            Say(player, 'Command do not exist!\n' .. wtips)
        end
    end
end
