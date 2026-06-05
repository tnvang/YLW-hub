local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "vanganhsang" -- Tên GUI
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Active = true

-- Kéo thả
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

-- UI
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0, 160, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "VANGANHSANG" -- Tên hiển thị
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 25)
MinBtn.Position = UDim2.new(1, -35, 0, 3)
MinBtn.Text = "_"
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1, 0, 1, -35)
Container.Position = UDim2.new(0, 0, 0, 35)
Container.BackgroundTransparency = 1

local FB_Btn = Instance.new("TextButton", Container)
FB_Btn.Size = UDim2.new(0, 200, 0, 40)
FB_Btn.Position = UDim2.new(0, 10, 0, 5)
FB_Btn.Text = "FULLBRIGHT: OFF"
FB_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

local Aim_Btn = Instance.new("TextButton", Container)
Aim_Btn.Size = UDim2.new(0, 200, 0, 40)
Aim_Btn.Position = UDim2.new(0, 10, 0, 55)
Aim_Btn.Text = "AIMBOT: OFF"
Aim_Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

-- Logic
local fbEnabled, aimEnabled, isMinimized = false, false, false

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Container.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 220, 0, 35) or UDim2.new(0, 220, 0, 160)
    MinBtn.Text = isMinimized and "+" or "_"
end)

FB_Btn.MouseButton1Click:Connect(function()
    fbEnabled = not fbEnabled
    FB_Btn.Text = fbEnabled and "FULLBRIGHT: ON" or "FULLBRIGHT: OFF"
    FB_Btn.BackgroundColor3 = fbEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

Aim_Btn.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    Aim_Btn.Text = aimEnabled and "AIMBOT: ON" or "AIMBOT: OFF"
    Aim_Btn.BackgroundColor3 = aimEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.RenderStepped:Connect(function()
    if fbEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end
    
    if aimEnabled then
        local closestTarget = nil
        local shortestDist = math.huge
        local myChar = Player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local myPos = myChar.HumanoidRootPart.Position
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") 
                   and obj.Name ~= Player.Name and obj.Humanoid.Health > 0 
                   and not Players:GetPlayerFromCharacter(obj) then
                    
                    local dist = (obj.Head.Position - myPos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = obj.Head
                    end
                end
            end
            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end
    end
end)

