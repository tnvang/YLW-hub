-- ROYJETBAN ULTIMATE (SUPER KILL AURA - HIGHLIGHT ESP - GOD MODE)
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
    ESP = true,
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

-- QUICK KILL BUTTON (FLOATING)
local QuickKill = Instance.new("TextButton", ScreenGui)
QuickKill.Size = UDim2.new(0, 60, 0, 60)
QuickKill.Position = UDim2.new(0.85, 0, 0.7, 0)
QuickKill.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
QuickKill.Text = "KILL"
QuickKill.TextColor3 = Color3.new(1,1,1)
QuickKill.Font = Enum.Font.SourceSansBold
QuickKill.TextSize = 18
local QCorner = Instance.new("UICorner", QuickKill)
QCorner.CornerRadius = UDim.new(1,0)
QuickKill.Active = true; QuickKill.Draggable = true

QuickKill.MouseButton1Click:Connect(function()
    _G.Settings.KillAura = not _G.Settings.KillAura
    QuickKill.BackgroundColor3 = _G.Settings.KillAura and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(150, 0, 0)
    QuickKill.Text = _G.Settings.KillAura and "KILLING" or "KILL"
end)

local Title = Instance.new("TextLabel",Main)
Title.Size = UDim2.new(1,0,0,45)
Title.Text = "Royjetban" -- Tên thương hiệu mới của bạn
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 22
Instance.new("UICorner",Title)

local Container = Instance.new("ScrollingFrame",Main)
Container.Size = UDim2.new(1,-10,1,-60)
Container.Position = UDim2.new(0,5,0,50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
local Layout = Instance.new("UIListLayout",Container)
Layout.Padding = UDim.new(0,8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI BUILDERS
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
        local pos = math.clamp((input.Position.X-Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos,0,1,0)
        local val = math.floor(min+(max-min)*pos)
        Label.Text = name.." : "..val
        callback(val)
    end
    Bar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = true end end)
    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then Update(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = false end end)
end

function CreateToggle(name,default,callback)
    local T = Instance.new("TextButton",Container)
    T.Size = UDim2.new(0.9,0,0,30)
    T.BackgroundColor3 = default and Color3.fromRGB(255,100,150) or Color3.fromRGB(40,40,50)
    T.Text = name.." : "..(default and "ON" or "OFF")
    T.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",T)
    local on = default
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name.." : "..(on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255,100,150) or Color3.fromRGB(40,40,50)
        callback(on)
    end)
end

-- --- CORE LOGIC (ROYJETBAN VERSION) ---

-- KILL AURA (INSTANT & POWERFUL)
task.spawn(function()
    while task.wait(0.01) do
        if _G.Settings.KillAura and player.Character then
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local tRoot = v.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot and (player.Character.HumanoidRootPart.Position - tRoot.Position).Magnitude <= 1000 then
                            tool:Activate()
                            pcall(function()
                                local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
                                if handle then
                                    firetouchinterest(tRoot, handle, 0)
                                    firetouchinterest(tRoot, handle, 1)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- FULL ESP (HIGHLIGHT & NAME)
local function CreateESP(targetPlayer)
    if targetPlayer == player then return end
    
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "Royjetban_ESP"
    Highlight.FillColor = Color3.fromRGB(255, 0, 127)
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.Parent = game.CoreGui

    local NameTag = Instance.new("BillboardGui", game.CoreGui)
    NameTag.Size = UDim2.new(0, 100, 0, 50)
    NameTag.AlwaysOnTop = true
    NameTag.StudsOffset = Vector3.new(0, 3, 0)
    local Label = Instance.new("TextLabel", NameTag)
    Label.Text = targetPlayer.Name
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14

    RunService.RenderStepped:Connect(function()
        if _G.Settings.ESP and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Highlight.Adornee = targetPlayer.Character
            NameTag.Adornee = targetPlayer.Character.HumanoidRootPart
            Highlight.Enabled = true
            NameTag.Enabled = true
        else
            Highlight.Enabled = false
            NameTag.Enabled = false
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(CreateESP)

-- GOD MODE
RunService.Heartbeat:Connect(function()
    if _G.Settings.GodMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
    end
end)

-- FLY & MOVEMENT
RunService.Stepped:Connect(function()
    pcall(function()
        local root = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        if _G.Settings.Fly then
            root.Velocity = Vector3.new(0, 1.2, 0)
            if hum.MoveDirection.Magnitude > 0 then
                root.Velocity = (camera.CFrame.LookVector * hum.MoveDirection.Z + camera.CFrame.RightVector * hum.MoveDirection.X).Unit * _G.Settings.FlySpeed
            end
        end
        if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (_G.Settings.Speed/130))
        end
    end)
end)

-- CONTROLS
CreateSlider("WalkSpeed", 16, 500, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 500, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Fly Speed", 50, 500, 100, function(v) _G.Settings.FlySpeed = v end)
CreateToggle("Kill Aura (Instant)", false, function(v) _G.Settings.KillAura = v end)
CreateToggle("God Mode", false, function(v) _G.Settings.GodMode = v end)
CreateToggle("Fly (Noclip)", false, function(v) _G.Settings.Fly = v end)
CreateToggle("ESP Full", true, function(v) _G.Settings.ESP = v end)

