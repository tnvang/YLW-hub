local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16, Jump = 50, Fly = false, FlySpeed = 120,
    KillAura = false, AuraDist = 20, Aim = false, Smoothness = 0.2,
    Hitbox = false, HitboxSize = 10, ESP = false, Invisibility = false
}

-- GUI CORE
local gui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 750, 0, 320)
Main.Position = UDim2.new(0.5, -375, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("Frame", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
Instance.new("UICorner", Title)

local Label = Instance.new("TextLabel", Title)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.Text = "   ROYHAYLOV2 | VIP HUB"
Label.TextColor3 = Color3.new(1, 1, 1)
Label.TextSize = 20
Label.BackgroundTransparency = 1
Label.TextXAlignment = "Left"

-- PHÂN CHIA 2 CỘT
local LeftC = Instance.new("Frame", Main); LeftC.Size = UDim2.new(0.5, -15, 1, -60); LeftC.Position = UDim2.new(0, 10, 0, 55); LeftC.BackgroundTransparency = 1
local RightC = Instance.new("Frame", Main); RightC.Size = UDim2.new(0.5, -15, 1, -60); RightC.Position = UDim2.new(0.5, 5, 0, 55); RightC.BackgroundTransparency = 1

local LGrid = Instance.new("UIGridLayout", LeftC); LGrid.CellSize = UDim2.new(1, 0, 0, 60); LGrid.CellPadding = UDim2.new(0, 5, 0, 5)
local RGrid = Instance.new("UIGridLayout", RightC); RGrid.CellSize = UDim2.new(1, 0, 0, 60); RGrid.CellPadding = UDim2.new(0, 5, 0, 5)

-- HÀM TẠO CHỨC NĂNG (Gồm Nút và Input số)
function AddMod(parent, name, default, min, max, callback, toggle)
    local F = Instance.new("Frame", parent); F.BackgroundColor3 = Color3.fromRGB(25, 25, 35); Instance.new("UICorner", F)
    local B = Instance.new("TextButton", F); B.Size = UDim2.new(0.7, 0, 1, 0); B.Text = name..": OFF"; B.BackgroundTransparency = 1; B.TextColor3 = Color3.new(1,1,1)
    local I = Instance.new("TextBox", F); I.Size = UDim2.new(0.3, -5, 0.8, 0); I.Position = UDim2.new(0.7, 0, 0.1, 0); I.Text = tostring(default); I.BackgroundColor3 = Color3.fromRGB(40,40,50); I.TextColor3 = Color3.new(0,1,0); Instance.new("UICorner", I)
    
    local on = false
    B.MouseButton1Click:Connect(function()
        on = not on
        B.Text = name..": "..(on and "ON" or "OFF")
        B.TextColor3 = on and Color3.fromRGB(80, 120, 255) or Color3.new(1,1,1)
        toggle(on)
    end)
    I.FocusLost:Connect(function()
        local val = tonumber(I.Text); if val then val = math.clamp(val, min, max); I.Text = tostring(val); callback(val) end
    end)
end

-- PHẦN PVP (BÊN TRÁI)
AddMod(LeftC, "AIMLOCK", 20, 1, 100, function(v) _G.Settings.Smoothness = v/100 end, function(v) _G.Settings.Aim = v end)
AddMod(LeftC, "KILL AURA", 20, 1, 100, function(v) _G.Settings.AuraDist = v end, function(v) _G.Settings.KillAura = v end)
AddMod(LeftC, "SPEED", 100, 50, 500, function(v) _G.Settings.Speed = v end, function(v) _G.Settings.WalkOn = v end)
AddMod(LeftC, "JUMP", 100, 50, 300, function(v) _G.Settings.Jump = v end, function(v) _G.Settings.JumpOn = v end)

-- PHẦN HỖ TRỢ (BÊN PHẢI)
AddMod(RightC, "HITBOX", 10, 1, 800, function(v) _G.Settings.HitboxSize = v end, function(v) _G.Settings.Hitbox = v end)
AddMod(RightC, "FLY", 120, 50, 700, function(v) _G.Settings.FlySpeed = v end, function(v) _G.Settings.Fly = v end)
AddMod(RightC, "ESP", 0, 0, 0, function() end, function(v) _G.Settings.ESP = v end)
AddMod(RightC, "INVIS", 0, 0, 0, function() end, function(v) _G.Settings.Invisibility = v end)

-- LOGIC SPEED/JUMP
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if _G.Settings.WalkOn then player.Character.Humanoid.WalkSpeed = _G.Settings.Speed end
        if _G.Settings.JumpOn then player.Character.Humanoid.JumpPower = _G.Settings.Jump end
    end
end)

-- LOGIC FLY (SỬA LỖI NGƯỢC)
RunService.Stepped:Connect(function()
    if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            hrp.Velocity = (camera.CFrame.Rotation * Vector3.new(moveDir.X, 0, moveDir.Z)).Unit * _G.Settings.FlySpeed
        else
            hrp.Velocity = Vector3.new(0, 1, 0)
        end
    end
end)

-- LOGIC TÀNG HÌNH (INVIS)
task.spawn(function()
    while task.wait(0.5) do
        if player.Character and _G.Settings.Invisibility then
            for _, p in pairs(player.Character:GetChildren()) do
                if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = 0.8 end
            end
        end
    end
end)

-- LOGIC HITBOX (RESET KHI TẮT)
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if _G.Settings.Hitbox then
                hrp.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                hrp.Transparency = 0.7; hrp.Material = "Neon"; hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true
            end
        end
    end
end)

-- LOGIC ESP (ĐƠN GIẢN)
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            if _G.Settings.ESP then
                if not head:FindFirstChild("RoyESP") then
                    local bg = Instance.new("BillboardGui", head); bg.Name = "RoyESP"; bg.Size = UDim2.new(0, 100, 0, 50); bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0, 3, 0)
                    local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1; tl.Text = v.Name; tl.TextColor3 = Color3.new(1, 0, 0); tl.TextSize = 14
                end
            else
                if head:FindFirstChild("RoyESP") then head.RoyESP:Destroy() end
            end
        end
    end
end)

