_G.AttackM = true
_G.AttackP = true
_G.Animation = true

local Load = loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/VxezeHubLoader/refs/heads/main/FastAttack.lua"))()

task.spawn(function()
    while task.wait(0.03) do
        Load:Attack()
    end
end)