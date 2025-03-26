-- MADE BY RIP#6666
-- MODIFIED TO PRESERVE TREE TEXTURES
-- send issues or suggestions to my discord: discord.gg/rips

if not _G.Ignore then
    _G.Ignore = {
        workspace.Terrain,
        workspace:FindFirstChild("Trees"),
        workspace:FindFirstChild("Forest")
        -- Add other tree containers here
    }
end

if not _G.WaitPerAmount then
    _G.WaitPerAmount = 500
end
if _G.SendNotifications == nil then
    _G.SendNotifications = false
end
if _G.ConsoleLogs == nil then
    _G.ConsoleLogs = false
end

if not game:IsLoaded() then
    repeat
        task.wait()
    until game:IsLoaded()
end

if not _G.Settings then
    _G.Settings = {
        Players = {
            ["Ignore Me"] = true,
            ["Ignore Others"] = true,
            ["Ignore Tools"] = true
        },
        Meshes = {
            NoMesh = false,      -- Keep this false for trees
            NoTexture = false,   -- Keep this false for trees
            Destroy = false
        },
        Images = {
            Invisible = true,
            Destroy = false
        },
        Explosions = {
            Smaller = true,
            Invisible = false,
            Destroy = false
        },
        Particles = {
            Invisible = true,
            Destroy = false
        },
        TextLabels = {
            LowerQuality = false,
            Invisible = false,
            Destroy = false
        },
        MeshParts = {
            LowerQuality = true,
            Invisible = false,
            NoTexture = false,   -- Keep this false for trees
            NoMesh = false,      -- Keep this false for trees
            Destroy = false
        },
        Other = {
            ["FPS Cap"] = 240,
            ["No Camera Effects"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true,
            ["Low Quality Models"] = true,
            ["Reset Materials"] = true,
            ["Lower Quality MeshParts"] = true
        }
    }
end

local Players, Lighting, StarterGui, MaterialService = game:GetService("Players"), game:GetService("Lighting"), game:GetService("StarterGui"), game:GetService("MaterialService")
local ME, CanBeEnabled = Players.LocalPlayer, {"ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles"}

local function IsTree(Instance)
    return Instance:IsA("MeshPart") and (Instance.Name:lower():find("tree") or Instance.Name:lower():find("leaf") or Instance.Name:lower():find("trunk"))
        or Instance:IsA("Part") and (Instance.Name:lower():find("tree") or Instance.Name:lower():find("leaf") or Instance.Name:lower():find("trunk"))
        or Instance:IsA("Model") and (Instance.Name:lower():find("tree") or Instance.Name:lower():find("forest"))
end

local function PartOfCharacter(Instance)
    for i, v in pairs(Players:GetPlayers()) do
        if v ~= ME and v.Character and Instance:IsDescendantOf(v.Character) then
            return true
        end
    end
    return false
end

local function DescendantOfIgnore(Instance)
    for i, v in pairs(_G.Ignore) do
        if Instance:IsDescendantOf(v) then
            return true
        end
    end
    return false
end

local function CheckIfBad(Instance)
    -- Skip processing for trees and their parts
    if IsTree(Instance) then
        return
    end

    if not Instance:IsDescendantOf(Players) and 
       (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Instance) or not _G.Settings.Players["Ignore Others"]) and 
       (_G.Settings.Players["Ignore Me"] and ME.Character and not Instance:IsDescendantOf(ME.Character) or not _G.Settings.Players["Ignore Me"]) and 
       (_G.Settings.Players["Ignore Tools"] and not Instance:IsA("BackpackItem") and not Instance:FindFirstAncestorWhichIsA("BackpackItem") or not _G.Settings.Players["Ignore Tools"]) and
       (_G.Ignore and not table.find(_G.Ignore, Instance) and not DescendantOfIgnore(Instance) or (not _G.Ignore or type(_G.Ignore) ~= "table" or #_G.Ignore <= 0)) then
        
        if Instance:IsA("DataModelMesh") then
            if _G.Settings.Meshes.NoMesh and Instance:IsA("SpecialMesh") then
                Instance.MeshId = ""
            end
            if _G.Settings.Meshes.NoTexture and Instance:IsA("SpecialMesh") then
                Instance.TextureId = ""
            end
            if _G.Settings.Meshes.Destroy then
                Instance:Destroy()
            end
        elseif Instance:IsA("FaceInstance") then
            if _G.Settings.Images.Invisible then
                Instance.Transparency = 1
                Instance.Shiny = 1
            end
            if _G.Settings.Images.Destroy then
                Instance:Destroy()
            end
        -- [Rest of the original CheckIfBad function remains the same...]
        end
    end
end

-- [Rest of the original script remains the same...]

-- Initialize the script
coroutine.wrap(pcall)(function()
    -- Water graphics settings
    if (_G.Settings["Low Water Graphics"] or (_G.Settings.Other and _G.Settings.Other["Low Water Graphics"])) then
        if not workspace:FindFirstChildOfClass("Terrain") then
            repeat task.wait() until workspace:FindFirstChildOfClass("Terrain")
        end
        workspace:FindFirstChildOfClass("Terrain").WaterWaveSize = 0
        workspace:FindFirstChildOfClass("Terrain").WaterWaveSpeed = 0
        workspace:FindFirstChildOfClass("Terrain").WaterReflectance = 0
        workspace:FindFirstChildOfClass("Terrain").WaterTransparency = 0
        if sethiddenproperty then
            sethiddenproperty(workspace:FindFirstChildOfClass("Terrain"), "Decoration", false)
        end
    end
end)

-- [All other original configuration coroutines remain the same...]

-- Process existing instances
game.DescendantAdded:Connect(function(value)
    wait(_G.LoadedWait or 1)
    CheckIfBad(value)
end)

local Descendants = game:GetDescendants()
local StartNumber = _G.WaitPerAmount or 500
local WaitNumber = _G.WaitPerAmount or 500

for i, v in pairs(Descendants) do
    CheckIfBad(v)
    if i == WaitNumber then
        task.wait()
        WaitNumber = WaitNumber + StartNumber
    end
end

warn("FPS Booster Loaded (Tree Textures Preserved)!")
