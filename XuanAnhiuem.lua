-- XuanAnhiuem - ULTIMATE PVP V3 (ENGLISH VERSION)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- --- GUI SETUP ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "XuanAnhiuem_EN_V3"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 480)
Main.Position = UDim2.new(0.5, -130, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XuanAnhiuem - PRO"
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Instance.new("UICorner", Title)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- --- SETTINGS ---
local _G = {
    Speed = 16,
    FlySpeed = 100,
    HitboxSize = 2,
    Aimlock = false,
    ESP = false,
    Flying = false,
    FastAttack = false,
    AttackSpeed = 0.1
}

-- --- UTILS ---
local function CreateToggle(text, callback)
    local on = false
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.Text = text .. " : OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = text .. (on and " : ON" or " : OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(40, 40, 45)
        callback(on)
    end)
end

-- --- CORE FEATURES ---

-- 1. WalkSpeed (Universal Bypass)
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and _G.Speed > 16 then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.Speed / 60))
            end
        end
    end)
end)

-- 2. Fly + Noclip
RunService.Stepped:Connect(function()
    if _G.Flying then
        pcall(function()
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

CreateToggle("Fly + Noclip", function(v)
    _G.Flying = v
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if v and root then
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "XuanAn_Fly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while _G.Flying do
                bv.Velocity = camera.CFrame.LookVector * _G.FlySpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- 3. Fast Attack (Virtual Input)
local VirtualUser = game:GetService("VirtualUser")
task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(0, 0))
            end)
            task.wait(_G.AttackSpeed)
        end
    end
end)

CreateToggle("Fast Attack", function(v)
    _G.FastAttack = v
    _G.AttackSpeed = 0.05
end)

CreateToggle("ULTRA Fast Attack", function(v)
    _G.FastAttack = v
    _G.AttackSpeed = 0.001
end)

-- 4. Hitbox Expander
task.spawn(function()
    while task.wait(1) do
        if _G.HitboxSize > 2 then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = v.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- 5. ESP & Visuals
CreateToggle("Player ESP", function(v) _G.ESP = v end)
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and not v.Character:FindFirstChild("iuXA_ESP") then
                local h = Instance.new("Highlight", v.Character)
                h.Name = "iuXA_ESP"
                h.FillColor = Color3.fromRGB(255, 100, 150)
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("iuXA_ESP") then
                v.Character.iuXA_ESP:Destroy()
            end
        end
    end
end)

-- --- SLIDERS ---
local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(1, -5, 0, 45)
    Frame.BackgroundTransparency = 1
    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, 0, 0, 15)
    Text.Text = name .. ": " .. default
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    local val = math.floor(min + (max - min) * pos)
                    Text.Text = name .. ": " .. val
                    callback(val)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end
            end)
        end
    end)
end

CreateSlider("Walk Speed", 16, 300, 16, function(v) _G.Speed = v end)
CreateSlider("Hitbox Scale", 2, 100, 2, function(v) _G.HitboxSize = v end)
CreateSlider("Fly Velocity", 50, 500, 100, function(v) _G.FlySpeed = v end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "XuanAnhiuem",
    Text = "Script Loaded Successfully!",
    Duration = 5
})

