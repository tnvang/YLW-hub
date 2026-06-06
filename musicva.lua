-- ====================================================================
-- SCRIPT NAME: musicva (Bản Sửa Lỗi Định Hướng + Lướt Thần Tốc 1Km)
-- ====================================================================

_G.musicva_Active = true 

_G.musicva_Config = {
    AutoTeleOnStart = true,  -- Tự động bay thẳng đến Bond ngay khi phát hiện
    MaxDistance = 1000,      -- Phạm vi gom đồ: 1Km (1000 studs)
    TeleportSpeed = 85       -- Tốc độ di chuyển phân đoạn an toàn và cực nhanh
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- BỘ LỌC KHÓA CHẾT MỤC TIÊU: Tập trung vào Bond/Phiếu, loại bỏ các mục tiêu loãng
local TargetKeywords = {"bond", "phieu", "phiếu", "trai", "trái"}

local function CheckItemESP(obj)
    if not obj or not (obj:IsA("BasePart") or obj:IsA("MeshPart")) then return false end
    
    -- Tránh vẽ nhầm vào các bộ phận nhân vật của người chơi khác
    if obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
        return false
    end
    
    local nameLower = string.lower(obj.Name)
    for _, keyword in pairs(TargetKeywords) do
        if string.find(nameLower, keyword) then 
            return true 
        end
    end
    return false
end

-- KỸ THUẬT LƯỚT PHÂN ĐOẠN SIÊU TỐC: Di chuyển mượt mà bypass anti-cheat kéo lại
local function fastTeleportTo(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local speed = _G.musicva_Config.TeleportSpeed
    local startPos = hrp.Position
    local endPos = targetCFrame.Position + Vector3.new(0, 3, 0) -- Đứng cao hơn vật phẩm 3 mét để nhặt an toàn
    local distance = (endPos - startPos).Magnitude
    
    local steps = math.floor(distance / (speed * 0.1))
    for i = 1, steps do
        if not _G.musicva_Active then break end
        hrp.CFrame = CFrame.new(startPos:Lerp(endPos, i / steps))
        task.wait(0.05) -- Giãn cách ngắn tối ưu tốc độ
    end
    if _G.musicva_Active then
        hrp.CFrame = CFrame.new(endPos)
    end
end

-- ==========================================
-- MENU BẬT/TẮT TRÊN MÀN HÌNH (THƯƠNG HIỆU: MUSICVA)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "musicva_Gui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 160, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.25, 0) -- Căn lề trái giống giao diện của bạn
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 15
ToggleButton.Text = "🔴 Auto bond: ON"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    _G.musicva_Active = not _G.musicva_Active
    if _G.musicva_Active then
        ToggleButton.Text = "🔴 Auto bond: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        ToggleButton.Text = "⚪ Auto bond: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        -- Dọn sạch hoàn toàn các khung khi tắt menu
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("musicva_Box") then obj["musicva_Box"]:Destroy() end
            if obj:FindFirstChild("musicva_Label") then obj["musicva_Label"]:Destroy() end
        end
    end
end)

-- ==========================================
-- 1. CHỨC NĂNG ESP KHUNG 3D MÀU HỒNG RỰC RỠ
-- ==========================================
local function createBigESP(object)
    if object:FindFirstChild("musicva_Box") then 
        local billboard = object:FindFirstChild("musicva_Label")
        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - object.Position).Magnitude)
            billboard.TextLabel.Text = "📜 " .. object.Name .. " [" .. dist .. "m]"
        end
        return 
    end
    
    -- Tạo hộp hồng phủ xung quanh vật phẩm chuẩn xác 100% giống NVANG cũ
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "musicva_Box"
    box.Size = object.Size + Vector3.new(0.5, 0.5, 0.5) 
    box.Color3 = Color3.fromRGB(255, 0, 127) 
    box.Transparency = 0.4 
    box.AlwaysOnTop = true 
    box.ZIndex = 10
    box.Adornee = object
    box.Parent = object

    -- Nhãn hiển thị khoảng cách động thực tế từ xa
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "musicva_Label"
    billboard.Size = UDim2.new(0, 180, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0) 
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 255) 
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) 
    label.TextStrokeTransparency = 0
    label.TextSize = 14 
    label.Font = Enum.Font.SourceSansBold 
    label.Text = object.Name
    label.Parent = billboard
    
    billboard.Parent = object
end

task.spawn(function()
    while true do
        task.wait(0.6)
        if _G.musicva_Active then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if CheckItemESP(obj) then
                        local distance = (root.Position - obj.Position).Magnitude
                        if distance <= _G.musicva_Config.MaxDistance then
                            createBigESP(obj)
                        else
                            if obj:FindFirstChild("musicva_Box") then obj.musicva_Box:Destroy() end
                            if obj:FindFirstChild("musicva_Label") then obj.musicva_Label:Destroy() end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- 2. TỰ ĐỘNG LƯỚT PHÂN ĐOẠN ĐẾN MỤC TIÊU
-- ==========================================
if _G.musicva_Config.AutoTeleOnStart then
    task.spawn(function()
        while true do
            task.wait(1.5)
            if _G.musicva_Active then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if CheckItemESP(obj) then
                            fastTeleportTo(obj.CFrame)
                            task.wait(1.8) -- Đợi nhận vật phẩm xong mới tiếp tục quét
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- 3. TỰ ĐỘNG KÍCH HOẠT NHẶT ĐỒ TỪ XA
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.3) -- Tiến độ kích hoạt liên tục cực nhanh
        if _G.musicva_Active then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if CheckItemESP(obj) then
                        local distance = (hrp.Position - obj.Position).Magnitude
                        if distance <= _G.musicva_Config.MaxDistance then
                            -- 1. Giả lập bấm nút tương tác "Thu thập" (ProximityPrompt)
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            -- 2. Giả lập dẫm chân lên vật thể rơi (Touch)
                            firetouchinterest(hrp, obj, 0)
                            task.wait(0.01)
                            firetouchinterest(hrp, obj, 1)
                        end
                    end
                end
            end
        end
    end
end)

