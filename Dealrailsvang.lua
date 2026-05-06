--[[
    Brand: dealrailsvang Hub (Mini Version)
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local US = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Cấu hình nhanh
local Config = { Radius = 15, Force = 50, Range = 500, Part = "HumanoidRootPart" }
local ShieldActive, AimActive = false, false

-- Khởi tạo Orion Library gọn nhẹ
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "dealrailsvang Hub", HidePremium = true, SaveConfig = false})
local Tab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})

-- Toggles giao diện
Tab:AddToggle({
    Name = "Bật Khiên Đẩy Quái",
    Default = false,
    Callback = function(v) ShieldActive = v end
})

Tab:AddToggle({
    Name = "Bật Aim Wallhack",
    Default = false,
    Callback = function(v) AimActive = v end
})

-- Hàm tìm mục tiêu gần tâm màn hình nhất
local function GetClosestEnemy()
    local target, shortDist = nil, math.huge
    local mousePos = US:GetMouseLocation()

    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild(Config.Part) and obj ~= LocalPlayer.Character then
            local screenPos, onScreen = Camera:WorldToViewportPoint(obj[Config.Part].Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortDist and dist <= Config.Range then
                    target = obj
                    shortDist = dist
                end
            end
        end
    end
    return target
end

-- Vòng lặp xử lý Khiên + Aim + Wallhack (Xuyên Tường)
RunService.RenderStepped:Connect(function()
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position

    -- Xử lý Quét và Đẩy quái (Shield)
    if ShieldActive then
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= myChar and obj:FindFirstChild("HumanoidRootPart") then
                if (myPos - obj.HumanoidRootPart.Position).Magnitude <= Config.Radius then
                    obj.HumanoidRootPart.Velocity = (obj.HumanoidRootPart.Position - myPos).Unit * Config.Force
                end
            end
        end
    end

    -- Xử lý Aim Lock & Wallhack ESP
    if AimActive then
        local enemy = GetClosestEnemy()
        if enemy and enemy:FindFirstChild(Config.Part) then
            -- Aim Lock
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemy[Config.Part].Position)
            
            -- Wallhack (ESP Xuyên Tường)
            if not enemy:FindFirstChild("vangiuanh_ESP") then
                local hl = Instance.new("Highlight")
                hl.Name = "vangiuanh_ESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = enemy
            end
        end
    else
        -- Tự động dọn dẹp ESP khi tắt Aim
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChild("vangiuanh_ESP") then
                obj.vangiuanh_ESP:Destroy()
            end
        end
    end
end)

OrionLib:Init()

