local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Fast Attack By Duy Trường Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Clean Mode",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Main", 4483362458)

_G.FastAttack = false
_G.AttackRange = 60
_G.HitRate = 0.1
_G.Combo = 2

Tab:CreateToggle({
    Name = "Enable Fast Attack",
    CurrentValue = false,
    Callback = function(v)
        _G.FastAttack = v
    end
})

Tab:CreateSlider({
    Name = "Attack Range",
    Range = {20,100},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v)
        _G.AttackRange = v
    end
})

Tab:CreateSlider({
    Name = "Attack Speed",
    Range = {1,20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(v)
        _G.HitRate = 1 / v
    end
})

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer

local Net = require(RS.Modules.Net)
local Combat = require(RS.Modules.CombatUtil)

local hit = Net:RemoteEvent("RegisterHit", true)
local atk = RS.Modules.Net["RE/RegisterAttack"]

local last = 0

task.spawn(function()
    while task.wait() do
        if not _G.FastAttack then continue end

        local char = plr.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        local tool = char:FindFirstChildOfClass("Tool")

        if not (root and tool) then continue end

        if tick() - last < _G.HitRate then continue end
        last = tick()

        local weapon = Combat:GetWeaponName(tool)
        local id = tostring(plr.UserId):sub(2,4)

        local fired = false

        for _, mob in ipairs(workspace.Enemies:GetChildren()) do
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            local hum = mob:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                if (hrp.Position - root.Position).Magnitude <= _G.AttackRange then
                    
                    if not fired then
                        atk:FireServer()
                        fired = true
                    end

                    for i = 1, _G.Combo do
                        hit:FireServer(hrp, {{mob, hrp}}, nil, nil, id)
                    end

                    Combat:ApplyDamageHighlight(mob, char, weapon, hrp)
                end
            end
        end
    end
end)