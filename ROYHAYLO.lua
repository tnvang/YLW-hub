-- ROYHAYLO PREMIUM (UPDATED & FIXED)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16,
    Jump = 50,
    FlySpeed = 100,
    HitboxSize = 2,
    Fly = false,
    ESP = true,
    KillAura = false,
    GodMode = false,
    MenuVisible = true
}

-- MAIN GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 450)
Main.Position = UDim2.new(0.5, -130, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "Royhaylo"
Title.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

-- Thêm hướng dẫn đóng mở
local Hint = Instance.new("TextLabel", Main)
Hint.Size = UDim2.new(1, 0, 0, 20)
Hint.Position = UDim2.new(0, 0, 1, 0)
Hint.Text = "Press [RightControl] to Hide/Show"
Hint.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Hint.BackgroundTransparency = 1
Hint.TextSize = 12

-- TOGGLE GUI BẰNG PHÍM RIGHT CONTROL
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        _G.Settings.MenuVisible = not _G.Settings.MenuVisible
        Main.Visible = _G.Settings.MenuVisible
    end
end)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -65)
Container.Position = UDim2.new(0, 5, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI BUILDERS (Giữ nguyên logic slider và toggle của bạn)
function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 45); Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 15); Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1); Label.BackgroundTransparency = 1; Label.TextSize = 12
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 6); Bar.Position = UDim2.new(0, 0, 0.65, 0); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        Label.Text = name .. " : " .. val; callback(val)
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

function CreateToggle(name, default, callback)
    local T = Instance.new("TextButton", Container)
    T.Size = UDim2.new(0.9, 0, 0, 35); T.Text = name .. " : " .. (default and "ON" or "OFF")
    T.BackgroundColor3 = default and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 50)
    T.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", T)
    local on = default
    T.MouseButton1Click:Connect(function()
        on = not on; T.Text = name .. " : " .. (on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 50)
        callback(on)
    end)
end

-- --- CORE LOGIC ---

-- FIX KILL AURA (Sử dụng Raycast hoặc Khoảng cách gần hơn)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.KillAura then
            pcall(function()
                local char = player.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if tool then
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local targetPart = v.Character.HumanoidRootPart
                            local dist = (char.HumanoidRootPart.Position - targetPart.Position).Magnitude
                            if dist < 20 then -- Tầm đánh hợp lý để không bị kick
                                tool:Activate()
                                if firetouchinterest then
                                    firetouchinterest(targetPart, tool.Handle, 0)
                                    firetouchinterest(targetPart, tool.Handle, 1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- FLY & SPEED LOGIC
RunService.Stepped:Connect(function()
    pcall(function()
        local char = player.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if _G.Settings.Fly and root then
            root.Velocity = Vector3.new(0, 0.1, 0) -- Giữ nhân vật lơ lửng
            if hum.MoveDirection.Magnitude > 0 then
                root.Velocity = (camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z * -1)) * _G.Settings.FlySpeed)
            end
        end
        if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            char:TranslateBy(hum.MoveDirection * (_G.Settings.Speed / 100))
        end
    end)
end)

-- GOD MODE (Simple Loop)
task.spawn(function()
    while task.wait(0.5) do
        if _G.Settings.GodMode then
            pcall(function() player.Character.Humanoid.Health = 100 end)
        end
    end
end)

-- ESP & HITBOX
task.spawn(function()
    while task.wait(1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                -- Hitbox
                v.Character.HumanoidRootPart.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                v.Character.HumanoidRootPart.Transparency = 0.7
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- CONTROLS
CreateSlider("WalkSpeed", 16, 300, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Fly Speed", 50, 500, 100, function(v) _G.Settings.FlySpeed = v end)
CreateSlider("Hitbox Size", 2, 50, 2, function(v) _G.Settings.HitboxSize = v end)
CreateToggle("Kill Aura", false, function(v) _G.Settings.KillAura = v end)
CreateToggle("God Mode", false, function(v) _G.Settings.GodMode = v end)
CreateToggle("Fly (Noclip)", false, function(v) _G.Settings.Fly = v end)
CreateToggle("Show ESP", true, function(v) _G.Settings.ESP = v end)

