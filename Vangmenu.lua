local Player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera

-- 1. GUI LOADING (Vàng Menu)
local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "VangMenu_Loading"
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(0, 200, 0, 60)
LoadFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadFrame.BorderSizePixel = 2
LoadFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.Text = "Vàng Menu: Loading..."
LoadText.TextColor3 = Color3.fromRGB(255, 215, 0)
LoadText.BackgroundTransparency = 1

task.spawn(function()
    for i = 1, 4 do
        LoadText.Text = "Vàng Menu: Scanning " .. (i*25) .. "%"
        task.wait(1)
    end
    LoadFrame:Destroy()
end)
task.wait(4)

-- 2. MENU CHÍNH
local MenuGui = Instance.new("ScreenGui", Player.PlayerGui)
MenuGui.Name = "VangMenu_Main"
local MainFrame = Instance.new("Frame", MenuGui)
MainFrame.Size = UDim2.new(0, 200, 0, 360)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Vàng Menu Pro"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createToggle(name, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, #parent:GetChildren() * 40 - 5)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = name .. ": " .. (isOn and "ON" or "OFF")
        btn.BackgroundColor3 = isOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        callback(isOn)
    end)
    return btn
end

local ESP_Quai, ESP_Sung, ESP_VatPham, AimBot, Noclip = false, false, false, false, false

-- Logic ESP (700m)
RunService.RenderStepped:Connect(function()
    if not (ESP_Quai or ESP_Sung or ESP_VatPham) then return end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and Player:DistanceFromCharacter(obj:GetPivot().Position) <= 700 then
            local highlight = obj:FindFirstChild("VangHighlight") or Instance.new("Highlight", obj)
            highlight.Name = "VangHighlight"
            local show = false
            if ESP_Quai and (string.find(string.lower(obj.Name), "zombie") or string.find(string.lower(obj.Name), "monster")) then
                highlight.FillColor = Color3.fromRGB(135, 206, 235); show = true
            elseif ESP_Sung and (string.find(string.lower(obj.Name), "gun") or string.find(string.lower(obj.Name), "rifle")) then
                highlight.FillColor = Color3.fromRGB(255, 255, 102); show = true
            elseif ESP_VatPham and (string.find(string.lower(obj.Name), "bond") or string.find(string.lower(obj.Name), "cross")) then
                highlight.FillColor = Color3.fromRGB(255, 165, 0); show = true
            end
            highlight.Enabled = show
        end
    end
end)

-- Aim & Noclip
RunService.RenderStepped:Connect(function()
    if AimBot then
        local closest = nil; local dist = 700
        for _, v in pairs(Workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and string.find(string.lower(v.Name), "zombie") then
                local d = (v.Head.Position - Camera.CFrame.p).Magnitude
                if d < dist then dist = d; closest = v end
            end
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.p, closest.Head.Position) end
    end
    if Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Buttons
createToggle("ESP Quai", MainFrame, function(v) ESP_Quai = v end)
createToggle("ESP Sung", MainFrame, function(v) ESP_Sung = v end)
createToggle("ESP VatPham", MainFrame, function(v) ESP_VatPham = v end)
createToggle("Fullbright", MainFrame, function(v) game.Lighting.Brightness = v and 5 or 2 end)
createToggle("Aim Quai", MainFrame, function(v) AimBot = v end)
createToggle("Noclip", MainFrame, function(v) Noclip = v end)

local ResetBtn = Instance.new("TextButton", MainFrame)
ResetBtn.Size = UDim2.new(1, -10, 0, 35); ResetBtn.Position = UDim2.new(0, 5, 0, 280)
ResetBtn.Text = "RESET ALL"; ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ResetBtn.MouseButton1Click:Connect(function()
    ESP_Quai = false; ESP_Sung = false; ESP_VatPham = false; AimBot = false; Noclip = false
    game.Lighting.Brightness = 2
    for _, btn in pairs(MainFrame:GetChildren()) do 
        if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); btn.Text = string.gsub(btn.Text, "ON", "OFF") end 
    end
end)
