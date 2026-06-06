-- ====================================================================
-- SCRIPT NAME: bondvip (Bản Chống Sót Tên + Khóa Di Chuyển Lướt)
-- ====================================================================

_G.bondvip_Active = true 

_G.bondvip_Config = {
    AutoTeleOnStart = true,  -- Tự động lướt tới Bond khi bắt đầu
    MaxDistance = 100,       -- Giới hạn khoảng cách nhặt đồ
    TweenSpeed = 40          -- Tốc độ lướt an toàn tránh anti-cheat
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- DANH SÁCH TỪ KHÓA QUÉT TOÀN DIỆN (Bao gồm cả item, trái phiếu, phiếu, bond,...)
local CO_THE_LA_TEN = {
    "bond", "phieu", "phiếu", "ket", "kết", "item", "trai", "trái", "lien", "liên"
}

-- Hàm quét gốc: Tìm chính xác vật phẩm dựa vào ảnh và từ khóa mở rộng
local function getBondObject(obj)
    if not obj then return nil end
    
    -- 1. Kiểm tra tên của chính vật phẩm đó trên sàn
    local nameLower = string.lower(obj.Name)
    for _, keyword in pairs(CO_THE_LA_TEN) do
        if string.find(nameLower, keyword) then
            if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                return obj
            end
        end
    end
    
    -- 2. Kiểm tra thông qua nút bấm hiển thị trên màn hình
    if obj:IsA("ProximityPrompt") then
        local objText = string.lower(obj.ObjectText)
        local actText = string.lower(obj.ActionText)
        
        for _, keyword in pairs(CO_THE_LA_TEN) do
            if string.find(objText, keyword) or string.find(actText, keyword) or string.find(objText, "mối") or string.find(actText, "thu") then
                if obj.Parent and (obj.Parent:IsA("BasePart") or obj.Parent:IsA("MeshPart")) then
                    return obj.Parent
                end
            end
        end
    end
    
    return nil
end

-- Hàm lướt mượt mà tránh bị giật về chỗ cũ
local function safeTweenTo(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / _G.bondvip_Config.TweenSpeed
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.2)
    end
end

-- ==========================================
-- MENU BẬT/TẮT TRÊN MÀN HÌNH (THƯƠNG HIỆU: BONDVIP)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "bondvip_Gui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 140, 0, 45)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Text = "🟢 BONDVIP: ON"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    _G.bondvip_Active = not _G.bondvip_Active
    if _G.bondvip_Active then
        ToggleButton.Text = "🟢 BONDVIP: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        ToggleButton.Text = "🔴 BONDVIP: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("bondvip_Box") then obj["bondvip_Box"]:Destroy() end
            if obj:FindFirstChild("bondvip_Label") then obj["bondvip_Label"]:Destroy() end
        end
    end
end)

-- ==========================================
-- 1. CHỨC NĂNG ESP KHUNG 3D TO RỰC RỠ + HIỆN TÊN
-- ==========================================
local function createBigESP(object)
    if object:FindFirstChild("bondvip_Box") then 
        local billboard = object:FindFirstChild("bondvip_Label")
        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - object.Position).Magnitude)
            billboard.TextLabel.Text = "📜 [" .. object.Name .. "] - " .. dist .. "m"
        end
        return 
    end
    
    -- Tạo khung hộp 3D to nổi bật màu đỏ xuyên tường
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "bondvip_Box"
    box.Size = object.Size + Vector3.new(1.8, 1.8, 1.8) 
    box.Color3 = Color3.fromRGB(255, 0, 0) 
    box.Transparency = 0.4 
    box.AlwaysOnTop = true 
    box.ZIndex = 10
    box.Adornee = object
    box.Parent = object

    -- Nhãn chữ lớn hiển thị tên hệ thống thực tế của vật phẩm
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "bondvip_Label"
    billboard.Size = UDim2.new(0, 220, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0) 
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) 
    label.TextStrokeTransparency = 0
    label.TextSize = 18 
    label.Font = Enum.Font.SourceSansBold 
    label.Text = "📜 [" .. object.Name .. "]"
    label.Parent = billboard
    
    billboard.Parent = object
end

task.spawn(function()
    while true do
        task.wait(0.8)
        if _G.bondvip_Active then
            for _, v in pairs(Workspace:GetDescendants()) do
                local target = getBondObject(v)
                if target then
                    createBigESP(target)
                end
            end
        end
    end
end)

-- ==========================================
-- 2. TỰ ĐỘNG LƯỚT BAY ĐẾN KHI VÀO GAME
-- ==========================================
if _G.bondvip_Config.AutoTeleOnStart then
    task.spawn(function()
        local teleSuccess = false
        while not teleSuccess do
            task.wait(1)
            if _G.bondvip_Active then
                for _, v in pairs(Workspace:GetDescendants()) do
                    local target = getBondObject(v)
                    if target then
                        safeTweenTo(target.CFrame * CFrame.new(0, 2.5, 0))
                        teleSuccess = true 
                        break
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- 3. TỰ ĐỘNG GOM TRONG PHẠM VI 100M
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.bondvip_Active then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for _, v in pairs(Workspace:GetDescendants()) do
                    local target = getBondObject(v)
                    if target then
                        local distance = (hrp.Position - target.Position).Magnitude
                        if distance <= _G.bondvip_Config.MaxDistance then
                            -- Nhặt bằng nút bấm ProximityPrompt
                            local prompt = target:FindFirstChildOfClass("ProximityPrompt") or target.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            -- Nhặt bằng chạm dẫm chân Touch
                            firetouchinterest(hrp, target, 0)
                            task.wait(0.02)
                            firetouchinterest(hrp, target, 1)
                        end
                    end
                end
            end
        end
    end
end)

