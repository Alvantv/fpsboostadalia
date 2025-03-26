-- Roblox FPS Booster + Dark Environment Script
-- By DeepSeek (optimized for performance & atmosphere)
-- Modified with Kemiling Hub loading screen

local decalsyeeted = true -- Remove decals for better FPS
local darkmode = true -- Enable darker environment

-- Create loading screen
local function createLoadingScreen()
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "KemilingHubLoading"
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Background
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    -- Container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.6, 0, 0.2, 0)
    container.Position = UDim2.new(0.2, 0, 0.4, 0)
    container.BackgroundTransparency = 1
    container.Parent = frame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.5, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "KEMILING HUB"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextStrokeTransparency = 0.8
    title.Parent = container

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0.5, 0)
    subtitle.Position = UDim2.new(0, 0, 0.5, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "PREMIUM FPS BOOST"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 18
    subtitle.Parent = container

    -- Progress bar background
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0.1, 0)
    progressBg.Position = UDim2.new(0, 0, 0.9, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = container

    -- Progress bar fill
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg

    -- Percentage text
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(1, 0, 1, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentText.Font = Enum.Font.Gotham
    percentText.TextSize = 14
    percentText.Parent = progressBg

    -- Animate loading
    local duration = 6 -- seconds
    local startTime = tick()
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        percentText.Text = math.floor(progress * 100) .. "%"
        
        if progress >= 1 then
            connection:Disconnect()
            gui:Destroy()
        end
    end)
end

-- Call loading screen first
createLoadingScreen()

-- Wait for loading to complete before applying optimizations
wait(6)

-- Services
local g = game
local w = g.Workspace
local l = g:GetService("Lighting")
local t = w.Terrain

-- ===== FPS OPTIMIZATION =====
sethiddenproperty(l, "Technology", 2) -- Shadow map
sethiddenproperty(t, "Decoration", false)

-- Terrain optimization
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0

-- Lighting optimization
l.GlobalShadows = false
l.FogEnd = 9e9
settings().Rendering.QualityLevel = "Level01"

-- ===== DARK ENVIRONMENT SETTINGS =====
if darkmode then
    l.ClockTime = 15 -- Evening time (18 = 6PM)
    l.Brightness = 0.3 -- Lower = darker
    l.Ambient = Color3.new(0.2, 0.2, 0.2) -- Dark ambient light
    l.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3)
    l.FogColor = Color3.new(0.1, 0.1, 0.1)
    l.FogEnd = 500 -- Shorter view distance
    l.ExposureCompensation = -0.5 -- Makes everything darker
end

-- ===== OBJECT OPTIMIZATION =====
local function optimize(v)
    if v:IsA("BasePart") and not v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        -- Texture remains for hair/clothes
    elseif v:IsA("SpecialMesh") then
        -- Texture remains for hair/clothes
    elseif v:IsA("ShirtGraphic") and decalsyeeted then
        v.Graphic = 0
    elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
        v[v.ClassName.."Template"] = 0
    end
end

-- Optimize existing objects
for _, v in pairs(w:GetDescendants()) do
    optimize(v)
end

-- Optimize new objects
w.DescendantAdded:Connect(function(v)
    task.wait() -- Prevent errors
    optimize(v)
end)

-- Optimize lighting effects
for _, v in pairs(l:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

print("FPS Boost + Dark Mode Activated!")
