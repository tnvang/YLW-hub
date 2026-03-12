-- lvXuanAnh PRO - FIXED MINIMIZE & ALL SLIDERS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- SETTINGS
_G.Settings = {
    Speed = 16,
    Jump = 50, -- Khôi phục phần Nhảy
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
Main.Draggable = true -- Cho phép kéo menu để không bị vướng
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "lvXuanAnh PRO"
Title.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Instance.new("UICorner", Title)

-- FIX LỖI THU GỌN (Sử dụng nút nhỏ ở góc để không chặn di chuyển)
local Mini = Instance.new("TextButton", ScreenGui)
Mini.Size = UDim2.new(0, 50, 0, 50)
Mini.Position = UDim2.new(0, 10, 0.5, 0)
Mini.Text = "OPEN"
Mini.Visible = false
Mini.BackgroundColor3 = Color3.fromRGB(255, 120, 180)
Instance.new("UICorner", Mini)

local CloseBtn = Instance.new("TextButton", Title)
CloseBtn.Size = UDim2.new(0, 35, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.Text = "_"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Mini.Visible = true
end)

Mini.MouseButton1Click:Connect(function()
    Main.Visible = true
    Mini.Visible = false
end)

-- CONTAINER
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -50)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 10)

-- --- SLIDER & TOGGLE FUNCTIONS ---
function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.9, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = name .. " : " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(1, 0, 0, 5)
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

function CreateToggle(name, callback)
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

-- --- FEATURES ---
RunService.Stepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        -- Fix Speed & Jump
        hum.JumpPower = _G.Settings.Jump
        if _G.Settings.Speed > 16 and hum.MoveDirection.Magnitude > 0 then
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (_G.Settings.Speed/140))
        end
    end
end)

-- Fast Attack & Hitbox 150
task.spawn(function()
    while task.wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    VU:CaptureController()
                    VU:ClickButton1(Vector2.new(0, 0))
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(_G.Settings.Hitbox, _G.Settings.Hitbox, _G.Settings.Hitbox)
                        tool.Handle.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- Fly System
task.spawn(function()
    local bv = Instance.new("BodyVelocity")
    RunService.Heartbeat:Connect(function()
        if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            bv.Parent = player.Character.HumanoidRootPart
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = camera.CFrame.LookVector * _G.Settings.FlySpeed
        else
            bv.Parent = nil
        end
    end)
end)

-- --- CREATE CONTROLS ---
CreateSlider("Speed Bypass", 16, 300, 16, function(v) _G.Settings.Speed = v end)
CreateSlider("Jump Power", 50, 200, 50, function(v) _G.Settings.Jump = v end)
CreateSlider("Fly Speed", 50, 500, 120, function(v) _G.Settings.FlySpeed = v end)
CreateSlider("Reach Size", 5, 200, 150, function(v) _G.Settings.Hitbox = v end)

CreateToggle("Fast Attack", function(v) _G.Settings.FastAttack = v end)
CreateToggle("Fly + Noclip", function(v) _G.Settings.Fly = v end)
CreateToggle("Full ESP", function(v) _G.Settings.ESP = v end)

