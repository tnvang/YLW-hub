local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

_G.Settings = {
    Fly = false,
    FlySpeed = 120,
    KillAura = false,
    AuraDist = 20,
    Aim = false,
    Smoothness = 0.2,
    Hitbox = false,
    HitboxSize = 10
}

-- GUI CORE
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Royhaylov2_Gui"

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 720, 0, 170)
Main.Position = UDim2.new(0.5, -360, 0.5, -85)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "  ROYHAYLOV2 | VIP MENU"
Title.BackgroundColor3 = Color3.fromRGB(80, 120, 255) -- Đổi màu xanh cho mới mẻ
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title)

local MinBtn = Instance.new("TextButton", Title)
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -37, 0, 4)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1

local Grid = Instance.new("UIGridLayout", Container)
Grid.CellSize = UDim2.new(0, 170, 0, 100)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)

-- Feature Creator (Hỗ trợ nhập số 1-900)
function CreateFeature(name, defaultVal, callback, toggleCallback)
    local Box = Instance.new("Frame", Container)
    Box.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Instance.new("UICorner", Box)

    local Btn = Instance.new("TextButton", Box)
    Btn.Size = UDim2.new(1, 0, 0.6, 0)
    Btn.Text = name .. "\n[OFF]"
    Btn.BackgroundTransparency = 1
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.TextSize = 15

    local Input = Instance.new("TextBox", Box)
    Input.Size = UDim2.new(1, -10, 0.35, 0)
    Input.Position = UDim2.new(0, 5, 0.6, 0)
    Input.Text = tostring(defaultVal)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Input.TextColor3 = Color3.fromRGB(0, 255, 150)
    Instance.new("UICorner", Input)

    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = name .. "\n[" .. (on and "ON" or "OFF") .. "]"
        Btn.TextColor3 = on and Color3.fromRGB(80, 120, 255) or Color3.new(1, 1, 1)
        toggleCallback(on)
    end)

    Input.FocusLost:Connect(function()
        local val = tonumber(Input.Text)
        if val then
            val = math.clamp(val, 1, 900)
            Input.Text = tostring(val)
            callback(val)
        else
            Input.Text = tostring(defaultVal)
        end
    end)
end

-- Đăng ký Feature
CreateFeature("FLY", 120, function(v) _G.Settings.FlySpeed = v end, function(v) _G.Settings.Fly = v end)
CreateFeature("AIM", 20, function(v) _G.Settings.Smoothness = v/100 end, function(v) _G.Settings.Aim = v end)
CreateFeature("AURA", 20, function(v) _G.Settings.AuraDist = v end, function(v) _G.Settings.KillAura = v end)
CreateFeature("HITBOX", 10, function(v) _G.Settings.HitboxSize = v end, function(v) _G.Settings.Hitbox = v end)

-- Minimize (Thu nhỏ thành Icon)
local open = true
MinBtn.MouseButton1Click:Connect(function()
    open = not open
    Container.Visible = open
    Main.Size = open and UDim2.new(0, 720, 0, 170) or UDim2.new(0, 45, 0, 45)
    Title.Text = open and "  ROYHAYLOV2 | VIP MENU" or ""
    MinBtn.Text = open and "-" or "+"
    MinBtn.Position = open and UDim2.new(1, -37, 0, 4) or UDim2.new(0, 6, 0, 6)
end)

-- AIMLOCK MƯỢT
RunService.RenderStepped:Connect(function()
    if _G.Settings.Aim then
        local target = nil
        local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                    if mDist < dist then
                        dist = mDist
                        target = v.Character.Head
                    end
                end
            end
        end
        if target then
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, target.Position), _G.Settings.Smoothness)
        end
    end
end)

-- FLY THEO HƯỚNG CAM
RunService.Stepped:Connect(function()
    if _G.Settings.Fly and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local hum = player.Character.Humanoid
        root.Velocity = (hum.MoveDirection.Magnitude > 0)
        and (camera.CFrame.LookVector * hum.MoveDirection.Z + camera.CFrame.RightVector * hum.MoveDirection.X).Unit * _G.Settings.FlySpeed
        or Vector3.new(0, 0.5, 0)
    end
end)

-- HITBOX (CÓ RESET KHI TẮT)
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = v.Character.HumanoidRootPart
            if _G.Settings.Hitbox then
                hrp.Size = Vector3.new(_G.Settings.HitboxSize, _G.Settings.HitboxSize, _G.Settings.HitboxSize)
                hrp.Transparency = 0.7
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1) -- Kích thước mặc định Roblox
                hrp.Transparency = 1
                hrp.CanCollide = true
            end
        end
    end
end)

-- KILL AURA (TARGET)
task.spawn(function()
    while task.wait(0.1) do
        if _G.Settings.KillAura and player.Character then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if d <= _G.Settings.AuraDist then
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                        break
                    end
                end
            end
        end
    end
end)

