-- XuanAnhhub premium - ADVANCED VERSION (NO FAST ATTACK)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16, Jump = 50, FlySpeed = 100, 
    HitboxSize = 10, Fly = false, ESP = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 400)
Main.Position = UDim2.new(0.5, -130, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "XuanAnhhub premium" 
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Instance.new("UICorner", Title)

-- MINIMIZE SYSTEM
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "OPEN"; OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Instance.new("UICorner", OpenBtn)

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 35, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.Text = "_"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -60)
Container.Position = UDim2.new(0, 5, 0, 50)
Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUILDERS (SLIDER & TOGGLE)
function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 50); Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20); Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1); Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 6); Bar.Position = UDim2.new(0, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        Label.Text = name .. " : " .. val
        callback(val)
    end
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function CreateToggle(name, callback)
    local T = Instance.new("TextButton", Container)
    T.Size = UDim2.new(0.9, 0, 0, 35); T.Text = name .. " : OFF"
    T.BackgroundColor3 = Color3.fromRGB(40, 40, 50); T.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", T)
    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name .. " : " .. (on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(40, 40, 50)
        callback(on)
    end)
end

-- --- PREMIUM LOGIC ---

-- SPEED & JUMP & NOCLIP
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character then
            if _G.Settings.Fly then -- NOCLIP WHEN FLYING
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum then
                hum.JumpPower = _G.Settings.Jump
                if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.Settings.Speed / 130))
                end
            end
        end
    end)
end)

-- FLY SYSTEM
RunService.RenderStepped:Connect(function()
    if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = camera.CFrame.LookVector * _G.Settings.FlySpeed
    end
end)

-- ENEMY HITBOX & ESP
task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local root = v.Character.HumanoidRootPart
                -- HITBOX LOGIC
                root.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                root.Transparency = 0.7
                root.CanCollide = false
                
                -- ESP LOGIC (NAME & DISTANCE)
                local head = v.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("XuanAnhESP")
                    if _G.Settings.ESP then
                        if not esp then
                            local bg = Instance.new("BillboardGui", head)
                            bg.Name = "XuanAnhESP"; bg.Size = UDim2.new(0, 100, 0, 50)
                            bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0, 3, 0)
                            local tl = Instance.new("TextLabel", bg)
                            tl.Size = UDim2.new(1, 0, 1, 0); tl.BackgroundTransparency = 1
                            tl.TextColor3 = Color3.new(1, 1, 1); tl.TextStrokeTransparency = 0
                            tl.TextSize = 14
                        end
                        local dist = math.floor((player.Character.HumanoidRootPart.Position - root.Position).Magnitude)
                        head.XuanAnhESP.TextLabel.Text = v.Name .. " [" .. dist .. "m]"
                    elseif esp then esp:Destroy() end
                end
            end
        end
    end
end)

-- CONTROLS
CreateSlider("WalkSpeed", 16, 500, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 500, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Enemy Hitbox", 2, 100, 10, function(v) _G.Settings.HitboxSize = v end)
CreateSlider("Fly Speed", 50, 500, 100, function(v) _G.Settings.FlySpeed = v end)

CreateToggle("ESP (Name & Distance)", function(v) _G.Settings.ESP = v end)
CreateToggle("Fly (Noclip)", function(v) _G.Settings.Fly = v end)

