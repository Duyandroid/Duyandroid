-- ╔══════════════════════════════════════╗
-- ║        NIGHT HUB - Logo T v6        ║
-- ║  Cực to + bị cắt nửa ở góc trái     ║
-- ╚══════════════════════════════════════╝

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

-- ======= ĐỔI NHẠC TẠI ĐÂY =======
local MUSIC_ID = "rbxassetid://1843671946"
local BPM      = 128
-- ==================================

if PlayerGui:FindFirstChild("DuyLogo") then
    PlayerGui.NHLogo:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "DuyLogo"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 9999
ScreenGui.Parent         = PlayerGui

-- ===== CLIP FRAME: góc dưới trái, chỉ hiện phần trong màn hình =====
-- Frame này sát góc, ClipsDescendants = true để cắt phần thừa
local Clip = Instance.new("Frame")
Clip.Name                 = "Clip"
Clip.Size                 = UDim2.new(0.38, 0, 0.55, 0)  -- chiếm ~38% ngang, 55% dọc màn hình
Clip.Position             = UDim2.new(0, 0, 0.45, 0)      -- bắt đầu từ 45% chiều cao xuống
Clip.BackgroundTransparency = 1
Clip.ClipsDescendants     = true   -- CẮT PHẦN THỪA RA NGOÀI
Clip.ZIndex               = 7
Clip.Parent               = ScreenGui

local LOGO_SIZE = 500  -- px cực to

-- Vị trí đích trong Clip: nằm lệch trái & dưới để bị cắt ~40%
-- X = -160 → phần trái bị cắt, Y = cuối clip → phần dưới bị cắt
local POS_IN  = UDim2.new(0, -150, 1, -LOGO_SIZE + 80)
-- Vị trí bắt đầu: hoàn toàn ngoài bên trái clip
local POS_OUT = UDim2.new(0, -(LOGO_SIZE + 50), 1, -LOGO_SIZE + 80)

-- ===== SHADOW tím đậm lệch phải + xuống =====
local Shadow = Instance.new("TextLabel")
Shadow.Name                   = "Shadow"
Shadow.Size                   = UDim2.new(0, LOGO_SIZE, 0, LOGO_SIZE)
Shadow.Position               = POS_OUT
Shadow.AnchorPoint            = Vector2.new(0, 0)
Shadow.BackgroundTransparency = 1
Shadow.Text                   = "T"
Shadow.TextColor3             = Color3.fromRGB(80, 60, 200)
Shadow.TextTransparency       = 0.25
Shadow.TextScaled             = true
Shadow.Font                   = Enum.Font.GothamBlack
Shadow.ZIndex                 = 8
Shadow.Parent                 = Clip

-- ===== GLOW layer =====
local Glow = Instance.new("TextLabel")
Glow.Name                   = "Glow"
Glow.Size                   = UDim2.new(0, LOGO_SIZE + 30, 0, LOGO_SIZE + 30)
Glow.Position               = POS_OUT
Glow.AnchorPoint            = Vector2.new(0, 0)
Glow.BackgroundTransparency = 1
Glow.Text                   = "T"
Glow.TextColor3             = Color3.fromRGB(150, 100, 255)
Glow.TextTransparency       = 0.72
Glow.TextScaled             = true
Glow.Font                   = Enum.Font.GothamBlack
Glow.ZIndex                 = 9
Glow.Parent                 = Clip

-- ===== CHỮ T CHÍNH trắng =====
local Logo = Instance.new("TextLabel")
Logo.Name                   = "Logo"
Logo.Size                   = UDim2.new(0, LOGO_SIZE, 0, LOGO_SIZE)
Logo.Position               = POS_OUT
Logo.AnchorPoint            = Vector2.new(0, 0)
Logo.BackgroundTransparency = 1
Logo.Text                   = "T"
Logo.TextColor3             = Color3.fromRGB(255, 255, 255)
Logo.TextTransparency       = 0
Logo.TextScaled             = true
Logo.Font                   = Enum.Font.GothamBlack
Logo.ZIndex                 = 10
Logo.Parent                 = Clip

-- ===== NHẠC =====
local Sound = Instance.new("Sound")
Sound.Name               = "NHMusic"
Sound.SoundId            = MUSIC_ID
Sound.Volume             = 0.6
Sound.Looped             = true
Sound.RollOffMaxDistance = 999999
Sound.Parent             = workspace

local function playMusic()
    if not Sound.IsPlaying then Sound:Play() end
end
if Sound.IsLoaded then playMusic()
else Sound.Loaded:Once(playMusic) end

-- ===== SLIDE VÀO CỰC CHẬM =====
local introDone = false

task.delay(0.2, function()
    local slideIn = TweenService:Create(Logo,
        TweenInfo.new(4.0, Enum.EasingStyle.Linear), {
            Position = POS_IN,
        }
    )
    slideIn:Play()

    TweenService:Create(Shadow, TweenInfo.new(4.0, Enum.EasingStyle.Linear), {
        Position = UDim2.new(POS_IN.X.Scale, POS_IN.X.Offset + 8,
                             POS_IN.Y.Scale, POS_IN.Y.Offset + 10),
    }):Play()

    TweenService:Create(Glow, TweenInfo.new(4.0, Enum.EasingStyle.Linear), {
        Position = UDim2.new(POS_IN.X.Scale, POS_IN.X.Offset - 15,
                             POS_IN.Y.Scale, POS_IN.Y.Offset - 15),
    }):Play()

    slideIn.Completed:Connect(function()
        introDone = true
    end)
end)

-- ===== LOOP XOAY + GLOW PULSE =====
local rotation    = 0
local elapsed     = 0
local beatTimer   = 0
local beatInterval = 60 / BPM
local isBeat      = false

local function doBeat()
    if isBeat or not introDone then return end
    isBeat = true
    TweenService:Create(Glow, TweenInfo.new(0.05), { TextTransparency = 0.1 }):Play()
    task.delay(0.08, function()
        TweenService:Create(Glow, TweenInfo.new(0.3), { TextTransparency = 0.72 }):Play()
        isBeat = false
    end)
end

RunService.RenderStepped:Connect(function(dt)
    elapsed   = elapsed   + dt
    beatTimer = beatTimer + dt

    if not introDone then return end

    -- Xoay chậm 60°/giây
    rotation = (rotation + 60 * dt) % 360
    Logo.Rotation   = rotation
    Shadow.Rotation = rotation
    Glow.Rotation   = rotation

    -- Glow pulse
    Glow.TextTransparency = 0.65 + 0.1 * math.sin(elapsed * 3)

    if beatTimer >= beatInterval then
        beatTimer = beatTimer - beatInterval
        doBeat()
    end
end)

Logo.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        if Sound.IsPlaying then Sound:Pause() else Sound:Resume() end
    end
end)

print("✅ Duy Trường V1 loaded!")