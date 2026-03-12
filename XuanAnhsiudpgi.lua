-- XuanAnhsiudpgi - ULTRA REACH & FAST ATTACK FIX
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VU = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- --- GUI SETUP ---
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 450)
Main.Position = UDim2.new(0.5, -130, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "XuanAnhsiudpgi"
Title.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Instance.new("UICorner", Title)

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, -10, 1, -55)
Container.Position = UDim2.new(0, 5, 0, 45)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 3, 0)
Container.ScrollBarThickness = 2
local UIList = Instance.new("UIListLayout", Container)
UIList.Padding = UDim.new(0, 8)

-- --- SETTINGS ---
local _G = {
    Speed = 16,
    Jump = 50,
    FlySpeed = 100,
    HitboxSize = 150, -- Nâng tầm đánh mặc định lên 150
    FastAttack = false,
    ESP = false,
    Flying = false,
    Aimlock = false
}

-- --- UI CREATOR ---
local function CreateToggle(text, callback)
    local on = false
    local Btn = Instance.new("TextButton", Container)
    Btn.Size = UDim2.new(0.95, 0, 0, 35)
    Btn.Text = text .. " : OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = text .. (on and " : ON" or " : OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 45)
        callback(on)
    end)
end

-- --- CORE FEATURES ---

-- 1. Fixed Fast Attack (Tự động đánh khi cầm vũ khí)
task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Kích hoạt click ảo để đánh
                    VU:CaptureController()
                    VU:ClickButton1(Vector2.new(850, 520))
                    
                    -- Tăng tầm quét hitbox cho vũ khí đang cầm
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(_G.HitboxSize, _G.HitboxSize, _G.HitboxSize)
                        tool.Handle.Transparency = 0.8
                        tool.Handle.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- 2. Movement & Noclip
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            if _G.Flying then
                for _, v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
            if _G.Speed > 16 and player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + (player.Character.Humanoid.MoveDirection * (_G.Speed / 100))
            end
        end
    end)
end)

-- 3. ESP Full Info (Tên + Khoảng cách)
local function UpdateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            local folder = v.Character:FindFirstChild("XA_ESP") or Instance.new("Folder", v.Character)
            folder.Name = "XA_ESP"

            if _G.ESP then
                local highlight = folder:FindFirstChild("Highlight") or Instance.new("Highlight", folder)
                highlight.FillColor = Color3.fromRGB(255, 105, 180)
                
                local bill = folder:FindFirstChild("Tag") or Instance.new("BillboardGui", folder)
                bill.Name = "Tag"
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.Adornee = hrp
                bill.AlwaysOnTop = true
                
                local label = bill:FindFirstChild("L") or Instance.new("TextLabel", bill)
                label.Name = "L"
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(1, 1, 1)
                label.Text = string.format("%s\n[%d m]", v.Name, math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude))
            else
                folder:ClearAllChildren()
            end
        end
    end
end

-- 4. Fly System
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

-- Các Toggles khác
CreateToggle("Auto Fast Attack (Reach 150)", function(v) _G.FastAttack = v end)
CreateToggle("Aimlock Player", function(v) _G.Aimlock = v end)
CreateToggle("Player ESP", function(v) _G.ESP = v end)

-- Vòng lặp quét ESP
task.spawn(function()
    while task.wait(0.5) do
        UpdateESP()
    end
end)

