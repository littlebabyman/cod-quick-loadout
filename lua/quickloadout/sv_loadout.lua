local enabled = GetConVar("quickloadout_enable")
local default = GetConVar("quickloadout_default")
local maxslots = GetConVar("quickloadout_maxslots")
local time = GetConVar("quickloadout_switchtime")
local timestop = GetConVar("quickloadout_switchtime_override")

util.AddNetworkString("quickloadout")
if game.SinglePlayer then
    local keybind = KEY_N
    util.AddNetworkString("QLSPHack")
    net.Receive("QLSPHack", function() keybind = net.ReadInt(9) end)
    hook.Add("PlayerButtonDown", "QuickLoadoutBind", function(ply, key)
        if key == keybind and IsFirstTimePredicted() then
            net.Start("QLSPHack")
            net.Send(ply)
        end
    end)
end

local hwep = "weaponholster"
hook.Add("InitPostEntity", "QLHolsterCheck", function()
    if ConVarExists("holsterweapon_weapon") and list.HasEntry("Weapon", GetConVar("holsterweapon_weapon"):GetString()) then
        hwep = GetConVar("holsterweapon_weapon"):GetString() or "weaponholster"
    end
end)

net.Receive("quickloadout", function(len, ply)
    if ply:GetInfoNum("quickloadout_enable_client", 0) == 0 then ply.quickloadout = {}
    else ply.quickloadout = string.Explode(", ", ply:GetInfo("quickloadout_weapons")) end
    for i, v in ipairs(ply.quickloadout) do
        if !list.Get("Weapon")[v] or (list.Get("Weapon")[v].AdminOnly and !ply:IsAdmin()) then timer.Simple(0, function() table.remove(ply.quickloadout, i) end) end
    end
    if (time:GetFloat() > 0 and ply.qlspawntime + time:GetFloat() < CurTime()) then
        net.Start("quickloadout")
        net.Send(ply)
        return
    end
    timer.Simple(0, function()
        QuickLoadout(ply)
    end)
end)

function QuickLoadout(ply)
    if !IsValid(ply) or !enabled:GetBool() or !ply.quickloadout or !ply:Alive() then return end
    ply:StripWeapons()
    if default:GetInt() == 1 or (default:GetInt() == -1 and ply:GetInfoNum("quickloadout_default_client", 1) == 1) or table.IsEmpty(ply.quickloadout) then hook.Run("PlayerLoadout", ply) end
    for k, v in ipairs(ply.quickloadout) do
        if !maxslots:GetBool() or maxslots:GetInt() >= k then
            if k == 1 and weapons.Get(v) and weapons.Get(v).ARC9 then LocalPlayer():PrintMessage("ARC9 SWEP prevented from crashing the game. Please don't set it as your first weapon!") v = "weapon_stunstick" end
            ply:Give(v)
        end
    end
    if ConVarExists("holsterweapon_weapon") then
        ply:Give(hwep)
    end
    -- PrintTable(ply.quickloadout)
end

hook.Add("PlayerInitialSpawn", "QuickLoadoutInitTable", function(ply) ply.quickloadout = {} end)

hook.Add("PlayerSpawn", "QuickLoadoutSpawn", function(ply)
    ply.qlspawntime = CurTime()
    timer.Simple(0, function() QuickLoadout(ply) end)
end)

hook.Add("KeyPress", "QuickLoadoutCancel", function(ply, key)
    if !timestop:GetBool() then return end
    if ply.qlspawntime > 0 and key == IN_ATTACK then
        ply.qlspawntime = 0
    end
end)