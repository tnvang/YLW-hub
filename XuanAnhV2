-- XUANANH V2 (ENGLISH VERSION - BRAND UPDATED)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Speed = 16,
    Jump = 50,
    FlySpeed = 100,
    HitboxSize = 10,
    Fly = false,
    ESP = false,
    KillAura = false,
    GodMode = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,260,0,480)
Main.Position = UDim2.new(0.5,-130,0.5,-240)
Main.BackgroundColor3 = Color3.fromRGB(20,20,30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner",Main)

-- FLOATING QUICK KILL BUTTON
local QuickKill = Instance.new("TextButton", ScreenGui)
QuickKill.Size = UDim2.new(0, 60, 0, 60)
QuickKill.Position = UDim2.new(0.8, 0, 0.2, 0)
QuickKill.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
QuickKill.Text = "KILL"
QuickKill.TextColor3 = Color3.new(1,1,1)
QuickKill.Font = Enum.Font.SourceSansBold
QuickKill.TextSize = 18
QuickKill.Active = true
QuickKill.Draggable = true
local QCorner = Instance.new("UICorner", QuickKill)
QCorner.CornerRadius = UDim.new(1,0)

QuickKill.MouseButton1Click:Connect(function()
    _G.Settings.KillAura = not _G.Settings.KillAura
    QuickKill.BackgroundColor3 = _G.Settings.KillAura and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 0, 0)
    QuickKill.Text = _G.Settings.KillAura and "KILLING" or "KILL"
end)

local Title = Instance.new("TextLabel",Main)
Title.Size = UDim2.new(1,0,0,45)
Title.Text = "XuanAnhV2" -- Tên đã được sửa
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Instance.new("UICorner",Title)

-- MINIMIZE SYSTEM
local OpenBtn = Instance.new("TextButton",ScreenGui)
OpenBtn.Size = UDim2.new(0,80,0,35)
OpenBtn.Position = UDim2.new(0,10,0.5,0)
OpenBtn.Text = "OPEN"
OpenBtn.Visible = false
OpenBtn.BackgroundColor3 = Color3.fromRGB(255,100,150)
Instance.new("UICorner",OpenBtn)

local CloseBtn = Instance.new("TextButton",Title)
CloseBtn.Size = UDim2.new(0,35,0,30)
CloseBtn.Position = UDim2.new(1,-40,0,7)
CloseBtn.Text = "_"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
Instance.new("UICorner",CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

local Container = Instance.new("ScrollingFrame",Main)
Container.Size = UDim2.new(1,-10,1,-60)
Container.Position = UDim2.new(0,5,0,50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout",Container)
Layout.Padding = UDim.new(0,8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI BUILDERS
function CreateButton(name,callback)
    local B = Instance.new("TextButton",Container)
    B.Size = UDim2.new(0.9,0,0,30)
    B.Text = name
    B.BackgroundColor3 = Color3.fromRGB(70,70,90)
    B.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",B)
    B.MouseButton1Click:Connect(callback)
end

function CreateToggle(name,callback)
    local T = Instance.new("TextButton",Container)
    T.Size = UDim2.new(0.9,0,0,30)
    T.Text = name.." : OFF"
    T.BackgroundColor3 = Color3.fromRGB(40,40,50)
    T.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",T)
    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name.." : "..(on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255,100,150) or Color3.fromRGB(40,40,50)
        callback(on)
    end)
end

function CreateSlider(name,min,max,default,callback)
    local Frame = Instance.new("Frame",Container)
    Frame.Size = UDim2.new(0.9,0,0,45); Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel",Frame)
    Label.Size = UDim2.new(1,0,0,15); Label.Text = name.." : "..default
    Label.TextColor3 = Color3.new(1,1,1); Label.BackgroundTransparency = 1; Label.TextSize = 12
    local Bar = Instance.new("Frame",Frame)
    Bar.Size = UDim2.new(1,0,0,6); Bar.Position = UDim2.new(0,0,0.65,0)
    Bar.BackgroundColor3 = Color3.fromRGB(50,50,60)
    local Fill = Instance.new("Frame",Bar)
    Fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(255,100,150)

    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
        Fill.Size = UDim2.new(pos,0,1,0)
        local val = math.floor(min+(max-min)*pos)
        Label.Text = name.." : "..val
        callback(val)
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = false end end)
end

-- CORE LOGIC
RunService.Stepped:Connect(function()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.JumpPower = _G.Settings.Jump
            if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
                root.CFrame = root.CFrame + (hum.MoveDirection * (_G.Settings.Speed/130))
            end
            if _G.Settings.Fly then
                for _,p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
                root.Velocity = Vector3.new(0,0,0)
                local move = hum.MoveDirection
                root.Velocity = (camera.CFrame.LookVector*move.Z + camera.CFrame.RightVector*move.X) * _G.Settings.FlySpeed
            end
        end
    end
end)

-- KILL AURA (FIXED)
task.spawn(function()
    while task.wait(0.05) do
        if _G.Settings.KillAura and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Parent ~= player.Character and v.Health > 0 then
                    local targetRoot = v.Parent:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        local dist = (player.Character.HumanoidRootPart.Position - targetRoot.Position).Magnitude
                        if dist <= 500 then
                            if tool and tool:FindFirstChild("Handle") then
                                tool:Activate()
                                firetouchinterest(targetRoot, tool.Handle, 0)
                                firetouchinterest(targetRoot, tool.Handle, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- GOD MODE
RunService.Heartbeat:Connect(function()
    if _G.Settings.GodMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end)

-- ESP + HITBOX
task.spawn(function()
    while task.wait(0.5) do
        for _,v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local root = v.Character.HumanoidRootPart
                root.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                root.Transparency = _G.Settings.ESP and 0.7 or 1
                root.CanCollide = false
            end
        end
    end
end)

-- BUTTONS
CreateSlider("WalkSpeed", 16, 500, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 500, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Fly Speed", 50, 500, 100, function(v) _G.Settings.FlySpeed = v end)
CreateSlider("Enemy Hitbox", 2, 100, 10, function(v) _G.Settings.HitboxSize = v end)
CreateToggle("Kill Aura (500m)", function(v) _G.Settings.KillAura = v end)
CreateToggle("God Mode", function(v) _G.Settings.GodMode = v end)
CreateToggle("Fly (Noclip)", function(v) _G.Settings.Fly = v end)
CreateToggle("ESP", function(v) _G.Settings.ESP = v end)
CreateButton("Activate Invisibility", function()
    for _,v in pairs(player.Character:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
    end
end)
