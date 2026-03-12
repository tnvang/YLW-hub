-- lvXuanAnh PRO V7 - ENGLISH VERSION (FIXED & OPTIMIZED)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16, Jump = 50, FlySpeed = 100, Hitbox = 10,
    FastAttack = false, Fly = false, ESP = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 400)
Main.Position = UDim2.new(0.5, -130, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.Active = true Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "lvXuanAnh PRO V7" -- GUI Title
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 22
Instance.new("UICorner", Title)

-- MINIMIZE BUTTONS
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 60, 0, 35)
OpenBtn.Position = UDim2.new(0, 5, 0.4, 0)
OpenBtn.Text = "MENU"; OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Instance.new("UICorner", OpenBtn)

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 35, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.Text = "_"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

-- CONTAINER
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -60)
Container.Position = UDim2.new(0, 5, 0, 50)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 12)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
end)

-- SLIDER BUILDER (FIXED FOR MOBILE)
function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 55); Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 25); Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1); Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 8); Bar.Position = UDim2.new(0, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)

    local dragging = false
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UIS:GetMouseLocation().X
            local sizeX = math.clamp((mousePos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(sizeX, 0, 1, 0)
            local val = math.floor(min + (max - min) * sizeX)
            Label.Text = name .. " : " .. val
            callback(val)
        end
    end)
end

-- TOGGLE BUILDER
function CreateToggle(name, callback)
    local T = Instance.new("TextButton", Container)
    T.Size = UDim2.new(0.9, 0, 0, 40); T.Text = name .. " : OFF"
    T.BackgroundColor3 = Color3.fromRGB(45, 45, 55); T.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", T)
    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name .. " : " .. (on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(45, 45, 55)
        callback(on)
    end)
end

-- LOGIC SYSTEMS
RunService.Stepped:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = _G.Settings.Jump
            if _G.Settings.Speed > 16 and char.Humanoid.MoveDirection.Magnitude > 0 then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (_G.Settings.Speed / 155))
            end
        end
    end)
end)

task.spawn(function()
    while task.wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    VU:CaptureController()
                    VU:ClickButton1(Vector2.new())
                    tool.Handle.Size = Vector3.new(_G.Settings.Hitbox, _G.Settings.Hitbox, _G.Settings.Hitbox)
                    tool.Handle.CanCollide = false
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = v.Character:FindFirstChild("Highlight")
                if _G.Settings.ESP then
                    if not h then
                        h = Instance.new("Highlight", v.Character)
                        h.FillColor = Color3.fromRGB(255, 100, 150)
                    end
                elseif h then h:Destroy() end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = camera.CFrame.LookVector * _G.Settings.FlySpeed
    end
end)

-- ENGLISH CONTROLS
CreateSlider("WalkSpeed Bypass", 16, 300, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 300, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Hitbox Size", 5, 200, 10, function(v) _G.Settings.Hitbox = v end)
CreateSlider("Fly Speed", 50, 500, 100, function(v) _G.Settings.FlySpeed = v end)

CreateToggle("Fast Attack", function(v) _G.Settings.FastAttack = v end)
CreateToggle("Player ESP", function(v) _G.Settings.ESP = v end)
CreateToggle("Fly Mode", function(v) _G.Settings.Fly = v end)

