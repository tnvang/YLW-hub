local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain") or workspace.Terrain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Lighting.GlobalShadows = false
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.FogStart = 9e9
Lighting.FogEnd = 9e9

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if atmosphere then atmosphere.Density = 0 end

pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)

for _, v in ipairs(Lighting:GetDescendants()) do
    if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") 
    or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
        v.Enabled = false
    end
end

if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

local function OptimizeInstance(v)
    if not v or not v:IsA("Instance") then return end
    
    if v:IsA("BasePart") then
        pcall(function()
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
            v.MaterialVariant = ""
            if not v:IsDescendantOf(LocalPlayer.Character or workspace) or v.Name ~= "HumanoidRootPart" then
                v.FluidForces = Enum.FluidForces.None
            end
        end)
        
        if v:IsA("MeshPart") then
            pcall(function() v.RenderFidelity = Enum.RenderFidelity.Performance end)
        end
        
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1 
        
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") 
    or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
        
    elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
        v.Enabled = false
        
    elseif v:IsA("Highlight") then
        v.Enabled = false
        pcall(function()
            v.FillTransparency = 1
            v.OutlineTransparency = 1
        end)
        
    elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
        pcall(function()
            v.MaxDistance = 100 
        end)
        
    elseif v:IsA("Explosion") then
        v.Visible = false
    end
end

task.spawn(function()
    local descendants = workspace:GetDescendants()
    local count = 0
    
    for i = 1, #descendants do
        local obj = descendants[i]
        OptimizeInstance(obj)
        
        count = count + 1
        if count >= 100 then 
            count = 0
            task.wait() 
        end
    end
end)

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    if not v or not v.Parent then return end
    OptimizeInstance(v)
end)

