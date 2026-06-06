-- ====================================================================
-- SCRIPT NAME: vagprebn (Bản Mix Lõi Nvang + Menu Auto Bond 1Km)
-- ====================================================================

_G.vagprebn_Active = true 

_G.vagprebn_Config = {
    AutoTeleOnStart = true,  -- Tự động lướt tới Bond khi bắt đầu game
    MaxDistance = 1000,      -- Bán kính quét và gom đồ: 1Km (1000 studs)
    TweenSpeed = 38          -- Tốc độ lướt an toàn tránh bị game kéo về vị trí cũ
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Sử dụng chính xác danh sách từ khóa hoạt động tốt từ lõi Nvang của bạn
local TargetItems = {
    "bond", "phieu", "phiếu", "trai", "trái", "item", "lien", "liên"
}

-- Hàm kiểm tra vật phẩm chuẩn theo lõi Nvang
local function CheckItemESP(obj)
    if not obj or not (obj:IsA("BasePart") or obj:IsA("MeshPart")) then return false end
    local nameLower = string.lower(obj.Name)
    
    for _, keyword in pairs(TargetItems) do
        if string.find(nameLower, keyword) then 
            return true 
        end
    end
    return false
end

-- Hàm lướt mượt mà bypass anti-cheat giật vị trí cũ
local function safeTweenTo(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local duration = distance / _G.vagprebn_Config.TweenSpeed
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.3)
    end
end

-- ==========================================
-- MENU BẬT/TẮT TRÊN MÀN HÌNH (THƯƠNG HIỆU: VAGPREBN)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "vagprebn_Gui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 160, 0, 45) -- Tăng nhẹ chiều rộng để chữ hiển thị đẹp hơn
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Text = "🟢 Auto bond: ON"

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    _G.vagprebn_Active = not _G.vagprebn_Active
    if _G.vagprebn_Active then
        ToggleButton.Text = "🟢 Auto bond: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    else
        ToggleButton.Text = "🔴 Auto bond: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("vagprebn_Box") then obj["vagrebn_Box"]:Destroy() end
            if obj:FindFirstChild("vagprebn_Label") then obj["vagprebn_Label"]:Destroy() end
        end
    end
end)

-- ==========================================
-- 1. CHỨC NĂNG ESP KHUNG 3D TO RỰC RỠ ĐÃ FIX LỖI
-- ==========================================
local function createBigESP(object)
    -- Nếu có khung rồi thì chỉ cập nhật số mét hiển thị từ xa
    if object:FindFirstChild("vagprebn_Box") then 
        local billboard = object:FindFirstChild("vagprebn_Label")
        if billboard and billboard:FindFirstChild("TextLabel") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - object.Position).Magnitude)
            billboard.TextLabel.Text = "📜 " .. object.Name .. " [" .. dist .. "m]"
        end
        return 
    end
    
    -- Tạo khung hộp 3D to nổi bật (Sử dụng màu hồng rực rỡ đặc trưng từ mã Nvang cũ của bạn)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "vagprebn_Box"
    box.Size = object.Size + Vector3.new(1.8, 1.8, 1.8) 
    box.Color3 = Color3.fromRGB(255, 0, 127) 
    box.Transparency = 0.4 
    box.AlwaysOnTop = true 
    box.ZIndex = 10
    box.Adornee = object
    box.Parent = object

    -- Nhãn chữ hiển thị tên thực tế của file để bạn tiện theo dõi mục tiêu
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "vagprebn_Label"
    billboard.Size = UDim2.new(0, 180, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0) 
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 255) -- Chữ xanh dạ quang dễ nhìn xuyên tường
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) 
    label.TextStrokeTransparency = 0
    label.TextSize = 15 
    label.Font = Enum.Font.SourceSansBold 
    label.Text = object.Name
    label.Parent = billboard
    
    billboard.Parent = object
end

-- Vòng lặp quét RenderStepped tối ưu khoảng cách 1km
task.spawn(function()
    while true do
        task.wait(0.8)
        if _G.vagprebn_Active then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if CheckItemESP(obj) then
                        local distance = (root.Position - obj.Position).Magnitude
                        if distance <= _G.vagprebn_Config.MaxDistance then
                            createBigESP(obj)
                        else
                            if obj:FindFirstChild("vagprebn_Box") then obj.vagprebn_Box:Destroy() end
                            if obj:FindFirstChild("vagprebn_Label") then obj.vagprebn_Label:Destroy() end
                        end
                    end
                end
            end
        end
    end
end)

-- ==========================================
-- 2. TỰ ĐỘNG LƯỚT BAY ĐẾN KHI VÀO GAME
-- ==========================================
if _G.vagprebn_Config.AutoTeleOnStart then
    task.spawn(function()
        local teleSuccess = false
        while not teleSuccess do
            task.wait(1.5)
            if _G.vagprebn_Active then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if CheckItemESP(obj) then
                            safeTweenTo(obj.CFrame * CFrame.new(0, 3, 0))
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
-- 3. TỰ ĐỘNG GOM TRONG BÁN KÍNH 1KM
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.vagprebn_Active then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if CheckItemESP(obj) then
                        local distance = (hrp.Position - obj.Position).Magnitude
                        if distance <= _G.vagprebn_Config.MaxDistance then
                            -- 1. Kích hoạt nút bấm nhặt đồ ProximityPrompt ẩn từ xa
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                            -- 2. Giả lập dẫm chạm chân Touch nhặt đồ từ xa
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

