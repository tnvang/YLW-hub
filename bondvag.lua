-- ====================================================================
-- SCRIPT NAME: bondvag (Bản Bypass Anti-Cheat Giật Vị Trí)
-- ====================================================================

_G.bondvag_Active = true 

_G.bondvag_Config = {
    AutoTeleOnStart = true,  -- Tự động lướt tới Bond khi bắt đầu
    MaxDistance = 100,       -- Giới hạn khoảng cách nhặt đồ
    TweenSpeed = 45          -- TỐC ĐỘ BAY (45-50 là an toàn, cao quá dễ bị quét)
}

local BOND_NAMES = {
    "bond", "phieu", "phiếu", "moi lien ket", "mối liên kết", 
    "lien ket", "liên kết", "phiếu liên kết", "phieu lien ket"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local function findBond(obj)
    if not obj then return false end
    local nameLower = string.lower(obj.Name)
    
    for _, keyword in pairs(BOND_NAMES) do
        if string.find(nameLower, keyword) then return true end
    end
    
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        local actText = string.lower(prompt.ActionText)
        local objText = string.lower(prompt.ObjectText)
        if string.find(actText, "thu") or string.find(actText, "nhặt") or string.find(actText, "nhat") or
           string.find(objText, "liên") or string.find(objText, "bond") then
            return true
        end
    end
    return false
end

-- ==========================================
-- HÀM LƯỚT BAY MƯỢT MÀ (BYPASS ANTI-CHEAT)
-- ==========================================
local function safeTweenTo(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    
    if hrp and humanoid then
        -- Tính khoảng cách để đưa ra thời gian bay hợp lý theo tốc độ cài sẵn
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / _G.bondvag_Config.TweenSpeed
        
        -- Tạo hiệu ứng lướt tuyến tính mượt mà
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        -- Chạy hiệu ứng bay và đợi bay tới nơi xong xuôi mới xử lý tiếp
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.2) -- Nghỉ một chút để hệ thống game cập nhật vị trí ổn định
    end
end

-- ==========================================
-- MENU BẬT/TẮT TRÊN MÀN HÌNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "bondvag_Gui"
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
ToggleButton.Text = "🟢 BONDVAG: ON"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    _G.bondvag_Active = not _G.bondvag_Active
    if _G.bondvag_Active then
        ToggleButton.Text = "🟢 BONDVAG: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        ToggleButton.Text = "🔴 BONDVAG: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("bondvag_Box") then obj["bondvag_Box"]:Destroy() end
            if obj:FindFirstChild("bondvag_Label") then obj["bondvag_Label"]:Destroy() end
        end
    end
end)

-- ==========================================
-- 1. CHỨC NĂNG ESP KHUNG TO & SỐ MÉT
-- ==========================================
local function createBigESP(object)
    if object:FindFirstChild("bondvag_Box") then 
        local billboard = object:FindFirstChild("bondvag_Label")
        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - object.Position).Magnitude)
            billboard.TextLabel.Text = "📜 [" .. object.Name .. "] - " .. dist .. "m"
        end
        return 
    end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "bondvag_Box"
    box.Size = object.Size + Vector3.new(1.6, 1.6, 1.6) 
    box.Color3 = Color3.fromRGB(255, 0, 0) 
    box.Transparency = 0.4 
    box.AlwaysOnTop = true 
    box.ZIndex = 10
    box.Adornee = object
    box.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "bondvag_Label"
    billboard.Size = UDim2.new(0, 200, 0, 50)
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
        task.wait(1)
        if _G.bondvag_Active then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                    createBigESP(obj)
                end
            end
        end
    end
end)

-- ==========================================
-- 2. TỰ ĐỘNG LƯỚT BAY ĐẾN (BYPASS LỖI GIẬT VỀ)
-- ==========================================
if _G.bondvag_Config.AutoTeleOnStart then
    task.spawn(function()
        local teleSuccess = false
        while not teleSuccess do
            task.wait(0.5)
            
            if _G.bondvag_Active then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                            -- Thay vì gán vị trí ngay lập tức, chuyển sang gọi hàm lướt mượt
                            safeTweenTo(obj.CFrame * CFrame.new(0, 2.5, 0))
                            teleSuccess = true 
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- 3. TỰ ĐỘNG GOM BOND TRONG PHẠM VI 100M
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.bondvag_Active then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local myPos = char.HumanoidRootPart.Position
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and findBond(obj) then
                        local distance = (myPos - obj.Position).Magnitude
                        
                        if distance <= _G.bondvag_Config.MaxDistance then
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            firetouchinterest(char.HumanoidRootPart, obj, 0)
                            task.wait(0.02)
                            firetouchinterest(char.HumanoidRootPart, obj, 1)
                        end
                    end
                end
            end
        end
    end
end)

