-- lvXuanAnh GUI - ANTI-KICK & FULL ESP
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- SETTINGS
_G.Settings = {
    Speed = 16,
    FlySpeed = 120,
    Hitbox = 150,
    FastAttack = false,
    Aimlock = false,
    ESP = false,
    Fly = false
}

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 420)
Main.Position = UDim2.new(0.5, -130, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "lvXuanAnh" -- Đã sửa tên theo yêu cầu
Title.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Instance.new("UICorner", Title)

-- MINIMIZE SYSTEM
local Min = Instance.new("TextButton", Title)
Min.Size = UDim2.new(0, 40, 0, 30)
Min.Position = UDim2.new(1, -45, 0, 5)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(255, 80, 150)

local Mini = Instance.new("TextButton", ScreenGui)
Mini.Size = UDim2.new(0, 60, 0, 60)
Mini.Position = UDim2.new(0, 20, 0.6, 0)
Mini.Text = "lvXA"
Mini.Visible = false
Mini.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
Instance.new("UICorner", Mini)

Min.MouseButton1Click:Connect(function() Main.Visible = false Mini.Visible = true end)
Mini.MouseButton1Click:Connect(function() Main.Visible = true Mini.Visible = false end)

-- CONTAINER
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- BUILDER FUNCTIONS
function Toggle(name, callback)
    local T = Instance.new("TextButton", Container)
    T.Size = UDim2.new(0.9, 0, 0, 35)
    T.Text = name .. " : OFF"
    T.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    T.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", T)
    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.Text = name .. " : " .. (on and "ON" or "OFF")
        T.BackgroundColor3 = on and Color3.fromRGB(255, 120, 180) or Color3.fromRGB(40, 40, 45)
        callback(on)
    end)
end

function Slider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 6)
    Bar.Position = UDim2.new(0, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move = RunService.RenderStepped:Connect(function()
                local pos = UIS:GetMouseLocation().X
                local percent = math.clamp((pos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                local val = math.floor(min + (max - min) * percent)
                Label.Text = name .. " : " .. val
                callback(val)
            end)
            UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end
    end)
end

-- --- CORE FEATURES ---

-- 1. WalkSpeed Bypass (Chống Kick 267)
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character.Humanoid
            if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.Settings.Speed/130))
            end
        end
    end)
end)

-- 2. Fast Attack & Ultra Reach 150
task.spawn(function()
    while task.wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    VU:CaptureController()
                    VU:ClickButton1(Vector2.new(850, 520))
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(_G.Settings.Hitbox, _G.Settings.Hitbox, _G.Settings.Hitbox)
                        tool.Handle.Transparency = 0.8
                        tool.Handle.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- 3. Fly & Noclip Fix
task.spawn(function()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0,0,0)
    RunService.Heartbeat:Connect(function()
        if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            bv.Parent = player.Character.HumanoidRootPart
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = camera.CFrame.LookVector * _G.Settings.FlySpeed
            for _, v in pairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        else
            bv.MaxForce = Vector3.new(0,0,0)
            bv.Parent = nil
        end
    end)
end)

-- 4. Full ESP (Names + Highlight)
local function UpdateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            local folder = v.Character:FindFirstChild("lvXA_ESP") or Instance.new("Folder", v.Character)
            folder.Name = "lvXA_ESP"
            if _G.Settings.ESP then
                local h = folder:FindFirstChild("Highlight") or Instance.new("Highlight", folder)
                h.FillColor = Color3.fromRGB(255, 0, 120)
                local b = folder:FindFirstChild("Tag") or Instance.new("BillboardGui", folder)
                b.Name = "Tag"
                b.Size = UDim2.new(0, 200, 0, 50)
                b.Adornee = hrp
                b.AlwaysOnTop = true
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L"
                l.Size = UDim2.new(1, 0, 1, 0)
                l.BackgroundTransparency = 1
                l.TextColor3 = Color3.new(1, 1, 1)
                l.Text = string.format("%s\n[%d m]", v.Name, math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude))
            else
                folder:ClearAllChildren()
            end
        end
    end
end

-- --- CREATE CONTROLS ---
Slider("Speed Bypass", 16, 300, 16, function(v) _G.Settings.Speed = v end)
Slider("Fly Speed", 50, 500, 120, function(v) _G.Settings.FlySpeed = v end)
Slider("Reach Size", 5, 200, 150, function(v) _G.Settings.Hitbox = v end)
Toggle("Fast Attack", function(v) _G.Settings.FastAttack = v end)
Toggle("Aimlock Player", function(v) _G.Settings.Aimlock = v end)
Toggle("Full ESP", function(v) _G.Settings.ESP = v end)
Toggle("Fly + Noclip", function(v) _G.Settings.Fly = v end)

task.spawn(function() while task.wait(0.5) do UpdateESP() end end)

