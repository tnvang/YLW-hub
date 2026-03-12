-- XuanAnhdpgai - BLOX FRUITS EDITION
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- --- GUI SETUP ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "XuanAnhdpgai_Hub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 440)
Main.Position = UDim2.new(0.5, -130, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
local MainCorner = Instance.new("UICorner", Main)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.ZIndex = 5
Instance.new("UICorner", MinBtn)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XuanAnhdpgai"
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -55)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 600)
Container.ScrollBarThickness = 3
Container.ZIndex = 2

local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Minimize Logic
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Container.Visible = not isMinimized
    Main:TweenSize(isMinimized and UDim2.new(0, 260, 0, 40) or UDim2.new(0, 260, 0, 440), "Out", "Quad", 0.3, true)
    MinBtn.Text = isMinimized and "+" or "-"
end)

-- --- SETTINGS ---
local _G = {
    Speed = 16,
    Jump = 50,
    FlySpeed = 100,
    HitboxSize = 2,
    FastAttack = false,
    ESP = false,
    Flying = false
}

-- --- UI CREATOR ---
local function CreateToggle(text, callback)
    local on = false
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(0.95, 0, 0, 35)
    Btn.Text = text .. " : OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.ZIndex = 3
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = text .. (on and " : ON" or " : OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(255, 100, 150) or Color3.fromRGB(30, 30, 35)
        callback(on)
    end)
end

local function CreateSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame", Container)
    Frame.Size = UDim2.new(0.95, 0, 0, 50)
    Frame.BackgroundTransparency = 1
    
    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, 0, 0, 20)
    Text.Text = name .. ": " .. default
    Text.TextColor3 = Color3.new(1,1,1)
    Text.BackgroundTransparency = 1
    
    local Bar = Instance.new("Frame", Frame)
    Bar.Size = UDim2.new(0.9, 0, 0, 5)
    Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
    Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 100, 150)

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    local val = math.floor(min + (max-min)*pos)
                    Text.Text = name .. ": " .. val
                    callback(val)
                end
            end)
            UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then move:Disconnect() end end)
        end
    end)
end

-- --- FEATURES ---
CreateToggle("Auto Fast Attack", function(v) _G.FastAttack = v end)
CreateToggle("Player ESP", function(v) _G.ESP = v end)
CreateToggle("Fly + Noclip", function(v) 
    _G.Flying = v 
    if v then
        local bv = Instance.new("BodyVelocity", player.Character.HumanoidRootPart)
        bv.Name = "XA_Fly"
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

CreateSlider("Walk Speed", 16, 500, 16, function(v) _G.Speed = v end)
CreateSlider("Jump Height", 50, 500, 50, function(v) _G.Jump = v end)
CreateSlider("Hitbox Scale", 2, 100, 2, function(v) _G.HitboxSize = v end)
CreateSlider("Fly Velocity", 50, 500, 100, function(v) _G.FlySpeed = v end)

-- --- CORE LOOPS ---
RunService.RenderStepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if _G.Speed > 16 and player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (player.Character.Humanoid.MoveDirection * (_G.Speed / 100))
            end
            player.Character.Humanoid.JumpPower = _G.Jump
            player.Character.Humanoid.UseJumpPower = true
        end
    end)
end)

local CombatFramework = require(player.PlayerScripts:WaitForChild("CombatFramework"))
task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local cd = debug.getupvalues(CombatFramework.activeController.attack)[15]
                if cd then
                    cd.activeController.hitboxMagnitude = 68
                    cd.activeController:attack()
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                local h = v.Character:FindFirstChild("XA_ESP")
                if _G.ESP then
                    if not h then
                        h = Instance.new("Highlight", v.Character)
                        h.Name = "XA_ESP"
                        h.FillColor = Color3.fromRGB(255, 100, 150)
                    end
                elseif h then h:Destroy() end
                
                if _G.HitboxSize > 2 and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                    v.Character.HumanoidRootPart.Transparency = 0.8
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "XuanAnhdpgai",
    Text = "Script Loaded Successfully!",
    Duration = 5
})

