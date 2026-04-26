
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local tool = Instance.new("Tool")
tool.Name = "Draconic Incandescence of the Vermillion Firmament"
tool.RequiresHandle = false
tool.CanBeDropped = false

tool.Parent = backpack

tool.Activated:Connect(function()
    pcall(function()
        local args = {
            "Uzoth"
        }

        workspace:WaitForChild("LuckymaxerChair")
            :WaitForChild("RemoteFunction")
            :InvokeServer(unpack(args))
    end)
end)