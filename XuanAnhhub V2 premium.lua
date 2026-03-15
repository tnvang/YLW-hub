local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16, Jump = 50, FlySpeed = 100, 
    HitboxSize = 10, Fly = false, ESP = false,
    KillAura = false, GodMode = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 450)
Main.Position = UDim2.new(0.5, -130, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true Main.Draggable = true
Instance.new("UICorner", Main)

-- QUICK KILL BUTTON (FLOATING ROUND BUTTON)
local QuickKillBtn = Instance.new("TextButton", ScreenGui)
QuickKillBtn.Size = UDim2.new(0, 60, 0, 60)
QuickKillBtn.Position = UDim2.new(0.85, 0, 0.7, 0) 
QuickKillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
QuickKillBtn.Text = "KILL"
QuickKillBtn.TextColor3 = Color3.new(1, 1, 1)
QuickKillBtn.TextSize = 18
QuickKillBtn.Font = Enum.Font.SourceSansBold
local QuickCorner = Instance.new("UICorner", QuickKillBtn)
QuickCorner.CornerRadius = UDim.new(1, 0)
QuickKillBtn.Active = true
QuickKillBtn.Draggable = true 

QuickKillBtn.MouseButton1Click:Connect(function()
    _G.Settings.KillAura = not _G.Settings.KillAura
    QuickKillBtn.BackgroundColor3 = _G.Settings.KillAura and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    QuickKillBtn.Text = _G.Settings.KillAura and "KILLING" or "KILL"
end)

-- TITLE (ENGLISH)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "XuanAnhhub V2 Premium" 
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
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
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUILDERS
function CreateSlider(name, min, max, default, callback)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16, Jump = 50, FlySpeed = 100, 
    HitboxSize = 10, Fly = false, ESP = false,
    KillAura = false, GodMode = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 450)
Main.Position = UDim2.new(0.5, -130, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true Main.Draggable = true
Instance.new("UICorner", Main)

-- QUICK KILL BUTTON (FLOATING ROUND BUTTON)
local QuickKillBtn = Instance.new("TextButton", ScreenGui)
QuickKillBtn.Size = UDim2.new(0, 60, 0, 60)
QuickKillBtn.Position = UDim2.new(0.85, 0, 0.7, 0) 
QuickKillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
QuickKillBtn.Text = "KILL"
QuickKillBtn.TextColor3 = Color3.new(1, 1, 1)
QuickKillBtn.TextSize = 18
QuickKillBtn.Font = Enum.Font.SourceSansBold
local QuickCorner = Instance.new("UICorner", QuickKillBtn)
QuickCorner.CornerRadius = UDim.new(1, 0)
QuickKillBtn.Active = true
QuickKillBtn.Draggable = true 

QuickKillBtn.MouseButton1Click:Connect(function()
    _G.Settings.KillAura = not _G.Settings.KillAura
    QuickKillBtn.BackgroundColor3 = _G.Settings.KillAura and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(100, 0, 0)
    QuickKillBtn.Text = _G.Settings.KillAura and "KILLING" or "KILL"
end)

-- TITLE (ENGLISH)
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "XuanAnhhub V2 Premium" 
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
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
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- BUILDERS
function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 45); Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 15); Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1); Label.BackgroundTransparency = 1; Label.TextSize = 12
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 6); Bar.Position = UDim2.new(0, 0, 0.65, 0)
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
    T.Size = UDim2.new(0.9, 0, 0, 30); T.Text = name .. " : OFF"
    T.BackgroundColor3 = Color3.fromRGB(40, 40, 50); T.TextColor3 = Color3.new(1, 1, 1)
    T.TextSize = 14
    Instance.new("UICorner", T)
    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name .. " : " .. (on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(40, 40, 50)
        callback(on)
    end)
end

function CreateButton(name, callback)
    local B = Instance.new("TextButton", Container)
    B.Size = UDim2.new(0.9, 0, 0, 30); B.Text = name
    B.BackgroundColor3 = Color3.fromRGB(60, 60, 80); B.TextColor3 = Color3.new(1, 1, 1)
    B.TextSize = 14
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(callback)
end

-- LOGIC
task.spawn(function()
    while task.wait(0.05) do
        if _G.Settings.KillAura then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                local myRoot = player.Character.HumanoidRootPart
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= player.Character and v.Health > 0 then
                        local targetRoot = v.Parent:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local dist = (myRoot.Position - targetRoot.Position).magnitude
                            if dist <= 1640 then -- 500m
                                if tool then
                                    tool:Activate()
                                    if tool:FindFirstChild("Handle") then
                                        firetouchinterest(targetRoot, tool.Handle, 0)
                                        firetouchinterest(targetRoot, tool.Handle, 1)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.Settings.GodMode then
        pcall(function()
            player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
        end)
    end
end)

-- CONTROLS (ENGLISH LABELS)
CreateSlider("WalkSpeed", 16, 500, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 500, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Enemy Hitbox", 2, 100, 10, function(v) _G.Settings.HitboxSize = v end)

CreateToggle("Kill Aura (500m)", function(v) _G.Settings.KillAura = v end)
CreateToggle("God Mode", function(v) _G.Settings.GodMode = v end)
CreateToggle("ESP (Name & Dist)", function(v) _G.Settings.ESP = v end)
CreateToggle("Fly (Noclip)", function(v) _G.Settings.Fly = v end)
CreateButton("Activate Invisibility", function()
    for _, v in pairs(player.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
    end
end)
