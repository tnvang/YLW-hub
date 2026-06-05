local Player = game.Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
ScreenGui.Name = "Ngvag_Main"
ScreenGui.ResetOnSpawn = false

-------------------------------------------------------------------------------
-- LOADING FRAME
-------------------------------------------------------------------------------
local LoadFrame = Instance.new("Frame", ScreenGui)
LoadFrame.Size = UDim2.new(0, 220, 0, 60)
LoadFrame.Position = UDim2.new(0.5, -110, 0.4, 0)
LoadFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 25)
LoadFrame.BorderSizePixel = 2
LoadFrame.BorderColor3 = Color3.fromRGB(255, 0, 127)

local LoadText = Instance.new("TextLabel", LoadFrame)
LoadText.Size = UDim2.new(1, 0, 1, 0)
LoadText.Text = "Ngvag: Scanning..."
LoadText.TextColor3 = Color3.fromRGB(255, 105, 180)
LoadText.Font = Enum.Font.SourceSansBold
LoadText.BackgroundTransparency = 1

task.spawn(function()
    for i = 1, 4 do
        LoadText.Text = "Ngvag: " .. (i*25) .. "%"
        task.wait(1)
    end
    LoadFrame:Destroy()
end)
task.wait(4)

-------------------------------------------------------------------------------
-- MAIN INTERFACE
-------------------------------------------------------------------------------
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 127)
MainFrame.Active = true
MainFrame.Draggable = true

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 5)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 20, 100)

local OpenCircle = Instance.new("TextButton", ScreenGui)
OpenCircle.Size = UDim2.new(0, 50, 0, 50)
OpenCircle.Position = UDim2.new(0, 20, 0.5, -25)
OpenCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
OpenCircle.Text = "NGVAG"
OpenCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCircle.Visible = false
OpenCircle.Active = true
OpenCircle.Draggable = true
Instance.new("UICorner", OpenCircle).CornerRadius = UDim.new(1, 0)

local ESP_Tab = Instance.new("Frame", MainFrame)
ESP_Tab.Size = UDim2.new(0.5, -5, 1, -40)
ESP_Tab.Position = UDim2.new(0, 0, 0, 40)
ESP_Tab.BackgroundTransparency = 1

local Support_Tab = Instance.new("Frame", MainFrame)
Support_Tab.Size = UDim2.new(0.5, -5, 1, -40)
Support_Tab.Position = UDim2.new(0.5, 5, 0, 40)
Support_Tab.BackgroundTransparency = 1

local Esptxt = Instance.new("TextLabel", MainFrame)
Esptxt.Size = UDim2.new(0.5, 0, 0, 30)
Esptxt.Text = "ESP SYSTEM"
Esptxt.TextColor3 = Color3.fromRGB(0, 255, 255)
Esptxt.BackgroundTransparency = 1

local Suptxt = Instance.new("TextLabel", MainFrame)
Suptxt.Size = UDim2.new(0.5, 0, 0, 30)
Suptxt.Position = UDim2.new(0.5, 0, 0, 0)
Suptxt.Text = "HỖ TRỢ"
Suptxt.TextColor3 = Color3.fromRGB(255, 105, 180)
Suptxt.BackgroundTransparency = 1

-------------------------------------------------------------------------------
-- MANAGEMENT VARIABLES & CONNECTIONS
-------------------------------------------------------------------------------
local E_Quai, E_Sung, E_Vat, AimBot, Noclip = false, false, false, false, false
local NoclipConnection = nil

-- Danh sách bộ lọc từ khóa của ESP Vật phẩm
local TargetItems = {
    ["than"] = true, ["giáp"] = true, ["giap"] = true, ["băng"] = true, ["bang"] = true,
    ["dầu rắn"] = true, ["dau ran"] = true, ["tấm thép"] = true, ["tam thep"] = true,
    ["vàng"] = true, ["vang"] = true, ["bạc"] = true, ["bac"] = true, ["đạn"] = true, ["dan"] = true,
    ["bond"] = true, ["phiếu"] = true, ["phieu"] = true, ["trái"] = true, ["trai"] = true, ["cross"] = true
}

-------------------------------------------------------------------------------
-- TOGGLE CREATOR FACTORY
-------------------------------------------------------------------------------
local function createToggle(name, parent, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = name .. " [+] OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50, 15, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local isOn = false
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        btn.Text = name .. (isOn and " [-] ON" or " [+] OFF")
        btn.BackgroundColor3 = isOn and Color3.fromRGB(200, 0, 120) or Color3.fromRGB(50, 15, 50)
        callback(isOn)
    end)
    return btn
end

-------------------------------------------------------------------------------
-- ESP BOX LOGIC
-------------------------------------------------------------------------------
local function CreateBox(obj, color)
    if obj:FindFirstChild("NgvagBox") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "NgvagBox"
    box.Size = obj:IsA("Model") and (obj:GetExtentsSize() + Vector3.new(0.1,0.1,0.1)) or (obj.Size + Vector3.new(0.1,0.1,0.1))
    box.Color3 = color
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Adornee = obj
    box.Transparency = 0.6
    box.Parent = obj
end

RunService.RenderStepped:Connect(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local objPos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
                if (root.Position - objPos).Magnitude <= 700 then
                    local name = string.lower(obj.Name)
                    
                    if E_Quai and (string.find(name, "zombie") or string.find(name, "monster") or (obj:FindFirstChild("Humanoid") and obj ~= Player.Character and not game.Players:GetPlayerFromCharacter(obj))) then
                        CreateBox(obj, Color3.fromRGB(135, 206, 250))
                    elseif E_Sung and (string.find(name, "gun") or string.find(name, "rifle") or string.find(name, "pistol")) then
                        CreateBox(obj, Color3.fromRGB(255, 255, 153))
                    elseif E_Vat and TargetItems[name] then
                        CreateBox(obj, Color3.fromRGB(255, 178, 102))
                    else
                        if obj:FindFirstChild("NgvagBox") then obj.NgvagBox:Destroy() end
                    end
                else
                    if obj:FindFirstChild("NgvagBox") then obj.NgvagBox:Destroy() end
                end
            end
        end
    end
end)

-------------------------------------------------------------------------------
-- CORE SUPPORT CORE RUNNER (NOCLIP & AIMBOT)
-------------------------------------------------------------------------------
local function SetNoclipState(state)
    Noclip = state
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    if Noclip then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if AimBot then
        local closestQuai = nil
        local shortestDist = 700
        for _, v in pairs(Workspace:GetDescendants()) do
            -- [ĐÃ FIX]: Không Aim vào chính mình, và KHÔNG Aim vào người chơi khác (chỉ Aim quái/NPC)
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= Player.Character and not game.Players:GetPlayerFromCharacter(v) then
                local head = v:FindFirstChild("Head") or v:FindFirstChildWhichIsA("BasePart")
                local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if head and root then
                    local dist = (root.Position - head.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestQuai = head
                    end
                end
            end
        end
        if closestQuai then Camera.CFrame = CFrame.new(Camera.CFrame.p, closestQuai.Position) end
    end
end)

-------------------------------------------------------------------------------
-- INITIALIZE BUTTON TOGGLES
-------------------------------------------------------------------------------
createToggle("ESP Quái", ESP_Tab, 10, function(v) E_Quai = v end)
createToggle("ESP Vũ Khí", ESP_Tab, 55, function(v) E_Sung = v end)
createToggle("ESP Vật Phẩm", ESP_Tab, 100, function(v) E_Vat = v end)
createToggle("Fullbright", Support_Tab, 10, function(v) game.Lighting.Brightness = v and 5 or 2 end)
createToggle("Aim Đầu", Support_Tab, 55, function(v) AimBot = v end)
createToggle("Noclip", Support_Tab, 100, function(v) SetNoclipState(v) end)

-------------------------------------------------------------------------------
-- SYSTEM PANELS & RESET ALL ACTIONS
-------------------------------------------------------------------------------
local ResetBtn = Instance.new("TextButton", MainFrame)
ResetBtn.Size = UDim2.new(1, -20, 0, 35)
ResetBtn.Position = UDim2.new(0, 10, 1, -45)
ResetBtn.Text = "RESET ALL NGVAG"
ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 50)
ResetBtn.TextColor3 = Color3.fromRGB(255, 105, 180)

ResetBtn.MouseButton1Click:Connect(function()
    E_Quai, E_Sung, E_Vat, AimBot = false, false, false, false
    SetNoclipState(false)
    game.Lighting.Brightness = 2
    
    for _, folder in pairs({ESP_Tab, Support_Tab}) do
        for _, btn in pairs(folder:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(50, 15, 50)
                btn.Text = string.gsub(btn.Text, "%s*[-]*%s*ON", " [+] OFF")
            end
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do 
        if obj:FindFirstChild("NgvagBox") then 
            obj.NgvagBox:Destroy() 
        end 
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenCircle.Visible = true end)
OpenCircle.MouseButton1Click:Connect(function() OpenCircle.Visible = false; MainFrame.Visible = true end)

